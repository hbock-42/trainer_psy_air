---
id: EPIC-02
issue: 2
title: "Content model & local database"
type: epic
status: done
priority: P0
lane: core
---

# EPIC-02 — Content model & local database

Defines how training content (lessons, items/questions, exam blueprints) and user data
(sessions, attempts, answers, stats) are modelled and stored **locally**.

## Goal
- A single, versioned content contract (Dart models + JSON schema) that every test engine,
  the learn mode and the content authors share. **US-010 is the synchronisation point for
  parallel work**: once merged, engines (EPIC-03), learn UI (EPIC-04) and content authoring
  (EPIC-08) can all proceed independently.
- Local SQLite database (Drift) behind repository interfaces so that a remote backend can be
  plugged in later without touching features. No remote DB in scope for now.

## Stories
US-010, US-011, US-012, US-013, US-014

## Out of scope
Remote sync, accounts, cloud backup (see EPIC-13).
