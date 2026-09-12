---
id: US-017
issue: 180
title: "Agent-agnostic project skills (.agents/skills) replacing the monolithic docs"
type: story
epic: EPIC-12
status: backlog
priority: P1
size: M
lane: core
depends_on: [US-007]
labels: [docs,agents,tooling]
---

# US-017 — Agent-agnostic project skills (.agents/skills) replacing the monolithic docs

**As a** maintainer **I want** task-shaped, lazily-loaded skills **so that** coding agents read only the conventions they need instead of the whole architecture doc, and the same skills serve any agent tool.

## Layout
```
.agents/skills/<name>/SKILL.md      canonical, agent-agnostic
.claude/skills  -> ../.agents/skills   (symlink, committed)
```
Skills (extracted from `docs/ARCHITECTURE.md`, `docs/TESTING.md`, `docs/DESIGN_SYSTEM.md`, `docs/content/AUTHORING.md`, `docs/kanban/README.md`):
- `ship-a-story` — branch/commit/PR rules (no AI attribution), headless verification commands, l10n ARB rules, kanban card + board update, merge etiquette (registry/ARB hotspots), CI jobs
- `add-activity-engine` — the runtime API and the 5-step recipe, registry conventions, `runSeed`/`index`, answer types, renderer rules (widgets only, keyboard), test template, family/blueprint checks
- `author-content` — bundle layout, item/lesson/deck/lexical-field rules, validator, contentVersion bump
- `data-layer` — Drift tables, repositories, seeding, web storage, backup format
- `design-system` — widgets, theme tokens, no Material rule, gallery, a11y guidelines
- `progress-analytics` — stats service, providers, readiness formula, invalidation hook

## Acceptance criteria
- [ ] Each SKILL.md has YAML frontmatter (`name`, `description` ≤ 1 line naming the trigger task) and a body ≤ ~250 lines that is self-sufficient for its task (links to code paths, not to other docs)
- [ ] `.claude/skills` is a relative symlink to `.agents/skills`; works on macOS/Linux checkouts; documented for Windows (`git config core.symlinks`)
- [ ] `docs/ARCHITECTURE.md` reduced to: repository layout, module map, cross-cutting rules, and a "Skills" index pointing to each skill; no duplicated procedure text (remove what moved)
- [ ] `docs/TESTING.md`, `DESIGN_SYSTEM.md`, `content/AUTHORING.md` keep human-facing reference but link to the skill for the procedure
- [ ] `README.md` "Working with agents" section: skills location, how to add one, agent-agnostic rationale
- [ ] A test (`tools/test/skills_test.dart`) asserting every skill has frontmatter, the symlink resolves, and no skill exceeds the size cap
