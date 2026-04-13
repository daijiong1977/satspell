# Task: Rewrite All 891 Question Explanations

## Goal
Replace all template-based explanations in `word_list.json` with specific, passage-referenced reasoning — the quality level demonstrated by the Copilot cross-check sample.

## Current State
- 891 questions have explanations but they're template-generated garbage like:
  - "The data supports that [answer pasted]..."
  - "Options A, B, C either overstate the scope..."
- Need: specific reasoning referencing passage content, explaining WHY

## Quality Standard (from Copilot sample)

**GOOD:**
> "Enhancement of pollination ranked 1 for project leaders vs 5,8,13,17 for others — clearly their highest-ranked benefit. Options A,B compare only one service against one group, D reverses the ranking."

**BAD:**
> "The data supports that [answer]. Options A, B, D either misread specific data points, reverse trends, or draw unsupported conclusions."

## Process

### Step 1: Extract all questions to batches
```python
# Extract questions in batches of 20 with full passage/options/answer
# Save to content-improvement/batches/batch-01.txt through batch-45.txt
```

### Step 2: For each batch, use Copilot CLI
```bash
~/.local/share/gh/copilot --effort high --add-dir . -p "Read [batch file]. For each question:
1. Answer it yourself with reasoning
2. Compare with stored answer  
3. Write 2-3 sentence SPECIFIC explanation referencing passage
4. If DISAGREE with stored answer, flag it
Format: Q#: [Letter] - [explanation]"
```

### Step 3: Parse Copilot output and update word_list.json
- Extract explanations from Copilot responses
- Update the `explanation` field in each question
- Flag any DISAGREE items for manual review

### Step 4: Validate
- Count questions with specific explanations (not template)
- Verify no "The correct answer is X" remains
- Verify JSON is valid
- Cross-check 10 random samples

## Files
- Source: `word_list.json` (891 embedded questions)
- Script: `content-improvement/rewrite-explanations.py` (to create)
- Batches: `content-improvement/batches/` (to create)
- Output: updated `word_list.json`

## Estimated Time
- ~45 batches × 2-3 min per Copilot call = ~2 hours
- Plus parsing/validation = ~30 min
- Total: ~2.5 hours

## Notes
- Copilot confirmed all 10 sample answers correct (0 disagreements)
- Use `--effort high` for quality reasoning
- If Copilot disagrees with an answer, flag for manual review — don't auto-change
- The `audit_questions.py` script exists but generates templates — don't use it
