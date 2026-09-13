---
id: US-111
issue: 73
title: "PSY2: interview preparation (question bank, self-recording, rubric)"
type: story
epic: EPIC-11
status: review
priority: P2
size: M
lane: learn-ui
depends_on: [US-110,US-041]
labels: [psy2,learn]
---

# US-111 — PSY2: interview preparation (question bank, self-recording, rubric)

From `docs/content/psy2-spec.md` "app scope".
- [x] Content: 7 themes × 10 original questions (70 total, from the spec), guidance per theme (what evaluators look for, STAR structure), model-answer skeletons — new content kind `interview_questions` (schema + parser + validator) under the `psy2` module, `psy2/interview/questions/*.json`
- [x] Interview practice screen: pick a theme (or random), 45 s prep + 2 min answer timer, self-assessment rubric (structure, concreteness, self-awareness, relevance, delivery per spec §4.1) stored as a `TrainingSession` of family `psy2_interview`; history + average per criterion charted on Progress. Audio self-recording (`record` package) was scoped out — verifying it needs no Material ancestor and builds clean on web/desktop was out of budget, so this ships the documented fallback: timers + a text notes field (`PlainTextArea`/`EditableText`)
- [x] Learn home shows the PSY2 module (module switch from US-101) with "Entretien", "Exercice de groupe" and "Comment se passe le PSY2" entries
- [x] Tests: content parses/seeds, question screen flow + timers (`ManualClock`), rubric persisted and charted, module switch shows the PSY2 entries
