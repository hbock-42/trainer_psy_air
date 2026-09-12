# PSY1 — the Air France Cadets in-person psychotechnical/psychomotor day: what it really is

_Research deliverable for US-100 (GitHub #68). Feeds US-101/US-102/US-103 (EPIC-10, PSY1 trainer)._
_Research done 2026-09-13. The 2026 PSY1 session (19–30 October 2026, per the official calendar quoted in `psy0-spec.md` §1) has not happened yet, so every session-specific detail below comes from 2019–2024 debriefs and prep-vendor pages; nothing has been observed for 2025 or 2026 yet. All URLs were accessed on 2026-09-13 unless stated otherwise._

## How to read this document

Same confidence scale as `psy0-spec.md`:

| Tag | Meaning |
|---|---|
| **[confirmed]** | Stated by an official Air France source. |
| **[reported]** | Consistent candidate feedback (Aeronet debriefs 2019–2024) and/or prep vendors (Pilotest, EPLtest, TestPilote, pilote-de-ligne.fr). Reliable for structure, less so for exact numbers, and PSY1 is reported to change its item pool/wording every session to fight over-conditioning on the trainers. |
| **[assumed]** | Our best guess where nothing precise was found. Blueprint values marked this way must stay flagged `"estimated": true`. |

**Headline findings (TL;DR)**

1. PSY1 is a **one-day, in-person, computer-based battery at ENAC Toulouse**, run on ~20 supervised workstations, roughly 8:30 to 16:30–17:00 with a short morning break and a long (~1.5 h) lunch break. **[confirmed]** for "one day, in person"; **[reported]** for ENAC as the venue (the official Air France page only says "sur une journée lors des vacances de la Toussaint" — it never names ENAC) and for the exact schedule.
2. It reuses the same family of psychotechnical mini-games as the **ENAC/EPL competition's own PSY1** (mental arithmetic, Raven-type matrices, cube nets, text comprehension, memory, counters, angles, tangram, general-efficiency items) **plus one psychomotor multitasking test unique to this stage, run with two joysticks**. Air France, ENAC/EPL (EPL/S, EPL/L) and the "Pilote pro" Air France/HOP track all draw on the same item families, which is why Pilotest/EPLtest sell one shared training catalogue for all three. **[reported]**
3. The battery is reported to eliminate **~70 % of candidates** — the single most selective stage of the whole process. **[reported, very consistent across sources, 2018→2026 prep-vendor copy]**
4. Unlike PSY0 (keyboard + mouse only), **PSY1 requires dedicated hardware**: two **Thrustmaster T.16000M FCS Space Sim Duo joysticks**, a keyboard with a numeric keypad, and a mouse. This is the one PSY1 activity a desktop/web app cannot fully rehearse without extra input hardware or a compromise (§4, §5).
5. Whether PSY1 still contains a **personality questionnaire** is unclear and possibly a hangover of older cycles: one prep page says a personality test is part of the ENAC/EPL PSY1, but a first-hand 2024 Air-France-cadet debrief states none was administered that year, and the 2026 official calendar places "personnalité, épreuve collective, entretien individuel" squarely in **PSY2** (see `psy0-spec.md` §1). We treat the PSY1 personality questionnaire as **retired for the Air France cadet track** unless a 2026 debrief says otherwise. **[reported, conflicting — open question]**
6. Consequences for the kanban: EPIC-10 needs a genuinely new **input abstraction for continuous dual-axis analog control + physical buttons** (the joystick psychomotor test), which nothing in EPIC-03's `ActivityEngine`/`SessionHost` runtime provides today; every other PSY1 activity can be built as a normal generated or bank-driven `ActivityEngine` (new families, same runtime). See §4.

---

## 1. Where PSY1 sits in the selection (recap)

See `psy0-spec.md` §1 for the full 7-stage table; the relevant row:

| # | Stage | What it is | Where | Eliminatory? | Source |
|---|---|---|---|---|---|
| 2 | **PSY1 — tests psychotechniques et psychomoteurs** | One full day of computer-based cognitive and psychomotor tests (joysticks, dual-axis tracking, Raven-type matrices, counters, cubes…). Toussaint school holidays (19–30 Oct 2026). | ENAC Toulouse (**[reported]**) | Yes — ~70 % elimination (**[reported]**). 2 failures = permanent exclusion from the Cadet track (**[confirmed]**, `psy0-spec.md` S1). | S1 (official), pilotest/EPLtest/test-pilote (below) |

Retake rule, restated from `psy0-spec.md` §1: **2 failures at PSY1 → definitive elimination from the Cadet track** (the "Pilote professionnel" track remains open). **[confirmed]** (S1).

---

## 2. PSY1 in detail

### 2.1 Modality, venue, hardware

| Item | Finding | Tag |
|---|---|---|
| Where | Official wording never names a venue ("sur une journée lors des vacances de la Toussaint"). Every prep vendor and every debrief names **ENAC Toulouse** as the site, consistent 2018→2024. | **[reported]** T1–T9 |
| Schedule | Doors open/checked in around **8:00**, testing starts **~8:30** (one blog: "les portes se verrouillent électroniquement à l'heure de début — tout retard empêche l'entrée"), day ends **~16:30–17:00** ("vous pouvez raisonnablement espérer finir vers 17h"). A short mid-morning break, then a **~1.5 h lunch break** (ENAC's Sodexo cafeteria; one blog warns "vous resterez sur votre faim après le déjeuner, prenez une barre de céréales"), a shorter (~10–15 min) afternoon break. | **[reported]** T2, T7 |
| Rooms | ~20 computer workstations per room, screens fitted with a **privacy/directional filter** to prevent a neighbour reading answers; the room is air-conditioned; candidates report worn/heavily-used keyboards. | **[reported]** T7 |
| Joysticks | **Two Thrustmaster T.16000M FCS Space Sim Duo** joysticks (spring-centered, no force feedback needed), replacing older Thrustmaster/CH "ST-90"-class sticks used before ~2017. Each stick has two thumb buttons and one index-finger trigger. | **[reported]** T2, T4, T7, T8 |
| Other input | Keyboard with numeric keypad (F1–F9 keys used in the psychomotor test), mouse for the QCM-style tests, physical scratch paper allowed for the maths/tangram tests only (unlike PSY0, where none is allowed). | **[reported]** T1, T4 |
| Personality test | One prep page (ENAC/EPL comparison) states a personality questionnaire is part of PSY1 ("assessing traits like confidence and decision-making ability"); a first-hand 2024 Air France cadet debrief states none was administered. The 2026 official calendar places personality inventories in **PSY2**, not PSY1 (`psy0-spec.md` §1). Net assessment: **most likely retired from the cadet PSY1** in recent cycles, possibly still present in the ENAC/EPL competition proper. | **[reported, conflicting]** T6, T9 |
| Scratch paper | Allowed for maths/tangram, per one source; contrast with PSY0 where none is allowed at all. | **[reported]** T2 |

### 2.2 Scoring and pass rules

| Item | Finding | Tag |
|---|---|---|
| Output | Same "classe" (stanine-like, 1–9 or 1–4 depending on the vendor's own scale) scoring model as PSY0; Pilotest recreates "le système de notation en classes Stanine". A 2018 result sheet quoted by a prep page gives **minimum classes to clear**: verbal ≥ class 3; psychomotor and spatial ≥ class 5; other families ≥ class 4 (illustrative, not necessarily current). | **[reported]** T1, T2 |
| Negative marking | "Les mauvaises réponses retirent des points, mieux vaut ne pas répondre au hasard" — negative marking is reported across most QCM-style PSY1 tests (unlike PSY0's 2026 culture test, which dropped it). The cube-rotation test specifically is reported at **−0.25 per wrong answer**, favouring accuracy over raw speed ("20 réponses justes vaut mieux que 25 dont 5 fausses"). | **[reported]** T2, T5 |
| Psychomotor scoring | Distinctive and harsh: each of the 4 simultaneous sub-tasks has its own live score; **the instant any one sub-task's score enters the "red zone", the whole test's total score drops to 0**, regardless of how well the other three sub-tasks are doing. This makes the psychomotor test effectively "keep all 4 balls in the air, permanently" rather than "average your 4 scores." | **[reported]** T4 |
| Results timing | One blog states results are sent "le lendemain à 9h" for at least part of the feedback; more generally, Air France communicates PSY1 outcomes "within a few weeks." | **[reported]** T1 |
| Ordering | Fixed order, one test after another with example screens; the psychomotor test is consistently reported as the **last** test of the day. | **[reported]** T4, T5, T9 |

### 2.3 The activities — family by family

Merges: a first-hand ordered **2024 debrief** (Aeronet, "Retex psy1 cadet AF 2024"), Pilotest's PSY1 category breakdown (numeric / intellectual / attention / psychomotor / spatial / verbal / memory), the EPLtest PSY1 test list, and a dedicated TestPilote article on the cube-rotation and two-axis tests. Where sources disagree on exact counts, both are given.

| # | Activity (candidate/vendor name) | Family | What it measures | Format & interaction | Volume / timing (as reported) | Tag |
|---|---|---|---|---|---|---|
| 1 | **Mathématiques** — word-problem style, distinct from PSY0's arithmetic grids | Numerical | Multi-step arithmetic reasoning under time pressure | MCQ or free numeric answer; scratch paper allowed | 30 q / 35 min (2024 debrief) | **[reported]** |
| 2 | **Tangram** | Spatial / construction | Mental composition of shapes from parts, counting occurrences | Complete/identify shape compositions from a fixed piece set; a 2024-only "new version" asked for **occurrence counts** rather than direct assembly | 24 "planches" (2024 debrief); count and format vary by session | **[reported]** |
| 3 | **Attention soutenue** ("Attention 1–3") | Attention / sustained vigilance | Sustained attention over repeated short bursts | Series-based vigilance task, exact stimulus/response format not documented in the sources found | 3 series of 5 (sub-tests?), ~3 min each per the 2024 debrief — reading is ambiguous, treat count as **[assumed]** | **[reported]**, format **[open question]** |
| 4 | **Lecture de textes / Compréhension de lecture** | Verbal | Reading comprehension, French | MCQ on passages, similar family to PSY0's English reading test but in French | 10 texts / 20 min (2024 debrief) | **[reported]** |
| 5 | **Angles à saisir** | Spatial | Angle estimation / geometric judgement | Among ~9 candidate angle values, select up to 4 correct ones (multi-select) | "9 possibilités, max 4 bonnes réponses" | **[reported]** |
| 6 | **EFG** ("Efficience générale") | General reasoning | Broad, fast-paced reasoning/logic items; exact item type not documented | MCQ, appears across numeric/intellectual/spatial/verbal categories on Pilotest's own taxonomy (i.e. a mixed-content family, not a single paradigm) | 35 q / 30 min (2024 debrief) | **[reported]**, exact format **[open question]** |
| 7 | **Lecture de compteurs / "Test des compteurs"** | Attention / instrument reading | Fast, accurate reading of analog gauges/counters — closest PSY1 analogue to a flight-instrument scan | Read values off dial/counter displays and answer; no time limit reported for the family as a whole (per-item timing likely exists but undocumented) | Not documented | **[reported]**, timing **[open question]** |
| 8 | **Patrons de cubes / "Dépliage de cube"** | Spatial / mental folding | 2D net ↔ 3D cube reasoning, and 3D-cube rotation matching (same-object-rotated vs mirrored/altered) | Two variants reported: (a) net-folding with **two alphabets** — "3 cubes/alphabet latin" and "2 cubes/alphabet runique" (i.e. some sessions use invented rune-like symbols, not just letters, to defeat memorisation); (b) rotation matching — view a reference cube, then judge whether each candidate cube is the same object rotated (possibly on a diagonal/combined axis) or altered (mirrored/swapped faces) | Net-folding: 2 phases × 10 "patrons" × 20 min each (2024 debrief). Rotation matching: ~25 items / 8–10 min, −0.25 per wrong answer (TestPilote article) | **[reported]** |
| 9 | **Mémoire de travail I** — reverse digit memorisation | Memory | Working-memory span with a reversal/inhibition demand | Sequences of **4–9 digits** shown, then recalled/answered within a **3–4 s** response window per item | Not fully specified beyond the digit-length range | **[reported]** |
| 10 | **Mémoire de travail II** — "calcul memory back" | Memory + arithmetic | Holding intermediate arithmetic results in working memory while computing further steps | 4 stages, **20+ calculations** each, increasing load | 4 stages × 20+ calcs | **[reported]** |
| 11 | **Matrices progressives de Raven™** | Fluid reasoning | Classic visual matrix completion (find the missing tile that continues the pattern) | MCQ, standard Raven-style layout | 30 q / 30 min (2024 debrief) | **[reported]** |
| 12 | **Calcul mental 1–4** | Numerical / mental arithmetic | Fast mental arithmetic across four distinct response modes | Four graded levels/sub-tests: **free numeric response**, **equations** (solve for x), **smallest interval** (choose the tightest bracket containing the true value), **all intervals** (select every interval that contains it) — i.e. progressively more demanding answer formats over the same underlying arithmetic | 10 calculations per series (4 series) — ~40 items total | **[reported]** |
| 13 | **Psychomoteur** (final test of the day) | Multitasking / psychomotor | Continuous divided attention across 4 simultaneous channels: dual-axis analog tracking, gauge-nulling, target-letter cancellation, timed arithmetic | **Left joystick + its two thumb buttons**: select and re-center 4 randomly-drifting gauges. **Right joystick**: track a moving crosshair inside a circle with direct, continuous, 2-axis proportional control (the "contrôle à 2 axes" the TestPilote article names separately). **Keyboard F1–F9**: cancel 3 target letters flashed among a 9-letter display. **Numeric keypad**: answer a fresh addition/subtraction problem every **12 s**. Six 3-minute phases, tasks layer in progressively over phases 1–3, all four run together (with shifting attention-weighting, e.g. phase 5 emphasises letters+calcs at 40 %) through phases 4–6. Scoring: any single sub-task entering its red zone zeroes the whole test instantly | 18 min total (6 × 3 min phases) | **[reported]**, hardware and structure **[reported, detailed and consistent]** |
| — | Overall count claim | — | — | — | One prep vendor (TestPilote) advertises PSY1 as **"22 tests psychotechniques et psychomoteurs"** in one day; we count 13 named families above (some with sub-variants, e.g. "calcul mental 1–4" as 4, cubes as 2 variants), which is compatible with "22" if every sub-test/level is counted separately, but we could not verify a session-dated 22-item list the way `psy0-spec.md` verified PSY0's 14-activity list. | **[reported, unverified as an exact list]** |

**Difficulty and traps (candidate feedback)** **[reported]**
- The 2024 debrief singles out the **psychomotor test** as harder than any trainer prepares you for: "ça va vite mon copain… la durée de temps de réponse… est plus faible qu'à l'entraînement" (the real timing/response window is tighter than Pilotest/EPLtest's), and reports intermittent **hardware flakiness** ("les touches… ne fonctionnent pas tout le temps, parfois 1 fois sur 3") — a reminder that our own build must not assume perfect input fidelity is what candidates actually experience, only what we should aim to deliver.
- **Raven matrices** were reported as noticeably harder than the prep material that same session.
- The **cube net-folding** test's rune-alphabet variant and the **rotation-matching** variant's diagonal/combined-axis rotations are specifically called out as ways the real test defeats rote practice on Pilotest/EPLtest.
- General strategy advice mirrors PSY0: never guess at random under negative marking; prioritise accuracy over raw item count, especially on cubes ("20 justes > 25 dont 5 fausses").

### 2.4 Prep resources candidates actually use for PSY1 **[reported]**

| Resource | Type | Notes |
|---|---|---|
| **Pilotest.com** — dedicated PSY1 page and per-test pages (`/tests/psychomot`, cube rotation, etc.) | Free/paid web trainer | Recreates the ENAC/EPL psychotechnical+psychomotor tests and the class/Stanine scoring; explicitly says training the psychomotor test without joysticks changes the interface and does not build real motor memory. |
| **EPLtest.fr** | Paid trainer | Reference tool "depuis plus de 10 ans" per its own copy; claims to reproduce even known bugs/quirks of the real ENAC hardware for realism. |
| **TestPilote (test-pilote.fr)** | Free/paid trainer + blog | Publishes technique articles (axis-by-axis mnemonic for cube rotation, micro-correction technique for 2-axis tracking); its "Aon cut-e" vendor claim for PSY0 is flagged unreliable in `psy0-spec.md` — treat its PSY1 claims (e.g. "22 tests") with the same caution pending corroboration. |
| **pilote-de-ligne.fr** (`/psy-1-cadets-af/`, `/psy-1-enac-epl/`) | Free guide | Cross-references the Air France cadet PSY1 against the ENAC/EPL competition's own PSY1, useful for spotting which item families are shared vs cadet-specific. |
| Aeronet forum debrief threads (2019, 2020, 2022, 2023, 2024) | Community | Primary source for schedule, hardware anecdotes, and difficulty feedback; same community-ethics norms as for PSY0 (no debrief before the session window closes). |
| *Devenez pilote de ligne — Tests PSY0, PSY1 et PSY2*, F. Bourgine, Dunod 2023 | Book | Same book referenced in `psy0-spec.md`; covers PSY1 as well. |

---

## 3. Which PSY1 activities a keyboard/mouse/gamepad app can rehearse faithfully

| Activity | Faithful on keyboard+mouse? | Faithful on a gamepad/joystick? | Notes |
|---|---|---|---|
| Mathématiques, Calcul mental 1–4, Mémoire de travail I/II, EFG, Lecture de textes, Angles, Compteurs, EFG, Attention soutenue | **Yes** — all MCQ/numeric-input, same shape as most PSY0 families | n/a | Straightforward `McqItem`/`NumericItem` engines. |
| Matrices de Raven, Cubes (net-folding + rotation matching), Tangram | **Yes** (mouse-driven selection/drag) | n/a | Same interaction class as PSY0's `spatial_cubes`/`spatial_viewpoint`/`spatial_overlay`. |
| **Psychomoteur** (dual-axis tracking + gauge nulling + letter cancellation + timed arithmetic) | **Partially** — the letter-cancellation and arithmetic channels map cleanly to keyboard; the **continuous dual-axis tracking and gauge-nulling channels degrade badly on keyboard** (discrete key taps cannot reproduce proportional analog control) and are only approximate on a mouse (no spring-centered self-return, no separate physical left/right sticks) | **Yes, closely** — a USB gamepad's analog thumbsticks are mechanically the same paradigm as the real Thrustmaster joysticks (continuous 2-axis proportional input, spring-centered return); two single-axis joysticks are the ENAC hardware but a single dual-stick gamepad (mapping left stick → gauge task, right stick → tracking task) is a reasonable one-device substitute | This is the one activity worth calling out as "gamepad strongly recommended, keyboard/mouse = non-representative practice only." |

**Flutter/gamepad implementation options** (Flutter has no first-party gamepad API):
1. **`gamepads` package** (pub.dev) — cross-platform plugin; on desktop (Windows/macOS/Linux) it reads native controller APIs (GameInput/GCController/evdev+SDL DB), and **on web it wraps the W3C Gamepad API** directly, reporting numeric button/axis indices with the standard mapping. This is the most promising single dependency for a Flutter app that must run on both desktop and web, since it gives one Dart-facing stream of button/axis events across targets. **[reported — package documentation, pub.dev, accessed 2026-09-13]**
2. **Web Gamepad API via direct JS interop** — for the Flutter web target specifically, `navigator.getGamepads()` can be polled each frame through `dart:js_interop`/`package:web` without the `gamepads` package, if finer control over polling cadence is needed than the package gives (the real psychomotor test is a continuous 60 Hz-ish tracking task, so poll rate matters).
3. **Keyboard fallback** — for platforms/devices with no gamepad connected, map the two tracking axes to arrow-key/WASD discrete nudges and the gauge-nulling buttons to number keys; must be **clearly flagged as a non-representative substitute** in the UI (per the legal/no-guarantees note in `psy0-spec.md` §7, carried into §5 below), never presented as equivalent training for the real joystick test.
4. Recommendation: build the psychomotor engine's **input** as an abstraction (`PsychomotorInputSource` or similar) with three concrete implementations — gamepad (options 1/2), touch virtual sticks (mobile/tablet, flagged non-representative), and keyboard (flagged non-representative) — so the scoring/engine logic never depends on which physical device produced the axis values.

---

## 4. Proposed app blueprint (input for US-101/102/103)

### 4.1 `psy1_full` — full rehearsal (~2 h 45 of active testing, before breaks; the real day runs ~8 h wall-clock including lunch)

All durations/counts are **estimated from the reports above**; mark every value `"estimated": true` unless the source gives a hard number. Family ids are proposals for new `TestFamily.id` entries (EPIC-10, distinct from the EPIC-03/PSY0 ids, though several PSY1 families can literally **reuse** the PSY0 engine — see §4.3).

| Order | Section (family id) | Engine / item type | Items | Section time | Notes |
|---|---|---|---|---|---|
| 1 | `p1_math_word_problems` | generated/bank, `McqItem`/`NumericItem` | 30 | 35 min | Multi-step word problems, harder than PSY0's arithmetic grids. |
| 2 | `p1_tangram` | new, `interactive/drag_construct` | 24 | ~20 min | New drag/construction input (place/rotate pieces); count-occurrence variant as an alt mode. |
| 3 | `p1_attention_sustained` | generated, reuse `attention_rules`/`attention_parity`-style cadence engine | 3 series × 5 | ~9 min | Format itself is an **[open question]**; build against the closest PSY0 paradigm until a fuller debrief is found. |
| 4 | `p1_reading_fr` | content bank (FR passages), `McqItem`, reuse `english_reading`'s renderer pattern | 10 texts | 20 min | French-language reading comprehension. |
| — | *(15 min break, not scored)* | | | | |
| 5 | `p1_angles` | generated, `interactive/multi_select` (reuse `arithmetic_grid`'s multi-select pattern) | ~9 options, ≤4 correct | ~5 min | Count/timing **[assumed]**. |
| 6 | `p1_general_efficiency` | mixed bank, `McqItem` | 35 | 30 min | Content/format **[open question]** — treat as a mixed-topic MCQ bank until clarified. |
| 7 | `p1_counters` | new, `interactive/gauge_read` | ~10 (assumed) | ~10 min (assumed) | Instrument/dial reading; no time-limit info found. |
| 8 | `p1_cube_nets` | reuse `spatial_cubes` engine, extended with a rune-alphabet variant | 2 × 10 | 2 × 20 min | Reuses the PSY0 net-folding engine almost unchanged; add an alphabet/symbol-set param. |
| — | *(~90 min lunch break, not scored)* | | | | |
| 9 | `p1_wm_reverse_span` | new, `SequenceItem`-like | digit sequences 4–9 | ~10 min (assumed) | 3–4 s response window per item. |
| 10 | `p1_wm_calc_back` | new, chained `NumericItem` | 4 stages × 20+ | ~15 min (assumed) | Working-memory-loaded arithmetic. |
| 11 | `p1_raven_matrices` | new, `McqItem` (image-tile matrix) | 30 | 30 min | Classic Raven paradigm; needs a generated/rendered matrix-tile asset pipeline. |
| 12 | `p1_mental_arithmetic` | reuse `arithmetic_grid`-style engine, 4 answer modes | 4 × 10 | ~15 min (assumed) | Free response / equation / smallest-interval / all-intervals answer modes — same underlying arithmetic generator, 4 answer-mode variants. |
| — | *(~10 min break, not scored)* | | | | |
| 13 | `p1_psychomotor` | new, `interactive/multitask_analog` | continuous | 18 min (6 × 3 min phases) | **Requires the gamepad input abstraction of §3**; keyboard/touch fallback flagged non-representative. Scoring: any sub-task in its red zone ⇒ total = 0. |
| | **Total (active testing only)** | | | **≈ 2 h 47 min** | Consistent with a day that also includes ~2 h of breaks/lunch/admin to reach the reported 8:30→17:00 span. |

### 4.2 `psy1_short` — ~20 min warm-up

| Order | Family | Items | Time |
|---|---|---|---|
| 1 | `p1_mental_arithmetic` | 1 × 10 (one answer mode) | 4 min |
| 2 | `p1_raven_matrices` | 8 | 8 min |
| 3 | `p1_cube_nets` | 3 | 6 min |
| 4 | `p1_counters` | 4 | 3 min |
| 5 | `p1_angles` | 3 sets | 2 min |
| 6 | `p1_psychomotor` (short form, gamepad only; skipped entirely if no gamepad is connected, rather than substituted) | continuous | 3 min (1 phase) |
| | **Total** | | **≈ 26 min** |

### 4.3 Mapping to the existing engine runtime

| PSY1 family | Reuses PSY0's `ActivityEngine`/`SessionHost` as-is? | Needs new engine code | Needs a new input abstraction |
|---|---|---|---|
| Math word problems, mental arithmetic (4 modes), reading comprehension, general efficiency, angles | **Yes** — pure `McqItem`/`NumericItem`, drop-in new `ActivityEngine` subclasses, same `SessionHost` chrome | New engine classes (content differs) | No |
| Cube nets, Raven matrices | **Mostly** — `spatial_cubes` can likely be extended in place for the rune-alphabet variant; Raven is a new `ActivityEngine` but the same MCQ-on-image-tile shape as `spatial_viewpoint` | New engine (Raven), extension (cubes) | No |
| Tangram, counters, working-memory span/calc-back, attention soutenue | **Partly** — same `SessionHost` timing/briefing chrome, but each needs a **new interactive item widget** (drag-construct for tangram, dial-read for counters, timed-recall for span) | New engine + new renderer widgets | No (still keyboard/mouse) |
| **Psychomotor (joystick)** | **No** — `SessionHost`'s discrete-answer model (one `Answer` per item, `ItemResult` scoring) does not fit a continuous, multi-channel, streaming-input task with a live composite score that can zero out mid-run | New engine, new renderer, new scoring model (continuous, multi-channel, "any red zone ⇒ 0") | **Yes — this is the one activity that needs a genuinely new input abstraction**: a `PsychomotorInputSource` (or similar) behind gamepad (via the `gamepads` package / web Gamepad API), keyboard-fallback, and touch-virtual-stick implementations, feeding a new continuous-scoring runtime alongside (not necessarily inside) `ActivitySessionController`. |

### 4.4 Recommended kanban edits (for the board owner, not in this PR)

1. **US-101** — retitle/scope to the **non-psychomotor PSY1 content engines**: math word problems, mental arithmetic (4 modes), reading comprehension (FR), general efficiency, angles, counters, tangram, cube-net extension, Raven matrices, working-memory span/calc-back. All reuse `ActivityEngine`/`SessionHost` with new engines/renderers, no new input plumbing.
2. **US-102** — split out as the **psychomotor/joystick engine and input abstraction** specifically: define `PsychomotorInputSource`, integrate the `gamepads` package (desktop + web via Gamepad API) with a keyboard/touch fallback flagged non-representative, and the continuous multi-channel scoring model (4 simultaneous sub-scores, any-red-zone-⇒-zero rule). This is the highest-risk, highest-effort story of EPIC-10 and should not be bundled with US-101's straightforward content engines.
3. **US-103** — content authoring: item banks for math word problems, reading passages (FR), Raven matrix images/tiles, cube-net alphabets (latin + invented "runic" set), general-efficiency question pool, angle-estimation generator; plus the `psy1_full`/`psy1_short` blueprint JSON files themselves.
4. **EPIC-10 description** — update "the engine runtime and progress tracking are reused" to note the **exception**: the psychomotor engine needs new runtime plumbing (continuous scoring, external input), not a pure reuse.
5. Add a realism-options entry (mirroring PSY0's `ExamRealismOptions`): "require gamepad for psychomotor test" (on by default in exam mode; off — with a non-representative banner — in practice mode without a gamepad connected).

---

## 5. Open questions

1. **Personality questionnaire in PSY1** — retired, moved to PSY2, or still present in some form? Sources conflict (§2.1).
2. **Exact format of "Attention soutenue" and "EFG"** — no debrief describes the stimulus/response shape in enough detail to design an engine confidently.
3. **Counters test timing** — per-item or per-series time limit, if any.
4. **Overall activity count** — is it really "22 tests" (TestPilote), or ~13 named families with several graded sub-levels each (our count from the 2024 debrief + Pilotest's category breakdown)? No single dated source lists all items the way `psy0-spec.md` §2.4 could for PSY0's 14.
5. **2025 and 2026 sessions** — no debrief found yet for either; the 2026 PSY1 window (19–30 Oct 2026) has not occurred as of this writing. Everything above should be revisited once 2026 debriefs appear.
6. **Whether the psychomotor test's exact channel assignment (which joystick does what) is fixed or varies by session/workstation.**
7. **Retake content variation** — do candidates who retake PSY1 (before their 2-failure cap) see a different item pool, or the same families with re-randomised content?
8. **Scoring weights** — how the per-family "classes" combine into the pass/fail threshold, and whether the psychomotor test's zero-on-any-red-zone rule is itself a hard elimination or just heavily weighted.
9. **Accessibility** — colour-blindness handling for any colour-coded gauges in the psychomotor test (unknown, same caveat as PSY0's colour N-back).

---

## 6. Sources

Official (Air France) — see `psy0-spec.md` §6 (S1, S2, S3) for the corporate pages that name PSY1's timing window and eliminatory status; none of them describe PSY1's content in detail.

Prep vendors / secondary
- T1 — Pilotest, *Préparation aux tests psy1, sélection Air France cadets*. https://www.pilotest.com/fr/selections/preparez-les-tests-psychotechniques-et-psychomoteurs-des-selections-pilotes-cadets-air-france — accessed 2026-09-13.
- T2 — Pilotest blog, *Journée psy1 à l'ENAC : précisions pratiques*. https://www.pilotest.com/fr/blog/journee-psy1-enac (redirected from https://blog.pilotest.com/journee-psy1-enac/) — accessed 2026-09-13.
- T3 — Pilotest, *Les tests psychotechniques Air France/HOP — psy1 — sélection pilotes pro*. https://www.pilotest.com/fr/selections/preparez-les-tests-psychotechniques-et-psychomoteurs-des-selections-pilote-air-france — accessed 2026-09-13.
- T4 — Pilotest, *Test Psychomoteur ENAC-EPL*. https://www.pilotest.com/fr/tests/psychomot — accessed 2026-09-13.
- T5 — TestPilote blog, *PSY1 Air France : rotation de cubes 3D et contrôle à 2 axes décryptés*. https://test-pilote.fr/blog/psy1-air-france-cubes-3d-controle-2-axes — accessed 2026-09-13.
- T6 — pilote-de-ligne.fr, *PSY 1 ENAC EPL*. https://pilote-de-ligne.fr/psy-1-enac-epl/ — accessed 2026-09-13.
- T9 — pilote-de-ligne.fr, *PSY 1 cadets Air France*. https://pilote-de-ligne.fr/psy-1-cadets-af/ — accessed 2026-09-13.
- T10 — EPLtest, *Préparation PSY0 & PSY1 Cadets Air France 2026*. https://epltest.fr/fr/psy0-psy1-cadets-air-france — accessed 2026-09-13.
- T11 — TestPilote, *Air France — préparation tests pilote*. https://test-pilote.fr/compagnies/air-france — accessed 2026-09-13. (Same vendor whose "Aon cut-e" PSY0 claim is flagged unreliable in `psy0-spec.md`; its unverified "22 tests" PSY1 claim is carried here with the same caveat.)

Candidate feedback (primary for structure/format)
- T7 — Aeronet forum, *Journée psy1 à l'ENAC* / related hardware threads, *Joysticks Psychomoteur* and *Quels sont les joystick des PSY 1 ENAC ?*. https://forum.aeronet-fr.org/viewtopic.php?t=39555 , https://forum.aeronet-fr.org/viewtopic.php?t=42504 — accessed 2026-09-13.
- T8 — Aeronet forum, *debrief psy1 2020*. https://forum.aeronet-fr.org/viewtopic.php?t=42586&start=240 — seen in search results 2026-09-13 (not fetched in full).
- T4/2024 — Aeronet forum, *Retex psy1 cadet AF 2024* (ordered test list with item counts/timings, hardware flakiness quotes, no personality test that session). https://forum.aeronet-fr.org/viewtopic.php?t=47366 — accessed 2026-09-13.
- T12 — Aeronet forum, *Psy1 Air France 2019*. https://forum.aeronet-fr.org/viewtopic.php?t=40382 — seen in search results 2026-09-13 (not fetched in full).

Packages / platform
- T13 — `gamepads` package, pub.dev (cross-platform Flutter gamepad plugin; web implementation wraps the W3C Gamepad API; desktop implementations use GameInput/GCController/evdev+SDL). https://pub.dev/packages/gamepads — accessed 2026-09-13.

Not found / negative results: no session-dated 2025 or 2026 PSY1 debrief; no official Air France or ENAC page describing PSY1 content beyond timing and eliminatory status; no source confirming or denying a personality questionnaire in the current-cycle cadet PSY1 with certainty.

---

## 7. Legal and ethics note

Same principles as `psy0-spec.md` §7, restated for PSY1:

- **Unofficial.** This project is an independent training aid, **not affiliated with, endorsed by or connected to Air France, Transavia, ENAC, or any of their contractors** (including the ENAC/EPL PSY1 that the cadet PSY1 shares item families with). Trademarks are used only to describe the target selection process.
- **No reproduction of test material.** We do not reproduce real PSY1 items, screens, hardware branding assets, or third parties' compiled question sets (Pilotest/EPLtest/TestPilote's own content and explanations remain their copyright). All items, passages, matrices, cube nets, tangram pieces and rules text in this app are **authored or generated by us**.
- **Format vs content.** A Raven-style matrix paradigm, an N-back-style working-memory task, or a dual-axis tracking task is a generic psychometric paradigm and not itself proprietary; specific item pools, artwork, and explanatory text are, and must stay original to us.
- **No guarantees, and an extra caveat for the psychomotor test specifically:** because that test needs physical hardware (joysticks/gamepad) that most desktop/laptop users do not own, the app must clearly label keyboard- or touch-based practice of that activity as **non-representative** of the real test, never implying equivalent preparation.
- **Fair play.** Same as PSY0: no "submit what you saw" leak-collection feature; remind users of community norms around not debriefing before a session window closes.
- **Data.** Local practice data only; no webcam or identity data; if cloud sync is added later, results stay private by default.

The FR/EN disclaimer text and store-listing line from `psy0-spec.md` §7 apply unchanged to a PSY1 module; no PSY1-specific wording is needed beyond adding "ENAC" to the list of entities the app is not affiliated with, which is already covered by the existing disclaimer's "ni approuvée par Air France, Transavia, l'ENAC ou leurs prestataires."
