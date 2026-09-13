# Kanban — PSY Trainer (Air France cadet selection)

Flutter app to prepare the Air France cadet selection tests (PSY0 first, then PSY1, PSY2).
Local database only for now; remote sync is a placeholder epic.
**UI is built on the Flutter `widgets` layer only — no Material, no Cupertino** (see EPIC-01).

Shipping a card (branch, commit, PR, board update) is the `ship-a-story` skill
(`.agents/skills/ship-a-story/SKILL.md`).

- **[BOARD.md](BOARD.md)** — index of every card (regenerate with `./gen_board.sh`)
- **[ROADMAP.md](ROADMAP.md)** — milestones, parallel lanes, dependency graph
- `epics/` — one file per epic (`EPIC-xx-*.md`)
- `stories/` — one file per user story (`US-xxx-*.md`)

## Columns

`backlog` → `ready` → `in-progress` → `review` → `done`

The column is the `status:` field in the card's frontmatter. `ready` means every card in
`depends_on` is `done` (or the dependency is only on a merged interface) and the card is
groomed enough to start.

## Card format

```yaml
---
id: US-023
title: "Mental arithmetic generator"
type: story            # epic | story
epic: EPIC-03
status: backlog
priority: P0           # P0 = PSY0 MVP, P1 = PSY0 complete, P2 = later stages/nice-to-have, P3 = future
size: M                # S ≈ ≤1 day, M ≈ 2–3 days, L ≈ a week
lane: engines          # who can work on it in parallel — see ROADMAP.md
depends_on: [US-020,US-022]
labels: [engine,generator]
---
```

Each card carries `issue: N`, the number of its GitHub issue. Stories are sub-issues of their
epic and `depends_on` is mirrored as "blocked by" on GitHub. The board lives at
<https://github.com/users/hbock-42/projects/3> (fields: Status, Priority, Size, Lane, Epic).

## Numbering

- `US-00x` foundation · `US-01x` data · `US-02x/03x` engines · `US-04x` learn · `US-05x` practice
- `US-06x` exam · `US-07x` analytics · `US-08x` content · `US-09x` settings
- `US-10x` PSY1 · `US-11x` PSY2 · `US-12x` quality · `US-13x` remote

## Rules of thumb

1. **US-080 (research) and US-010 (content contract) first.** They unblock every lane.
2. One PR per story, branch `us-023-mental-arithmetic`, PR title `US-023: Mental arithmetic generator`.
3. A story is `done` when its acceptance checklist is ticked, tests pass in CI and the PR is merged.
4. Content (JSON/markdown) never requires a Flutter change; if it does, the contract (US-010) is versioned.
