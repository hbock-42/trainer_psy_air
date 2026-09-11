---
id: US-061
title: "Exam runner (strict, timed, silent)"
type: story
epic: EPIC-06
status: backlog
priority: P0
size: L
lane: exam-ui
depends_on: [US-020,US-060,US-021,US-022]
labels: [ui,exam]
---

# US-061 — Exam runner (strict, timed, silent)

**As a** candidate **I want** a full-length timed simulation with no feedback **so that** I experience the real pressure.

## Acceptance criteria
- [ ] Briefing screen per section (instructions, duration, item count) with "Start" — mimics the real flow
- [ ] Section timer + optional per-item timer, auto-advance, no back, no pause; quitting = abort with confirmation
- [ ] Between sections: optional short break with countdown
- [ ] Screen stays awake; interruptions (call, background) handled: timer keeps running, state persisted every attempt
- [ ] Ends on a "Computing results…" screen → US-062
- [ ] Widget/integration test with a 2-section blueprint and fake generators
