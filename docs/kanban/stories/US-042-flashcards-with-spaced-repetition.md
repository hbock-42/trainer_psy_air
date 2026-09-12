---
id: US-042
issue: 37
title: "Flashcards with spaced repetition"
type: story
epic: EPIC-04
status: done
priority: P1
size: M
lane: learn-ui
depends_on: [US-011,US-040]
labels: [ui,learn]
---

# US-042 — Flashcards with spaced repetition

**As a** candidate **I want** flashcards for vocabulary, formulas and conversions **so that** I memorise efficiently.

## Acceptance criteria
- [x] Decks per family/topic (English vocab, physics formulas, unit conversions, mental-math tricks)
- [x] Leitner (5 boxes) scheduling stored in `flashcard_reviews`; "due today" count on the Learn home
- [x] Flip animation, self-grade buttons (Again / Hard / Good), keyboard shortcuts
- [x] Unit tests on the scheduler

## Delivered

Decks (`assets/content/psy0/<family>/decks/*.json`, `deck.<slug>` ids per
`AUTHORING.md`): `culture_aero.deck.culture-generale` (70 cards: IATA/ICAO
codes, AF fleet facts with dates, aviation history, institutions),
`arithmetic_grid.deck.mental-math` (43: squares 11²-25², ×11/×25 tricks,
fractions ↔ percentages, operator priorities), `english.deck.vocab-grammar`
(63: aviation vocabulary + tricky grammar pairs), `logic_dominos.deck.modulo7`
(17: modulo-7 sequence patterns), `memory_nback.deck.method` and
`attention_rules.deck.method` (10 each: method reminders). `contentVersion`
bumped to 2; validator reports 0 errors.

`lib/features/learn/domain/leitner_scheduler.dart`: pure-Dart, injectable
clock, 5 Leitner boxes (Again -> box 1, +10 min; Hard -> same box, +1 day;
Good -> box+1 capped at 5, interval of the new box 1/3/7/14/30 days).

`lib/features/learn/presentation/flashcards/` (`FlashcardsScreen` +
`FlipCard`) and `providers/flashcards_queue_provider.dart` /
`flashcards_session_provider.dart`: deck summary ("N à réviser · M au
total"), flip animation (`AnimatedBuilder` + `Transform`), Again/Hard/Good
buttons with keyboard 1/2/3 and Space, end-of-session summary. Routes
`/learn/family/:familyId/cards` and `/learn/cards` (review-today, every due
card across decks). Learn home shows "À réviser aujourd'hui" when any card
is due; the family page's "Cartes" button is enabled once a deck exists for
that family. Persisted through the existing `ProgressRepository`
(`flashcardReview`/`saveFlashcardReview`/`dueFlashcardReviews`); no repository
changes were needed.
