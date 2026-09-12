---
id: EPIC-10
issue: 10
title: "PSY1 trainer"
type: epic
status: backlog
priority: P2
lane: engines
---

# EPIC-10 — PSY1 trainer

Second selection stage: one in-person day at ENAC Toulouse (~70 % elimination), ~13 computer-based
activity families ending with an 18-minute two-joystick psychomotor test — see
`docs/content/psy1-spec.md` (US-100). All non-psychomotor activities reuse the PSY0 engine runtime;
the psychomotor test needs a gamepad input abstraction.

## Activities → stories
| # | Family id | Activity | Story |
|---|---|---|---|
| 1 | `p1_math_word_problems` | Mathématiques (word problems, scratch paper) | US-104 |
| 2 | `p1_tangram` | Tangram (composition / occurrence count) | US-109 |
| 3 | `p1_attention_sustained` | Attention soutenue | US-115 |
| 4 | `p1_reading_fr` | Compréhension de lecture (FR) | US-116 (bank) + US-103 (content) |
| 5 | `p1_angles` | Angles à saisir (multi-select) | US-114 |
| 6 | `p1_general_efficiency` | EFG mixed reasoning | US-116 (bank) + US-103 (content) |
| 7 | `p1_counters` | Lecture de compteurs (gauges) | US-113 |
| 8 | `p1_cube_nets` / `p1_cube_rotation` | Cubes: rune alphabet variant + rotation matching | US-108 |
| 9 | `p1_wm_reverse_span` | Mémoire de travail I (reverse digits) | US-106 |
| 10 | `p1_wm_calc_back` | Mémoire de travail II (calc memory back) | US-106 |
| 11 | `p1_raven_matrices` | Matrices progressives | US-107 |
| 12 | `p1_mental_arithmetic` | Calcul mental 1–4 (4 answer modes) | US-105 |
| 13 | `p1_psychomotor` | Psychomoteur (2 joysticks + numpad, 6 × 3 min) | US-102 |

## Order
US-101 (module + contract) first; then engines in parallel; US-102 last; US-103 content in parallel.
