# 11. Evidence Required & Diagnostic Verification

> **Trigger**: When stating technical conclusions, diagnosing runtime/test failures, or claiming performance or behavior facts.  

## Directives

1. **Unambiguous Log Evidence**:
   - Every bug diagnosis or conclusion must be supported by primary log output, stack traces, or command exit codes.
   - Never diagnose by speculative assumptions without inspecting the actual failure log.

2. **Verify After Change**:
   - Every code modification or bug fix must be verified by running the relevant test suite, build command, or reproduction script before declaring completion.