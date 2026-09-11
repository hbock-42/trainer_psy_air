---
id: US-014
issue: 23
title: "Content validator script (used by authors and CI)"
type: story
epic: EPIC-02
status: review
priority: P1
size: S
lane: content-tooling
depends_on: [US-010]
labels: [content,ci,tooling]
---

# US-014 — Content validator script (used by authors and CI)

**As a** content author **I want** a command that validates my JSON **so that** I catch errors without running the app.

## Acceptance criteria
- [x] `dart run tool/validate_content.dart` validates every file against the JSON schemas
- [x] Semantic checks: unique ids, `correctIndex` in range, non-empty explanation, referenced images exist, FR text present, difficulty 1–5
- [x] Prints a per-family summary (item counts by difficulty)
- [x] Wired into CI (US-004)

## Notes

- Schema validation is generic: `tool/content_validator/schema_registry.dart` loads every
  `docs/content/schema/*.schema.json` (`json_schema` ^5.2, draft 2020-12) and maps a file
  `kind` to the schema declaring `properties.kind.const`. New kinds or fields from a later
  contract version (US-015) need no validator change for the schema layer; semantic rules
  are one small function per kind in `tool/content_validator/semantic_checks.dart`.
- Every file is also fed to `ContentBundleParser`, so the Dart models and the schemas are
  checked against each other on every run.
- A bundle is a folder with a `manifest.json`; cross-file checks run inside it. Files under
  `examples/` (and any file outside a bundle) are validated on their own.
- Flags: `--quiet`, `--json`, `--schema-dir`. `make content-check`. Tests in
  `test/tool/validate_content_test.dart` use the fixture bundles in `test/tool/fixtures/`.
