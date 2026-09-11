---
id: US-002
title: "State management, DI and routing skeleton"
type: story
epic: EPIC-01
status: backlog
priority: P0
size: S
lane: core
depends_on: [US-001]
labels: [setup]
---

# US-002 — State management, DI and routing skeleton

**As a** developer **I want** Riverpod providers and go_router wired **so that** features can be added as isolated modules.

## Acceptance criteria
- [ ] `ProviderScope` at root, example provider + test showing override pattern
- [ ] go_router with typed routes, one route per tab + nested routes pattern documented
- [ ] Route guard placeholder (e.g. onboarding not completed → onboarding)
- [ ] Error boundary / global error screen
- [ ] Unit test for router redirect logic
