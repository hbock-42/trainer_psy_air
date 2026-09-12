# PSY Trainer

[![CI](https://github.com/hbock-42/trainer_psy_air/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/hbock-42/trainer_psy_air/actions/workflows/ci.yml)

Unofficial app to prepare for the psychometric tests of the Air France cadet pilot selection
(PSY0 first, then PSY1 and PSY2): lessons, timed drills, mock exams and progress tracking, all
stored locally on the device. Phone builds are for learning and practice; desktop and web builds
rehearse the keyboard-native activities the way the real desktop test runs (see
[Platforms](docs/ARCHITECTURE.md#platforms)).

This project is a personal training tool. It is **not affiliated with, endorsed by, or connected
to Air France** or any of its selection partners. Test formats are reconstructed from public
information and may differ from the real thing.

## Status

Early scaffold. The app currently shows a placeholder screen; the navigation shell, design system
and first exercise engines are tracked on the [kanban board](docs/kanban/README.md).

## Setup

This repo is a [pub workspace](https://dart.dev/tools/pub/workspaces) (US-007): the Flutter
app (`apps/psy_trainer/`) and the pure-Dart content package (`packages/psy_content/`) resolve
from one `pubspec.lock` at the root. Requirements: Flutter 3.41.x (stable) with the toolchain
of the platform you target (Android, iOS, macOS via Xcode, Windows via Visual Studio, or
Chrome for web; `flutter doctor` must be green for it), `make`, and
[Melos](https://melos.invertase.dev/) (optional convenience wrapper around the same
commands; see `melos.yaml`).

```sh
git clone <this repo>
cd trainer_psy_air
dart pub global activate melos   # optional, once per machine
dart pub get                     # resolves the whole workspace from the root
make run DEVICE=<device id>      # or: cd apps/psy_trainer && flutter run
```

Common tasks (see `make help`, run from the repo root; equivalent `melos run <name>` scripts
exist too):

| Command          | What it does |
|------------------|--------------|
| `make gen`       | Code generation (`freezed`, `json_serializable`, `drift`) for the app and `psy_content` |
| `make lint`      | Analyze (`--fatal-infos`) + format check, every package |
| `make test`      | Every package's tests (app, `psy_content`, `tools/test`) |
| `make coverage`  | App tests with coverage + the repo-wide coverage gate |
| `make content-check` | Content validator (`packages/psy_content`) over the app's `assets/content` |
| `make run`       | `flutter run` on the connected device (in `apps/psy_trainer`) |
| `make run-macos` | `flutter run -d macos` (desktop, exam mode) |
| `make run-web`   | `flutter run -d chrome` |
| `make build-macos` | `flutter build macos --debug` (headless check of the desktop target) |
| `make build-web` | `flutter build web --release` (same as CI) |
| `make board`     | Regenerate the kanban board index |

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) ("Repository layout") for the full layout,
why pub workspaces + Melos, and how to add a package.

## CI

GitHub Actions ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs on every pull
request and on pushes to `main`:

- **`check`**: `dart pub get` at the root (resolves every workspace member), code generation,
  `dart format` check, `flutter analyze --fatal-infos` (app) + `dart analyze --fatal-infos`
  (`psy_content`), the content validator (`psy_content:validate_content`, US-014) over the
  app's `assets/content`, `flutter test --coverage` (app) + `dart test`
  (`psy_content`, `tools/test`), the coverage gate over the app's lcov, then
  `flutter build web --release` in `apps/psy_trainer`. This job is required to merge into
  `main`. Desktop builds (macOS, Windows) are not run in CI.
- **`build-android`**: builds a debug APK (`apps/psy_trainer`) and uploads it as an artifact.
  Runs on pushes to `main` and on pull requests labelled `build`.

Run the same commands locally with `make lint` and `make test` before opening a PR.

## Release

Pushing a `v*` tag runs [`.github/workflows/release.yml`](.github/workflows/release.yml):
release APK/AAB (Android) and a web build, attached as artifacts and to a draft GitHub
Release. See [docs/RELEASE.md](docs/RELEASE.md) for the full process — version bump script,
Android signing secrets, and the manual Play internal testing / TestFlight steps.

## Conventions

- Architecture, folder layout, stack and naming rules: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
- **The UI is built on the Flutter `widgets` layer only. No Material, no Cupertino.** A test in
  `apps/psy_trainer/test/architecture/` fails the build if either library is imported under
  `apps/psy_trainer/lib/`.
- Work is organised as epics and user stories in [docs/kanban](docs/kanban/README.md); one PR per
  story, branch `us-xxx-short-title`, PR title `US-xxx: Title`.
