# Release

How to cut a release of PSY Trainer: bump the version, tag it, what CI builds from the tag,
where the artifacts land, and the manual steps for Play internal testing and TestFlight
(US-122). This file covers `apps/psy_trainer/`; see `docs/ARCHITECTURE.md` ("Platforms") for
why Android/iOS are the "learn and practice" targets and macOS/Windows/web are "exam mode".

## App identity

| | Value |
|---|---|
| Display name | PSY Trainer (Android label, iOS/macOS `CFBundleDisplayName`/`CFBundleName`, web manifest/title) |
| Bundle id / application id | `dev.hbock.psytrainer` (Android `namespace` + `applicationId`, iOS/macOS `PRODUCT_BUNDLE_IDENTIFIER`) |
| Version | `apps/psy_trainer/pubspec.yaml`'s `version:` line, `major.minor.patch+build` |

Icons and the splash screen are generated from one source image — see "Branding" below.

## 1. Bump the version

```sh
dart run tools/bump_version.dart --patch   # bug fixes: 1.0.0+1 -> 1.0.1+2
dart run tools/bump_version.dart --minor   # new features: 1.0.1+2 -> 1.1.0+3
dart run tools/bump_version.dart --major   # breaking/major milestone: 1.1.0+3 -> 2.0.0+4
```

This rewrites the `version:` line in `apps/psy_trainer/pubspec.yaml` only, and always
increments the build number (Android `versionCode`, iOS `CFBundleVersion`) so it strictly
increases across releases even for a patch bump. Commit the change:

```sh
git add apps/psy_trainer/pubspec.yaml
git commit -m "Bump version to $(sed -n 's/^version: //p' apps/psy_trainer/pubspec.yaml)"
```

## 2. Tag and push

Tag the commit with a `v` prefix matching the new version (the build number is optional in
the tag name, the workflow doesn't parse it):

```sh
git tag v1.0.1
git push origin v1.0.1
```

Pushing a `v*` tag triggers `.github/workflows/release.yml`. It does not re-run `check` from
`ci.yml` — only tag a commit that already passed CI on `main`.

## 3. What CI builds

`.github/workflows/release.yml` runs three jobs on the tag:

- **`build-android`**: `flutter build apk --release` and `flutter build appbundle --release`.
  Signed when both `ANDROID_KEYSTORE_BASE64` and `ANDROID_KEY_PROPERTIES` repository secrets
  are set (see "Android signing" below); otherwise the release build type falls back to the
  debug signing config (same as a local `flutter build apk --release` with no
  `android/key.properties`), so the build still succeeds unsigned.
- **`build-web`**: `flutter build web --release`, archived as `web-release.tar.gz`.
- **`draft-release`**: downloads both jobs' artifacts and opens a **draft** GitHub Release
  named after the tag, with the APK, AAB and web archive attached, and auto-generated release
  notes. A maintainer reviews the draft, edits the notes if needed, and publishes it.

Artifacts also stay attached to the workflow run for 90 days (Actions -> the run -> Artifacts)
even before the release is published.

There is no iOS/macOS job: this project has no Apple Developer account secrets configured in
CI, so those builds stay manual (see "TestFlight" below).

## Android signing

Real releases should be signed with a stable upload key so Play accepts updates to the same
app over time.

1. Generate a keystore once (keep it **outside** the repo, e.g. in a password manager or a
   secrets vault):

   ```sh
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 \
     -validity 10000 -alias upload
   ```

2. For a **local** signed release build, copy
   `apps/psy_trainer/android/key.properties.example` to
   `apps/psy_trainer/android/key.properties` (gitignored) and fill in the real values —
   `storeFile` can be an absolute path to the keystore or a path relative to
   `apps/psy_trainer/android/app/`. `android/app/build.gradle.kts` reads this file
   automatically; when it is absent, the release build type falls back to the debug signing
   config so `flutter build apk --release` still works unsigned.

3. For **CI-signed** release builds, set two repository secrets (Settings -> Secrets and
   variables -> Actions -> New repository secret):

   - `ANDROID_KEYSTORE_BASE64`: `base64 -i upload-keystore.jks | pbcopy` (or `base64 -w0` on
     Linux), pasted as the secret value. The workflow decodes it to
     `android/app/upload-keystore.jks` before the build and deletes it afterwards.
   - `ANDROID_KEY_PROPERTIES`: the full contents of a `key.properties` file (same format as
     `key.properties.example`) whose `storeFile` is just `upload-keystore.jks` (matching where
     the secret above is decoded to).

   Both must be set for CI to sign; with only one set, or neither, the build falls back to
   unsigned (debug-signed) output.

## TestFlight (manual)

No Apple Developer secrets exist for this project, so iOS release builds are not automated.
To ship a TestFlight build:

1. Open `apps/psy_trainer/ios/Runner.xcworkspace` in Xcode (`flutter build ios` once first to
   generate the ephemeral Flutter files if needed).
2. Set the signing team under Runner target -> Signing & Capabilities (needs an Apple
   Developer Program membership); `PRODUCT_BUNDLE_IDENTIFIER` is already `dev.hbock.psytrainer`
   via the project's build settings.
3. Product -> Archive, then use the Organizer to upload to App Store Connect, **or** from the
   command line:

   ```sh
   cd apps/psy_trainer
   flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
   ```

   Copy `ios/ExportOptions.plist.example` to `ios/ExportOptions.plist` (gitignored) first and
   replace `YOUR_TEAM_ID` with the real Apple Developer Team ID.
4. In App Store Connect, add the build to a TestFlight group and invite testers. Internal
   testers see it immediately after processing; external testers need a beta review.

## Play internal testing (manual, for now)

Play Console upload is not automated either (no Play service-account secret is configured).
Until it is:

1. Download the signed `.aab` from the release's GitHub artifacts (or the draft Release once
   `draft-release` runs).
2. Play Console -> the app -> Testing -> Internal testing -> Create new release, upload the
   AAB, add release notes, and roll out to the internal testing track.
3. Testers on the internal testing list get the update within a few minutes.

Automating this later needs a Play service account JSON (e.g. via
`r0adkll/upload-google-play`) as another repository secret — out of scope for this story.

## Web (GitHub Pages)

The web build is deployed continuously, independently of tagged releases (US-124): every push
to `main` runs [`.github/workflows/pages.yml`](../.github/workflows/pages.yml) (also runnable
on demand from Actions -> Pages -> Run workflow), which builds and deploys the site to
**https://hbock-42.github.io/trainer_psy_air/**.

- **Build**: `flutter build web --release --base-href "/${{ github.event.repository.name }}/"`
  in `apps/psy_trainer`, so the app's assets resolve under the project-site sub-path GitHub
  Pages serves it from (a user/org site would be root-served instead, needing no `--base-href`).
  The `web/index.html`/`manifest.json` in the repo use relative asset URIs (the default
  `flutter create` template), so nothing else needed changing for the sub-path.
- **Deploy**: `actions/configure-pages@v5` + `actions/upload-pages-artifact@v3` (uploading
  `apps/psy_trainer/build/web`) + `actions/deploy-pages@v4`, the standard "deploy with GitHub
  Actions" trio, under the `github-pages` environment with `permissions: pages: write,
  id-token: write`.
- **Deep links**: GitHub Pages has no server-side rewrite, so a reload on a path route like
  `/learn/family/x` would 404 under Flutter's default path-based URL strategy. Rather than
  adding a `404.html` SPA-redirect trick, the app sets the **hash URL strategy**
  (`setUrlStrategy(HashUrlStrategy())` from `package:flutter_web_plugins`, compiled for
  the web only through the conditional import in `lib/core/router/url_strategy.dart` —
  the package needs `dart:ui_web`, which mobile and desktop builds do not have) so every
  route lives after the `#` (e.g.
  `https://hbock-42.github.io/trainer_psy_air/#/learn/family/x`), which GitHub Pages always
  serves as `index.html` regardless of the fragment. Simpler to maintain than a redirect page:
  no extra file to keep in sync with the router, and it degrades the same way locally
  (`make run-web`) as it does deployed.
- **Service worker / caching**: no `--pwa-strategy` override — the `flutter build web` default
  (`offline-first`) is used, matching the release build in `release.yml`.
- **Pages source**: set once via `gh api -X POST repos/hbock-42/trainer_psy_air/pages -f
  build_type=workflow` (idempotent; a 409 means it's already set). If that ever needs doing by
  hand instead: repo Settings -> Pages -> Build and deployment -> Source -> "GitHub Actions".
- **Verifying a deploy**: open the URL above, complete onboarding, run a practice session,
  reload the page and confirm progress persisted (Drift/IndexedDB via US-016), and exercise a
  keyboard-native activity in Chrome.

## Branding (icon + splash)

The app icon and splash screen are generated from one design, drawn programmatically rather
than rasterised from an SVG (no SVG renderer is guaranteed to be available in CI/sandboxes):

- `tools/branding/icon.svg` — readable source-of-truth reference for the design (a stylised
  aircraft climbing through a target ring, on the design system's deep-blue background token).
- `tools/branding/generate_icon.dart` — draws the same shapes with `package:image` and writes
  `tools/branding/out/icon_1024.png` (opaque, for the app icon) and
  `tools/branding/out/splash_1024.png` (transparent, for the splash logo).
- `apps/psy_trainer/assets/branding/{icon,splash_logo}.png` — the committed copies that
  `flutter_launcher_icons` and `flutter_native_splash` (dev dependencies, configured in
  `apps/psy_trainer/pubspec.yaml`) actually read.

To change the design and regenerate every platform's icons/splash assets:

```sh
dart run tools/branding/generate_icon.dart
cp tools/branding/out/icon_1024.png apps/psy_trainer/assets/branding/icon.png
cp tools/branding/out/splash_1024.png apps/psy_trainer/assets/branding/splash_logo.png
cd apps/psy_trainer
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Commit the regenerated platform files (`android/app/src/main/res/mipmap-*`,
`ios/Runner/Assets.xcassets/AppIcon.appiconset/`,
`macos/Runner/Assets.xcassets/AppIcon.appiconset/`, `web/icons/`, `web/favicon.png`,
`web/manifest.json`, `web/index.html`, `web/splash/`, and the Android
`drawable*/launch_background.xml` + `values*/styles.xml` splash wiring) along with the two
source PNGs.
