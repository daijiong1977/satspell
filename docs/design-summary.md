# SAT Vocab V1 — Design Summary & Implementation Readiness

**Date:** April 12, 2026
**Status:** Design complete. Ready for implementation planning.

---

## 1. What We Built (Design Phase)

### Design Documents

| Document | Purpose | Sections | Status |
|----------|---------|----------|--------|
| `docs/ui-design-spec.md` | Complete UI specification | 14 sections, 30 screens, 10 Practice states | ✅ Reviewed by Codex + GPT-5.4 |
| `docs/learning-model-design.md` | Spaced repetition model | 14 sections, Leitner 5-box, same-day acceleration | ✅ Reviewed by Codex |
| `docs/flashcard-design.md` | Flashcard UI deep spec | 15 sections, gestures, adaptive layout, image framing | ✅ Reviewed by GPT-5.4 |
| `docs/game-views-design.md` | Image game, Quick recall, SAT question specs | 6 sections, feedback, scoring, sizing, edge cases | ✅ New |
| `docs/points-system.md` | XP system, box progression, reward layers | 9 sections, daily targets, combos, streak bonuses | ✅ Reviewed by GPT-5.4 |
| `docs/ui-visual-system.md` | Final visual treatment, colors, typography, animations | 5 sections, per-activity specs, iPhone sizing | ✅ Final |
| `docs/data-schema.md` | SQLite + Supabase schema, migration, key queries | 8 sections, CREATE TABLE, data flow, sync strategy | ✅ Audited |
| `docs/content-delivery.md` | How word lists get into the app (V1 bundled, V2 downloadable) | 5 sections, import code, pack store design | ✅ New |

### Key Design Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Visual style | Duolingo-inspired, playful & gamified | Appeals to 15-18 year olds without being childish |
| Tab structure | 4 tabs: Map, Practice, Stats, Profile | Merged Tasks + Games into Practice |
| Daily structure | 2 sessions × ~16 min (morning + evening) | Spacing effect: 4-8hr gap boosts retention 20-30% |
| Spaced repetition | 5-level Leitner boxes (1, 3, 7, 14, mastered) | Simple, proven, with same-day multi-touch acceleration |
| Flashcard scoring | Exposure-only (not scored) | Scoring via image game, quick recall, SAT questions only |
| Flashcard interaction | Tap to flip, swipe to navigate, Show Again/Got It on back | Show Again re-queues AND feeds into Step 2 game |
| Image framing | Image fills 100% of card, sentence overlaid at bottom | Word highlighted in gold within sentence — visual memory link |
| Parent report | "Share Today's Progress" via iOS share sheet | Student-owned, not parent-surveillance |
| Recovery modes | 3 types: Recovery Evening, Catch-Up Day, Re-entry Day | Study-day progression, not calendar-rigid |
| Evening unlock | Hardcoded: 4hr gap OR 5 PM | No user-configurable setting in V1 |
| Words Fighting Back | Display-only in V1 (not tappable) | WordDetailView deferred to P1 |
| Tone | "Smart friend + sharp SAT coach" | Quick, witty microcopy — not cute, not academic |

### Cross-Check Reviews Completed

| Reviewer | Document | Issues Found | All Resolved? |
|----------|----------|-------------|---------------|
| Codex (user's AI) | learning-model-design.md | 5 blocking + 3 medium | ✅ Yes |
| Codex | ui-design-spec.md | 4 product + 4 marketing | ✅ Yes |
| Copilot (GPT default) | ui-design-spec.md | 5 issues | ✅ Yes |
| GPT-5.4 | ui-design-spec.md | 4 issues | ✅ Yes |
| GPT-5.4 | flashcard-design.md | 4 issues + 2 suggestions | ✅ Yes |

---

## 2. Images

All 372 existing flashcard images are used as-is for V1. Image improvements deferred to later.

The flashcard UI adapts to any image via dark gradient overlay at the bottom (for sentence text) and top (for progress bar). See `docs/flashcard-design.md` Section 2 for composition rules.

---

## 3. What's Still Provisional

These values are in `AppConfig` and may need tuning after initial testing:

| Value | Default | Notes |
|-------|---------|-------|
| Morning new words | 11 | May adjust based on actual session timing |
| Evening new words | 10 | May adjust |
| Back-pressure: reduce at | 18 overdue | May need real usage data |
| Back-pressure: stop at | 30 overdue | May need real usage data |
| Zone test pass threshold | 80% | May be too high for first-time test |
| Zone/day calendar | 5 zones × 4 days | Exact word distribution not final |
| Same-day promotion rule | 2/3 scored + correct final | Codex recommended, not yet validated by simulation |

---

## 4. Known Gaps to Close Before Implementation

### Resolved

- ~~Data model needs DateTime~~ → ✅ `due_at: DateTime` + `intro_stage` in data-schema.md
- ~~Map day-tap behavior~~ → ✅ Section 14.6 in ui-design-spec.md
- ~~Late-day timing matrix~~ → ✅ Section 14.7 in ui-design-spec.md
- ~~Flashcard scoring inconsistent~~ → ✅ Flashcards fully non-scored across all docs
- ~~Share label inconsistent~~ → ✅ All "Share Today's Progress"
- ~~Box labels too academic~~ → ✅ Locked In/Rising/Strong/Solid/Mastered

### Still Open (resolve during implementation)

1. **Calendar math not canonical** — UI assumes 11+10 words/day, learning model carries provisional zone math. Need one canonical 20-day calendar locked. ⚙️
2. **Simulation needs rerun** — Projections used 20 review slots/day, production has ~14. Directionally valid but numbers are provisional. ⚙️
3. **Spec review appendices** — learning-model-design.md still has Codex review notes inline. Consider moving to docs/reviews/ during implementation.

---

## 5. Tooling Created

| Tool | Purpose | Usage |
|------|---------|-------|
| `scripts/copilot-review.sh` | Automated cross-check via GPT-5.4 | `./scripts/copilot-review.sh --type design --model gpt-5.4` |
| `~/.claude/commands/cross-check.md` | Claude Code `/cross-check` command | Invoke cross-check from any session |
| `scripts/cleanup_storage.py` | Supabase storage cleanup (28-day retention) | `python3 cleanup_storage.py` |

---

## 6. Recommendations for Implementation Phase

### Priority Order

**P0 — First release (must ship):**
1. Data layer: WordState, SessionState, DayState, ReviewQueue, BoxTransition
2. Practice tab with 2 session cards + lock timer
3. Session flow orchestrator (chains flashcard → game → SAT)
4. Flashcard view (image-hero, sentence overlay, flip, Show Again/Got It)
5. Image-to-word game (scored, with Show Again priority)
6. Quick recall (scored, Day 1 promotion)
7. SAT split-scroll (scored)
8. Session complete screen + Share Progress
9. Pause/resume with per-item persistence
10. Adventure map with session indicators

**P1 — Fast follow (1-2 weeks after):**
11. Recovery modes (F1/F2/F3)
12. Back-pressure banners
13. Stats tab (box distribution, weekly calendar, Words Fighting Back)
14. Zone test with remediation
15. Profile settings (notifications)
16. Step transition screens
17. Parent report card image generator

**P2 — V2:**
18. Dark mode
19. WordDetailView (tappable stubborn words)
20. AI assist for stubborn words
21. Automatic parent report (email/push)
22. Post-program retention probes

### Process Recommendations

1. **Freeze the spec** — Move all review appendices to `docs/reviews/`. The live spec should be clean.
2. **Write implementation plan** — Use the `writing-plans` skill to create a step-by-step build plan from the P0 screen list.
3. **Run `/cross-check` after each major implementation milestone** — The script is ready.
4. **Test with real teen** — Get your daughter to test after P0 is built. Her feedback > any AI review.

---

## 7. Files Reference

```
docs/
├── design-summary.md          ← This file
├── ui-design-spec.md          ← Complete UI spec (authoritative)
├── learning-model-design.md   ← Learning/retention model (authoritative)
├── flashcard-design.md        ← Flashcard deep spec (authoritative)
├── CLEANUP.md                 ← Supabase cleanup guide
└── reviews/
    └── (cross-check review outputs)

scripts/
├── copilot-review.sh          ← Cross-check via GPT-5.4
└── cleanup_storage.py         ← Supabase cleanup
```
