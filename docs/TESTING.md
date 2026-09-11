# Testing

How we test the PSY Trainer app: what goes where, how to run it, and the coverage gate CI
enforces. Established in US-120; amend when the policy changes.

## Pyramid

| Level | What | Where | Tooling |
|---|---|---|---|
| **Unit** | `domain/` state machines, test generators, scoring, blueprints, repository interfaces; pure Dart, no Flutter | `test/features/<feature>/domain/` | `flutter_test` (`test()`), `fake_async` for time |
| **DAO / data** | Drift DAOs and repository implementations against an **in-memory** database; JSON loaders and mappers against fixture files | `test/features/<feature>/data/`, `test/core/db/` | `NativeDatabase.memory()` from `drift/native.dart` |
| **Widget** | `presentation/` screens and `shared/` widgets: rendering, interaction, provider wiring, goldens for key screens | `test/features/<feature>/presentation/`, `test/shared/` | `testWidgets` + `pumpApp` helper, goldens via `golden_config.dart` |
| **Integration** | End-to-end flows on a device/emulator: run a practice session, sit an exam, see the summary | `integration_test/` (US-121) | `integration_test` package |
| **Architecture** | Rules about the codebase itself (no Material/Cupertino, layer dependencies) | `test/architecture/` | plain `test()` scanning `lib/` |

Most tests should be unit tests: the engines and state machines are where the product risk
lives, and they run in milliseconds. Widget tests cover behaviour a user can see; do not
re-test domain logic through the UI. Integration tests are few and cover whole flows.

## Layout and naming

```
test/
  app_test.dart                       # smoke test of the root widget
  app_golden_test.dart                # golden of the root/placeholder screen
  architecture/                       # codebase rules
  core/                               # mirrors lib/core
  features/<feature>/{domain,data,presentation}/   # mirrors lib/features
  shared/                             # mirrors lib/shared
  helpers/                            # pumpApp, golden config, fakes shared by tests
  fixtures/                           # shared data files (JSON content samples, lcov...)
  goldens/                            # committed golden PNGs
  tool/                               # tests for scripts under tool/
integration_test/                     # device-driven flow tests (US-121)
```

- A test file mirrors the path of the file it covers and is named `<file>_test.dart`
  (`lib/features/train/domain/session_state_machine.dart` ->
  `test/features/train/domain/session_state_machine_test.dart`).
- Test names are sentences describing behaviour: `'advances to the next item after an answer'`,
  not `'test1'` or `'nextItem'`. Group by method/scenario with `group()`.
- Fixtures used by one test live next to it in a `fixtures/` sub-folder
  (`test/tool/fixtures/`); fixtures shared across features go in `test/fixtures/`. Read them
  relative to the package root (`File('test/fixtures/x.json')`): `flutter test` always runs
  from there.
- Fakes and stubs shared by several tests go in `test/helpers/`; a fake used by one test stays
  in that file.
- Golden PNGs are named after the screen/widget and variant: `practice_summary.png`,
  `practice_summary_large_text.png`.

## Running

```
make test            # flutter test
make test-watch      # re-run on change (needs entr or fswatch)
make coverage        # flutter test --coverage + coverage gate (see below)
flutter test test/features/train              # one folder
flutter test --name 'advances to'             # by test name
flutter test --update-goldens test/app_golden_test.dart   # regenerate goldens
```

`make lint` and `make test` must be green before opening a PR; CI runs them plus
`make coverage`.

## Coverage gate

`make coverage` runs `flutter test --coverage`, which writes `coverage/lcov.info`, then
`dart run tool/coverage_gate.dart --min 70`. The gate:

- computes line coverage overall (informational) and for the **gated paths**
  `lib/features/**/domain/**`, `lib/features/**/data/**` and `lib/core/**`;
- excludes generated files (`*.g.dart`, `*.freezed.dart`, `*.drift.dart`) from both numbers;
- fails with exit code 1 when gated coverage is below the threshold (70 % by default,
  `--min` to change; `--file` to point at another lcov);
- prints a notice and exits 0 when the gated paths have no measured lines at all (the early
  project state), so CI is green before the first engine lands.

`presentation/`, `shared/` and `app.dart` are measured but not gated: widget coverage is a
poor proxy for UI quality, and goldens and integration tests cover those. Keep gated coverage
well above 70 % rather than at it; the threshold is a floor, not a target.

The gate itself is unit-tested in `test/tool/coverage_gate_test.dart` on lcov fixtures.

To read coverage locally, `brew install lcov` then `genhtml coverage/lcov.info -o coverage/html`
and open `coverage/html/index.html`. The `coverage/` folder is git-ignored.

## Widget tests without Material

The app is built on `package:flutter/widgets.dart` only. There is no `MaterialApp` to give
widgets a `Directionality`, `MediaQuery` or `DefaultTextStyle`, and **test helpers must not
import `material.dart` or `cupertino.dart` either** (the architecture test only scans `lib/`,
but the rule applies to `test/` by convention: a Material ancestor in a test would hide a
missing ancestor in the app).

Use `pumpApp` from `test/helpers/pump_app.dart`:

```dart
import '../../../helpers/pump_app.dart';

testWidgets('shows the score', (tester) async {
  await pumpApp(
    tester,
    const ScoreTile(score: 42),
    overrides: [scoreRepositoryProvider.overrideWithValue(FakeScoreRepository())],
  );
  expect(find.text('42'), findsOneWidget);
});
```

`pumpApp` wraps the child in `ProviderScope` (with your overrides), `MediaQuery` from the
test view, `Directionality`, the app's `DefaultTextStyle` and a background `ColoredBox`. It
does not install a `Navigator`; tests that need routing pump `PsyTrainerApp` (or the
go_router config once US-002 lands) directly.

Some `flutter_test` finders assume Material: `find.byTooltip` works only with `Tooltip`
(Material), `tester.tap` on a Material button expects ink. Use `find.text`, `find.byKey`,
`find.byType`, `find.bySemanticsLabel` and our own widgets' keys instead.

### Goldens

`test/helpers/golden_config.dart` fixes the surface size (390x844 logical, pixel ratio 1)
and text scale, and points the comparator at `test/goldens/`:

```dart
await pumpGolden(tester, const PracticeSummaryScreen(...), pump: pumpApp);
await expectGolden(tester, 'practice_summary');
```

`flutter test` renders with the bundled Ahem font (solid boxes for every glyph) and the
software rasteriser, so goldens are stable across machines on the same Flutter version.
They can change when Flutter is upgraded: regenerate them in the same PR as the Flutter bump
and review the diffs. Regenerate with `flutter test --update-goldens <file>`; never update a
golden without looking at the new image.

Keep goldens for key screens (one per major screen and per important state), not for every
widget: each PNG is a maintenance cost.

## Testing time

Anything that depends on the clock (exam timers, streaks, spaced repetition due dates,
countdowns) must not call `DateTime.now()` or `Timer` directly.

- **Injected clock.** Domain code takes a `DateTime Function() now` (or a small `Clock`
  interface) in its constructor, defaulting to `DateTime.now`. Tests pass a fixed or stepping
  function. Do not add `package:clock`; a function parameter is enough.
- **`fake_async`.** For code that uses `Timer`, `Future.delayed` or streams driven by time,
  wrap the test body in `fakeAsync((async) { ...; async.elapse(const Duration(seconds: 30)); })`
  from `package:fake_async`. `flutter_test` already runs `testWidgets` inside a `FakeAsync`
  zone; use `tester.pump(const Duration(seconds: 1))` there instead.
- Never `await Future.delayed` in a test to "wait for" something.

## DAO tests

Drift tests open an in-memory database per test so they are isolated and need no files:

```dart
late AppDatabase db;
setUp(() => db = AppDatabase(NativeDatabase.memory()));
tearDown(() => db.close());
```

Test the DAO's public queries (insert then read back, ordering, filtering) and migrations
(`schema` version bumps) rather than SQL details. Use a fixed clock for `createdAt` columns.

## Architecture tests

`test/architecture/` holds tests about the code itself, not its behaviour:

- `no_material_cupertino_test.dart`: fails if anything under `lib/` imports Material or
  Cupertino.
- `no_drift_in_features_test.dart`: `lib/features/` never imports Drift, sqlite3 or `core/db/`.
- `no_flutter_in_domain_test.dart`: `lib/features/*/domain/` never imports Flutter, Riverpod,
  Drift or a `presentation/` folder.
- Add tests here for other rules from `docs/ARCHITECTURE.md` as they become checkable
  (`core/` and `shared/` never import `features/`).

They are cheap, run with the unit suite, and turn a documented convention into a failing test
instead of a review comment.
