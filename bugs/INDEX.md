# Bug Index — WordScholar

## Open Bugs

| ID | Severity | Title | Status | Reported |
|----|----------|-------|--------|----------|
| BUG-0042 | P1 | Review mode shows only flashcards, not all 3 steps | INVESTIGATING | 2026-04-13 |
| BUG-0043 | P1 | Review mode loses completed morning session status | INVESTIGATING | 2026-04-13 |

## Fixed Bugs (v1.0 — commit ad3497d+)

| ID | Severity | Title | Fixed In |
|----|----------|-------|----------|
| BUG-0001 | P0 | SQLite multi-threaded crash on device | 9387433 |
| BUG-0002 | P0 | Box 0 words promoted mid-session | 9387433 |
| BUG-0003 | P1 | Evening quick recall loads wrong (new) words | c6442fc |
| BUG-0004 | P1 | "Pause & Exit" doesn't dismiss | a5745e7 |
| BUG-0005 | P1 | Blank white sheet on cold launch after killed session | 6255a6f |
| BUG-0006 | P2 | Word count always shows 0 | 5bc7bcd |
| BUG-0007 | P2 | Session completion animation missing | c6f7985 |
| BUG-0008 | P2 | Evening session unlocks immediately | 15d0f09 |
| BUG-0009 | P1 | App kill loses session position | e1ab997 |
| BUG-0010 | P2 | Resume only, no restart option | e1ab997 |
| BUG-0011 | P2 | Morning session disappears during evening | e1ab997 |
| BUG-0012 | P2 | "Day 0" displayed instead of "Day 1" | e1ab997 |
| BUG-0013 | P2 | SAT wrong answers never reported to stats | e1ab997 |
| BUG-0014 | P2 | Map nodes all tappable (future days too) | e1ab997 |
| BUG-0015 | P2 | unlockAllAdventureForTesting left on | e1ab997 |
| BUG-0016 | P2 | Zone test enterable before all days done | e1ab997 |
| BUG-0017 | P2 | Evening unlock fallback after 5PM gives past time | e1ab997 |
| BUG-0018 | P2 | Step transition no auto-advance | e1ab997 |
| BUG-0019 | P2 | Notification toggles UI-only | e1ab997 |
| BUG-0020 | P2 | Session complete share button no-op | e1ab997 |
| BUG-0021 | P2 | Profile missing reset action | e1ab997 |
| BUG-0022 | P2 | Restart doesn't use supersedeSession | e1ab997 |
| BUG-0023 | P2 | No scenePhase background handling | e1ab997 |
| BUG-0024 | P2 | Map day tap shows placeholder text | cab1918 |
| BUG-0025 | P2 | Double header in flashcards | 8744f5e |
| BUG-0026 | P2 | Markdown ** in example sentences | f4d03e1 |
| BUG-0027 | P2 | Empty queue stranded UI | ff5663b |
| BUG-0028 | P3 | Font sizes too small (< 20pt) | 0589b57 |
| BUG-0029 | P2 | Image game photo clipped at top | 0589b57 |
| BUG-0030 | P2 | SAT questions truncated/scrollable | 0589b57 |
| BUG-0031 | P2 | Sound button non-functional | 0589b57 |
| BUG-0032 | P2 | NSLock deadlock on physical device | 0589b57 |
| BUG-0033 | P2 | Widget extension deploy error on device | 0589b57 |
| BUG-0034 | P2 | X button not clickable in Image Game/Quick Recall | ad3497d |
| BUG-0035 | P2 | Image game wrong answer goes straight to next | ad3497d |
| BUG-0036 | P2 | SAT questions show target word in question text | ad3497d |
| BUG-0037 | P2 | Flashcard swipe advances without flipping | ad3497d |
| BUG-0038 | P2 | Image game/quick recall header shows answer word | 0589b57 |
| BUG-0039 | P3 | SAT branding in user-facing text | 964de05 |
| BUG-0040 | P2 | Review overwrites completed session state | ad3497d |
| BUG-0041 | P2 | Review shows only flashcards, not steps 2/3 | ad3497d |

## Content Bugs (separate tracking in content-improvement/)

| ID | Count | Title | Status |
|----|-------|-------|--------|
| CONTENT-001 | 1,313 | Blanks (______) in questions | IN_PROGRESS |
| CONTENT-002 | 140 | Usage contexts missing target word | IN_PROGRESS |
| CONTENT-003 | 7 | Definition/example mismatches | IN_PROGRESS |
| CONTENT-004 | 12 | Questions without answers | IN_PROGRESS |
