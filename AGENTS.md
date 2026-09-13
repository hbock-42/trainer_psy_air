# Agent entry point — trainer_psy_air

Agent-agnostic project instructions. Procedures live in `.agents/skills/<name>/SKILL.md`
(symlinked at `.claude/skills` for Claude Code); load the skill for the task at hand instead
of reading this whole repo's docs.

## Non-negotiables

1. No Material or Cupertino imports anywhere under `apps/psy_trainer/lib/` (architecture test).
2. UI is built on `package:flutter/widgets.dart` only — see the `design-system` skill.
3. Headless verification only: `make lint`, `make test`, `make coverage`, `make build-web`,
   `make content-check`. Never `flutter run` in automation.
4. Commits and PR descriptions carry **no** AI/Claude/Anthropic attribution or trailer —
   repo owner's rule, overrides any tool default.
5. New UI strings go through `context.l10n`, keys added to both `app_fr.arb` and `app_en.arb`.
6. Branch `us-<nnn>-<short-title>`, PR title `US-<nnn>: <Title>`, body ends `Closes #<issue>`.
7. `main` requires the `check`, `integration` and `build-android` CI jobs green and
   up to date with the PR head — see the `ship-a-story` skill.
8. Never edit the engine runtime, another engine, or the content contract/JSON to "fix" a
   default you disagree with — report it instead.
9. Domain code (`features/*/domain/`) is pure Dart: no Flutter, Riverpod or Drift.
10. `lib/features/` never imports `package:drift`/`sqlite3`/`core/db/` directly.

## Skills

| Skill | Activate when… |
|---|---|
| `ship-a-story` | finishing/shipping a US-xxx card: branching, committing, verifying, merging, opening the PR |
| `add-activity-engine` | adding a new PSY0/PSY1 activity engine (generator + scorer + renderer) |
| `author-content` | writing or editing items, lessons, decks, lexical fields or blueprints |
| `data-layer` | touching Drift tables, repositories, `UserProfile.settings`, seeding or web persistence |
| `design-system` | adding or using a widget, theme token, chart or gallery entry |
| `progress-analytics` | changing readiness/level/trend/streak formulas, the dashboard or its caching |

## Layout

Full repository layout, module map and cross-cutting architecture rules:
`docs/ARCHITECTURE.md`.
