# SAT Vocab V1 — UI Design Specification

## Overview

This document is the complete UI specification for SAT Vocab V1. It defines every screen, every button action, every state, and every edge case. The learning model (`docs/learning-model-design.md`) defines **what** happens to the data; this document defines **what the student sees and does**.

This spec is the V1 target. Values marked with ⚙️ are **provisional** and configurable via `AppConfig` — they may be tuned after initial testing without changing the UI structure.

---

## 1. App Structure

### 1.1 Tab Bar (4 tabs)

| Tab | Icon | Label | Primary Purpose |
|-----|------|-------|----------------|
| 1 | 🗺️ | Map | Adventure progress, zone navigation |
| 2 | 📝 | Practice | Daily sessions (primary daily screen) |
| 3 | 📊 | Stats | Progress visualization, word mastery |
| 4 | 👤 | Profile | Settings, parent report, account |

**Removed from current app:** Tasks tab, Games tab.

**Tab bar behavior:**
- Hidden during active sessions (flashcard, game, SAT, recall)
- Visible on all 4 main tab screens
- Active tab: green (#58CC02) label + dot indicator
- Inactive tab: gray (#AFAFAF) label

### 1.2 Design System

**Colors (Duolingo palette):**

| Token | Hex | Usage |
|-------|-----|-------|
| primary | #58CC02 | Correct, progress, completed, CTA |
| primary-pressed | #58A700 | 3D button bottom border |
| gold | #FFC800 | XP, current day, streak, resume |
| gold-pressed | #E5AC00 | Gold button bottom border |
| orange | #FF9600 | Streaks, SAT questions, warnings |
| red | #FF4B4B | Wrong, review needed, hearts |
| red-pressed | #EA2B2B | Red button bottom border |
| blue | #1CB0F6 | Selected option, info |
| blue-pressed | #1899D6 | Blue button bottom border |
| purple | #CE82FF | Quick recall, bonus |
| text-primary | #4B4B4B | Headings, body text |
| text-secondary | #AFAFAF | Subtitles, labels |
| border | #E5E5E5 | Card borders, dividers |
| bg-light | #F7F7F7 | Section backgrounds |

**3D Button pattern (all major buttons):**
- `border-radius: 14px`
- `border-bottom: 4px solid [pressed-color]`
- `font-weight: 800`
- `font-size: 13-15px`
- `padding: 12-14px`
- `text-transform: uppercase` for action buttons
- `letter-spacing: 0.3-0.5px`

**Card pattern:**
- `border: 2px solid #E5E5E5`
- `border-bottom: 4px solid #E5E5E5`
- `border-radius: 14px`
- Active/selected: border color changes to relevant color

**Progress bar:**
- Height: 7px
- Background: #E5E5E5
- Fill: rounded, color matches context (green for learning, orange for SAT, purple for recall)

**Typography:** SF Pro (system). Headings: 800 weight. Body: 500-600. Labels: 600, 10px, uppercase, letter-spacing 0.5px.

**Spacing:** 8pt grid (8, 12, 14, 16, 20, 24px).

**Responsive layout rules:**
- Use `GeometryReader` proportional sizing, not fixed pt values
- SAT passage area: min 35%, max 45% of available height
- Image game image: min 40%, max 55% of available height
- All interactive elements: minimum 44x44pt touch target
- Support Dynamic Type for body text (headings can be fixed)

### 1.3 Voice & Microcopy

**Tone:** Smart friend + sharp SAT coach. Playful and energetic, but not childish. Quick, witty, slightly self-aware. The app should feel like a study buddy who's genuinely good at SAT vocab, not a generic educational tool.

**Microcopy examples by context:**

| Context | Example Copy |
|---------|-------------|
| Correct answer | "Nailed it." · "That one's yours now." · "Clean." |
| Wrong answer | "That word is fighting back." · "Not yet — you'll get it." · "Tricky one. It'll stick next time." |
| Streak maintained | "5 days strong. Keep building." · "Consistency wins." |
| Streak broken | "Streaks reset. Knowledge doesn't. Let's go." |
| Almost done with step | "3 left. You're cruising." · "Almost there — finish strong." |
| Session complete | "Done. Your brain just leveled up." · "See you tonight — let it sink in." |
| Stubborn word | "This one keeps coming back. Let's try a new angle." |
| Zone unlocked | "Zone 2 unlocked. New territory." · "Cloud Realm awaits." |
| Comeback after missed day | "Welcome back. Pick up where you left off." |
| Bonus practice | "Extra reps? That's how you get ahead." |
| Rush detection | "Slow down — your brain needs a second." |
| Evening locked | "Let it marinate. Come back at 5 PM." |
| Final day | "372 words. 20 days. Let's see what stuck." |

**Rules:**
- No emoji in microcopy text (emoji live in icons/badges, not in sentences)
- Max 8 words per line where possible
- Never condescending, never fake-enthusiastic
- Rotate variants — don't show the same line twice in a session

### 1.4 Provisional Values ⚙️

These values are configurable in `AppConfig` and may be tuned after initial testing:

| Value | Default | Where Used |
|-------|---------|-----------|
| Morning new words | 11 ⚙️ | Session 1 flashcard count |
| Evening new words | 10 ⚙️ | Session 2 flashcard count |
| Image game rounds (morning) | 12 (8 new + 4 review) ⚙️ | Step 2 |
| Image game rounds (evening) | 12 (6 new + 6 review) ⚙️ | Step 3 |
| SAT questions (morning) | 3 ⚙️ | Step 3 |
| SAT questions (evening) | 2 ⚙️ | Step 4 |
| Evening unlock gap | 4 hours ⚙️ | Lock timer |
| Evening unlock fallback | 5:00 PM ⚙️ | Lock timer |
| Back-pressure: reduce threshold | 18 overdue ⚙️ | New word reduction |
| Back-pressure: stop threshold | 30 overdue ⚙️ | Review-only day |
| Back-pressure: reduced count | 12 new ⚙️ | Reduced day |
| Zone test pass threshold | 80% ⚙️ | Zone unlock |
| Rush detection: flashcard min | 3 seconds ⚙️ | Toast trigger |
| Rush detection: game min | 1 second ⚙️ | Toast trigger |
| Background resume threshold | 30 minutes ⚙️ | Resume vs in-place |

---

## 2. Tab 1: Adventure Map

### 2.1 Screen Layout

```
┌──────────────────────────────┐
│ [🔥5]    SAT Vocab     [⚡1.2k] │  ← Header: streak + XP badges
│                                │
│   🌿 ZONE 1 — Foundation      │  ← Zone title pill
│   ████████░░ 49/75 familiar+   │  ← Zone word progress bar
│                                │
│         [✓] Day 1              │  ← Completed node
│         ☀️🌙                    │  ← Session indicators
│                                │
│            [✓] Day 2           │
│            ☀️🌙                 │
│                                │
│      [☀️] Day 3                │  ← Half state (morning done)
│      ☀️ 🌙                     │  ← Morning filled, evening dim
│                                │
│         [🏆] Test              │  ← Zone test (distinct icon)
│                                │
│    [ START EVENING SESSION ]   │  ← Context-aware CTA
│                                │
│  🗺️    📝    📊    👤          │  ← Tab bar
└──────────────────────────────┘
```

### 2.2 Day Node States

| State | Visual | Session Dots | Condition |
|-------|--------|-------------|-----------|
| Completed | Green circle, ✓, 3D border | ☀️🌙 (both filled) | Both sessions done |
| Morning done | Green/Gold split circle, ☀️ icon | ☀️ filled, 🌙 dim | Morning done, evening pending |
| Current (not started) | Gold circle, ⭐, pulse glow | Neither filled | Next day to do, morning not started |
| Available | Green circle, smaller | Neither filled | Zone unlocked, day accessible |
| Locked | Gray circle, 🔒 | Hidden | Zone not unlocked |

### 2.3 Zone Test Node

- Icon: 🏆 (not ⭐)
- Label: "TEST" (not "Day 4")
- Color: indigo/purple when available, gray when locked
- Tap action: navigate to zone test session

### 2.4 Zone Navigation

- Left/right chevron buttons to switch zones
- Zone background: illustrated image per zone (generated separately)
- Zone title pill: semi-transparent, backdrop blur, zone emoji + name
- Zone word progress bar: thin bar below title, shows familiar+ word count

### 2.5 Map Button Actions

| Element | Tap Action |
|---------|-----------|
| Day node (any state except locked) | Switch to Practice tab with that day selected |
| Day node (locked) | Disabled, no action |
| Zone test node | Navigate to zone test session |
| Zone chevrons | Switch displayed zone |
| START button | Navigate to Practice tab, start appropriate session |

### 2.6 Map CTA Button (context-aware)

| Context | Button Text | Style |
|---------|------------|-------|
| Morning session available | "START MORNING SESSION" | Green 3D |
| Morning done, evening locked | "LET IT MARINATE. BACK AT 5 PM." | Gray 3D |
| Evening session available | "START EVENING SESSION" | Green 3D |
| Both done today | "DAY COMPLETE ✓" | Green 3D (disabled) |
| Session paused | "RESUME SESSION" | Gold 3D |
| Recovery needed | "START RECOVERY" | Orange 3D |
| Zone locked | "🔒 LOCKED" | Gray 3D (disabled) |

---

## 3. Tab 2: Practice (Daily Hub)

This is the primary screen students interact with daily.

### 3.1 Header

```
Day 5                          🔥5  ⚡1.2k
Zone 2 · Cloud Realm
SAT Reading & Writing Score Builder
```

- Day number: 18px, weight 800
- Zone info: 11px, secondary color
- Streak badge: orange background pill
- XP badge: gold background pill

### 3.2 Practice Tab States

The Practice tab has **10 possible states**. Each state shows different cards.

#### State A: Morning Available, Evening Locked

```
┌─ Morning Session Card (active, green border) ──┐
│ ☀️ Morning Session                              │
│ Learn 11 new words · ~16 min                    │
│ [📚 Flashcards] [🎮 Image Game] [📝 SAT]       │
│ [ START ]                                       │
└─────────────────────────────────────────────────┘

┌─ Evening Session Card (dimmed, locked) ─────────┐
│ 🌙 Evening Session                    🔒        │
│ Review & strengthen · ~17 min                    │
│ ┌─────────────────────────────────┐              │
│ │ Let it marinate. Back at 5 PM.  │              │
│ └─────────────────────────────────┘              │
└─────────────────────────────────────────────────┘

Reviews due today: 12 words
```

#### State B: Morning In Progress (Paused)

```
┌─ Resume Card (gold border) ─────────────────────┐
│ ▶️ Continue Morning Session                      │
│ Paused at Step 1: Flashcards · 3/11             │
│ [███░░░░░░░]                                     │
│ [📚 8 left] [🎮 Image Game] [📝 SAT]            │
│ [ RESUME ]                                       │
└─────────────────────────────────────────────────┘
   Restart from beginning

┌─ Evening (locked, dimmed) ──────────────────────┐
│ Complete morning first                    🔒     │
└─────────────────────────────────────────────────┘
```

#### State C: Morning Done, Evening Locked

```
┌─ Morning Complete (green bg) ───────────────────┐
│ ✓ Morning Complete                               │
│ 11 new words · 82% accuracy · +180 XP           │
└─────────────────────────────────────────────────┘

┌─ Evening Session Card (dimmed, locked) ─────────┐
│ 🌙 Evening Session                    🔒        │
│ Unlocks at 5:00 PM (2h 30m remaining)            │
└─────────────────────────────────────────────────┘
```

#### State D: Morning Done, Evening Available

```
┌─ Morning Complete (green bg, compact) ──────────┐
│ ✓ Morning · 11 words · 82%                      │
└─────────────────────────────────────────────────┘

┌─ Evening Session Card (active, green border) ───┐
│ 🌙 Evening Session                              │
│ 10 new + review morning words · ~17 min          │
│ [📚 Learn] [🧠 Recall] [🎮 Game] [📝 SAT]      │
│ [ START ]                                        │
└─────────────────────────────────────────────────┘
```

#### State E: Both Sessions Complete

```
┌─ Morning Complete (compact) ────────────────────┐
│ ✓ Morning · 11 words · 82%                      │
└─────────────────────────────────────────────────┘
┌─ Evening Complete (compact) ────────────────────┐
│ ✓ Evening · 10 words · 85%                      │
└─────────────────────────────────────────────────┘

┌─ Today's Summary ───────────────────────────────┐
│ 21 NEW  |  14 REVIEWED  |  83% ACCURACY  | +350 XP │
└─────────────────────────────────────────────────┘

[ 📤 SHARE TODAY'S PROGRESS ]  ← Blue 3D button

┌─ Bonus Practice ────────────────────────────────┐
│ ⭐ Bonus Practice                                │
│ Extra reps? That's how you get ahead.            │
│ [ PRACTICE MORE ]                                │
└─────────────────────────────────────────────────┘
```

#### State F1: Recovery Evening (missed last evening only)

```
┌─ Recovery Banner (orange gradient) ─────────────┐
│ 👋 Welcome back. Let's finish yesterday first.   │
│ Your morning words still need their evening pass.│
└─────────────────────────────────────────────────┘

┌─ Recovery Session Card (orange border) ─────────┐
│ 🔄 Recovery Evening                              │
│ Finish yesterday's review · ~12 min              │
│ [🧠 Recall yesterday] [🎮 Practice]             │
│ [ START RECOVERY ]                               │
└─────────────────────────────────────────────────┘

┌─ Today's Morning (locked, dimmed) ──────────────┐
│ Complete recovery first                   🔒     │
└─────────────────────────────────────────────────┘
```

**Behavior:** Yesterday's morning words do NOT get same-day Box 2 acceleration. They enter Box 1 after recovery.

#### State F2: Catch-Up Day (missed 1 full day)

```
┌─ Catch-Up Banner (orange gradient) ─────────────┐
│ 👋 Missed a day? No stress.                      │
│ Lighter load today — catch up, then keep going.  │
└─────────────────────────────────────────────────┘

┌─ Catch-Up Session Card (orange border) ─────────┐
│ 🔄 Catch-Up Session                              │
│ Yesterday's words + priority reviews · ~15 min   │
│ [📚 Missed words] [🧠 Review] [🎮 Practice]     │
│ [ START CATCH-UP ]                               │
└─────────────────────────────────────────────────┘

┌─ Today's Sessions (reduced, dimmed) ────────────┐
│ Available after catch-up · Reduced new words      │
└─────────────────────────────────────────────────┘
```

**Behavior:** Today's new word count reduced by ~50% ⚙️. Catch-up session covers missed words + overdue Box 1-2 reviews.

#### State F3: Re-entry Day (missed 3+ days)

```
┌─ Re-entry Banner (warm red gradient) ───────────┐
│ 👋 It's been a few days. Welcome back.           │
│ Let's start with what you remember.              │
└─────────────────────────────────────────────────┘

┌─ Re-entry Session Card (red-orange border) ─────┐
│ 🔄 Re-entry Review                               │
│ Diagnostic review · See what stuck · ~15 min     │
│ [🧠 Recall check] [🎮 Practice]                 │
│ [ START RE-ENTRY ]                               │
└─────────────────────────────────────────────────┘

No new words until overdue queue is healthy.
```

**Behavior:** No new words. Review-only. New words resume when overdue Box 1-2 queue drops below threshold ⚙️. Program may extend by 1-3 study days.

#### State G: Back-Pressure / Review-Only Day

```
┌─ Review Focus Banner (blue gradient) ───────────┐
│ 📚 Review Focus Day                              │
│ 32 words need attention. Strengthening first.    │
└─────────────────────────────────────────────────┘

┌─ Review Session Card ───────────────────────────┐
│ 🔄 Review Session                                │
│ No new words today · Focus on mastery            │
│ [ START REVIEW ]                                 │
└─────────────────────────────────────────────────┘
```

#### State H: Late Night Session (started morning after 8 PM)

```
┌─ Late Night Banner (purple gradient) ───────────┐
│ 🌙 Late study session — no evening expected.     │
│ These words will get their review tomorrow.      │
└─────────────────────────────────────────────────┘

┌─ Night Session Card (purple border) ────────────┐
│ 🌙 Night Session                                 │
│ Learn new words · No evening follow-up tonight   │
│ [ START ]                                        │
└─────────────────────────────────────────────────┘
```

**Behavior:** Words do NOT qualify for same-day Box 2 acceleration. They enter Box 1, with review due tomorrow. The next day starts fresh with a normal morning.

### 3.3 Recovery Component Architecture

States F1, F2, F3 share the same UI components with different configuration:

```swift
enum RecoveryType {
    case recoveryEvening   // F1
    case catchUpDay        // F2
    case reEntryDay        // F3
}
```

`RecoveryBanner(type:)` — controls icon, title, subtitle, gradient colors.
`RecoverySessionCard(type:)` — controls session structure, step tags, button label.

### 3.4 Practice-State Priority Resolver

When multiple conditions overlap (e.g., paused session + recovery needed + back-pressure), the Practice tab resolves to **one** state using this priority order (highest priority first):

```
1. State B  — Paused session exists → show Resume card (always wins)
2. State F3 — Missed 3+ days → Re-entry Day (review-only)
3. State F2 — Missed 1-2 days → Catch-Up Day
4. State F1 — Missed evening only → Recovery Evening
5. State G  — Back-pressure triggered (overdue > 30) → Review-Only Day
6. State H  — Current time ≥ 8 PM and morning not done → Late Night
7. State A  — Morning available, evening locked (normal morning)
8. State C  — Morning done, evening locked (waiting)
9. State D  — Morning done, evening unlocked (normal evening)
10. State E — Both sessions done (day complete)
```

**Implementation:** A single `PracticeTabStateResolver` function evaluates conditions top-to-bottom and returns the first match.

### 3.5 Button Actions on Practice Tab

| Button | Action |
|--------|--------|
| START (morning) | Begin morning session → navigate to Step 1 (flashcards). Hide tab bar. Save session start time. |
| START (evening) | Begin evening session → navigate to Step 1 (flashcards). Hide tab bar. |
| RESUME | Navigate directly to the paused step and item. Hide tab bar. |
| START RECOVERY | Begin recovery session (type depends on F1/F2/F3). |
| START CATCH-UP | Begin catch-up session with reduced new words + overdue reviews. |
| START RE-ENTRY | Begin diagnostic review session (no new words). |
| START REVIEW | Begin review-only session (back-pressure triggered). |
| SHARE TODAY'S PROGRESS | Generate report card image → open iOS share sheet. |
| PRACTICE MORE | Begin bonus practice (Box 1-2 words only, half XP). |
| "Restart from beginning" (text link) | Show confirmation → clear partial session → restart Step 1 item 0. Previous scored events marked `superseded` (see Section 5.5). |

---

## 4. In-Session Flow

### 4.1 Session Structure

**Morning Session (3 steps):**

| Step | Activity | Items | Scoring | Duration |
|------|----------|-------|---------|----------|
| 1 | New word flashcards | 11 ⚙️ cards | 👁️ Exposure only | ~7 min |
| 2 | Image-to-word game | 12 ⚙️ rounds (8 new + 4 review) | 📊 Scored | ~5 min |
| 3 | SAT questions | 3 ⚙️ questions | 📊 Scored | ~4 min |

**Evening Session (4 steps):**

| Step | Activity | Items | Scoring | Duration |
|------|----------|-------|---------|----------|
| 1 | New word flashcards | 10 ⚙️ cards | 👁️ Exposure only | ~7 min |
| 2 | Quick recall (morning words) | 11 words | 📊 Scored (Day 1 promotion) | ~4 min |
| 3 | Image-to-word game | 12 ⚙️ rounds (6 new + 6 review) | 📊 Scored (Day 1 promotion) | ~5 min |
| 4 | SAT questions | 2 ⚙️ questions | 📊 Scored | ~2.5 min |

**Scoring key:**
- 👁️ Exposure only = student sees the word but no scored recall. Does not affect box progression.
- 📊 Scored = objective recall event. Affects box progression and same-day promotion.

### 4.2 Session Header (all steps)

```
✕                STEP 1 OF 3                 🔊
              Explore New Words · 3/11
[███████░░░░░░░░░░░░░░░░░░░░░░░░]
```

- ✕ button: triggers pause confirmation (see Section 5)
- Step label: "STEP X OF Y" (10px, uppercase, secondary)
- Activity label + progress: "Explore New Words · 3/11" (12px, bold)
- Progress bar: fills based on current item / total items in step
- 🔊 button: text-to-speech for current word (flashcard/recall only)

### 4.3 Step 1: Flashcard View (Exposure Only)

> **Full flashcard spec: `docs/flashcard-design.md`** — authoritative reference for flashcard layout, gestures, adaptive sizing, and implementation.

```
┌──────────────────────────────────┐
│       [progress bar overlay]     │  ← Top 10%
│  ✕       [ 2 / 5 ]          🔊  │
│                                  │
│       [ FULL ILLUSTRATION ]      │  ← Image fills 100%
│         object-fit: cover        │
│       character centered here    │  ← Middle 40-60%
│                                  │
│       [dark gradient overlay]    │  ← Bottom 20-30%
│  The minimalist design           │
│  reflected a particular          │
│  AESTHETIC philosophy            │  ← Sentence + gold word
│  that favored simplicity.        │
│      tap to flip · swipe next →  │
└──────────────────────────────────┘
BACK: definition, example, collocations, SAT context
      + [SHOW AGAIN] [GOT IT →] (soft signal, not scored)
```

**Front side (initial view):**
- Card: white bg, 3D border, rounded 14px
- Image: fills top portion, aspect fit, proportional height (min 40%, max 55%)
- Part of speech: small badge top-right of image
- Word: 22px, weight 800, centered
- Definition: 12px, secondary, centered
- Example sentence: 11px, italic, word highlighted in green

**Tap to flip → Back side:**
- 3D rotation animation (0.4s)
- Shows: definition, example with highlighted word, collocations (top 3), SAT context
- Two soft-signal buttons:
  - **SHOW AGAIN** (outlined/gray 3D) → card re-queued at end of current step
  - **GOT IT →** (green 3D) → advance to next card

**Important:** These buttons are **soft signals for within-session ordering only**. They do NOT affect box progression. Box progression is driven purely by scored events in Steps 2-4.

**On review cards only:** small difficulty badge top-left:
- 🟢 easy · ⚪ normal · 🟡 fragile · 🔴 stubborn

### 4.4 Step 2: Image-to-Word Game (📊 Scored)

> **Full game & recall spec: `docs/game-views-design.md`** — authoritative reference for image game, quick recall, and SAT question layout, gestures, feedback, scoring, and sizing. Summary below for context.

```
┌─ Image area ─────────────────────────────────────┐
│                                                   │
│  [REVIEW]        [mnemonic image]                 │
│                                                   │
│  ─────────── CHOOSE THE BEST WORD ───────────     │
└───────────────────────────────────────────────────┘

   The sunset was ________, gone in moments.

   ┌──────────┐  ┌──────────┐
   │ ephemeral│  │ perpetual│
   └──────────┘  └──────────┘
   ┌──────────┐  ┌──────────┐
   │  mundane │  │ abundant │
   └──────────┘  └──────────┘
```

- Image: proportional height (min 40%, max 55%), rounded corners, gradient overlay at bottom with caption
- REVIEW badge: orange pill, top-left of image, only on review words
- Cloze sentence: centered, blank highlighted with gold underline
- 2x2 grid: 3D card buttons, font 13px bold
- Correct answer: card turns green, microcopy toast (e.g., "Nailed it."), auto-advance 1.5s
- Wrong answer: card turns red, correct card pulses green, microcopy toast (e.g., "That word is fighting back."), auto-advance 2s
- This is a **primary scored event** for same-day box promotion
- Minimum response time: 1 second ⚙️ (faster = flagged as guess, doesn't count for promotion)

### 4.5 Step 3: SAT Question (Split Scroll) (📊 Scored)

```
┌─ Passage (scrollable, proportional height) ─────┐
│ 📖 PASSAGE                           scroll ↕    │
│                                                   │
│ The environmental movement has undergone a        │
│ [profound transformation] in recent decades...     │
└───────────────────────────────────────────────────┘
               ─── QUESTION ───
As used in the passage, "profound transformation"
most nearly means:

  (A) a minor adjustment
  ⦿ (B) a fundamental change        ← selected (blue)
  (C) a temporary shift
  (D) a superficial alteration

[ CHECK ]
```

- Passage area: warm yellow background (#FFF8E1), 2px border (#FFE082), scrollable independently, proportional height (min 35%, max 45%)
- Target word/phrase: highlighted with yellow underline gradient
- Question area: fills remaining space, fixed (not scrollable)
- Options: 3D card style, letter circle left-aligned, full-width rows
- Selected option: blue border + blue letter circle + blue text
- CHECK button: green when option selected, gray when not
- After CHECK:
  - Correct: green flash, microcopy (e.g., "Clean."), explanation shown
  - Wrong: red flash, correct option highlighted, microcopy (e.g., "Brutal SAT word, but you'll get it."), explanation shown
  - Both show: word definition, context, explanation
  - NEXT button to advance

### 4.6 Quick Recall (Evening Step 2 — 📊 Scored, Day 1 Promotion)

```
            WHAT DOES THIS MEAN?

              EPHEMERAL
           from this morning

  ┌─────────────────────────────────┐
  │ very important or significant   │
  └─────────────────────────────────┘
  ┌─────────────────────────────────┐
  │ lasting a very short time       │
  └─────────────────────────────────┘
  ┌─────────────────────────────────┐
  │ extremely complicated           │
  └─────────────────────────────────┘
  ┌─────────────────────────────────┐
  │ widely known and admired        │
  └─────────────────────────────────┘
```

- Word: 28px, weight 800, centered
- "from this morning" label: purple (#CE82FF), 11px
- 4 definition choices: full-width 3D card buttons, 13px text
- Progress bar: purple fill
- Correct: card flashes green, microcopy, 1s pause, auto-advance
- Wrong: card flashes red, correct card highlighted green, auto-advance after 2s
- This is a **primary scored event** for same-day box promotion
- Minimum response time: 1 second ⚙️ (faster = flagged as guess, doesn't count)

**Day 1 promotion scored events (3 total):**
1. Morning image-to-word game (Step 2)
2. Evening quick recall (Step 2)
3. Evening image-to-word game (Step 3)

Promotion rule: 2/3 scored correct AND correct final recall → Box 2. Otherwise → Box 1.

### 4.7 Step Transition Screen

Shown between steps. Auto-advances after 3 seconds or tap CONTINUE.

```
              🎉

        Step 1 Complete!
     11 new words explored

          ● ○ ○

        ┌─ NEXT UP ──────────┐
        │ 🎮 Image Practice  │
        │ 12 rounds          │
        └────────────────────┘

        [ CONTINUE ]
```

- Celebration emoji: changes per step (🎉, 💪, 🏆)
- Microcopy: varies (e.g., "11 new words explored" / "12 rounds crushed" / "3 SAT questions down")
- Step dots: filled = done, empty = remaining
- Next up card: gray background, shows next activity name + count
- CONTINUE button: green 3D

### 4.8 Session Complete Screen

```
              🎉

     Done. Your brain just leveled up.

   🔥5 STREAK    +350 XP    105 WORDS

  ┌─ TODAY'S BOX MOVES ──────────────┐
  │ ↑ 18 promoted                    │
  │ ↓ 3 need more practice           │
  └──────────────────────────────────┘

  [ 📤 SHARE TODAY'S PROGRESS ]
  [ DONE ]
```

- Confetti animation (particles falling) for milestones (zone complete, 50 words, 10-day streak)
- Microcopy rotates: "Done. Your brain just leveled up." / "That's a wrap." / "Solid session."
- Stats row: 3 tiles with icon + number + label
- Box moves: simple summary of promotions and demotions today
- Share button: blue 3D, generates report card image
- DONE button: green 3D, returns to Practice tab
- If only morning complete: "See you tonight — let it sink in." message. **No share button on morning-only completion.**
- Share button ("Share Today's Progress") appears ONLY on:
  - Evening session complete screen
  - Practice tab State E (both sessions done)
  - Profile tab (always available)

### 4.9 Rush Detection

**Applies to scored steps only (image game, quick recall, SAT questions). Does NOT apply to flashcards — flashcards are exposure-only and have no scoring or rush checks.**

- Game answer in < 1 second ⚙️: toast "Too fast. Take a moment."
- Quick recall answer in < 1 second ⚙️: same toast
- SAT question answered in < 3 seconds ⚙️: toast "Slow down — your brain needs a second."
- These are non-blocking — don't pause the session
- Rushed answers don't count toward same-day box promotion
- After 3 rush warnings in a session: slightly larger banner "Learning works best when you take your time." (dismissible)

---

## 5. Session Interruption & Resume

### 5.1 Pause Confirmation (tapping ✕)

Bottom sheet modal slides up. Background dimmed.

**Content varies by progress:**

| Progress | Title | Encouragement | Primary Button |
|----------|-------|---------------|----------------|
| < 50% of current step | "Pause Session?" | "Progress saved automatically." | KEEP GOING (green) |
| ≥ 50% of current step | "Almost there." | "X left. ~Y min." | FINISH IT (green) |
| Between steps | "Pause Session?" | Step checklist (✓ done, ○ pending) | CONTINUE TO STEP X (green) |

**All variants show:**
- Progress info: current step, items done / total, estimated time remaining
- Focus tip (< 50%): "Finishing in one sitting helps it stick."
- Secondary button: "PAUSE & EXIT" (gray 3D) — always available

**Pause & Exit action:**
1. Save current step index + current item index to UserDefaults
2. Log all completed reviews to SQLite (already done per-item)
3. Navigate back to Practice tab
4. Practice tab shows Resume card (State B)

### 5.2 Resume Card

Shown on Practice tab when a session is paused.

**Gold border card replacing the normal session card:**
- ▶️ icon with gold gradient circle
- "Continue [Morning/Evening] Session"
- "Paused at Step X: [Activity] · Y/Z"
- Segmented progress bar (done = green, remaining = gold, unstarted = gray)
- Step activity tags showing remaining steps
- RESUME button (gold 3D)
- "Restart from beginning" text link (small, below card)

**Resume button action:**
1. Read saved step index + item index
2. Navigate directly to that step's view
3. Set current item to saved index
4. Continue session as normal

### 5.3 App Background / Kill Behavior

| Scenario | Behavior |
|----------|----------|
| Switch to another app, return < 30 min ⚙️ | Resume in-place (stay on the activity screen) |
| Switch to another app, return ≥ 30 min ⚙️ | Navigate to Practice tab, show Resume card |
| iOS kills app in background | Next launch: Practice tab with Resume card |
| Student force-quits app | Same as iOS kill: Resume card on next launch |

**Implementation:** Save session state to UserDefaults on every `scenePhase` change to `.background`. On launch / foreground, check for saved state and elapsed time.

### 5.4 Edge Case: Pause During Evening, Resume Next Day

If student pauses the evening session and doesn't return until the next day:
- The paused evening session becomes a **Recovery Evening** (State F1)
- Resume card shows: "🔄 Continue Yesterday's Evening Session"
- After completing it, morning session for today becomes available
- Same-day acceleration does NOT apply (spacing was broken)
- Words from the incomplete evening enter Box 1, not Box 2

### 5.5 Restart Semantics

When a student taps "Restart from beginning":

1. Show confirmation: "Restart session? Your previous answers are kept for practice, but scoring starts fresh."
2. On confirm:
   - All previous scored events from this session are marked `superseded` in the review log
   - Only the latest (restarted) attempt's scored events count toward box progression and XP
   - Previous exposure events are preserved for analytics
   - Clear saved step/item index, start from Step 1 item 0
3. XP from the superseded attempt is subtracted (net zero until new attempt earns it back)

---

## 6. Tab 3: Stats

### 6.1 Layout

```
Your Progress

┌─ Hero Tiles (3 across) ─────────────────────────┐
│  🔥        ⚡         📚                         │
│  5         1,600      105                        │
│  STREAK    XP         WORDS                      │
└──────────────────────────────────────────────────┘

┌─ Word Mastery (stacked bar) ────────────────────┐
│  [████████████████████████░░░░░░░░░░░░░░░]       │
│  🟢 Mastered 15  🟩 Solid 60  🟡 Strong 30       │
│  🟠 Rising 123  🔴 Locked In 17                  │
└──────────────────────────────────────────────────┘

┌─ This Week (calendar) ──────────────────────────┐
│  M    T    W    T    F    S    S                  │
│  ✓    ✓    ✓    ☀️   ○    ○    ○                 │
│  ☀️🌙 ☀️🌙 ☀️🌙 ☀️                                │
└──────────────────────────────────────────────────┘

┌─ Words Fighting Back 💪 ───────────────────────┐
│  These need a different angle. Tap to explore.   │
│  ephemeral          missed 3x · Box 1            │
│  ambivalent         missed 2x · Box 1            │
└──────────────────────────────────────────────────┘

┌─ Zones ─────────────────────────────────────────┐
│  ✓ Foundation                           90%      │
│  ⭐ Cloud Realm                         35%      │
│  🔒 Island · Space · Future City                 │
└──────────────────────────────────────────────────┘
```

### 6.2 Stats Elements

**Hero tiles:** 3D border-bottom style matching Duolingo. Each tile has gradient background matching its color theme.

**Word Mastery bar:** Maps to Leitner boxes:

| Visual | Box | Label | Color |
|--------|-----|-------|-------|
| 🟢 | Box 5 | Mastered | #58CC02 |
| 🟩 | Box 4 | Solid | #89E219 |
| 🟡 | Box 3 | Strong | #FFC800 |
| 🟠 | Box 2 | Rising | #FFAB40 |
| 🔴 | Box 1 | Locked In | #FF7043 |

Note: These are student-facing labels. Internal code uses: mastered, strong, familiar, learning, struggling.

**Weekly calendar:** Shows each day of the current week. Completed days: green circle with ✓. Morning-only days: gold circle with ☀️. Future/missed: gray circle. Session dots below each day.

**Words Fighting Back 💪:** Shows words with `memory_status = stubborn`. Header copy: "These need a different angle." Display-only in V1 (not tappable — WordDetailView is P2). Shows word, miss count, and current box. Max 5 shown. Tappable word detail view deferred to P1/P2.

**Zone progress:** List of zones with completion % (familiar+ words / total zone words). Tappable → shows zone word list with individual box levels.

### 6.3 Stats Button Actions

| Element | Tap Action |
|---------|-----------|
| Hero tile | No action (display only) |
| Word mastery bar | No action (display only) |
| Calendar day | No action (display only) |
| Word Fighting Back row | Display only in V1 (no tap action) |
| "See all" | Deferred to P1/P2 |
| Zone row | Navigate to zone word list view |

---

## 7. Tab 4: Profile

### 7.1 Layout (V1)

```
Profile

┌─ User Info ─────────────────────────────────────┐
│ 👤 Student Name                                  │
│ Day 5 · Zone 2 · 105 words learned               │
└──────────────────────────────────────────────────┘

┌─ Report ────────────────────────────────────────┐
│ 📤 Share Today's Progress                     [>]  │
└──────────────────────────────────────────────────┘

┌─ Session Settings ──────────────────────────────┐
│ 🔔 Morning Reminder: 8:00 AM       [toggle]     │
│ 🔔 Evening Reminder: 6:00 PM       [toggle]     │
└──────────────────────────────────────────────────┘

┌─ Danger Zone ───────────────────────────────────┐
│ 🔄 Reset All Progress                       [>]  │
└──────────────────────────────────────────────────┘
```

### 7.2 Profile Button Actions

| Element | Tap Action |
|---------|-----------|
| Share Today's Progress | Generate report image → iOS share sheet |
| Evening Unlock Mode | Removed from V1. Hardcoded: 4-hour gap OR after 5 PM, whichever comes first. |
| Morning/Evening Reminder | Toggle → request notification permission if needed, schedule local notification at specified time |
| Reset All Progress | Confirmation dialog ("This cannot be undone. All words, sessions, and progress will be reset.") → clears all data |

### 7.3 V2 Profile Additions (not in V1)

- Parent email input + auto-send toggle
- Report time picker
- Customizable daily word count (casual/regular/intense)
- Cloud sync settings

---

## 8. Parent Report Card

### 8.1 Report Card Image (generated in-app)

The report is a rendered image (not a live view) that can be shared via iOS share sheet.

**Content:**
```
┌─────────────────────────────────┐
│ 📊 SAT Vocab Report             │  ← Green gradient header
│ Day 5 · April 11, 2026          │
├─────────────────────────────────┤
│ ✓✓      🔥5     33m     83%    │  ← Sessions, streak, time, accuracy
│ SESSIONS STREAK  TIME  ACCURACY │
├─────────────────────────────────┤
│ [████████████░░░░░░░░░░░░]      │  ← Mastery bar
│ 105/372 words at familiar+      │
├─────────────────────────────────┤
│ ⚠️ Words fighting back:         │  ← Stubborn words (if any)
│ ephemeral, ambivalent, pragmatic│
├─────────────────────────────────┤
│ 🎉 Milestone: 100 words!        │  ← Only when earned
└─────────────────────────────────┘
```

**Size:** iPhone-friendly aspect ratio (roughly 3:4 or 1:1)

**Generation:** Use SwiftUI `ImageRenderer` to render a view to UIImage, then pass to `UIActivityViewController`.

### 8.2 When Report Is Offered

- After completing **evening session** → on Session Complete screen
- On **Practice tab** when both sessions are done (State E)
- On **Profile tab** → "Share Today's Progress" button (always available)

---

## 9. Zone Test Session

### 9.1 Structure (reduced from original)

Zone test is a single session, shorter than a normal daily session:

| Step | Activity | Items | Source |
|------|----------|-------|--------|
| 1 | Quick recall | 10 words ⚙️ | Random sample from all zone words |
| 2 | Image-to-word game | 10 rounds ⚙️ | Zone words |
| 3 | SAT questions | 5 questions ⚙️ | Zone words |

**Total: 25 items, ~12 minutes.**

### 9.2 Scoring & Remediation

- Minimum 80% ⚙️ accuracy across all steps to pass
- Score shown on completion screen

**Pass:**
- Celebration + zone unlock animation + "Zone X Unlocked. New territory."
- Words scored correctly are promoted one box level
- Share Report offered

**Fail (1st attempt):**
- Encouraging message: "Not yet. Let's work on the ones you missed."
- Missed words go to Box 1
- Student enters **remediation round**: short flashcard review + image game round on ONLY missed words
- After remediation, a **focused retest**: 10-item recall test on previously missed words
- Pass focused retest (80% ⚙️) → zone unlocks
- Fail focused retest → can retry remediation + retest (same day)

**Fail (3rd+ attempt same day):**
- Message: "Take a break. These words need time to settle. Try again tomorrow."
- Next study day becomes a remediation day for this zone's weak words before retesting

### 9.3 Zone Test UI Differences

- Header shows: "ZONE 1 TEST" instead of "STEP X OF Y"
- Progress bar: purple/indigo fill
- Completion screen shows pass/fail verdict prominently
- No Share Report on fail (only on pass or daily sessions)

---

## 10. Final Review Days (19-20)

### Day 19: Weak Word Blitz

Two sessions focused entirely on Box 1-2 words:
- Morning: 15 weakest words (flashcard exposure + image game)
- Evening: Next 15 weakest words + SAT practice

Practice tab shows special banner: "Final stretch. Time to lock in the tough ones."

### Day 20: Final Assessment

- Morning: 30-question comprehensive SAT-style test (covers all zones)
- Evening: Results review + mastery celebration + final stats

Practice tab shows: "372 words. 20 days. Let's see what stuck."

Session Complete shows extended results:
- Overall mastery percentage
- Zone-by-zone breakdown
- Total words mastered (Box 3+)
- Study time over 20 days
- "Share Final Report" button (special report card with full results)

---

## 11. Screens Inventory

Complete list of all unique screens/views to implement:

| # | Screen | New/Existing | Priority |
|---|--------|-------------|----------|
| 1 | RootTabView (4 tabs) | Modify | P0 |
| 2 | AdventureMapView (zone backgrounds, node states) | Redesign | P0 |
| 3 | PracticeTabView (daily hub, 10 states) | **New** | P0 |
| 4 | MorningSessionCard | **New** | P0 |
| 5 | EveningSessionCard | **New** | P0 |
| 6 | ResumeCard | **New** | P0 |
| 7 | RecoveryBanner(type:) | **New** | P1 |
| 8 | RecoverySessionCard(type:) | **New** | P1 |
| 9 | BackPressureBanner | **New** | P1 |
| 10 | LateNightBanner | **New** | P2 |
| 11 | SessionFlowView (step orchestrator) | **New** | P0 |
| 12 | FlashcardView (exposure only, Got it / Show again) | Redesign | P0 |
| 13 | ClozeRoundView / Image Game (scored, polish) | Redesign | P0 |
| 14 | SatMCQRoundView (split scroll, scored) | Redesign | P0 |
| 15 | QuickRecallView (scored) | **New** | P0 |
| 16 | StepTransitionView | **New** | P1 |
| 17 | SessionCompleteView | **New** | P0 |
| 18 | PauseConfirmationSheet | **New** | P0 |
| 19 | StatsView (redesign) | Redesign | P1 |
| 20 | BoxDistributionChart | **New** | P1 |
| 21 | WeeklyCalendarView | **New** | P1 |
| 22 | WordsFightingBackView (display-only list, no tap) | **New** | P1 |
| 23 | ZoneMasteryListView | **New** | P1 |
| 24 | ProfileView (V1 settings) | Redesign | P1 |
| 25 | ParentReportCardView (image renderer) | **New** | P1 |
| 26 | ZoneTestSessionView (reduced + remediation) | Redesign | P1 |
| 27 | ZoneRemediationView | **New** | P1 |
| 28 | WordDetailView | **New** | P2 |
| 29 | RushDetectionToast | **New** | P2 |
| 30 | BonusPracticeView | **New** | P2 |

**Priority definitions:**
- **P0 = V1 first release** — must ship for the app to be usable
- **P1 = V1.1 fast follow** — ship within 1-2 weeks after first release
- **P2 = V2** — not in the first release cycle

**Summary:** P0: 12 screens (first release). P1: 12 screens (fast follow). P2: 6 screens (V2).

---

## 12. Data Dependencies

The UI depends on these data layer components (defined in `learning-model-design.md`):

| Data Component | UI Consumer |
|----------------|------------|
| `WordState` (box_level, due_at, memory_status, lapse_count) | Stats tab, review badges, Words Fighting Back list |
| `SessionState` (step_index, item_index, is_paused, session_type) | Resume card, Practice tab state |
| `DayState` (morning_complete, evening_complete, morning_complete_at) | Practice tab state, Map node dots, evening lock timer |
| `RecoveryState` (recovery_type, is_recovery_needed) | Practice tab F1/F2/F3 states |
| `ReviewQueue` (priority-sorted due words by box then memory_status) | Image game review words, quick recall, review count badge |
| `BoxTransitionLog` (promotions, demotions today) | Session complete screen |
| `DailyStats` (new_count, review_count, accuracy, xp) | Practice tab summary, report card |
| `StreakStore` (current_streak, last_study_date) | Header badges, Stats tab, report card |
| `ReviewLog` (word_id, outcome, superseded flag) | Restart semantics, analytics |
| Evening unlock rule (hardcoded: 4hr gap OR 5 PM) | Lock timer (no UI setting in V1) |

---

## 13. Global Edge Cases

These are production scenarios that apply across multiple screens.

### First Launch (No Progress)

- Practice tab: State A with Day 1 selected, streak = 0, XP = 0
- Map: Zone 1 unlocked, Day 1 as "current" (gold ⭐), Days 2-4 available but dim, Zones 2-5 locked
- Stats: all zeros, empty mastery bar, no Words Fighting Back, no weekly calendar history
- Profile: name defaults to "Student" (editable)
- No onboarding tutorial in V1 — the app is self-explanatory

### Notification Permission Denied

- If student denies notification permission when toggling reminders:
  - Show brief explanation: "Reminders help you stay on track. You can enable them in Settings."
  - Toggle stays off, no retry prompt
  - App works fully without notifications — they are convenience only

### Report Sharing Before Any Session

- Profile "Share Today's Progress" button: if no session completed today, generate a report showing overall progress instead of daily stats
- Never show an empty or broken report card

### Timezone / Cross-Midnight Behavior

- Study day boundary: midnight local time
- If a session starts at 11:50 PM and finishes at 12:10 AM: counts as the day it started on
- Evening unlock timer: based on elapsed real time since morning completion, not clock labels
- Streak: counts study days (days with at least one session completed), not calendar days
- If device clock changes (travel, manual change): freeze new-word unlocks until pending session completes

### No Internet

- App is fully offline (all data in bundled SQLite + local images)
- Share Report uses iOS share sheet which works offline (student can share when back online)
- No network-dependent features in V1

---

## 14. Gap Resolutions

Issues identified in the final gap audit and resolved here.

### 14.1 Recovery Session Structures

**Recovery Evening (F1):**

| Step | Activity | Items |
|------|----------|-------|
| 1 | Quick recall of yesterday's morning words | up to 11 |
| 2 | Image-to-word game (yesterday's words + overdue reviews) | 10 |

**Catch-Up Day (F2):**

| Step | Activity | Items |
|------|----------|-------|
| 1 | Flashcard exposure (missed words) | up to 11 |
| 2 | Image-to-word game (missed + overdue) | 10 |
| 3 | Quick recall | 8 |

**Re-entry Day (F3):**

| Step | Activity | Items |
|------|----------|-------|
| 1 | Quick recall (diagnostic — sample from all learned words) | 15 |
| 2 | Image-to-word game (words recalled incorrectly) | 10 |

### 14.2 Back-Pressure Day Session Structure (State G)

Single session, review only:

| Step | Activity | Items |
|------|----------|-------|
| 1 | Quick recall (Box 1 words first, then Box 2) | 15 |
| 2 | Image-to-word game (same words) | 12 |
| 3 | SAT questions (from reviewed words) | 3 |

### 14.3 Bonus Practice (State E)

Deferred from V1 first release. In State E, the "PRACTICE MORE" button is **hidden in P0**. It appears only when BonusPracticeView is built (P1). Until then, State E shows the summary + share button only.

### 14.4 Days 19-20 Session Structures

**Day 19 — Weak Word Blitz (morning):**

| Step | Activity | Items |
|------|----------|-------|
| 1 | Flashcard exposure (Box 1-2 words, weakest first) | 15 |
| 2 | Image-to-word game (same words) | 12 |
| 3 | SAT questions (same words) | 5 |

**Day 19 — Evening:** Same structure, next 15 weakest words.

**Day 20 — Final Assessment (morning):**

| Step | Activity | Items |
|------|----------|-------|
| 1 | SAT-style comprehensive test (all zones) | 30 |

**Day 20 — Evening:** Results review screen. No session — just final stats display with Share Final Report.

### 14.5 Zone Test Remediation Day

When a student fails the zone test 3+ times, the next study day uses **State G (Review-Only Day)** with its banner text changed to: "Let's strengthen these zone words before retesting." After completing the review session, the zone test becomes available again.

### 14.6 Map Day Tap Behavior

| Node State | Tap Action |
|------------|-----------|
| Current day (active) | Switch to Practice tab |
| Past day (completed) | Show read-only day summary: "Day X ✓ · 21 words · 83%" (no action) |
| Future day (unlocked but not yet reached) | Disabled — subtle bounce animation, no navigation |
| Future day (locked) | Disabled — no response |
| Zone test node | Navigate to zone test (if available) |

### 14.7 Evening Unlock Timing Matrix

| Morning Completed At | Evening Unlocks At | State H? | Notes |
|---------------------|-------------------|----------|-------|
| Before 1:00 PM | 5:00 PM (fallback wins) | No | Normal flow |
| 1:00 – 5:00 PM | 5:00 PM (fallback wins) | No | Normal flow |
| 5:00 – 7:59 PM | Morning + 4 hours | No | Evening available same night |
| 8:00 PM or later | Next day morning | Yes (State H) | No evening expected tonight |
| Cross midnight | Counts as the day it started | No | Session stays on original day |

### 14.8 Distractor Selection Rules

**Quick Recall (4 definition choices):**
1. Correct definition = the word's actual definition
2. Distractor 1 = definition of a word from the same zone
3. Distractor 2 = definition of a word with the same part of speech
4. Distractor 3 = definition of a random word from any zone
5. Shuffle all 4 positions randomly

**Image-to-Word Game (4 word choices):**
1. Correct word = the target word
2. Distractor 1 = word from same zone, same part of speech
3. Distractor 2 = word from same zone, different part of speech
4. Distractor 3 = random word from any zone
5. Shuffle all 4 positions randomly
6. Never repeat a distractor set for the same target word within a session

### 14.9 V1 P0 Scope Clarification

Features that appear in V1 flows but are NOT in P0 first release. These should be hidden/omitted, not half-built:

| Feature | Priority | P0 Fallback |
|---------|----------|-------------|
| Recovery modes (F1/F2/F3) | P1 | If recovery is needed, show generic "Welcome back" banner + start normal morning session (no special recovery flow) |
| Back-pressure (State G) | P1 | Never triggered in P0 — all days have full new words |
| Late Night (State H) | P2 | No special handling — normal morning session starts |
| Rush detection toast | P2 | Not shown — all answers count |
| Bonus practice | P1 | Button hidden in State E |
| Step transition screen | P1 | Skip directly to next step |
| Zone test remediation | P1 | Unlimited retries (no remediation flow) |

The Practice tab state resolver in P0 only needs: **A, B, C, D, E** (5 states). F1/F2/F3, G, H added in P1/P2.

---

## 15. What Is NOT in V1

Explicitly out of scope:

- Dark mode (architect for, don't implement)
- Automatic push notifications to parent (V2 — requires backend)
- Weekly email digest (V2)
- Parent email input + auto-send (V2)
- Customizable evening unlock time picker (V1 uses simple toggle)
- Word pronunciation audio files (use AVFoundation text-to-speech)
- Social features (leaderboards, friend challenges)
- Cloud sync between devices
- Onboarding tutorial (just start)
- Customizable daily word count
- Broad AI-generated explanations (use pre-built SAT context)
- App Store submission (TestFlight first)

**V2 candidates to explore:**
- AI assist for stubborn words: on-demand only, available after a word becomes `stubborn`, limited to 2-3 structured modes ("give me a memory trick," "compare confusing words," "explain like a SAT tutor")
- Automatic daily report to parent email
- Dark mode
- Post-program 7-day and 30-day retention probes

---

## 14. Codex Release Review Notes (April 11, 2026)

This appendix is a final release-stage review pass after the major Codex fixes were applied. The goal is not to reopen the full design, but to flag the remaining issues that are still worth reviewing before implementation starts.

### Remaining Product Suggestions

1. **Align the "Words Fighting Back" interaction with implementation priority.**
  - The Stats tab positions "Words Fighting Back" as a meaningful, tappable feature.
  - But `WordDetailView` is still listed as **P2** in the screens inventory.
  - Recommendation: either raise `WordDetailView` to at least **P1** for the first release, or make the list non-tappable in V1 and treat it as informational only.

2. **Reduce the parent-forward feeling inside the student's main reward loop.**
  - The current flow offers "Share Today's Progress" at emotionally important moments, especially after session completion.
  - For some high school students, that may make the product feel supervised instead of self-driven.
  - Recommendation: consider softer V1 wording such as **"Share Today's Progress"** or make the parent framing secondary in the UI while keeping the same underlying feature.

3. **Keep evening unlock controls as simple as possible.**
  - The current toggle is much better than a full time picker, but it still exposes scheduler logic that many students may not need to manage.
  - Recommendation: keep the default smart path strong. If implementation gets tight, it is acceptable to ship with one default mode and defer alternate unlock behavior.

4. **Treat the 30-screen inventory as a release-planning warning, not just a design count.**
  - The structure is now much clearer, but V1 still spans 30 screens and 10 Practice-tab states.
  - Recommendation: be strict about what is truly needed for the first usable ship. P0 should focus on daily completion, recovery, scoring clarity, and report sharing. Anything that does not improve those loops can stay behind P1/P2.

### Marketing / Audience Fit Notes

1. **The visual direction is now much more attractive for SAT students than the earlier drafts.**
  - The product feels cleaner, more intentional, and less like a kids app.
  - The current voice direction, especially "smart friend + sharp SAT coach," is a good fit for ages 15-18.

2. **The UI should communicate SAT payoff even more explicitly.**
  - Right now the product communicates consistency and practice well.
  - It is slightly weaker at communicating the direct payoff to SAT Reading/Writing performance.
  - Recommendation: add one persistent SAT-value cue on a core screen, such as "Reading & Writing score builder," "Real SAT-style practice every day," or "Common SAT trap words."

3. **Keep humor sharp, not childish.**
  - The stronger direction is quick, witty, lightly competitive microcopy.
  - Recommendation: prefer lines that feel like a smart study buddy. Avoid anything that sounds too cute, too mascot-like, or too young.

4. **The narrow AI idea is a strong future differentiator.**
  - The current V2 direction is well-scoped: only for words that become `stubborn`, and only through a few structured help modes.
  - From a product and marketing perspective, this is stronger than adding broad AI chat because it feels useful, specific, and believable.

### Short Release Verdict

This spec looks strong enough to move into implementation planning for a first release. The biggest remaining questions are not about core learning-model alignment anymore. They are about scope discipline, teen ownership vs parent visibility, and making the SAT outcome feel slightly more obvious in the everyday UI.

## Copilot Review (20260412-012104)

### What Looks Good
- The core learning loop is clear: daily hub -> session steps -> completion -> recovery, with good alignment to spaced repetition behavior.
- The design system, button patterns, and microcopy give developers strong SwiftUI direction without over-constraining implementation.
- The spec does a good job translating learning-model concepts into user-facing states, especially pause/resume, recovery, and review pressure.

### Issues Found
1. **Report sharing is inconsistent.** Section 4.8 shows a share button on the generic Session Complete screen, but Section 8.2 says reports are offered only after the evening session, when both sessions are done, or from Profile. **Why it matters:** developers cannot tell whether morning-only completion should show sharing, and students may get prompted too often. **Suggested fix:** define separate morning-complete vs full-day-complete variants and explicitly hide or disable sharing after morning-only completion.
2. **Evening unlock is defined three different ways.** Section 7.2 says the control is removed and behavior is hardcoded, Section 12 still lists `Evening unlock mode (UserDefaults)`, and Section 13 says V1 uses a simple toggle. **Why it matters:** this changes UI, state, and QA scope. **Suggested fix:** pick one V1 rule and update Profile, Data Dependencies, and Out-of-Scope so they all match.
3. **Practice-state precedence is missing.** The spec defines overlapping conditions (paused session, F1/F2/F3 recovery, back-pressure, late-night, zone test availability) but not the resolver order. **Why it matters:** different developers could implement different state selection logic. **Suggested fix:** add a single priority table or pseudocode for how the Practice tab chooses its state.
4. **V1 vs later scope is still blurry.** The doc calls itself the complete V1 spec, but the screen inventory mixes P0/P1/P2 items while Section 13 separately defines what is not in V1. **Why it matters:** release planning and implementation estimates are still ambiguous. **Suggested fix:** split the inventory into "Must ship in V1" and "Post-V1," or explicitly state that P1/P2 are not part of the first release.
5. **Some mobile edge cases are still uncovered.** Missing or unclear cases include first launch with no progress, sharing before any session is complete, notification permission denied, and timezone/cross-midnight behavior for locks, streaks, and resumes. **Why it matters:** these are common production scenarios and will otherwise be guessed during implementation. **Suggested fix:** add a short global edge-cases subsection covering empty states, permission-denied flows, and study-day boundary rules.

### Suggestions
- Keep parent-facing sharing secondary in student reward moments so the app feels student-owned first.
- Add one persistent SAT-payoff cue on a core screen to reinforce score relevance, not just streak and XP.

## Cross-Check Review — gpt-5.4 (20260411-213621)

### What Looks Good
- The spec has a strong core loop: Practice states, in-session steps, pause/resume, and recovery all connect cleanly.
- The design system and microcopy are specific enough for SwiftUI implementation while still feeling right for 15-18 year olds.
- Data dependencies and screen inventory make the document much closer to build-ready than a typical product spec.

### Issues Found
1. **V1 scope is still not operationally clear.** Core flows reference surfaces marked P1/P2, including `ProfileView`, `ParentReportCardView`, `RecoveryBanner/Card`, `RushDetectionToast`, and `BonusPracticeView`. **Why it matters:** engineering and QA still have to guess what the first shippable build includes. **Suggested fix:** promote every feature that appears in a V1 happy path to P0/P1, or remove those affordances from V1 states and document the fallback UX.
2. **Map day selection is ambiguous.** The map allows any unlocked day node to open Practice "with that day selected," and first launch says Days 2-4 are available, but Practice only defines the current active day flow. **Why it matters:** developers could accidentally enable skipping ahead or replaying days in a way that breaks the spacing model. **Suggested fix:** explicitly define tap behavior for past, current, and future day nodes: preview-only, summary-only, disabled, or actionable.
3. **Late-day timing behavior is underspecified.** The unlock rule is "4-hour gap OR after 5 PM," while State H only special-cases starts after 8 PM, and the late-night rule says review is due tomorrow even though the next day "starts fresh." **Why it matters:** this is the core learning loop, and unclear timing will create inconsistent spacing and confusing lock states. **Suggested fix:** add a timing matrix for morning completion bands (before 1 PM, 1-5 PM, 5-8 PM, after 8 PM, cross-midnight) and say exactly when the deferred review appears.
4. **Share/report naming and ownership are inconsistent.** The doc alternates between "Share Today's Progress" and "Share Today's Progress," and parent-report CTAs appear in high-reward moments. **Why it matters:** inconsistent labels slow implementation, and too much parent framing can make the app feel supervised instead of self-driven. **Suggested fix:** choose one label everywhere and keep student celebration primary; parent framing can live inside the share sheet/report card.

### Suggestions
- Add a one-time inline explainer for the first evening lock or recovery day so "let it marinate" feels intentional, not arbitrary.
- Consider a tiny persistent SAT-payoff cue on the Practice header or completion screen.
