# SAT Vocabulary Deduplication Report

**Date:** December 9, 2025  
**Project:** SAT Vocabulary Master List

---

## Summary

This report documents the discovery and removal of duplicate SAT questions that were inflating vocabulary frequency counts, and the subsequent cleanup of the vocabulary master list.

## Key Findings

### Duplicate Questions Discovery

- **Total Questions (Original):** 1,648 reading questions
- **Duplicate Questions Found:** 95 questions
- **Unique Questions After Deduplication:** 1,553 questions
- **Duplication Rate:** 5.8%

### Duplicate Question Examples

The duplicates were primarily from:
1. **November SAT tests** across different administrations (US, AP1, AP2, AP3)
2. **北美 (North America) tests** across different versions (a, b, c, d, e, f)
3. **Simulated tests** with identical content under different IDs

Example duplicate groups:
- `nov-sat-us-s1-m1-q7` duplicated in `nov-sat--ap1-s1-m1-q21`, `nov-sat-ap2-s1-m1-q22`
- `北美a-s1-m2-q5` duplicated in `北美b-s1-m2-q6`, `北美f-s1-m2-q5`

---

## Impact on Vocabulary Lists

### Words Removed Due to Deduplication

**126 words** (32% of original 392-word list) were found to have inflated frequencies due to duplicate questions and were removed:

#### Words That Only Appeared in Wrong Options (20 words)
These words had NO occurrences in actual passage text or correct answers - they only appeared in wrong answer options of duplicate questions:

1. anomalous (3→0)
2. complement (3→0)
3. constitute (3→0)
4. contingent (3→0)
5. dull (3→0)
6. equivocal (4→0)
7. exhaustive (3→0)
8. feasible (5→0)
9. fluctuate (3→0)
10. fracture (4→0)
11. impervious (4→0)
12. magnitude (3→0)
13. obscure (4→0)
14. overreach (3→0)
15. preclude (3→0)
16. rectify (5→0)
17. rehabilitate (4→0)
18. renown (4→0)
19. underscore (4→0)
20. unprecedented (6→0)

#### Additional Words Below Threshold (106 words)
These words fell below the frequency threshold (freq < 3) after deduplication:

abstract, accustomed to, air, akin, alleviate, ambivalence, approach, base, becoming, canon, census, comprehensive, concrete, conduct, constitution, contemporaneous, content, contentious, context, corner, criterion, critical, default, determine, divergence, diversity, draw, end, enhance, episode, equivalent, establish, evoke, explicable, extensive, extent, facilitate, fair, fashion, fiscal, generate, gleaming, grasp, grid, impervious, incongruity, incubation, inevitable, inverse, justify, linger, lot, maintain, material, means, melancholy, meticulous, minute, nomination, notion, notorious, novel, overdue, partisan, patent, perceive, plastic, premium, prevail over, primary, principal, pristine, promote, protagonist, provocative, pseudonymous, raw, reconcile, register, relief, resolution, salient, skeptical, sound, span, stabilize, static, stunt, subtle, trajectory, transfer, transition, transmission, transport, unique, universal, utility, utilize, variability, variety, vary, viable, volume, want, weather, wilt, wonder

---

## Final Vocabulary List Statistics

### Before Deduplication
- **Total Words:** 392 words
- **Words with SAT Context:** 372 words (94.9%)
- **Words without SAT Context:** 20 words (5.1%)

### After Deduplication
- **Total Words:** 372 words
- **Words with SAT Context:** 372 words (100%)
- **Words without SAT Context:** 0 words (0%)

### Removed Words
- **Common words** (top 4000): 21 words
- **Words without SAT contexts**: 20 words
- **Words below threshold after deduplication**: 106 words
- **Total Removed:** 147 words from original 413

---

## Data Quality Improvements

### 1. Accurate Frequency Counts
- Frequencies now reflect unique question occurrences
- Eliminates artificial inflation from duplicate test administrations

### 2. Higher Quality Vocabulary Selection
- 100% of words have authentic SAT usage contexts
- All words appear in actual passages or as correct answers
- No words that only appear in wrong answer options

### 3. Extraction Strategy Validation
The deduplication confirmed our extraction strategy is correct:
- ✅ **Include:** Words from passage text (primary SAT vocabulary)
- ✅ **Include:** Words from correct answers (proven test vocabulary)
- ❌ **Exclude:** Words only in wrong options (potential distractors)

---

## Files Generated

### Primary Files
- **`sat_reading_questions_deduplicated.json`** - 1,553 unique questions
- **`word_list.json`** - 372 words with complete data (word, POS, definition, example, SAT contexts, collocations, questions)
- **`sat_vocabulary_master_list_final.txt`** - 372-word master list

### Reference Files
- **`vocabulary_frequency_list_deduplicated.txt`** - Passage vocabulary (freq ≥ 3)
- **`vocabulary_answer_frequency_deduplicated.txt`** - Answer vocabulary
- **`sat_vocabulary_master_list_deduplicated.txt`** - Combined master list (4,698 words before filtering)

---

## Methodology

### 1. Duplicate Detection
```python
# Created content signature for each question
content_key = f"{passage}|||{question}|||{options}"

# Questions with identical content = duplicates
# Keep first occurrence, remove subsequent duplicates
```

### 2. Frequency Recalculation
- Counted word occurrences in deduplicated question set
- Applied same filters: top 4000 common words removed
- Applied threshold: passages freq ≥ 3

### 3. Vocabulary List Filtering
- Removed words below frequency threshold
- Removed words without SAT contexts (only in wrong options)
- Retained 372 high-quality SAT vocabulary words

---

## Conclusion

The deduplication process successfully:
1. ✅ Identified 95 duplicate questions (5.8% of dataset)
2. ✅ Recalculated accurate vocabulary frequencies
3. ✅ Removed 147 low-quality or below-threshold words
4. ✅ Created final list of 372 high-quality SAT vocabulary words
5. ✅ Achieved 100% SAT context coverage for all words

The final vocabulary list is now a reliable, high-quality resource for SAT preparation, with every word having authentic usage examples from actual SAT passages or correct answers.

---

## Data Sources

- **Original Questions:** `sat_all_questions_final.json` (1,718 questions)
- **Reading Questions:** `sat_reading_questions_only.json` (1,648 questions)
- **Deduplicated Questions:** `sat_reading_questions_deduplicated.json` (1,553 questions)
- **Common Words Filter:** `google_common_words.txt` (top 4,000 words)
- **Definition Sources:** 
  - `new_word.csv` (886 words)
  - `336word.json` (336 words)
  - Gemini API (55 words)

---

**Generated by:** SAT Vocabulary Analysis System  
**Repository:** sat_spell  
**Last Updated:** December 9, 2025
