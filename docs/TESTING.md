# Testing

How we test the PSY Trainer app: what goes where, how to run it, and the coverage gate CI
enforces. Established in US-120; amend when the policy changes. This is human-facing
reference; the exact commands to run before shipping a PR (and the required CI jobs) are the
`ship-a-story` skill (`.agents/skills/ship-a-story/SKILL.md`), and the widget-test template for
a new engine's renderer is the `add-activity-engine` skill.

This file covers `apps/psy_trainer/`. Since US-007 the repo is a pub workspace with two more
test suites: `packages/psy_content/test/` (pure Dart, `package:test`, its own
`no_flutter_test.dart` architecture test — see `docs/ARCHITECTURE.md`, "Repository layout")
and `tools/test/` (the coverage gate and content-assets scripts, also `package:test`). Both
run with `dart test <dir>` from the repo root; `melos run test` / `make test` runs
everything.

## Pyramid

| Level | What | Where | Tooling |
|---|---|---|---|
| **Unit** | `domain/` state machines, test generators, scoring, blueprints, repository interfaces; pure Dart, no Flutter | `test/features/<feature>/domain/` | `flutter_test` (`test()`), `fake_async` for time |
| **DAO / data** | Drift DAOs and repository implementations against an **in-memory** database; JSON loaders and mappers against fixture files | `test/features/<feature>/data/`, `test/core/db/` | `NativeDatabase.memory()` from `drift/native.dart` |
| **Widget** | `presentation/` screens and `shared/` widgets: rendering, interaction, provider wiring, goldens for key screens | `test/features/<feature>/presentation/`, `test/shared/` | `testWidgets` + `pumpApp` helper, goldens via `golden_config.dart` |
| **Integration** | End-to-end flows over the real seeded content and engines: onboarding, a lesson, a practice drill, an exam simulation and its report, the dashboard, a setting | `integration_test/` (US-121) | `integration_test` package, `IntegrationTestWidgetsFlutterBinding` |
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
integration_test/                     # end-to-end flow test (US-121)
```

- A test file mirrors the path of the file it covers and is named `<file>_test.dart`
  (`lib/features/train/domain/session_state_machine.dart` ->
  `test/features/train/domain/session_state_machine_test.dart`).
- Test names are sentences describing behaviour: `'advances to the next item after an answer'`,
  not `'test1'` or `'nextItem'`. Group by method/scenario with `group()`.
- Fixtures used by one test live next to it in a `fixtures/` sub-folder (e.g.
  `packages/psy_content/test/fixtures/`, `tools/test/fixtures/`); fixtures shared across
  features go in `test/fixtures/` (app package). Read them relative to the package root
  (`File('test/fixtures/x.json')`): `flutter test` / `dart test` always run from there.
- Fakes and stubs shared by several tests go in `test/helpers/`; a fake used by one test stays
  in that file.
- Golden PNGs are named after the screen/widget and variant: `practice_summary.png`,
  `practice_summary_large_text.png`.

## Running

```
make test            # flutter test
make test-watch      # re-run on change (needs entr or fswatch)
make coverage        # flutter test --coverage + coverage gate (see below)
make integration     # flutter test integration_test -d flutter-tester (see below)
flutter test test/features/train              # one folder
flutter test --name 'advances to'             # by test name
flutter test --update-goldens test/app_golden_test.dart   # regenerate goldens
```

`make lint` and `make test` must be green before opening a PR; CI runs them plus
`make coverage` and `make integration` (a separate `integration` job, see below).

## Integration test

`integration_test/app_flows_test.dart` (US-121) is the one end-to-end test: fresh install ->
onboarding (accept the disclaimer, skip the exam date, keep PSY0) -> Learn (every seeded PSY0
family, a lesson marked read) -> Train (Quick 5 on `arithmetic_grid`, answered through its real
grid UI) -> Exam (the `psy0.blueprint.short` blueprint run section by section) -> its report ->
the Progress dashboard (readiness, recent activity) -> Settings (switch the language to English,
a label changes).

Unlike every other layer above, it runs over the **real** seeded content and the **real**
engines, not fakes:

- `contentReadyProvider` seeds for real, from the actual `assets/content/` bundle on disk
  (`FileAssetReader`, see `test/helpers/file_asset_reader.dart` — the same reader
  `content_seeder_test.dart` / `content_ready_provider_test.dart` use — not `rootBundle`, which
  `flutter test` does not reliably serve) into a fresh `AppDatabase(openInMemoryExecutor())`
  (`appDatabaseProvider` overridden with that instance; `contentRepositoryProvider` and
  `progressRepositoryProvider` are left at their real Drift-backed bindings).
- `engineRegistryProvider` / `rendererRegistryProvider` are left at their real bindings too: the
  test drives the real `arithmetic_grid` renderer and every engine the `psy0_short` blueprint's
  nine sections use.
- Only `engineClockProvider` is overridden, with a `ManualClock` the test elapses by hand so
  cadences, per-item limits and section timeouts resolve immediately instead of over real
  wall-clock minutes (see "Testing time" below); the exam is driven by a small state machine that
  taps "Start"/"Next" as they appear and otherwise elapses the clock, so it needs no per-family
  knowledge of which sections are cadence-driven, timed or untimed.

Assertions are on structure read back from the seeded content (family/section counts, item
counts) rather than hard-coded numbers, so a content edit does not make this test flaky.

Runs headlessly, no device or emulator: `flutter_tester` (`-d flutter-tester`), the same
windowless host Flutter uses to run plain `flutter test` — this app has no platform channel
besides the asset bundle, which the test bypasses with `FileAssetReader` anyway, so a real
Linux/Chrome/Android target buys nothing over the same assertions for a heavier, more brittle CI
job. `make integration` runs it locally; CI runs the identical command in the `integration` job
(`.github/workflows/ci.yml`, `needs: check`, not gated behind the `build` label). Avoid
`flutter test integration_test -d macos` locally: with a real device flag it opens a window.

## Coverage gate

`make coverage` runs `flutter test --coverage` inside `apps/psy_trainer` (writing
`apps/psy_trainer/coverage/lcov.info`), then, from the repo root, `dart run
tools/coverage_gate.dart --file apps/psy_trainer/coverage/lcov.info --min 70` (US-007: the
gate itself is a repo-wide script, not tied to one package). The gate:

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

The gate itself is unit-tested in `tools/test/coverage_gate_test.dart` on lcov fixtures.

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
does not install a `Navigator`; tests that need routing pump `PsyTrainerApp` directly, with
`progressRepositoryOverride()` from `test/helpers/onboarding_fakes.dart` in the overrides: the
router's onboarding guard reads the profile at startup, and without the in-memory fake it would
open the real database (`onboardingDone: false` / `completed: false` gives a fresh install).

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
Glyph-edge anti-aliasing still differs between macOS and the Linux CI runner; the comparator
tolerates 1 % of differing pixels by default, and a text-dense screen can pass a larger budget
with `expectGolden(tester, name, tolerance: 0.05)` (a layout change diffs far more than that).
CI uploads a `golden-failures` artifact (master / test / diff PNGs) when a golden test fails.
They can change when Flutter is upgraded: regenerate them in the same PR as the Flutter bump
and review the diffs. Regenerate with `flutter test --update-goldens <file>`; never update a
golden without looking at the new image.

Keep goldens for key screens (one per major screen and per important state), not for every
widget: each PNG is a maintenance cost.

### Accessibility guideline tests (US-123)

Every top-level screen (the five tab homes: Learn, Train, Exam, Progress, Settings) has one
widget test that runs `flutter_test`'s built-in accessibility guidelines over it:

```dart
testWidgets('meets accessibility guidelines', (tester) async {
  final handle = tester.ensureSemantics();
  await pumpLearn(tester);              // or the screen's own pump helper

  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  handle.dispose();
});
```

- `tester.ensureSemantics()` turns semantics on for the test (the app doesn't otherwise need a
  screen reader attached) and must be `dispose()`d at the end.
- `textContrastGuideline` checks every text node against its background for the WCAG AA ratio
  (4.5:1 for normal text); `androidTapTargetGuideline` checks every tappable node is at least
  48x48; `labeledTapTargetGuideline` checks every tappable node has a semantics label. All three
  come from `package:flutter_test/flutter_test.dart`, no extra dependency.
- These are real checks, not smoke tests: this pass found and fixed genuine violations —
  `success`-on-`successSubtle` text just under the contrast ratio (`ConfidenceChip`,
  `AppColors.light.success` darkened, US-123), the selected tab bar label using `accent` text
  directly on the bar's `surface` (`AppTabBar`, switched to `textPrimary`), `SegmentedChoice`'s
  pills built at 32 dp instead of the design system's 48 dp minimum, and an inline link
  (`LearnScreen`'s "read the full disclaimer") explicitly opted out of the minimum with
  `minSize: 0`. Treat a new failure the same way: fix the widget, don't loosen the guideline.
- `textContrastGuideline`'s check renders a real frame through
  `tester.binding.runAsync` to rasterise the surface. Pumped under the **whole app** (router +
  every provider the shell wires up), that real-async step can leave an unrelated provider's
  retry `Timer` pending at teardown (`!timersPending`) even though the screen under test has
  nothing to do with it — `SettingsScreen`'s accessibility test hit this and works around it by
  pumping the bare screen (`pump_app.pumpApp`) instead of the full `PsyTrainerApp` + router,
  which reproduces the same visuals without the interaction. Prefer pumping the screen alone for
  a new accessibility test unless the screen genuinely needs the router.

### 360 dp / 1.3x overflow tests

Every top-level screen also has a test that pumps it at a 360x780 (or similar) logical surface
and 1.3x text scale — the narrowest phone width and largest scale factor this app supports —
and asserts `tester.takeException()` is `null` (no `RenderFlex` overflow, no other exception):

```dart
testWidgets('survives 1.3x text scaling at 360dp without overflow', (tester) async {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await pumpScreen(tester, textScale: 1.3);

  expect(tester.takeException(), isNull);
});
```

Use content with a genuinely long, real (not placeholder) label where the screen renders one —
a long family/blueprint name, a long section title — the overflow this catches only shows up
with real content width, not a two-word fixture string. This pass found and fixed two: a
`Row(Expanded(name), SecondaryButton("Rapide (5)"))` on the Train home whose fixed-width button
plus a long family name exceeded 360 dp (`TrainScreen`, moved the button to its own row below the
name instead of beside it), and `_RealismToggleRow` on the Exam home, whose trailing
`SegmentedChoice` sat in a `Row` where a non-flex child gets an *unbounded* width — its own
`Wrap` never got the chance to wrap onto a second line — fixed by switching that row to a
`Column` (label above, pills below), the same layout `_SettingRow` in `settings_screen.dart`
already used correctly.

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
- **Activity runtime.** `ActivitySession` takes an `EngineClock`; tests pass a `ManualClock`
  and call `clock.elapse(...)` to fire item, cadence and section timers deterministically (in
  `testWidgets` too, by overriding `engineClockProvider`). `SystemClock(now:
  async.getClock(start).now)` works under `fakeAsync` when a test wants real `Timer`s.
  `test/helpers/fake_engine.dart` / `fake_renderer.dart` give a registered fake activity.

## DAO tests

Drift tests open an in-memory database per test so they are isolated and need no files:

```dart
late AppDatabase db;
setUp(() => db = AppDatabase(NativeDatabase.memory()));
tearDown(() => db.close());
```

Test the DAO's public queries (insert then read back, ordering, filtering) and migrations
(`schema` version bumps) rather than SQL details. Use a fixed clock for `createdAt` columns.

## Web persistence tests (US-016)

Two kinds of test touch the web (`WasmDatabase`) path, both under `test/core/db/`:

- **`storage_info_test.dart`** — plain VM test (part of `make test`): `StorageInfo.resolve()` on
  native is a persistent local file.
- **`storage_info_web_test.dart`** — `@TestOn('browser')`, so a plain `flutter test` (VM) skips
  it; run it with `flutter test --platform chrome test/core/db/storage_info_web_test.dart`
  (needs `CHROME_EXECUTABLE` set if `google-chrome`/`chromium` isn't on `PATH` — on macOS:
  `export CHROME_EXECUTABLE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"`).
  It maps every `WasmStorageImplementation` drift can report to `StorageKind` without needing a
  real `WasmDatabase.open` call (the mapping, `storageInfoFromWasmResult`, is pure Dart — it
  never touches `resolvedExecutor`). Verified locally: passes in ~1s.

**A real open + seed + attempt round trip under `--platform chrome` does not work in this repo
today**, and is not wired into CI: `flutter test --platform chrome` compiles the test to
JS/wasm and serves it from its own dev server, which does not serve the app's `web/` directory
(`sqlite3.wasm`, `drift_worker.js`) — `WasmDatabase.open` fails with `TypeError: Failed to
execute 'compile' on 'WebAssembly': HTTP status code is not ok` (a 404 fetching
`sqlite3.wasm`). This is a limitation of the `flutter test` browser harness, not of the app: the
same code works under `flutter build web --release` (verified, see `docs/ARCHITECTURE.md`
"Platforms"). Do not re-add a `web_smoke_test.dart` that opens a real `WasmDatabase` unless a
way to serve `web/` from the test harness is found first — it will fail identically.

**Manual check** (until the harness limitation above is resolved), after `make build-web`:

1. Serve `build/web` over plain HTTP (not `file://`, which browsers block from opening
   `sqlite3.wasm`/workers): `cd apps/psy_trainer/build/web && python3 -m http.server 8000`.
2. Open `http://localhost:8000` in a real browser, use the app enough to write data (finish
   onboarding, run one practice item), then check:
   - DevTools console shows one `[db] web storage: <implementation>` line (from
     `open_database_web.dart`) with no `missingFeatures` — a shared/local Chrome or Firefox
     should log `opfsShared` or `opfsLocks`.
   - DevTools → Application → IndexedDB (or File System, for OPFS) shows a `psy_trainer`
     database with data.
   - Reload the page: the data (onboarding state, the practice attempt) is still there.
   - Settings → About shows "Stockage : OPFS" (or "IndexedDB") with no warning line.
3. Optional: repeat in a private/incognito window with storage disabled, or in a browser with
   neither OPFS nor IndexedDB, to see the "mémoire (non persistant)" fallback and its warning
   line — data should NOT survive a reload in that case.

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
