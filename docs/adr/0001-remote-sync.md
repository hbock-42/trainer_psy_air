---
status: Proposed
date: 2026-09-12
---

# 0001 — Remote sync strategy (future)

## Context

PSY Trainer (US-001) is local-first: every user table (`sessions`, `attempts`, `item_stats`,
`flashcard_reviews`, `lesson_progress`, `user_profile`) already carries a UUID primary key and
`created_at`/`updated_at` (`AuditedTable`, see `docs/ARCHITECTURE.md` "Data layer"), specifically
so a future sync never needs a schema rewrite (EPIC-13). US-074 (backlog) will add a versioned
JSON export/import ("backup") of all user data with merge-by-id; that payload is the natural
wire format for sync, not a separate design. `core/repositories/` already isolates every feature
behind `ContentRepository`/`ProgressRepository` interfaces, so swapping (or augmenting) the local
Drift implementation for one that also talks to a server touches no feature code.

This ADR is a placeholder per EPIC-13: nothing here is built now. It exists so that if/when
sync is scheduled, the shape of the work is already decided and doesn't get re-litigated.

Constraints shaping the decision:

- **Solo developer.** Minimal ops surface; no time to run/patch a database server.
- **Local-first, offline-first.** The app must work fully offline; sync is a background
  enhancement, never a blocking dependency of any feature.
- **EU data residency.** French audience (PSY0/PSY1/PSY2 prep for French competitive exams);
  GDPR applies, and hosting in the EU avoids a data-transfer conversation entirely.
- **Cost at 0–10k users.** The app is free/low-revenue at this stage; the backend must be ~free
  at 0 users and stay cheap through 10k mostly-inactive-sync users.
- **Content stays bundled, not synced** (`docs/content/CONTRACT.md`): content is authored,
  versioned and shipped in the asset bundle and seeded locally (US-013); a backend, if it
  exists, serves *user data* only, never content.

## Decision

**Recommendation: Supabase (managed Postgres + Auth + Row-Level Security), hosted in an EU
region, with the backup-export JSON (US-074) as the v1 wire payload.**

Reasoning:

| | Supabase | Firebase | Self-hosted Dart (`dart_frog`/`serverpod`) |
|---|---|---|---|
| Data model | Postgres — relational, matches the Drift schema almost 1:1 | Firestore — document store, would need a remodel of `attempts`/`item_stats` aggregation | Whatever we build — Postgres via `serverpod`, or anything via `dart_frog` |
| Region / residency | Pick an EU project region (e.g. `eu-west-1`) at creation, done | EU multi-region exists but is coarser-grained and Google's DPA is the standard fallback, not a first-class regional guarantee for this project size | Full control — self-pick any EU host |
| Auth | Built-in: email magic link, Apple, Google, anonymous sign-in with later linking — exactly the plan below | Built-in, same providers, same anonymous-linking model | Roll your own (or bolt on an auth library) — real work for a solo dev |
| Ops for a solo dev | Managed; free tier covers 0 users, ~$25/mo at modest scale | Managed; free tier generous, cost model is per-read/write which gets awkward once sync polls per row | Full ops burden: hosting, TLS, backups, migrations, monitoring — the thing we're trying to avoid |
| Fit with `packages/psy_content` | N/A — content isn't synced either way | N/A | Would let a Dart backend literally import `psy_content` (it's pure Dart, no Flutter dep, per US-007) — the one real advantage over managed options |
| Conflict/LWW model | Native SQL, trivial per-row `updated_at` comparison, RLS enforces per-user isolation at the DB level | Doable but Firestore's document semantics make per-row LWW and tombstone queries clumsier | Fully in our control, but we write and maintain it |

Firestore's document model is a worse fit than Postgres for tables that are already relational
(`sessions` → `attempts` FK, per-family aggregates via SQL window functions). A self-hosted Dart
backend is the most "monorepo-native" option (`apps/api/` sharing `packages/psy_content`, as
sketched in US-007) and is not ruled out long-term, but for a solo developer today it trades a
few days of Postgres/RLS setup in Supabase for open-ended hosting and auth maintenance, for a
benefit (sharing `psy_content` server-side) that doesn't matter yet because **content is never
synced**. Revisit self-hosting only if/when a server-side reason to run Dart appears (e.g.
server-computed leaderboards needing the engine logic, P2 below).

### Auth

- **Anonymous-first.** The app works fully offline and un-authenticated from install (current
  behavior, unchanged). The first time sync is enabled, an anonymous Supabase session is created
  silently — no signup friction — so P0 (below) needs zero user-facing auth UI.
- **Account linking, later (P1).** The user later links that anonymous identity to a real one
  (email magic link, Sign in with Apple, Sign in with Google) via Supabase's anonymous→permanent
  linking flow. Linking preserves the same `user_id`, so no data migration is needed.

### Sync model

- **Local-first, per-row last-write-wins on `updated_at`.** Every row already has it
  (`AuditedTable`). On push/pull, the row with the later `updated_at` wins; ties break on a
  server-assigned sequence to stay deterministic.
- **Tombstones for deletes.** Hard deletes don't propagate through LWW (a delete has no
  `updated_at` to "win" with). Add a `deleted_at TIMESTAMP NULL` column to every syncable table.
  A delete is `deleted_at = now()` (soft delete locally and remotely); a pull applies it as a
  local soft-delete too, and a background sweep hard-deletes rows tombstoned longer than a
  retention window (e.g. 30 days) once every replica has observed them.
- **Push/pull cursor.** Each client stores a per-table `last_synced_at` (or a server-issued
  opaque cursor). Push: send every local row with `updated_at > last_pushed_at`. Pull: request
  every server row with `server_updated_at > cursor`, apply LWW, advance the cursor to the max
  `server_updated_at` seen. No full-table diffing.
- **Conflict cases per table:**
  - `sessions`, `attempts` — append-only, immutable once written (a session's `endedAt`/`status`
    close it, then it's never edited again in practice). Conflicts are trivial: same id ⇒ same
    content, just insert-if-absent.
  - `item_stats`, `flashcard_reviews`, `lesson_progress` — mutated in place
    (`ON CONFLICT DO UPDATE`) by every attempt/review; genuine LWW candidates. A rare double-write
    from two devices resolves by `updated_at`, accepting the small chance of losing one
    increment — acceptable for spaced-repetition counters, not worth a CRDT.
  - `user_profile` — single row per user; LWW on the whole JSON blob. A future refinement could
    do field-level merge, but it's not needed for v1 given the small field set.
- **Wire payload v1 = the backup export format (US-074).** The versioned JSON produced by
  export (one array per table, `schemaVersion` at the top) is exactly what a sync push/pull
  batch carries; no separate serialization is designed here. This also means the backup file a
  user already saves before sync existed is forward-compatible with it.
- **What is NOT synced:** content (modules, families, items, lessons, decks, flashcards,
  blueprints) and `content_meta` — these are bundled and versioned per `docs/content/CONTRACT.md`
  and reseeded locally (US-013); a server never serves content, only user data.

### Privacy

- **Data held server-side (once sync is opted into):** the tables above, minus content —
  session/attempt history, item statistics, flashcard review state, lesson-read markers, and the
  profile row (exam date, target stage, locale, settings). No raw item content, no free-text PII
  beyond what auth providers hold (email, or nothing for anonymous/Apple-private-relay users).
- **Retention:** tombstoned rows purge after the retention window (above); an idle account (no
  sync, no login) is not proactively deleted, but is subject to the same policy as account
  deletion.
- **Right to erasure:** `clearAll()` (already the local wipe primitive, if present, or its
  equivalent) plus a server-side delete of every row for that `user_id` (and the auth identity
  itself) satisfies GDPR erasure in one action, exposed as a single "delete my data" flow.

## Consequences

- Easier: no schema redesign later — the `AuditedTable` uuid + timestamps decision already made
  in US-011/US-012 pays off directly; the backup format (US-074) does double duty as the sync
  payload, so that story is not throwaway work; RLS lets Supabase enforce per-user isolation
  without hand-written authorization code.
- Harder: adds one more managed dependency and an EU region choice to revisit if Supabase's
  terms or pricing change; tombstone sweeping and cursor bookkeeping are new code paths that
  need their own tests; anonymous→linked account migration is a one-way door that needs care
  (losing the anonymous session before linking loses the data).
- Deferred entirely for now: no code changes ship from this ADR. EPIC-13 stays "not scheduled".

### Phased plan (later stories, not created yet)

- **P0 — Anonymous device backup.** Single device, anonymous Supabase auth, push-only (upload
  the backup payload on a schedule/manual trigger), restore-on-reinstall. No conflict resolution
  needed yet (single writer).
- **P1 — Account + multi-device.** Email magic link / Apple / Google linking; real push+pull with
  cursors, LWW and tombstones as designed above; this is where EPIC-13 "remote sync" actually
  starts.
- **P2 — Aggregates (optional).** Leaderboard-ish cross-user aggregates (e.g. percentile per
  family) computed server-side; the first plausible reason to run server-side logic (a Dart
  backend sharing `packages/psy_content`/engine code becomes attractive here, reopening the
  self-hosted option from the Decision table above).

Stories to create when this is scheduled: `apps/api/` (only if/when P2 needs server logic —
not needed for P0/P1 with Supabase), `packages/psy_api_client/` (thin Dart client wrapping the
Supabase SDK behind an interface next to `core/repositories/`, so features still never import a
vendor SDK directly), and `US-131` (Supabase project + schema + RLS policies), `US-132` (P0
anonymous backup), `US-133` (P1 auth linking + push/pull sync), `US-134` (tombstone sweep +
retention job), `US-135` (erasure flow).

## Alternatives considered

- **Firebase (Firestore + Auth).** Rejected as primary choice: document model is a worse fit
  for relational, aggregate-heavy tables (`attempts`, `item_stats`); EU residency is achievable
  but less clean than picking a Supabase region; auth story is equivalent to Supabase's, so no
  advantage there. Could be revisited if Firebase's typed Dart SDK or offline persistence proves
  meaningfully better in practice — not expected.
- **Self-hosted Dart backend (`dart_frog` or `serverpod`) in `apps/api/`.** Rejected for now:
  correct long-term shape for a monorepo that wants to share `packages/psy_content` server-side
  (per US-007's stated intent), but content is never synced, so that advantage doesn't apply.
  Full ops burden (hosting, TLS, DB backups, auth) is real cost for a solo developer with no
  current server-side logic need. Reconsider at P2 if leaderboard/aggregate computation
  justifies running actual Dart server code.
- **No backend at all (device-to-device sync, e.g. via iCloud/Drive file sync of the backup
  JSON).** Rejected: no real-time multi-device experience, fragile on Android, and still needs
  most of the LWW/tombstone logic designed above without any of the auth/account benefits.
- **CRDTs / field-level merge instead of row-level LWW.** Rejected as over-engineering for the
  current table shapes: `sessions`/`attempts` are append-only (no merge needed) and the mutable
  tables (`item_stats`, `flashcard_reviews`, `user_profile`) are small, low-contention counters
  where losing a rare concurrent increment is an acceptable trade against CRDT complexity.
