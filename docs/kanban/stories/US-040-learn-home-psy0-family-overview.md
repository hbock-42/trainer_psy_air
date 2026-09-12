---
id: US-040
issue: 35
title: "Learn home: PSY0 family overview"
type: story
epic: EPIC-04
status: done
priority: P0
size: S
lane: learn-ui
depends_on: [US-005,US-010,US-012]
labels: [ui,learn]
---

# US-040 — Learn home: PSY0 family overview

**As a** candidate **I want** an overview of every PSY0 test family **so that** I understand what I will face.

## Acceptance criteria
- [x] Card per family: name, what is evaluated, format (items, duration), my mastery indicator (from US-075 when available, placeholder before)
- [x] Tapping opens the family's lesson list (US-041) with quick actions "Practice" / "Flashcards"
- [x] "How the selection works" page: stages PSY0 → PSY1 → PSY2 → medical, sourced from US-080, with disclaimer

## Notes (implementation)
- Screens: `lib/features/learn/presentation/learn_screen.dart` (home), `family_screen.dart`
  (`/learn/family/:familyId`, lists lesson titles until US-041 builds the viewer),
  `how_it_works_screen.dart` (`/learn/how-it-works`, stages from `psy0-spec.md` §1 with
  confidence chips, calendar, retake rules, full disclaimer).
- Families come from `ContentRepository.families(moduleId: psy0)` in `order`; with nothing
  seeded (before US-013) the home shows a designed empty state.
- Mastery: `familyMasteryProvider(familyId)` (`presentation/providers/`) returns null → "—";
  US-075/US-070 override it with the real computation.
- Quick actions: "Apprendre" → family page, "S'entraîner" → `/train` (US-050 will target the
  family), "Cartes" disabled until US-042.
- Responsive: one column on phones, two columns from 900 dp (same breakpoint as the tab rail).
