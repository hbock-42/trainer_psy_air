---
id: US-002
issue: 15
title: "State management, DI and routing skeleton"
type: story
epic: EPIC-01
status: review
priority: P0
size: S
lane: core
depends_on: [US-001]
labels: [setup]
---

# US-002 — State management, DI and routing skeleton

**As a** developer **I want** Riverpod providers and go_router wired **so that** features can be added as isolated modules.

## Acceptance criteria
- [x] `ProviderScope` at root, example provider + test showing override pattern
- [x] go_router with typed routes, one route per tab + nested routes pattern documented
- [x] Route guard placeholder (e.g. onboarding not completed → onboarding)
- [x] Error boundary / global error screen
- [x] Unit test for router redirect logic

## Notes (implementation)
- Branch `us-002-riverpod-router`. Routing + state conventions documented in
  `docs/ARCHITECTURE.md` ("State and DI", "Routing").
- Route paths are constants (`AppRoutes`), not `go_router_builder` typed routes: no codegen, no
  Material dependency, enough for a small route table.
- `AppPage` is a `Page` + custom `PageRoute` (no `MaterialPage`); every route uses it.
- `onboardingCompletedProvider` is a `NotifierProvider<..., bool>` defaulting to `true`
  (`StateProvider` is legacy in Riverpod 3); US-090 backs it with the DB.
- Placeholder screens only; the tab bar comes with US-005.
