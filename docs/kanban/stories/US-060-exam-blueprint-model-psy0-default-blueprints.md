---
id: US-060
issue: 45
title: "Exam blueprint model & PSY0 default blueprints"
type: story
epic: EPIC-06
status: backlog
priority: P0
size: S
lane: exam-ui
depends_on: [US-010,US-015,US-080]
labels: [exam,content]
---

# US-060 — Exam blueprint model & PSY0 default blueprints

**As a** candidate **I want** the simulation to follow the real PSY0 structure **so that** the rehearsal is realistic.

## Acceptance criteria
Blueprints drafted in US-015 (`psy0_full.json` / `psy0_short.json` with cadence, scoring policy and per-section confidence, validated by US-014); validate/adjust here.
- [ ] `assets/content/psy0/blueprints/psy0_full.json` transcribed from spec §3.1 (14 sections, order, item counts, section/per-item time, cadence, scoring policy), every value tagged with its `confidence`
- [ ] `psy0_short.json` (~20 min) from spec §3.2
- [ ] Sections for activities not yet implemented are allowed: the exam runner skips them with a "not available yet" briefing (so the sim is usable from the first engines)
- [ ] Validated by US-014
