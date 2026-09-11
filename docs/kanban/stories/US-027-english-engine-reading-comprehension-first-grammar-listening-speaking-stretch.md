---
id: US-027
issue: 31
title: "English engine: reading comprehension first, grammar, listening/speaking stretch"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-021]
labels: [engine,content-driven,mvp]
---

# US-027 — English engine: reading comprehension first, grammar, listening/speaking stretch

**As a** candidate **I want** TOEIC-like English practice **so that** I am ready for the "anglais renforcé" part of PSY0.

Real test (spec §2.4-O): since 2022, reading comprehension on texts, images and graphs, ~45 MCQ in 30 min, passage re-displayable; since 2026 also listening + recorded speaking (format unknown — open question 1).

## Acceptance criteria
- [ ] `english_reading`: passage panel (text / image / chart) always re-openable, 3–5 linked MCQs, strict section timer (30 min / 45 q default)
- [ ] `english_grammar`: gap-fill MCQ (4 options incl. ∅) — cheap secondary drill
- [ ] `english_listening` (stretch): MCQ with an audio stimulus (`MediaRef` audio), play-once option for realism — only if the model/asset pipeline supports audio; otherwise leave a documented stub
- [ ] `english_speaking` (stretch, practice-only): prompt + 45 s prep + 60 s recording, playback, self-assessment checklist; no automatic scoring
- [ ] Item sampling balances sub-tags and avoids items seen in the last N sessions
Content: US-082.
