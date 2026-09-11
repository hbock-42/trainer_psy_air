---
id: EPIC-03
issue: 3
title: "PSY0 activity engines"
type: epic
status: backlog
priority: P0
lane: engines
---

# EPIC-03 — PSY0 activity engines

The interactive activities that make up the real PSY0 online pre-selection, as documented in
`docs/content/psy0-spec.md` (US-080). PSY0 is **not** an academic MCQ exam: it is ~14 short,
Pilotest-like cognitive games (keyboard + mouse, desktop app), plus an aeronautical-culture MCQ
and an English test. Each activity is an independent story so several can be built in parallel
once the generic runtime (US-020) and the two basic renderers (US-021/022) exist.

## Activities (order of the real test, Sept 2026 — see spec §2.4 / §3.1)
| # | Family id | Activity | Kind | Story | MVP |
|---|---|---|---|---|---|
| 1 | `memory_nback` | N-back (colours / digits, 2- or 3-back) | interactive, fixed cadence | US-026 | ✔ |
| 2 | `planning_tubes` | Billes / éprouvettes — min. number of moves | numeric | US-035 | |
| 3 | `attention_rules` | Formes et couleurs — rule-based key response | interactive, keyboard | US-029 | ✔ |
| 4 | `attention_parity` | Pair / impair — alternating ascending clicks | interactive | US-031 | ✔ |
| 5 | `spatial_overlay` | Formes glissées II — drag tiles, overlay rules | interactive, drag | US-033 | |
| 6 | `logic_dominos` | Dominos — modulo-7 series | choice (2 × 7) | US-024 | ✔ |
| 7 | `attention_airways` | Airways — re-route aircraft, capacity rules | interactive, simulation | US-032 | |
| 8 | `verbal_boxes` | Boîte à mots — semantic categorisation (FR) | interactive, bank | US-030 | |
| 9 | `arithmetic_grid` | Grilles de calcul — flag the wrong equalities | multi-select | US-023 | ✔ |
| 10 | `spatial_viewpoint` | Objets 3D — which viewpoint? | MCQ (8 options) | US-034 | |
| 11 | `spatial_cubes` | Cubes / dés — rebuild the net, drag faces | interactive, drag | US-025 | |
| 12 | `culture_aero` | Culture générale aéronautique — 48 MCQ | MCQ bank | US-028 | ✔ |
| 13 | `multitask_psychomotor` | Multitâche — tracking + shape match + calc check | interactive, keyboard, 5 min | US-036 | |
| 14 | `english_*` | Reading (passages/images/graphs), listening, speaking | MCQ bank / audio / recording | US-027 | ✔ (reading) |

## Principles
- An engine is usable in Practice mode (feedback, explanations) and Exam mode (silent, timed);
  the engine never decides the feedback policy — **except** activities where the real test shows
  live feedback (`attention_rules`, `attention_parity` restart), which keep it in exam mode.
- Every generated activity is reproducible from `(generatorId, seed, params)` (US-015).
- Keyboard-native activities (`attention_rules`, `multitask_psychomotor`) need desktop/web
  targets (US-006); touch adaptations are allowed but labelled "non-representative".
- No Material/Cupertino: all activity UIs are custom widgets on the design system (US-003).

## Stories
US-020 … US-036

## Dropped from the original plan
Academic maths/physics (no such test at PSY0), free-input mental arithmetic (PSY1), digit span,
analogies/syllogisms, generic rotation MCQs, figure matrices (PSY1 — keep for EPIC-10).
