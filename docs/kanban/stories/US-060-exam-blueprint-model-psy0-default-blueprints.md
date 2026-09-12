---
id: US-060
issue: 45
title: "Exam blueprint model & PSY0 default blueprints"
type: story
epic: EPIC-06
status: done
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
- [x] `assets/content/psy0/blueprints/psy0_full.json` transcribed from spec §3.1 (14 sections, order, item counts, section/per-item time, cadence, scoring policy), every value tagged with its `confidence`
- [x] `psy0_short.json` (~20 min) from spec §3.2
- [x] Sections for activities not yet implemented are allowed: the exam runner skips them with a "not available yet" briefing (so the sim is usable from the first engines)
- [x] Validated by US-014

Verified in US-061: both blueprints re-checked against §3.1/§3.2 and re-run through
`make content-check` — 0 errors/warnings, every section's `familyId` matches an
existing family folder, every generated section resolves a real `GeneratorId` with
valid `params`, and every section carries a `confidence`. Nothing needed fixing;
the 16 JSON sections of `psy0_full` map to the spec's 14 numbered activities
because English is split into reading/listening/speaking (14a/14b/14c in the
spec itself). The exam runner (`planExamSections`) skips any section whose
`familyId` has no registered engine.
