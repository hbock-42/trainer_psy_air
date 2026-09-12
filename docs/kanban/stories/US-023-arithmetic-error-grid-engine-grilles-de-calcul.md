---
id: US-023
issue: 27
title: "Arithmetic error-grid engine (Grilles de calcul)"
type: story
epic: EPIC-03
status: review
priority: P0
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,mvp]
---

# US-023 — Arithmetic error-grid engine (Grilles de calcul)

**As a** candidate **I want** to drill the *Grilles de calcul* activity **so that** I spot wrong equalities fast and reliably.

Real test (spec §2.4-J): a 3×3 grid of 9 equalities, 0–4 are wrong; click the wrong ones then validate; 8–10 grids, ~45 s each; calculations "simpler than Pilotest".

## Acceptance criteria
- [x] Generator: equalities mixing +, −, ×, ÷ (integer), operator priorities, squares, simple percentages; wrong ones off by plausible errors (±1, ±10, swapped priority, sign); difficulty 1–5 controls operand size and trap subtlety; deterministic per seed
- [x] Renderer: 3×3 tappable grid, toggle-select cells, "Valider" button; per-grid timer; exam mode silent, practice mode shows which cells were right/wrong + why
- [x] Scorer: grid correct only if the selected set equals the wrong set; also reports partial precision/recall for analytics
- [ ] Practice-only extra: free-input mental arithmetic drill with keypad (US-022) — useful for PSY1 later, low priority (out of scope here, tracked under US-022)
- [x] Unit tests on the generator (exactly the announced number of wrong cells, no ambiguous items) and on the scorer
