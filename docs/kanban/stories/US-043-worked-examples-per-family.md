---
id: US-043
issue: 38
title: "Worked examples per family"
type: story
epic: EPIC-04
status: review
priority: P1
size: S
lane: learn-ui
depends_on: [US-041]
labels: [learn,content]
---

# US-043 — Worked examples per family

**As a** candidate **I want** step-by-step solved examples **so that** I see the method applied.

## Acceptance criteria
- [x] Reveal-step-by-step widget (tap to show next step): `RevealSteps`, driven by `## Exemple guidé n`
  sections in the lesson markdown (the `[!EXAMPLE]` statement stays visible; each `### Étape n` is
  revealed by "Étape suivante", plus a "Tout afficher" shortcut)
- [ ] At least 3 worked examples per family in content — content authoring, tracked in US-081; out of
  scope here (this card is the viewer). Every real lesson under `assets/content/psy0/lessons/`
  already parses and renders through `RevealSteps` without error (see
  `test/shared/widgets/markdown/real_lessons_test.dart`)
