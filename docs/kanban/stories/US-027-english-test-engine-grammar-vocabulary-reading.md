---
id: US-027
title: "English test engine (grammar, vocabulary, reading)"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: S
lane: engines
depends_on: [US-021]
labels: [engine,content-driven]
---

# US-027 — English test engine (grammar, vocabulary, reading)

**As a** candidate **I want** English MCQs including reading passages **so that** I can prepare the English part of PSY0.

## Acceptance criteria
- [ ] Uses `BankSource` of `McqItem`s tagged `english.grammar|vocab|reading`
- [ ] Reading comprehension: passage shown in a scrollable panel above 3–5 linked questions
- [ ] Optional audio stimulus support in the model (listening), rendering can be P2
- [ ] Item sampling balances sub-tags and avoids items seen in the last N sessions
Content itself: US-082.
