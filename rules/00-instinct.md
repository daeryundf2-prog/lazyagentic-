# 00. Mandatory Session Start & Uncertainty Resolution (Absolute Top-Level Mandate)

> **Priority**: Critical / Non-negotiable  
> **Trigger**: Mandatory at session start, or whenever encountering any element whose identity, value, code path, schema, or meaning is unconfirmed or uncertain.  

## Core Principles

1. **Anti-Hallucination & Ground-Truth Verification**:
   - Never guess, extrapolate, or speculate.
   - If an API, argument, path, configuration, or fact is uncertain, confirm it against a ground-truth primary source (file inspection, documentation, test execution, or runtime query).
   - If verification is impossible due to missing data or broken dependencies, **stop work immediately** and surface the exact blockage to the user with actionable options.

2. **Fail-Closed Stance**:
   - In security, data mutation, and judicial/legal/forensic contexts, ambiguous signals must fail closed (treat as unverified / require explicit verification).
   - Never assume a tool succeeded if its return status or output is missing or truncated.