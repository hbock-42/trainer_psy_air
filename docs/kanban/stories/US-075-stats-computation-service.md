---
id: US-075
title: "Stats computation service"
type: story
epic: EPIC-07
status: backlog
priority: P0
size: M
lane: analytics
depends_on: [US-011,US-012]
labels: [analytics,domain]
---

# US-075 — Stats computation service

**As a** developer **I want** all aggregates computed in one tested service **so that** dashboard, adaptive difficulty and recommendations agree.

## Metrics
- Per family: accuracy, median response time, level (1–5), trend over last 7/30 days, items done, last practised
- Per exam sim: global + per-section score, delta vs previous
- Readiness score 0–100 = weighted mix of family levels, lesson progress (US-044) and exam-sim results; weights in a config file
- Weak areas: families/tags with accuracy below threshold or negative trend

## Acceptance criteria
- [ ] Pure Dart, unit tests with fixture sessions covering edge cases (no data, single session, timeouts)
- [ ] Efficient SQL aggregates in DAOs (no loading all attempts in memory) for time series
- [ ] Exposed via providers with caching invalidated when a session finishes

## Parallel
Can be built right after US-011, before any engine exists.
