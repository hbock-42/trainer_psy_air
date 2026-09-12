---
id: US-116
issue: 173
title: "PSY1: bank-driven engines (reading FR, EFG)"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: S
lane: engines
depends_on: [US-101,US-103]
labels: [engine,content-driven,psy1]
---

# US-116 — PSY1: bank-driven engines (reading FR, EFG)

Spec §2.3-4/6: French reading comprehension (10 texts / 20 min) and EFG mixed reasoning (35 q / 30 min), both MCQ banks.
- [ ] `p1_reading_fr`: `McqRenderer` with the passage resolver (reuse US-027's passage plumbing and passage-aware sampler)
- [ ] `p1_general_efficiency`: `McqRenderer`, tag-balanced sampling
- [ ] Tests: registration, sampling, SessionHost runs
