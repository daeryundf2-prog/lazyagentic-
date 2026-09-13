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

4. **File Modification via Dedicated Tools Only**:
   - Never modify file contents through the shell (`>`, `>>`, `Set-Content`, `Out-File`, `sed -i`, `tee`, here-docs) when a dedicated file-edit tool (`write_to_file`/`replace_file_content`/edit tool) exists in the harness.
   - Rationale: shell writes bypass the editor's encoding handling and have corrupted non-ASCII (Korean) comments wholesale on PowerShell locales. Shell commands may create *new* scratch artifacts only when no edit tool applies; source and document files are always edited through file tools.