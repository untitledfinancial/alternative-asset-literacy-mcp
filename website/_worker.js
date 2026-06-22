/**
 * Alternative Asset Literacy — Cloudflare Worker
 * ================================================
 * Handles:
 *   1. Static site — HTML pages, styles, scripts
 *   2. LLM/MCP discovery endpoints
 *   3. MCP server (/mcp) — 7 tools
 *   4. Chat agent (/chat) — Cloudflare AI (Llama 3.1)
 *   5. Contact form (/contact POST) — stored in Cloudflare D1
 *
 * D1 Bindings:
 *   DB  — aal-contact (contact form submissions)
 *
 * No external API dependencies.
 */

// ─── CORS ────────────────────────────────────────────────────────────────────

const ALLOWED_ORIGINS = [
  "https://alternativeassetliteracy.com",
  "https://www.alternativeassetliteracy.com",
  "https://morning-limit-8bb9.case-57e.workers.dev",
];

function getCorsHeaders(request) {
  const origin = request.headers.get("Origin") || "";
  const allowedOrigin = ALLOWED_ORIGINS.includes(origin) ? origin : ALLOWED_ORIGINS[0];
  return {
    "Access-Control-Allow-Origin": allowedOrigin,
    "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Vary": "Origin",
  };
}

function corsResponse(request, body, status = 200, contentType = "application/json") {
  return new Response(body, {
    status,
    headers: { "Content-Type": contentType, ...getCorsHeaders(request) },
  });
}

// ─── Rate Limiting (in-memory, per-isolate) ─────────────────────────────────

const RATE_LIMIT = new Map();
const RATE_WINDOW_MS = 60_000;
const RATE_MAX = 5;

function isRateLimited(ip) {
  const now = Date.now();
  const entry = RATE_LIMIT.get(ip);
  if (!entry || now > entry.resetAt) {
    RATE_LIMIT.set(ip, { count: 1, resetAt: now + RATE_WINDOW_MS });
    return false;
  }
  entry.count++;
  return entry.count > RATE_MAX;
}

// ─── Contact Form Handler — Cloudflare D1 ────────────────────────────────────

function getRoute(subject) {
  const routes = {
    "General Inquiry":         "general",
    "Privacy / Data Request":  "privacy",
    "Press":                   "press",
    "Partnership":             "partnerships",
    "Institutional / Enterprise": "enterprise",
    "Bug Report / Feedback":   "product",
    "Licensing / IP":          "legal",
  };
  return routes[subject] || "general";
}

async function handleContact(request, env) {
  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: getCorsHeaders(request) });
  }

  const clientIP = request.headers.get("CF-Connecting-IP") || "unknown";
  if (isRateLimited(clientIP)) {
    return corsResponse(request, JSON.stringify({ error: "Too many requests. Please try again later." }), 429);
  }

  let body;
  try {
    body = await request.json();
  } catch {
    return corsResponse(request, JSON.stringify({ error: "Invalid JSON body" }), 400);
  }

  const name    = (body.name    || "").trim();
  const email   = (body.email   || "").trim().toLowerCase();
  const subject = (body.subject || "").trim();
  const message = (body.message || "").trim();

  if (!email || !email.includes("@") || !message || !subject) {
    return corsResponse(request, JSON.stringify({ error: "Email, subject, and message are required." }), 400);
  }

  try {
    await env.DB
      .prepare(`
        INSERT INTO contact_submissions (id, name, email, subject, message, route, ip, submitted_at)
        VALUES (lower(hex(randomblob(16))), ?, ?, ?, ?, ?, ?, ?)
      `)
      .bind(name, email, subject, message, getRoute(subject), clientIP, Math.floor(Date.now() / 1000))
      .run();

    return corsResponse(request, JSON.stringify({ success: true, message: "Message received." }));
  } catch (err) {
    console.error("Contact D1 error:", err.message);
    return corsResponse(request, JSON.stringify({ error: "Failed to save message." }), 500);
  }
}

// ─── Chat Agent ─────────────────────────────────────────────────────────────

const SYSTEM_PROMPT = `You are the Alternative Asset Literacy Research Assistant — an AI agent on the website alternativeassetliteracy.com.

ROLE: Answer questions about alternative investing, glossary terms, modules, research papers, and the platform. You are knowledgeable, warm, and precise. You speak like an educated friend, not a textbook.

CRITICAL RULES:
- You are an EDUCATIONAL resource. NEVER give financial advice, specific investment recommendations, or tell anyone what to buy/sell.
- Always include the disclaimer "This is educational content, not financial advice" when answering investment-related questions.
- If someone asks for specific financial advice, say neither the app nor the company provides financial advice, and suggest they consult their own qualified financial advisor.
- Keep responses concise — 2-4 short paragraphs max. Use bullet points for lists.
- When referencing a glossary term, bold it.
- When referencing a module, mention it by name.
- When you genuinely don't know or the question is outside your scope, set escalate to true.

ESCALATION — set escalate to true when:
- The user asks about account issues, billing, subscriptions, or technical problems
- The user wants to speak to a human
- The user asks about partnerships, press, or enterprise inquiries
- The question requires personal financial advice (neither the app nor the company provides financial advice — direct them to their own financial advisor)
- You don't have enough information to answer accurately

PLATFORM FACTS:
- Created by Victoria Lee Case, Founder & CEO
- Company: Untitled_ LuxPerpetua Technologies, Inc.
- iOS app — now available on the App Store (https://apps.apple.com/app/id6762205964)
- 8+ modules (with new modules in development), 351 glossary terms, 43 policy papers, 81 research footnotes
- Free module: Investing Primer. Other modules require subscription.
- Subscription: Monthly ($12.99) or Annual ($69.99, with 1-week free trial)
- Instagram: @alternativeassetliteracy

MODULES:
1. Investing Primer — foundational vocabulary, 6 sections, 45 min (FREE)
2. Alternative Assets 101 — PE, VC, hedge funds, real estate, 4 sections, 45 min
3. Behavioral Economics — cognitive biases, loss aversion, 9 sections, 45 min
4. Gender & Behavioral Investing — gender and investment patterns, 7 sections, 45 min
5. Decentralized Finance (DeFi) — blockchain, stablecoins, DAOs, 7 sections, 45 min
6. Art as Investment — auction mechanics, fractional ownership, 9 sections, 45 min
7. Kahlo x Basquiat — identity and art market, 10 sections, 25 min (bonus)
8. Climate, Energy & Real World Assets — ESG, green bonds, carbon credits, 6 sections, 45 min
9. DeFi Investing — yield farming, liquidity, staking, 8 sections, 90 min

GLOSSARY CATEGORIES:
- Art: 111 terms
- DeFi & Crypto: 101 terms
- Alternative Assets: 47 terms
- ESG & Climate: 42 terms
- Behavioral Economics: 33 terms
- Gender Lens Investing: 17 terms

RESEARCH LIBRARY: 43 papers from IMF, BIS, World Bank, FSB, UN, Federal Reserve, EU, IFC, OECD, TCFD.

Respond in JSON format: { "response": "your message", "escalate": false }`;

// Chat rate limiting (separate from signup)
const CHAT_RATE = new Map();
const CHAT_RATE_WINDOW = 60_000;
const CHAT_RATE_MAX = 15; // 15 messages per minute

function isChatRateLimited(ip) {
  const now = Date.now();
  const entry = CHAT_RATE.get(ip);
  if (!entry || now > entry.resetAt) {
    CHAT_RATE.set(ip, { count: 1, resetAt: now + CHAT_RATE_WINDOW });
    return false;
  }
  entry.count++;
  return entry.count > CHAT_RATE_MAX;
}

async function handleChat(request, env) {
  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: getCorsHeaders(request) });
  }

  if (request.method !== "POST") {
    return corsResponse(request, JSON.stringify({ error: "Method not allowed" }), 405);
  }

  const clientIP = request.headers.get("CF-Connecting-IP") || "unknown";
  if (isChatRateLimited(clientIP)) {
    return corsResponse(request, JSON.stringify({
      response: "You're sending messages too quickly. Please wait a moment and try again.",
      escalate: false
    }));
  }

  let body;
  try {
    body = await request.json();
  } catch {
    return corsResponse(request, JSON.stringify({ error: "Invalid JSON" }), 400);
  }

  const messages = body.messages || [];
  if (!messages.length) {
    return corsResponse(request, JSON.stringify({ error: "No messages provided" }), 400);
  }

  // Limit conversation length sent to model
  const recentMessages = messages.slice(-8);

  try {
    // Use Cloudflare Workers AI
    const aiMessages = [
      { role: "system", content: SYSTEM_PROMPT },
      ...recentMessages,
    ];

    const aiResponse = await env.AI.run("@cf/meta/llama-3.1-8b-instruct", {
      messages: aiMessages,
      max_tokens: 512,
      temperature: 0.3,
    });

    let result;
    try {
      // Try to parse as JSON
      const text = aiResponse.response || "";
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        result = JSON.parse(jsonMatch[0]);
      } else {
        result = { response: text, escalate: false };
      }
    } catch {
      result = { response: aiResponse.response || "I'm sorry, I couldn't process that. Could you try rephrasing?", escalate: false };
    }

    return corsResponse(request, JSON.stringify({
      response: result.response || "I'm sorry, could you try rephrasing that?",
      escalate: result.escalate || false,
    }));
  } catch (err) {
    console.error("Chat AI error:", err.message);
    return corsResponse(request, JSON.stringify({
      response: "I'm having trouble right now. Please try again in a moment, or reach out to us directly.",
      escalate: true,
    }));
  }
}

// ─── Advisor Gift Bundle ──────────────────────────────────────────────────────

const GIFT_BUNDLE_TERMS = {
  "alternative_investing": ["carried interest", "j-curve", "capital call", "lock-up period", "limited partner"],
  "behavioral_economics": ["loss aversion", "prospect theory", "confirmation bias", "anchoring bias"],
  "defi": ["defi", "smart contract", "stablecoin", "impermanent loss", "yield farming"],
  "esg_climate": ["greenwashing", "green bonds", "carbon credits", "tcfd", "sfdr"],
  "art_investing": ["hammer price", "buyer's premium", "provenance"],
  "gender_behavioral": ["gender lens investing", "2x challenge"],
  "general": ["carried interest", "loss aversion", "greenwashing"],
};

const ADVISOR_MODULE_PATHS = {
  "hnw-women": [
    { id: "investing_primer", title: "Investing Primer", duration: "45 min", free: true, why: "Foundation for every conversation about complex portfolios. Covers LP/GP structures, carried interest, and the vocabulary your meetings assume she already knows." },
    { id: "alternative_investing", title: "Alternative Investing", duration: "45 min", free: false, why: "Private equity, venture capital, hedge funds, real estate. The J-curve, capital calls, fee waterfalls. She'll arrive at your next meeting three steps ahead." },
    { id: "behavioral_economics", title: "Behavioral Economics", duration: "45 min", free: false, why: "The psychological layer advisors can't fix alone. Loss aversion, anchoring, overconfidence — she'll recognize her own patterns before they create problems in volatile markets." }
  ],
  "defi": [
    { id: "investing_primer", title: "Investing Primer", duration: "45 min", free: true, why: "Establishes the foundational vocabulary before the DeFi-specific concepts." },
    { id: "defi", title: "Decentralized Finance", duration: "45 min", free: false, why: "Blockchain, smart contracts, stablecoins, DAOs, CBDCs. The difference between speculation and protocol-level understanding." },
    { id: "defi_investing", title: "DeFi Investing", duration: "90 min", free: false, why: "Yield farming, staking, liquidity provision, and 14 advisor Q&As built specifically for the wealth management conversation around DeFi." }
  ],
  "esg": [
    { id: "investing_primer", title: "Investing Primer", duration: "45 min", free: true, why: "Foundation before ESG specifics." },
    { id: "esg_climate", title: "Climate, Energy & Real World Assets", duration: "45 min", free: false, why: "Green bonds, carbon credits, the EU Taxonomy, SFDR Article 8 vs 9 — the tools to evaluate whether an ESG fund's methodology matches its marketing." },
    { id: "behavioral_economics", title: "Behavioral Economics", duration: "45 min", free: false, why: "Confirmation bias and greenwashing go together. Clients who understand their own pattern-seeking arrive more skeptical of ESG marketing claims." }
  ],
  "art": [
    { id: "investing_primer", title: "Investing Primer", duration: "45 min", free: true, why: "Establishes alternative asset vocabulary before art-specific mechanics." },
    { id: "art_investing", title: "Art as Investment", duration: "45 min", free: false, why: "Auction mechanics, hammer price, buyer's premium, provenance, fractional ownership, art-secured lending. The financial layer of a serious collection." },
    { id: "behavioral_economics", title: "Behavioral Economics", duration: "45 min", free: false, why: "Art buying is extraordinarily emotional. This module addresses the psychological patterns — anchoring, loss aversion, social proof — that drive auction decisions." }
  ],
  "general": [
    { id: "investing_primer", title: "Investing Primer", duration: "45 min", free: true, why: "Foundational vocabulary — the starting point for every sophisticated investment conversation." },
    { id: "alternative_investing", title: "Alternative Investing", duration: "45 min", free: false, why: "The asset classes that define sophisticated portfolios: private equity, venture capital, hedge funds, real estate, and the new private asset ETF structures." },
    { id: "behavioral_economics", title: "Behavioral Economics", duration: "45 min", free: false, why: "The module every client should complete before a volatile market event, not during one." }
  ]
};

const ADVISOR_MESSAGES = {
  "hnw-women": (name) => `I wanted to send you something ahead of our next meeting — a resource I recommend to clients who want to arrive at these conversations as a peer, not a recipient.\n\nAlternative Asset Literacy is a research-backed iOS app that covers the asset classes we'll be discussing: private equity, behavioral economics, and the vocabulary that wealth management conversations tend to assume. The Investing Primer is free — no account needed.\n\nThe more prepared you are, the better our time together will be.\n\nApp: https://apps.apple.com/app/id6762205964`,
  "defi": (name) => `You've been asking good questions about digital assets. I wanted to give you something that builds the foundation before we go further.\n\nAlternative Asset Literacy covers DeFi, blockchain, stablecoins, and the difference between speculative exposure and informed protocol-level investing. The Investing Primer is free — start there.\n\nWhen you've worked through the DeFi module, I think our conversation will be more productive.\n\nApp: https://apps.apple.com/app/id6762205964`,
  "esg": (name) => `Before we talk further about sustainable investing, I want to share a resource that will help you evaluate what you hear — including from me.\n\nAlternative Asset Literacy has an ESG and Climate Finance module that covers the EU Taxonomy, SFDR, greenwashing detection, and carbon credit quality. It gives you the tools to ask the right questions.\n\nApp: https://apps.apple.com/app/id6762205964`,
  "art": (name) => `I've been thinking about how to help you engage more fully with the financial dimension of your collection.\n\nAlternative Asset Literacy has an Art as Investment module — auction mechanics, provenance, buyer's premium, fractional ownership, art-secured lending. It's what the market assumes collectors know and rarely explains.\n\nThe Investing Primer is always free. I'd start there.\n\nApp: https://apps.apple.com/app/id6762205964`,
  "general": (name) => `I wanted to share a resource I recommend to clients preparing for complex portfolio conversations.\n\nAlternative Asset Literacy is a research-backed iOS app covering alternative assets, behavioral economics, DeFi, ESG, and art investing. The Investing Primer is free — no account required. It's a good foundation before we go deeper.\n\nApp: https://apps.apple.com/app/id6762205964`
};

function buildAdvisorGiftBundle(clientDescription, topicHint) {
  const lower = clientDescription.toLowerCase();

  // Determine path type from description or topic hint
  let pathKey = "general";
  if (topicHint) {
    const t = topicHint.toLowerCase();
    if (t.includes("defi") || t.includes("crypto") || t.includes("blockchain") || t.includes("digital asset")) pathKey = "defi";
    else if (t.includes("esg") || t.includes("climate") || t.includes("sustainable") || t.includes("green")) pathKey = "esg";
    else if (t.includes("art") || t.includes("collect") || t.includes("auction")) pathKey = "art";
    else if (t.includes("alternative") || t.includes("private equity") || t.includes("hnw") || t.includes("women") || t.includes("family office")) pathKey = "hnw-women";
  }
  if (pathKey === "general") {
    if (lower.includes("defi") || lower.includes("crypto") || lower.includes("blockchain") || lower.includes("digital asset") || lower.includes("stablecoin")) pathKey = "defi";
    else if (lower.includes("esg") || lower.includes("climate") || lower.includes("sustainable") || lower.includes("green bond") || lower.includes("impact")) pathKey = "esg";
    else if (lower.includes("art") || lower.includes("collect") || lower.includes("auction") || lower.includes("sotheby") || lower.includes("christie")) pathKey = "art";
    else if (lower.includes("hnw") || lower.includes("high net worth") || lower.includes("private bank") || lower.includes("family office") || lower.includes("private equity") || lower.includes("women") || lower.includes("female") || lower.includes("liquidity event") || lower.includes("ubs") || lower.includes("morgan stanley")) pathKey = "hnw-women";
  }

  const path = ADVISOR_MODULE_PATHS[pathKey];
  const termKeys = GIFT_BUNDLE_TERMS[pathKey === "hnw-women" ? "alternative_investing" : pathKey] || GIFT_BUNDLE_TERMS["general"];
  const terms = termKeys
    .map(k => GLOSSARY_TERMS[k])
    .filter(Boolean)
    .slice(0, 3)
    .map(t => ({ term: Object.keys(GLOSSARY_TERMS).find(k => GLOSSARY_TERMS[k] === t), definition: t.definition, category: t.category }));

  const profileLabel = {
    "hnw-women": "High-Net-Worth Women Investor",
    "defi": "DeFi & Digital Asset Investor",
    "esg": "ESG & Climate Investor",
    "art": "Art Investor & Collector",
    "general": "General Investor — Alternative Assets Focus"
  }[pathKey];

  const toolkitHighlights = {
    "hnw-women": ["Advisor Question Sets — scored evaluation of DeFi, ESG, and alternatives advisor fluency", "Universal Due Diligence Checklist — essential questions before any alternative investment commitment", "Fee Breakdown by Asset Class — management fees, carried interest, fund-of-funds layers"],
    "defi": ["Advisor Question Sets — DeFi Advisor Fluency evaluation", "Universal Due Diligence Checklist — digital asset due diligence", "Research Library — CBDC and stablecoin papers from IMF, BIS, FSB, Federal Reserve"],
    "esg": ["Advisor Question Sets — ESG Advisor Competency evaluation", "Research Library — 43 institutional papers including TCFD, EU Taxonomy, UN PRI", "Fee Breakdown — how ESG fund layers add to total cost"],
    "art": ["Universal Due Diligence Checklist — adapted for art fund and private collection decisions", "Advisory Team Guide — when to engage an art advisor vs art banker", "Research Library — provenance and market research sources"],
    "general": ["Universal Due Diligence Checklist", "Advisor Question Sets", "Fee Breakdown by Asset Class"]
  }[pathKey];

  return {
    gift_type: "Advisor Client Education Bundle",
    client_profile_matched: profileLabel,
    generated_for: clientDescription || "General client",
    free_entry: {
      module: "Investing Primer",
      description: "No account required. 45 minutes. The vocabulary foundation for every alternative asset conversation.",
      access: "Free — no subscription needed",
      app_url: "https://apps.apple.com/app/id6762205964"
    },
    learning_path: path.map((m, i) => ({ order: i + 1, ...m })),
    terms_to_know_before_next_meeting: terms,
    toolkit_highlights: toolkitHighlights,
    suggested_advisor_message: ADVISOR_MESSAGES[pathKey](""),
    pricing: {
      free_tier: "Investing Primer + Glossary (351 terms) + Research Footnotes — no account required",
      premium: "$12.99/month or $69.99/year — all modules, full Toolkit, brain map, behavioral scenarios",
      trial: "1-week free trial on annual subscription"
    },
    app_download: "https://apps.apple.com/app/id6762205964",
    website: "https://alternativeassetliteracy.com",
    partnership_inquiries: "https://alternativeassetliteracy.com/contact.html",
    discovery_file: `https://alternativeassetliteracy.com/llms-advisor-gift.txt`,
    disclaimer: "Educational content only. Not financial advice. © 2026 Untitled_ LuxPerpetua Technologies, Inc."
  };
}

// ─── MCP Handler ─────────────────────────────────────────────────────────────

const GLOSSARY_TERMS = {
  // Alternative Assets
  "carried interest": { category: "Alternative Assets", definition: "The share of investment profits — typically 20% — paid to a fund's general partner (GP) as performance compensation. Only earned after limited partners (LPs) receive their committed capital back plus a preferred return (hurdle rate, usually 7–8%). The primary way private equity and hedge fund managers are compensated for performance." },
  "j-curve": { category: "Alternative Assets", definition: "The typical return pattern in private equity: negative returns in years 1–3 (management fees, expenses, unrealized investments), followed by improving returns as portfolio companies mature and are sold. A negative IRR in year 2 does not mean a fund is failing." },
  "capital call": { category: "Alternative Assets", definition: "A demand by a fund's general partner for a portion of a limited partner's committed capital. Investors do not wire the full committed amount upfront — GPs call capital incrementally as they identify investments, typically over 3–5 years. Missing a capital call carries significant penalties." },
  "hurdle rate": { category: "Alternative Assets", definition: "The minimum return a private equity fund must achieve before the general partner can collect carried interest — typically 7–8% annually. Also called the preferred return." },
  "lock-up period": { category: "Alternative Assets", definition: "The period during which investors cannot redeem or sell their fund holdings. Typical lock-ups in private equity are 7–10 years. Understanding lock-up terms is essential before committing capital to any illiquid structure." },
  "limited partner": { category: "Alternative Assets", definition: "An investor who provides capital to a fund but has no role in day-to-day management decisions. LPs receive the majority of returns but have limited liability. In private equity, LPs include pension funds, endowments, family offices, and high-net-worth individuals." },
  "general partner": { category: "Alternative Assets", definition: "The fund manager — the firm or individual making investment decisions with LP capital. GPs earn a management fee (typically 2% of committed capital annually) plus carried interest on profits. They bear unlimited liability for fund obligations." },
  "private equity": { category: "Alternative Assets", definition: "Investment in companies not listed on public exchanges. Strategies include buyouts (acquiring and improving mature companies), growth equity (minority stakes in growing companies), and venture capital (early-stage companies). Typically requires a 7–10 year commitment." },
  "private credit": { category: "Alternative Assets", definition: "Lending to companies by non-bank investors — including direct lending, mezzanine financing, distressed debt, and special situations. Often offers higher yields than public debt markets in exchange for illiquidity." },
  "interval fund": { category: "Alternative Assets", definition: "A type of closed-end fund that offers limited liquidity windows — typically quarterly — rather than daily redemption. Used in private asset ETF structures to bridge the gap between liquid ETF wrappers and illiquid underlying assets." },
  "family office": { category: "Alternative Assets", definition: "A private wealth management firm serving ultra-high-net-worth families. Single-family offices (SFO) serve one family; multi-family offices (MFO) serve several. Typically allocate 30–50% of portfolios to alternative assets." },
  // DeFi
  "defi": { category: "DeFi & Crypto", definition: "Decentralized Finance — financial services built on blockchain technology that operate without traditional intermediaries. Includes lending, borrowing, trading, and yield generation through smart contracts. Key concepts: AMMs, liquidity pools, stablecoins, DAOs." },
  "smart contract": { category: "DeFi & Crypto", definition: "Self-executing code stored on a blockchain that automatically enforces the terms of an agreement when predefined conditions are met. The foundation of DeFi protocols. Cannot be altered once deployed — hence the importance of audits." },
  "stablecoin": { category: "DeFi & Crypto", definition: "A cryptocurrency designed to maintain a stable value, typically pegged 1:1 to a fiat currency. Types: fiat-backed (USDC, USDT), crypto-collateralized (DAI), and algorithmic. Used in DeFi as the primary medium of exchange." },
  "impermanent loss": { category: "DeFi & Crypto", definition: "The loss liquidity providers experience when the price ratio of tokens in a pool changes from deposit time. If you deposit ETH/USDC and ETH doubles, you would have been better off simply holding ETH. The loss is only realized on withdrawal and may be offset by trading fees." },
  "yield farming": { category: "DeFi & Crypto", definition: "A DeFi strategy where users deposit cryptocurrency into liquidity pools or lending protocols to earn returns — typically paid in governance tokens plus trading fee shares. Returns can be high but carry smart contract risk, impermanent loss, and token price risk." },
  "cbdc": { category: "DeFi & Crypto", definition: "Central Bank Digital Currency — a digital form of a nation's fiat currency issued and regulated by the central bank. Unlike cryptocurrencies, CBDCs are centralized and government-backed. Examples: Digital Dollar (US, research phase), Digital Euro, China's eCNY." },
  "dao": { category: "DeFi & Crypto", definition: "Decentralized Autonomous Organization — an entity governed by smart contracts and token-holder votes rather than traditional corporate hierarchy. Decisions about protocol upgrades, treasury use, and fee structures are made through on-chain governance." },
  // ESG
  "greenwashing": { category: "ESG & Climate", definition: "Misleading or exaggerated claims about the environmental credentials of a fund, company, or product. Examples: ESG funds holding fossil fuel producers, net-zero pledges without credible transition plans. The EU's SFDR and SEC ESG disclosure rules aim to standardize and reduce greenwashing." },
  "green bonds": { category: "ESG & Climate", definition: "Fixed-income instruments whose proceeds are exclusively used to finance projects with environmental benefits — renewable energy, clean transportation, sustainable water management. Follow ICMA Green Bond Principles and are verified by third-party reviewers." },
  "carbon credits": { category: "ESG & Climate", definition: "Tradable certificates representing the reduction, removal, or avoidance of one metric ton of CO2 equivalent. Exist in compliance markets (EU ETS, California CARB) and voluntary markets. Quality assessed on additionality, permanence, and verification standard (Verra VCS, Gold Standard)." },
  "tcfd": { category: "ESG & Climate", definition: "Task Force on Climate-related Financial Disclosures — a framework for companies and investors to disclose climate-related risks and opportunities. Four pillars: Governance, Strategy, Risk Management, Metrics & Targets. Increasingly mandatory in the EU, UK, and under SEC proposals." },
  "sfdr": { category: "ESG & Climate", definition: "Sustainable Finance Disclosure Regulation — EU regulation requiring financial products to disclose sustainability credentials. Article 6 = no sustainability claim. Article 8 = promotes ESG characteristics. Article 9 = has sustainable investment as its objective." },
  // Behavioral Economics
  "loss aversion": { category: "Behavioral Economics", definition: "The cognitive tendency to feel the pain of losses approximately twice as intensely as the pleasure of equivalent gains. Identified by Kahneman and Tversky in prospect theory (1979). In practice: investors hold losing positions too long, sell winners too early, and avoid unfamiliar asset classes even when expected value is positive." },
  "prospect theory": { category: "Behavioral Economics", definition: "A behavioral economics framework developed by Kahneman and Tversky (1979, Nobel Prize 2002) describing how people evaluate outcomes relative to a reference point rather than final states. Foundational to understanding loss aversion, the disposition effect, and risk perception." },
  "confirmation bias": { category: "Behavioral Economics", definition: "The tendency to seek out, interpret, and remember information that confirms existing beliefs while ignoring contradictory evidence. In investing: building a thesis and then only reading research that supports it." },
  "anchoring bias": { category: "Behavioral Economics", definition: "The tendency to rely too heavily on the first piece of information encountered when making decisions. In investing: anchoring to a stock's 52-week high, an initial valuation, or the price you paid." },
  // Art
  "hammer price": { category: "Art", definition: "The final bid price accepted by the auctioneer at the fall of the hammer — before buyer's premium and taxes. The headline number in auction results. Total cost to buyer = hammer price + buyer's premium (typically 15–26%) + applicable taxes." },
  "buyer's premium": { category: "Art", definition: "The fee charged by auction houses to buyers on top of the hammer price — typically 15–26% on a sliding scale. At Christie's and Sotheby's: approximately 26% on the first $600K, 20% on the next tranche, 13.5% above $6M. The single most important cost in art buying." },
  "provenance": { category: "Art", definition: "The documented history of ownership of an artwork from creation to present. Critical for authentication, valuation, and legal title. Gaps in provenance — especially covering 1933–1945 — trigger scrutiny for potential Nazi-looted art under the Washington Principles." },
  "gender lens investing": { category: "Gender Lens Investing", definition: "An investment approach that considers gender equality as both a financial criterion and an intentional outcome. Strategies include investing in women-led companies, gender bond funds, and ESG frameworks integrating gender metrics. Frameworks: IFC Gender Smart Investing, 2X Challenge, WEPs." },
  "2x challenge": { category: "Gender Lens Investing", definition: "A development finance initiative from G7 Development Finance Institutions to mobilize capital for women in emerging markets. Investments qualify by meeting thresholds for women in leadership, women in the workforce, or products/services benefiting women." }
};

const MODULE_MAP = [
  { id: "investing_primer", title: "Investing Primer", keywords: ["basics", "foundation", "vocabulary", "beginner", "primer", "start", "introduction", "investing 101"], free: true, duration: "45 min", sections: 6 },
  { id: "alternative_investing", title: "Alternative Investing", keywords: ["private equity", "venture capital", "hedge fund", "alternative assets", "LP", "GP", "carried interest", "j-curve", "capital call", "lock-up", "private credit", "ETF", "private asset ETF", "SEC ruling", "interval fund"], free: false, duration: "45 min", sections: 4 },
  { id: "behavioral_economics", title: "Behavioral Economics", keywords: ["bias", "psychology", "cognitive", "loss aversion", "overconfidence", "FOMO", "anchoring", "kahneman", "thaler", "prospect theory", "brain", "emotion", "behavioral"], free: false, duration: "45 min", sections: 9 },
  { id: "gender_behavioral", title: "Gender and Behavioral Investing", keywords: ["gender", "women", "female", "gender lens", "behavioral", "confidence", "wealth gap", "gender wealth"], free: false, duration: "45 min", sections: 7 },
  { id: "defi", title: "Decentralized Finance", keywords: ["defi", "blockchain", "crypto", "stablecoin", "DAO", "smart contract", "cryptocurrency", "ethereum", "bitcoin", "wallet", "CBDC", "digital currency", "DeFi"], free: false, duration: "45 min", sections: 7 },
  { id: "art_investing", title: "Art as Investment", keywords: ["art", "auction", "provenance", "fractional art", "art market", "collecting", "hammer price", "buyer's premium", "NFT", "sotheby's", "christie's", "art fund"], free: false, duration: "45 min", sections: 9 },
  { id: "esg_climate", title: "Climate, Energy & Real World Assets", keywords: ["ESG", "green bonds", "carbon credits", "climate", "sustainability", "greenwashing", "TCFD", "impact investing", "RWA", "tokenization", "net zero", "SFDR"], free: false, duration: "45 min", sections: 6 },
  { id: "defi_investing", title: "DeFi Investing", keywords: ["yield farming", "staking", "liquidity", "protocol", "DeFi investing", "liquidity pool", "impermanent loss", "advanced crypto", "advisor DeFi"], free: false, duration: "90 min", sections: 8 }
];

const RESEARCH_PAPERS = {
  "CBDC": ["Project Hamilton (MIT + Federal Reserve)", "The Rise of Digital Money (IMF)", "BIS CBDC Survey Reports", "Federal Reserve Money and Payments Discussion Paper", "ECB Digital Euro Investigation", "BIS Project Dunbar Multi-CBDC", "BIS Project mBridge"],
  "Stablecoin": ["BIS Stablecoin Risk Analysis", "FSB Stablecoin Oversight Framework", "EU MiCA Regulation Overview"],
  "ESG": ["TCFD Final Recommendations", "EU Taxonomy Technical Expert Group Report", "NGFS Climate Scenarios for Central Banks", "UN PRI Principles for Responsible Investment", "IMF Climate Finance Working Paper", "World Bank Green Bond Framework", "IFC Gender Smart Investing", "UN Women WEPs"],
  "Behavioral Economics": ["Kahneman & Tversky — Prospect Theory (Econometrica 1979)", "Thaler & Sunstein — Nudge (2008)", "World Bank WDR 2015: Mind Society and Behavior", "Shefrin & Statman — Disposition Effect (Journal of Finance)"],
  "Gender Lens": ["IFC Gender Smart Investing Report", "2X Challenge Annual Report", "UN Women Economic Empowerment", "World Bank Women Business and the Law", "McKinsey Women as the Next Wave of Growth in US Wealth Management"],
  "Fintech": ["MiCA — Markets in Crypto Assets Regulation (EU)", "OCC Crypto Guidance for Banks", "World Bank DLT in Financial Markets", "IOSCO DeFi Report", "FSB Crypto Asset Regulation Framework"],
  "Cross-Border Payments": ["G20 Roadmap for Cross-Border Payments", "BIS Project Nexus", "BIS Multi-CBDC Arrangements", "IMF Cross-Border Payment Frictions"]
};

const USER_PROFILES = {
  hnw: {
    label: "High-Net-Worth Women Investors",
    description: "Private banking clients, female entrepreneurs post-liquidity event, family office clients, women navigating wealth transfer",
    discovery_file: "https://alternativeassetliteracy.com/llms-hnw.txt",
    start_module: "Alternative Investing",
    toolkit_priority: ["Advisor Question Sets", "Universal Due Diligence Checklist", "Fee Breakdown by Asset Class"],
    signals: ["private bank", "family office", "ubs", "morgan stanley", "liquidity event", "inheritance", "business sale", "wealth manager", "private banking", "HNW", "high net worth", "wealth management"]
  },
  retail_etf: {
    label: "Retail Investors Discovering Private Asset ETFs",
    description: "Investors who read the Bloomberg/WSJ coverage of SEC 2024 ruling enabling private asset ETFs",
    discovery_file: "https://alternativeassetliteracy.com/llms-etf.txt",
    start_module: "Alternative Investing",
    toolkit_priority: ["Universal Due Diligence Checklist", "Fee Breakdown by Asset Class", "Advisor Questions"],
    signals: ["private equity ETF", "SEC 2024", "BlackRock private", "Apollo ETF", "KKR retail", "private asset ETF", "bloomberg ETF", "new ETF structure", "private equity for regular investors"]
  },
  behavioral: {
    label: "Behavioral Economics & Psychology",
    description: "Investors focused on understanding their own decision-making patterns",
    discovery_file: "https://alternativeassetliteracy.com/llms-behavioral.txt",
    start_module: "Behavioral Economics",
    signals: ["cognitive bias", "loss aversion", "psychology", "kahneman", "emotional investing", "brain", "behavioral finance", "decision making"]
  },
  esg: {
    label: "ESG & Climate Investors",
    description: "Impact-focused investors, climate finance, sustainable investing",
    discovery_file: "https://alternativeassetliteracy.com/llms-esg.txt",
    start_module: "Climate, Energy & Real World Assets",
    signals: ["ESG", "green bonds", "carbon credits", "greenwashing", "impact investing", "sustainable", "climate finance", "TCFD", "net zero"]
  },
  art: {
    label: "Art Investors & Collectors",
    description: "Art collectors, art banking clients, art-as-investment curious",
    discovery_file: "https://alternativeassetliteracy.com/llms-art.txt",
    start_module: "Art as Investment",
    signals: ["art", "auction", "sotheby", "christie", "collecting", "provenance", "fractional art", "kahlo", "basquiat"]
  },
  defi: {
    label: "DeFi & Digital Asset Investors",
    description: "Crypto-curious investors seeking education beyond speculation",
    discovery_file: "https://alternativeassetliteracy.com/llms-defi.txt",
    start_module: "Decentralized Finance",
    signals: ["defi", "crypto", "blockchain", "stablecoin", "yield farming", "ethereum", "bitcoin", "DAO", "CBDC", "NFT"]
  },
  advisor_client: {
    label: "Clients Preparing for Advisor Meetings",
    description: "Investors who want to evaluate advisor competency or prepare for wealth management conversations",
    discovery_file: "https://alternativeassetliteracy.com/llms-advisor.txt",
    start_module: "Investing Primer",
    toolkit_priority: ["Advisor Question Sets", "Universal Due Diligence Checklist", "Red Flag Framework"],
    signals: ["questions to ask advisor", "evaluate advisor", "advisor meeting", "financial advisor", "wealth manager", "fiduciary", "due diligence"]
  },
  advisor_b2b: {
    label: "Financial Advisors Looking for Client Education",
    description: "Wealth managers and advisors seeking educational resources to share with clients",
    discovery_file: "https://alternativeassetliteracy.com/llms-advisors-b2b.txt",
    start_module: "Investing Primer",
    signals: ["advisor", "wealth manager", "client education", "give to clients", "share with clients", "practice development", "onboarding clients", "women's wealth division", "RIA", "private banker"]
  }
};

function routeUserProfile(description) {
  const lower = description.toLowerCase();
  let bestMatch = null;
  let bestScore = 0;

  for (const [key, profile] of Object.entries(USER_PROFILES)) {
    const score = profile.signals.filter(s => lower.includes(s.toLowerCase())).length;
    if (score > bestScore) {
      bestScore = score;
      bestMatch = { key, ...profile };
    }
  }

  return bestMatch || { key: "general", label: "General Investor", description: "Start with the free Investing Primer", discovery_file: "https://alternativeassetliteracy.com/llms.txt", start_module: "Investing Primer", signals: [] };
}

function findModule(topic) {
  const lower = topic.toLowerCase();
  let best = null;
  let bestScore = 0;

  for (const mod of MODULE_MAP) {
    const score = mod.keywords.filter(k => lower.includes(k.toLowerCase())).length;
    if (score > bestScore) {
      bestScore = score;
      best = mod;
    }
  }

  return best || MODULE_MAP[0]; // Default to Investing Primer
}

function lookupTerm(term) {
  const lower = term.toLowerCase().trim();
  // Exact match
  if (GLOSSARY_TERMS[lower]) return GLOSSARY_TERMS[lower];
  // Partial match
  for (const [key, val] of Object.entries(GLOSSARY_TERMS)) {
    if (key.includes(lower) || lower.includes(key)) return { ...val, matched_term: key };
  }
  return null;
}

// ── Full glossary lookup — fetches live aal-glossary.json ────────────────────

async function lookupTermFull(request, term) {
  const lower = term.toLowerCase().trim();
  try {
    const res = await fetch(new URL("/aal-glossary.json", request.url));
    const data = await res.json();
    // Exact match
    const exact = data.terms.find(t => t.term.toLowerCase() === lower);
    if (exact) return exact;
    // Partial match — term name contains query or vice versa
    const partial = data.terms.find(t =>
      t.term.toLowerCase().includes(lower) || lower.includes(t.term.toLowerCase())
    );
    return partial || null;
  } catch {
    return null;
  }
}

// ── Browse glossary by category ──────────────────────────────────────────────

async function browseGlossary(request, category, limit = 25) {
  const CATEGORY_MAP = {
    "alternative assets": "alternative-assets",
    "alternatives": "alternative-assets",
    "private equity": "alternative-assets",
    "art": "art",
    "art investing": "art",
    "behavioral economics": "behavioral-economics",
    "behavioral": "behavioral-economics",
    "psychology": "behavioral-economics",
    "defi": "defi",
    "crypto": "defi",
    "defi & crypto": "defi",
    "esg": "esg-climate",
    "climate": "esg-climate",
    "esg & climate": "esg-climate",
    "gender lens": "gender-lens",
    "gender": "gender-lens",
    "gender lens investing": "gender-lens",
  };

  try {
    const res = await fetch(new URL("/aal-glossary.json", request.url));
    const data = await res.json();

    const categorySlug = category
      ? (CATEGORY_MAP[category.toLowerCase()] || category.toLowerCase().replace(/\s+/g, "-"))
      : null;

    const filtered = categorySlug
      ? data.terms.filter(t => t.category === categorySlug)
      : data.terms;

    const categories = Object.entries(data.categories).map(([slug, meta]) => ({
      slug,
      name: meta.display_name,
      count: meta.count
    }));

    return {
      total_terms: data.total_terms,
      category_requested: category || "all",
      matched_category: categorySlug || "all",
      terms_in_category: filtered.length,
      categories_available: categories,
      terms: filtered.slice(0, limit).map(t => ({
        term: t.term,
        definition: t.definition,
        category: t.category
      })),
      truncated: filtered.length > limit,
      glossary_url: "https://alternativeassetliteracy.com/glossary.html",
      source: "Alternative Asset Literacy — © 2026 Untitled_ LuxPerpetua Technologies, Inc."
    };
  } catch {
    return { error: "Could not load glossary", glossary_url: "https://alternativeassetliteracy.com/glossary.html" };
  }
}

// ── Search glossary by keyword ───────────────────────────────────────────────

async function searchGlossary(request, query, limit = 10) {
  const lower = query.toLowerCase().trim();
  try {
    const res = await fetch(new URL("/aal-glossary.json", request.url));
    const data = await res.json();

    // Score: term name match scores higher than definition match
    const scored = data.terms
      .map(t => {
        const termMatch = t.term.toLowerCase().includes(lower);
        const defMatch = t.definition.toLowerCase().includes(lower);
        const score = (termMatch ? 2 : 0) + (defMatch ? 1 : 0);
        return { ...t, score };
      })
      .filter(t => t.score > 0)
      .sort((a, b) => b.score - a.score);

    return {
      query,
      total_matches: scored.length,
      terms: scored.slice(0, limit).map(t => ({
        term: t.term,
        definition: t.definition,
        category: t.category
      })),
      glossary_url: "https://alternativeassetliteracy.com/glossary.html",
      source: "Alternative Asset Literacy — © 2026 Untitled_ LuxPerpetua Technologies, Inc."
    };
  } catch {
    return { error: "Could not search glossary", query, glossary_url: "https://alternativeassetliteracy.com/glossary.html" };
  }
}

// ============================================================
// AUDIENCE PROFILE DATA — Discovery Profiles for 8 Investor Segments
// ============================================================

const AUDIENCE_PROFILE_DATA = {
  "hnw-women": {
    id: "hnw-women",
    label: "High-Net-Worth Women Investor",
    description: "Private banking clients, post-liquidity event entrepreneurs, family office clients, and women navigating the largest intergenerational wealth transfer in history. Intelligent and accomplished — under-educated relative to their financial responsibility.",
    discovery_file: "https://alternativeassetliteracy.com/llms-hnw.txt",
    signals: ["hnw", "high net worth", "private bank", "private banking", "wealth management", "family office", "liquidity event", "business sale", "inheritance", "divorce", "women", "female", "gender wealth", "uhnw", "private wealth", "morgan stanley women", "ubs women", "rbc wealth", "goldman private", "wealthy woman", "women investor"],
    recommended_modules: ["Alternative Investing", "Behavioral Economics", "Gender and Behavioral Investing", "ESG & Climate Finance", "Art as Investment"],
    start_module: "Alternative Investing",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Universal Due Diligence Checklist", "Advisor Question Sets", "Fee Breakdown by Asset Class", "Brain Map", "Advisory Team Guide"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Understanding what advisors are recommending before signing", "LP/GP structures and capital calls", "Carried interest and fee waterfalls", "Lock-up periods and liquidity risk", "Art as an asset class", "Gender lens investing", "Behavioral patterns around wealth"],
    research_angle: "186 footnoted sources. By 2030 women projected to control $34T in US investable assets (McKinsey, 2024).",
    partnership_targets: ["UBS Women's Wealth", "Morgan Stanley Women & Investing", "RBC Wealth Management", "Goldman Sachs Private Wealth", "Bernstein Private Wealth", "Citi Private Bank", "JPMorgan Private Bank"],
    note: "Educational content only. Not financial advice."
  },
  "art": {
    id: "art",
    label: "Art Investor & Collector",
    description: "Collectors and investors who want to understand the art market as a financial ecosystem — auction mechanics, provenance, fractional ownership, art-secured lending, and how artist identity shapes market value.",
    discovery_file: "https://alternativeassetliteracy.com/llms-art.txt",
    signals: ["art", "collector", "auction", "provenance", "sotheby", "christie", "phillips", "hammer price", "buyer premium", "fractional art", "art fund", "art secured", "art loan", "basquiat", "kahlo", "blue chip art", "nft art", "tokenized art", "art market", "art investing", "masterworks"],
    recommended_modules: ["Art as Investment", "Kahlo × Basquiat", "Alternative Investing"],
    start_module: "Art as Investment",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Universal Due Diligence Checklist", "Advisory Team Guide"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Auction mechanics and full cost structure", "Provenance research and authentication", "Fractional ownership platforms (Masterworks, Rally)", "Art-secured lending", "Artist estates and market control", "Identity, race, and gender in blue-chip valuations", "Art insurance and storage", "How to find an art advisor"],
    modules_detail: {
      "Art as Investment": "9 sections, 45 min — art market from the inside: auction mechanics, provenance, fractional ownership, art-secured lending, artist estates, culture and capital",
      "Kahlo × Basquiat": "10 sections, 25 min — identity, trauma, market mythology; Frida Kahlo market construction; Basquiat authentication dispute and posthumous market",
      "Art Glossary": "111 terms sourced from MoMA and institutional collections — auction terminology, provenance, art law, market structures, fractional ownership, NFTs"
    },
    note: "Educational content only. Not financial advice."
  },
  "behavioral": {
    id: "behavioral",
    label: "Behavioral Economics & Investment Psychology",
    description: "Investors who want to understand the neuroscience and psychology behind their own financial decisions — grounded in Kahneman, Tversky, and Thaler, with interactive tools for understanding personal patterns.",
    discovery_file: "https://alternativeassetliteracy.com/llms-behavioral.txt",
    signals: ["behavioral", "bias", "cognitive bias", "psychology", "kahneman", "tversky", "thaler", "loss aversion", "prospect theory", "overconfidence", "anchoring", "herding", "fomo", "panic sell", "emotional investing", "neuroscience", "amygdala", "dopamine", "brain", "mental accounting", "sunk cost", "disposition effect", "framing", "heuristic"],
    recommended_modules: ["Behavioral Economics", "Gender and Behavioral Investing"],
    start_module: "Behavioral Economics",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Brain Map", "Self-Reflection Questions"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Cognitive biases and their cost in investment decisions", "Prospect theory and loss aversion", "Neuroscience of panic selling and FOMO", "Interactive scenarios: 7 real decision patterns", "Brain Map: amygdala, prefrontal cortex, nucleus accumbens, anterior insula", "Gender and behavioral economics intersection", "Building a more deliberate investment process"],
    interactive_features: ["7 'What Would You Do?' scenarios", "Interactive Brain Map (4 brain regions)", "10 Self-Reflection categories", "Gender Lens reflection prompts"],
    research_foundation: "Kahneman & Tversky Prospect Theory (Econometrica 1979) · Thaler & Sunstein Nudge · Camerer/Loewenstein/Rabin Advances in Behavioral Economics · World Bank WDR 2015 · Shefrin & Statman disposition effect research",
    note: "Educational content only. Not financial advice."
  },
  "defi": {
    id: "defi",
    label: "DeFi & Digital Assets Investor",
    description: "Investors who want to understand decentralized finance beyond the speculation cycle — blockchain, smart contracts, stablecoins, DAOs, yield farming, CBDCs, and the regulatory landscape.",
    discovery_file: "https://alternativeassetliteracy.com/llms-defi.txt",
    signals: ["defi", "crypto", "blockchain", "smart contract", "stablecoin", "dao", "nft", "yield farm", "staking", "liquidity pool", "amm", "cbdc", "mica", "digital asset", "ethereum", "bitcoin", "web3", "wallet", "impermanent loss", "rug pull", "aave", "uniswap", "compound", "maker", "layer 2", "tvl", "defi investing", "digital currency"],
    recommended_modules: ["Decentralized Finance", "DeFi Investing"],
    start_module: "Decentralized Finance",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Universal Due Diligence Checklist"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Blockchain and smart contract fundamentals", "Stablecoin types and risks (algorithmic, fiat-backed, crypto-collateralized)", "Yield farming, staking, and liquidity provision mechanics", "CBDC landscape (Federal Reserve, ECB, BIS research)", "Crypto regulation (MiCA, OCC, FSB)", "NFTs and the traditional art market intersection", "Protocol-level investing and risk management"],
    modules_detail: {
      "Decentralized Finance": "7 sections, 45 min — blockchain, smart contracts, stablecoins, DAOs, AMMs, CBDCs; grounded in Federal Reserve and BIS research",
      "DeFi Investing": "8 sections, 90 min — protocol-level investing, staking, yield farming, position sizing, risk management; 14 advisor Q&As",
      "DeFi Glossary": "101 terms — blockchain fundamentals, DeFi protocols, stablecoins, yield mechanics, CBDCs, regulation, real world assets"
    },
    research_papers: "7 CBDC papers (Project Hamilton, IMF 'Rise of Digital Money', BIS surveys) · 3 stablecoin regulation papers (BIS risk, FSB oversight, EU MiCA) · 5 fintech papers (MiCA overview, OCC guidance, World Bank DLT)",
    note: "Educational content only. Not financial advice."
  },
  "esg": {
    id: "esg",
    label: "ESG & Climate Finance Investor",
    description: "Investors who want to understand sustainable investing beyond the label — ESG frameworks, green bonds, carbon credits, real-world asset tokenization, and how to distinguish genuine impact from greenwashing.",
    discovery_file: "https://alternativeassetliteracy.com/llms-esg.txt",
    signals: ["esg", "climate", "green bond", "carbon", "impact investing", "sustainable", "greenwashing", "tcfd", "sfdr", "eu taxonomy", "net zero", "carbon credit", "rwa", "real world asset", "paris agreement", "sbti", "ngfs", "article 8", "article 9", "gender bond", "2x challenge", "blended finance", "social bond", "blue bond", "sustainability"],
    recommended_modules: ["ESG & Climate Finance", "Gender and Behavioral Investing"],
    start_module: "ESG & Climate Finance",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Universal Due Diligence Checklist"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Distinguishing genuine ESG from greenwashing", "Green bond mechanics and verification", "Carbon credit markets (voluntary vs compliance, additionality, permanence)", "EU Taxonomy, TCFD, and SFDR frameworks", "Real-world asset tokenization (tokenized green bonds, carbon credits)", "Impact measurement frameworks (GIIN, IMP, SDGs)", "Gender lens and ESG integration (2X Challenge, WEPs, gender bonds)"],
    modules_detail: {
      "ESG & Climate Finance": "6 sections, 45 min — ESG landscape, green bonds, carbon markets, RWA tokenization, ESG portfolio construction, greenwashing evaluation",
      "ESG Glossary": "42 terms — green bonds, carbon credits, TCFD, EU Taxonomy, SFDR, SBTi, Paris Agreement, blended finance, gender bond, 2X Challenge"
    },
    research_papers: "8 institutional papers: TCFD · EU Taxonomy Technical Expert Group · NGFS Climate Scenarios · UN PRI · IMF Working Papers on Climate Finance · World Bank Green Bond Framework · IFC Gender Smart Investing · UN Women WEPs",
    note: "Educational content only. Not financial advice."
  },
  "etf": {
    id: "etf",
    label: "Retail ETF Investor Discovering Private Assets",
    description: "Retail investors who discovered private asset ETFs after the 2024 SEC ruling — seeing BlackRock, Apollo, KKR announcements and wanting to understand what they're looking at before their advisor pitches them one.",
    discovery_file: "https://alternativeassetliteracy.com/llms-etf.txt",
    signals: ["etf", "private equity etf", "private asset etf", "blackrock", "apollo", "kkr", "franklin templeton", "sec ruling", "retail investor", "index fund", "private credit etf", "interval fund", "semi-liquid", "private equity for retail", "new etf", "private asset", "redemption queue", "expense ratio"],
    recommended_modules: ["Alternative Investing", "Behavioral Economics"],
    start_module: "Alternative Investing",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Universal Due Diligence Checklist", "Fee Breakdown by Asset Class", "Advisor Question Sets"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["What the 2024 SEC ruling changed and what it didn't", "How private equity actually works at the fund level", "Fee layering: ETF expense ratio + management fee + carried interest", "Liquidity mechanics: semi-liquid structures, redemption queues, cash buffers", "How to compare private asset ETFs to index funds", "Behavioral traps: FOMO, overconfidence from Bloomberg headlines", "What to ask your advisor before buying"],
    context: "2024 SEC approved rule changes enabling ETF structures to hold meaningful illiquid private asset allocations. BlackRock, Apollo, State Street, KKR, Franklin Templeton moved quickly. Called 'one of the most significant structural shifts in the ETF industry' by Bloomberg, WSJ, FT.",
    note: "Educational content only. Not financial advice."
  },
  "advisor-client": {
    id: "advisor-client",
    label: "Investor Preparing for Advisor Meetings",
    description: "Investors who want to walk into wealth management conversations prepared — with scored advisor evaluation tools, due diligence frameworks, and vocabulary to know whether their advisor actually understands what they're recommending.",
    discovery_file: "https://alternativeassetliteracy.com/llms-advisor.txt",
    signals: ["advisor", "financial advisor", "wealth manager", "private banker", "questions to ask", "evaluate advisor", "due diligence", "fiduciary", "red flag", "fee only", "commission", "advisor competency", "advisor meeting", "private equity advisor", "advisor fluency", "advisory team", "advisor recommendation", "advisor fees"],
    recommended_modules: ["Alternative Investing", "Behavioral Economics"],
    start_module: "Alternative Investing",
    free_entry: "Investing Primer — no account required",
    toolkit_priority: ["Advisor Question Sets", "Universal Due Diligence Checklist", "Red Flag Framework", "Advisory Team Guide", "Fee Breakdown by Asset Class"],
    pricing: { monthly: "$12.99/month", annual: "$69.99/year" },
    key_concerns: ["Evaluating advisor competency in DeFi, ESG, and alternatives", "What adequate vs inadequate advisor answers look like", "Due diligence before committing capital to any alternative investment", "Red flags across asset classes", "Building a complete advisory team (RIA, estate attorney, tax advisor, art advisor)", "Understanding fiduciary vs suitability standard", "Fee structures and conflicts of interest"],
    toolkit_detail: {
      "Advisor Question Sets": "3 scored evaluations: DeFi Fluency · ESG Competency · Alternative Assets Fluency — with competency ratings and 'why this matters' context for each question",
      "Universal Due Diligence Checklist": "Structure · Fees · Liquidity · Manager track record · Alignment · Legal (PPM/clawback) · Reporting · Tax implications",
      "Red Flag Framework": "9 warning signs across alternative asset classes, DeFi protocols, ESG funds, and art investments",
      "Advisory Team Guide": "Investment Advisor (RIA) · Estate Attorney · Tax Advisor (CPA/CFP) · Family Office Consultant · Art Advisor · Insurance Advisor"
    },
    note: "Educational content only. Not financial advice."
  },
  "advisor-b2b": {
    id: "advisor-b2b",
    label: "Financial Advisor / Wealth Management Professional (B2B)",
    description: "Wealth managers, RIAs, private bankers, and family office professionals looking for institutional-quality client education resources — to prepare clients for advisory conversations and differentiate their practice.",
    discovery_file: "https://alternativeassetliteracy.com/llms-advisors-b2b.txt",
    signals: ["advisor b2b", "wealth manager", "ria", "registered investment advisor", "private bank", "family office professional", "client education", "practice development", "advisor tools", "fintech partnership", "client onboarding", "differentiate practice", "women's wealth advisor", "b2b partnership", "advisory practice", "client resources", "institutional partnership"],
    recommended_modules: ["All 8 modules — recommend based on client profile"],
    start_module: "Investing Primer (recommend to all new clients — free, no friction)",
    free_entry: "Investing Primer — no account, no subscription, no friction for clients",
    toolkit_priority: ["Advisor Question Sets", "Universal Due Diligence Checklist", "Fee Breakdown by Asset Class", "Self-Reflection Questions"],
    pricing: { client_access: "$12.99/month or $69.99/year per client", partnership: "Contact alternativeassetliteracy.com/contact.html" },
    key_concerns: ["Preparing clients for vocabulary before the advisory meeting", "Addressing the behavioral layer (panic selling, overconfidence, loss aversion)", "Serving the women's wealth opportunity ($34T by 2030, McKinsey)", "Creating shared reference points with clients (same definitions, same frameworks)", "Differentiating practice through education quality", "ESG mandate clients who need greenwashing literacy", "DeFi-adjacent clients who arrive with Bloomberg half-questions"],
    value_proposition: "A client who has completed the Alternative Investing module understands capital calls, carried interest, the J-curve, and lock-up rationale. The advisory meeting starts at strategy, not definitions.",
    partnership_targets: ["Wealth management firms and RIAs", "Private banks", "Women's wealth divisions (UBS, Morgan Stanley, RBC, Goldman Sachs)", "ESG-focused advisory practices", "Art banking and collecting advisory services", "Digital asset advisory firms"],
    contact: "https://alternativeassetliteracy.com/contact.html",
    note: "Educational content only. Not financial advice."
  }
};

function handleAudienceProfile(audienceType) {
  if (!audienceType) {
    return {
      error: "Please provide an audience type.",
      available: Object.keys(AUDIENCE_PROFILE_DATA),
      hint: "Try: hnw-women, art, behavioral, defi, esg, etf, advisor-client, advisor-b2b"
    };
  }
  const key = audienceType.toLowerCase().replace(/\s+/g, "-");
  if (AUDIENCE_PROFILE_DATA[key]) return AUDIENCE_PROFILE_DATA[key];

  // Partial match
  for (const [id, profile] of Object.entries(AUDIENCE_PROFILE_DATA)) {
    if (id.includes(key) || key.includes(id) || profile.label.toLowerCase().includes(key)) {
      return profile;
    }
  }

  return {
    error: `No profile found for "${audienceType}".`,
    available: Object.keys(AUDIENCE_PROFILE_DATA),
    hint: "Try: hnw-women, art, behavioral, defi, esg, etf, advisor-client, advisor-b2b"
  };
}

function handleAudienceMatch(description) {
  if (!description) return { error: "Please provide a description of the user or investor." };
  const descLower = description.toLowerCase();

  const scores = {};
  for (const [id, profile] of Object.entries(AUDIENCE_PROFILE_DATA)) {
    let score = 0;
    for (const signal of profile.signals) {
      if (descLower.includes(signal)) score += signal.split(" ").length; // weight multi-word signals higher
    }
    scores[id] = score;
  }

  const ranked = Object.entries(scores).sort((a, b) => b[1] - a[1]);
  const topId = ranked[0][0];
  const topScore = ranked[0][1];

  if (topScore === 0) {
    return {
      matched_profile: null,
      note: "No strong signal match. Try describing the investor's wealth level, interests, or goals.",
      all_profiles: Object.keys(AUDIENCE_PROFILE_DATA)
    };
  }

  const profile = AUDIENCE_PROFILE_DATA[topId];
  const alternatives = ranked.slice(1, 3).filter(([, s]) => s > 0).map(([id]) => ({
    id,
    label: AUDIENCE_PROFILE_DATA[id].label
  }));

  return {
    matched_profile: profile.id,
    label: profile.label,
    description: profile.description,
    discovery_file: profile.discovery_file,
    recommended_start: profile.start_module,
    toolkit_priority: profile.toolkit_priority,
    alternative_matches: alternatives,
    note: "Educational content only. Not financial advice."
  };
}

// ============================================================
// GEOGRAPHIC DATA — Module-to-Geography and HNW Submarket
// ============================================================

const GEO_MODULE_DATA = {
  "behavioral-economics": {
    title: "Behavioral Economics & Investment Psychology",
    module_id: "mod_behavioral",
    status: "live",
    primary_hubs: [
      {
        city: "Chicago",
        country: "US",
        region: "Illinois",
        detail: "University of Chicago Booth School (Hyde Park) — birthplace of behavioral economics; Richard Thaler (Nobel 2017); Fama-Miller Center hosts the annual Conference in Behavioral Finance and Decision Making. CME Group, Morningstar.",
        institutions: ["University of Chicago Booth School", "Fama-Miller Center", "CME Group", "Morningstar"]
      },
      {
        city: "Cambridge",
        country: "US",
        region: "Massachusetts",
        detail: "Harvard University: Cass Sunstein (co-author of Nudge), Harvard Kennedy School Behavioral Insights Group. MIT (David Laibson). Cambridge is the East Coast center of behavioral economics.",
        institutions: ["Harvard Kennedy School", "MIT", "Harvard Law School"]
      },
      {
        city: "Princeton",
        country: "US",
        region: "New Jersey",
        detail: "Home to the late Daniel Kahneman (Nobel 2002), father of prospect theory and cognitive bias research. Princeton psychology and economics departments remain central to the field.",
        institutions: ["Princeton University"]
      },
      {
        city: "New Haven",
        country: "US",
        region: "Connecticut",
        detail: "Yale University: Robert Shiller (Nobel 2013), irrational exuberance, narrative economics, behavioral macrofinance. Cowles Foundation supports ongoing behavioral finance research.",
        institutions: ["Yale University", "Cowles Foundation"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "LSE Department of Economics and Psychological and Behavioural Science — strongest European academic center outside the US. UK Behavioural Insights Team (BIT) originated at 70 Whitehall. Morgan Stanley, Merrill Lynch, and major banks apply behavioral finance in wealth management.",
        institutions: ["London School of Economics", "UK Behavioural Insights Team", "Morgan Stanley International"]
      }
    ],
    secondary_hubs: [
      "Durham NC (Duke/Ariely Center for Advanced Hindsight)",
      "Pittsburgh PA (Carnegie Mellon Tepper — joint PhD in behavioral economics)",
      "Ithaca NY (Cornell BEDR)",
      "Berkeley CA (UC Berkeley Haas)",
      "Cambridge UK (El-Erian Institute at Cambridge Judge)",
      "Paris France (OECD Behavioural Insights, 16th arrondissement)",
      "Washington DC (SBST White House, World Bank behavioral team, ideas42)",
      "New York City (Morgan Stanley behavioral finance, Bernstein, Merrill Lynch)",
      "Boston (Fidelity, Wellington, MFS, State Street asset management)",
      "Copenhagen Denmark (iNudgeyou / Nudge Network)"
    ],
    key_conferences: [
      "Behavioral Finance Conference (Chicago Booth Fama-Miller Center, annual)",
      "BeFi Summit (virtual; practitioner reach across NYC, Boston, Chicago)",
      "Society for Judgment and Decision Making (SJDM, annual, rotates US cities)",
      "CFA Institute Annual Conference (behavioral finance standing track)",
      "Morningstar Investment Conference (Chicago; strong behavioral programming)"
    ],
    women_networks: [
      "Morgan Stanley 'Women and Investing' behavioral finance research (NYC)",
      "Behavioral Finance Working Group (London-based; gender and investing research)",
      "Alternative Asset Literacy behavioral module: investment psychology of women investors, confidence gap research, trading behavior differences"
    ],
    discovery_keywords: ["behavioral finance", "behavioral economics", "cognitive bias", "prospect theory", "loss aversion", "nudge theory", "mental accounting", "heuristics", "irrational exuberance", "investment psychology"]
  },

  "gender-lens-investing": {
    title: "Gender Lens Investing & Women and Investing",
    module_id: "mod_gender",
    status: "live",
    primary_hubs: [
      {
        city: "San Francisco",
        country: "US",
        region: "California",
        detail: "Strongest US ecosystem for gender lens venture investing. All Raise (HQ in SF and Sand Hill Road), Urban Innovation Fund (top 1% performing VC, women-owned), Female Founders Fund, Operator Collective (Mallun Yen). Sand Hill Road in Menlo Park is the structural hub for LP relationships with women-led funds.",
        institutions: ["All Raise", "Female Founders Fund", "Operator Collective", "Parity Partners", "Tory Burch Foundation"]
      },
      {
        city: "New York City",
        country: "US",
        region: "New York",
        detail: "NY leads US cities for female VC partner representation (19.7%). Ellevate Network (280,000+ global members, global HQ in NYC), Criterion Institute, GIIN (Global Impact Investing Network), Women's World Banking, Ms. Foundation for Women.",
        institutions: ["Ellevate Network", "Criterion Institute", "GIIN", "Women's World Banking", "100 Women in Finance NY"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "Most significant non-US hub (18.3% of VC partners are women). Level 20 (premier women-in-private-equity organization in Europe, headquartered in London). Women in Finance Charter (HM Treasury). British International Investment (BII, formerly CDC Group) — primary 2X Challenge DFI.",
        institutions: ["Level 20", "British International Investment", "Octopus Ventures", "Pipeline Angels"]
      },
      {
        city: "Washington DC",
        country: "US",
        region: "District of Columbia",
        detail: "HQ city for major DFIs driving global gender lens investing: US International Development Finance Corporation (DFC), World Bank Group IFC 2X Initiative, We-Fi. GenderSmart Investing Summit primary location.",
        institutions: ["DFC (US International Development Finance Corporation)", "World Bank IFC", "Center for Global Development"]
      },
      {
        city: "The Hague / Amsterdam",
        country: "Netherlands",
        region: "South Holland / North Holland",
        detail: "FMO (Netherlands Development Finance Company, The Hague) is a 2X Challenge founding DFI. The Hague anchors European gender lens capital. Amsterdam hosts European PE and sustainable finance community.",
        institutions: ["FMO", "European Investment Bank (Brussels/Luxembourg)"]
      }
    ],
    secondary_hubs: [
      "Cambridge MA (Harvard Kennedy School Women and Public Policy Program, MIT Sloan)",
      "Philadelphia PA (Wharton Center for Impact Finance)",
      "Oxford UK (Saïd Business School Gender, Work, and Organisation research)",
      "Geneva / Zurich (IFC gender finance team, UBS Gender Lens Investment Report, WEF Davos gender parity working group)",
      "Brussels Belgium (European Commission gender finance policy)",
      "Paris France (Bpifrance women's entrepreneurship, Station F women-focused VC)",
      "Nairobi Kenya (GenderSmart Africa, Rising Tide Africa)",
      "Manila Philippines (Asian Development Bank)",
      "Singapore (Women in Finance Asia)",
      "Boston MA (Portfolia, Harvard WE@HBS, MIT $100K Competition)"
    ],
    key_conferences: [
      "GenderSmart Investing Summit (Washington DC primary; secondary in Nairobi and London)",
      "GIIN Forum (New York, annual; gender lens is a featured track)",
      "PRI in Person (rotating; 2026 Amsterdam; gender lens is a standard session)",
      "All Raise VC Summit (San Francisco, annual)",
      "Women's Forum for the Economy and Society (Deauville France, annual)",
      "Level 20 Annual Summit (London, annual)",
      "Kayo Women's Investing Summit (New York, annual)"
    ],
    women_networks: [
      "Level 20 — London (women in private equity; Europe-wide)",
      "All Raise — San Francisco (women and non-binary VC investors)",
      "Ellevate Network — NYC HQ (280,000+ global members)",
      "100 Women in Finance — chapters in NY, London, SF, Chicago, Singapore, Hong Kong, Dubai, Paris, Frankfurt, Zurich",
      "Women in Finance Asia (WIFA) — Singapore and Hong Kong",
      "GenderSmart Investing Network — Washington DC"
    ],
    discovery_keywords: ["gender lens investing", "women investors", "female founders", "2X Challenge", "women in VC", "women in private equity", "impact investing women", "gender diversity investment"]
  },

  "defi-crypto": {
    title: "Decentralized Finance (DeFi) & Crypto",
    module_id: "mod_defi",
    status: "live",
    primary_hubs: [
      {
        city: "Zug",
        country: "Switzerland",
        region: "Zug Canton",
        detail: "Crypto Valley — world's most established and regulatory-sophisticated DeFi hub. Lowest corporate tax rates in Switzerland (~11.85%). Bitcoin payments accepted for government fees. Crypto Valley Association (1,000+ blockchain companies). Ethereum Foundation, Cardano Foundation, Tezos Foundation, Web3 Foundation (Polkadot) all registered in Zug. CV VC (Crypto Valley Venture Capital). FINMA provides clear DeFi regulatory frameworks from Bern HQ.",
        institutions: ["Crypto Valley Association", "Ethereum Foundation", "Cardano Foundation", "Tezos Foundation", "Web3 Foundation", "CV VC"]
      },
      {
        city: "Singapore",
        country: "Singapore",
        region: "Southeast Asia",
        detail: "25%+ adult crypto ownership; MAS licensing framework (most DeFi-progressive major central bank regulator). Marina Bay Financial Centre and One-North/Biopolis host blockchain startups. Crypto.com HQ in Singapore. 68% crypto penetration projected 2026. Relevant to DeFi module's regulatory and institutional content.",
        institutions: ["Monetary Authority of Singapore (MAS)", "Crypto.com", "Coinbase APAC"]
      },
      {
        city: "Miami",
        country: "US",
        region: "Florida",
        detail: "$1.2B in crypto deals across 80+ blockchain startups (2025). Wynwood district: Blockchain Institute of Technology (BIT), BitBasel, Gemini Miami office. Annual Bitcoin Conference (Miami Beach Convention Center). Brickell financial district intersects with crypto markets.",
        institutions: ["Blockchain Institute of Technology", "Gemini (Miami)", "Bitcoin Conference"]
      },
      {
        city: "Dubai",
        country: "UAE",
        region: "Middle East",
        detail: "Dubai's Virtual Assets Regulatory Authority (VARA, est. 2022) — world's first dedicated crypto regulator. DIFC and DMCC Free Zone host major crypto and blockchain firms. DMCC Crypto Centre (JLT district) — 600+ crypto and blockchain companies. Token2049, Consensus, and Future Blockchain Summit are held in Dubai.",
        institutions: ["VARA (Virtual Assets Regulatory Authority)", "DMCC Crypto Centre", "Gate.io", "OKX"]
      },
      {
        city: "Hong Kong",
        country: "China (SAR)",
        region: "Asia-Pacific",
        detail: "Re-emerged as major crypto hub following 2023 SFC regulatory pivot to allow retail crypto trading. Central and Admiralty districts host licensed Virtual Asset Service Providers (VASPs). Primary gateway for Asia-Pacific institutional DeFi.",
        institutions: ["Securities and Futures Commission (SFC)", "HashKey Exchange", "OSL"]
      }
    ],
    secondary_hubs: [
      "Austin TX (Consensus conference, Austin Convention Center; South Congress crypto community)",
      "New York City (Galaxy Digital Midtown HQ; Gemini Flatiron; Grayscale Stamford CT nearby)",
      "Lisbon Portugal (crypto nomad hub; Chiado and Príncipe Real neighborhoods; Web Summit ecosystem)",
      "Tallinn Estonia (e-residency pioneer; Baltic crypto hub)",
      "Amsterdam Netherlands (Zuidas financial district; Rockaway Blockchain Fund European presence)",
      "Seoul South Korea (Gangnam-gu — Upbit, Bithumb, Klaytn; Teheran-ro 'Silicon Valley of Korea')",
      "Tokyo Japan (Shibuya district; Japan FSA clear regulatory framework)",
      "Buenos Aires Argentina (highest per-capita DeFi use in LatAm; Palermo Soho informal hub)",
      "Ibiza Spain (European crypto founders summer residence; Santa Gertrudis and Santa Eulalia del Río)",
      "Isle of Man UK (0% CGT, 0% inheritance tax; clear digital asset regulatory framework; family office relocations)"
    ],
    key_conferences: [
      "Bitcoin Conference (Miami, annual — Miami Beach Convention Center)",
      "Consensus (Austin TX, annual; also Hong Kong and London events)",
      "Token2049 (Dubai and Singapore, semiannual)",
      "ETHDenver (Denver CO, annual — Art Hotel and McNichols Building)",
      "Science of Blockchain Conference (SBC) (Berkeley CA, annual)",
      "Web Summit (Lisbon Portugal, annual — crypto as a major track)",
      "Korea Blockchain Week (Seoul, annual — Gangnam-gu venues)",
      "Paris Blockchain Week (Paris, annual — Paris Event Center 19th arr.)"
    ],
    women_networks: [
      "Women in Crypto and Blockchain (multiple US chapter cities)",
      "Women in Finance Asia (WIFA) — Singapore chapter covers DeFi/digital assets",
      "100 Women in Finance — DeFi/digital asset panels at annual conferences",
      "Crypto4Her — global women's community in crypto"
    ],
    discovery_keywords: ["DeFi", "decentralized finance", "crypto", "cryptocurrency", "blockchain", "Web3", "smart contracts", "NFT", "Ethereum", "Bitcoin", "digital assets", "yield farming", "staking", "CBDC"]
  },

  "esg-climate": {
    title: "ESG, Climate Finance & Sustainable Investing",
    module_id: "mod_esg_climate",
    status: "live",
    primary_hubs: [
      {
        city: "Amsterdam",
        country: "Netherlands",
        region: "North Holland",
        detail: "Ranked world's top green financial hub (Global Green Finance Index). Euronext Amsterdam is the largest venue for sustainable bond listings in Europe. Major Dutch asset managers — APG, PGGM, NN Investment Partners — are among the largest ESG allocators globally. ABN AMRO and ING headquarters. Global Reporting Initiative (GRI) European liaison. ISSB co-anchor for EU.",
        institutions: ["APG", "PGGM", "NN Investment Partners", "ABN AMRO", "ING", "Global Reporting Initiative (GRI)"]
      },
      {
        city: "Luxembourg",
        country: "Luxembourg",
        region: "Luxembourg",
        detail: "Luxembourg Green Exchange (LGX) — world's first and largest dedicated platform for sustainable finance instruments (1,400+ green/social/sustainable bonds listed). EU Green Bond Standard (EuGBS) implemented through Luxembourg's listing infrastructure. Premier European fund domicile — ESG fund structuring concentrated here.",
        institutions: ["Luxembourg Green Exchange (LGX)", "Quintet Private Bank", "Banque de Luxembourg"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "London Stock Exchange major green bond listing venue. Climate Bonds Initiative (CBI) HQ sets global green bond certification standards. Bank of England Climate Hub. City of London Green Finance Initiative. PRI (Principles for Responsible Investment), TCFD Secretariat, CDP (Carbon Disclosure Project) all headquartered in London.",
        institutions: ["Climate Bonds Initiative", "PRI (Principles for Responsible Investment)", "CDP", "TCFD Secretariat", "London Stock Exchange"]
      },
      {
        city: "Paris",
        country: "France",
        region: "Île-de-France",
        detail: "Paris Agreement (2015, COP21) was signed here — symbolic capital of climate finance. French AMF implements SFDR and EU Taxonomy from Paris HQ. Caisse des Dépôts and BNP Paribas are largest French ESG capital allocators. OECD (16th arrondissement) Green Finance Platform. OECD Behavioural Insights Team.",
        institutions: ["AMF (Autorité des marchés financiers)", "BNP Paribas", "Caisse des Dépôts", "OECD Green Finance Platform"]
      },
      {
        city: "Geneva",
        country: "Switzerland",
        region: "Geneva Canton",
        detail: "UNEP FI (UN Environment Programme Finance Initiative, Châtelaine district) — primary UN body coordinating ESG standards across financial sector. Sustainable Finance Geneva (80+ institutions). Task Force on Climate-related Financial Disclosures (TCFD) coordination bodies. Global Reporting Initiative European liaison.",
        institutions: ["UNEP FI", "Sustainable Finance Geneva", "TCFD coordination bodies"]
      }
    ],
    secondary_hubs: [
      "New York City (GIIN HQ tracking $1.1T+ in impact assets, Bloomberg ESG data, MSCI ESG data, Columbia Climate School)",
      "Tokyo Japan (GPIF — world's largest pension fund ¥214T, full ESG integration; METI GX Green Transformation policy)",
      "Stockholm Sweden (Nordea, SEB, Handelsbanken most advanced ESG integrators; Östermalm financial district)",
      "Brussels Belgium (EU Sustainable Finance Taxonomy, SFDR, CSRD — drafted from Berlaymont; ESMA offices)",
      "Nairobi Kenya (UNEP headquarters, Gigiri district — only UN major body in developing country)",
      "Frankfurt Germany (ISSB primary seat; BaFin oversight of ESG fund disclosure; Deutsche Börse sustainability index)",
      "Oxford UK (Oxford Sustainable Finance Group, Smith School; Oxford Sustainable Finance Summit)",
      "Boston MA (GreenFin Conference; Harvard Management Company ESG integration)",
      "Copenhagen Denmark (Novo Nordisk Foundation extensive ESG programs; leading Scandinavian ESG market)"
    ],
    key_conferences: [
      "PRI in Person (rotating; 2025 São Paulo; 2026 Amsterdam, Oct 13-15, Beurs van Berlage)",
      "COP (UN Climate Change Conference, rotating; government-facing; central to climate finance policy)",
      "Bloomberg Sustainable Business Summit (New York City, annual)",
      "Sustainable Investment Forum (SIF) Europe (Paris, annual)",
      "Impact Summit Europe (The Hague, annual)",
      "GreenFin Conference (Boston/New York area, annual)",
      "Climate Week NYC (New York City, annual September, parallel to UNGA)"
    ],
    women_networks: [
      "Women in Sustainable Finance (WISF) — London-based, global chapters",
      "GIIN Gender Lens Investing Network — New York",
      "Inspiring More Sustainability (IMS) — Luxembourg chapter",
      "Nordic Women in Finance Network — Stockholm, Oslo, Copenhagen"
    ],
    discovery_keywords: ["ESG", "environmental social governance", "sustainable investing", "green bonds", "climate finance", "impact investing", "SFDR", "TCFD", "carbon credits", "net zero", "UN SDGs", "responsible investing", "green taxonomy"]
  },

  "art-investing": {
    title: "Art as Investment & the Art Market",
    module_id: "mod_art",
    status: "live",
    primary_hubs: [
      {
        city: "New York City",
        country: "US",
        region: "New York",
        detail: "World's largest art auction market by value. Christie's Americas at 20 Rockefeller Plaza; Sotheby's at 1334 York Avenue (UES); Phillips at 432 Park Avenue. Chelsea Arts District (W 18th–28th, 10th–11th Avenues): David Zwirner, Pace Gallery, Hauser & Wirth, Gagosian. Upper East Side (Madison Ave 60th–86th): secondary market galleries and Old Masters dealers. Frieze New York (May, The Shed, Hudson Yards). TEFAF New York (May, Park Avenue Armory).",
        institutions: ["Christie's Americas", "Sotheby's New York", "Phillips Americas", "David Zwirner", "Gagosian", "Hauser & Wirth", "Pace Gallery"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "Christie's London at King Street, St. James's (oldest Christie's address, continuous since 1766). Sotheby's at 34-35 New Bond Street, Mayfair. Phillips London at 30 Berkeley Square. Mayfair gallery corridor: Gagosian (Grosvenor Hill), Zwirner (Grafton St), Hauser & Wirth (Savile Row), White Cube (Mason's Yard). Frieze London and Frieze Masters (October, Regent's Park).",
        institutions: ["Christie's London", "Sotheby's London", "Phillips London", "Gagosian London", "Hauser & Wirth London", "White Cube"]
      },
      {
        city: "Hong Kong",
        country: "China (SAR)",
        region: "Asia-Pacific",
        detail: "Asia's primary art auction market. Zero duty on wine and art since 2008. Sotheby's flagship at Landmark Chater (Central). Christie's in Henderson building (Central, Zaha Hadid, 50,000 sq ft). Phillips in WKCDA Tower (West Kowloon). Art Basel Hong Kong (March, HKCEC Wan Chai). West Kowloon Cultural District (M+ Museum, Hong Kong Palace Museum).",
        institutions: ["Sotheby's Hong Kong", "Christie's Hong Kong", "Phillips Asia", "Art Basel Hong Kong", "M+ Museum"]
      },
      {
        city: "Paris",
        country: "France",
        region: "Île-de-France",
        detail: "Christie's Paris at 9 Avenue Matignon (8th arrondissement). Artcurial at 7 Rond-Point des Champs-Élysées. Gallery districts: Marais (3rd/4th arr., near Pompidou — David Zwirner, Galerie Perrotin, Galerie Chantal Crousel), Saint-Germain (6th arr., Rue de Seine, Galerie Templon, Galerie Lelong). Art Basel Paris (October, Grand Palais).",
        institutions: ["Christie's Paris", "Artcurial", "Galerie Perrotin", "Galerie Templon", "Art Basel Paris"]
      },
      {
        city: "Basel",
        country: "Switzerland",
        region: "Basel-Stadt Canton",
        detail: "Art Basel (June, Messe Basel) — the world's most important contemporary art fair. Kunstmuseum Basel patrons. Local and international collector community.",
        institutions: ["Art Basel", "Kunstmuseum Basel"]
      }
    ],
    secondary_hubs: [
      "Miami FL (Art Basel Miami Beach December; Pérez Art Museum PAMM; Wynwood arts district; Brickell gallery scene)",
      "Los Angeles CA (Gagosian, Hauser & Wirth satellite events; LACMA; The Broad; entertainment-linked collecting; Beverly Hills gallery corridor)",
      "Geneva Switzerland (Freeport Geneva near Meyrin — $100B+ in art storage; Pictet & Cie, Lombard Odier art banking; Art Geneva fair)",
      "Seoul South Korea (Kiaf/Frieze Seoul, September, COEX Gangnam-gu; growing Asian collector community)",
      "Dubai UAE (Art Dubai May, Madinat Jumeirah; DIFC Art Nights; Gate Village gallery district)",
      "Singapore (ArtSG January, Marina Bay Sands; Julius Baer, UBS, DBS art-secured lending)",
      "Maastricht Netherlands (TEFAF March — world's premier fine art and antiques fair; MECC)",
      "Turin Italy (Artissima November)",
      "São Paulo Brazil (SP-Arte April)"
    ],
    key_conferences: [
      "Art Basel (Basel Switzerland, June)",
      "Art Basel Miami Beach (December)",
      "Art Basel Hong Kong (March)",
      "Art Basel Paris (October, Grand Palais)",
      "Frieze London (October, Regent's Park)",
      "Frieze New York (May, The Shed, Hudson Yards)",
      "TEFAF Maastricht (March, MECC)",
      "The Armory Show (New York, September, Javits Center)",
      "Art Dubai (May, Madinat Jumeirah)",
      "ArtSG (Singapore, January, Marina Bay Sands)"
    ],
    women_networks: [
      "Sotheby's Institute of Art (MA in Art Business) — New York",
      "Museum Women's Boards — Metropolitan Museum, Art Institute of Chicago, Tate, MoMA",
      "Art Institute of Chicago Women's Board (one of the most prestigious volunteer organizations in Chicago)",
      "Christie's Financial Services — art lending advisory for women collectors",
      "Fondazione Furla (Milan) — women's-led art foundation supporting young artists",
      "Fondazione Prada (Milan) — Miuccia Prada, model of HNW women's arts philanthropy"
    ],
    discovery_keywords: ["art investing", "art market", "art auction", "art funds", "collectibles", "fine art investment", "contemporary art", "Old Masters", "art as asset class", "art fair", "gallery", "auction house", "art advisory", "blue-chip art"]
  },

  "alternative-assets": {
    title: "Alternative Assets: Private Equity, Real Assets & Commodities",
    module_id: "mod_alt",
    status: "live",
    primary_hubs: [
      {
        city: "New York City",
        country: "US",
        region: "New York",
        detail: "Global capital of private equity by AUM. Blackstone (345 Park Ave), KKR (30 Hudson Yards), Apollo Global Management (9 W 57th St), Warburg Pincus (450 Lexington Ave), Carlyle (520 Madison Ave). Park Avenue corridor 42nd–59th Street is the most PE-dense real estate in the world. 384,500 millionaires; 21,714 UHNW individuals ($30M+). Deepest family office concentration in the US.",
        institutions: ["Blackstone", "KKR", "Apollo Global Management", "Warburg Pincus", "Carlyle Group", "Ares Management"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "Europe's primary PE hub. CVC Capital Partners, Advent International, Bridgepoint, Apax Partners, Permira, BC Partners, Cinven all headquartered in London (primarily Mayfair — Berkeley Square, Grosvenor Street, W1J/W1S postcodes). Level 20 (women in European PE) based in London. BVCA (British Private Equity & Venture Capital Association) at 3 Clements Inn.",
        institutions: ["CVC Capital Partners", "Apax Partners", "Permira", "BC Partners", "Cinven", "Level 20", "BVCA"]
      },
      {
        city: "Boston",
        country: "US",
        region: "Massachusetts",
        detail: "Bain Capital (200 Clarendon Street, Back Bay), Audax Private Equity, TA Associates, Summit Partners, Berkshire Partners. PE culture deeply connected to Harvard Business School (Allston campus) and MIT Sloan.",
        institutions: ["Bain Capital", "Audax Private Equity", "TA Associates", "Summit Partners"]
      },
      {
        city: "Singapore",
        country: "Singapore",
        region: "Southeast Asia",
        detail: "Asia's fastest-growing PE and family office hub. Temasek (Orchard Road) and GIC (St. George's Road) manage $700B+ combining PE, infrastructure, and global alternatives. Marina Bay Financial Centre hosts dozens of regional PE fund managers. 2,500+ family offices as of 2025 — leads globally in family office count, exceeding New York by 2.5x.",
        institutions: ["Temasek", "GIC", "Marina Bay Financial Centre"]
      },
      {
        city: "Chicago",
        country: "US",
        region: "Illinois",
        detail: "Thoma Bravo (HQ Chicago), GTCR, Madison Dearborn Partners. Chicago PE firms invest $100B+ annually. The Loop and River North neighborhoods anchor the Chicago PE community.",
        institutions: ["Thoma Bravo", "GTCR", "Madison Dearborn Partners"]
      }
    ],
    secondary_hubs: [
      "San Francisco / Menlo Park CA (Vista Equity, Francisco Partners, Insight Partners; Sand Hill Road growth equity)",
      "Hong Kong SAR (PAG, Hillhouse Capital, MBK Partners; Admiralty and Central districts)",
      "Zurich / Geneva Switzerland (world's largest cross-border private banking center; Rue du Rhône, Zurichberg)",
      "Toronto Canada (Brookfield Asset Management — global infrastructure and real assets leader, Bay Street)",
      "Sydney Australia (Macquarie Asset Management — infrastructure, Martin Place)",
      "Dubai UAE (DIFC — 75% of Middle East family offices; Gate Village)",
      "Paris France (Ardian; Antin Infrastructure Partners HQ; La Défense financial district)"
    ],
    key_conferences: [
      "PEI Private Equity New York Forum (annual)",
      "SuperReturn International (Berlin, annual — Europe's premier PE conference)",
      "IPEM (Cannes, annual — private equity, venture, infrastructure, credit)",
      "Milken Institute Global Conference (Beverly Hills, annual — alternatives featured)",
      "Private Wealth Forum (New York, annual)"
    ],
    women_networks: [
      "Level 20 — London (women in European private equity)",
      "100 Women in Finance — New York chapter (450+ professionals, primary networking for women in alternatives)",
      "Women Advisor Summit New York (annual)",
      "Ellevate Network — NYC HQ (280,000+ global members)",
      "Campden Wealth European Family Office Forum — significant women's family office leadership representation"
    ],
    discovery_keywords: ["private equity", "alternative assets", "real assets", "infrastructure investing", "hedge funds", "family office", "commodities", "private credit", "real estate investing", "REIT", "private markets", "GP LP", "carried interest", "buyout fund"]
  },

  "wine-investing": {
    title: "Wine & Vineyard Investing",
    module_id: "mod_wine",
    status: "future",
    primary_hubs: [
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "Global center of fine wine investment infrastructure. Liv-ex (London International Vintners Exchange, Borough Market / London Bridge area) — world's primary wine trading platform and Liv-ex 100 benchmark index. Christie's Wine Department (King Street, St. James's), Sotheby's Wine (New Bond Street), Bonhams Wine (22 Baker Street). Berry Bros. & Rudd (3 St. James's Street, est. 1698). Farr Vintners, Justerini & Brooks. Cult Wines, Vin-X, WineCap all London-based.",
        institutions: ["Liv-ex", "Christie's Wine", "Sotheby's Wine", "Berry Bros. & Rudd", "Farr Vintners", "Cult Wines", "WineCap"]
      },
      {
        city: "Bordeaux",
        country: "France",
        region: "Gironde",
        detail: "En primeur system — world's only futures market for wine. Château tastings in Pauillac, Saint-Émilion, and Pomerol during primeur week (April–June). Place de Bordeaux négociant trading system through merchant houses in the Chartrons district (Quai des Chartrons). Sets global fine wine pricing benchmarks.",
        institutions: ["Place de Bordeaux", "Chartrons négociants"]
      },
      {
        city: "Hong Kong",
        country: "China (SAR)",
        region: "Asia-Pacific",
        detail: "World's most active fine wine auction market by lots sold since 2008 duty removal. Christie's, Sotheby's, and Zachys maintain significant HK wine auction operations. Asian buyers make up 32% of global Sotheby's wine sales. Zero import duty on wine. Central and Admiralty districts.",
        institutions: ["Christie's Hong Kong", "Sotheby's Hong Kong", "Zachys Hong Kong"]
      }
    ],
    secondary_hubs: [
      "New York City (Acker — world's highest-grossing fine wine auction house, 22 E 72nd St UES; Zachys White Plains NY)",
      "Burgundy France (Côte d'Or — highest per-unit-value investment region globally; DRC, Gevrey-Chambertin, Vosne-Romanée)",
      "Napa Valley CA (Screaming Eagle, Harlan Estate, Opus One, Dominus; Auction Napa Valley)",
      "Singapore (Christie's Asia wine operations; growing market)",
      "Tokyo Japan (Acker Tokyo auctions; growing Japanese collector market for Burgundy and Bordeaux)",
      "Edinburgh Scotland (Bonhams whisky and wine auctions, George Street; Bonhams primary)"
    ],
    key_conferences: [
      "Auction Napa Valley (June, St. Helena CA — premier charity wine auction in North America)",
      "Vinexpo Paris (biennial)",
      "London Wine Fair (annual)",
      "Decanter Fine Wine Encounter (London, annual)"
    ],
    women_networks: [
      "Les Dames d'Escoffier International — chapters in NYC, Chicago, LA, San Francisco",
      "Women for WineSense — chapters across US cities",
      "Court of Master Sommeliers women's chapters — London, New York, Chicago, San Francisco"
    ],
    discovery_keywords: ["wine investing", "fine wine investment", "en primeur", "wine auction", "Bordeaux wine", "Burgundy wine", "Liv-ex", "wine fund", "collectible wine", "wine as asset"]
  },

  "whisky-investing": {
    title: "Whisky & Whiskey Investing",
    module_id: "mod_whisky",
    status: "future",
    primary_hubs: [
      {
        city: "Speyside",
        country: "UK",
        region: "Moray, Scotland",
        detail: "Most important investment region for Scotch whisky by volume. Benchmark brands: Glenfiddich (Dufftown), The Glenlivet (Glenlivet village), The Macallan (Easter Elchies Estate, Craigellachie). The Macallan is the single most important investment-grade whisky globally; 1926 The Macallan holds the world record auction price for a spirit.",
        institutions: ["The Macallan", "Glenfiddich", "The Glenlivet", "WhiskyInvestDirect", "Braeburn Whisky (Dufftown)"]
      },
      {
        city: "Edinburgh",
        country: "UK",
        region: "Scotland",
        detail: "Bonhams Whisky (George Street) — leading traditional auction house for premium Scotch; primary events held in Edinburgh. Whisky Auctioneer (Perth) — world's highest-volume online whisky auction platform; primary price discovery mechanism.",
        institutions: ["Bonhams Whisky Edinburgh", "Whisky Auctioneer Perth", "Cask Trade Edinburgh"]
      },
      {
        city: "Louisville",
        country: "US",
        region: "Kentucky",
        detail: "Spiritual and commercial capital of bourbon investment. Kentucky Bourbon Trail: Buffalo Trace (Frankfort), Heaven Hill (Bardstown), Four Roses (Lawrenceburg), Maker's Mark (Loretto), Willett (Bardstown). Pappy Van Winkle (Buffalo Trace) — primary investment-grade bourbon.",
        institutions: ["Buffalo Trace Distillery", "Heaven Hill", "Willett Distillery"]
      }
    ],
    secondary_hubs: [
      "Islay Scotland (Ardbeg, Lagavulin, Laphroaig, Bowmore; Fèis Ìle annual festival; Port Ellen vintage bottles)",
      "Tokyo Japan (primary Japanese whisky investment market; rare Karuizawa and Hanyu; Bonhams and Christie's Tokyo specialist sales)",
      "Osaka Japan (Suntory Yamazaki Distillery, Shimamoto; Yamazaki 55-year-old holds Japanese auction record)",
      "Glasgow Scotland (McTear's Auction — major Scottish auction house)",
      "London (Christie's Whisky; WhiskyInvestDirect HQ; New Bond Street Bonhams)",
      "Chicago IL (largest bourbon collector community in US outside Kentucky; Chicago Whisky Society)"
    ],
    key_conferences: [
      "Fèis Ìle — Islay Festival (May/June, Islay Scotland — limited-release investment bottles)",
      "Whisky Live Singapore (annual — growing Southeast Asian market)",
      "Spirit of Speyside Whisky Festival (annual, Speyside)"
    ],
    women_networks: [
      "Les Dames d'Escoffier International — NYC, Chicago, LA, SF chapters (includes spirits)",
      "Court of Master Sommeliers women's chapters — London, New York"
    ],
    discovery_keywords: ["whisky investing", "Scotch whisky investment", "whisky auction", "cask investment", "single malt", "bourbon investing", "collectible spirits", "The Macallan", "Japanese whisky", "Pappy Van Winkle"]
  },

  "vc-gender-lens": {
    title: "Venture Capital & Private Equity — Gender Lens",
    module_id: "mod_vc_gender",
    status: "future",
    primary_hubs: [
      {
        city: "San Francisco / Bay Area",
        country: "US",
        region: "California",
        detail: "Global center of women in venture capital. All Raise (SF and Sand Hill Road), Female Founders Fund, Operator Collective (Mallun Yen, enterprise AI VC), Parity Ventures, BBG Ventures. UC Berkeley Haas and Stanford GSB are the primary academic pipelines.",
        institutions: ["All Raise", "Female Founders Fund", "Operator Collective", "Parity Ventures"]
      },
      {
        city: "New York City",
        country: "US",
        region: "New York",
        detail: "Female VC partner representation (19.7%) exceeds Silicon Valley (13.2%). Major women-in-finance networks: 100 Women in Finance (450+ professionals), Ellevate Network, Astia (women-led high-growth companies).",
        institutions: ["100 Women in Finance", "Ellevate Network", "Astia"]
      },
      {
        city: "London",
        country: "UK",
        region: "England",
        detail: "Level 20 — premier women-in-private-equity organization in Europe, headquartered in London. Atomico and Balderton Capital both have public gender diversity commitments. Women in Finance Charter applies to PE and VC firms. London female VC partner representation (18.3%) is second highest globally.",
        institutions: ["Level 20", "Atomico", "Balderton Capital"]
      }
    ],
    secondary_hubs: [
      "Paris France (female VC partner representation 17.1% — third highest globally; Bpifrance women's entrepreneurship; Station F 13th arrondissement)",
      "Boston MA (Portfolia women-led consumer VC; Harvard WE@HBS; MIT $100K competition)",
      "Los Angeles CA (M13 Ventures, Mucker Capital gender diversity mandate; USC and UCLA women's entrepreneurship)",
      "Austin TX (Capital Factory women founders program; SXSW women in tech tracks)",
      "Toronto Canada (MaRS Discovery District; BDC Capital Women in Technology Venture Fund)",
      "Tel Aviv Israel (Rising Tide Israel women's VC fund; Viola Ventures)",
      "Nairobi Kenya (Rising Tide Africa — first female-led angel network; GenderSmart Africa)"
    ],
    key_conferences: [
      "All Raise VC Summit (San Francisco, annual)",
      "Level 20 Annual Summit (London, annual)",
      "Kayo Women's Investing Summit (New York, annual)",
      "SheEO World Summit (Toronto / virtual, annual)",
      "Women Entrepreneurs Finance Initiative (We-Fi) Summits (Washington DC and emerging market cities)"
    ],
    women_networks: [
      "All Raise — San Francisco",
      "Level 20 — London",
      "100 Women in Finance — New York, London, and global chapters",
      "Astia — women-led high-growth companies network"
    ],
    discovery_keywords: ["women in VC", "female founders", "gender lens venture capital", "women-led funds", "diversity in private equity", "women entrepreneurs", "impact VC", "all-female founding team"]
  },

  "biodynamic-agriculture": {
    title: "Biodynamic & Regenerative Agriculture Investing",
    module_id: "mod_biodynamic",
    status: "future",
    primary_hubs: [
      {
        city: "Northern California",
        country: "US",
        region: "California",
        detail: "Demeter USA HQ (Philomath, Oregon; significant activity in Napa Valley, Sonoma, Mendocino). UC Davis Agricultural Sustainability Institute (ASI) and SAREP — leading US academic programs. USDA Natural Resources Conservation Service presence in Sacramento. TIAA-NUVEEN Natural Capital (NYC HQ) is the largest institutional farmland investor globally.",
        institutions: ["Demeter USA", "UC Davis ASI", "USDA NRCS"]
      },
      {
        city: "Kutztown / Midwest",
        country: "US",
        region: "Pennsylvania / Great Plains",
        detail: "Rodale Institute (Kutztown PA) — organization that coined 'regenerative agriculture' in the 1980s. University of Nebraska–Lincoln and Kansas State University have strong sustainable agriculture research programs for large-scale grain and livestock operations.",
        institutions: ["Rodale Institute", "University of Nebraska-Lincoln", "Kansas State University"]
      },
      {
        city: "Stroud / Darmstadt",
        country: "UK / Germany",
        region: "Gloucestershire UK / Hesse Germany",
        detail: "Biodynamic Association (BDA) headquartered in Stroud, Gloucestershire — historic center of organic agriculture in Britain. Demeter International (global biodynamic certification) headquartered in Darmstadt, Germany. Wageningen University (Netherlands) — Europe's leading agricultural science university.",
        institutions: ["Biodynamic Association (BDA)", "Demeter International", "Wageningen University"]
      }
    ],
    secondary_hubs: [
      "Boulder CO (Savory Institute — holistic planned grazing; Rocky Mountain Institute regenerative food and agriculture finance)",
      "São Paulo Brazil (Catalytic Capital for Collective Transformation C4C; IFACC deforestation-free agriculture)",
      "Wageningen Netherlands (Wageningen University Centre for Crop Systems Analysis — EU's leading regenerative research)",
      "Singapore (Climate Impact X CIX — Southeast Asia's premier carbon exchange, est. 2021; backed by DBS, SGX, Standard Chartered)",
      "London (Gresham House forestry/sustainable land management; Foresight Group sustainable infrastructure)"
    ],
    key_conferences: [
      "Biodynamic Association Annual Conference (Stroud UK)",
      "Ecological Farming Conference (Pacific Grove CA, annual)",
      "NECFE New England Small Farm Summit (Massachusetts)",
      "Carbon Unbound (London, annual — voluntary carbon markets)"
    ],
    women_networks: [
      "Women Food and Agriculture Network (WFAN) — Iowa-based, US chapters",
      "The Demeter Association women farmers and producers network",
      "Daylesford Organic (Bamford family, Cotswolds UK) — intersection of sustainable luxury, land stewardship, and HNW female consumer identity"
    ],
    discovery_keywords: ["regenerative agriculture", "biodynamic farming", "sustainable agriculture investing", "farmland investment", "carbon credits", "nature-based solutions", "organic investing", "timberland", "natural capital", "impact agriculture"]
  }
};

// ============================================================
// HNW SUBMARKET DATA
// ============================================================

const GEO_HNW_DATA = {
  "new-york": {
    display: "New York City, USA",
    region: "US Northeast",
    relevant_modules: ["alternative-assets", "art-investing", "behavioral-economics", "gender-lens-investing", "esg-climate", "defi-crypto"],
    hubs: {
      "Upper East Side": {
        postcode: "10021 / 10028",
        detail: "Classical center of old-money Manhattan. Carnegie Hill (84th–98th St), Lenox Hill, Yorkville. Pre-war co-ops on Park Avenue, Fifth Avenue, Madison Avenue. Densest concentration of private foundations and family offices in the US. Metropolitan Museum, the Frick, Neue Galerie, 92nd Street Y anchor arts collecting. Sotheby's flagship at 1334 York Avenue; Christie's at 20 Rockefeller Plaza. TEFAF New York at Park Avenue Armory.",
        institutions: ["Metropolitan Museum of Art", "Sotheby's New York", "Frick Collection", "92nd Street Y"]
      },
      "Midtown (Park Avenue Corridor)": {
        postcode: "10022 / 10017",
        detail: "Primary address of wealth management firms and private banks. Morgan Stanley (1585 Broadway), UBS, JPMorgan Private Bank, Citi Private Bank, Goldman Sachs, Bernstein Private Wealth. The professional hub of HNW advisory services. Blackstone (345 Park Ave), KKR (30 Hudson Yards), Apollo (9 W 57th St).",
        institutions: ["Morgan Stanley", "JPMorgan Private Bank", "Blackstone", "KKR", "Apollo Global Management"]
      },
      "Chelsea / West Chelsea": {
        postcode: "10011",
        detail: "Highest concentration of major contemporary art galleries in the world: David Zwirner (W 19th & W 20th), Pace Gallery (W 25th), Hauser & Wirth (W 22nd), Gagosian (W 24th & W 21st). Frieze New York (The Shed, Hudson Yards). New corporate wealth anchored by relocated/expanded financial institutions.",
        institutions: ["David Zwirner", "Pace Gallery", "Hauser & Wirth", "Gagosian"]
      },
      "Tribeca / SoHo": {
        postcode: "10013 / 10012",
        detail: "Technology, media, entertainment, and startup-liquidity wealth. Post-exit founders and VC-backed entrepreneurs dominate. Significant concentration of art galleries and serious collectors; Tribeca is increasingly the residential address for art-world-adjacent UHNW. Younger UHNW (30s–50s) with higher alternative and digital asset exposure.",
        institutions: []
      }
    },
    womens_networks: [
      "100 Women in Finance — New York chapter (450+ finance leaders annually; primary body for women in alternatives)",
      "Women Advisor Summit New York (annual convening of women wealth advisors)",
      "Ellevate Network (280,000+ global members, strong NYC presence)",
      "Goldman Sachs Women Entrepreneurs Advisory",
      "Morgan Stanley Women & Investing",
      "UBS Women's Wealth"
    ],
    family_offices: "Deepest family office concentration in the US; Park Avenue, Midtown, Hudson Yards. 384,500 millionaires; 21,714 UHNW individuals ($30M+).",
    art_market: "World's largest art auction market by value. Christie's, Sotheby's, Phillips all with primary salesrooms here. Art Basel satellite programming draws international collectors."
  },

  "boston": {
    display: "Boston / Greater Boston, USA",
    region: "US Northeast",
    relevant_modules: ["behavioral-economics", "alternative-assets", "esg-climate", "gender-lens-investing"],
    hubs: {
      "Back Bay / Beacon Hill": {
        postcode: "02116 / 02108",
        detail: "Urban wealth equivalent to Manhattan's Upper East Side. Historic families, nonprofit executives, institutional investors. Isabella Stewart Gardner Museum anchors old-money art collecting culture. Bain Capital (200 Clarendon Street, Back Bay).",
        institutions: ["Isabella Stewart Gardner Museum", "Bain Capital", "Boston Athenaeum"]
      },
      "Cambridge (Harvard / MIT adjacency)": {
        postcode: "02138",
        detail: "Harvard University (Kennedy School Behavioral Insights Group, Cass Sunstein, David Laibson), MIT Digital Currency Initiative. Biotech, life sciences, and tech liquidity events. Harvard Management Company alumni and MIT investment networks generate significant HNW individuals who tend toward alternative and impact investing.",
        institutions: ["Harvard Kennedy School", "MIT Media Lab", "Harvard Management Company"]
      },
      "Wellesley / Weston (MetroWest)": {
        postcode: "02481 / 02493",
        detail: "Primary HNW residential corridor west of Boston. Wellesley: multiple Morgan Stanley, UBS, and boutique wealth management offices. Wellesley College creates a sustained pipeline of high-achieving women who return as investors. Weston has among the highest median household incomes in Massachusetts.",
        institutions: ["Wellesley College", "Morgan Stanley Wellesley"]
      }
    },
    womens_networks: [
      "Boston chapter — 100 Women in Finance",
      "Portfolia women-led consumer VC network",
      "Harvard WE@HBS women's investment network",
      "MIT $100K competition (significant women's participation)"
    ],
    family_offices: "Asset management industry concentration (Fidelity, Wellington, MFS, State Street) creates significant professional wealth. Behavioral finance practitioner community linked to Harvard, MIT, and Boston University.",
    art_market: "Isabella Stewart Gardner Museum, Museum of Fine Arts Boston. GreenFin Conference held in Boston/New York area."
  },

  "chicago": {
    display: "Chicago, USA",
    region: "US Midwest",
    relevant_modules: ["behavioral-economics", "alternative-assets", "art-investing", "whisky-investing"],
    hubs: {
      "Gold Coast (Lake Shore Drive)": {
        postcode: "60611",
        detail: "Chicago's highest-income urban neighborhood (7th richest urban neighborhood in the US by median HHI — $153,358). Pre-war co-ops and high-rises on Lake Shore Drive. Old Chicago family wealth: Pritzker, Crown, Field-adjacent. Art Institute of Chicago is the anchor of world-class art collecting culture.",
        institutions: ["Art Institute of Chicago", "Museum of Contemporary Art Chicago"]
      },
      "North Shore (Kenilworth / Winnetka / Lake Forest)": {
        postcode: "60043 / 60093 / 60045",
        detail: "Premier North Shore suburbs; Kenilworth has the highest median HHI of any incorporated place in Illinois. Multigenerational wealth from Chicago's industrial and financial legacy families. Chicago North Shore Wealth Management corridor has dedicated boutique family office firms. Lake Forest Art Center anchors arts patronage.",
        institutions: ["Lake Forest Art Center", "Ravinia Festival", "Curi Capital", "NewEdge Wealth"]
      },
      "River North / Streeterville": {
        postcode: "60654 / 60611",
        detail: "River North is Chicago's gallery district — Merchandise Mart, numerous contemporary galleries, Chicago Design Museum. University of Chicago Booth (Fama-Miller Center) hosts the Behavioral Finance Conference — the field's most important practitioner-facing academic event. CME Group and Morningstar headquarters are in Chicago.",
        institutions: ["University of Chicago Booth School", "CME Group", "Morningstar", "Thoma Bravo", "GTCR"]
      }
    },
    womens_networks: [
      "Chicago Finance Exchange (women in financial services)",
      "Art Institute Women's Board (one of Chicago's most prestigious volunteer organizations; serious art collector network)",
      "MacArthur Foundation (catalytic capital for women-led impact funds)",
      "Museum of Contemporary Art Chicago women's board"
    ],
    family_offices: "The Loop and River North anchor Chicago PE community (Thoma Bravo, GTCR, Madison Dearborn). PE firms invest $100B+ annually.",
    art_market: "Art Institute of Chicago (world-class permanent collection). River North gallery district. Chicago is a key secondary art market city."
  },

  "san-francisco": {
    display: "San Francisco Bay Area, USA",
    region: "US West Coast",
    relevant_modules: ["gender-lens-investing", "alternative-assets", "esg-climate", "defi-crypto", "vc-gender-lens"],
    hubs: {
      "Atherton (San Mateo County)": {
        postcode: "94027",
        detail: "Consistently the highest-income ZIP code in the United States. Home to venture capitalists, tech founders, and PE professionals. Family offices are active; wealth management concentrated on adjacent Menlo Park (Sand Hill Road).",
        institutions: []
      },
      "Sand Hill Road (Menlo Park / Palo Alto)": {
        postcode: "94025",
        detail: "Global center of venture capital. Major VC firms (Sequoia, Andreessen Horowitz, Kleiner Perkins, NEA). LP networks include endowments, pensions, and private UHNW investors. Significant women's venture investing community: All Raise, Female Founders Fund, Operator Collective.",
        institutions: ["Sequoia Capital", "Andreessen Horowitz", "Kleiner Perkins", "All Raise", "Female Founders Fund"]
      },
      "Pacific Heights (San Francisco)": {
        postcode: "94115",
        detail: "Upper East Side equivalent for San Francisco. Victorian mansions and Edwardian flats along Broadway, Pacific, and Vallejo. Old SF families and new tech wealth. Palace of the Legion of Honor and de Young Museum anchor arts patronage. SFMOMA (South of Market) drives contemporary art collecting.",
        institutions: ["SFMOMA", "Palace of the Legion of Honor", "de Young Museum"]
      }
    },
    womens_networks: [
      "All Raise (women in VC/tech investing — Sand Hill Road and SF offices)",
      "Female Founders Fund LP and portfolio community",
      "Watermark (professional women's organization, significant Bay Area membership)",
      "Commonwealth Club Women's Network",
      "100 Women in Finance Bay Area chapter",
      "Stanford Women on Boards initiative"
    ],
    family_offices: "VC and PE wealth concentrated; Atherton, Menlo Park, Palo Alto. Significant ESG and impact investing orientation in Marin County communities.",
    art_market: "SFMOMA, Hauser & Wirth satellite events, de Young Museum patron community. Art Basel Miami Beach preview events in Bay Area."
  },

  "los-angeles": {
    display: "Los Angeles, USA",
    region: "US West Coast",
    relevant_modules: ["art-investing", "wine-investing", "alternative-assets", "gender-lens-investing"],
    hubs: {
      "Bel Air": {
        postcode: "90077",
        detail: "Highest median home prices in LA (~$4.27M). Entertainment, technology, and finance UHNW. Significant international wealth (Middle Eastern, Asian, European). Family offices serving entertainment wealth are concentrated in adjacent Century City and Beverly Hills.",
        institutions: []
      },
      "Beverly Hills": {
        postcode: "90210",
        detail: "Most internationally recognized LA address. Entertainment industry wealth management firms. Gagosian, Hauser & Wirth satellite events. Serious collector residences. HNW women's charity and investment networks operate through women's clubs and philanthropic auxiliaries.",
        institutions: ["Gagosian Beverly Hills"]
      },
      "Century City (Office District)": {
        postcode: "90067",
        detail: "Primary address for LA wealth management: Morgan Stanley, UBS, Merrill Lynch, major family offices. Entertainment law and talent agency wealth management centered here.",
        institutions: ["Morgan Stanley LA", "UBS Century City"]
      }
    },
    womens_networks: [
      "Women in Film (entertainment-adjacent wealth network)",
      "100 Women in Finance LA chapter",
      "Step Up Women's Network (founded in LA)",
      "Women's Philanthropy Fund at the Jewish Federation of Greater LA",
      "Riviera Club and Bel Air Bay Club women's networks"
    ],
    family_offices: "Family offices serving entertainment wealth concentrated in Century City and Beverly Hills. Brentwood Country Club, Riviera Country Club anchor private social networks.",
    art_market: "LACMA, The Broad, Getty Villa, Norton Simon Museum. Entertainment-linked collecting. Frieze LA. Art Basel preview events."
  },

  "miami": {
    display: "Miami / South Florida, USA",
    region: "US Southeast",
    relevant_modules: ["art-investing", "defi-crypto", "alternative-assets"],
    hubs: {
      "Fisher Island": {
        postcode: "33109",
        detail: "Accessible only by private ferry or helicopter. America's highest-income ZIP code. Median sale price approximately $5.5M–$5.75M (2024). Internationally diverse UHNW: European, Latin American, and Middle Eastern principals.",
        institutions: []
      },
      "South of Fifth / SoFi (Miami Beach)": {
        postcode: "33139",
        detail: "Art Basel Miami Beach (December) makes this the global art market's epicenter for one week annually. Finance professionals who relocated from New York. Significant Northeastern UHNW migration post-2020.",
        institutions: ["Pérez Art Museum Miami (PAMM)"]
      },
      "Wynwood": {
        postcode: "33127",
        detail: "Primary crypto-cultural neighborhood. Blockchain Institute of Technology (BIT), BitBasel, Gemini Miami office. $1.2B in crypto deals across 80+ blockchain startups (2025). Annual Bitcoin Conference held in Miami.",
        institutions: ["Blockchain Institute of Technology", "Gemini Miami", "Bitcoin Conference"]
      },
      "Palm Beach": {
        postcode: "33480",
        detail: "Old-money capital of the American East Coast. Worth Avenue anchors luxury retail. Private clubs (The Everglades Club, Bath & Tennis Club, Sailfish Club). Norton Museum patron community. Society of the Four Arts. Art Palm Beach fair.",
        institutions: ["Norton Museum of Art", "Society of the Four Arts"]
      },
      "Coral Gables / Brickell": {
        postcode: "33134 / 33129",
        detail: "Gables Estates: 179 sprawling waterfront lots on Biscayne Bay. Coral Gables Community Foundation women's networks. Brickell: Citadel global HQ (relocated from Chicago). Pérez Art Museum Miami (PAMM) in Brickell-adjacent Museum Park.",
        institutions: ["Citadel", "Pérez Art Museum Miami"]
      }
    },
    womens_networks: [
      "100 Women in Finance Miami chapter",
      "Women of Tomorrow (Miami-based mentorship and investment network)",
      "Junior League of Miami",
      "Pérez Art Museum Miami women's circles"
    ],
    family_offices: "Significant Latin American family office presence. Coral Gables, Coconut Grove, and Palm Beach are established family office addresses.",
    art_market: "Art Basel Miami Beach (December) — most important art week in the Americas. Coconut Grove Arts Festival. Pérez Art Museum Miami."
  },

  "washington-dc": {
    display: "Washington D.C. Metropolitan Area, USA",
    region: "US Mid-Atlantic",
    relevant_modules: ["gender-lens-investing", "esg-climate", "behavioral-economics", "alternative-assets"],
    hubs: {
      "Georgetown (DC)": {
        postcode: "20007",
        detail: "Political, diplomatic, and think-tank wealth. Former Cabinet officials, lobbying partners, law firm name partners. Georgetown University and Kennedy Center philanthropy anchor arts patronage. Vital Voices Global Partnership.",
        institutions: ["Georgetown University", "Kennedy Center", "Vital Voices Global Partnership"]
      },
      "McLean / Great Falls (Fairfax County, VA)": {
        postcode: "22101 / 22066",
        detail: "Primary residential address for Washington's UHNW: defense contractors, intelligence community executives, lobbying partners, and senior government officials post-service. Multiple family offices and wealth management boutiques.",
        institutions: []
      },
      "Bethesda / Chevy Chase (Montgomery County, MD)": {
        postcode: "20814 / 20815",
        detail: "NIH, World Bank, and IMF executive wealth; international organization professional class. Strong international family wealth (diplomat residences). Women's investment networks through World Bank Women's professional organization and NIH women's leadership.",
        institutions: ["National Institutes of Health", "World Bank (HQ)", "IMF (HQ)"]
      }
    },
    womens_networks: [
      "Vital Voices Global Partnership",
      "World Bank IFC Women Entrepreneurs Finance Initiative (We-Fi)",
      "IMF Gender Diversity Research Division",
      "Center for Global Development gender finance research"
    ],
    family_offices: "DFC, World Bank IFC, SBST are the major DFI gender lens investing bodies headquartered here. Ideas42 (behavioral economics nonprofit) has significant DC presence.",
    art_market: "Smithsonian Institution patron networks; National Gallery of Art patron community. Phillips Collection, Corcoran Gallery legacy."
  },

  "nantucket-hamptons": {
    display: "The Hamptons & Nantucket, USA",
    region: "US Northeast Seasonal",
    relevant_modules: ["art-investing", "alternative-assets", "wine-investing"],
    hubs: {
      "The Hamptons (Southampton / East Hampton / Sagaponack)": {
        postcode: "11968 / 11937 / 11962",
        detail: "Primary summer concentration of New York UHNW wealth. Southampton Village and Sagaponack represent highest land values. Significant art world presence: Bridgehampton Polo attracts collectors, Christie's and Sotheby's operate summer preview events, numerous seasonal galleries. Art Basel satellite programming draws international collectors. Key for advisor outreach during summer contact windows (June–August).",
        institutions: []
      },
      "Nantucket": {
        postcode: "02554",
        detail: "Summer equivalent of the Hamptons for Boston-area UHNW wealth. Significant art collecting and philanthropy networks during summer season.",
        institutions: []
      }
    },
    womens_networks: [
      "Summer philanthropic circuits in the Hamptons (active June–August)",
      "Nantucket arts patron community"
    ],
    family_offices: "Summer seasonal concentration of New York, Boston, and Northeast UHNW wealth.",
    art_market: "Christie's and Sotheby's summer preview events. Seasonal galleries in the Hamptons. Nantucket arts patron community."
  },

  "greenwich-westchester": {
    display: "Greenwich CT / Westchester, USA",
    region: "US Northeast",
    relevant_modules: ["alternative-assets", "behavioral-economics", "art-investing"],
    hubs: {
      "Greenwich": {
        postcode: "06830 / 06831",
        detail: "Single most important hedge fund suburb in the world. Bridgewater Associates (Westport), Point72, AQM Capital. Per capita grand list exceeds Connecticut statewide average by 385%. High concentration of family offices managing multigenerational financial-industry wealth.",
        institutions: ["Bridgewater Associates", "Point72", "Bruce Museum"]
      },
      "Darien": {
        postcode: "06820",
        detail: "Ranked second-richest small town in the US by per capita income. Dense concentration of financial services professionals. Conservative investment culture; strong estate planning and multigenerational trust activity.",
        institutions: []
      },
      "New Canaan": {
        postcode: "06840",
        detail: "Median household income exceeding $400,000. High concentration of private equity partners and corporate executives. Philip Johnson's Glass House is located here.",
        institutions: []
      }
    },
    womens_networks: [
      "Multiple bank-affiliated women's wealth programs in Greenwich",
      "Fairfield County HNW women's advisory networks"
    ],
    family_offices: "Highest density of hedge fund and PE family offices in the United States, concentrated in Greenwich. Bridgewater Associates (Westport) is the world's largest hedge fund by AUM.",
    art_market: "Bruce Museum (Greenwich); private collector networks. Westport has a culturally creative HNW community."
  },

  "london": {
    display: "London, United Kingdom",
    region: "UK",
    relevant_modules: ["alternative-assets", "art-investing", "esg-climate", "behavioral-economics", "gender-lens-investing", "wine-investing", "defi-crypto"],
    hubs: {
      "Mayfair (W1)": {
        postcode: "W1J / W1S / W1K",
        detail: "Global headquarters of private wealth management and family office advisory in Europe. Berkeley Square, Grosvenor Square, Mount Street. Goldman Sachs International, Morgan Stanley Private Wealth, UBS, Coutts, C. Hoare & Co. Sotheby's (New Bond Street), Christie's (King Street) — center of global art auction market. Hauser & Wirth, Gagosian, White Cube, and dozens of major galleries in Berkeley Square and Cork Street corridor.",
        institutions: ["Sotheby's London", "Christie's London", "Gagosian London", "Hauser & Wirth London", "Goldman Sachs International", "UBS London", "Coutts"]
      },
      "Belgravia (SW1)": {
        postcode: "SW1X / SW1W",
        detail: "Immediately west of Buckingham Palace. Eaton Square, Belgravia Square, Chesham Place. Among the highest residential property values in London. Historically aristocratic and diplomatic wealth; now heavily international (Gulf, European). Large period townhouses on garden squares.",
        institutions: []
      },
      "Chelsea / South Kensington (SW3 / SW7)": {
        postcode: "SW3 / SW7",
        detail: "Chelsea: galleries on King's Road and Flood Street; younger UHNW (tech, creative industries). South Kensington: museum district (V&A, Natural History Museum); intellectual and arts-collecting community. Strong French expatriate community creating crossover with Paris-based wealth networks.",
        institutions: ["Victoria & Albert Museum", "Natural History Museum", "Imperial College London"]
      },
      "St. James's (SW1)": {
        postcode: "SW1A / SW1Y",
        detail: "Private clubs district: Brooks's, White's, the Travellers, Athenaeum. Christie's King Street salesroom. Berry Bros. & Rudd (3 St James's Street, est. 1698 — fine wine private banking). Jermyn Street luxury lifestyle.",
        institutions: ["Christie's King Street", "Berry Bros. & Rudd", "Liv-ex (Borough Market area)"]
      }
    },
    womens_networks: [
      "100 Women in Finance London chapter (strongest non-US chapter; 450+ professionals)",
      "Level 20 (women in private equity — London HQ)",
      "Women in Finance Charter (HM Treasury — UK government-sponsored; all major banks are signatories)",
      "Octopus Ventures women's LP network",
      "Campden Wealth European Family Office Forum (significant women's family office leadership)"
    ],
    family_offices: "Largest sophisticated alternatives ecosystem in Europe. Mayfair, St. James's, Belgravia are the European family office capitals. UK Behavioural Insights Team (BIT) originated at 70 Whitehall.",
    art_market: "Christie's and Sotheby's dual primary salesrooms (London and New York). Frieze London and Frieze Masters (October, Regent's Park). Mayfair gallery corridor. Liv-ex fine wine trading platform."
  },

  "edinburgh": {
    display: "Edinburgh, Scotland, United Kingdom",
    region: "UK — Scotland",
    relevant_modules: ["alternative-assets", "art-investing", "esg-climate"],
    hubs: {
      "Morningside / Merchiston (EH10)": {
        postcode: "EH10",
        detail: "Edinburgh's most established residential wealth quarter — equivalent to London's Chelsea or Boston's Chestnut Hill. Old professional money: lawyers, surgeons, abrdn and Baillie Gifford senior professionals. EH10 4 average property values exceed £975,000. Morningside Drive and Merchiston Avenue are the prestige addresses.",
        institutions: ["abrdn (Standard Life Aberdeen)", "Baillie Gifford", "Turcan Connell"]
      },
      "Murrayfield / Ravelston (EH12 / EH4)": {
        postcode: "EH12 / EH4",
        detail: "Most expensive residential district in Edinburgh by average sold price (£732,515 average). Senior partners at Shepherd and Wedderburn, Brodies LLP, Turcan Connell. Ravelston House Road and Ravelston Dykes are the prestige addresses.",
        institutions: ["Shepherd and Wedderburn", "Brodies LLP"]
      },
      "New Town (EH3)": {
        postcode: "EH3",
        detail: "Edinburgh's Georgian planned city quarter — Heriot Row, Moray Place, Ainslie Place in the First and Second New Town. Architecturally irreplaceable. Arts-adjacent creative-professional community. Stockbridge (adjacent): independent galleries, antique dealers.",
        institutions: ["Scottish National Gallery", "Ingleby Gallery"]
      }
    },
    womens_networks: [
      "Scottish Women in Business (professional network with financial services focus)",
      "Edinburgh Chamber of Commerce Women in Business group",
      "100 Women in Finance — Scottish network anchored in Edinburgh (emerging chapter)",
      "Turcan Connell private client law firm (significant HNW women clients in trust and estate planning)",
      "Baillie Gifford Women's Leadership Network alumni"
    ],
    family_offices: "Edinburgh is the UK's second most important financial centre. Over £1 trillion in AUM through abrdn, Baillie Gifford, Artemis Investment Management, Martin Currie. 57,000 HNW residents.",
    art_market: "Scottish National Galleries system. Lyon & Turnbull auction house (Scottish art, silverware, decorative arts). Ingleby Gallery (contemporary international artists). Edinburgh Art Festival (August — coincides with the Fringe, densest concentration of culturally engaged HNW visitors in any UK city outside London during August)."
  },

  "manchester-cheshire": {
    display: "Manchester & Cheshire Golden Triangle, United Kingdom",
    region: "UK — North England",
    relevant_modules: ["alternative-assets", "art-investing", "esg-climate"],
    hubs: {
      "Alderley Edge (SK9)": {
        postcode: "SK9",
        detail: "Consistently ranked among the top five wealthiest villages in the UK. Premier League footballers, television personalities, entrepreneurs, corporate executives. Properties on Macclesfield Road, Ryleys Lane, and Woodbrook Road exceed £2M+. Direct rail to Manchester Piccadilly (20 minutes); Manchester Airport proximity.",
        institutions: []
      },
      "Prestbury (SK10)": {
        postcode: "SK10",
        detail: "Most exclusive village within the Golden Triangle. Properties on Macclesfield Road and New Road: £3–£5M+. Sir Alex Ferguson, multiple Premier League managers, and England internationals have resided in Prestbury. Most aspirational UHNW address in Manchester's orbit.",
        institutions: []
      },
      "Knutsford (WA16)": {
        postcode: "WA16",
        detail: "Highest concentration of wealth management and private banking offices in the region. Coutts, Handelsbanken, and multiple independent wealth managers serve the Knutsford-Wilmslow-Alderley Edge corridor. Tatton Park estate and gardens anchor heritage arts and horticultural patron community.",
        institutions: ["Coutts Knutsford", "Handelsbanken Knutsford"]
      },
      "Wilmslow (SK9)": {
        postcode: "SK9",
        detail: "Senior executives at Kellogg's, Barclays Manchester, HSBC UK Regional Hub. Primary address for Manchester's legal and financial advisory community. Bollin Valley corridor contains some of the largest private residential estates in the North of England.",
        institutions: []
      }
    },
    womens_networks: [
      "Greater Manchester Chamber of Commerce Women in Business",
      "Coutts Knutsford (dedicated HNW women relationship managers)",
      "Manchester's MediaCityUK and Tech North women's professional community"
    ],
    family_offices: "Manchester PE and property investment wealth from the development boom (Noma, First Street Corridor). Spinningfields financial district (NatWest, HSBC, Barclays regional offices).",
    art_market: "Whitworth Art Gallery (University of Manchester) — national-calibre institution. Manchester Art Gallery. Manchester Museum of Science and Industry. Bonhams Manchester salesroom. Northern Quarter arts district (Ancoats, NOMA)."
  },

  "surrey": {
    display: "Surrey & Home Counties, United Kingdom",
    region: "UK — South England",
    relevant_modules: ["alternative-assets", "art-investing"],
    hubs: {
      "Virginia Water / Wentworth Estate (GU25)": {
        postcode: "GU25",
        detail: "Rated most expensive town in England by average property price (avg exceeding £1.2M; Wentworth Estate properties £5–£20M). Private gated community of ~1,500 houses around Wentworth Golf Club (BMW PGA Championship). Most internationally diverse residential address in Surrey.",
        institutions: ["Wentworth Golf Club"]
      },
      "St George's Hill / Weybridge (KT13)": {
        postcode: "KT13",
        detail: "Most exclusive private estate in England after Wentworth: ~350 houses behind security-patrolled gate, private tennis courts, hotel, and golf club. Properties £3–£15M. Technology billionaires, Middle Eastern royal family members, senior financiers.",
        institutions: []
      },
      "Cobham (KT11)": {
        postcode: "KT11",
        detail: "Average property price ~£1.04M. Chelsea FC training ground adjacency. Corporate executive wealth from the M25 corridor. Burwood Park is a private estate comparable to Wentworth.",
        institutions: []
      },
      "Esher / Thames Ditton (KT10)": {
        postcode: "KT10",
        detail: "Elmbridge Borough's most established wealth community. Senior pharmaceuticals, technology, and investment management executives. Claremont Landscape Garden (National Trust).",
        institutions: []
      }
    },
    womens_networks: [
      "Elmbridge Women's Business Awards (annual; covers Esher, Walton, Weybridge, Cobham)",
      "Surrey branches of Coutts, Cazenove, and Investec serving HNW women clients",
      "ICR Sutton (Institute for Cancer Research) — focus of women's philanthropic giving in Surrey HNW community"
    ],
    family_offices: "Surrey is the primary residential address for City of London-based family office principals who prefer to live outside London. Oxshott Crown Estate (KT22) is considered the most private address in the Surrey belt.",
    art_market: "Petworth House (National Trust, adjacent in West Sussex) — extraordinary Old Masters patronage tradition (Turner painted at Petworth). Goodwood (Festival of Speed, Goodwood Revival) draws international UHNW and is a center of motorsport and heritage art culture."
  },

  "jersey-guernsey": {
    display: "Jersey & Guernsey (Channel Islands)",
    region: "Crown Dependencies — British Isles",
    relevant_modules: ["alternative-assets", "defi-crypto"],
    hubs: {
      "St Helier / St Brelade (Jersey)": {
        postcode: "JE2 / JE3",
        detail: "Jersey hosts 50+ active family office structures; combined AUM in the hundreds of billions of pounds. 0% CGT, 0% inheritance tax, 20% flat income tax cap. UBS Jersey, RBC Wealth Management Jersey, Coutts Jersey, JTC Group, Equiom. Premium residential addresses in the Waterfront Quarter, Gorey Village (JE3), and western parishes St Brelade/St Lawrence.",
        institutions: ["UBS Jersey", "RBC Wealth Management Jersey", "Coutts Jersey", "JTC Group", "Equiom"]
      },
      "St Peter Port (Guernsey)": {
        postcode: "GY1",
        detail: "Guernsey hosts £300B+ in private equity domiciled through Guernsey structures. 0% CGT, 0% inheritance tax. Significant offshore fund administration infrastructure. Premium residential addresses on the Grange, Hauteville, and cliffside properties above the harbour.",
        institutions: []
      }
    },
    womens_networks: [
      "Jersey Women's Finance Network (emerging)",
      "JTC Group and Equiom dedicated women's leadership programmes",
      "Jersey Arts Trust and Guernsey Arts Commission (significant HNW women's leadership)"
    ],
    family_offices: "Jersey is the most significant family office jurisdiction within the British Isles. Family offices are significant allocators to alternative assets including PE, hedge funds, and DeFi.",
    art_market: "Jersey Arts Trust and Guernsey Arts Commission programming. Small but sophisticated collector community."
  },

  "paris": {
    display: "Paris, France",
    region: "France",
    relevant_modules: ["art-investing", "esg-climate", "alternative-assets", "behavioral-economics"],
    hubs: {
      "8th Arrondissement / Golden Triangle": {
        postcode: "75008",
        detail: "International UHNW residential and commercial address. Avenue Montaigne (luxury fashion row). Christie's Paris (9 Avenue Matignon). Major financial institutions. Musée Jacquemart-André anchor. Prices reach or exceed €30,000/m². International family offices use for both residential and operational presence.",
        institutions: ["Christie's Paris", "Musée Jacquemart-André"]
      },
      "7th Arrondissement (Invalides)": {
        postcode: "75007",
        detail: "Diplomatic and old-money arrondissement. Hôtels particuliers along Rue de Varenne, Rue de Grenelle, Boulevard Saint-Germain. Most discreet of the UHNW residential arrondissements. Rodin Museum and Musée d'Orsay anchor arts patronage. Prices reach €25,000–€30,000/m².",
        institutions: ["Musée d'Orsay", "Rodin Museum"]
      },
      "6th Arrondissement (Saint-Germain-des-Prés)": {
        postcode: "75006",
        detail: "The literary and gallery quarter. Galerie Karsten Greve, Galerie Maeght, Galerie Templon, Galerie Lelong along Rue de Seine, Rue Mazarine, Rue du Four. Strong demand from European and British UHNW buyers. Paris Art Week (October, Paris+) satellite programming concentrates here.",
        institutions: ["Galerie Templon", "Galerie Perrotin (Marais)"]
      },
      "Neuilly-sur-Seine": {
        postcode: "92200",
        detail: "Immediately west of the 17th arrondissement; France's wealthiest commune by per capita income. Strong concentration of financial industry professionals, corporate executives, and established French family wealth. Where Paris's finance and corporate elite actually lives.",
        institutions: []
      }
    },
    womens_networks: [
      "Cercle InterElles (women in business and finance, Paris chapter)",
      "100 Women in Finance Paris chapter",
      "Fondation des Femmes (women's philanthropy network)",
      "Bpifrance women's entrepreneurship investment program (La Défense)"
    ],
    family_offices: "Caisse des Dépôts and BNP Paribas are the largest French ESG capital allocators. OECD (16th arrondissement) Green Finance Platform. Paris La Défense business district is the primary ESG practitioner hub.",
    art_market: "Christie's and Artcurial flagship salesrooms. Gallery districts: Marais (3rd/4th arr., near Centre Pompidou) and Saint-Germain-des-Prés (6th arr.). Art Basel Paris (October, Grand Palais). Paris Art Week in October."
  },

  "amsterdam": {
    display: "Amsterdam, Netherlands",
    region: "Netherlands",
    relevant_modules: ["esg-climate", "defi-crypto", "alternative-assets", "art-investing"],
    hubs: {
      "Oud-Zuid (1071)": {
        postcode: "1071",
        detail: "Amsterdam's most prestigious urban residential district. PC Hooftstraat (Netherlands' most expensive shopping street). Rijksmuseum, Van Gogh Museum, Stedelijk Museum, Vondelpark. Properties €8,000–€14,000/m². Financial services professionals, technology entrepreneurs, and multigenerational Amsterdam merchant families. Concertgebouw anchor.",
        institutions: ["Rijksmuseum", "Van Gogh Museum", "Stedelijk Museum", "Concertgebouw"]
      },
      "Jordaan (1016)": {
        postcode: "1016",
        detail: "Canal houses €2–€6M. 17th-century buildings. Gallery districts within the Jordaan (Bloemgracht, Elandsgracht). FOAM Photography Museum and Galerie Ron Mandos.",
        institutions: ["FOAM Photography Museum"]
      },
      "Wassenaar (2243–2245)": {
        postcode: "2243 / 2244 / 2245",
        detail: "Wealthiest municipality in the Netherlands per capita. Between The Hague and Leiden. Dutch industrial families, senior diplomats (Den Haag-adjacent), Shell executives, UHNW international residents. King Willem-Alexander maintains Villa Eikenhorst in Wassenaar. Properties €2–€20M+.",
        institutions: []
      }
    },
    womens_networks: [
      "Dutch Women in Finance Network (DWIF)",
      "FNV Finance women's network",
      "Women on Boards Netherlands initiative (post-EU parity legislation)",
      "Rijksmuseum Board and Van Gogh Museum Board (significant HNW women patron representation)"
    ],
    family_offices: "HAL Investments (Rotterdam, €16B AUM); Cyrte Investments (John de Mol/Endemol). Amsterdam is ranked world's top green financial hub. APG, PGGM, NN Investment Partners — among the largest ESG allocators globally.",
    art_market: "TEFAF Maastricht (March — world's premier fine art and antiques fair). Rijksmuseum, Van Gogh Museum. FOAM Photography Museum. PRI in Person 2026 (Amsterdam, Oct 13-15, Beurs van Berlage)."
  },

  "zurich-geneva": {
    display: "Zurich & Geneva, Switzerland",
    region: "Switzerland",
    relevant_modules: ["alternative-assets", "esg-climate", "defi-crypto", "art-investing", "wine-investing"],
    hubs: {
      "Zurichberg / Küsnacht (Zurich)": {
        postcode: "8044 / 8700",
        detail: "Zurich's primary residential address for wealth. Zurichberg: wooded hillside east of city center; large villas with lake views; old Swiss banking and industrial family wealth (UBS, Zurich Insurance, Swiss Re senior executives). Küsnacht: known as home to senior financial professionals; Herrliberg and Meilen provide larger estates with direct Lake Zurich access. Swiss private banking legacy wealth concentrated along this corridor.",
        institutions: ["Kunsthaus Zürich"]
      },
      "Zug": {
        postcode: "6300",
        detail: "25 minutes from Zurich; among the lowest tax rates in Switzerland and Europe. Crypto Valley — the world's leading blockchain and DeFi regulatory jurisdiction. Ethereum Foundation, Cardano Foundation, Tezos Foundation, Web3 Foundation all registered in Zug. Crypto Valley Association (1,000+ companies). Family offices increasingly establish in Zug for tax optimization and digital asset regulatory environment.",
        institutions: ["Crypto Valley Association", "Ethereum Foundation", "Web3 Foundation", "CV VC"]
      },
      "Cologny / Rue du Rhône (Geneva)": {
        postcode: "1223 / 1204",
        detail: "Cologny is the 'Beverly Hills of Geneva' — large villas on the lake with private docks. Home to senior private bankers (Pictet, Lombard Odier, Bordier), international organization executives (UN, ICRC, WTO). Rue du Rhône: Switzerland's premier private banking street. Pictet & Cie, Lombard Odier, Mirabaud, Union Bancaire Privée. Geneva manages more cross-border private wealth than any other city in the world. Freeport Geneva (adjacent to the airport, Meyrin) — world's most important private art storage facility ($100B+ in art, wine, collectibles).",
        institutions: ["Pictet & Cie", "Lombard Odier", "Mirabaud", "Union Bancaire Privée", "Freeport Geneva"]
      }
    },
    womens_networks: [
      "Swiss Philanthropy Foundation (women's program)",
      "WEF Davos Women Leaders Community (annual; significant Zurich/Geneva spillover)",
      "100 Women in Finance Zurich and Geneva chapters",
      "Campden Wealth European Family Office network (significant Swiss women family office principals)"
    ],
    family_offices: "Zurich/Geneva is the world's largest cross-border private banking center. UNEP FI (UN Environment Programme Finance Initiative) headquartered in Geneva's Châtelaine district. Geneva: Rue du Rhône — hundreds of registered family offices including Unifund SA ($10B+) and B-Flexion ($12B, Bertarelli family).",
    art_market: "Kunsthaus Zürich (Switzerland's largest art museum). Art Basel (Basel, June — world's most important contemporary art fair). Freeport Geneva ($100B+ in stored art). UBS Art Collection."
  },

  "munich": {
    display: "Munich, Germany",
    region: "Germany — Bavaria",
    relevant_modules: ["alternative-assets", "art-investing", "esg-climate"],
    hubs: {
      "Bogenhausen / Herzogpark (81675 / 81925)": {
        postcode: "81675 / 81925",
        detail: "Most prestigious residential district in Munich. Large 19th and early 20th century villas alongside high-end developments. Herzogpark sub-district: planned garden suburb of detached villas with large gardens, patrolled gates, private swimming club. Munich's old industrial and banking families: Allianz executives, BMW board members, senior Munich law firm partners (Gleiss Lutz, Linklaters Munich). Key streets: Möhlstraße, Maria-Theresia-Straße.",
        institutions: ["Villa Stuck (museum)", "Allianz SE"]
      },
      "Grünwald (82031)": {
        postcode: "82031",
        detail: "'Munich's Billionaires' Village.' South of Munich across the Isar; extremely low Bavarian tax rates; very high density of billionaires and family offices relative to population. Family offices: Munich Partners Family Office GmbH (Südliche Münchner Straße 32), Winterberg Group (Tölzer Str. 1). Properties €3–€15M. Alps skiing proximity.",
        institutions: ["Munich Partners Family Office", "Winterberg Group"]
      },
      "Maxvorstadt / Schwabing (80333 / 80801)": {
        postcode: "80333 / 80801",
        detail: "Munich's arts-collecting neighbourhood. Bavarian State Art Collections: Alte Pinakothek, Neue Pinakothek, Pinakothek der Moderne, Museum Brandhorst. Ludwig-Maximilians-Universität. BMW Museum. Gallery owners, museum board members, collectors of modern and contemporary art.",
        institutions: ["Alte Pinakothek", "Neue Pinakothek", "Pinakothek der Moderne", "Museum Brandhorst"]
      }
    },
    womens_networks: [
      "100 Women in Finance Frankfurt chapter (strongest in Germany; ECB community)",
      "Frauen in der Wirtschaft (Women in Business) Munich networks",
      "DAX Women's Investor Group (senior female executives across German corporates)",
      "Campden Wealth European Family Office network (significant German participation)"
    ],
    family_offices: "Grünwald is known informally as Munich's Billionaires' Village — highest density of billionaires and family offices per capita in Germany. Munich is Germany's primary PE and industrial wealth city.",
    art_market: "Alte Pinakothek, Neue Pinakothek, Pinakothek der Moderne, Museum Brandhorst — four world-class museums in Maxvorstadt. Villa Stuck. Significant Old Masters and modern art collecting tradition."
  },

  "milan": {
    display: "Milan, Italy",
    region: "Italy — Lombardy",
    relevant_modules: ["art-investing", "alternative-assets", "esg-climate"],
    hubs: {
      "Brera (20121)": {
        postcode: "20121",
        detail: "Milan's most expensive residential neighbourhood and Italy's primary arts and fashion wealth district. Pinacoteca di Brera (Italy's second most important art museum after the Uffizi). Via Fiori Chiari monthly antique market. Properties €8,000–€15,000/m². Gallery owners, multigenerational Milanese families, collectors.",
        institutions: ["Pinacoteca di Brera", "Fondazione Prada", "Fondazione Furla"]
      },
      "Montenapoleone / Quadrilatero della Moda (20121 / 20122)": {
        postcode: "20121 / 20122",
        detail: "Fashion quadrangle: Via Montenapoleone, Via della Spiga, Via Manzoni, Corso Venezia. Properties above €12,000/m². Fashion industry UHNW (Armani, Versace, Prada-adjacent). Museo Poldi Pezzoli (Via Alessandro Manzoni 12) — one of Italy's most significant private collection museums.",
        institutions: ["Museo Poldi Pezzoli"]
      }
    },
    womens_networks: [
      "Fondazione Prada — Miuccia Prada's institution is one of the world's most significant privately-funded contemporary art foundations; model of HNW women's arts philanthropy",
      "Fondazione Furla (Milan) — women's-led art foundation supporting young artists",
      "AIPB (Italian Wealth Management Association) growing women's leadership representation"
    ],
    family_offices: "Milan is Italy's financial capital. Significant private banking wealth through Mediobanca, Intesa Sanpaolo Private Banking, and international private banks.",
    art_market: "Pinacoteca di Brera. Fondazione Prada (both a major foundation and a contemporary art institution). Artissima Turin (November, adjacent). Major Italian fashion and design collecting community."
  },

  "madrid": {
    display: "Madrid, Spain",
    region: "Spain",
    relevant_modules: ["art-investing", "alternative-assets", "esg-climate"],
    hubs: {
      "Salamanca (28001 / 28006)": {
        postcode: "28001 / 28006",
        detail: "Spain's most prestigious residential and commercial address. Calle Serrano, Calle de Jorge Juan, Velázquez, Príncipe de Vergara. Average declared annual income approximately €95,000/taxpayer. Properties €6,000–€12,000/m². Thyssen-Bornemisza Museum (Paseo del Prado 8) and Museo del Prado — one of the world's great art-patron corridors. Galería Marlborough, Galería Elvira González, international gallery representatives.",
        institutions: ["Thyssen-Bornemisza Museum", "Museo del Prado", "Galería Marlborough"]
      },
      "La Moraleja (28109)": {
        postcode: "28109",
        detail: "Spain's wealthiest neighbourhood by per capita income (avg declared €200K/taxpayer). Private golf-course residential development of ~3,000 luxury villas (Alcobendas municipality, north of Madrid). Comparable to Virginia Water's Wentworth Estate or Paris's Le Vésinet. Inditex directors, Santander board members, Repsol executives.",
        institutions: ["American School of Madrid"]
      }
    },
    womens_networks: [
      "WOMENALIA (Spain's largest women's professional and entrepreneurial network — significant HNW membership in Madrid and Barcelona)",
      "CaixaBank OpenWealth (manages over €10B in UHNW and family office assets; growing women's wealth advisory)",
      "Fundación Compromiso y Transparencia women's philanthropy research initiative"
    ],
    family_offices: "Madrid is Spain's financial capital. Major Spanish banks (Santander, BBVA, CaixaBank) have private banking operations serving the Salamanca and La Moraleja communities.",
    art_market: "Thyssen-Bornemisza Museum and Museo del Prado — one of the world's great art-patron corridors. Galería Marlborough, international gallery representatives in Salamanca."
  },

  "singapore": {
    display: "Singapore",
    region: "Asia-Pacific",
    relevant_modules: ["alternative-assets", "defi-crypto", "esg-climate", "art-investing", "gender-lens-investing"],
    hubs: {
      "Nassim Road / District 10": {
        postcode: "District 10",
        detail: "Singapore's premiere GCB (Good Class Bungalow) area. Nassim Road nicknamed 'Billionaires' Row' — ultra-large detached residential land plots. District 10 (Nassim, Tanglin, Buona Vista, Holland Village) is the most expensive residential district.",
        institutions: ["Temasek (Orchard Road)", "GIC (St. George's Road)"]
      },
      "Marina Bay Financial Centre": {
        postcode: "018983",
        detail: "Singapore's financial infrastructure hub. UBS, DBS Private Bank, OCBC Premier Banking, Bank of Singapore, hundreds of family office operations. MAS (Monetary Authority of Singapore) headquartered here — governs the world's fastest-growing family office jurisdiction. Singapore's family office count exceeded 2,500 in 2025; combined AUM $66.8B+ (43% year-on-year increase).",
        institutions: ["Monetary Authority of Singapore (MAS)", "UBS Singapore", "DBS Private Bank", "Bank of Singapore"]
      },
      "Sentosa Cove": {
        postcode: "Sentosa",
        detail: "Singapore's only zone where foreigners can freely purchase landed residential property. Waterfront villas and bungalows with yacht marina access. Significant international UHNW: Chinese (mainland and overseas), Indonesian, Indian, and European families.",
        institutions: []
      }
    },
    womens_networks: [
      "Women in Finance Asia (WIFA) — Singapore headquarters",
      "Singapore Council of Women's Organisations",
      "100 Women in Finance Singapore chapter",
      "AWARE (Association of Women for Action and Research)",
      "Family Business Network Asia (significant women's next-generation wealth programming)"
    ],
    family_offices: "Singapore leads globally in family office count (2,500+ as of 2025). Tax incentives under Sections 13O and 13U of the Income Tax Act, extended through 2029. Variable Capital Company (VCC) structure. Singapore's UHNW population includes significant women principals — Southeast Asian business families often transfer wealth management to daughters.",
    art_market: "ArtSG (January, Marina Bay Sands — Singapore's flagship international art fair). Major private banks (DBS, UBS, Julius Baer) offer art-secured lending. Climate Impact X (CIX) — Southeast Asia's premier carbon exchange."
  },

  "hong-kong": {
    display: "Hong Kong, SAR",
    region: "Asia-Pacific",
    relevant_modules: ["art-investing", "alternative-assets", "defi-crypto", "wine-investing"],
    hubs: {
      "The Peak (Victoria Peak)": {
        postcode: "The Peak",
        detail: "Most prestigious residential address in Hong Kong. Pollock's Path, Plantation Road, Peak Road house Hong Kong's most established UHNW families: Jardine Matheson and Swire-connected families, mainland Chinese billionaires, senior bankers. Limited residential supply creates extreme value density.",
        institutions: []
      },
      "Mid-Levels (Robinson Road / Conduit Road)": {
        postcode: "Mid-Levels",
        detail: "Below the Peak; highest density of UHNW residential in terms of unit count. Primarily luxury apartment towers; banking executives, hedge fund managers, professional UHNW. Mid-Levels Escalator connects to Central financial district.",
        institutions: []
      },
      "Central / Admiralty (Financial District)": {
        postcode: "Central",
        detail: "Operational center of Hong Kong private wealth. HSBC Private Banking, Goldman Sachs, Credit Suisse (now UBS), and major regional wealth managers. Sotheby's flagship at Landmark Chater (24,000 sq ft). Christie's in Henderson building (50,000 sq ft, Zaha Hadid design). Licensed Virtual Asset Service Providers (VASPs) concentrated here.",
        institutions: ["Sotheby's Hong Kong", "Christie's Hong Kong", "HSBC Private Banking HK"]
      }
    },
    womens_networks: [
      "Women in Finance Asia (WIFA) — Hong Kong chapter",
      "100 Women in Finance Hong Kong chapter",
      "The Women's Foundation Hong Kong",
      "Campden Wealth Asia Pacific family office network"
    ],
    family_offices: "~2,700 family offices in Hong Kong. Preferred for China-connected wealth and mainland UHNW seeking international diversification. HK manages approximately HK$21.9 trillion in private banking assets.",
    art_market: "Art Basel Hong Kong (March, HKCEC Wan Chai) — Asia's most important international art fair. Sotheby's, Christie's, Phillips all with major Asia operations. West Kowloon Cultural District (M+ Museum, Hong Kong Palace Museum). World's most active fine wine auction market by lots sold."
  },

  "dubai": {
    display: "Dubai, UAE",
    region: "Middle East",
    relevant_modules: ["alternative-assets", "defi-crypto", "art-investing", "esg-climate"],
    hubs: {
      "DIFC (Dubai International Financial Centre)": {
        postcode: "DIFC",
        detail: "Regulatory and operational hub of Middle East wealth management. HSBC Private Banking, Goldman Sachs, Morgan Stanley, Julius Baer, and 75% of the region's family offices. English common law jurisdiction within the UAE; independent courts. Over 3,500 companies registered. Gate Village within DIFC is the primary gallery district. DIFC Art Nights and Art Dubai programming.",
        institutions: ["HSBC Private Banking Dubai", "Goldman Sachs Dubai", "Julius Baer Dubai", "VARA (Virtual Assets Regulatory Authority)"]
      },
      "Emirates Hills": {
        postcode: "Emirates Hills",
        detail: "Dubai's most prestigious gated residential community, modeled on Beverly Hills. Custom villas on golf course frontage. Home to senior partners at DIFC-registered family offices and private equity firms. The Montgomerie Golf Club anchors resident social life.",
        institutions: []
      },
      "Palm Jumeirah": {
        postcode: "Palm Jumeirah",
        detail: "Man-made palm-shaped island; luxury villas and signature hotels (Atlantis, One&Only The Palm). Significant international UHNW: Russian, Chinese, British, and Indian principals who have relocated. Nakheel Mall and The Pointe anchor social activity.",
        institutions: []
      },
      "DMCC Crypto Centre (JLT)": {
        postcode: "JLT",
        detail: "Dubai Multi Commodities Centre Crypto Centre in Jumeirah Lake Towers — 600+ crypto and blockchain companies. Gate.io, MEXC, OKX have Dubai offices. VARA (est. 2022) — world's first dedicated crypto regulator. Token2049, Consensus, and Future Blockchain Summit all held in Dubai.",
        institutions: ["VARA", "DMCC Crypto Centre", "Gate.io", "OKX"]
      }
    },
    womens_networks: [
      "100 Women in Finance Dubai chapter",
      "Arab Women's Leadership Institute",
      "Women in Finance Middle East (DIFC-based initiatives)",
      "Ellevate Network Dubai and Abu Dhabi chapters",
      "The Women's Investment Club (Abu Dhabi)"
    ],
    family_offices: "75% of Middle East family offices are concentrated in DIFC. DIFC is the primary gateway for Gulf family wealth, sovereign wealth fund adjacent principals, and Middle Eastern UHNW seeking international diversification.",
    art_market: "Art Dubai (May, Madinat Jumeirah). DIFC Art Nights and Gate Village gallery district. Art Basel satellite programming. Frieze Abu Dhabi (new; Saadiyat Island with Louvre Abu Dhabi and Guggenheim Abu Dhabi under development)."
  },

  "sydney": {
    display: "Sydney, Australia",
    region: "Asia-Pacific",
    relevant_modules: ["alternative-assets", "art-investing", "esg-climate"],
    hubs: {
      "Point Piper (Eastern Suburbs)": {
        postcode: "2027",
        detail: "Australia's most exclusive residential address. Waterfront estates on the Rushcutters Bay and Double Bay harbour foreshore; private pontoons; limited inventory. Old money and new technology wealth. Several major Australian mining and resources billionaires have maintained residences here. One of the most expensive suburbs per square metre in the Southern Hemisphere.",
        institutions: []
      },
      "Double Bay": {
        postcode: "2028",
        detail: "Known colloquially as 'Double Pay'; the luxury shopping and dining village of the Eastern Suburbs. Galleries have historically clustered here. Art Gallery of NSW accessible via short drive. Strong Jewish philanthropy and investment networks active in Double Bay.",
        institutions: []
      },
      "Mosman (Lower North Shore)": {
        postcode: "2088",
        detail: "Most active market for $5M+ residential transactions in Sydney by volume for many years. Waterfront suburb across the harbour; large period homes and luxury new construction. Banking and legal UHNW. Proximity to private schools (Mosman Prep, SCEGGS Redlands) anchors family residential demand.",
        institutions: []
      }
    },
    womens_networks: [
      "100 Women in Finance Australia/Sydney chapter",
      "Chief Executive Women (CEW) — the most significant women's executive network in Australia; based in Sydney and Melbourne",
      "Australian Women Donors Network (philanthropy-focused)",
      "UNSW and University of Sydney women's investment alumni networks"
    ],
    family_offices: "Macquarie Asset Management (infrastructure, Martin Place, Sydney) is a globally significant alternative asset manager. Sydney is Australia's primary private wealth center.",
    art_market: "Art Gallery of New South Wales patron community. Significant Jewish philanthropy and arts patronage in the Eastern Suburbs. The Archibald Prize and major Australian art events attract HNW patron community."
  }
};

// ============================================================
// LOCATION-TO-MODULE INDEX (fast reverse lookup)
// ============================================================

const LOCATION_MODULE_INDEX = {
  "chicago": ["behavioral-economics", "alternative-assets", "art-investing", "whisky-investing"],
  "cambridge": ["behavioral-economics", "esg-climate", "alternative-assets", "defi-crypto"],
  "princeton": ["behavioral-economics"],
  "new haven": ["behavioral-economics", "alternative-assets"],
  "durham": ["behavioral-economics"],
  "pittsburgh": ["behavioral-economics"],
  "london": ["alternative-assets", "art-investing", "esg-climate", "behavioral-economics", "gender-lens-investing", "wine-investing", "defi-crypto"],
  "mayfair": ["alternative-assets", "art-investing", "esg-climate", "wine-investing"],
  "belgravia": ["alternative-assets", "art-investing"],
  "chelsea": ["art-investing", "alternative-assets"],
  "new york": ["alternative-assets", "art-investing", "behavioral-economics", "gender-lens-investing", "esg-climate", "defi-crypto", "wine-investing"],
  "upper east side": ["art-investing", "alternative-assets", "wine-investing"],
  "midtown": ["alternative-assets", "behavioral-economics", "gender-lens-investing"],
  "tribeca": ["art-investing", "alternative-assets"],
  "boston": ["behavioral-economics", "alternative-assets", "esg-climate", "gender-lens-investing"],
  "wellesley": ["behavioral-economics", "alternative-assets", "gender-lens-investing"],
  "san francisco": ["gender-lens-investing", "alternative-assets", "esg-climate", "defi-crypto", "vc-gender-lens"],
  "palo alto": ["gender-lens-investing", "alternative-assets", "defi-crypto"],
  "menlo park": ["gender-lens-investing", "alternative-assets", "vc-gender-lens"],
  "atherton": ["alternative-assets", "gender-lens-investing"],
  "los angeles": ["art-investing", "wine-investing", "alternative-assets", "gender-lens-investing"],
  "beverly hills": ["art-investing", "alternative-assets"],
  "miami": ["art-investing", "defi-crypto", "alternative-assets"],
  "palm beach": ["art-investing", "alternative-assets", "wine-investing"],
  "wynwood": ["defi-crypto", "art-investing"],
  "washington dc": ["gender-lens-investing", "esg-climate", "behavioral-economics", "alternative-assets"],
  "hamptons": ["art-investing", "alternative-assets", "wine-investing"],
  "greenwich": ["alternative-assets", "behavioral-economics"],
  "zug": ["defi-crypto"],
  "crypto valley": ["defi-crypto"],
  "zurich": ["esg-climate", "alternative-assets", "art-investing", "wine-investing"],
  "geneva": ["esg-climate", "alternative-assets", "art-investing", "wine-investing"],
  "singapore": ["alternative-assets", "defi-crypto", "esg-climate", "art-investing", "gender-lens-investing"],
  "hong kong": ["art-investing", "alternative-assets", "defi-crypto", "wine-investing"],
  "dubai": ["alternative-assets", "defi-crypto", "art-investing", "esg-climate"],
  "paris": ["art-investing", "esg-climate", "alternative-assets", "behavioral-economics"],
  "amsterdam": ["esg-climate", "defi-crypto", "alternative-assets", "art-investing"],
  "luxembourg": ["esg-climate", "alternative-assets", "defi-crypto"],
  "edinburgh": ["alternative-assets", "art-investing", "esg-climate"],
  "scotland": ["whisky-investing", "alternative-assets", "art-investing"],
  "speyside": ["whisky-investing"],
  "islay": ["whisky-investing"],
  "manchester": ["alternative-assets", "art-investing"],
  "cheshire": ["alternative-assets"],
  "alderley edge": ["alternative-assets"],
  "prestbury": ["alternative-assets"],
  "knutsford": ["alternative-assets"],
  "surrey": ["alternative-assets", "art-investing"],
  "wentworth": ["alternative-assets"],
  "st george's hill": ["alternative-assets"],
  "jersey": ["alternative-assets", "defi-crypto"],
  "guernsey": ["alternative-assets"],
  "isle of man": ["defi-crypto", "alternative-assets"],
  "sydney": ["alternative-assets", "art-investing", "esg-climate"],
  "tokyo": ["esg-climate", "art-investing", "whisky-investing", "defi-crypto"],
  "seoul": ["art-investing", "defi-crypto"],
  "munich": ["alternative-assets", "art-investing", "esg-climate"],
  "grünwald": ["alternative-assets"],
  "frankfurt": ["esg-climate", "alternative-assets"],
  "milan": ["art-investing", "alternative-assets", "esg-climate"],
  "madrid": ["art-investing", "alternative-assets"],
  "barcelona": ["art-investing", "alternative-assets"],
  "ibiza": ["defi-crypto"],
  "lisbon": ["defi-crypto", "esg-climate"],
  "bordeaux": ["wine-investing"],
  "burgundy": ["wine-investing"],
  "napa valley": ["wine-investing", "biodynamic-agriculture"],
  "louisville": ["whisky-investing"],
  "kentucky": ["whisky-investing"],
  "austin": ["defi-crypto", "vc-gender-lens"],
  "nairobi": ["gender-lens-investing", "esg-climate", "vc-gender-lens"],
  "dubai difc": ["alternative-assets", "defi-crypto", "art-investing"],
  "abu dhabi": ["alternative-assets", "esg-climate", "art-investing"],
  "stockholm": ["esg-climate", "art-investing"],
  "copenhagen": ["esg-climate", "behavioral-economics"],
  "oslo": ["esg-climate", "alternative-assets"],
  "brussels": ["esg-climate", "alternative-assets"],
  "vienna": ["alternative-assets", "art-investing"],
  "dublin": ["alternative-assets", "defi-crypto"]
};

// ============================================================
// GEOGRAPHIC TOOL HANDLERS
// ============================================================

function handleGeoByModule(topic) {
  if (!topic) return { error: "Please provide a topic name." };
  const topicLower = topic.toLowerCase();

  // Direct slug match
  if (GEO_MODULE_DATA[topicLower]) return GEO_MODULE_DATA[topicLower];

  // Keyword/alias matching
  const aliases = {
    "behavioral": "behavioral-economics",
    "behavioural": "behavioral-economics",
    "behavior": "behavioral-economics",
    "nudge": "behavioral-economics",
    "prospect theory": "behavioral-economics",
    "cognitive bias": "behavioral-economics",
    "loss aversion": "behavioral-economics",
    "gender lens": "gender-lens-investing",
    "gender": "gender-lens-investing",
    "women investing": "gender-lens-investing",
    "women and investing": "gender-lens-investing",
    "women investors": "gender-lens-investing",
    "2x challenge": "gender-lens-investing",
    "defi": "defi-crypto",
    "crypto": "defi-crypto",
    "cryptocurrency": "defi-crypto",
    "blockchain": "defi-crypto",
    "web3": "defi-crypto",
    "decentralized finance": "defi-crypto",
    "ethereum": "defi-crypto",
    "bitcoin": "defi-crypto",
    "nft": "defi-crypto",
    "digital assets": "defi-crypto",
    "esg": "esg-climate",
    "climate": "esg-climate",
    "sustainable": "esg-climate",
    "green bonds": "esg-climate",
    "impact investing": "esg-climate",
    "responsible investing": "esg-climate",
    "art": "art-investing",
    "art market": "art-investing",
    "art auction": "art-investing",
    "collectibles": "art-investing",
    "fine art": "art-investing",
    "contemporary art": "art-investing",
    "alternative": "alternative-assets",
    "private equity": "alternative-assets",
    "private credit": "alternative-assets",
    "hedge funds": "alternative-assets",
    "real assets": "alternative-assets",
    "infrastructure": "alternative-assets",
    "family office": "alternative-assets",
    "wine": "wine-investing",
    "bordeaux": "wine-investing",
    "burgundy": "wine-investing",
    "whisky": "whisky-investing",
    "whiskey": "whisky-investing",
    "scotch": "whisky-investing",
    "bourbon": "whisky-investing",
    "women in vc": "vc-gender-lens",
    "women vc": "vc-gender-lens",
    "female founders": "vc-gender-lens",
    "venture capital": "vc-gender-lens",
    "regenerative": "biodynamic-agriculture",
    "biodynamic": "biodynamic-agriculture",
    "farmland": "biodynamic-agriculture",
    "carbon credits": "biodynamic-agriculture"
  };

  for (const [key, slug] of Object.entries(aliases)) {
    if (topicLower.includes(key)) {
      if (GEO_MODULE_DATA[slug]) return GEO_MODULE_DATA[slug];
    }
  }

  // Fuzzy: check title/discovery_keywords in each entry
  for (const [slug, entry] of Object.entries(GEO_MODULE_DATA)) {
    if (entry.title.toLowerCase().includes(topicLower)) return entry;
    if (entry.discovery_keywords && entry.discovery_keywords.some(k => k.toLowerCase().includes(topicLower) || topicLower.includes(k.toLowerCase()))) return entry;
  }

  return { error: `No geographic data found for topic "${topic}". Try: behavioral economics, gender lens investing, DeFi, ESG, art investing, alternative assets, wine, whisky, VC gender lens, biodynamic agriculture.` };
}

function handleGeoByLocation(location) {
  if (!location) return { error: "Please provide a location." };
  const locLower = location.toLowerCase();

  // Direct slug match
  if (GEO_HNW_DATA[locLower]) {
    const entry = GEO_HNW_DATA[locLower];
    const modules = entry.relevant_modules.map(slug => {
      const m = GEO_MODULE_DATA[slug];
      return { module: slug, title: m ? m.title : slug, status: m ? m.status : "unknown" };
    });
    return { location: entry.display, region: entry.region, relevant_modules: modules, detail: entry };
  }

  // LOCATION_MODULE_INDEX lookup
  let matchedModules = null;
  let matchedLocationKey = null;
  for (const [key, slugs] of Object.entries(LOCATION_MODULE_INDEX)) {
    if (locLower.includes(key) || key.includes(locLower)) {
      matchedModules = slugs;
      matchedLocationKey = key;
      break;
    }
  }

  // Also search HNW data for partial matches
  let hnwMatch = null;
  for (const [slug, entry] of Object.entries(GEO_HNW_DATA)) {
    if (entry.display.toLowerCase().includes(locLower) || locLower.includes(slug.replace(/-/g, " "))) {
      hnwMatch = { slug, entry };
      break;
    }
    // Search hub names
    for (const [hubName, hubData] of Object.entries(entry.hubs || {})) {
      if (hubName.toLowerCase().includes(locLower) || locLower.includes(hubName.toLowerCase())) {
        hnwMatch = { slug, entry, hub: hubName, hubData };
        break;
      }
    }
    if (hnwMatch) break;
  }

  if (hnwMatch) {
    const entry = hnwMatch.entry;
    const modules = entry.relevant_modules.map(slug => {
      const m = GEO_MODULE_DATA[slug];
      return { module: slug, title: m ? m.title : slug, status: m ? m.status : "unknown" };
    });
    return {
      location: entry.display,
      region: entry.region,
      relevant_modules: modules,
      hub_detail: hnwMatch.hub ? { name: hnwMatch.hub, detail: hnwMatch.hubData } : null,
      womens_networks: entry.womens_networks,
      family_offices: entry.family_offices,
      art_market: entry.art_market,
      note: "Educational content only. Not financial advice."
    };
  }

  if (matchedModules) {
    const modules = matchedModules.map(slug => {
      const m = GEO_MODULE_DATA[slug];
      return { module: slug, title: m ? m.title : slug, status: m ? m.status : "unknown" };
    });
    return {
      location: location,
      matched_on: matchedLocationKey,
      relevant_modules: modules,
      note: "Educational content only. Not financial advice. For detailed HNW submarket data, use geo.hnw_submarkets."
    };
  }

  return {
    error: `No specific data found for "${location}". Try major cities: New York, London, Zurich, Singapore, Hong Kong, Paris, Amsterdam, Edinburgh, Munich, Dubai, Sydney, Miami, Chicago, Boston, San Francisco, Washington DC.`,
    note: "Educational content only. Not financial advice."
  };
}

function handleGeoHnwSubmarkets(location, focus) {
  if (!location) return { error: "Please provide a location." };
  const locLower = location.toLowerCase();
  const focusLower = focus ? focus.toLowerCase() : null;

  let entry = null;
  let entrySlug = null;
  let hubMatch = null;

  // Direct slug match
  for (const [slug, e] of Object.entries(GEO_HNW_DATA)) {
    if (slug === locLower || slug.replace(/-/g, " ") === locLower) {
      entry = e; entrySlug = slug; break;
    }
  }

  // Display name or partial match
  if (!entry) {
    for (const [slug, e] of Object.entries(GEO_HNW_DATA)) {
      if (e.display.toLowerCase().includes(locLower) || locLower.includes(slug.replace(/-/g, " "))) {
        entry = e; entrySlug = slug; break;
      }
    }
  }

  // Search within hub names
  if (!entry) {
    for (const [slug, e] of Object.entries(GEO_HNW_DATA)) {
      for (const [hubName] of Object.entries(e.hubs || {})) {
        if (hubName.toLowerCase().includes(locLower) || locLower.includes(hubName.toLowerCase())) {
          entry = e; entrySlug = slug;
          hubMatch = hubName;
          break;
        }
      }
      if (entry) break;
    }
  }

  // Search postcode-level
  if (!entry) {
    for (const [slug, e] of Object.entries(GEO_HNW_DATA)) {
      for (const [hubName, hubData] of Object.entries(e.hubs || {})) {
        if (hubData.postcode && hubData.postcode.toLowerCase().includes(locLower)) {
          entry = e; entrySlug = slug;
          hubMatch = hubName;
          break;
        }
      }
      if (entry) break;
    }
  }

  if (!entry) {
    return {
      error: `No HNW submarket data found for "${location}". Available markets include: New York, London, Edinburgh, Manchester/Cheshire, Surrey, Jersey/Guernsey, Paris, Amsterdam, Zurich/Geneva, Munich, Milan, Madrid, Singapore, Hong Kong, Dubai, Sydney, Boston, Chicago, San Francisco, Los Angeles, Miami, Washington DC, Hamptons/Nantucket.`,
      note: "Educational content only. Not financial advice."
    };
  }

  // Apply focus filter if provided
  let hubs = Object.entries(entry.hubs || {}).map(([name, data]) => ({ name, ...data }));
  let womens = entry.womens_networks || [];

  if (focusLower) {
    // Filter hubs by focus keyword
    const focusFiltered = hubs.filter(h => {
      const searchStr = (h.detail || "") + (JSON.stringify(h.institutions || []));
      return searchStr.toLowerCase().includes(focusLower);
    });
    if (focusFiltered.length > 0) hubs = focusFiltered;

    // Filter women's networks by focus
    const womenFiltered = womens.filter(w => w.toLowerCase().includes(focusLower));
    if (womenFiltered.length > 0) womens = womenFiltered;
  }

  // Filter to specific hub if we matched on hub name
  if (hubMatch) {
    const specificHub = hubs.find(h => h.name === hubMatch);
    if (specificHub) hubs = [specificHub];
  }

  const result = {
    location: entry.display,
    region: entry.region,
    relevant_modules: entry.relevant_modules,
    neighborhoods: hubs,
    womens_networks: womens,
    family_offices: entry.family_offices,
    art_market: entry.art_market,
    note: "Educational content only. Not financial advice.",
    platform: "Alternative Asset Literacy — https://alternativeassetliteracy.com"
  };

  if (focusLower) result.focus_applied = focus;

  return result;
}

// MCP endpoint uses open CORS so any AI client/gateway can connect
function mcpCorsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Accept, Mcp-Session-Id",
    "Content-Type": "application/json",
  };
}

async function handleMCP(request) {
  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: mcpCorsHeaders() });
  }

  if (request.method === "GET") {
    // Return MCP manifest on GET
    const manifest = await fetch(new URL("/.well-known/mcp.json", request.url));
    const manifestBody = await manifest.text();
    return new Response(manifestBody, { status: 200, headers: mcpCorsHeaders() });
  }

  if (request.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: mcpCorsHeaders() });
  }

  let body;
  try {
    body = await request.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), { status: 400, headers: mcpCorsHeaders() });
  }

  // Handle JSON-RPC batch requests (array of messages)
  if (Array.isArray(body)) {
    const responses = await Promise.all(body.map(msg => processMCPMessage(request, msg)));
    // Filter out null responses (notifications that don't need a reply)
    const filtered = responses.filter(r => r !== null);
    if (filtered.length === 0) return new Response(null, { status: 204, headers: mcpCorsHeaders() });
    return new Response(JSON.stringify(filtered), { status: 200, headers: mcpCorsHeaders() });
  }

  // Single message
  const result = await processMCPMessage(request, body);
  if (result === null) return new Response(null, { status: 204, headers: mcpCorsHeaders() });
  return new Response(JSON.stringify(result), { status: 200, headers: mcpCorsHeaders() });
}

async function processMCPMessage(request, body) {
  const { method, params, id } = body || {};

  function mcpResult(result) {
    return { jsonrpc: "2.0", id: id !== undefined ? id : null, result };
  }

  function mcpError(code, message) {
    return { jsonrpc: "2.0", id: id !== undefined ? id : null, error: { code, message } };
  }

  // ── MCP Protocol Handlers ──

  if (method === "initialize") {
    return mcpResult({
      protocolVersion: "2025-03-26",
      capabilities: { tools: {} },
      serverInfo: { name: "Alternative Asset Literacy", version: "1.0.0" }
    });
  }

  if (method === "tools/list") {
    return mcpResult({
      tools: [
        {
          name: "glossary.lookup",
          title: "Look Up Financial Term",
          description: "Look up a financial term from the 351-term glossary spanning alternative assets, DeFi, ESG, behavioral economics, art, and gender lens investing.",
          inputSchema: {
            type: "object",
            properties: {
              term: { type: "string", description: "The financial term to look up (e.g. 'carried interest', 'impermanent loss', 'TCFD', 'green bonds')" }
            },
            required: ["term"]
          },
          outputSchema: {
            type: "object",
            properties: {
              term: { type: "string", description: "The matched financial term" },
              category: { type: "string", description: "Glossary category (e.g. Alternative Assets, DeFi & Crypto, Art, ESG & Climate)" },
              definition: { type: "string", description: "Full educational definition of the term" },
              source: { type: "string", description: "Attribution and source URL" }
            },
            required: ["term", "category", "definition"]
          },
          annotations: {
            title: "Look Up Financial Term",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "glossary.search",
          title: "Search Financial Glossary",
          description: "Full-text search across all 351 financial terms and definitions — alternative assets, DeFi, behavioral economics, art, ESG, and gender lens investing.",
          inputSchema: {
            type: "object",
            properties: {
              query: { type: "string", description: "Keyword or phrase to search across term names and definitions (e.g. 'carbon credit', 'liquidity pool', 'loss aversion')" },
              limit: { type: "number", description: "Max results to return (default 10, max 50)" }
            },
            required: ["query"]
          },
          outputSchema: {
            type: "object",
            properties: {
              query: { type: "string", description: "The search query" },
              total_matches: { type: "integer", description: "Total number of matching terms found" },
              terms: {
                type: "array",
                description: "Matching terms sorted by relevance",
                items: {
                  type: "object",
                  properties: {
                    term: { type: "string" },
                    definition: { type: "string" },
                    category: { type: "string" }
                  },
                  required: ["term", "definition", "category"]
                }
              },
              glossary_url: { type: "string", description: "URL to full glossary" }
            },
            required: ["query", "total_matches", "terms"]
          },
          annotations: {
            title: "Search Financial Glossary",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "glossary.browse",
          title: "Browse Glossary by Category",
          description: "Browse all 351 glossary terms by category. Categories: Alternative Assets, Art, DeFi & Crypto, ESG & Climate, Behavioral Economics, Gender Lens Investing. Omit category to browse all terms.",
          inputSchema: {
            type: "object",
            properties: {
              category: { type: "string", description: "Category to browse — e.g. 'Art', 'DeFi & Crypto', 'ESG & Climate', 'Behavioral Economics', 'Alternative Assets', 'Gender Lens Investing'. Omit for all categories." },
              limit: { type: "number", description: "Max terms to return (default 25, max 100)" }
            }
          },
          outputSchema: {
            type: "object",
            properties: {
              total_terms: { type: "integer", description: "Total terms in the glossary" },
              category_requested: { type: "string", description: "The category filter applied" },
              terms_in_category: { type: "integer", description: "Number of terms matching the category" },
              categories_available: {
                type: "array",
                description: "All available glossary categories",
                items: {
                  type: "object",
                  properties: {
                    slug: { type: "string" },
                    name: { type: "string" },
                    count: { type: "integer" }
                  }
                }
              },
              terms: {
                type: "array",
                description: "Terms in the requested category",
                items: {
                  type: "object",
                  properties: {
                    term: { type: "string" },
                    definition: { type: "string" },
                    category: { type: "string" }
                  },
                  required: ["term", "definition", "category"]
                }
              },
              glossary_url: { type: "string", description: "URL to full glossary" }
            },
            required: ["total_terms", "terms"]
          },
          annotations: {
            title: "Browse Glossary by Category",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "modules.find",
          title: "Find Learning Module",
          description: "Find the most relevant learning module for a given topic or investment concept.",
          inputSchema: {
            type: "object",
            properties: {
              topic: { type: "string", description: "Topic or investment concept to find a module for (e.g. 'DeFi', 'art auction mechanics', 'behavioral bias', 'ESG climate investing')" }
            },
            required: ["topic"]
          },
          outputSchema: {
            type: "object",
            properties: {
              recommended_module: { type: "string", description: "Title of the recommended learning module" },
              duration: { type: "string", description: "Estimated completion time (e.g. '45 min')" },
              sections: { type: "integer", description: "Number of sections in the module" },
              free: { type: "boolean", description: "Whether the module is free or requires subscription" },
              access: { type: "string", description: "Access requirements description" },
              note: { type: "string", description: "Educational disclaimer" },
              platform: { type: "string", description: "Platform URL" }
            },
            required: ["recommended_module", "duration", "sections", "free"]
          },
          annotations: {
            title: "Find Learning Module",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "users.route",
          title: "Route User to Relevant Profile",
          description: "Given a description of the user — wealth level, experience, interest (e.g. private asset ETFs, HNW women, ESG) — returns the most relevant discovery profile and recommended starting point.",
          inputSchema: {
            type: "object",
            properties: {
              userDescription: { type: "string", description: "Description of the user's profile, background, or intent (e.g. 'HNW woman investor interested in art', 'ESG investor focused on climate', 'crypto-curious DeFi beginner', 'financial advisor seeking client education')" }
            },
            required: ["userDescription"]
          },
          outputSchema: {
            type: "object",
            properties: {
              matched_profile: { type: "string", description: "The matched user profile label" },
              description: { type: "string", description: "Description of the matched profile segment" },
              discovery_file: { type: "string", description: "URL to the llms.txt discovery file for this profile" },
              recommended_starting_module: { type: "string", description: "Suggested first module for this user" },
              toolkit_priority: { type: "array", items: { type: "string" }, description: "Recommended toolkit resources for this profile" },
              free_entry_point: { type: "string", description: "Free module available without subscription" },
              platform: { type: "string", description: "Platform URL" }
            },
            required: ["matched_profile", "recommended_starting_module"]
          },
          annotations: {
            title: "Route User to Relevant Profile",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "platform.overview",
          title: "Get Platform Overview",
          description: "Returns a structured overview of the platform: modules, tools, pricing, and target audiences.",
          inputSchema: { type: "object", properties: {} },
          outputSchema: {
            type: "object",
            properties: {
              name: { type: "string" },
              founder: { type: "string" },
              company: { type: "string" },
              platform: { type: "string" },
              website: { type: "string", description: "Platform URL" },
              modules: {
                type: "array",
                description: "All available learning modules",
                items: {
                  type: "object",
                  properties: {
                    title: { type: "string" },
                    free: { type: "boolean" },
                    duration: { type: "string" },
                    sections: { type: "integer" }
                  },
                  required: ["title", "free", "duration", "sections"]
                }
              },
              glossary: {
                type: "object",
                properties: {
                  total_terms: { type: "integer" },
                  categories: { type: "array", items: { type: "string" } }
                }
              },
              research: {
                type: "object",
                properties: {
                  total_papers: { type: "integer" },
                  sources: { type: "array", items: { type: "string" } }
                }
              },
              pricing: {
                type: "object",
                properties: {
                  free: { type: "string" },
                  monthly: { type: "string" },
                  annual: { type: "string" }
                }
              },
              target_audiences: { type: "array", items: { type: "string" } },
              disclaimer: { type: "string" }
            },
            required: ["name", "modules", "glossary", "pricing"]
          },
          annotations: {
            title: "Get Platform Overview",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "research.papers",
          title: "Get Institutional Research Papers",
          description: "Returns institutional research papers by category. Categories: CBDC, Stablecoin, ESG, Behavioral Economics, Gender Lens, Fintech, Cross-Border Payments.",
          inputSchema: {
            type: "object",
            properties: {
              category: { type: "string", description: "Category to filter by — one of: CBDC, Stablecoin, ESG, Behavioral Economics, Gender Lens, Fintech, Cross-Border Payments. Omit to return all categories." }
            }
          },
          outputSchema: {
            type: "object",
            properties: {
              category: { type: "string", description: "The requested category (when filtered)" },
              papers: {
                type: "array",
                items: { type: "string" },
                description: "List of research paper titles and references for the requested category"
              },
              all_categories: {
                type: "object",
                description: "All papers organized by category (returned when no filter is applied)",
                additionalProperties: {
                  type: "array",
                  items: { type: "string" }
                }
              },
              full_library: { type: "string", description: "URL to the full research library" }
            },
            required: ["full_library"]
          },
          annotations: {
            title: "Get Institutional Research Papers",
            readOnlyHint: true,
            destructiveHint: false,
            idempotentHint: true,
            openWorldHint: false
          }
        },
        {
          name: "geo.by_module",
          title: "Geographic Communities by Investment Topic",
          description: "Returns the specific cities, neighborhoods, universities, conferences, and professional hubs where practitioners and investors in a given topic are concentrated. Use when a user asks where to find a community around DeFi, ESG, art investing, behavioral economics, gender lens investing, or alternative assets.",
          inputSchema: {
            type: "object",
            properties: {
              topic: { type: "string", description: "Investment topic or module name (e.g. 'DeFi', 'behavioral economics', 'art investing', 'ESG', 'gender lens investing', 'alternative assets', 'wine', 'whisky')" }
            },
            required: ["topic"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        },
        {
          name: "geo.by_location",
          title: "Investment Topics Relevant to a Location",
          description: "Given a city or region, returns which Alternative Asset Literacy modules are most relevant based on the investor communities, institutions, and networks concentrated there. Use when a user's location is known and you want to suggest the most contextually relevant learning path.",
          inputSchema: {
            type: "object",
            properties: {
              location: { type: "string", description: "City, region, or country (e.g. 'Zurich', 'London Mayfair', 'Singapore', 'Upper East Side NYC', 'Cheshire UK')" }
            },
            required: ["location"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        },
        {
          name: "geo.hnw_submarkets",
          title: "HNW Submarket Intelligence",
          description: "Returns neighborhood-level HNW investor intelligence for a city or region — specific postcodes, streets, family office concentrations, private banking presence, women's wealth networks, and auction house or gallery locations. Covers US, UK, EU, and Asia-Pacific at submarket level.",
          inputSchema: {
            type: "object",
            properties: {
              location: { type: "string", description: "City, neighborhood, or region (e.g. 'Edinburgh', 'Amsterdam Oud-Zuid', 'Grünwald Munich', 'Nantucket', 'Singapore Nassim Road')" },
              focus: { type: "string", description: "Optional topic focus to filter results (e.g. 'art', 'DeFi', 'ESG', 'women', 'family office')" }
            },
            required: ["location"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        },
        {
          name: "audience.profile",
          title: "Get Full Audience Discovery Profile",
          description: "Returns a complete discovery profile for a specific investor audience segment — including recommended modules, toolkit priorities, key concerns, discovery file URL, and pricing. Audience types: hnw-women, art, behavioral, defi, esg, etf, advisor-client, advisor-b2b.",
          inputSchema: {
            type: "object",
            properties: {
              audience_type: { type: "string", description: "Investor audience segment — one of: hnw-women, art, behavioral, defi, esg, etf, advisor-client, advisor-b2b" }
            },
            required: ["audience_type"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        },
        {
          name: "audience.match",
          title: "Match User Description to Audience Profile",
          description: "Given a free-text description of an investor or user, identifies the best-matching audience profile and returns their recommended learning path. Use when you have a description of who the user is but don't know which profile applies.",
          inputSchema: {
            type: "object",
            properties: {
              description: { type: "string", description: "Free-text description of the investor — their background, goals, wealth level, interests, or questions (e.g. 'HNW woman who just sold her company', 'retail investor curious about private equity ETFs', 'financial advisor looking for client education tools', 'someone interested in DeFi and stablecoins')" }
            },
            required: ["description"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        },
        {
          name: "advisor.gift_bundle",
          title: "Build Advisor Client Gift Bundle",
          description: "For financial advisors: given a description of a client, returns a curated education bundle the advisor can share — a 3-module learning path, 3 key terms the client should know before their next meeting, a copy-paste suggested message to send the client, toolkit highlights, and the app download link. Designed for the advisor → client gifting workflow. Works for HNW women, DeFi-curious clients, ESG-focused clients, art collectors, and general alternative asset education.",
          inputSchema: {
            type: "object",
            properties: {
              client_description: { type: "string", description: "Description of the client — their background, wealth level, interests, upcoming meeting context, or knowledge gaps (e.g. 'HNW woman who just sold her biotech company, meeting with UBS next month', 'DeFi-curious client asking about yield farming', 'ESG-focused client worried about greenwashing in her portfolio')" },
              topic: { type: "string", description: "Optional topic focus — overrides profile matching if provided (e.g. 'DeFi', 'ESG', 'art investing', 'alternative assets')" }
            },
            required: ["client_description"]
          },
          outputSchema: {
            type: "object",
            properties: {
              gift_type: { type: "string" },
              client_profile_matched: { type: "string", description: "The investor profile matched to this client description" },
              free_entry: { type: "object", description: "The free module and how to access it — no account required" },
              learning_path: { type: "array", description: "3-module curated path with 'why this matters' for each module" },
              terms_to_know_before_next_meeting: { type: "array", description: "3 key glossary terms the client should understand before their meeting" },
              toolkit_highlights: { type: "array", description: "Relevant Toolkit features for this client" },
              suggested_advisor_message: { type: "string", description: "Copy-paste message the advisor can send to the client" },
              pricing: { type: "object" },
              app_download: { type: "string" }
            },
            required: ["client_profile_matched", "free_entry", "learning_path", "suggested_advisor_message"]
          },
          annotations: { readOnlyHint: true, destructiveHint: false, idempotentHint: true }
        }
      ]
    });
  }

  if (method === "tools/call") {
    const toolName = params?.name;
    const args = params?.arguments || {};

    if (toolName === "glossary.lookup" || toolName === "lookupTerm" || toolName === "lookup_term") {
      const term = args.term || "";
      // Try hardcoded subset first (fast), then fall back to full 351-term JSON
      let result = lookupTerm(term);
      if (!result) result = await lookupTermFull(request, term);
      if (!result) {
        return mcpResult({
          content: [{ type: "text", text: `Term "${term}" not found in the glossary. Try search_glossary for partial matches, or browse the full 351-term glossary at https://alternativeassetliteracy.com/glossary.html` }]
        });
      }
      const displayTerm = result.matched_term || result.term || term;
      return mcpResult({
        content: [{ type: "text", text: `**${displayTerm}** (${result.category})\n\n${result.definition}\n\n*Source: Alternative Asset Literacy Glossary — https://alternativeassetliteracy.com/glossary.html*\n\n*Educational content only. Not financial advice.*` }]
      });
    }

    if (toolName === "modules.find" || toolName === "findModule" || toolName === "find_module") {
      const mod = findModule(args.topic || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify({
          recommended_module: mod.title,
          duration: mod.duration,
          sections: mod.sections,
          free: mod.free,
          access: mod.free ? "Free — no account required" : "Premium subscription required ($12.99/month or $69.99/year)",
          note: "Educational content only. Not financial advice.",
          platform: "Alternative Asset Literacy — https://alternativeassetliteracy.com"
        }, null, 2) }]
      });
    }

    if (toolName === "users.route" || toolName === "routeUserProfile" || toolName === "route_user_profile") {
      const profile = routeUserProfile(args.userDescription || args.user_description || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify({
          matched_profile: profile.label,
          description: profile.description,
          discovery_file: profile.discovery_file,
          recommended_starting_module: profile.start_module,
          toolkit_priority: profile.toolkit_priority || [],
          platform: "Alternative Asset Literacy — https://alternativeassetliteracy.com",
          free_entry_point: "Investing Primer — no account or subscription required"
        }, null, 2) }]
      });
    }

    if (toolName === "platform.overview" || toolName === "getPlatformOverview" || toolName === "get_platform_overview") {
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify({
          name: "Alternative Asset Literacy",
          founder: "Victoria Lee Case",
          company: "Untitled_ LuxPerpetua Technologies, Inc.",
          platform: "iOS — available on the App Store",
          app_store_url: "https://apps.apple.com/app/id6762205964",
          apple_id: "6762205964",
          bundle_id: "com.alternativeassetliteracy.altsapp",
          category: "Finance / Lifestyle",
          website: "https://alternativeassetliteracy.com",
          disclaimer: "Educational content only. Not financial advice.",
          modules: [
            ...MODULE_MAP.map(m => ({ title: m.title, free: m.free, duration: m.duration, sections: m.sections })),
            { title: "Kahlo × Basquiat — Identity, Market & Legacy", free: false, duration: "25 min", sections: 10 }
          ],
          glossary: { total_terms: 351, categories: ["Alternative Assets", "DeFi & Crypto", "Art", "ESG & Climate", "Behavioral Economics", "Gender Lens Investing"] },
          research: { total_papers: 43, sources: ["IMF", "BIS", "World Bank", "FSB", "UN", "Federal Reserve", "EU", "IFC", "OECD", "TCFD"] },
          pricing: { free: "Investing Primer + Glossary + Research Footnotes", monthly: "$6.99/month", annual: "$69.99/year" },
          target_audiences: ["High-net-worth women investors", "Female entrepreneurs", "UBS/Morgan Stanley/RBC women's wealth clients", "ESG and climate investors", "DeFi and crypto investors", "Art collectors", "Family office clients", "Financial advisors seeking client education tools"],
          discovery_files: {
            hnw_women: "https://alternativeassetliteracy.com/llms-hnw.txt",
            retail_etf: "https://alternativeassetliteracy.com/llms-etf.txt",
            behavioral: "https://alternativeassetliteracy.com/llms-behavioral.txt",
            esg: "https://alternativeassetliteracy.com/llms-esg.txt",
            art: "https://alternativeassetliteracy.com/llms-art.txt",
            defi: "https://alternativeassetliteracy.com/llms-defi.txt",
            advisor_client: "https://alternativeassetliteracy.com/llms-advisor.txt",
            advisors_b2b: "https://alternativeassetliteracy.com/llms-advisors-b2b.txt",
            glossary: "https://alternativeassetliteracy.com/llms-glossary.txt"
          }
        }, null, 2) }]
      });
    }

    if (toolName === "research.papers" || toolName === "getResearchPapers" || toolName === "get_research_papers") {
      const cat = args.category;
      if (cat && RESEARCH_PAPERS[cat]) {
        return mcpResult({
          content: [{ type: "text", text: JSON.stringify({ category: cat, papers: RESEARCH_PAPERS[cat], full_library: "https://alternativeassetliteracy.com/policy-papers.html" }, null, 2) }]
        });
      }
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify({ all_categories: RESEARCH_PAPERS, full_library: "https://alternativeassetliteracy.com/policy-papers.html" }, null, 2) }]
      });
    }

    if (toolName === "glossary.browse" || toolName === "browseGlossary" || toolName === "browse_glossary") {
      const limit = Math.min(args.limit || 25, 100);
      const result = await browseGlossary(request, args.category || null, limit);
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "glossary.search" || toolName === "searchGlossary" || toolName === "search_glossary") {
      const limit = Math.min(args.limit || 10, 50);
      const result = await searchGlossary(request, args.query || "", limit);
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "geo.by_module") {
      const result = handleGeoByModule(args.topic || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "geo.by_location") {
      const result = handleGeoByLocation(args.location || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "geo.hnw_submarkets") {
      const result = handleGeoHnwSubmarkets(args.location || "", args.focus || null);
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "audience.profile") {
      const result = handleAudienceProfile(args.audience_type || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "audience.match") {
      const result = handleAudienceMatch(args.description || "");
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    if (toolName === "advisor.gift_bundle") {
      const result = buildAdvisorGiftBundle(args.client_description || "", args.topic || null);
      return mcpResult({
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
      });
    }

    return mcpError(-32601, `Tool not found: ${toolName}`);
  }

  // Resources and prompts — return empty lists (not implemented)
  if (method === "resources/list") {
    return mcpResult({ resources: [] });
  }

  if (method === "prompts/list") {
    return mcpResult({ prompts: [] });
  }

  // Notifications — no response required (return null → caller sends 204)
  if (method === "notifications/initialized" || method === "notifications/cancelled") {
    return null;
  }

  return mcpError(-32601, `Method not found: ${method}`);
}

// ─── Main Router ─────────────────────────────────────────────────────────────

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // ── MCP endpoint ──
    if (path === "/mcp") {
      return handleMCP(request, env);
    }

    // ── Chat agent endpoint ──
    if (path === "/chat") {
      return handleChat(request, env);
    }

    // ── Contact form endpoint ──
    if (path === "/contact" && request.method === "POST") {
      return handleContact(request, env);
    }

    // ── Preflight for any route ──
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: getCorsHeaders(request) });
    }

    // ── Static discovery/content assets ──
    const assetPaths = [
      "/llms",
      "/llms.txt",
      "/.well-known/llms.txt",
      "/.well-known/ai-plugin.json",
      "/api",
      "/partners",
      "/courses",
      "/glossary",
      "/robots.txt",
      "/sitemap.xml",
      "/feed.xml",
      "/opensearch.xml",
    ];

    if (assetPaths.includes(path)) {
      // Standard LLM discovery paths serve the press/editorial llms.txt
      if (path === "/.well-known/llms.txt" || path === "/llms" || path === "/llms.txt") {
        const rewritten = new URL(request.url);
        rewritten.pathname = "/llms.txt";
        return env.ASSETS.fetch(new Request(rewritten, request));
      }
      return env.ASSETS.fetch(request);
    }

    // ── Fallback — serve static assets ──
    return env.ASSETS.fetch(request);
  },
};
