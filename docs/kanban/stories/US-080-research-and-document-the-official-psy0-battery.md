---
id: US-080
issue: 56
title: "Research and document the official PSY0 battery"
type: story
epic: EPIC-08
status: done
priority: P0
size: S
lane: content
depends_on: []
labels: [research,blocking]
---

# US-080 — Research and document the official PSY0 battery

**As a** team **we want** a reliable description of the real PSY0 stage **so that** engines, blueprints and lessons target the right thing.

## Do first — it de-risks the whole project.

## Acceptance criteria
- [x] `docs/content/psy0-spec.md`: selection stages overview (dossier → PSY0 → PSY1 → PSY2 → medical), PSY0 modality (online, proctored?), test families, order, durations, item counts, answer formats, scoring/pass rules — each fact tagged **confirmed** (official source) or **reported** (candidate feedback, forums) or **assumed**
- [x] Sources listed with dates (Air France Cadets site, ENAC/pilot forums, prep books)
- [x] Gaps listed as open questions
- [x] Legal note: trainer is unofficial, no reproduction of copyrighted test material; disclaimer text for the app
- [ ] Reviewed → feeds US-060 blueprint and the family list in EPIC-03

## Outcome (2026-09-11)
Deliverable: [`docs/content/psy0-spec.md`](../../content/psy0-spec.md). Key findings: PSY0 is a ~3 h proctored desktop-app battery of ~14 speeded cognitive mini-games (N-back, tubes, rule-based S-R, parity sequence, overlay grids, dominos, airways, word boxes, arithmetic grids, viewpoint, cube nets, multitask) plus an aeronautical-culture MCQ (48 items in Sept 2026) and an English test (listening + reading + speaking since 2026). No academic maths/physics test. Recommended EPIC-03 changes are in §4 of the spec (add culture aero and multitask families, re-scope US-028/US-026/US-030).
