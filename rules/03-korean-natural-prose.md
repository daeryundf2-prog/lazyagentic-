# 03. Korean Natural Prose and Syntax Policy (TOP-PRIORITY, MANDATORY)

> **Priority**: Critical  
> **Trigger**: Mandatory at session start, and whenever authoring Korean prose, explanations, conversational answers, proposals, documentation, commits, or status logs.  

## Top-Level Principle

**Construct natural, idiomatic Korean prose grounded in Korean grammatical realities. Omit redundant overt subjects and obvious objects based on discourse context, eliminate translation-ese, eradicate AI signature cliches under a strict removal-only mandate, balance sentence rhythm and ending variety, and preserve standard technical terminology and 100% meaning fidelity.**

---

## 1. Grammatical Disparity & Context-Driven Syntax

### 1.1 Context-Driven Subject Omission (Zero-Anaphora)
- **Discourse Omission**: Korean is a pro-drop language where the subject is naturally omitted when recoverable from context (`zero-anaphora`).
- **Rule**: Strictly prohibit mechanical repetition of overt subjects (`우리는`, `시스템은`, `사용자는`, `이것은`, `그것은`) across consecutive sentences. Let predicates drive narrative flow.
- *Incorrect (AI-tell)*: "우리는 새로운 API를 설계했습니다. 우리는 이어서 통합 테스트를 실행했습니다. 그것은 완벽한 안정성을 보여줍니다."
- *Correct (Natural Korean)*: "새로운 API를 설계한 뒤 통합 테스트를 실행하여 안정성을 확인했습니다."

### 1.2 Pragmatic Object Handling
- Omit or absorb obvious direct objects into predicates based on context. Avoid repeating identical direct objects across linked clauses.
- *Incorrect*: "설정 파일을 열고, 설정 파일을 수정한 후, 설정 파일을 저장합니다."
- *Correct*: "설정 파일을 열어 수정한 뒤 저장합니다."

---

## 2. Deconstruction of Translation-ese & Structural Distortions

### 2.1 Passive Voice Purification
- **Ban double passives**: Eliminate `~되어지다`, `~지게 되다`, `~되어져 있다`. Use active verbs or single passives (`판단되어진다` → `판단된다`/`판단한다`, `작성되어졌다` → `작성했다`/`작성되었다`).
- **Convert by-passives**: Replace passive by-phrases (`~에 의해`) by restoring the actor (`AI에 의해 생성된 코드` → `AI가 생성한 코드`, `외부 요인에 의해 발생한 오류` → `외부 요인으로 발생한 오류`).

### 2.2 Abstract Subjects & All-Purpose Verbs
- Prohibit literal English formulas (`The X shows / provides / brings Y`).
- Reframe with causal clauses (`~로 인해`, `~덕분에`) or reporting clauses (`~에 따르면`).

### 2.3 English Third-Person Pronoun Elimination
- Prohibit literal translation of pronouns (`he`, `she`, `it`, `they` → `그`, `그녀`, `그것`, `그들`).
- In technical prose, omit pronouns (zero pronoun) or use specific role nouns/terms.

### 2.4 Translation-ese Particle Stacking
- Replace `~에 대하여`/`~에 대해서` with `~를` or `~는`.
- Distribute `~를 통해`/`~를 통하여` across instrumental `-로`, causal `-해서`, or `-함으로써`.
- Replace `~에 있어(서)` with `-에서` or `-을 볼 때`.
- Dismantle double particles (`-에서의`, `-에로의`, `-으로의`, `-에의`, `-으로부터의`) into natural clauses.

### 2.5 Taxonomic Structural Metaphor & "Pillars" Translation-ese Elimination
- **Ban on structural metaphor suffixes (`~ 축`, `~ 기둥`)**: Prohibit appending awkward structural metaphor nouns when enumerating categories, operations, or principles derived from English `pillars` (e.g., `4대 핵심 운영 축`, `3대 전략 축`).
- *Incorrect (AI-tell)*: `4대 핵심 운영 축`, `3대 전략 축`, `주요 추진 축`
- *Correct (Natural Korean)*: `4대 핵심 운영`, `3대 전략` (또는 `3대 전략 과제`), `주요 추진 방향`

### 2.6 Light Verb & Experience Possession Translation-ese
- Strictly ban literal translation-ese such as `~경험을 보유하고 있다/있습니다` or `~경험을 가지고 있다`. Experience is not a physical asset to possess.
- *Incorrect*: `비동기 백엔드 환경에서 최적화해 온 실전 경험을 보유하고 있습니다.`
- *Correct*: `비동기 백엔드 환경에서 논블로킹 I/O 성능을 최적화한 경험이 있습니다.`

### 2.7 Redundant "From Day One" Translation-ese Elimination
- 업무나 프로젝트는 시작과 동시에 진행되는 것이 당연한 전제입니다. 굳이 `투입 첫날부터`, `첫날부터`라고 수식하는 번역투 사족을 배제하고 `서비스 가용성을 안정적으로 유지하는`, `투입 초기 체계적인 인벤토리 파악을 통해`처럼 담백하고 명확하게 서술합니다.

### 2.8 Empty Savior Formulas Elimination
- `자립적으로 책임지는`, `단독으로 책임질`, `책임지고 통제하겠습니다`와 같이 알맹이 없는 시혜적 태도나 AI 특유의 피상적 다짐 어휘를 배제하고, 객관적이고 검증 가능한 실행 가치를 제시합니다.

---

## 3. AI Signature Cliches & Rhetorical Patterns

### 3.1 Removal-Only Mandate (역방향 삽입 금지)
- When generating or editing Korean text, **never inject ungrounded AI cliches, exaggerated idioms, or synthetic praise** (`기록적인 성과를 거두었다`, `~로 평가된다`, `주목받았다` 등). Edits must remove AI tells, never add them.

### 3.2 Banned Signature Phrases & Lexicon
- **Summary cliches**: Eliminate `결론적으로`, `요약하면`, `종합하면`, `정리하자면`, `시사하는 바가 크다`, `매우 중요하다`, `주목할 만하다`, `간과할 수 없다`, `지평을 연다`, `방점을 찍는다`.
- **Hype words**: Avoid empty hype (`혁신적인`, `획기적인`, `전례 없는`, `압도적`, `파격적`, `폭발적`). Replace with verifiable facts and metrics.
- **Connective ending commas**: Do not place a comma immediately after connective verb endings (`-고,`, `-며,`, `-지만,`, `-면서,`, `-아서,`).

### 3.3 Anti-Parroting & Solution-First Mandate
- 의뢰서나 사용자의 질문을 앵무새처럼 그대로 복창(Parroting)하지 않고, 곧바로 진단(Diagnosis), 구체적 해결책(Solution), 실행 계획(Action Plan)을 제시합니다.

---

## 4. Sentence Rhythm, Predicate Endings & Tone Consistency

### 4.1 Predicate Ending Variety
- Do not repeat the identical sentence ending (`~이다. ~이다. ~이다.` 또는 `~한다. ~한다. ~한다.`) 4 or more times consecutively. Vary with past tense, connective compound structures, and diverse predicate forms.

### 4.2 Speech Level Consistency
- Select a single consistent speech level per document or conversation:
  - **하십시오체** (합쇼체): 공식 보고서, 비즈니스 산출물, 정중한 사용자 대화
  - **해요체**: 일상적이고 친절한 설명
  - **해라체** (한다체): 기술 사양서, 내부 규칙 문서, 아키텍처 노트
- 문맥 도중 불필요하게 경어를 부자연스럽게 부풀리거나 격식을 넘나들지 않습니다.

---

## 5. Technical Terminology & Meaning Anchor Fidelity

### 5.1 Preservation of Standard Technical Terms & System Invariants
- IT, AI, 소프트웨어 엔지니어링 표준 기술 용어(`API`, `SDK`, `CLI`, `prompt`, `token`, `pipeline`, `framework` 등)와 시스템 아키텍처 불변식 개념은 영문 표기를 유지하거나 원어 병기합니다. 억지스러운 기계적 직역(prompt → 지시문, token → 표식 등)을 금지합니다.

### 5.2 Strict Meaning Anchor Invariance
- 100% preservation of core facts, numbers, dates, version strings, identifiers, quotes, logic, and citations. Never alter, omit, or dilute substantive content while refining prose naturalness.