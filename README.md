# PSY Trainer

Unofficial mobile app to prepare for the psychometric tests of the Air France cadet pilot
selection (PSY0 first, then PSY1 and PSY2): lessons, timed drills, mock exams and progress
tracking, all stored locally on the device.

This project is a personal training tool. It is **not affiliated with, endorsed by, or connected
to Air France** or any of its selection partners. Test formats are reconstructed from public
information and may differ from the real thing.

## Status

Early scaffold. The app currently shows a placeholder screen; the navigation shell, design system
and first exercise engines are tracked on the [kanban board](docs/kanban/README.md).

## Setup

Requirements: Flutter 3.41.x (stable) with the Android and/or iOS toolchains
(`flutter doctor` must be green for the platform you target), and `make`.

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
| `make board`     | Regenerate the kanban board index |

## Conventions

- Architecture, folder layout, stack and naming rules: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
- **The UI is built on the Flutter `widgets` layer only. No Material, no Cupertino.** A test in
  `test/architecture/` fails the build if either library is imported under `lib/`.
- Work is organised as epics and user stories in [docs/kanban](docs/kanban/README.md); one PR per
  story, branch `us-xxx-short-title`, PR title `US-xxx: Title`.
