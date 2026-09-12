# lazyagentic-enforced — Enforced Split

본체(rules-only)와 분리된 강제 실행판이다.
PreToolUse intent-guard + Stop 턴 감사 + MCP lint-rules로 한글 문체를 검사한다.

## 설치법
1. 플러그인 디렉터리에 lazyagentic-enforced로 클론한다.
2. 예: ~/.gemini/config/plugins/lazyagentic-enforced 로 클론한다.
3. 본체 lazyagentic와 병행 가능하며 같은 세션에 함께 둘 수 있다.
4. 이름·경로가 달라 충돌 없음이 보장된다.

## 구성
- plugin.json: name lazyagentic-enforced, version 1.0.0, rulesVersion 3.28.0.
- hooks.json: PreToolUse 1개 + Stop 1개(turn audit).
- hooks/intent-guard/intent-guard.mjs: FAIL_OPEN 가드.
- mcp/lint-rules: scan_korean_prose 13종 검사(의존성 0).

## 검증
node --test enforced/mcp/lint-rules/test/scan.test.mjs 실행으로 통과를 확인한다.
node --check 2파일과 기존 sh ALL PASSED를 함께 유지한다.

## 판정 로그
- `LAZYAGENTIC_GUARD_LOG`: 설정 시 intent-guard 판정 1줄(JSON) append.
- `LAZYAGENTIC_LINT_LOG`: 설정 시 scan_korean_prose 요약 1줄(JSON) append.
- 미설정 시 로그 미생성(기존 stdout 동작 유지).
