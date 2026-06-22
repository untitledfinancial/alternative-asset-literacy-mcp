/**
 * Alternative Asset Literacy — AI Chat Widget
 * =============================================
 * Embeddable chat agent powered by Cloudflare Workers AI.
 * Answers questions about alternative assets, glossary terms,
 * modules, research papers, and the platform.
 * Escalates to human via contact form when needed.
 */

(function () {
  "use strict";

  // ── Configuration ──────────────────────────────────────────────────────────
  const CHAT_ENDPOINT = "/chat";
  const MAX_MESSAGES = 20;
  const ESCALATION_EMAIL = "hello@alternativeassetliteracy.com";

  // ── State ──────────────────────────────────────────────────────────────────
  let isOpen = false;
  let isLoading = false;
  let messages = [];
  let conversationId = crypto.randomUUID();

  // ── DOM Creation ───────────────────────────────────────────────────────────

  function createWidget() {
    // Container
    const container = document.createElement("div");
    container.id = "aal-chat";
    container.innerHTML = `
      <button id="aal-chat-toggle" aria-label="Open chat assistant">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
        </svg>
      </button>

      <div id="aal-chat-window" class="aal-chat-hidden">
        <div id="aal-chat-header">
          <div id="aal-chat-header-info">
            <span id="aal-chat-title">Research Assistant</span>
            <span id="aal-chat-subtitle">Alternative Asset Literacy</span>
          </div>
          <button id="aal-chat-close" aria-label="Close chat">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
              <path d="M18 6L6 18"/><path d="M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <div id="aal-chat-messages"></div>

        <div id="aal-chat-input-wrap">
          <textarea id="aal-chat-input" placeholder="Ask about investing, glossary terms, modules..." rows="1"></textarea>
          <button id="aal-chat-send" aria-label="Send message" disabled>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4z"/>
            </svg>
          </button>
        </div>

        <div id="aal-chat-disclaimer">
          Educational content only. Not financial advice. <a href="/terms.html" target="_blank">Terms</a>
        </div>
      </div>
    `;
    document.body.appendChild(container);

    // ── Event Binding ──────────────────────────────────────────────────────
    const toggle = document.getElementById("aal-chat-toggle");
    const close = document.getElementById("aal-chat-close");
    const window_ = document.getElementById("aal-chat-window");
    const input = document.getElementById("aal-chat-input");
    const send = document.getElementById("aal-chat-send");
    const messagesEl = document.getElementById("aal-chat-messages");

    toggle.addEventListener("click", () => {
      isOpen = !isOpen;
      window_.classList.toggle("aal-chat-hidden", !isOpen);
      toggle.classList.toggle("aal-chat-toggle-active", isOpen);
      if (isOpen && messages.length === 0) {
        addBotMessage(getWelcomeMessage());
      }
      if (isOpen) input.focus();
    });

    close.addEventListener("click", () => {
      isOpen = false;
      window_.classList.add("aal-chat-hidden");
      toggle.classList.remove("aal-chat-toggle-active");
    });

    input.addEventListener("input", () => {
      send.disabled = !input.value.trim() || isLoading;
      // Auto-resize
      input.style.height = "auto";
      input.style.height = Math.min(input.scrollHeight, 100) + "px";
    });

    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        if (input.value.trim() && !isLoading) sendMessage();
      }
    });

    send.addEventListener("click", () => {
      if (input.value.trim() && !isLoading) sendMessage();
    });
  }

  // ── Messages ───────────────────────────────────────────────────────────────

  function getWelcomeMessage() {
    return "Welcome to Alternative Asset Literacy. I can help with:\n\n" +
      "\u2022 **Glossary terms** \u2014 351 definitions across 6 categories\n" +
      "\u2022 **Module details** \u2014 9 research-backed courses\n" +
      "\u2022 **Research papers** \u2014 43 institutional sources\n" +
      "\u2022 **General questions** about alternative investing, DeFi, behavioral economics, art markets, ESG, and more\n\n" +
      "What would you like to know?";
  }

  function addBotMessage(text) {
    messages.push({ role: "assistant", content: text });
    renderMessage("assistant", text);
  }

  function addUserMessage(text) {
    messages.push({ role: "user", content: text });
    renderMessage("user", text);
  }

  function renderMessage(role, text) {
    const messagesEl = document.getElementById("aal-chat-messages");
    const msg = document.createElement("div");
    msg.className = `aal-chat-msg aal-chat-msg-${role}`;

    const bubble = document.createElement("div");
    bubble.className = "aal-chat-bubble";
    bubble.innerHTML = formatMarkdown(text);

    msg.appendChild(bubble);
    messagesEl.appendChild(msg);
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  function renderTypingIndicator() {
    const messagesEl = document.getElementById("aal-chat-messages");
    const msg = document.createElement("div");
    msg.className = "aal-chat-msg aal-chat-msg-assistant";
    msg.id = "aal-chat-typing";

    const bubble = document.createElement("div");
    bubble.className = "aal-chat-bubble aal-chat-typing";
    bubble.innerHTML = '<span></span><span></span><span></span>';

    msg.appendChild(bubble);
    messagesEl.appendChild(msg);
    messagesEl.scrollTop = messagesEl.scrollHeight;
  }

  function removeTypingIndicator() {
    const typing = document.getElementById("aal-chat-typing");
    if (typing) typing.remove();
  }

  // ── Markdown (minimal) ─────────────────────────────────────────────────────

  function formatMarkdown(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
      .replace(/\*(.+?)\*/g, "<em>$1</em>")
      .replace(/\[(.+?)\]\((.+?)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>')
      .replace(/\n\n/g, "</p><p>")
      .replace(/\n/g, "<br>")
      .replace(/\u2022/g, "&bull;")
      .replace(/^/, "<p>")
      .replace(/$/, "</p>");
  }

  // ── Send Message ───────────────────────────────────────────────────────────

  async function sendMessage() {
    const input = document.getElementById("aal-chat-input");
    const send = document.getElementById("aal-chat-send");
    const text = input.value.trim();

    if (!text || isLoading) return;

    addUserMessage(text);
    input.value = "";
    input.style.height = "auto";
    send.disabled = true;
    isLoading = true;

    renderTypingIndicator();

    try {
      // Build conversation history (last N messages for context)
      const history = messages
        .filter((m) => m.role === "user" || m.role === "assistant")
        .slice(-10)
        .map((m) => ({ role: m.role, content: m.content }));

      const response = await fetch(CHAT_ENDPOINT, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          messages: history,
          conversation_id: conversationId,
        }),
      });

      removeTypingIndicator();

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();

      if (data.escalate) {
        addBotMessage(data.response + `\n\n[Contact us](${"/contact.html"}) or email **${ESCALATION_EMAIL}** and we'll get back to you.`);
      } else {
        addBotMessage(data.response);
      }

      // Trim conversation if too long
      if (messages.length > MAX_MESSAGES * 2) {
        messages = messages.slice(-MAX_MESSAGES);
      }
    } catch (err) {
      removeTypingIndicator();
      addBotMessage(
        "I'm having trouble connecting right now. You can reach us at [contact us](/contact.html) or email **" +
          ESCALATION_EMAIL +
          "**."
      );
      console.error("AAL Chat error:", err);
    }

    isLoading = false;
    send.disabled = !input.value.trim();
  }

  // ── Initialize ─────────────────────────────────────────────────────────────

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", createWidget);
  } else {
    createWidget();
  }
})();
