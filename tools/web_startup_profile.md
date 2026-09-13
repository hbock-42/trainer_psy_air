# Web startup performance profile (US-125)

Measurement method: `npx --yes lighthouse <url> --output=json --chrome-flags="--headless --no-sandbox" --only-categories=performance`, headless Chrome, cold cache, against the deployed build. "After" numbers for the JS/content payload come from a local `make build-web` of this branch (see the note at the end — the branch has not been deployed to GitHub Pages yet, that happens on merge to `main` via `.github/workflows/pages.yml`).

## Before (baseline, deployed `main` at the time of writing)

Lighthouse trace against `https://hbock-42.github.io/trainer_psy_air/`:

| Metric | Value |
|---|---|
| First Contentful Paint | 0.9 s |
| Largest Contentful Paint | 1.1 s |
| Total Blocking Time | 1,930 ms |
| Speed Index | 28.6 s |
| Time to Interactive | 15.8 s |
| Lighthouse performance score | 0.62 |

Network (167 requests, 3.50 MB transferred total):

| Resource | Transfer size | Note |
|---|---|---|
| `main.dart.js` | 1,203,558 B (gzip) / 4,400,509 B (raw) | all 27 activity engines bundled in |
| CanvasKit `.wasm` | 1,630,179 B | fetched from `gstatic.com`, not this repo's build |
| Content assets (`assets/content/**`) | 152 requests, 470,369 B transferred (1,884,231 B raw) | one request per authored file — items, families, lessons, decks, blueprints, lexical fields, interview questions, `manifest.json` |

The two suspected causes from the story card are both confirmed by this trace: ~130+ individual content-file requests before the app can show anything, and a single ~4.4 MB `main.dart.js` carrying every engine whether or not the session ever uses it. TBT (1.93 s) and TTI (15.8 s) are consistent with a large synchronous seeding + parse step blocking the main thread after `main.dart.js` finishes downloading.

## After (this branch, local `make build-web`)

### Content: pre-bundled + lazy per-module seeding

`tools/bundle_content.dart` (`make content-assets` / CI, before `flutter build`) collapses each module's authored files into one JSON document:

| Module | Files collapsed | Bundle size (raw / gzip) |
|---|---|---|
| psy0 | 81 → 1 | 1,300,388 B / 230,346 B |
| psy1 | 51 → 1 | 600,407 B / 118,054 B |
| psy2 | 19 → 1 | 141,418 B / 17,998 B |

`ContentBundleLoader` prefers the bundle file when present, falling back to the per-file tree read otherwise (tests keep using the tree via `FileAssetReader`). Combined with lazy per-module seeding (`ContentSeeder.seedModule`, gated by the new `module_seed_state` table — see `docs/ARCHITECTURE.md` "Content seeding"):

- **First launch, before the first frame**: 1 request for `manifest.json` + 1 request for the *active* module's bundle (`psy0.json` by default) = **2 content requests**, down from 152.
- psy1/psy2 (2 more requests, ~750 KB raw / ~136 KB gzip combined) seed in the background after the first frame (`SchedulerBinding.addPostFrameCallback`), never blocking the router.

This is the dominant win: the ~130-request, ~1.9 MB-raw seeding step that used to run in full before the router could show anything now runs as 2 small requests before first paint, with the rest deferred.

### Engines: PSY1 deferred behind a `deferred as` import

`main.dart.js` and the new `main.dart.js_1.part.js` (PSY1's 13 engines/renderers, `deferred as psy1` in `engine_registry_provider.dart`):

| File | Raw size | Gzip size |
|---|---|---|
| `main.dart.js` (before, 27 engines eager) | 4,400,509 B | 1,203,558 B |
| `main.dart.js` (after, 14 non-PSY1 engines eager) | 4,410,924 B\* | 1,131,171 B |
| `main.dart.js_1.part.js` (13 PSY1 engines, loaded in the background post-first-frame) | 137,566 B | 47,219 B |

\* Raw size is roughly flat (dart2js's per-fragment overhead), but the number that matters for load time — **gzip transfer size of the initial script** — drops from 1,203,558 B to 1,131,171 B (**-72,387 B, -6%**), and that work moves off the critical path: the PSY1 chunk downloads/parses in the background after the shell is already showing, not before.

This is a smaller win than the content-bundling change and a deliberately scoped one: only PSY1 (13 of 27 families, the non-default module) is split out, loaded eagerly in the background rather than gated behind the practice launcher / exam planner / retry-mistakes builder as the story card's reference design suggests. See the PR description for why (touching those ~15 production call sites and the ~50 tests that assume the engine/renderer registries are synchronously, fully populated was judged too high-risk for the time available). `flutter build web` output does contain a real `*.part.js` file confirming the split works; native builds (`make build-macos`) are unaffected (deferred imports are no-ops there).

### Startup budget test

`test/core/router/startup_gate_lazy_seeding_test.dart` asserts `contentReadyProvider` (the provider `StartupGate` gates the router on) resolves once the *active* module is seeded, while the other modules are still gated/unseeded — i.e. the shell does not wait on them.

## Not yet measured: a redeployed Lighthouse trace

This profile's "after" numbers come from a local build, not a redeployed `https://hbock-42.github.io/trainer_psy_air/`: deploying happens automatically via `.github/workflows/pages.yml` on merge to `main`, which this session (a PR branch) does not do. **Follow-up**: once this PR merges and Pages redeploys, re-run the same Lighthouse command against the live URL and record FCP/LCP/TBT/TTI/Speed Index here for a true side-by-side — the CanvasKit `.wasm` fetch (1.6 MB from `gstatic.com`) is outside this story's scope and will still dominate cold-cache TTI regardless.
