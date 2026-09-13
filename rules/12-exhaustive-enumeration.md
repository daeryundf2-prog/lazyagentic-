# 12. Exhaustive Enumeration & Uncovered-Scope Declaration

> **Trigger**: When the user asks to enumerate, list, review, audit, or inventory items — e.g. "전부/모두/빠짐없이/전수/다 보여줘", "review all repositories", "list every finding", or any request whose deliverable is a set of items.

## Directives

1. **Anchor the Count to the Source**:
   - Before answering, determine the source item count mechanically (file glob, `wc -l`, grep count, manifest length) whenever the universe is enumerable.
   - State the count explicitly in the answer (e.g. "총 N건"). If the universe is not enumerable, state that boundary instead of silently picking a few.

2. **No Salience Truncation**:
   - Do NOT collapse an enumeration request into "top N" / "주요 항목" / three representative examples unless the user asked for a ranking or sample.
   - If the full list is too long for one response, enumerate all items anyway using compact one-line rows, or continue across clearly numbered chunks — never drop items without saying so.

3. **Attach Grounding Evidence per Item**:
   - Every enumerated item must carry a verifiable anchor: `file:line`, commit SHA, command output, or a stated source. Items without anchors get marked `(근거 없음)` rather than being silently asserted.

4. **Declare Uncovered Scope**:
   - Every enumeration/review answer MUST end with an explicit scope declaration: what was covered, and what was NOT covered (directories skipped, tests not run, assets unavailable, etc.).
   - Omitting this declaration is a rule violation even when the answer itself is complete.

5. **Completeness Claims Require Receipts**:
   - Claims of "전수", "100%", "모두", "전부 커버" require a mechanical receipt — `coverage_audit.mjs --source <원문> --target <산출>` where available, or the enumeration count + method shown. No receipt → phrase it as "확인한 범위 내" instead.

6. **Division Over Delegation**:
   - When the universe exceeds ~20 items, split the enumeration by structural boundary (directory, category, file) and cover each partition explicitly — do not let the model self-select a representative subset.

7. **No Placeholder Stubs (Implementation Truncation)**:
   - When implementation was requested, delivering `// TODO`, `pass`, `...`, or stub bodies in place of working logic is enumeration-truncation in code form — the same violation as cutting a list short.
   - If full implementation genuinely exceeds one response, state which parts are real and which remain, with a concrete continuation plan — never present scaffold as finished work.
