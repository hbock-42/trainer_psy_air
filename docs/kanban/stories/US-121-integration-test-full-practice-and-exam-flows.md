---
id: US-121
issue: 76
title: "Integration test: full practice and exam flows"
type: story
epic: EPIC-12
status: done
priority: P1
size: M
lane: core
depends_on: [US-052,US-062]
labels: [quality]
---

# US-121 — Integration test: full practice and exam flows

- [x] `integration_test/` runs onboarding → quick practice → summary → short exam blueprint → report → dashboard shows data
- [x] Runs headlessly in CI on every PR (`integration` job, `.github/workflows/ci.yml`), not gated behind
      a `build` label or nightly — no Android emulator: `flutter test integration_test -d flutter-tester`
      is enough for this widgets-only app (see `docs/TESTING.md`, "Integration test", for why)
