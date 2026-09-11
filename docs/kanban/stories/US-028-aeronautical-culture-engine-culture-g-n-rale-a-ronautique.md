---
id: US-028
issue: 32
title: "Aeronautical culture engine (Culture générale aéronautique)"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: S
lane: engines
depends_on: [US-021]
labels: [engine,content-driven,mvp]
---

# US-028 — Aeronautical culture engine (Culture générale aéronautique)

**As a** candidate **I want** to drill the culture MCQ **so that** I am not caught out by the activity candidates fear most.

Real test (spec §2.4-N): 48 single-answer MCQ (4 options), one per screen, no back, ~18 s each (Sept 2026); topics = BIA/PPL theory + aviation history + airports/codes + geography + Air France/Transavia facts + the cadet path. Historically +3/−1/0 with "je ne sais pas"; 2026 instruction silent on negative marking.

## Acceptance criteria
- [ ] Uses `BankSource` of `McqItem`s tagged `culture.<topic>` (14 topic areas from the spec) with balanced sampling across topics
- [ ] Per-item timer 18 s default, no back, auto-advance; optional scoring policy `{+3, −1, 0}` with a "Je ne sais pas" option (realism toggle, US-063)
- [ ] Items carry `validAsOf`; perishable items (fleet counts, CEOs, routes) show their date in the explanation
- [ ] Topic-level stats fed to analytics (weak topics)
Content: US-083.
