---
id: US-014
title: "Content validator script (used by authors and CI)"
type: story
epic: EPIC-02
status: backlog
priority: P1
size: S
lane: content-tooling
depends_on: [US-010]
labels: [content,ci,tooling]
---

# US-014 — Content validator script (used by authors and CI)

**As a** content author **I want** a command that validates my JSON **so that** I catch errors without running the app.

## Acceptance criteria
- [ ] `dart run tool/validate_content.dart` validates every file against the JSON schemas
- [ ] Semantic checks: unique ids, `correctIndex` in range, non-empty explanation, referenced images exist, FR text present, difficulty 1–5
- [ ] Prints a per-family summary (item counts by difficulty)
- [ ] Wired into CI (US-004)
