---
trigger: always_on
---

# LazyAgentic Global Rule Entry Point

Host: **Google Antigravity**. Keep the session UI on **Gemini 3.8 Flash (High)**. The host does not rewrite the session model per role (`canAutoRoute=false`). Pass `invoke_subagent` `Subagents[].Model` (`flash` / `pro` / `flash_lite`) as an agent hint only — do not claim the child model changed unless host `modelName` differs.

At the start of every session, before performing any tasks or replying to the user, you MUST read the following absolute entry point files. Prefer the Dual-Mount path; if it is missing, use the plugin install path.

1. `~/agentic/RULES.md` or `~/.gemini/config/plugins/lazyagentic/RULES.md`
2. `~/agentic/rules/00-instinct.md` or `~/.gemini/config/plugins/lazyagentic/rules/00-instinct.md`
3. `~/agentic/rules/03-korean-natural-prose.md` or `~/.gemini/config/plugins/lazyagentic/rules/03-korean-natural-prose.md`

You must strictly follow every instruction in `RULES.md`, `00-instinct.md`, and `03-korean-natural-prose.md`. When a situational trigger listed in `RULES.md` applies to your task, read the referenced `rules/##-name.md` file once per session and follow its directives without exception.

## Universal CLI Execution Mandate
- **Canonical SSOT Source**: `~/agentic/rules/08-cli-execution.md` or `~/.gemini/config/plugins/lazyagentic/rules/08-cli-execution.md`
- On Antigravity the shell tool may be named `Shell`, `Bash`, `run_command`, or `execute_command`. Follow the same safety rules regardless of the host tool name.