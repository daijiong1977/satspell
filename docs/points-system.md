# Points & Progression System

This document defines the XP (experience points) system and box progression model. These are two independent systems that work together.

---

## 1. The Simple Rule

**Correct answer in a scored activity = +10 XP. Everything else = 0 XP. No penalties. No deductions. Ever.**

XP measures effort and practice, not perfection. A student who gets 50% right still earns ~200 XP/day.

---

## 2. What Earns XP

| Activity | Correct Answer | Wrong Answer | Rushed (<1s) |
|----------|---------------|-------------|-------------|
| Image-to-Word Game | **+10 XP** | 0 XP | 0 XP |
| Quick Recall | **+10 XP** | 0 XP | 0 XP |
| SAT Question | **+10 XP** | 0 XP | 0 XP (if <3s) |
| Bonus Practice | **+5 XP** (half) | 0 XP | 0 XP |

## 3. What Does NOT Earn XP

| Activity | XP | Why |
|----------|-----|-----|
| Flashcards | 0 | Exposure only — not scored |
| Show Again / Got It | 0 | Soft signal for session ordering |
| Flipping a card | 0 | Reading, not recall |
| Viewing stats or map | 0 | Not a learning activity |

---

## 4. Scored vs Exposure Activities

### The 4 Activity Types

| # | Activity | Type | Earns XP? | Affects Box? | Color |
|---|----------|------|-----------|-------------|-------|
| 1 | **Flashcard** | 👁️ Exposure | No | No | — |
| 2 | **Image-to-Word Game** | 📊 Scored | Yes (+10) | Yes | Green |
| 3 | **Quick Recall** | 📊 Scored | Yes (+10) | Yes | Purple |
| 4 | **SAT Question** | 📊 Scored | Yes (+10) | Yes | Orange |

### How Each Activity Works

**1. Flashcard (👁️ Exposure)**
- Student sees: mnemonic image filling the screen + example sentence with gold-highlighted word
- Interaction: tap to flip (front: image + sentence, back: definition + collocations + SAT context)
- Buttons on back: "Show Again" (re-queue) / "Got It" (next card)
- No scoring, no XP, no box changes
- Purpose: first exposure to the word — encoding, not testing

**2. Image-to-Word Game (📊 Scored)**
- Student sees: mnemonic image + cloze sentence with blank + 2×2 word choice grid
- Interaction: tap one of 4 words to fill the blank
- Correct: card turns green, "+10 XP" floats, auto-advance 1.5s
- Wrong: card turns red, correct answer highlighted, auto-advance 2.5s
- No retry — wrong is wrong, word comes back in future reviews
- This is a primary scored event for Day 1 box promotion

**3. Quick Recall (📊 Scored)**
- Student sees: the word in large text + "from this morning" label + 4 definition choices
- Interaction: tap the correct definition
- Correct: card flashes green, auto-advance 1s (fast-paced)
- Wrong: card flashes red, correct highlighted, auto-advance 2s
- Evening only — tests words learned that morning
- This is a primary scored event for Day 1 box promotion

**4. SAT Question (📊 Scored)**
- Student sees: SAT passage excerpt (top, scrollable) + vocabulary question (bottom, fixed) + A/B/C/D choices
- Interaction: tap an answer, then tap CHECK
- Correct: green verdict + explanation in bottom sheet
- Wrong: red verdict + correct answer + explanation
- Mirrors actual SAT Reading & Writing format

---

## 5. Daily XP Breakdown

### Morning Session (~16 min)

| Step | Activity | Items | Max XP |
|------|----------|-------|--------|
| 1 | Flashcards (exposure) | 11 | 0 |
| 2 | Image-to-Word Game | 12 rounds | 120 |
| 3 | SAT Questions | 3 | 30 |
| **Total** | | | **150 XP** |

### Evening Session (~17 min)

| Step | Activity | Items | Max XP |
|------|----------|-------|--------|
| 1 | Flashcards (exposure) | 10 | 0 |
| 2 | Quick Recall | 11 words | 110 |
| 3 | Image-to-Word Game | 12 rounds | 120 |
| 4 | SAT Questions | 2 | 20 |
| **Total** | | | **250 XP** |

### Daily Totals

| Scenario | XP/Day |
|----------|--------|
| Perfect day (100% correct) | 400 XP |
| Good day (80% correct) | ~320 XP |
| Average day (60% correct) | ~240 XP |
| 20-day program total (80%) | ~6,400 XP |

---

## 6. Box Progression (Independent from XP)

XP = effort reward (how much you practiced).
Boxes = learning progress (how well you remember).

They are **independent**. A student can earn lots of XP while still having words in Box 1 (they practiced a lot but some words are stubborn).

### The 5 Boxes

| Box | Student-Facing Name | Review Interval | Color | Internal Label |
|-----|---------------------|----------------|-------|----------------|
| 1 | Locked In | 1 day | Red #FF7043 | struggling |
| 2 | Rising | 3 days | Orange #FFAB40 | learning |
| 3 | Strong | 7 days | Gold #FFC800 | familiar |
| 4 | Solid | 14 days | Light green #89E219 | strong |
| 5 | Mastered | No review | Green #58CC02 | mastered |

**Student sees:** "Locked In → Rising → Strong → Solid → Mastered" with a 5-segment strength meter.
**Code uses:** internal labels (struggling, learning, familiar, strong, mastered) — unchanged from learning model.

### How Words Move Between Boxes

**Moving UP (correct answer in a scored activity):**
- Each correct answer in Image Game, Quick Recall, or SAT Question → word moves up one box
- A word needs 4 correct answers across ~25 days to reach Box 5 (mastered)

**Moving DOWN (wrong answer):**
- Any wrong answer → word goes back to **Box 1** (not down by one — full reset)
- This is the Leitner standard: harsh but effective for retention

**Day 1 Promotion (new words):**
- New words start at Box 0 (not yet in system)
- After Day 1's 3 scored events (morning game + evening recall + evening game):
  - 2/3 correct AND correct final recall → **Box 2** (review in 3 days)
  - Otherwise → **Box 1** (review tomorrow)
- If evening session is missed → words enter Box 1 (no acceleration)

### Word Strength Meter (Student-Facing)

Students never see "Box 1" or "Box 4." Instead they see a **Word Strength** meter with 5 segments:

```
[Locked In] → [Rising] → [Strong] → [Solid] → [Mastered]
     🔴           🟠         🟡         🟢         ✅
```

- Each segment fills when the word moves up a box
- "1 more win to level up this word" messaging
- When a word reaches Mastered: gold ring animation + "Mastered ✓" stamp

### Box Progression Does NOT Affect XP

- Getting a word to Mastered doesn't earn bonus XP (but shows a celebration)
- Having words in Locked In doesn't lose XP
- XP is purely: correct answers × 10

---

## 7. Reward Layers (Dopamine Hits)

The base system (+10 XP per correct) is the foundation. These layers add motivation without complicating the core rule.

### 7.1 Daily XP Target

- Default target: **250 XP/day** ⚙️ (achievable at ~63% accuracy)
- Shown as a progress ring on the Practice tab header
- Hitting the target: brief celebration pulse + "Daily goal reached ✓"
- Missing the target: no penalty, no messaging — just an unfilled ring

### 7.2 Combo Streaks (within a session)

Consecutive correct answers trigger combo callouts:

| Streak | Callout | Visual |
|--------|---------|--------|
| 3 correct | "On a roll." | Small text toast |
| 5 correct | "Unstoppable." | Larger toast + subtle screen glow |
| 10 correct | "Perfect run." | Toast + progress bar sparkle |

- Combos reset on wrong answer
- Combos are visual only — no bonus XP (keeps the simple rule)

### 7.3 Session-Complete Bonus

- Completing a full session (all steps): **+30 XP bonus** ⚙️
- Shown on Session Complete screen: "Session bonus: +30 XP"
- This rewards completion, not just accuracy

### 7.4 Streak Bonuses

| Streak | Bonus | Visual |
|--------|-------|--------|
| 3-day streak | +20 XP one-time | Small flame grows |
| 7-day streak | +50 XP one-time | Flame gets brighter |
| 14-day streak | +100 XP one-time | Flame turns gold |
| 30-day streak | +200 XP one-time | Special badge earned |

- Streak = consecutive days with both sessions completed
- Streak bonus is one-time per milestone (not recurring)
- Streak flame visible in header badges throughout the app

### 7.5 Word Mastery Moment

When a word reaches "Mastered" (Box 5):
- Gold ring animation around the word
- Brief confetti burst
- "Mastered ✓" stamp
- Toast: "EPHEMERAL — mastered. That word is yours now."
- This happens during any scored activity where the final correct answer triggers Box 5

### 7.6 Zone Completion Celebration

When all zone words reach "Strong" or above (Box 3+):
- Zone trophy animation
- "Zone 1: Foundation — complete! 🏆"
- All zone trophies visible on the Map tab

### 7.7 Flashcard "Word Unlocked" (Non-XP Reward)

Even though flashcards earn 0 XP, they should still feel rewarding:
- When student taps "Got It" on a new word for the first time: subtle "Word unlocked" stamp appears briefly
- This gives flashcards their own reward moment without breaking the "0 XP for exposure" rule

---

## 8. What Students See

### During Sessions
- Header shows: "📊 +10 XP PER CORRECT" on scored steps
- Header shows: "👁️ EXPOSURE" on flashcard step
- After correct answer: "+10" chip arcs from answer card into the XP counter in header (~600ms animation)
- After wrong answer: no XP animation (but no penalty messaging either)
- Combo callouts at 3/5/10 correct streak
- Word strength meter briefly shown when a word levels up

### On Practice Tab (after both sessions)
- Today's summary: "21 NEW | 14 REVIEWED | 83% ACCURACY | +350 XP"
- XP badge always visible in header: "⚡ 1,250"

### On Stats Tab
- Total XP with flame icon
- No XP breakdown by activity (keep it simple)

### In Parent Report
- Daily XP total
- Accuracy percentage (more meaningful than raw XP)

---

## 9. Why This System Works

1. **Simple:** One rule. +10 per correct. That's it.
2. **No punishment:** Wrong answers earn 0, not negative. Students aren't afraid to try.
3. **Effort-based:** Even struggling students earn XP every session. Motivation maintained.
4. **Separate concerns:** XP motivates daily practice. Boxes track actual learning. Neither interferes with the other.
5. **Transparent:** Student always knows exactly what earns points and what doesn't.

---

## Codex Review

1. **Clarity:** The public rule is strong: **+10 XP per correct** is explainable in 5 seconds. The confusing part is boxes. "Box 0/1/2," "2/3 correct + final recall," and "wrong answer resets to Box 1" are not teen-friendly mental models. Keep boxes internal. In student UI, translate them into a single **Word Strength** meter with 5 states and copy like "1 more win to level up this word." Never ask the student to reason about XP and boxes at the same time.

2. **Motivation:** The no-penalty rule is good, but the reward loop is too flat. Right now the main dopamine hit is a floating **+10**. Add layered rewards without breaking the simple system: a visible daily target (for example **250 XP**), a session-complete bonus (**+30**), streak bonuses at **3/7/14 days**, and a mastery bonus when a word reaches the top state. Also protect habit formation: "miss evening -> Box 1" is okay as backend logic, but the UX needs a comeback mechanic like a streak freeze or next-morning make-up window.

3. **UI quality:** The mockups feel raw mostly because of typography and motion. Too much **7-10px uppercase utility text** makes the app feel like a wireframe. Raise utility text to **11-12pt**, key labels to **15-17pt**, and use one cleaner type ramp across all 4 views. Give every activity a premium shell: deep navy base (**#101826**), accent glows by mode (green/purple/orange/gold), **16pt** corners, a soft shadow (`0 8 24 rgba(0,0,0,.16)`), and a glass header with **10px blur**. Interactions should feel alive: answer cards depress **2pt** on touch (**120ms**), correct answers trigger a **220ms** color bloom plus haptic tick, and the **+10 XP** chip should arc into the header counter in ~**600ms**. For SAT, use a serif passage font, a paper-like card surface, and a springy bottom-sheet reveal instead of a plain slide-up.

4. **Engagement:** There are not enough celebration beats. Add combo callouts at **3/5/10 correct**, a progress bar sparkle when a milestone hits, a session-end recap card ("12 correct · 90 XP · 2 words leveled up"), and a rare mastery moment (gold ring, confetti burst, "Mastered"). Flashcards should still feel rewarding even at **0 XP**: add a richer flip shadow, subtle image parallax, and a small "Word unlocked" stamp when the student taps **Got It**.

5. **Teen appeal:** The foundation is good, but the tone is still a little academic. "Locked In / Rising / Strong" sounds like school software; "Locked In / Rising / Strong / Mastered" feels more aspirational. What's missing is identity and status: streak flame, level title, badge cabinet, zone trophies, and a weekly "you beat yesterday" card. Teens do not need childish mascots, but they do need the app to feel sharp, energetic, and worth opening twice a day.

---

## Copilot Review — Mockup Pass

The system is much stronger once the rewards are treated as a **visible layer**, not just backend math. Three changes would make the product feel more premium and easier for a student to follow.

1. **Keep one reward cluster persistent across scored views:** XP total, daily goal progress, and streak flame should always live in the same top header zone. Right now the rules are simple, but the rewards risk feeling scattered. A stable reward cluster makes the app feel more polished and helps teens connect one answer to long-term progress.

2. **Make Word Strength the only student-facing progression language:** the docs are already moving in the right direction. Go all the way. Never show "Box 1," "reset," or "demoted" in the UI. Use language like "Needs one more win" or "Back to Locked In" so progression feels understandable instead of punitive.

3. **Be selective about bonus moments:** session-complete bonus, streak milestones, combo callouts, and mastery celebration are enough. That is the right amount of dopamine. Do **not** add extra XP multipliers on top of those, or the clean mental model (+10 per correct) will get muddy fast.

UI-wise, the biggest quality jump will come from larger type, richer contrast, and more depth: glass headers, better accent glows, stronger bottom sheets, and real 3D press states on buttons. Flashcards also need their own premium payoff even at 0 XP, or they will feel like the "boring part" of the loop.
