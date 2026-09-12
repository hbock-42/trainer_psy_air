---
id: US-111
issue: 73
title: "PSY2: interview preparation (question bank, self-recording, rubric)"
type: story
epic: EPIC-11
status: backlog
priority: P2
size: M
lane: learn-ui
depends_on: [US-110,US-041]
labels: [psy2,learn]
---

# US-111 — PSY2: interview preparation (question bank, self-recording, rubric)

From `docs/content/psy2-spec.md` "app scope".
- [ ] Content: 7 themes × ~10 original questions (from the spec), guidance per theme (what evaluators look for, STAR structure), model-answer skeletons — as a new content kind `interview_questions` (schema + parser + validator) under the `psy2` module, or as lessons + a deck if simpler (document)
- [ ] Interview practice screen: pick a theme, random question, 45 s prep + 2 min answer timer, audio self-recording (`record` package if Material-free; else timer-only) with playback, then a self-assessment rubric (clarity, structure, examples, CRM vocabulary, duration) stored as a session; history of practised questions and self-scores in Progress
- [ ] Learn home shows the PSY2 module (module switch from US-101) with "Entretien" and "Exercice de groupe" entries
- [ ] Tests: content parses, timer flow, rubric persisted
