---
id: US-027
issue: 31
title: "English engine: reading comprehension first, grammar, listening/speaking stretch"
type: story
epic: EPIC-03
status: done
priority: P0
size: M
lane: engines
depends_on: [US-021]
labels: [engine,content-driven,mvp]
---

# US-027 — English engine: reading comprehension first, grammar, listening/speaking stretch

**As a** candidate **I want** TOEIC-like English practice **so that** I am ready for the "anglais renforcé" part of PSY0.

Real test (spec §2.4-O): since 2022, reading comprehension on texts, images and graphs, ~45 MCQ in 30 min, passage re-displayable; since 2026 also listening + recorded speaking (format unknown — open question 1).

## Acceptance criteria
- [x] `english_reading`: passage panel (text / image / chart) always re-openable, 3–5 linked MCQs, strict section timer (30 min / 45 q default)
- [x] `english_grammar`: gap-fill MCQ (4 options incl. ∅) — cheap secondary drill
- [ ] `english_listening` (stretch): MCQ with an audio stimulus (`MediaRef` audio), play-once option for realism — only if the model/asset pipeline supports audio; otherwise leave a documented stub
- [ ] `english_speaking` (stretch, practice-only): prompt + 45 s prep + 60 s recording, playback, self-assessment checklist; no automatic scoring
- [x] Item sampling balances sub-tags (see notes: the "avoid items seen in the last N sessions" half is a pre-existing, launcher-wide gap, not specific to `english` — see Notes)
Content: US-082.

## Notes (implementation)

**The `Passage` contract gap (documented on `PassageResolver` in
`mcq_renderer.dart`, US-021) is closed:**
- New content mirror table `passages` (`core/db/tables/content_tables.dart`),
  `AppDatabase.schemaVersion` 1 → 2 (`core/db/app_database.dart`; the
  upgrade only creates the table — content mirrors are re-seeded from
  assets, no data migration needed — see the class doc comment).
- `ItemBank.passages` is now actually collected by the loader
  (`core/db/seed/content_bundle_loader.dart`, previously parsed and
  discarded) and seeded (`content_seeder.dart`, `ContentRows.passage`).
- `ContentRepository.passage(id)` / `.passagesByIds(ids)`, implemented by
  `LocalContentRepository` and `InMemoryContentRepository`; contract test in
  `content_repository_contract.dart` (`passages round-trip and are found by
  id`) runs against both.
- `practice_session_builder.dart` gained a generic `PassagesLoaded` hook
  (`onPassagesLoaded`) called with every distinct passage a session's
  sampled bank items reference; the launcher screens
  (`practice_launcher_screen.dart`, `train_screen.dart`) wire it to
  `EnglishPassageCache` (`features/engines/english/presentation/`), a small
  provider-held `Map<String, Passage>` the `PassageResolver` reads
  synchronously. `engine_registry_provider.dart` registers
  `McqRenderer(familyId: 'english', passageResolver: (id) =>
  ref.read(englishPassageCacheProvider).get(id))`.

**Family-aware item sampling** (`practice_session_builder.dart`):
`ItemSampler` typedef + `itemSamplers` map keyed by family id (default
`balanceByTag`, unchanged); `english` registers `passageAwareSampler`, which
groups candidates into "units" (a passage's whole question group, sorted by
id = authored order, or a standalone item) before doing the same tag-balance
round-robin at unit granularity — a passage is never split, and may push the
final count slightly over what was asked for rather than truncate a set.
Unit tests in `test/features/train/presentation/launcher/item_sampler_test.dart`
(pure function) and `practice_session_builder_test.dart` (wiring +
`onPassagesLoaded`).

**`EnglishEngine`** (`features/engines/english/domain/english_engine.dart`):
`familyId = 'english'`, no generator, default scorer (MCQ choice/skip is all
this family needs). `english.grammar` / `english.vocab` gap-fill items are
plain `McqItem`s with those tags — no separate engine or family; there is no
`english_grammar` family file in the bundle (only `english_listening` and
`english_speaking` do, as documented empty stretch families) — the story
card's phrasing was read as "the grammar acceptance criterion", not a
distinct engine to register.

**Verified against the spec/family/blueprint, no mismatch found:**
`english/family.json` (`defaultItemCount: 45`, `defaultDurationSec: 1800`,
`defaultPerItemTimeSec: 40`) matches `psy0-spec.md` §2.4-O/§3.1 row 14a and
`blueprints/psy0_full.json`'s `s14-english-reading` section exactly.

**Deviations / left alone:**
- `english_listening` / `english_speaking`: out of scope (stretch, no
  content authored yet, US-082); their family files are untouched.
- "avoids items seen in the last N sessions": `ContentRepository.items`
  already takes `excludeIds`, and blueprints carry `avoidRecentSessions`,
  but nothing in `practice_session_builder.dart` computes or passes that
  exclusion set for *any* bank family yet — this is a pre-existing,
  launcher-wide gap (not introduced or fixed here); flagging it since the
  acceptance criterion mentions it, so a future story should wire it
  generically rather than per-family.
- The exam runner (US-061, blueprint-driven sessions) does not exist yet, so
  `blueprints/psy0_full.json`'s `s14-english-reading` /
  `s15-english-listening` sections are unused until then; this story only
  wires the practice launcher.
