---
id: US-086
issue: 62
title: "Calibrate activity generators' difficulty"
type: story
epic: EPIC-08
status: review
priority: P1
size: S
lane: content
depends_on: [US-023,US-024,US-026,US-029,US-031]
labels: [content,tuning]
---

# US-086 — Calibrate activity generators' difficulty

- [ ] Play-test each generator at each difficulty with 2–3 people; record accuracy/time; compare with Pilotest-style stanine targets reported in the spec (not automatable; listed as a follow-up in `docs/content/difficulty.md` with a concrete plan once US-084's seed banks exist)
- [x] Adjust parameters so difficulty 3 ≈ reported real-test level; document in `docs/content/difficulty.md` (headless harness `apps/psy_trainer/tool/calibration/calibrate.dart`, N=200/difficulty/generator; every measured generator already lands difficulty 3 on its real-test default, confirmed monotonic/well-spread 1..5 except two documented gaps left as follow-ups)
