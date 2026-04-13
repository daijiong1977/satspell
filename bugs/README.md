# WordScholar Bug Tracker

## How to Use

Each bug is a markdown file: `bugs/BUG-NNNN.md`

### Bug File Template
```markdown
# BUG-NNNN: Short title

**Status:** OPEN | IN_PROGRESS | FIXED | WONTFIX
**Severity:** P0 (crash) | P1 (broken feature) | P2 (wrong behavior) | P3 (cosmetic)
**Reported:** YYYY-MM-DD
**Fixed in:** commit hash or version
**Reporter:** name

## Description
What's wrong.

## Steps to Reproduce
1. Step one
2. Step two
3. Expected: ...
4. Actual: ...

## Root Cause
(filled when investigated)

## Fix
(filled when fixed — what was changed and why)

## Files Changed
- `path/to/file.swift`
```

### Bug Index
See `bugs/INDEX.md` for the full list with status.

### Versioning
- v1.0.0 — Initial release
- Each commit message references bug IDs when fixing: `fix(BUG-0012): description`
