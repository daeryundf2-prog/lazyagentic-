#!/usr/bin/env node
// intent-guard.mjs (enforced) — copied from body hooks/intent-guard/intent-guard.mjs
// FAIL_OPEN -> ask 성격: 파싱 실패/전사 누락 시 차단하지 않고 approve(확인 질문으로 전환)
// Input: hook JSON via stdin { event, transcript_path }. Output: decision JSON to stdout.
import { readFileSync, existsSync } from "node:fs";
const KEYWORDS_EN = ["unverified", "assumed", "speculative"];
const KEYWORDS_KO = ["아마도", "추정컨대", "확실하지 않", "검증 없이"];
const KEYWORDS = [...KEYWORDS_EN, ...KEYWORDS_KO];
async function readStdin() {
  let d = "";
  for await (const c of process.stdin) d += c;
  return d.trim();
}
function approve(reason) {
  console.log(JSON.stringify({ decision: "approve", reason }));
}
function cont(reason) {
  console.log(JSON.stringify({ decision: "continue", reason }));
}
async function main() {
  let evt = {};
  try { evt = JSON.parse((await readStdin()) || "{}"); } catch { approve("unparseable input"); return; }
  const tp = evt.transcript_path || evt.transcriptPath || "";
  if (!tp) { approve("no transcript — nothing to audit"); return; }
  if (!existsSync(tp)) { approve("transcript missing — nothing to audit"); return; }
  let text = "";
  try { text = readFileSync(tp, "utf8"); } catch { approve("transcript unreadable"); return; }
  const low = text.toLowerCase();
  const hit = KEYWORDS.filter((k) => low.includes(k.toLowerCase()) || text.includes(k));
  if (hit.length > 0) { cont(`unverified-claim keyword: ${hit.join(", ")}`); return; }
  approve("no unverified-claim keyword");
}
main();
