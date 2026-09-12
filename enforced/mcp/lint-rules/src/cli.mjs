#!/usr/bin/env node
// lint-rules MCP server skeleton (dependency-free).
// Tool: scan_korean_prose — 13 regex rules (zero-anaphora excluded: auto-detection infeasible).
// Rule breakdown: 박다 variants 3 + double-passive 2 + ~에의해 1 + ~축 1
//   + experience-possession 1 + 투입첫날부터 1 + AI-cliche 4 = 13.
// IO: stdin JSON -> stdout JSON. Import: { scanKoreanProse } from "./cli.mjs".
import { appendFileSync } from "node:fs";
function llog(v){try{const p=process.env.LAZYAGENTIC_LINT_LOG;if(!p)return;appendFileSync(p,JSON.stringify({ts:new Date().toISOString(),count:v.length,rules:[...new Set(v.map(x=>x.rule))]})+"\n");}catch{}}

export const TOOL_NAME = "scan_korean_prose";

export const RULES = [
  { id: "park-da", pattern: /박다/, description: "박다 원형 금지 (코드를 박다)" },
  { id: "park-compound", pattern: /박아\s*넣/, description: "박다 변형 금지 (박아넣다)" },
  { id: "park-inflected", pattern: /박(아|았|어)/, description: "박다 굴절형 금지 (박아서/박았다)" },
  { id: "double-passive-ji", pattern: /되어지/, description: "이중피동 금지 (판단되어진다)" },
  { id: "double-passive-jyeo", pattern: /되어져/, description: "이중피동 금지 (작성되어져 있다)" },
  { id: "by-passive", pattern: /에\s*의해/, description: "~에의해 수동태 금지 (AI에 의해 생성)" },
  { id: "pillar-suffix", pattern: /(운영|전략|추진|핵심)\s*축/, description: "~축 구조은유 금지 (운영 축/전략 축)" },
  { id: "experience-possession", pattern: /경험을\s*(보유|가지고)/, description: "경험보유 번역투 금지 (경험을 보유/가지고 있다)" },
  { id: "day-one-filler", pattern: /(투입\s*)?첫날부터/, description: "투입첫날부터 사족 금지 (투입 첫날부터/첫날부터)" },
  { id: "cliche-very-important", pattern: /매우\s*중요/, description: "AI클리셰 금지 (매우 중요)" },
  { id: "cliche-core", pattern: /핵심적인/, description: "AI클리셰 금지 (핵심적인)" },
  { id: "cliche-fast-changing", pattern: /빠르게\s*변화하는/, description: "AI클리셰 금지 (빠르게 변화하는)" },
  { id: "cliche-noticeably", pattern: /눈에\s*띄게/, description: "AI클리셰 금지 (눈에 띄게)" },
];

export function scanKoreanProse(text) {
  const violations = [];
  const lines = String(text ?? "").split(/\r?\n/);
  lines.forEach((raw, idx) => {
    const lineNo = idx + 1;
    const excerpt = raw.trim().slice(0, 120);
    for (const r of RULES) {
      if (r.pattern.test(raw)) {
        violations.push({ rule: r.id, line: lineNo, excerpt });
      }
    }
  });
  llog(violations);
  return violations;
}

export const TOOL_DEF = {
  name: TOOL_NAME,
  description: "Scan Korean prose for 13 translation-ese / cliche rules",
  inputSchema: {
    type: "object",
    properties: { text: { type: "string", description: "Korean text to scan" } },
    required: ["text"],
  },
};

function extractText(input) {
  if (typeof input === "string") return input;
  if (input == null || typeof input !== "object") return "";
  if (typeof input.text === "string") return input.text;
  if (input.arguments && typeof input.arguments.text === "string") return input.arguments.text;
  if (input.params?.arguments?.text) return String(input.params.arguments.text);
  if (input.params?.text) return String(input.params.text);
  return "";
}

async function readStdin() {
  let d = "";
  for await (const c of process.stdin) d += c;
  return d.trim();
}

async function main() {
  const raw = await readStdin();
  let input = {};
  try {
    input = raw ? JSON.parse(raw) : {};
  } catch {
    console.log(JSON.stringify({ tool: TOOL_NAME, violations: [], error: "unparseable input" }));
    return;
  }
  const method = input.method || "";
  if (method === "initialize") {
    console.log(JSON.stringify({ protocolVersion: "2024-11-05", serverInfo: { name: "lint-rules", version: "1.0.0" }, capabilities: { tools: {} }, id: input.id ?? null }));
    return;
  }
  if (method === "tools/list") {
    console.log(JSON.stringify({ tools: [TOOL_DEF], id: input.id ?? null }));
    return;
  }
  if (method === "tools/call") {
    const name = input.params?.name || "";
    const text = extractText(input.params || {});
    if (name && name !== TOOL_NAME) {
      console.log(JSON.stringify({ error: `unknown tool: ${name}`, id: input.id ?? null }));
      return;
    }
    const violations = scanKoreanProse(text);
    console.log(JSON.stringify({ tool: TOOL_NAME, violations, id: input.id ?? null }));
    return;
  }
  const text = extractText(input);
  const violations = scanKoreanProse(text);
  console.log(JSON.stringify({ tool: TOOL_NAME, violations }));
}

const invoked = (process.argv[1] || "").endsWith("cli.mjs");
if (invoked) {
  main();
}
