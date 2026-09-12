#!/usr/bin/env python3
"""Mechanical content-QA checks for the PSY0 content bundle (US-087).

These checks complement `make content-check` (schema / model / cross-file
rules): they look for things the schema validator does not and cannot check
- duplicate ids or near-duplicate stems across bank files,
- answer-position (correctIndex) skew per bank file,
- French typography (NBSP before ;:!?, guillemets vs straight quotes),
- lexical-field consistency (word ownership, trap/incompatibleWith symmetry),
- the culture_aero tag vocabulary vs docs/content/AUTHORING.md (14 topics).

Read-only: it reports issues, it does not fix them. Run from the repo root:

    python3 tools/content_qa/check_content.py

Exit code is always 0 (this is an aid for a human/content reviewer, not a
CI gate - `make content-check` is the gate).
"""
import json
import glob
import re
import collections

ROOT = "apps/psy_trainer/assets/content/psy0"
NBSP = " "
NNBSP = " "

DOCUMENTED_CULTURE_TOPICS = {
    "culture.flight_mechanics", "culture.meteorology", "culture.human_factors",
    "culture.rules_of_the_air", "culture.navigation", "culture.ops_documents",
    "culture.history", "culture.accidents", "culture.airports_manufacturers",
    "culture.network_geography", "culture.af_fleet_figures",
    "culture.subsidiaries_alliances", "culture.pilot_job_cadet_path",
    "culture.institutions",
}


def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def check_punct(text):
    """French typography issues in a prose string. Skips HH:MM / ratio colons
    (colon followed by a digit) and treats 'HOP!' as a brand name, not
    end-of-clause punctuation."""
    out = []
    if '"' in text:
        out.append("straight-double-quote")
    n = len(text)
    for i, c in enumerate(text):
        if c == "!" and i >= 3 and text[i - 3:i] == "HOP":
            continue
        if c == ":" and i + 1 < n and text[i + 1].isdigit():
            continue
        if c in ";!?:":
            prev = text[i - 1] if i > 0 else ""
            if prev and prev not in (NBSP, NNBSP):
                out.append(f"no-nbsp-before-{c}")
    return out


def check_items():
    item_files = sorted(glob.glob(f"{ROOT}/*/items/*.json"))
    ids = collections.defaultdict(list)
    stems = collections.defaultdict(list)
    all_items = []
    for path in item_files:
        data = load(path)
        for it in data.get("items", []):
            ids[it["id"]].append(path)
            stem = it.get("stem")
            if isinstance(stem, dict) and stem.get("fr"):
                stems[(it.get("familyId"), stem["fr"].strip().lower())].append((it["id"], path))
            all_items.append((path, it))

    print("=== Duplicate ids across bank files ===")
    for k, v in ids.items():
        if len(v) > 1:
            print(" ", k, v)

    print("\n=== Near-duplicate stems (same familyId, identical stem.fr) ===")
    for k, v in stems.items():
        if len(v) > 1:
            print(" ", k, v)

    print("\n=== Answer-position (correctIndex) skew per mcq bank file (>45% one index) ===")
    for path in item_files:
        data = load(path)
        dist = collections.Counter()
        n = 0
        for it in data.get("items", []):
            if it.get("type") == "mcq":
                dist[it.get("correctIndex")] += 1
                n += 1
        if n >= 4 and max(dist.values()) / n > 0.45:
            print(f"  {path}: n={n} dist={dict(dist)}")

    print("\n=== French typography (stem/options non-english, explanation always) ===")
    issues = collections.Counter()
    examples = collections.defaultdict(list)
    for path, it in all_items:
        is_english = it.get("familyId") == "english"
        fields = []
        expl = it.get("explanation")
        if isinstance(expl, dict) and "fr" in expl:
            fields.append(("explanation", expl["fr"]))
        if not is_english:
            stem = it.get("stem")
            if isinstance(stem, dict) and "fr" in stem:
                fields.append(("stem", stem["fr"]))
            for i, opt in enumerate(it.get("options", []) or []):
                t = opt.get("text") if isinstance(opt, dict) else None
                if isinstance(t, dict) and "fr" in t:
                    fields.append((f"options[{i}]", t["fr"]))
        for field, text in fields:
            for issue in check_punct(text):
                issues[issue] += 1
                if len(examples[issue]) < 10:
                    examples[issue].append((path, it.get("id"), field, text[:90]))
    for k, v in issues.items():
        print(f"  {k}: {v}")
        for ex in examples[k]:
            print("   ", ex)

    print("\n=== Difficulty distribution per family (bank items) ===")
    fam_diff = collections.defaultdict(collections.Counter)
    for _, it in all_items:
        fam_diff[it.get("familyId")][it.get("difficulty")] += 1
    for fam, dist in sorted(fam_diff.items()):
        print(" ", fam, dict(sorted((k, v) for k, v in dist.items() if k is not None)))

    print("\n=== culture_aero tags vs docs/content/AUTHORING.md (14 topics) ===")
    used = set()
    for _, it in all_items:
        if it.get("familyId") == "culture_aero":
            for t in it.get("tags", []):
                parts = t.split(".")
                if len(parts) >= 2:
                    used.add(".".join(parts[:2]))
    extra = used - DOCUMENTED_CULTURE_TOPICS
    missing = DOCUMENTED_CULTURE_TOPICS - used
    if extra:
        print("  undocumented tags in use:", sorted(extra))
    if missing:
        print("  documented tags never used:", sorted(missing))
    if not extra and not missing:
        print("  OK: exactly the 14 documented topics are in use")


def check_lexical_fields():
    print("\n=== Lexical fields (verbal_boxes/lexical_fields/*.json) ===")
    for path in sorted(glob.glob(f"{ROOT}/verbal_boxes/lexical_fields/*.json")):
        data = load(path)
        fields = data.get("fields", [])
        by_id = {f["id"]: f for f in fields}
        word_owner = collections.defaultdict(list)
        for f in fields:
            for w in f["words"]:
                word_owner[w].append(f["id"])
        for w, owners in word_owner.items():
            if len(owners) > 1:
                # only a problem if the owning fields are not mutually incompatible
                a, b = owners[0], owners[1]
                fa, fb = by_id[a], by_id[b]
                if b not in (fa.get("incompatibleWith") or []):
                    print(f"  {path}: word '{w}' in {owners} without incompatibleWith")
        for f in fields:
            for other in f.get("incompatibleWith", []) or []:
                tgt = by_id.get(other)
                if not tgt:
                    print(f"  {path}: {f['id']} -> missing field {other}")
                elif f["id"] not in (tgt.get("incompatibleWith") or []):
                    print(f"  {path}: {f['id']} -> {other} not reciprocated")
            n = len(f["words"])
            if not (15 <= n <= 25):
                print(f"  {path}: {f['id']} has {n} words (expected 15-25)")


if __name__ == "__main__":
    check_items()
    check_lexical_fields()
