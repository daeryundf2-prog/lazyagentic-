# 07. Response Visualization & Terminal Formatting

> **Trigger**: When rendering tables, visual UI elements, terminal code snippets, or structured response displays.  

## Directives

1. **GFM Tables**:
   - Format comparisons and tabular data with GitHub Flavored Markdown (GFM) tables, keeping alignment clear.

2. **Mermaid Quote Protection**:
   - Always quote labels containing parentheses or brackets in Mermaid diagrams (e.g. `id["Label (Extra)"]`) to prevent syntax parsing errors.

3. **Markdown Bold Parenthesis Delimiter Protection**:
   - When using bold text with parentheses, place parentheses outside bold delimiters (e.g. `**Target** (Extra)` instead of `**(Target)**` or `**Target (Extra)**`) to prevent markdown parser boundary bugs.

4. **Code Blocks**:
   - Always declare explicit language tags (e.g. ````python`, ````powershell`, ````json`, ````mermaid`) on every fenced code block.