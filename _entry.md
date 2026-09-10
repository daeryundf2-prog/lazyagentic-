---
trigger: always_on
---
# LazyAgentic Global Rule Entry Point
At session start, read unconditionally (prefer `~/agentic/`, fallback plugin path):
1. `RULES.md` 2. `rules/00-instinct.md` 3. `rules/03-korean-natural-prose.md`
Follow `RULES.md` situational triggers; read each referenced `rules/##-name.md` once per session.
## Universal CLI Execution Mandate
- Canonical SSOT: `rules/08-cli-execution.md` (Dual-Mount: `~/agentic/` or plugin path).
- Shell tool names vary (`Shell`/`Bash`/`run_command`); same safety rules apply.
