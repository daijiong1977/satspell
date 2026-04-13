# WordScholar Content Improvement Project

## Audit Summary (April 13, 2026)

### Source Files
- `word_list.json` — 372 words with definitions, examples, contexts, collocations, embedded questions
- `sat_reading_questions_deduplicated.json` — 1,553 standalone questions

### Issues Found

| Category | Count | Severity |
|----------|-------|----------|
| Blanks in questions (___) | 458 embedded + 855 standalone = **1,313** | HIGH — blanks show as literal text in the app |
| Word missing from usage context | **140** | MEDIUM — context doesn't demonstrate the word |
| Definition/example mismatch | **7** | MEDIUM — definition doesn't match how word is used in example |
| Questions without answers | **12** | HIGH — unanswerable questions |
| Questions without passage | **1** | LOW |
| Missing fields | **0** | — |

---

## Issue Details

### 1. Blanks in Questions (1,313 total)

**Problem:** Many questions contain literal `______` blank placeholders in passages and questions. These were designed as fill-in-the-blank but display as ugly underscores in the app's multiple-choice format.

**Examples:**
```
"It was the kind of challenge that would set any art curator's mind into _______ that elusive thread"
"Which choice completes the text so that it conforms to the conventions\nof Standard English?"
```

**Fix needed:**
- For passages: Replace `______` with the correct word (the answer) to make a complete readable passage
- For questions asking "which completes the text": Rewrite as "which word best fits" or provide the complete passage
- Some blanks are intentional cloze-style — these need to be converted to proper MCQ format

### 2. Word Missing from Usage Context (140 cases)

**Problem:** The `sat_context` field contains passages where the target word doesn't actually appear. The context was likely associated by topic, not by word usage.

**Examples:**
- `accentuate` → context about Emily Dickinson poem (word "accentuate" not in text)
- `affinity` → context about children's book author (word "affinity" not in text)
- `alignment` → context about grain/tea/peppercorns as money (word "alignment" not in text)

**Fix needed:**
- Option A: Replace context with one that actually uses the word
- Option B: Add a sentence explaining how the word relates to the passage
- Option C: Generate new contexts using AI that naturally include the word

### 3. Definition/Example Mismatch (7 cases)

**Problem:** The definition describes one meaning but the example uses a different meaning.

**Cases:**
| Word | Definition Says | Example Uses |
|------|----------------|-------------|
| abrupt | "unfriendly and rude" | "abrupt transformation" (sudden) |
| criterion | correct but singular | example uses "criteria" (plural) |
| pollinate | correct | example is a fragment |
| repository | correct | example is a fragment |
| simulated | correct | example is a fragment |
| subtlety | correct | example is a fragment |
| sweep | "move quickly" | "craze swept the country" (spread) |

**Fix needed:**
- `abrupt`: Add second definition "sudden and unexpected" or update example
- `sweep`: Add second definition "to spread quickly across an area"
- Fragment examples: Expand into complete sentences

### 4. Questions Without Answers (12)

**Problem:** 12 questions have empty answer fields — they can never be answered correctly.

**Fix needed:** Either provide correct answers or remove these questions.

---

## Improvement Plan

### Phase 1: Critical Fixes (automated)
1. **Remove/fill blanks** — Replace `______` in passages with the correct word
2. **Remove unanswerable questions** — Delete the 12 with no answer
3. **Fix fragment examples** — Expand the 5 fragment examples into full sentences

### Phase 2: Quality Improvements (AI-assisted)
4. **Fix definition/example mismatches** — Update definitions or examples for 7 words
5. **Fix usage contexts** — Replace 140 contexts where word is missing
6. **Add explanations to questions** — Each question needs a "why this is correct" explanation
7. **Verify question answer correctness** — Cross-check all answers

### Phase 3: Content Enrichment
8. **Generate better example sentences** — More natural, memorable examples
9. **Add word etymology** — Origin stories help retention
10. **Add word families** — Related words (abrupt → abruptly, abruptness)
11. **Add difficulty rating** — Easy/medium/hard per word

---

## File Structure

```
content-improvement/
├── README.md                    # This file
├── audit-report.json            # Detailed audit results
├── scripts/
│   ├── audit-content.py         # Content auditing script
│   ├── fix-blanks.py            # Replace blanks with correct words
│   ├── fix-contexts.py          # Fix missing-word contexts
│   ├── fix-definitions.py       # Fix definition/example mismatches
│   └── validate-questions.py    # Validate all questions have answers
├── fixes/
│   ├── blank-fixes.json         # Proposed blank replacements
│   ├── context-fixes.json       # Proposed context replacements
│   └── definition-fixes.json    # Proposed definition updates
└── output/
    ├── word_list_improved.json  # Improved word list
    └── questions_improved.json  # Improved questions
```

## How to Run

```bash
# Audit current content
python3 content-improvement/scripts/audit-content.py

# Apply fixes (after review)
python3 content-improvement/scripts/fix-blanks.py
python3 content-improvement/scripts/fix-contexts.py

# Validate output
python3 content-improvement/scripts/validate-questions.py
```

---

## Skill Requirements

A content improvement skill should:
1. Read word_list.json and questions JSON
2. Identify issues (blanks, missing words, mismatches)
3. Propose fixes with AI assistance (Gemini/GPT for rewriting)
4. Generate a diff/preview of changes
5. Apply fixes after human review
6. Validate the output (no broken references, all words present)

---

*Created: April 13, 2026*
*Project: WordScholar Content Improvement*
