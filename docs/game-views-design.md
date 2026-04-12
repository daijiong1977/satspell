# Game & Recall Views Design Specification

This document defines the complete UI, interaction, and scoring spec for the three scored activity views. It is a companion to `flashcard-design.md` (exposure-only) and overrides Sections 4.4, 4.5, and 4.6 in `ui-design-spec.md`.

All three views share a common session header and scoring model, but each has distinct UI and interaction patterns.

---

## 1. Shared Elements

### 1.1 Session Header (all scored views)

```
✕              STEP 2 OF 3 · 📊 SCORED              ❤️3
                Image Practice · 5/12
[████████████████░░░░░░░░░░░░░░░░░░]
```

| Element | Detail |
|---------|--------|
| ✕ button | Top left, 14px, gray. Tap → pause confirmation sheet |
| Step label | "STEP X OF Y · 📊 SCORED" — 7px uppercase, context color |
| Activity label | "Image Practice · 5/12" — 9px bold, primary text |
| Progress bar | 5px, rounded, color matches activity (green=game, purple=recall, orange=SAT) |
| Hearts ❤️ | Top right, shows remaining lives (optional, P1). Not in P0 — omit. |

### 1.2 Scoring Rules (all scored views)

- Each answer is logged immediately to `ReviewLog`
- Correct → `outcome: correct`, word's correct touch count incremented
- Wrong → `outcome: incorrect`
- Rushed answer (< 1 second for game/recall, < 3 seconds for SAT) → logged but does NOT count toward box promotion
- Scored results feed into: same-day Box 2 promotion, daily accuracy stats, XP (+10 per correct ⚙️)

### 1.3 Microcopy Rotation

| Context | Examples (rotate, never repeat in session) |
|---------|-------------------------------------------|
| Correct | "Nailed it." · "That one's yours now." · "Clean." · "Nice." |
| Wrong | "That word is fighting back." · "Not yet — you'll get it." · "Tricky one." |
| Streak (3+ correct) | "On a roll." · "Three in a row." |
| Last round | "Final round." · "Last one." |

Microcopy appears as a toast at top of screen, fades after 1.5s. Does not block interaction.

---

## 2. Image-to-Word Game (ClozeRoundView)

### 2.1 Purpose

Test active recall: student sees the mnemonic image + a cloze sentence and must choose the correct word from 4 options. This is the primary practice activity and a scored event for box promotion.

### 2.2 Layout

```
┌──────────────────────────────────┐
│ ✕   STEP 2 OF 3 · 📊 SCORED  ❤️ │
│      Image Practice · 5/12       │
│ [████████████░░░░░░░░░░░░░░]     │
├──────────────────────────────────┤
│                                  │
│  [REVIEW]                        │  ← Badge (review words only)
│                                  │
│       [mnemonic image]           │  ← 45-55% of card height
│                                  │
│  ──── CHOOSE THE BEST WORD ──── │  ← Caption on gradient
│                                  │
├──────────────────────────────────┤
│                                  │
│  The sunset was _______, gone    │  ← Cloze sentence
│  in moments.                     │
│                                  │
│  ┌──────────┐  ┌──────────┐     │
│  │ ephemeral│  │ perpetual│     │  ← 2x2 answer grid
│  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐     │
│  │  mundane │  │ abundant │     │
│  └──────────┘  └──────────┘     │
└──────────────────────────────────┘
```

### 2.3 Image Area

- Height: proportional, min 40%, max 55% of available space (below header)
- `object-fit: cover`, `object-position: center 20-30%`
- Rounded corners: 12px
- Bottom gradient overlay: `linear-gradient(transparent 60%, rgba(0,0,0,0.5))`
- Caption text on gradient: "CHOOSE THE BEST WORD" — 7px, white, bold, uppercase, letter-spacing 0.5px

**REVIEW badge:** Orange pill, top-left corner of image, 6px bold white text on `rgba(255,150,0,0.9)`. Shown only when this word comes from the spaced review queue (not a new word).

**Show Again priority badge:** Gold pill "FROM STEP 1" — shown when this word was flagged with Show Again in the flashcard step. Replaces REVIEW badge.

### 2.4 Cloze Sentence

- Below image, centered
- Background: #F7F7F7, rounded 8px, padding 6-8px
- Font: 10-12px (SE-Max), primary text color
- Blank: `________` with gold underline (2px, #FFC800), padding 0 8px

**Sentence source:** Same example sentence used on the flashcard front. Word replaced with blank.

### 2.5 Answer Grid (2×2)

- 4 word choices in a 2×2 grid, gap 5-8px
- Each choice: 3D card button (border 1.5px #E5E5E5, border-bottom 3px)
- Font: 10-13px (SE-Max), bold, primary text color, centered
- Min tap target: 44×44pt

**Word selection:**
- 1 correct word (the target)
- 3 distractors (see Section 14.8 in ui-design-spec.md for rules)
- All 4 positions shuffled randomly
- Never repeat exact same 4-word set for the same target within a session

### 2.6 Answer Feedback

**Correct:**
1. Tapped card turns green (border + background flash #58CC02)
2. Other 3 cards dim slightly
3. Microcopy toast appears at top ("Nailed it.")
4. XP +10 floats up from card briefly
5. Auto-advance after 1.5s ⚙️

**Wrong:**
1. Tapped card turns red (border + background flash #FF4B4B)
2. Correct card pulses green (highlight the right answer)
3. Microcopy toast ("That word is fighting back.")
4. Auto-advance after 2.5s ⚙️ (longer — let student see correct answer)
5. No retry — move on

**No second chance.** Wrong is wrong. The word will come back in future reviews.

### 2.7 Round Completion

After the last round (e.g., 12/12):
- If Show Again cards are queued: those appear next (same format)
- After all rounds + requeued: advance to Step Transition screen
- No separate "round complete" screen within the game

### 2.8 Data Requirements

| Field | Source | Used For |
|-------|--------|----------|
| word (target) | Session word list | Correct answer option |
| example sentence | word_list.json | Cloze sentence (word replaced with blank) |
| image_filename | words table | Image display |
| 3 distractors | Generated per distractor rules | Wrong answer options |
| is_review | ReviewQueue flag | REVIEW badge |
| is_show_again | Step 1 result | FROM STEP 1 badge |

### 2.9 iPhone Size Adaptation

| Property | Pro Max (430pt) | SE/Mini (375pt) |
|----------|----------------|-----------------|
| Image area height | 50-55% | 40-45% |
| Cloze font | 12px | 10px |
| Answer grid font | 13px | 10px |
| Answer grid gap | 8px | 5px |
| Caption font | 8px | 7px |

---

## 3. Quick Recall View

### 3.1 Purpose

Test spaced recognition: student sees a word they learned that morning and must pick the correct definition from 4 choices. Faster-paced than the image game. This is a scored Day 1 promotion event.

### 3.2 Layout

```
┌──────────────────────────────────┐
│ ✕   STEP 2 OF 4 · 📊 SCORED     │
│      Quick Recall · 4/11         │
│ [████████████░░░░░░░░░░░░░░]     │  ← Purple progress bar
├──────────────────────────────────┤
│                                  │
│         WHAT DOES THIS MEAN?     │  ← Label, 9px, gray
│                                  │
│           EPHEMERAL              │  ← Word, 24-28px, bold
│          from this morning       │  ← Source label, purple
│                                  │
│  ┌──────────────────────────┐    │
│  │ very important or        │    │  ← Definition choice 1
│  │ significant              │    │
│  └──────────────────────────┘    │
│  ┌──────────────────────────┐    │
│  │ lasting a very short     │    │  ← Definition choice 2
│  │ time                     │    │
│  └──────────────────────────┘    │
│  ┌──────────────────────────┐    │
│  │ extremely complicated    │    │  ← Definition choice 3
│  └──────────────────────────┘    │
│  ┌──────────────────────────┐    │
│  │ widely known and admired │    │  ← Definition choice 4
│  └──────────────────────────┘    │
└──────────────────────────────────┘
```

### 3.3 Word Display

- "WHAT DOES THIS MEAN?" — 9px, gray, uppercase, letter-spacing 0.5px, centered
- Word: 24px (Max) / 20px (SE), weight 800, primary text color, centered
- Source label: "from this morning" — 10px, purple (#CE82FF), centered
- No image shown — this tests pure recall without visual cue

### 3.4 Definition Choices (4 vertical cards)

- Full-width 3D card buttons, stacked vertically, gap 6-8px
- Font: 12px (Max) / 10px (SE), primary text color
- Cards can show multi-line definitions (word-wrap enabled)
- Min height: 44pt per card
- Padding: 10-12px

**Definition selection:**
- 1 correct definition (the word's actual definition)
- 3 distractors (see Section 14.8 in ui-design-spec.md)
- Shuffled randomly

### 3.5 Answer Feedback

**Same pattern as Image Game with one difference:**

- Correct: card turns green, microcopy, auto-advance 1s ⚙️ (faster — this is rapid-fire)
- Wrong: tapped card turns red, correct card highlighted green, auto-advance 2s ⚙️
- No retry

### 3.6 Timing & Pace

Quick Recall is designed to be **fast-paced**:
- Average time per word: ~3 seconds (vs ~5s for image game)
- Total step: ~35 seconds for 11 words
- If student hasn't answered after 10 seconds, no timeout — just wait (don't rush)

### 3.7 Progress Bar

- Purple fill (#CE82FF) instead of green — visually distinct from other steps
- Same 5px height and rounded style

### 3.8 Data Requirements

| Field | Source | Used For |
|-------|--------|----------|
| word (lemma) | Morning session's word list | Word display |
| definition (correct) | word_list.json | Correct choice |
| 3 distractor definitions | Generated per distractor rules | Wrong choices |

### 3.9 iPhone Size Adaptation

| Property | Pro Max | SE/Mini |
|----------|---------|---------|
| Word font | 24px | 20px |
| Definition card font | 12px | 10px |
| Card gap | 8px | 6px |
| Label font | 10px | 8px |

---

## 4. SAT Question View (SatMCQRoundView)

### 4.1 Purpose

Test contextual understanding: student reads a SAT-style passage excerpt, then answers a vocabulary-in-context question. This mirrors the actual SAT Reading & Writing section format.

### 4.2 Layout (Split Scroll)

```
┌──────────────────────────────────┐
│ ✕   STEP 3 OF 3 · 📊 SCORED     │
│      SAT Questions · 1/3         │
│ [████░░░░░░░░░░░░░░░░░░░░░░]     │  ← Orange progress bar
├──────────────────────────────────┤
│ ┌────────────────────────────┐   │
│ │ 📖 PASSAGE        scroll ↕│   │  ← Passage area (35-45%)
│ │                            │   │
│ │ The environmental movement │   │
│ │ has undergone a [profound  │   │  ← Target word highlighted
│ │ transformation] in recent  │   │
│ │ decades. What began as...  │   │
│ └────────────────────────────┘   │
│          ─── QUESTION ───        │  ← Divider
│                                  │
│ As used in the passage,          │
│ "profound transformation"        │
│ most nearly means:               │
│                                  │
│  (A) ○ a minor adjustment        │
│  (B) ● a fundamental change  ←   │  ← Selected (blue)
│  (C) ○ a temporary shift         │
│  (D) ○ a superficial alteration  │
│                                  │
│          [ CHECK ]               │  ← Green when selected
└──────────────────────────────────┘
```

### 4.3 Passage Area (Top)

- Background: warm yellow (#FFF8E1)
- Border: 2px solid #FFE082, rounded 12px
- Height: proportional, min 35%, max 45%
- **Independently scrollable** — student can scroll the passage without affecting the question area
- Header: "📖 PASSAGE" left, "scroll ↕" right, both 7px

**Target word/phrase highlighting:**
- Highlighted with yellow underline gradient: `linear-gradient(180deg, transparent 55%, #FFE082 55%)`
- Bold weight
- This is the word being tested

**Passage source:** `sat_context` field from word_list.json. Placeholders (______) filled with the target word via `TextFill`.

### 4.4 Divider

- Horizontal line with centered label "QUESTION"
- Line: 1px #E5E5E5
- Label: 7px, gray, uppercase

### 4.5 Question Area (Bottom)

- Fixed (not scrollable) — stays visible while passage scrolls
- Question text: 11px (Max) / 9px (SE), weight 600, primary text color
- Typically: "As used in the passage, '[word/phrase]' most nearly means:"

### 4.6 Answer Options (A/B/C/D)

- Full-width rows, stacked vertically, gap 5-6px
- Each row: 3D card style, padding 8-10px
- Left: letter circle (18px diameter, 2px border #E5E5E5 or filled blue when selected)
  - Unselected: gray border, gray letter
  - Selected: blue fill (#1CB0F6), white letter
- Right: answer text, 10px (Max) / 9px (SE)
- Min tap target: full row width × 44pt height

**Selection behavior:**
- Tap to select (toggle)
- Only one selected at a time
- Can change selection before CHECK
- CHECK button: gray (#E5E5E5) when nothing selected, green (#58CC02) when selected

### 4.7 Answer Feedback (After CHECK)

A bottom sheet slides up (50% of screen) showing:

```
┌──────────────────────────────────┐
│  ✓ Correct!  /  ✗ Not quite.    │  ← Verdict (green or red)
│                                  │
│  WORD: profound transformation   │
│  MEANING: a fundamental change   │
│                                  │
│  WHY: The passage describes a    │
│  complete shift from grassroots  │
│  to global enterprise, which     │
│  indicates a fundamental change. │
│                                  │
│         [ NEXT → ]              │  ← Green 3D button
└──────────────────────────────────┘
```

**Correct feedback:**
- Header: "✓ Correct!" in green, with microcopy ("Clean.")
- Shows: word, meaning, brief explanation
- Background: light green tint
- XP +10

**Wrong feedback:**
- Header: "✗ Not quite." in red, with microcopy ("Brutal SAT word, but you'll get it.")
- Shows: word, correct meaning, explanation of why the correct answer is right
- The correct option is highlighted green in the question area behind the sheet
- Background: light red tint

**NEXT button:** Advances to next question. Dismisses the feedback sheet.

### 4.8 Passage Scroll + Question Interaction

**Gesture handling:**
- Passage area: vertical scroll only (finger on passage scrolls passage)
- Question area: tap only (no scroll — answers are visible)
- No horizontal swipe (unlike flashcards — can't swipe between SAT questions)
- Must answer via CHECK button (no skip)

### 4.9 Progress Bar

- Orange fill (#FF9600) — visually distinct from game (green) and recall (purple)
- Same 5px height and rounded style

### 4.10 Data Requirements

| Field | Source | Used For |
|-------|--------|----------|
| sat_context (passage) | word_list.json, `sat_questions` array | Passage text |
| question_text | sat_reading_questions_deduplicated.json | Question |
| choices (A/B/C/D) | sat_reading_questions_deduplicated.json | Answer options |
| correct_answer | sat_reading_questions_deduplicated.json | Scoring |
| explanation | sat_reading_questions_deduplicated.json | Feedback |
| target_word | word_list.json | Highlight in passage |

### 4.11 iPhone Size Adaptation

| Property | Pro Max | SE/Mini |
|----------|---------|---------|
| Passage height | 40-45% | 35-38% |
| Passage font | 11px | 9px |
| Question font | 11px | 9px |
| Answer font | 10px | 9px |
| Letter circle | 18px | 16px |
| Feedback sheet height | 50% | 55% |

### 4.12 Edge Cases

- **Very long passage:** Scrollable, max 300 words shown. If passage exceeds, truncate with "..." and show full on scroll.
- **Very short passage:** Passage area shrinks, question area gets more space.
- **Student doesn't answer:** No timer, no auto-skip. Wait until CHECK is pressed.
- **Last question:** After NEXT on feedback, advance to Step Transition screen.

---

## 5. Shared Edge Cases

### 5.1 All Answers Wrong in a Step

- No special screen. Each wrong answer gets individual feedback.
- The session continues. Step completes normally.
- Low accuracy is reflected in daily stats and parent report.

### 5.2 Connection to Box Progression

- Correct answers in any scored view → counted toward Day 1 promotion
- Wrong answers → word stays in current box (or goes to Box 1 if from review)
- Results are written to `ReviewLog` per-item as the student answers (not batched at step end)

### 5.3 Pause During Scored View

- Pausing saves current round index
- Resume returns to the exact round (e.g., round 7/12 in image game)
- Already-answered rounds are preserved (scores kept)
- The current unanswered round is shown fresh (no partial state)

### 5.4 Show Again Priority in Image Game

Per `flashcard-design.md` Section 15:
- Words flagged "Show Again" in Step 1 fill the "new word" slots first in Step 2
- These words show a gold "FROM STEP 1" badge instead of REVIEW badge
- Otherwise identical behavior

---

## 6. Changes from Current Code

| Aspect | Current | New |
|--------|---------|-----|
| Image game layout | Image stretched, basic buttons | Image proportional with gradient caption, 3D buttons |
| Image game feedback | Basic correct/wrong | Microcopy toast + XP animation + auto-advance timing |
| SAT question layout | Full-scroll, answers mixed with passage | Split-scroll: passage top (scrollable), question bottom (fixed) |
| SAT feedback | Sheet with explanation | Bottom sheet with verdict + word + meaning + explanation |
| Quick recall | Does not exist | New view: word → 4 definitions, purple theme, fast-paced |
| Scoring | Flashcard Review/Master buttons (scored) | Flashcards not scored. Game/recall/SAT are the only scored events |
| Progress | "Mastered X/Y" in toolbar | "Step X of Y · 📊 SCORED" + progress bar |
| Distractor generation | Not specified | Defined rules: same zone, same POS, random |
