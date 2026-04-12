#!/bin/bash
# copilot-review.sh — Automated cross-check review using GitHub Copilot CLI
#
# Usage:
#   ./scripts/copilot-review.sh                                    # Default: GPT review
#   ./scripts/copilot-review.sh --model gemini-2.5-pro             # Use Gemini
#   ./scripts/copilot-review.sh --model gpt-5.4-xhigh              # Use GPT-5.4
#   ./scripts/copilot-review.sh --model o3                         # Use o3
#   ./scripts/copilot-review.sh --type design                      # Review type
#   ./scripts/copilot-review.sh --all-models                       # Run all models in parallel
#   ./scripts/copilot-review.sh docs/ui-design-spec.md             # Specific file
#
# Review types:
#   design        (default) Consistency, edge cases, scope, implementation readiness
#   learning-model          Spaced repetition science and math validation
#   marketing               Audience fit, SAT value, shareability, differentiation
#   implementation          Code vs design spec comparison
#   cross-check             Full cross-check: run design + learning-model + marketing

set -euo pipefail

COPILOT="$HOME/.local/share/gh/copilot"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REVIEW_DIR="$PROJECT_DIR/docs/reviews"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Defaults
MODEL=""
EFFORT="high"
REVIEW_TYPE="design"
TARGET_FILE=""
ALL_MODELS=false

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --model) MODEL="$2"; shift 2;;
    --effort) EFFORT="$2"; shift 2;;
    --type) REVIEW_TYPE="$2"; shift 2;;
    --all-models) ALL_MODELS=true; shift;;
    --help|-h)
      head -16 "$0" | tail -15
      exit 0;;
    *)
      TARGET_FILE="$1"; shift;;
  esac
done

# Check copilot is available
if [ ! -x "$COPILOT" ]; then
  echo "Error: Copilot CLI not found at $COPILOT"
  exit 1
fi

mkdir -p "$REVIEW_DIR"

# If --all-models, run 3 models in parallel
if [ "$ALL_MODELS" = true ]; then
  echo "Running cross-check with multiple models in parallel..."
  echo ""

  PIDS=()

  for m in "gpt-5.4" "gpt-5.2"; do
    SAFE_NAME=$(echo "$m" | tr '.' '-')
    echo "  Starting: $m ($REVIEW_TYPE)..."
    "$0" --model "$m" --effort "$EFFORT" --type "$REVIEW_TYPE" ${TARGET_FILE:+"$TARGET_FILE"} \
      > "$REVIEW_DIR/${REVIEW_TYPE}-${SAFE_NAME}-${TIMESTAMP}.log" 2>&1 &
    PIDS+=($!)
  done

  echo ""
  echo "Waiting for all reviews to complete..."
  FAILED=0
  for pid in "${PIDS[@]}"; do
    if ! wait "$pid"; then
      FAILED=$((FAILED + 1))
    fi
  done

  echo ""
  echo "All reviews complete. Results in: $REVIEW_DIR/"
  ls -lt "$REVIEW_DIR"/*"$TIMESTAMP"* 2>/dev/null
  [ "$FAILED" -gt 0 ] && echo "Warning: $FAILED review(s) failed."
  exit 0
fi

# If --type cross-check, run all 3 review types sequentially
if [ "$REVIEW_TYPE" = "cross-check" ]; then
  echo "Running full cross-check (design + learning-model + marketing)..."
  echo ""
  for t in design learning-model marketing; do
    echo "--- Running $t review ---"
    "$0" --type "$t" --effort "$EFFORT" ${MODEL:+--model "$MODEL"} ${TARGET_FILE:+"$TARGET_FILE"}
    echo ""
  done
  echo "Cross-check complete."
  exit 0
fi

# Build model flag
MODEL_FLAG=""
if [ -n "$MODEL" ]; then
  MODEL_FLAG="--model $MODEL"
  MODEL_LABEL="$MODEL"
else
  MODEL_LABEL="default"
fi

# Build the review prompt based on type
case $REVIEW_TYPE in
  design)
    if [ -n "$TARGET_FILE" ]; then
      FILES_INSTRUCTION="Read the file $TARGET_FILE."
    else
      FILES_INSTRUCTION="Read docs/ui-design-spec.md and docs/learning-model-design.md."
    fi
    PROMPT="$FILES_INSTRUCTION

You are reviewing a design specification for an iOS SAT vocabulary learning app. The app uses SwiftUI, targets high school students (15-18), and has a Duolingo-inspired gamified UI with a spaced repetition learning model.

Review for:
1. Internal consistency — do all sections agree with each other?
2. Missing edge cases — any user scenarios not covered?
3. Scope clarity — is V1 vs V2 boundary clear?
4. Implementation readiness — could a developer build from this spec without guessing?
5. Product concerns — anything that would hurt the user experience?

Format your review as:
### What Looks Good
(2-3 bullet points)

### Issues Found
(numbered list, each with: what the issue is, why it matters, suggested fix)

### Suggestions
(optional improvements that aren't bugs)

Write your review directly into the file by appending a new section at the end. Use the heading '## Cross-Check Review — $MODEL_LABEL ($TIMESTAMP)'. Keep it concise — under 500 words."
    ;;

  learning-model)
    PROMPT="Read docs/learning-model-design.md carefully.

You are a learning science expert reviewing a spaced repetition model for a 20-day SAT vocabulary app (372 words, 2 sessions/day, Leitner boxes).

Review for:
1. Scientific accuracy — are the cited research findings applied correctly?
2. Math validation — do the word counts, timing, and box intervals work?
3. Same-day acceleration — is the 4-touch → Box 2 promotion rule sound?
4. Queue overflow — will the review queue stay manageable?
5. Edge cases — missed days, re-entry, back-pressure thresholds

Append your review to the file under '## Learning Model Cross-Check — $MODEL_LABEL ($TIMESTAMP)'. Be specific about any math or science issues. Under 500 words."
    ;;

  marketing)
    PROMPT="Read docs/ui-design-spec.md (focus on sections 1.3 Voice & Microcopy, 3 Practice Tab, 8 Parent Report, and 13 What Is NOT in V1).

You are a product/marketing reviewer for an iOS SAT vocab app targeting high school students (15-18). The app is free, distributed via TestFlight initially.

Review for:
1. Audience fit — does the tone/design appeal to 15-18 year olds?
2. Value proposition — is the SAT benefit clear enough?
3. Shareability — will students want to share this with friends?
4. Parent appeal — does the report feature work for parents?
5. Differentiation — what makes this stand out vs Quizlet, Anki, Magoosh?

Append your review to the file under '## Marketing Cross-Check — $MODEL_LABEL ($TIMESTAMP)'. Include 2-3 specific suggestions. Under 400 words."
    ;;

  implementation)
    if [ -n "$TARGET_FILE" ]; then
      FILES_INSTRUCTION="Read the file $TARGET_FILE and also read docs/ui-design-spec.md for context."
    else
      FILES_INSTRUCTION="Read the Swift source files in ios/SATVocabApp/Sources/ and compare against docs/ui-design-spec.md."
    fi
    PROMPT="$FILES_INSTRUCTION

You are reviewing implementation code against the design specification. Check:
1. Does the code match the spec's screen inventory?
2. Are button actions implemented as specified?
3. Are edge cases (pause, resume, recovery) handled?
4. Does the data model match what the spec requires?

Write your review to docs/reviews/implementation-review-$MODEL_LABEL-$TIMESTAMP.md. Be specific — reference file names and line numbers."
    ;;

  *)
    echo "Unknown review type: $REVIEW_TYPE"
    echo "Valid types: design, learning-model, marketing, implementation, cross-check"
    exit 1;;
esac

SAFE_MODEL=$(echo "$MODEL_LABEL" | tr '.' '-')
OUTPUT_FILE="$REVIEW_DIR/${REVIEW_TYPE}-${SAFE_MODEL}-${TIMESTAMP}.md"

echo "Running Copilot cross-check review..."
echo "  Model:  $MODEL_LABEL"
echo "  Type:   $REVIEW_TYPE"
echo "  Effort: $EFFORT"
echo "  Target: ${TARGET_FILE:-all design docs}"
echo "  Output: $OUTPUT_FILE"
echo ""

cd "$PROJECT_DIR"

# Use --continue to reuse previous session context for same project
CONTINUE_FLAG=""
if [ -f "$REVIEW_DIR/.last-session-id" ]; then
  LAST_SESSION=$(cat "$REVIEW_DIR/.last-session-id" 2>/dev/null)
  if [ -n "$LAST_SESSION" ]; then
    CONTINUE_FLAG="--resume=$LAST_SESSION"
    echo "  Continuing session: $LAST_SESSION"
  fi
fi

"$COPILOT" -p "$PROMPT" \
  --allow-all-tools \
  --effort "$EFFORT" \
  $MODEL_FLAG \
  $CONTINUE_FLAG \
  --share "$OUTPUT_FILE" \
  --output-format text

# Save session ID for next run
if [ -f "$OUTPUT_FILE" ]; then
  grep -o 'Session ID.*[a-f0-9-]\{36\}' "$OUTPUT_FILE" 2>/dev/null | head -1 | grep -o '[a-f0-9-]\{36\}' > "$REVIEW_DIR/.last-session-id" 2>/dev/null
fi

echo ""
echo "Review saved to: $OUTPUT_FILE"
