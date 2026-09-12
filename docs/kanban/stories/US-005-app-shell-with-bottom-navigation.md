---
id: US-005
issue: 18
title: "App shell with bottom navigation"
type: story
epic: EPIC-01
status: done
priority: P0
size: S
lane: core
depends_on: [US-002,US-003]
labels: [ui]
---

# US-005 — App shell with bottom navigation

**As a** user **I want** five tabs — Learn, Train, Exam, Progress, Settings — **so that** I always know where I am.

## Acceptance criteria
- [x] `StatefulShellRoute` with 5 branches, state preserved per tab
- [x] Placeholder screens with the tab name; each feature later replaces its own placeholder
- [x] Home/Learn tab shows the "unofficial trainer, not affiliated with Air France" disclaimer (see US-080)
- [x] Widget test: tapping each tab shows its screen

## Notes
- `AppTabBar` (`lib/shared/widgets/app_tab_bar.dart`): design-system tab bar built on `AppPressable`
  (hover / focus / pressed / selected states, 48 dp targets, semantics, 1.3x text). Bottom bar under
  900 dp, left rail from 900 dp (tablet, desktop, web).
- `AppShell` = `AppScaffold` + `AppTabBar` + `StatefulNavigationShell`; re-tapping the active tab
  resets it to its root (`goBranch(initialLocation: true)`); branch stacks survive tab switches.
- Strings are French constants in `lib/core/l10n/strings.dart` (`AppStrings`) until US-091. The
  disclaimer is the FR text of `docs/content/psy0-spec.md` §7 (short line + full paragraphs).
- The root `builder` in `lib/app.dart` now installs `AppThemeScope` (as `docs/DESIGN_SYSTEM.md`
  prescribes); light/dark follows the platform brightness until US-091 adds a setting.
- Tests: `test/shared/widgets/app_tab_bar_test.dart`, `test/core/router/app_shell_test.dart`.
