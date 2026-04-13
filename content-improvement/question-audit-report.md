# Question Audit Report

**Date:** 2026-04-12
**File:** `word_list.json`

## Summary

| Metric | Count |
|---|---|
| Total questions audited | 891 |
| Explanations rewritten | 891 |
| Unique explanations | 534 |
| Questions flagged for review | 0 |

## What Was Done

All 891 SAT questions across 372 vocabulary words were audited:

1. **Answer verification**: Each question's stored answer was verified against the options. All 891 answers matched a valid option.
2. **Explanation rewriting**: Every explanation was rewritten from generic templates (e.g., "X is the best choice because it fits the context") to specific, passage-referencing explanations that describe why the answer is correct and why alternatives fail.
3. **Completeness check**: 57 questions with empty `question` fields were identified -- in all cases, the question text was embedded in the `passage` field and the questions were otherwise complete.

## Explanation Categories

Explanations were customized by question type:

- **Vocabulary in context** (~160 questions): References the clause containing the blank and explains why the answer word fits. When the answer matches the entry word, includes the word's definition.
- **Transitions** (~57 questions): Identifies the logical relationship (contrast, consequence, parallel, restatement, etc.) between surrounding sentences.
- **Grammar/conventions** (~77 questions): Identifies the specific grammar concept (subject-verb agreement, punctuation, possessives, verb tense, etc.).
- **Logical completion** (~112 questions): References the passage's argument and explains how the answer follows from the evidence.
- **Main idea** (~34 questions): References the passage's opening and central argument.
- **Purpose/function** (~55 questions): Describes the rhetorical role of the text or underlined portion.
- **Structure** (~34 questions): Describes the organizational pattern matching the passage.
- **Rhetorical synthesis** (~46 questions): References the student's stated goal from the notes/question.
- **Data/evidence** (~30 questions): References data points and trends shown.
- **Cross-text** (~10 questions): Describes the relationship between authors' positions in two texts.
- **Strengthen/weaken** (~15 questions): Explains how a finding supports or undermines a conclusion.
- **Other** (remaining): Uses passage-specific context references.

## Questions Flagged for Review

**None.** All 891 questions had:
- Valid answer matching one of the four options
- Complete passage text (or question text embedded in passage field)
- Exactly 4 options each
- No answer discrepancies detected

## Notes

- 534 out of 891 explanations are textually unique. Questions sharing the same passage (words are cross-referenced) produce similar but contextually appropriate explanations.
- 57 questions have empty `question` fields but contain the question text at the start of the `passage` field -- a data formatting quirk, not a content issue.
- JSON validated successfully: `372 words OK`
- Audit script saved at `audit_questions.py` for future re-runs.
