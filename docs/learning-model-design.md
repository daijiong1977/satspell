# SAT Vocab Learning Model Design

## Overview

This document describes the vocabulary retention model for the SAT Vocab app — a 20-day structured learning program covering 372 SAT vocabulary words. The model is designed for high school students (ages 15-18) studying in two 15-17 minute sessions per day.

The model's central challenge: **how to teach 372 words in 20 days while achieving meaningful long-term retention.** Research suggests 8-12 new words per day is optimal, but our constraint requires ~21 new words per day. This document explains how we solve that tension.

---

## 1. The Problem with Naive Approaches

### Current Implementation (Broken)

The existing app uses a binary review system:

```
If latest_answer == correct → word is "mastered" (never reviewed again)
If latest_answer == incorrect → word appears in review queue
```

**Why this fails:**
- One correct answer permanently removes a word from review
- No spaced intervals — words are either "done" or "not done"
- No consideration of forgetting curve
- Students pass through words quickly but retain very few

### Why Standard Spaced Repetition Also Fails at This Scale

A standard Leitner or SM-2 system with 21 new words/day creates an unmanageable review queue:

| Day | New Words | Reviews Due | Total Load |
|-----|-----------|-------------|------------|
| 1   | 21        | 0           | 21         |
| 4   | 21        | 42          | 63         |
| 8   | 21        | 108         | 129        |
| 14  | 21        | 234         | 255        |

By day 8, there are more reviews due than a student can complete in the allotted time. Reviews get dropped, and retention collapses.

**Simulation result (standard Leitner, 21 words/day, 16 reviews/day cap):**
- 78% of words still in Box 1 (unlearned) at day 20
- Only 19% at "familiar" or better
- 3,031 reviews dropped due to queue overflow

---

## 2. The Solution: Same-Day Multi-Touch Acceleration

### Core Insight

The 2-session daily structure provides **4 exposures per word on the day it is introduced**. If we count these same-day exposures as accelerated box progression, most words skip Box 1 entirely — dramatically reducing the review queue for subsequent days.

### How It Works

Each new word receives 4 distinct touches on its first day:

| Touch | Session | Activity | Cognitive Mode |
|-------|---------|----------|----------------|
| 1     | Morning | Flashcard | Encoding (see word, image, definition) |
| 2     | Morning | Image-to-word game | Active recall (retrieve from memory) |
| 3     | Evening | Quick recall | Spaced recognition (hours later) |
| 4     | Evening | Image-to-word game | Reinforced retrieval |

**Progression rule (V1 — updated per Codex review):**

Flashcards are exposure-only (not scored). The 3 scored Day 1 events are:
1. Morning image-to-word game
2. Evening quick recall
3. Evening image-to-word game

Promotion: **2 of 3 scored recalls correct AND correct final recall → Box 2** (next review in 3 days). Otherwise → Box 1 (next review tomorrow). If evening session is missed, words enter Box 1 (no same-day acceleration).

This is the key mechanism that makes 21 words/day viable. The 4-8 hour gap between morning and evening sessions provides the first spacing interval, which research shows boosts retention by 20-30% compared to massed practice.

---

## 3. The Box System (Modified Leitner)

### Five-Level Progression

```
                  correct           correct           correct           correct
    ┌────────┐  ──────────►  ┌────────┐  ──────────►  ┌────────┐  ──────────►  ┌────────┐  ──────────►  ┌──────────┐
    │ Box 1  │               │ Box 2  │               │ Box 3  │               │ Box 4  │               │  Box 5   │
    │ Due:1d │               │ Due:3d │               │ Due:7d │               │Due:14d │               │ MASTERED │
    └────────┘               └────────┘               └────────┘               └────────┘               └──────────┘
         ▲                        │                        │                        │
         │         incorrect      │       incorrect        │       incorrect        │
         └────────────────────────┴────────────────────────┴────────────────────────┘
```

| Box | Review Interval | Meaning | Action on Correct | Action on Incorrect |
|-----|----------------|---------|-------------------|---------------------|
| 1   | 1 day          | Struggling | Move to Box 2 | Stay in Box 1 |
| 2   | 3 days         | Learning | Move to Box 3 | Back to Box 1 |
| 3   | 7 days         | Familiar | Move to Box 4 | Back to Box 1 |
| 4   | 14 days        | Strong | Move to Box 5 | Back to Box 1 |
| 5   | None (mastered)| Mastered | Stay in Box 5 | Back to Box 1 |

**Note:** These are internal/code labels. Student-facing UI uses: Locked In → Rising → Strong → Solid → Mastered. See `docs/points-system.md` Section 6 for the mapping.

### Why These Intervals

The intervals (1, 3, 7, 14 days) are a simplified version of Pimsleur's graduated intervals, validated by Cepeda et al.'s meta-analysis (2006). They approximate the optimal spacing for a 30-day retention target:

- **1 day**: Catches the steepest part of the Ebbinghaus forgetting curve (56% retained at 24 hours without review)
- **3 days**: Reinforces before the second major decay point
- **7 days**: Establishes medium-term memory
- **14 days**: Bridges to long-term retention

A word needs **4 consecutive correct answers across ~25 days** to reach "mastered" status.

---

## 4. Daily Session Structure

### Session 1 — Morning "Learn" (~16 minutes)

| Step | Activity | Count | Time | Purpose |
|------|----------|-------|------|---------|
| 1 | New word flashcards | 11 | 7.3 min | Encoding: see word, mnemonic image, definition, example sentence |
| 2 | Image-to-word game | 12 (8 new + 4 review) | 5.0 min | Active recall of new words + spaced review of older words |
| 3 | SAT questions | 3 | 3.8 min | Contextual application using today's words |

### Session 2 — Evening "Consolidate" (~17 minutes)

| Step | Activity | Count | Time | Purpose |
|------|----------|-------|------|---------|
| 1 | New word flashcards | 10 | 6.7 min | Encoding: second batch of new words |
| 2 | Quick recall of morning words | 11 | 3.7 min | Spaced recognition (4-8 hours after morning) |
| 3 | Image-to-word game | 12 (6 new + 6 review) | 5.0 min | Active recall + spaced review |
| 4 | SAT questions | 2 | 2.5 min | Contextual application |

### Why Two Sessions

The two-session structure is not just a scheduling convenience — it is the core mechanism of the learning model:

1. **Spacing effect**: The 4-8 hour gap between sessions creates the first spaced repetition interval, which is the most critical for moving information from short-term to long-term memory
2. **Sleep consolidation**: Evening sessions position newly learned words for overnight memory consolidation (Diekelmann & Born, 2010)
3. **Same-day acceleration**: The 4 touches per word on Day 1 allow words to skip Box 1, preventing review queue overflow
4. **Attention management**: Two 16-minute sessions maintain engagement better than one 32-minute session for the target age group

### Evening Session Unlock Rule

The evening session unlocks when **either** condition is met:
- 4 hours have passed since completing the morning session
- It is after 5:00 PM local time

This prevents students from rushing through both sessions back-to-back, which would eliminate the spacing benefit.

---

## 5. Review Queue Management

### The Overflow Problem

Even with same-day acceleration, some days will have more reviews due than can fit in the session. The system handles this with priority-based capping:

### Priority Order for Reviews

When more reviews are due than can be completed:

1. **Box 1 words first** (most at risk of being forgotten)
2. **Box 2 words second** (recently learned, need reinforcement)
3. **Box 3+ words last** (more stable, can tolerate a 1-day delay)

### Daily Review Budget

| Slot | Session | Activity | Review Words |
|------|---------|----------|-------------|
| 1 | Morning | Image game | 4 review words mixed with 8 new |
| 2 | Morning | SAT questions | 1-2 review words in question pool |
| 3 | Evening | Quick recall | 0 (morning words only) |
| 4 | Evening | Image game | 6 review words mixed with 6 new |
| 5 | Evening | SAT questions | 1-2 review words in question pool |
| **Total** | | | **~14 review slots per day** |

### Overflow Handling

Words that cannot be reviewed today are **pushed to tomorrow** with their box level preserved. They are given highest priority the next day.

The system guarantees:
- No word goes more than **2 days** past its due date
- Box 1 words are **never** deprioritized
- If overflow persists for 3+ days, the system reduces new word count temporarily

---

## 6. The 20-Day Schedule

### Days 1-18: Learning Phase

| Day | Zone | New Words | Expected Reviews | Focus |
|-----|------|-----------|-----------------|-------|
| 1   | Foundation | 21 | 0 | Pure learning |
| 2   | Foundation | 21 | ~5 (Day 1 Box 1 words) | Learn + light review |
| 3   | Foundation | 21 | ~8 | Learn + review |
| 4   | Foundation | 0 | ~15 | **Zone test** (80% to unlock Zone 2) |
| 5   | Cloud Realm | 21 | ~12 | Learn + review |
| ... | ... | ... | ... | ... |
| 16  | Future City | 0 | ~20 | **Zone test** |
| 17  | Future City | 21 | ~18 | Learn + review |
| 18  | Future City | 9 (last words) | ~20 | Final learning day |

### Days 19-20: Review Phase

**Day 19 — Weak Word Blitz:**
- Morning: 15 weakest words (Box 1-2) — intensive flashcard + game
- Evening: Next 15 weakest words + mixed SAT practice
- No new words introduced

**Day 20 — Final Assessment:**
- Morning: 30-question comprehensive SAT-style test covering all zones
- Evening: Results review, mastery celebration, final stats

### Zone Test Days (Days 4, 8, 12, 16)

Zone test days introduce no new words. Both sessions are dedicated to:
- Review all words from the current zone
- Mixed activity format (flashcard recall + image game + SAT questions)
- Minimum 80% accuracy required to unlock next zone
- Can retry unlimited times on the same day
- Failed words automatically get Box 1 status (reviewed tomorrow)

---

## 7. Word Distribution Across Zones

| Zone | Name | Words | Word IDs | Words/Day |
|------|------|-------|----------|-----------|
| 1 | Foundation | 75 | 1-75 | 25/day × 3 learn days |
| 2 | Cloud Realm | 75 | 76-150 | 25/day × 3 learn days |
| 3 | Island | 75 | 151-225 | 25/day × 3 learn days |
| 4 | Space | 75 | 226-300 | 25/day × 3 learn days |
| 5 | Future City | 72 | 301-372 | 24/day × 3 learn days |

**⚙️ PROVISIONAL:** These word counts are not final. The session design uses 11+10=21 new words/day, but zones assume 25/day × 3 learn days = 75/zone. This gap (21 vs 25) must be resolved during implementation by either:
- (a) Making all 4 zone days learning days (21 × 4 = 84, close to 75 with buffer), or
- (b) Adjusting session word counts to match (13+12=25/day on learning days)

The exact calendar should be locked as one of the first implementation tasks.

---

## 8. Validation Results

### Simulation Parameters
- 372 words, 18 learning days + 2 review days
- 85% correct rate on same-day touches
- 82% correct rate on subsequent reviews
- 20 review slots per day across both sessions (⚠️ production budget is ~14 — rerun needed)
- Same-day multi-touch acceleration enabled

**⚠️ PROVISIONAL:** These projections used 20 review slots/day. Actual production budget is ~14 slots/day (Section 5). Simulation should be rerun with 14 slots before treating these numbers as final. The directional finding (same-day acceleration makes 21 words/day viable) is still valid.

### Projected Outcomes at Day 20

| Box | Words | Percentage | Meaning |
|-----|-------|-----------|---------|
| Box 1 | 17 | 5% | Still struggling |
| Box 2 | 123 | 33% | Actively learning |
| Box 3 | 160 | 43% | Strong (familiar) |
| Box 4 | 72 | 19% | Solid (strong recall) |
| **Box 3+** | **232** | **62%** | **Strong or better** |

After the Day 19-20 review phase, projected to reach **70-75% familiar or better**.

### Comparison with Current System

| Metric | Current | New Model |
|--------|---------|-----------|
| Words at "familiar+" by Day 20 | ~15% | ~62% |
| Review queue manageable | No (drops reviews) | Yes (capped + prioritized) |
| Same-day reinforcement | None | 4 touches per word |
| Spaced repetition | None (binary correct/incorrect) | 5-level Leitner with timed intervals |
| Adaptive to mistakes | No | Yes (wrong → Box 1 → reviewed tomorrow) |

---

## 9. Data Model

### Word Review State

Each word has a persistent state:

```
word_id:       Integer (FK to words table)
user_id:       String
box_level:     Integer (1-5)
due_at:        DateTime (when this word should next be reviewed — DateTime for same-day precision)
intro_stage:   Integer (0=not introduced, 1=morning seen, 2=evening recall done, 3=promotion decided)
last_reviewed: DateTime
total_correct: Integer (lifetime correct count)
total_seen:    Integer (lifetime seen count)
day_touches:   Integer (touches today, reset daily)
lapse_count:   Integer (times the word fell back to Box 1 after being higher)
consecutive_wrong: Integer (current streak of wrong recalls)
recent_accuracy: Float (rolling accuracy over recent scored recalls)
memory_status: Enum (easy, normal, fragile, stubborn)
```

### Word Difficulty Layer

The box system tracks **when** a word should be reviewed. The difficulty layer tracks **how stable that word feels for this learner**.

- **easy**: usually recalled correctly, low lapse history, currently stable
- **normal**: no special intervention needed
- **fragile**: recently missed or unstable, needs earlier attention within the queue
- **stubborn**: forgotten repeatedly across multiple sessions or repeatedly reset to Box 1

Important rule:

- `memory_status` should **not** replace the box system
- An "easy" word still has to pass through spaced intervals to earn mastery
- A "stubborn" word should not be permanently trapped, but it should receive more support and earlier priority inside the same box

### Review Log Entry

Each interaction is logged:

```
word_id:       Integer
user_id:       String
activity_type: Enum (flashcard, image_game, sat_question, quick_recall)
outcome:       Enum (correct, incorrect)
response_ms:   Integer (time to answer)
session:       Enum (morning, evening)
day_index:     Integer
reviewed_at:   DateTime
```

### Box Transition Logic (Pseudocode)

```
function processReview(word, outcome):
    word.total_seen += 1
    word.last_reviewed = now()

    if word.isNewToday():
        word.day_touches += 1
        if word.day_touches >= 4 and word.todayCorrectRate() >= 0.75:
            word.box_level = 2
            word.due_at = today + 3 days
        else if word.day_touches >= 4:
            word.box_level = 1
            word.due_at = tomorrow
        word.recent_accuracy = word.computeRecentAccuracy()
        word.memory_status = classifyMemoryStatus(word)
        return  // Don't advance boxes during same-day touches

    if outcome == correct:
        word.total_correct += 1
        word.consecutive_wrong = 0
        word.box_level = min(word.box_level + 1, 5)
    else:
        if word.box_level > 1:
            word.lapse_count += 1
        word.consecutive_wrong += 1
        word.box_level = 1

    word.recent_accuracy = word.computeRecentAccuracy()
    word.memory_status = classifyMemoryStatus(word)
    word.due_at = today + interval[word.box_level]

intervals = {1: 1 day, 2: 3 days, 3: 7 days, 4: 14 days, 5: infinite}

function classifyMemoryStatus(word):
    if word.lapse_count >= 3 or word.consecutive_wrong >= 2:
        return stubborn
    if word.recent_accuracy < 0.6 or word.lapse_count >= 1:
        return fragile
    if word.box_level >= 3 and word.recent_accuracy >= 0.85 and word.lapse_count == 0:
        return easy
    return normal
```

### Fetching the Review Queue (Pseudocode)

```
function getReviewQueue(user_id, limit):
    memory_priority = {stubborn: 4, fragile: 3, normal: 2, easy: 1}

    due_words = SELECT * FROM word_states
                WHERE user_id = user_id
                AND due_at <= today
                ORDER BY box_level ASC,
                         memory_priority DESC,
                         due_at ASC
                LIMIT limit

    return due_words
    // Box 1 first (most urgent), then Box 2, etc.
    // Within the same box: stubborn > fragile > normal > easy
    // Within the same memory tier: oldest due date first
```

---

## 10. Edge Cases

### Recovery Principle: Program Day, Not Calendar Day

The 20-day plan should run on **study-day progression**, not on fixed calendar dates.

- A "day" advances only after the learner completes both the morning and evening sessions for that program day
- Missing a calendar day does **not** skip content or auto-advance the learner to the next zone
- New words are **postponed**, not stacked. If a learner misses 2 calendar days, the app should not suddenly ask them to learn 42 make-up words
- Recovery should always prioritize finishing incomplete learning and clearing overdue reviews before unlocking fresh words

### Student Misses a Day

- Adventure day does **not** advance — it stays on the same program day until the learner finishes the missing session(s)
- Reviews due on the missed day are pushed to the next active session and get highest priority
- No words are permanently skipped
- Streak resets but can be rebuilt

**If the learner misses only the evening session:**
- The next login starts with a **Recovery Evening** for the unfinished day, before any new words are unlocked
- That recovery session should include:
    - quick recall for the morning's new words
    - one recall game round using those same words
    - any overdue Box 1-2 reviews
- Morning words from that incomplete day should **not** receive same-day acceleration into Box 2. At best, they complete their intro cycle and move to **Box 1 due tomorrow**
- After the Recovery Evening is completed, the learner may start the next morning session

**If the learner misses 1 full day:**
- The next active day becomes a **Catch-Up Day**
- Session 1: unfinished new words from the last incomplete day + highest-priority overdue reviews
- Session 2: normal evening consolidation for those words
- New word count for the next unlocked day is reduced by about **50%** to protect review quality

**If the learner misses 2 full days:**
- Do **not** try to cram two missed days of new words into one day
- The first day back should be **review-heavy** or even **review-only** if the overdue queue is large
- Skipped new-word sets are postponed to later program days; the total course length may extend by 1-2 days for that learner
- This is better than preserving the calendar at the cost of retention collapse

**Make-up rule of thumb:**
- Missed evening only: finish yesterday first, then continue
- Missed 1 day: catch up with reduced new words
- Missed 2+ days: review first, extend the program if needed

### Student Starts a Session but Gets Interrupted

- Session progress should be saved at the item level, not only at the session boundary
- Already-scored review attempts count; unseen items remain pending
- A session is not marked complete until all required steps for that session are finished
- If interruption happens during the first session, the second session stays locked because the intro cycle is incomplete
- If interruption happens during a Recovery Evening or Catch-Up Day, the next login resumes that same flow before any new words unlock

### Student Studies Very Late at Night

- If the first session starts very late (for example, after 8:00 PM local time), the app should not expect a same-night follow-up session
- Those words should be treated like an incomplete intro cycle and routed into a next-day recovery flow
- They do **not** qualify for same-day Box 2 acceleration, because the spacing pattern was not actually achieved
- This protects the memory model while still letting busy learners make partial progress on hard days

### Student Travels or Changes Time Zones

- Session unlock logic should depend on **elapsed real time** plus stored program-day state, not just the device's local clock label
- Crossing time zones or manually changing the clock should not unlock extra sessions or skip required recovery
- The UI can show local morning/evening labels, but progression should remain tied to the unfinished study day
- If the system detects a major clock shift, it should freeze new-word unlocks until the learner completes any pending recovery session

### Student Returns After 3+ Missed Days

- The first day back becomes a **Re-entry Day** rather than a normal learning day
- Session 1 should be a diagnostic review focused on overdue Box 1-3 words
- Session 2 should be consolidation and confidence rebuilding, not heavy new-word introduction
- New words resume only after the overdue Box 1-2 queue drops below a healthy threshold
- The program may extend by several study days for that learner; retention quality is more important than preserving the original calendar length

### Bonus Practice After a Missed Day

- Bonus practice can help recall, but it does **not** replace a required Recovery Evening, Catch-Up Day, or Re-entry Day
- Bonus attempts may be logged for analytics or confidence scoring, but they should not auto-complete an unfinished study day
- This prevents learners from bypassing the intended spacing structure while still rewarding extra effort

### Zone Test Missed or Failed After Time Away

- If a learner returns on a pending zone-test day after a break, the app should show a short refresher review before the test attempt
- If the learner fails the zone test repeatedly after time away, the next study day should convert to remediation instead of unlimited brute-force retries
- The next zone stays locked until the refresher plus test are passed
- Previously learned words keep their review boxes; only the zone gate is delayed

### Student Gets Most Words Wrong

- Wrong words go to Box 1, due tomorrow
- If Box 1 queue exceeds daily capacity, system temporarily reduces new word count (e.g., 15 instead of 21) to make room for reviews
- The system self-balances: fewer correct → more reviews → slower new word introduction → better retention

### Student Rushes Through Without Reading

- Response time is tracked. If a flashcard is dismissed in under 3 seconds, it does **not** count as a valid touch
- Image game answers under 1 second are flagged as guesses and don't count toward box progression

### Student Wants to Study More

- After completing both daily sessions, an optional "bonus practice" mode is available
- Bonus practice reviews Box 1-2 words only (no new words)
- Bonus practice earns half XP (incentive exists but doesn't replace the structured sessions)

### Two Sessions Done Back-to-Back

- Evening session is locked until 4 hours after morning completion OR after 5:00 PM
- This enforces the spacing interval that makes the model work
- If the student tries to start the evening session early, show: "Your brain needs time to process! Come back at [unlock time]."

### Why This Matters for the Model

- The calendar should support the memory model, not override it
- Same-day acceleration is valuable only when the second touch actually happens after a meaningful gap
- If life gets busy, the system should preserve learning quality first and schedule neatness second
- In practice, this means the app needs a small amount of **schedule elasticity** even if the default experience is framed as a 20-day journey

---

## 11. Scientific References

The model draws from these established findings:

1. **Ebbinghaus Forgetting Curve (1885)**: Memory retention drops to ~56% after 24 hours without review. Spaced review at increasing intervals dramatically improves long-term retention.

2. **Leitner System (1972)**: Box-based spaced repetition where correct answers move cards forward and incorrect answers reset them. Simple, effective, and easy to implement.

3. **Spacing Effect — Cepeda et al. (2006)**: Meta-analysis in Psychological Bulletin confirming that distributed practice produces 20-30% better retention than massed practice. Optimal gap between sessions scales with desired retention interval.

4. **Testing Effect — Roediger & Karpicke (2006)**: Active recall (being tested) produces 30-50% better retention than passive review (re-reading). This is why our model emphasizes games and quizzes over simple flashcard viewing.

5. **Sleep Consolidation — Diekelmann & Born (2010)**: Memory consolidation occurs during sleep. Evening study sessions position material for overnight consolidation.

6. **Interleaving — Rohrer & Taylor (2007)**: Mixing different types of problems (interleaving) produces 10-20% better transfer performance than practicing one type at a time (blocking). Our image games mix new and review words for this reason.

7. **Desirable Difficulty — Bjork (1994)**: Learning conditions that make retrieval harder (but not impossible) produce stronger long-term memories. The image-to-word game creates desirable difficulty by requiring production rather than recognition.

8. **Attention and Session Length**: Research on adolescent attention spans suggests 15-25 minutes per focused study session is optimal. Beyond 30 minutes, diminishing returns set in sharply (Dempster, 1988).

---

## 12. Success Metrics

How we measure if the model is working:

| Metric | Target | How Measured |
|--------|--------|-------------|
| Day 20 Box 3+ rate | ≥ 60% | Count of words at Box 3 or higher |
| Daily completion rate | ≥ 80% | Sessions completed / sessions available |
| Average session time | 14-18 min | Time from session start to finish |
| Box 1 queue size | ≤ 25 | Daily count of Box 1 words |
| Week 2 retention | ≥ 70% | Accuracy on Zone 1 words tested in Zone 3+ |
| Student satisfaction | ≥ 4/5 | In-app rating prompt after Zone 3 |

---

## 13. Open Questions for Review

1. **Should the same-day acceleration threshold be 3/4 or 4/4 correct touches?** Lower threshold (3/4) moves more words to Box 2 faster, reducing review load. Higher threshold (4/4) ensures stronger initial encoding but increases Box 1 queue.

2. **Is the 4-hour minimum gap between sessions sufficient?** Research suggests optimal same-day spacing is 4-12 hours. Should we make this configurable or fixed?

3. **Should wrong answers always reset to Box 1, or drop by 1 box?** Full reset (Leitner standard) is simpler and more conservative. Drop-by-1 is less punishing but may allow under-learned words to progress.

4. **How should the zone test difficulty scale?** Should Zone 5 test only Zone 5 words, or include a percentage from all previous zones?

5. **Should the model adapt the daily new word count based on individual performance?** If a student's Box 1 queue grows too large, should the system automatically reduce new words from 21 to 15 to prioritize reviews?

---

## Codex Review Notes (April 11, 2026)

### Blocking Issues to Resolve Before Implementation

1. **The schedule math is internally inconsistent.**
    - The overview and session plans are built around **21 new words/day** (11 in the morning, 10 in the evening).
    - The zone table switches to **25 words/day x 3 learning days** for most zones.
    - The calendar currently also includes **four zero-new-word zone test days** plus a **two-day review phase**, which leaves only **14 actual new-word days** in a 20-day run.
    - That means the plan would need $372 / 14 \approx 26.6$ new words per active learning day, which does not fit either the 21-word session design or the 25-word zone math.
    - Recommendation: choose one canonical 20-day calendar first, then recompute zone sizes, daily loads, and time budgets from that baseline.

2. **Same-day acceleration does not yet define what counts as a "correct" touch.**
    - The model says a word can reach Box 2 after **3-4 touches correct on Day 1**.
    - But two of the four touches are currently described as **flashcards / encoding**, which are passive exposures rather than scored recall events.
    - If passive flashcard views count as "correct," the model will over-promote words and under-estimate later review load.
    - Recommendation: only count recall-based events toward same-day promotion, or add a micro-check after each flashcard so every qualifying touch has a measurable success criterion.

3. **The retention simulation assumes more review capacity than the product schedule actually provides.**
    - The daily review budget section says the app has about **14 review slots/day**.
    - The validation section simulates **20 review slots/day**.
    - That difference is large enough to invalidate the projected Day 20 box distribution.
    - Recommendation: rerun the simulation with the exact production schedule, including zone test days, missed-day recovery, and whatever same-day touches truly count as reviews.

4. **The overflow guarantee is not backed by a deterministic scheduling rule.**
    - The doc promises that no word goes more than **2 days past due**, while also capping reviews and allowing missed days.
    - The current fallback is only "push to tomorrow" and "temporarily reduce new word count," which is directionally right but not specific enough to implement or test.
    - Recommendation: define an explicit back-pressure policy. Example: if overdue reviews exceed 18, cut tomorrow's new words to 12; if overdue reviews exceed 30, convert the next day to review-only.

5. **The data model is too coarse for a two-session same-day learning loop.**
    - `next_due: Date` is fine for 1-day and 3-day boxes, but it cannot represent same-day evening eligibility, partial completion of an intro cycle, or recovery from a missed evening session.
    - `total_correct` is labeled as a lifetime metric, but the pseudocode does not increment it during the same-day branch.
    - Recommendation: use `due_at: DateTime`, add an explicit same-day state such as `intro_stage` or `same_day_touch_count`, and define how same-day correctness is logged.

### Medium-Priority Suggestions

1. **Add a delayed retention checkpoint after the 20-day program.**
    - The stated goal is meaningful long-term retention, but the success metrics stop at Day 20 and an in-program week-2 measure.
    - Recommendation: add a 7-day and 30-day post-program probe on a sampled word set.

2. **Separate "mastery for this 20-day sprint" from true mastery.**
    - Reaching Box 5 after one short program is probably better labeled as "course mastered" or "strong recall" than permanently mastered.
    - Recommendation: reserve a stricter status for words that survive a delayed review after the course ends.

3. **Define what happens on zone test failure at the program level, not just the word level.**
    - The doc says students can retry unlimited times on the same day, but it does not say whether repeated failure delays the calendar, unlocks remediation, or reduces new-word quotas.
    - Recommendation: specify whether a failed zone test pauses progression or triggers a lighter remediation day.

### Suggested Revision Order

1. Lock the 20-day calendar and word/day math.
2. Define which Day 1 events are scored and eligible for box promotion.
3. Rerun the queue simulation using the exact production review budget.
4. Finalize the adaptive overflow rules.
5. Update the data model to match the two-session scheduler.

### Short Verdict

The core idea is promising: the two-session structure and same-day reinforcement are good levers for a constrained SAT vocabulary program. The current draft is not ready to implement as written because the calendar math, promotion criteria, and queue-cap assumptions still conflict with each other. Fixing those three items first will make the rest of the model much easier to build and test.

### Codex Recommended V1 Defaults for Claude Review

If this document is handed to Claude for one more review before implementation, these are the defaults I recommend treating as the current intended model:

1. **Use study-day progression, not fixed calendar progression.**
    - The product can still be presented as a "20-day journey," but the scheduler should advance by completed study days.
    - In practice this means many learners finish in about 20 calendar days, while busy learners may need 21-24.

2. **Keep the box system and the learner-specific difficulty layer together.**
    - `box_level` answers when a word is due.
    - `memory_status` (`easy`, `normal`, `fragile`, `stubborn`) answers how much support that word needs for this learner.
    - Queue priority should be: box first, then `stubborn > fragile > normal > easy` inside the same box.

3. **Only scored recall events should affect Day 1 promotion.**
    - For V1, treat these as the scored Day 1 recalls:
      - morning image-to-word game
      - evening quick recall
      - evening image-to-word game
    - Recommended promotion rule: move to **Box 2** only if the learner gets at least **2 of 3** scored recalls correct **and** ends the day with a correct final recall.
    - If the evening session is missed and recovered the next day, the word should start in **Box 1**, not Box 2.

4. **Use explicit recovery modes instead of calendar catch-up.**
    - Missed evening: **Recovery Evening**
    - Missed 1 day: **Catch-Up Day**
    - Missed 3+ days: **Re-entry Day**
    - Never stack missed new words into a single overloaded day.

5. **Adopt a concrete back-pressure policy.**
    - If overdue reviews exceed about **18**, reduce the next day's new-word load to about **12**.
    - If overdue reviews exceed about **30**, or the Box 1 queue is clearly unhealthy, convert the next day to **review-only**.
    - This should be configurable, but these values are reasonable V1 defaults.

6. **Treat current validation numbers as provisional.**
    - The current simulation/results section should not be treated as final evidence until it is rerun with the real production assumptions, especially the true review-slot budget and recovery behavior.

7. **Treat Box 5 as course mastery, not permanent mastery.**
    - For V1 wording, "mastered" can mean "mastered for this course." 
    - A later follow-up review at 7 days or 30 days can be added if the product wants a stronger claim about long-term retention.

8. **Do not hardcode the exact zone/day calendar until the queue simulation is rerun.**
    - The narrative of five zones is good.
    - The exact words-per-day math still looks provisional and should remain configurable during the first implementation pass.

## 14. Codex Final Implementation Handoff (April 11, 2026)

This short appendix is meant to keep the learning model aligned with the current UI spec before implementation starts.

### What Now Looks Aligned Across Both Docs

1. **Flashcards are exposure-only, not scored recall.**
    - The UI spec now treats flashcards as orientation and within-session ordering only.
    - Same-day promotion should be based only on scored recall events.

2. **Recovery modes are now part of the intended V1 product behavior.**
    - `Recovery Evening`, `Catch-Up Day`, and `Re-entry Day` should be treated as core scheduling behavior, not optional edge-case polish.
    - The late-night flow is also aligned with the model's rule that incomplete spacing should not earn same-day acceleration.

3. **The learner-specific difficulty layer fits the UI direction.**
    - `memory_status` remains a support layer that changes queue priority and learner messaging.
    - It should not replace the box system or create a separate progression path.

4. **Study-day progression remains the correct scheduler model for V1.**
    - The experience can still be framed as a 20-day journey.
    - Under the hood, progression should still follow completed study days, not rigid calendar advance.

### What Is Still Intentionally Provisional

1. **The exact 20-day calendar math is still not final.**
    - Zone sizes, zero-new-word test days, and total new-word load still need one canonical version.

2. **The simulation numbers should still be treated as provisional.**
    - They need to be rerun with the real review-slot budget, real recovery behavior, and the final definition of scored Day 1 events.

3. **The data model still needs a scheduler-ready shape.**
    - `next_due` by date alone is still too coarse for same-day states, recovery handling, and partial intro cycles.
    - Implementation should plan for explicit same-day progression state, such as `due_at`, `intro_stage`, or equivalent.

### Practical V1 Reading of This Document

This document is now strong enough to guide implementation decisions, but it should be treated as a **V1 operating model**, not a mathematically final retention proof. The main remaining work is to lock the exact calendar math, rerun the queue simulation with production assumptions, and shape the stored state so the scheduler can express same-day learning and recovery cleanly.
