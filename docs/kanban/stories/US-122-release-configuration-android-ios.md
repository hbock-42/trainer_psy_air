---
id: US-122
issue: 77
title: "Release configuration (Android / iOS)"
type: story
epic: EPIC-12
status: done
priority: P1
size: S
lane: core
depends_on: [US-001]
labels: [release]
---

# US-122 — Release configuration (Android / iOS)

- [x] App name, icons, splash, bundle ids, signing configs (secrets outside repo), version bump script
- [x] Internal testing track / TestFlight build produced from CI on tag — CI (`.github/workflows/release.yml`)
      builds the release APK/AAB and web build from a `v*` tag and drafts a GitHub Release with them
      attached (signed when `ANDROID_KEYSTORE_BASE64`/`ANDROID_KEY_PROPERTIES` secrets are set, unsigned
      otherwise). Uploading to the Play internal testing track and TestFlight itself stays a manual step
      (no Play/Apple secrets exist yet) — documented in `docs/RELEASE.md`.
