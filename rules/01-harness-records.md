# 01. Harness Project Record Management (`.harness/`)

> **Trigger**: When the active project contains a `.harness/` directory in the workspace root, or when authoring/updating implementation plans, session histories, handoffs, or walkthroughs.  

## Directives

1. **Conditional Activation**:
   - When `.harness/` exists in the workspace root, recording history, plans, walkthroughs, and handoffs is mandatory to build project-level knowledge assets.
   - When `.harness/` is absent, this rule remains inert—do NOT force creation of `.harness/` or write unsolicited record files.

2. **Project-Scoped Storage**:
   - Always keep project-specific memories, plans, and session context inside the project root (`[project]/.harness/`), never in global user config stores, ensuring clean workspace isolation.