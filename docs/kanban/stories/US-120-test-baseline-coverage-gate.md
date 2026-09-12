---
id: US-120
issue: 75
title: "Test baseline & coverage gate"
type: story
epic: EPIC-12
status: done
priority: P1
size: S
lane: core
depends_on: [US-004]
labels: [quality,ci]
---

# US-120 — Test baseline & coverage gate

- [x] Coverage report in CI, threshold 70 % on `domain/` and `data/`, golden tests for key widgets
  - `make coverage` = `flutter test --coverage` + `dart run tool/coverage_gate.dart --min 70` (gates `lib/features/**/{domain,data}` and `lib/core`, excludes generated files, skips with exit 0 while nothing is measured there); CI wiring (US-004) calls the same two commands
  - Golden harness in `test/helpers/golden_config.dart`, first golden of the placeholder root screen in `test/goldens/`; goldens for real screens come with each screen's story
- [x] `docs/TESTING.md`: what to test where (unit / widget / integration)
