#!/usr/bin/env node
// intent-guard.mjs — STOP/PreToolUse minimal scaffold (rules-only repo, no auto-registration)
// Input: hook JSON via stdin { event, transcript_path }. Output: decision JSON to stdout.
import { readFileSync, existsSync } from "node:fs";
const KEYWORDS = ["unverified", "assumed", "speculative"];
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
  const hit = KEYWORDS.filter((k) => low.includes(k));
  if (hit.length > 0) { cont(`unverified-claim keyword: ${hit.join(", ")}`); return; }
  approve("no unverified-claim keyword");
}
main();
