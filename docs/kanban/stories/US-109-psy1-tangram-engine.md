---
id: US-109
issue: 169
title: "PSY1: tangram engine"
type: story
epic: EPIC-10
status: review
priority: P2
size: L
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-109 — PSY1: tangram engine

Spec §2.3-2: 24 boards; compose a target silhouette from a fixed piece set, or (2024 variant) count how many times a piece/shape occurs.
- [x] Core: the 7 tangram pieces as polygons, placement with rotation/flip on a grid, exact-cover check against a target silhouette; generator builds solvable targets by random assembly; occurrence-count variant
- [x] Renderer: drag/rotate/flip pieces (widgets-layer drag), auto-validate on exact cover; count mode = numeric keypad
- [x] Tests: cover check, solvability, SessionHost run with drags
