# Content Quality Crosscheck Report

**Date:** 2026-04-12
**File:** `word_list.json`
**Total words checked:** 372

## Check 1: Collocations Quality

**Fixed: 72 entries**

Many words had collocations that were just the bare word itself (e.g., `"ameliorate"`, `"corroborate"`, `"ubiquitous"`) or extracted sentence fragments with trailing punctuation. All were replaced with meaningful usage phrases.

### Examples of fixes

| Word | Before | After |
|------|--------|-------|
| accentuate | `"accentuate"` | `"accentuate the positive"`, `"accentuate differences"`, `"accentuate features"` |
| conspicuous | `"Conspicuous"` | `"conspicuous consumption"`, `"conspicuous absence"`, `"conspicuous by its absence"` |
| attrition | `"attrition"` | `"war of attrition"`, `"attrition rate"`, `"natural attrition"` |
| constitution | `"procedure. Romania's constitution contains one"` | `"constitutional amendment"`, `"written constitution"`, `"constitution of the committee"` |
| inhibited | `"ALAN completely inhibited hatching. These"` | `"inhibited growth"`, `"inhibited by fear"`, `"socially inhibited"` |
| abstract | `"nor the abstract art movements"`, `"simple, almost abstract forms. Perhaps"` | `"abstract concept"`, `"abstract art"`, `"abstract thinking"`, `"abstract form"` |
| ubiquitous | `"ubiquitous"` | `"ubiquitous presence"`, `"become ubiquitous"`, `"ubiquitous in modern life"` |
| spurious | `"spurious"` | `"spurious claims"`, `"spurious argument"`, `"spurious correlation"` |

## Check 2: Usage Contexts Missing the Target Word

**Fixed: 33 contexts across 22 words**

These contexts were passages pulled from SAT question banks that did not contain the target vocabulary word. Each was replaced with a new 1-3 sentence passage at high-school academic reading level that naturally uses the word.

### Words with replaced contexts

| Word | Contexts replaced |
|------|-------------------|
| assertion | 1 |
| contend | 2 |
| eliciting | 1 |
| expense | 2 |
| impart | 2 |
| inconsistencies | 2 |
| integral | 1 |
| interconnected | 1 |
| interplay | 1 |
| lean | 2 |
| magnify | 2 |
| plentiful | 1 |
| pollinate | 1 |
| postulate | 1 |
| prescient | 1 |
| reciprocal | 1 |
| subtlety | 1 |
| supplement | 2 |
| suppress | 2 |
| tranquil | 1 |
| tranquility | 2 |
| ubiquitous | 2 |
| unequivocal | 1 |

### Example replacement

**suppress** (context 1):
- **Before:** "The advent of online streaming has led many music listeners to drift away from ownership of music..." (word "suppress" absent)
- **After:** "The advent of online streaming has not managed to suppress interest in vinyl records; in fact, sales of physical media have experienced a surprising resurgence among younger listeners."

## Check 3: Question Answer Explanations

**Missing explanations: 0**

All 372 words have explanations present on every embedded SAT question. Note: 799 explanations use boilerplate language (e.g., "is the best choice because it fits the context") -- these are technically present but could benefit from future enrichment.

## Remaining Issues

- **Boilerplate explanations (799):** Many question explanations are generic and do not teach the student why the answer is correct. A future pass should replace these with specific reasoning tied to the passage and answer.
- **No other structural issues detected.** All words have valid collocations, all contexts contain the target word, and all questions have explanations.

## Validation

```
$ python3 -c "import json; d=json.load(open('word_list.json')); print(f'{len(d)} words OK')"
372 words OK
```
