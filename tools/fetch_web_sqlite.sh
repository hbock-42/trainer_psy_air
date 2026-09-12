#!/usr/bin/env bash
# Refreshes the drift/sqlite3 web assets (US-016): apps/psy_trainer/web/sqlite3.wasm
# and apps/psy_trainer/web/drift_worker.js.
#
# These two files are prebuilt binaries, not code drift/sqlite3 generate for you
# at build time, so they are downloaded once and committed. Compatibility rule
# (see https://drift.simonbinder.eu/platforms/web/#prerequisites and
# https://github.com/simolus3/drift/discussions/3721): a sqlite3.wasm from
# version X needs `package:sqlite3` >= X in pubspec.lock (forward-compatible,
# not backward); keep drift_worker.js's version close to `package:drift`'s.
#
# Usage:
#   tools/fetch_web_sqlite.sh                # download the pinned versions below
#   tools/fetch_web_sqlite.sh --check         # verify pubspec.lock still matches (no download)
#
# After bumping `drift`/`sqlite3` in apps/psy_trainer/pubspec.yaml, update
# SQLITE3_VERSION/DRIFT_VERSION below to match the new pubspec.lock entries,
# re-run this script, and update docs/ARCHITECTURE.md's "Platforms" note
# with the new versions.

set -euo pipefail

# Pinned to apps/psy_trainer/pubspec.lock as of US-016:
#   sqlite3: 3.5.2   (package:sqlite3, transitive via drift)
#   drift:   2.34.4  (package:drift)
SQLITE3_VERSION="3.5.2"
DRIFT_VERSION="2.34.4"

SQLITE3_WASM_URL="https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-${SQLITE3_VERSION}/sqlite3.wasm"
DRIFT_WORKER_URL="https://github.com/simolus3/drift/releases/download/drift-${DRIFT_VERSION}/drift_worker.js"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB_DIR="${ROOT_DIR}/apps/psy_trainer/web"

check_lock() {
  local lock="${ROOT_DIR}/pubspec.lock"
  if [[ ! -f "$lock" ]]; then
    echo "warning: ${lock} not found, run 'dart pub get' first to verify versions" >&2
    return
  fi
  for pair in "sqlite3:${SQLITE3_VERSION}" "drift:${DRIFT_VERSION}"; do
    local name="${pair%%:*}"
    local expected="${pair##*:}"
    local actual
    actual=$(awk -v name="  ${name}:" '
      $0 == name { found=1; next }
      found && /^    version:/ { gsub(/[":]/, "", $2); print $2; exit }
      found && /^  [a-zA-Z]/ { exit }
    ' "$lock")
    if [[ "$actual" != "$expected" ]]; then
      echo "mismatch: pubspec.lock has ${name} ${actual:-<not found>}, this script is pinned to ${expected}" >&2
      echo "update SQLITE3_VERSION/DRIFT_VERSION in tools/fetch_web_sqlite.sh (and re-run without --check)" >&2
      exit 1
    fi
  done
  echo "pubspec.lock matches: sqlite3 ${SQLITE3_VERSION}, drift ${DRIFT_VERSION}"
}

if [[ "${1:-}" == "--check" ]]; then
  check_lock
  exit 0
fi

check_lock
mkdir -p "$WEB_DIR"
echo "downloading sqlite3.wasm (sqlite3 ${SQLITE3_VERSION}) -> ${WEB_DIR}/sqlite3.wasm"
curl -sSL -o "${WEB_DIR}/sqlite3.wasm" "$SQLITE3_WASM_URL"
echo "downloading drift_worker.js (drift ${DRIFT_VERSION}) -> ${WEB_DIR}/drift_worker.js"
curl -sSL -o "${WEB_DIR}/drift_worker.js" "$DRIFT_WORKER_URL"
echo "done. Review the diff and commit both files."
