---
id: US-041
issue: 36
title: "Lesson viewer (markdown) with tips and strategies"
type: story
epic: EPIC-04
status: done
priority: P0
size: M
lane: learn-ui
depends_on: [US-040,US-013]
labels: [ui,learn]
---

# US-041 — Lesson viewer (markdown) with tips and strategies

**As a** candidate **I want** to read lessons with images and formulas **so that** I learn methods before drilling.

## Acceptance criteria
- [x] Markdown rendering, callout blocks (Tip / Trap / Method / Example). Deviation: `package:markdown`
  (pure Dart) parsed to an AST and rendered with our own widgets, not `flutter_markdown` (needs a
  Material ancestor, off-limits — see `docs/ARCHITECTURE.md` "No Material, no Cupertino"). Images
  render as an alt-text placeholder (`MarkdownView`); none of the real lessons use one yet. Inline
  formulas (`$...$`) are not in any real lesson either (`AUTHORING.md` allows them); not implemented,
  tracked as a follow-up if content needs it.
- [x] Table of contents (collapsible, per lesson), previous/next navigation within the family, reading
  progress persisted (US-044)
- [x] "Essayer" button at the end of a lesson launches practice on that family (`AppRoutes.trainFamily`,
  resolves to `/train` until a per-family launcher exists)
- [x] Renders correctly in dark mode and at 1.3 text scale
