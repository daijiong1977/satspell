# Final Gap Audit — SAT Vocab V1 Design Docs

**Date:** April 11, 2026
**Scope:** design-summary.md, ui-design-spec.md, learning-model-design.md, flashcard-design.md

---

## A. Flow Completeness

### 1. Bonus practice entry is unspecified (UI spec State E / flashcard-design.md Section 11)
State E shows a "PRACTICE MORE" button, but BonusPracticeView is listed as P2. No screen or session structure is defined for bonus practice -- only that it uses Box 1-2 words and earns half XP. A developer cannot build this flow.
**Fix:** Either promote BonusPracticeView to P0/P1 with a defined session structure, or remove the PRACTICE MORE button from State E in V1.

### 2. Day 19 and Day 20 session structures are vague (UI spec Section 10)
Day 19 says "15 weakest words (flashcard + game)" per session but does not define step counts, scoring rules, or whether SHOW AGAIN priority carries over. Day 20's evening "results review + mastery celebration" has no screen spec.
**Fix:** Define step-by-step session structures for Days 19-20 as done for regular sessions in Section 4.1.

### 3. Zone test retry flow after 3+ failures is incomplete (UI spec Section 9.2)
After the 3rd failure the student is told to "try again tomorrow," and the next day "becomes a remediation day." But no Practice tab state exists for a remediation day that is distinct from F1/F2/F3 or State G.
**Fix:** Add a Practice tab state (or clarify which existing state applies) for zone-test remediation days.

### 4. Recovery Evening session structure is undefined (UI spec State F1)
F1 says the session includes "recall yesterday + practice + overdue reviews" but no step table (like Section 4.1) exists. The developer must guess the step count, item counts, and step order.
**Fix:** Provide a step table for each recovery type (F1, F2, F3) comparable to the morning/evening tables.

---

## B. Cross-Doc Contradictions

### 5. Same-day promotion rule: 3/4 vs 2/3 (learning-model-design.md Section 2 vs Section 14 / UI spec Section 4.6)
Section 2 says "3-4 touches correct on Day 1 -> Box 2." Codex review (Section 14) revised this to "2 of 3 scored recalls correct AND correct final recall." UI spec Section 4.6 uses the 2/3 rule. The original Section 2 text was never updated.
**Fix:** Update learning-model Section 2 to match the 2/3 scored-recall rule used everywhere else.

### 6. Word counts per day: 21 vs 25 (learning-model-design.md Sections 4 and 7)
Section 4 designs sessions around 11+10 = 21 new words/day. Section 7 says 25 words/day x 3 learning days per zone. Codex flagged this (Blocking Issue 1) but no resolution is in the spec.
**Fix:** Lock one canonical calendar. With 14 learning days the daily load is ~26.6, which exceeds both figures. This must be resolved before implementation.

### 7. Simulation used 20 review slots; production has ~14 (learning-model-design.md Sections 5 and 8)
Section 5 says ~14 review slots/day. Section 8 simulates with 20. The projected Day 20 box distribution is therefore unreliable.
**Fix:** Rerun simulation with 14 slots before relying on the projections.

### 8. Flashcard description in UI spec still shows old layout (UI spec Section 4.3 vs flashcard-design.md)
Section 4.3 shows word/definition below the image in a white card layout. flashcard-design.md (authoritative) specifies image-fills-100% with sentence overlaid. Both docs acknowledge the override, but the stale wireframe will confuse developers.
**Fix:** Replace the Section 4.3 wireframe with a note pointing solely to flashcard-design.md, or update it to match.

### 9. Share button label inconsistency (UI spec Sections 4.8, 7.1, 8.2)
The button is called "Share Today's Report" in Profile (7.1) and "Share Today's Progress" in Session Complete (4.8) and State E. design-summary.md uses "Share Today's Progress."
**Fix:** Pick one label and use it everywhere.

---

## C. Missing Specs

### 10. Map tap behavior for past and future days (UI spec Section 2.5)
Section 2.5 says any unlocked day node navigates to Practice "with that day selected," but Practice only supports the current active day. Past-day summary and future-day disabled states are not defined.
**Fix:** Define explicitly: past = read-only summary, future unlocked = disabled or preview, future locked = disabled.

### 11. Late-day timing matrix (UI spec Section 3.2, State H)
The evening unlock rule is "4hr OR 5 PM." State H triggers at 8 PM. What happens for morning completion at 1 PM (unlock at 5 PM), at 5:30 PM (unlock at 9:30 PM?), or at 7:59 PM (not State H but evening may be impractical)?
**Fix:** Add a timing matrix: morning-done time -> evening unlock time -> late-night cutoff.

### 12. Back-pressure day session structure (UI spec State G)
State G shows a "START REVIEW" button but no step table. How many items? Which activity types? Is it one session or two?
**Fix:** Define step structure for review-only days.

### 13. Data model still uses `next_due: Date` (learning-model-design.md Section 9)
Codex flagged this as Blocking Issue 5. Same-day progression, evening eligibility, and recovery all require `DateTime` granularity. The data model section was never updated.
**Fix:** Update Section 9 to use `due_at: DateTime` and add `intro_stage` field.

### 14. Quick recall distractor source undefined (UI spec Section 4.6)
Quick recall shows 4 definition choices but the spec does not say how the 3 wrong definitions are selected (random from same zone? same part of speech? semantically similar?).
**Fix:** Define distractor selection rules for quick recall and image-to-word game.

---

## D. Priority / Scope Confusion

### 15. Recovery modes, rush detection, and bonus practice span P0-P2 but appear in V1 flows
Recovery (F1/F2/F3) is P1, RushDetectionToast is P2, BonusPracticeView is P2, yet all appear in V1 Practice tab states and session flows. LateNightBanner is P2 but State H is in the priority resolver.
**Fix:** Either promote these to P0 or define fallback behavior when they are absent in the first release.

---

**Total issues: 15** (4 flow gaps, 5 contradictions, 5 missing specs, 1 scope conflict)
