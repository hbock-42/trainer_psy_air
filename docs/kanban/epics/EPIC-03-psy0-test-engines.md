---
id: EPIC-03
issue: 3
title: "PSY0 test engines"
type: epic
status: backlog
priority: P0
lane: engines
---

# EPIC-03 — PSY0 test engines

The interactive test families that make up the PSY0 online selection stage.
Each family is an independent story so several can be developed in parallel once
the generic engine runtime (US-020) and item renderers (US-021/022) exist.

## PSY0 families (to be confirmed by US-080 research)
| Family | Type | Story |
|---|---|---|
| English (grammar, vocabulary, reading) | content bank | US-027 |
| Maths / physics knowledge (bac level) | content bank | US-028 |
| Mental arithmetic | procedural generator | US-023 |
| Logical reasoning (series, matrices) | generator + assets | US-024 |
| Spatial reasoning (rotations, folding) | procedural | US-025 |
| Memory (digits, patterns, sequences) | procedural | US-026 |
| Verbal reasoning | content bank | US-030 |
| Attention / concentration | procedural | US-029 |

## Stories
US-020 … US-030

## Principle
An engine is *both* usable in Practice mode (instant feedback) and Exam mode (silent, timed).
The engine never decides feedback policy; the session mode does.
