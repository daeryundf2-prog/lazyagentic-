# LazyAgentic — Agentic Sanctuary & Situational Routing

LazyAgentic is the 4th core plugin in the Lazy series (`lazyantigravity`, `lazyforensic`, `lazyothers`, `lazyagentic`).

Default host: **Google Antigravity**. Keep the session UI on **Gemini 3.8 Flash (High)**. This plugin is rules-only (no hooks, no MCP). The host does not rewrite the session model per role.

It implements the **Agentic Sanctuary** architecture adapted from vesperchant's Gemini guide:
- **Situational Path Reference System (`RULES.md` v3.28)**: On-demand modular rule loading to prevent context-window bloat.
- **Fail-Closed Instinct (`rules/00-instinct.md`)**: Anti-hallucination mandate ensuring uncertainty is verified against primary sources.
- **Natural Korean Prose Policy (`rules/03-korean-natural-prose.md`)**: Eradicating translation-ese, zero-anaphora, and AI signature cliches.
- **Dual-Mount Sanctuary**: Linked to `~/agentic` via Windows Directory Junction. If the junction is missing, agents must read `~/.gemini/config/plugins/lazyagentic/` instead.