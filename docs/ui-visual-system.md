# UI Visual System — Final Design Reference

This document defines the final visual treatment for all activity views and the reward/points UI. It overrides any conflicting visual details in earlier docs.

---

## 1. Visual Foundation

### Color System

| Token | Hex | Usage |
|-------|-----|-------|
| **App chrome** | #101826 | Status bar area, tab bar background, glass headers |
| **Card surface** | #FFFFFF | Content cards, answer buttons, definition areas |
| **Page background** | #F5F6FA | Behind cards (light gray, not pure white) |
| **Primary green** | #58CC02 | Correct, progress, CTA, game accent |
| **Green pressed** | #58A700 | 3D button border-bottom |
| **Purple** | #CE82FF | Quick recall accent |
| **Orange** | #FF9600 | SAT question accent, streaks |
| **Gold** | #FFC800 | XP, word highlight, flashcard accent |
| **Red** | #FF4B4B | Wrong answer |
| **Blue** | #1CB0F6 | Selected option |
| **Text primary** | #1A1A2E | Dark text on white cards |
| **Text secondary** | #6B7280 | Subtitles, labels |
| **Text on dark** | #F4F8FF | White text on dark chrome |
| **Border** | #E8ECF0 | Card borders (softer than #E5E5E5) |

### Typography Scale (actual iPhone pt sizes)

These are SwiftUI point sizes, not CSS pixels. All sizes tested at iPhone Pro Max (430pt) and SE (375pt).

| Role | Size | Weight | Usage |
|------|------|--------|-------|
| **Hero word** | 28pt | Black (900) | Word on flashcard front |
| **Section title** | 22pt | Bold (700) | Screen titles, word on card back |
| **Body large** | 17pt | Semibold (600) | Sentence text, answer options |
| **Body** | 15pt | Regular (400) | Definitions, descriptions |
| **Label** | 13pt | Semibold (600) | Step labels, progress counts |
| **Caption** | 11pt | Medium (500) | Hint text, badges, section headers |
| **Micro** | 9pt | Semibold (600) | "tap to flip" hints only |

**Minimum readable size on iPhone:** 11pt. Nothing in the UI should be smaller.

### Depth & Shadow

| Element | Shadow |
|---------|--------|
| Cards (answer buttons, content) | `0 2px 8px rgba(0,0,0,0.06)` |
| Floating panels (feedback sheet) | `0 8px 24px rgba(0,0,0,0.16)` |
| Glass headers | `backdrop-filter: blur(10px)`, `rgba(16,24,38,0.85)` |
| 3D buttons | `border-bottom: 4px solid [pressed-color]` |
| Active/pressed button | translate Y +2px, border-bottom shrinks to 2px |

### Corner Radius

| Element | Radius |
|---------|--------|
| iPhone screen | 44pt (matches hardware) |
| Content cards | 16pt |
| Answer buttons | 14pt |
| Progress bar | 6pt |
| Badges/pills | 999pt (full round) |
| Glass header buttons | 12pt |

---

## 2. Activity View Visual Specs

### 2.1 Shared Session Header (Glass Style)

```
┌─────── Dark glass bar (blur 10px) ──────┐
│ [✕]     STEP 2 OF 3 · 📊 SCORED   [🔊] │
│         Image Practice · 5/12            │
│ [═══════════════░░░░░░░░░░░░░░░░]        │  ← Gradient-filled progress bar
│                                          │
│        ⚡ 280 XP    🔥 5    ○○○●○ 250    │  ← Persistent reward cluster
└──────────────────────────────────────────┘
```

**Persistent reward cluster** (always visible during scored steps):
- ⚡ XP counter (gold, weight 800)
- 🔥 Streak flame (orange)
- Daily goal progress dots (5 dots, each = 50 XP, filled = green)

**NOT shown during flashcards** — flashcards show only ✕, progress count, 🔊.

### 2.2 Flashcard (Gold Accent)

**Front:**
- Image fills entire view
- Bottom gradient: builds from transparent to `rgba(16,24,38,0.88)` (dark navy, not pure black)
- Sentence: 17pt, weight 500, white 90%
- Word in sentence: 22pt, weight 900, #FFC800 gold, underlined
- Glass header: ✕ + "2/11" + 🔊 on dark blur
- "tap to flip" hint: 9pt, white 40%, bottom center

**Back:**
- White card surface (#FFFFFF) with 16pt corner radius
- Image thumbnail (56pt, rounded 14pt) + word (22pt gold) at top
- Content sections: Definition (17pt semibold), Example (15pt, gold left border on #FFFBEB), Collocations (13pt pills on #FFF8E1), SAT Context (15pt, #6B7280)
- Buttons at bottom: "SHOW AGAIN" (outlined) / "GOT IT →" (green 3D)
- "Word unlocked" stamp on first-time "Got It" (subtle gold shimmer, 1s fade)

### 2.3 Image-to-Word Game (Green Accent)

- Header: green progress bar, reward cluster visible
- Image area: 45-50% height, rounded 16pt, gradient caption overlay
- Cloze sentence: white card, 15pt text, gold blank underline
- 2×2 answer grid: white cards, 17pt bold, 3D border-bottom 4px #E8ECF0
  - Press: card depresses 2pt (120ms)
  - Correct: green border bloom (220ms), "+10 XP" chip arcs to header counter (600ms), haptic tick
  - Wrong: red flash, correct card pulses green, 2.5s hold

### 2.4 Quick Recall (Purple Accent)

- Header: purple progress bar, reward cluster visible
- White card surface
- Word: 28pt, weight 900, #1A1A2E, centered
- "from this morning": 13pt, #CE82FF
- 4 definition choices: white cards, 15pt, full-width, vertical stack, gap 10pt
  - Same press/correct/wrong behavior as image game
  - Faster pace: correct auto-advance 1s, wrong 2s

### 2.5 SAT Question (Orange Accent)

- Header: orange progress bar, reward cluster visible
- Passage area: warm cream card (#FFFBEB), border 1px #FFE082, rounded 16pt
  - **Serif font** for passage text: Georgia or system serif, 15pt
  - Target word: bold + yellow highlight gradient
  - "📖 PASSAGE" label: 11pt caption, #FF9600
- Question area: white card surface
  - Question text: 15pt semibold, #1A1A2E
  - A/B/C/D options: white cards, letter circle (22pt, border 2px), answer text 15pt
  - Selected: blue circle fill + blue text
- CHECK button: green 3D when selected, gray 3D when not
- Feedback bottom sheet: springs up (not plain slide), rounded 20pt top, 50% height
  - "✓ Correct!" or "✗ Not quite." as verdict header
  - Word + meaning + explanation below

---

## 3. Reward Visuals

### 3.1 +10 XP Chip

- Small pill: green background (#58CC02), white text "+10", weight 800, 11pt
- Animation: chip appears at correct answer card → arcs upward in a curve → lands on XP counter in header → counter increments with scale pulse (1.1x → 1.0x, 300ms)
- Duration: ~600ms total
- Not shown on wrong answers or flashcards

### 3.2 Combo Callout

| Streak | Text | Visual |
|--------|------|--------|
| 3 correct | "On a roll." | 13pt semibold, white on dark pill, top center, fades 1.5s |
| 5 correct | "Unstoppable." | Same + subtle green glow behind text |
| 10 correct | "Perfect run." | Same + progress bar sparkle animation |

### 3.3 Streak Flame

- Always in header reward cluster
- Static: orange flame emoji + number (15pt bold)
- At milestones (3/7/14/30): flame glows brighter for 2s

### 3.4 Daily Goal Ring

- 5 dots in header: each = 50 XP (target: 250 XP ⚙️)
- Empty: #3A3F4E (dark gray)
- Filled: #58CC02 (green) with subtle glow
- When target hit: all dots pulse green once, "Daily goal ✓" toast

### 3.5 Word Strength Meter

5-segment horizontal bar, shown briefly when a word levels up:

```
[🔴 Locked In][🟠 Rising][🟡 Strong][🟢 Solid][✅ Mastered]
```

- Each segment is proportional width
- Active segment glows with its color
- When word levels up: bar appears above the answer card for 1.5s, new segment fills with color bloom animation

### 3.6 Word Mastery Moment

When a word reaches Mastered (Box 5):
- Gold ring expands around the word (500ms)
- Brief confetti burst (8-10 gold particles)
- Toast: "EPHEMERAL — mastered." (15pt, gold, 2s)
- Haptic: success pattern

---

## 4. Decisions from Codex Review

| Suggestion | Decision | Rationale |
|-----------|----------|-----------|
| Dark navy base (#101826) | ✅ Accept for chrome/headers | Premium feel, but keep white cards for readability |
| Accent glows per activity | ✅ Accept | Visual identity per mode |
| Glass header + blur | ✅ Accept | Modern iOS feel |
| Persistent reward cluster | ✅ Accept | XP + streak + daily goal always visible during scored steps |
| Serif font for SAT passages | ✅ Accept | Distinguishes academic content visually |
| +10 XP arc animation | ✅ Accept | Strong dopamine hit, connects answer to reward |
| Image parallax on flashcards | ❌ Deny | Complexity without clear benefit. V2 candidate. |
| Badge cabinet / level titles | ❌ Deny | Scope creep. Streak + XP + Word Strength is enough for V1. |
| "You beat yesterday" weekly card | ❌ Deny for V1 | Nice but P2. Not needed for core loop. |
| XP multipliers | ❌ Deny | Would muddy the clean "+10 per correct" rule |
| Word Strength over Box numbers | ✅ Accept | Already applied throughout |
| Combo callouts visual-only (no bonus XP) | ✅ Accept | Keeps simple rule clean |

---

## 5. iPhone Sizing Summary

| Element | Pro Max (430pt) | SE (375pt) |
|---------|----------------|------------|
| Sentence on flashcard | 17pt | 15pt |
| Word highlight | 22pt | 18pt |
| Answer option text | 17pt | 15pt |
| Definition text | 17pt | 15pt |
| SAT passage text | 15pt (serif) | 13pt (serif) |
| Section labels | 13pt | 11pt |
| XP counter | 15pt | 13pt |
| Buttons text | 15pt | 13pt |
| Minimum text size | 11pt | 11pt |
