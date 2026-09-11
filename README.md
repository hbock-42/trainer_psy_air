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

Requirements: Flutter 3.41.x (stable) with the toolchain of the platform you target (Android,
iOS, macOS via Xcode, Windows via Visual Studio, or Chrome for web; `flutter doctor` must be green
for it), and `make`.

```sh
git clone <this repo>
cd trainer_psy_air
flutter pub get
flutter run            # or: make run DEVICE=<device id>
```

Common tasks (see `make help`):

| Command          | What it does |
|------------------|--------------|
| `make gen`       | Code generation (`freezed`, `json_serializable`, `drift`) via `build_runner` |
| `make lint`      | `flutter analyze` + format check |
| `make test`      | `flutter test` |
| `make run`       | `flutter run` on the connected device |
| `make run-macos` | `flutter run -d macos` (desktop, exam mode) |
| `make run-web`   | `flutter run -d chrome` |
| `make build-macos` | `flutter build macos --debug` (headless check of the desktop target) |
| `make build-web` | `flutter build web --release` (same as CI) |
| `make board`     | Regenerate the kanban board index |

## CI

GitHub Actions ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs on every pull
request and on pushes to `main`:

- **`check`**: `flutter pub get`, code generation, `dart format` check, `flutter analyze
  --fatal-infos`, `flutter test --coverage` (the `coverage/lcov.info` file is uploaded as an
  artifact), then `flutter build web --release`. The content validator
  (`tool/validate_content.dart`, US-014) runs as soon as it exists. This job is required to merge
  into `main`. Desktop builds (macOS, Windows) are not run in CI.
- **`build-android`**: builds a debug APK and uploads it as an artifact. Runs on pushes to `main`
  and on pull requests labelled `build`.

Run the same commands locally with `make lint` and `make test` before opening a PR.

## Conventions

- Architecture, folder layout, stack and naming rules: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
- **The UI is built on the Flutter `widgets` layer only. No Material, no Cupertino.** A test in
  `test/architecture/` fails the build if either library is imported under `lib/`.
- Work is organised as epics and user stories in [docs/kanban](docs/kanban/README.md); one PR per
  story, branch `us-xxx-short-title`, PR title `US-xxx: Title`.
