---
id: US-004
issue: 17
title: "CI pipeline (analyze, test, build)"
type: story
epic: EPIC-01
status: review
priority: P1
size: S
lane: core
depends_on: [US-001]
labels: [setup,ci]
---

# US-004 — CI pipeline (analyze, test, build)

**As a** developer **I want** GitHub Actions to run on every PR **so that** parallel work does not break main.

## Acceptance criteria
- [x] Workflow: `flutter pub get`, codegen, `flutter analyze`, `flutter test --coverage`
- [x] Debug APK built as artifact on main
- [x] Content validation (US-014) added to the pipeline once available (step runs `tool/validate_content.dart` when the file exists)
- [x] Branch protection on `main` requires green CI (required status check `check`, no required reviews, admins not enforced)
