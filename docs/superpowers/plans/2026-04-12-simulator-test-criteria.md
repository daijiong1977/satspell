# iPhone Simulator Test Criteria — Detailed Pass/Fail

Every test scenario describes exactly **what the tester sees on screen** and what counts as PASS or FAIL.

**Simulators to test on:**
- iPhone 16 Pro Max (430pt wide) — primary
- iPhone SE 3rd gen (375pt wide) — compact layout validation

---

## Test S1: First Launch

### S1.1: App Opens to Practice Tab

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Install fresh app, tap to open | Loading spinner briefly | Spinner visible < 3 seconds |
| 2 | Wait for import to complete | Practice tab appears | Tab bar shows 4 tabs: Map, Practice, Stats, Profile |
| 3 | Observe Practice tab content | Morning Session card visible | Card shows: ☀️ icon, "Morning Session", "Learn 11 new words · ~16 min", green START button |
| 4 | Check Evening card | Evening card below morning | Card shows: 🌙 icon, "Evening Session", locked state with "Let it marinate" message |
| 5 | Check header | Day + streak + XP badges | Shows "Day 1", "🔥 0", "⚡ 0" |

**PASS:** All 5 checks above are visible. No crashes, no blank screen, no error messages.
**FAIL:** Crash on launch, blank screen, missing cards, wrong day number, import error shown.

### S1.2: All Tabs Accessible

| Step | Action | Expected Screen |
|------|--------|----------------|
| 1 | Tap "Map" tab | Adventure map with Zone 1 visible, Day 1 node highlighted |
| 2 | Tap "Stats" tab | "Your Progress" with all zeros (streak 0, XP 0, 0 words) |
| 3 | Tap "Profile" tab | Profile screen with "Share Today's Progress" button |
| 4 | Tap "Practice" tab | Back to morning session card |

**PASS:** All 4 tabs navigate without crash. Each shows appropriate empty/initial state.

---

## Test S2: Morning Session — Complete Flow

### S2.1: Start Morning Session

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap green START button | Session starts, tab bar hidden | "STEP 1 OF 3 · 👁️ EXPOSURE" header visible |
| 2 | Observe flashcard | Image fills screen, sentence at bottom | Word highlighted in gold within sentence, "tap to flip" hint visible |
| 3 | Check progress | "1/11" in glass pill | Progress shows correct count |

### S2.2: Flashcard Interaction

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap card to flip | 3D flip animation, back side shows | Definition, example, collocations, Word Strength meter visible |
| 2 | Check Word Strength | 5-segment bar under word | All segments empty (new word, box 0) |
| 3 | Tap "GOT IT →" | Next card appears (front side) | Progress updates to "2/11" |
| 4 | Tap card, tap "SHOW AGAIN" | Card slides to back of deck | Progress stays, card re-queued |
| 5 | Continue through all 11 cards | Show Again cards appear at end | Re-queued cards show again before step ends |
| 6 | After last card | Step Transition screen | "Step 1 Complete!" with 🎉, dot 1 filled, "Next: Image Practice" shown |

**PASS:** All 11 cards viewable. Flip works. Got It advances. Show Again re-queues. Transition shows.
**FAIL:** Card doesn't flip, progress doesn't update, Show Again cards don't reappear, crash.

### S2.3: Image Game

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap CONTINUE on transition | Image Game starts | "STEP 2 OF 3 · 📊 SCORED" header, green progress bar |
| 2 | Observe round | Image + cloze sentence + 2×2 grid | 4 word choices visible, blank in sentence highlighted gold |
| 3 | Tap CORRECT answer | Card turns green, "+10 XP" chip appears | XP chip arcs to header (or brief animation), auto-advance after ~1.5s |
| 4 | Tap WRONG answer | Card turns red, correct card highlighted green | Microcopy toast (e.g., "That word is fighting back."), auto-advance after ~2.5s |
| 5 | Check Show Again words | Words from step 1 Show Again appear as rounds | "FROM STEP 1" badge on these rounds |
| 6 | Complete all 12 rounds | Step Transition | "Step 2 Complete!" with 💪, dots 1-2 filled |

**PASS:** Correct/wrong feedback works. XP animation visible. Auto-advance works. Show Again words appear.
**FAIL:** No feedback on answer, stuck (no auto-advance), XP not shown, crash.

### S2.4: SAT Question

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap CONTINUE | SAT Question view | "STEP 3 OF 3 · 📊 SCORED" header, orange progress bar |
| 2 | Observe layout | Split scroll: passage top, question bottom | Passage in warm yellow card, scrollable. Question with A/B/C/D below. |
| 3 | Scroll passage | Passage scrolls, question stays fixed | Two independent scroll areas |
| 4 | Tap an answer option | Option highlights blue (circle fills) | CHECK button turns green |
| 5 | Tap CHECK | Bottom sheet slides up with feedback | "✓ Correct!" or "✗ Not quite." with explanation |
| 6 | Tap NEXT | Next question or Session Complete | Progress updates |
| 7 | Complete all 3 questions | Session Complete screen | 🎉 celebration |

**PASS:** Split scroll works. Answer selection highlights. CHECK shows feedback sheet. Explanation visible.
**FAIL:** Passage and question scroll together, no feedback sheet, CHECK doesn't work.

### S2.5: Session Complete

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Session ends | Celebration screen | "Done. Your brain just leveled up." or similar microcopy |
| 2 | Check stats | XP, streak, words | Shows correct XP earned, streak=1 (or 0 if first), word count |
| 3 | Check box moves | Promoted/demoted counts | "↑ X promoted · ↓ Y need practice" |
| 4 | Tap "SHARE TODAY'S PROGRESS" | iOS share sheet opens | Report card image generated, share options shown |
| 5 | Cancel share, tap DONE | Returns to Practice tab | Morning card now shows ✓, Evening card visible (locked with time) |

**PASS:** All stats correct. Share generates image. Practice tab updates to State C (morning done, evening locked).
**FAIL:** Wrong XP count, share crashes, Practice tab doesn't update.

---

## Test S3: Evening Session

### S3.1: Evening Lock Timer

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Complete morning, check evening card | Evening card shows lock | "Unlocks at [time]" displayed. Time = morning_complete + 4hr or 5PM. |
| 2 | Wait for unlock (or set simulator clock forward) | Evening card becomes active | Green border, START button enabled, lock icon gone |

**To simulate time advance:** In Simulator → Features → Toggle Appearances, or set device time in Settings → General → Date & Time.

### S3.2: Quick Recall (New Activity)

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Start evening, complete flashcards | Quick Recall starts | "STEP 2 OF 4 · 📊 SCORED" header, purple progress bar |
| 2 | Observe word | Large word centered, "from this morning" label | Word is one learned this morning, purple label visible |
| 3 | Tap correct definition | Card flashes green, auto-advance ~1s | Fast — noticeably quicker than image game |
| 4 | Tap wrong definition | Card flashes red, correct highlighted | Auto-advance ~2s |
| 5 | Complete all 11 words | Step transition | "Step 2 Complete!" |

**PASS:** Words match morning session. Purple theme consistent. Fast-paced feel. Correct/wrong feedback clear.
**FAIL:** Words don't match morning, feedback missing, stuck on a word.

### S3.3: Day Complete

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Complete evening session | Session Complete | Shows combined day XP, streak updated |
| 2 | Return to Practice tab | State E: Both Complete | Both ✓ cards, daily summary row, Share + Bonus Practice buttons |
| 3 | Check Map tab | Day 1 node shows ☀️🌙 both filled | Session indicators visible under the day node |

**PASS:** Both sessions shown complete. Daily summary accurate. Map updates.

---

## Test S4: Pause & Resume

### S4.1: Pause Mid-Flashcard

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Start morning, view 3/11 flashcards | At card 3 | Progress shows "3/11" |
| 2 | Tap ✕ (close button) | Pause bottom sheet slides up | Shows "Pause Session?", progress "3/11", "8 words remaining" |
| 3 | Tap "KEEP GOING" | Sheet dismisses, back to card 3 | Same card, same progress — nothing lost |
| 4 | Tap ✕ again, tap "PAUSE & EXIT" | Returns to Practice tab | Resume card (gold border) shows "Paused at Step 1: Flashcards · 3/11" |

### S4.2: Resume After Pause

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | See Resume card on Practice tab | Gold card with ▶️ | Shows step/item progress, RESUME button |
| 2 | Tap RESUME | Returns to session at card 4 | Not card 1 — picks up exactly where paused |
| 3 | Complete remaining cards | Session continues normally | Step transition works after resumed cards |

### S4.3: Kill App and Relaunch

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Pause session (or just swipe app away) | App killed | — |
| 2 | Relaunch app | Practice tab with Resume card | Same paused state preserved across app kill |
| 3 | Tap RESUME | Returns to exact position | Step index + item index correct |

**PASS:** Pause saves state. Resume restores exact position. App kill doesn't lose progress.
**FAIL:** Resume starts from beginning, progress lost, wrong card shown.

---

## Test S5: Adventure Map

### S5.1: Map Display

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap Map tab | Zone 1 visible | Zone title "🌿 ZONE 1 — Foundation", zone progress bar |
| 2 | Check Day 1 node | Current day highlighted | Gold ⭐ with pulse glow (if not started), or session dots |
| 3 | Check Day 4 node | Zone test node | 🏆 trophy icon, labeled "TEST" (not "Day 4") |
| 4 | Check Days 2-3 | Available but not current | Green circles, smaller than current |
| 5 | Tap left/right chevrons | Navigate between zones | Zone 2+ locked with gray nodes |

### S5.2: Map After Completing Day 1

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Complete Day 1 (both sessions) | Return to map | Day 1 node: green ✓, ☀️🌙 both filled |
| 2 | Check Day 2 | Now the current day | Gold ⭐ with pulse |

**PASS:** Nodes update to reflect completion. Session dots show correctly. Zone test has trophy.

---

## Test S6: Stats Tab

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Complete a session, go to Stats | Stats tab | Hero tiles show non-zero: streak, XP, words |
| 2 | Check Word Mastery bar | Stacked color bar | Shows segments: Locked In (red), Rising (orange), etc. |
| 3 | Check weekly calendar | Current week | Today marked with ☀️ or ✓, other days empty |
| 4 | Check Words Fighting Back | List of stubborn words (if any) | Shows word + miss count (display only, not tappable in V1) |

**PASS:** All sections show data matching actual progress. No zeros after studying.

---

## Test S7: Profile & Report

| Step | Action | Expected Screen | Pass Criteria |
|------|--------|----------------|---------------|
| 1 | Tap Profile tab | Profile screen | Name, day/zone info, Share button, notification toggles |
| 2 | Tap "Share Today's Progress" | iOS share sheet | Report card image visible in share preview |
| 3 | Check report card | Image content | Shows: sessions ✓✓, streak, time, accuracy %, mastery bar, stubborn words |
| 4 | Share via Messages (or save to Photos) | Report delivered | Image saves/sends correctly |

**PASS:** Report generates as image. All stats accurate. Share sheet works.

---

## Test S8: iPhone SE Layout

Run all above tests on iPhone SE simulator (375pt). Additional checks:

| Check | Pass Criteria |
|-------|---------------|
| Flashcard sentence text | Readable at 13pt minimum, doesn't overflow |
| Image game 2×2 grid | All 4 buttons visible without scrolling, tap targets ≥ 44pt |
| SAT passage area | At least 35% of screen, scrollable |
| Session header | All elements fit (✕, step label, progress bar) |
| Practice tab cards | Both morning + evening cards visible without scrolling |
| Tab bar labels | All 4 labels readable, not truncated |
| Word Strength meter | Visible on card back, not clipped |

**PASS:** All content visible and tappable on SE. Nothing cut off, nothing unreadable.
**FAIL:** Text truncated, buttons too small to tap, content clipped, overlapping elements.

---

## Test Execution Checklist

Run in this order on iPhone 16 Pro Max first, then iPhone SE:

- [ ] S1.1: First launch → Practice tab
- [ ] S1.2: All tabs accessible
- [ ] S2.1: Start morning session
- [ ] S2.2: Flashcard interaction (flip, Got It, Show Again)
- [ ] S2.3: Image game (correct, wrong, Show Again priority)
- [ ] S2.4: SAT question (split scroll, CHECK, feedback)
- [ ] S2.5: Session complete (stats, share, practice tab updates)
- [ ] S3.1: Evening lock timer
- [ ] S3.2: Quick recall (purple, fast-paced)
- [ ] S3.3: Day complete (both sessions, map updates)
- [ ] S4.1: Pause mid-flashcard
- [ ] S4.2: Resume after pause
- [ ] S4.3: Kill app and relaunch
- [ ] S5.1: Map display (nodes, zones, trophy)
- [ ] S5.2: Map after Day 1 complete
- [ ] S6: Stats tab (hero tiles, mastery bar, calendar)
- [ ] S7: Profile & report sharing
- [ ] S8: iPhone SE layout check

**Total: 18 test scenarios, ~80 individual checks.**
