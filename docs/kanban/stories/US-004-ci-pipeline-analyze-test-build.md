---
id: US-004
title: "CI pipeline (analyze, test, build)"
type: story
epic: EPIC-01
status: backlog
priority: P1
size: S
lane: core
depends_on: [US-001]
labels: [setup,ci]
---

# US-004 — CI pipeline (analyze, test, build)

**As a** developer **I want** GitHub Actions to run on every PR **so that** parallel work does not break main.

## Acceptance criteria
- [ ] Workflow: `flutter pub get`, codegen, `flutter analyze`, `flutter test --coverage`
- [ ] Debug APK built as artifact on main
- [ ] Content validation (US-014) added to the pipeline once available
- [ ] Branch protection on `main` requires green CI
