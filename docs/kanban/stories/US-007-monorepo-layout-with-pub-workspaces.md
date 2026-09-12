---
id: US-007
issue: 112
title: "Monorepo layout with pub workspaces"
type: story
epic: EPIC-01
status: backlog
priority: P0
size: M
lane: core
depends_on: [US-001,US-020]
labels: [setup,monorepo,blocking]
---

# US-007 — Monorepo layout with pub workspaces

**As a** team **we want** a monorepo from the start **so that** a future backend, remote-DB client and shared Dart packages live next to the app with one toolchain.

## Layout
```
apps/psy_trainer/        Flutter app (lib, test, platforms, assets/content, Makefile targets)
packages/psy_content/    pure Dart: content models + ContentBundleParser + docs/content schemas + validator
tools/                   repo-wide scripts (coverage gate, list_content_assets, kanban board)
docs/, .github/          unchanged
```
Later: `apps/api/` (Dart backend), `packages/psy_api_client/`, `packages/psy_engine/` (pure-Dart engine domain) — not now.

## Acceptance criteria
- [ ] Root `pubspec.yaml` with `workspace:` listing every member; each member has `resolution: workspace`; single lock file at root; `dart pub get` at root resolves everything
- [ ] `melos.yaml` (Melos ≥ 7, uses pub workspaces) with scripts: `analyze`, `format`, `test`, `build:web`, `content:check` — or a root `Makefile` delegating per package if Melos adds friction (document the choice)
- [ ] `lib/core/content/**` + `docs/content/schema/**` + `tool/validate_content.dart` + `tool/content_validator/**` moved into `packages/psy_content` (`package:psy_content/psy_content.dart`), app imports updated; no Flutter dependency in that package (enforced by its own test)
- [ ] App moved to `apps/psy_trainer` with `git mv` (history preserved); assets registered relative to the app; `tool/list_content_assets.dart` updated
- [ ] CI runs at root: pub get once, `melos run analyze/format/test`, coverage gate over the app + packages, web build, content validator — green
- [ ] Architecture tests updated (paths); `docs/ARCHITECTURE.md` + `README.md` + `docs/TESTING.md` + `docs/content/AUTHORING.md` reflect the layout; "how to add a package" section
- [ ] `docs/kanban/gen_board.sh`, `.gitattributes`, `Makefile` still work from the root
