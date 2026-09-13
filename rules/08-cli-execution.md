# 08. CLI Command Execution & Safety (Windows & PowerShell Optimized)

> **Trigger**: When executing shell commands via Antigravity `Shell` / `Bash` / `run_command` / `execute_command`, writing CLI scripts, or configuring terminal sandbox execution.  

## Directives

1. **Workspace Boundary Containment**:
   - Commands must remain strictly confined to the active workspace or project directory unless user-approved system operations are explicitly requested.
   - Avoid dangerous broad directory scans or mutating system-wide files.

2. **Clean & Deterministic Command Formulation**:
   - Favor clear, single-purpose commands.
   - In PowerShell, prefer idiomatic cmdlets (`Get-ChildItem`, `Test-Path`, `Select-String`) or standard binaries.
   - For chained setup operations, keep commands sequential and check exit codes or success status honestly.

3. **Background & Long-Running Tasks**:
   - Respect asynchronous execution. Never poll background tasks in busy loops; let reactive wakeups notify when execution completes.
   - Exception: when the harness has no completion-notification mechanism (background tasks that never report back), bounded interval polling or an explicit status check is required — do not wait indefinitely for a wakeup that cannot arrive.

4. **File Modification via Dedicated Tools Only**:
   - Never modify file contents through the shell (`>`, `>>`, `Set-Content`, `Out-File`, `sed -i`, `tee`, here-docs) when a dedicated file-edit tool (`write_to_file`/`replace_file_content`/edit tool) exists in the harness.
   - Rationale: shell writes bypass the editor's encoding handling and have corrupted non-ASCII (Korean) comments wholesale on PowerShell locales. Shell commands may create *new* scratch artifacts only when no edit tool applies; source and document files are always edited through file tools.

5. **Destructive Command Path Safety**:
   - Always quote every path in `rm`/`del`/`Remove-Item`/`Move-Item` and any command that deletes, moves, or overwrites — an unquoted space turns `D:\folder name` into a delete of `D:\folder`.
   - Before executing a recursive or wildcard delete, list the resolved target first (`Get-ChildItem`/`ls` on the exact quoted path) and verify it is the intended directory and inside the workspace. Never fire a bulk delete at a path you have not inspected resolved.
   - Prefer recoverable operations (move to trash/backup dir) over hard deletes when the target is user data.

6. **Bounded Retry & Loop Breaking**:
   - If a tool call or command fails identically 3 times in a row (same error, same empty/`CLEARED` status), stop retrying: surface the failure to the user with the exact error instead of burning quota in a retry loop.
   - Never fabricate or simulate the output of a failed tool (e.g. inventing search results when `search_web` errors) — a failed tool is reported as failed, and an alternative path is proposed explicitly.