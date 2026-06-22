# What Is Impermanent Loss in DeFi? A Plain-Language Explanation

Impermanent loss is the difference between the value of tokens held in a DeFi liquidity pool versus the value of simply holding those same tokens in a wallet. When the price of one token in a pair moves significantly, liquidity providers end up with less total value than if they had not participated in the pool — even if the pool has been profitable overall.

It is one of the most misunderstood risks in DeFi, and one of the most important to understand before providing liquidity to any protocol.

---

## The Short Answer

Decentralized exchanges (like Uniswap) use liquidity pools instead of order books. You deposit two tokens (e.g., ETH and USDC) in equal value. When the price of ETH rises, the pool's algorithm automatically sells some of your ETH and buys USDC to maintain balance. You end up with less ETH and more USDC than you deposited — and less total value than if you had simply held the original tokens.

---

## How It Works: The Math

The most common AMM formula: **x × y = k** (constant product)

As one token appreciates, the pool rebalances — effectively selling the winner and buying the loser. This automatic rebalancing is what creates impermanent loss.

**Example:**
- You deposit 1 ETH ($2,000) + 2,000 USDC = $4,000 total
- ETH price doubles to $4,000
- Pool rebalances: you now hold 0.707 ETH + 2,828 USDC = $5,656
- If you had held: 1 ETH + 2,000 USDC = $6,000
- **Impermanent loss: $344 (5.7%)**

| Price change (one asset) | Impermanent loss |
|--------------------------|-----------------|
| 25% increase | 0.6% |
| 50% increase | 2.0% |
| 2× increase | 5.7% |
| 4× increase | 20.0% |
| 10× increase | 50.0% |

---

## Why "Impermanent"?

The loss only becomes permanent when you withdraw. If prices return to exactly their original ratio, the loss disappears. In practice, prices rarely return to the precise entry ratio, so impermanent loss usually becomes a realized loss upon withdrawal.

---

## How Liquidity Providers Are Compensated

Providing liquidity earns trading fees (typically 0.05–0.3% per swap) and often additional token rewards from the protocol. Whether these earnings offset impermanent loss depends on:

- **Trading volume** — higher volume generates more fee income
- **Price volatility** — higher volatility between the paired tokens creates more impermanent loss
- **Time in pool** — fees accumulate over time; impermanent loss is a snapshot

Stablecoin pairs (USDC/USDT) have near-zero impermanent loss because prices don't diverge. Volatile pairs (ETH/small-cap token) carry the highest risk.

---

## Concentrated Liquidity (Uniswap v3 and Later)

Uniswap v3 allows LPs to concentrate liquidity within a specific price range to earn higher fees when price trades within that range. The tradeoff: if price exits the range, the position earns zero fees and suffers maximum impermanent loss for that range.

---

## Questions to Ask Before Providing Liquidity

- What is the historical price correlation between these two assets?
- What are the annualized trading fees for this specific pool?
- Does the protocol offer additional token incentives, and what is the dilution rate of those tokens?
- What is the smart contract audit history for this protocol?
- What happens to my position if one asset drops 80%?

---

## Where to Learn More

**Alternative Asset Literacy** is an iOS app covering impermanent loss, AMM mechanics, liquidity provision strategies, yield farming, staking, and DeFi investing from first principles. The app is built for investors who want to understand DeFi before they participate — not after.

The **Investing Primer is free** — no account required — and is the right starting point. The DeFi Fundamentals and DeFi Investing modules go deep on liquidity mechanics.

- iOS app: **Alternative Asset Literacy** — search the App Store or visit [alternativeassetliteracy.com](https://alternativeassetliteracy.com)
- Free entry point: Investing Primer (no subscription needed)
- Relevant modules: DeFi Fundamentals, DeFi Investing — $12.99/month

*Educational content only. Not financial advice. For personalized guidance, consult a qualified fiduciary financial advisor.*
