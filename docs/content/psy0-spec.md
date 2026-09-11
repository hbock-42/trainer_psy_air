# PSY0 — the Air France Cadets online pre-selection: what it really is

_Research deliverable for US-080 (GitHub #56). Feeds US-060 (exam blueprint) and the family list of EPIC-03._
_Research done 2026-09-11, i.e. one week after the September 4–5, 2026 PSY0 session. All URLs were accessed on that date unless stated otherwise._

## How to read this document

Every factual claim carries one of three tags:

| Tag | Meaning |
|---|---|
| **[confirmed]** | Stated by an official Air France source (corporate site, FAQ, job offer, press release). |
| **[reported]** | Consistent candidate feedback (Aeronet forum debriefs 2019–2023, Pilotest session notes up to Sept 2026) and/or prep vendors. Reliable for structure, less so for exact numbers. |
| **[assumed]** | Our best guess where nothing precise was found. Blueprint values marked this way must stay flagged "estimated" in `psy0_full.json`. |

**Headline findings (TL;DR)**

1. PSY0 is a **remote, proctored, ~3 h online battery of ~14 short "activities"** run on a dedicated desktop application (Windows/macOS, webcam required) supplied by an Air France contractor, taken at home inside a 36 h window on the first weekend of September. **[confirmed]** for modality/duration/window, **[reported]** for the 14-activity structure.
2. The battery is **not** a maths/physics exam. It is a set of **speeded cognitive mini-games** (working memory, attention, spatial visualisation, planning, semantic categorisation, arithmetic error-checking, multitasking) plus **two knowledge tests: aeronautical general culture and English**. **[reported, very consistent 2019–2026]**
3. The mini-games are, by all candidate accounts, near-clones of the free trainer **Pilotest.com** (candidates literally grade the real test as "fidèle à Pilotest"). Pilotest itself is a re-creation of the real battery from candidate debriefs. This gives us a precise picture of formats and timings, but also a legal constraint: we must build our own items and our own rules text, not copy Pilotest's. **[reported]**
4. **2026 change:** the TOEIC prerequisite was dropped; an "anglais renforcé" test (listening, reading, speaking) is now embedded in PSY0. **[confirmed]** Its exact format is **not public** as of today. **[open question]**
5. **The aeronautical-culture test grew** at the September 2026 session: 48 MCQ items, one per screen, no going back, and the instruction no longer mentions negative marking nor a "je ne sais pas" option (earlier sessions: 20–35 items, +3/−1, abstain allowed). **[reported — Pilotest post-session note, 2026-09-08]**
6. Consequences for the kanban: EPIC-03 must **add** an *Aeronautical culture* family and a *Multitasking / psychomotor* family, **re-scope** *Maths/physics knowledge* (not in PSY0) and *Memory* (N-back, not digit span), and **re-shape** *Attention* and *Spatial* into the concrete game formats listed below. See §4.

---

## 1. The whole selection process at a glance

| # | Stage | What it is | Where | Eliminatory? | Source |
|---|---|---|---|---|---|
| 0 | **Dossier de candidature** | Online application on the Air France recruitment portal, June–July. Diploma / medical / nationality prerequisites checked; 200 € fee (waived for French state scholarship holders). Paper applications are not processed. | Online | Yes — only "recevable" files are invited to PSY0 | **[confirmed]** AF corporate page (S1) |
| 1 | **PSY0 — pré-sélection** | Online remote battery, first weekend of September, "intégrant différents tests de logique, de raisonnement, de culture générale aéronautique et d'anglais renforcé". Produces a **ranking** ("classement") of candidates for the next stage. ~3 h inside a 36 h window (Paris time), secure software + webcam. | At home, proctored software | Yes — ranking with an internal threshold; a waiting list exists. 3 failures = permanent exclusion from the Cadet track. | **[confirmed]** S1 FAQ; waiting list **[reported]** Aeronet 2022/2023 |
| 2 | **PSY1 — tests psychotechniques et psychomoteurs** | One full day of computer-based cognitive and psychomotor tests (joysticks, dual-task, tracking, Raven-type matrices, counters…). During the Toussaint school holidays (19–30 Oct 2026). | ENAC Toulouse (**[reported]**; the official page only says "sur une journée lors des vacances de la Toussaint") | Yes — reported ~70 % elimination. 2 failures = permanent exclusion from the Cadet track. | **[confirmed]** S1; venue/rate **[reported]** S8, S9, S15 |
| 3 | **PSY2 — sélection finale** | Two personality inventories, one group exercise (under NDA), one individual interview with psychologists and pilots. From January of the following year. AF explicitly says paid group-exercise coaching "n'a démontré aucune plus-value". | Roissy-CDG, Air France selection department | Yes — "réussite" or "ajournement" (1 year → PSY2 only again; 2 years → full process again) | **[confirmed]** S1 |
| 4 | **Commission de recrutement** | Reviews PSY2 files, decides success / ajournement. Written debrief only after a first PSY2 ajournement. | — | Yes | **[confirmed]** S1 |
| 5 | **Medical class 1** | Class 2 medical is required *at application* (deposited by 31 Aug 2026); a **class 1** medical is required *before entering flight school*. | AeMC | Yes | **[confirmed]** S1 |
| 6 | **Training** | 24 months (9 months ATPL theory + 15–21 months CPL/IR-ME/MCC, ~150 h flight + 80 h sim) in an AF partner school, housed, paid 65–100 % SMIC (contrat de professionnalisation en CDI). ~5 % failure rate, no repayment on failure. Assignment AF (A220/A320) or Transavia (737/A320neo) is not chosen by the cadet. | Partner ATO | — | **[confirmed]** S1, S3 |

**2026 campaign calendar** **[reported, consistent across S8, S9, S10, S12 which quote the official offer]:** applications ~15 June → 31 July 2026; PSY0 4–5 September 2026; PSY1 19–30 October 2026; PSY2 from January 2027. Official page wording: PSY0 "le premier weekend de septembre", PSY1 "lors des vacances de la Toussaint", PSY2 "en début d'année prochaine". **[confirmed]**

**Volumes** **[reported]:** ~4 400 applications in 2018 (S22), ~2 400–3 000 in 2020–2022 (S16), roughly 500–600 invited to PSY1, ~80–105 cadets selected per campaign; >300 cadets hired since the 2018 relaunch **[confirmed]** (S3).

**Retake rules for the Cadet track** **[confirmed]** (S1):
- 3 failures at PSY0 → definitive elimination from the Cadet track (the "Pilote professionnel" track remains open).
- 2 failures at PSY1 → same.
- 1 ajournement at PSY2 → one more attempt at the Cadet track (after 1 or 2 years depending on the commission's decision).

---

## 2. PSY0 in detail

### 2.1 Modality, platform, proctoring

| Item | Finding | Tag |
|---|---|---|
| Where | "en ligne, en distanciel", "à passer en ligne à votre convenance sur une période de 36 h définie au préalable (heure de Paris)". | **[confirmed]** S1 |
| Duration | "Elle durera environ 3 h" (2026 wording, includes the new English test). Earlier sessions: candidates report ~1 h 30 of effective test time in 2023 (S17), Pilotest says "jusqu'à 2 h 30 selon les sessions" (S5). | **[confirmed]** 3 h; **[reported]** earlier |
| Software | "notre prestataire prendra contact avec vous par mail afin de vous demander de paramétrer votre ordinateur en téléchargeant un software sécurisé (compatible MAC et Windows). Il faudra que votre PC soit équipé d'une webcam." So: a **dedicated desktop app**, webcam-proctored. Not a browser test, not a phone. | **[confirmed]** S1 |
| Resilience | "en cas de coupure internet, vos résultats seront sauvegardés et vous reprendrez le test au moment où ce dernier a été interrompu." | **[confirmed]** S1 |
| Vendor | Candidates in 2019–2020 found the app installed as `air-france-console-pre-selection` (v1.3.1), logs under `AppData/Roaming` (Windows) / `Library/Application Support` (macOS) — i.e. an Electron-style desktop app. Candidate support mailbox `support@preselectionpiloteaf.fr`, results portal `resultats.preselectionpiloteaf.fr` (S18, S16). One experienced Aeronet member (ex-airline FO) states the contractor is the company behind **HappyNeuron** (Scientific Brain Training, Lyon) and that "les exercices sont tirés d'HappyNeuron et légèrement modifiés" (S19); Pilotest's 2018 pre-session blog also hints at SBT/HappyNeuron (S22). One prep site (test-pilote.fr, S9) claims **Aon cut-e** — this contradicts every candidate debrief and Aon's known catalogue (scales lt-e etc. never appear in debriefs); treat as **unreliable**. | **[reported]** — HappyNeuron/SBT is the likeliest; **[open question]** |
| Hardware interaction | Keyboard keys (letters, arrows, space bar) and mouse drag-and-drop are used by several activities ("Le jour J, vous devez utiliser les touches du clavier" — S5 *Formes et couleurs*; arrows + space + "f" key in the multitask test). No joystick at PSY0 (joysticks are PSY1). | **[reported]** |
| Scratch paper | "Pas droit au brouillon pour les psy0." Calculator obviously not allowed. | **[reported]** S17 |
| Language | Interface and verbal items in **French**; English test in English. | **[reported]** |

### 2.2 Scoring and pass rules

| Item | Finding | Tag |
|---|---|---|
| Output | A **ranking** of candidates; those above an internal threshold go to PSY1, others fail or land on a waiting list ("liste d'attente") called up depending on PSY1 capacity. | **[confirmed]** ranking (S1); waiting list **[reported]** S16, S17 |
| Per-activity score | In 2019–2020 candidates could download their results: **14 activities, each scored in a "classe" from 1 to 4** (quartile-like; class 4 = best). Successful candidates reported e.g. "10 classe 4, 2 classe 3, 2 classe 2"; failed ones had several class 1–2. Later sessions no longer publish per-activity classes (results are a simple admitted / waiting list / not admitted email ~2 weeks later). | **[reported]** S18 |
| Speed vs accuracy | Time is part of the score ("le temps est pris en compte", S20); Pilotest's advice, echoed on forums: never answer at random, "ne sacrifiez jamais la précision pour la rapidité". Candidates believe failing (= not finishing) more than ~2 activities is fatal (S17). | **[reported]** |
| Negative marking | Historically explicit on the *logic series* (−1 per wrong answer, 2019, S23) and on *aeronautical culture* (+3 correct / −1 wrong / 0 "je ne sais pas", 2018–2020, S21). In 2022 a candidate reports "pas de point négatif" on culture; in **Sept 2026** the instruction "n'annonce plus ni points négatifs ni réponse 'je ne sais pas'" (S21, S24). | **[reported]** — assume **no** negative marking on the current culture test, but keep it configurable |
| Ordering of activities | Fixed order imposed by the app, one activity after another, each preceded by an instruction screen and a worked example ("Le questionnaire commence par un exemple"). No going back inside an activity (culture 2026: "présentées une par écran, sans possibilité de revenir en arrière"). | **[reported]** S17, S24 |
| Breaks | No candidate mentions imposed breaks; the 36 h window is the flexibility. Whether the app allows pausing between activities is unknown. | **[open question]** |

### 2.3 Eligibility prerequisites that matter for content

| Prerequisite | Finding | Tag |
|---|---|---|
| Diploma | One of: bac + valid ATPL theory; ≥1 validated year of CPGE (any track except Lettres A/L, integrated prépas included); bac+2 in a scientific field or 120 ECTS; validated M1 or enrolled in M2. → Candidates are **not guaranteed a strong maths/physics background** (M1 in any field qualifies), which is consistent with PSY0 containing no academic maths. | **[confirmed]** S1 |
| English | From the 2026 campaign the TOEIC is no longer required; English is assessed in PSY0 (listening, reading, speaking), mandatory for everyone. Before 2026: TOEIC L&R ≥ 850 (<2 years old), briefly "TOEIC 4 skills" was announced for the 2025 campaign (S10). Target level to prepare: comfortably **B2, ideally C1** — the old 850 TOEIC benchmark maps to B2/C1. | **[confirmed]** rule; level mapping **[assumed]** |
| French | Fluent French; non-native speakers need FCL .055 level 6 in French for the pro track (cadet page: "s'exprimer couramment"). Verbal activity (*boîte à mots*) is in French. | **[confirmed]** |
| Flight experience | None required; at most PPL and/or ATPL theory; **no CPL(A)** at closing date. Aeronautical culture is therefore pitched at **BIA / PPL theory level** plus Air France–Transavia company knowledge. | **[confirmed]** rule; level **[reported]** S17, S21 |
| Medical | Class 2 at application, class 1 before training. | **[confirmed]** |
| Age | No limit, but AF warns success at PSY0/PSY1 is statistically lower for older candidates and training difficulties rise after 35. | **[confirmed]** S1 |

### 2.4 The activities — family by family

The table below merges four dated snapshots of the battery (Jan 2019 result sheets, Jan 2020 debrief, Dec 2022 debrief, Sept 2023 debrief) with Pilotest's rolling notes up to the Sept 2026 session and the EPLtest 2026 list. Names in quotes are the names candidates use (usually Pilotest's); official in-app names (2019 result sheet) are given when known.

Legend for "Sessions": 19 = Jan 2019, 20 = Jan 2020, 22 = Dec 2022, 23 = Sept 2023, 24/25 = per Pilotest notes, 26 = Sept 2026 (Pilotest post-session note or EPLtest 2026 list).

| # | Activity (candidate name / 2019 app name) | Family | What it measures | Format & interaction | Volume / timing (as reported) | Sessions | Tag |
|---|---|---|---|---|---|---|---|
| A | **Memory N-back** — "M2 Back" / "Deux rangs avant"; M3-back numérique in 2023; **M2-back couleurs** in 2024–2025; EPLtest 2026: "Memory chromatique" | Working memory | Updating in working memory | A stimulus (digit, later a colour) shows ~1 s; answer Yes/No whether it equals the one shown 2 (or 3) steps earlier; 1.5 s to answer; missing answer = error | 42 stimuli incl. 2 primers → ~1 min 45 s | 19 20 22 23 24 25 26 | **[reported]** |
| B | **Billes / Éprouvettes** — "Billes", "Éprouvettes de Hanoï" | Planning / spatial | Mental simulation of moves, planning (Tower-of-Hanoi family) | Three U-tubes (capacity 3/2/3) with coloured balls; enter the **minimum number of moves** from start to target configuration. Free numeric input | ~10–20 questions, ~40 s each | 19 23 26 | **[reported]**; absent in 20 and 22 |
| C | **Formes et couleurs** — "Triangle Carré" (2019), "Règles géométriques" (EPLtest 2026) | Attention / rule-based response | Speeded stimulus–response with conditional rules, error feedback shown live ("résilience") | Rules given at start (e.g. *if filled → N for square / X for triangle; if empty → N for blue / X for orange*); shape flashes 0.5 s every 3 s; press the keyboard key. Shapes/colours vary between sessions (2023: green diamonds, pink circles) | 20–41 stimuli reported → ~2 min | 19 20 22 23 26 | **[reported]** |
| D | **Pair / impair** — "Nombres" (2019), "Suites de parité alternée" (EPLtest 2026) | Attention / sequencing | Alternating rule following under time pressure; restart on error | A cloud of numbers; starting from START, click alternately an even then an odd number, each category in ascending order; an error restarts the series; START and END numbers are labelled | 5 series (2022–2023); Pilotest trains 10 | 19 20 22 23 26 | **[reported]** |
| E | **Formes glissées (II)** — "Symétrie"/"Code couleur" (2019–2020) | Spatial / visual overlay | Predicting the result of superposition rules on a grid | Drag 3–4 tile-shapes onto a central grid so that, under the given overlay rules (navy+navy=navy, navy+grey=grey, grey+grey=navy), it reproduces the target grid; auto-advance when solved. Version II (2024→) has heavily overlapping shapes and black cells | 3 boards (2020) → **5 boards** (2022–2026), roughly 60–90 s each | 19 20 22 23 24 25 26 | **[reported]** — Pilotest flags it as "fortement complexifiée" at Sept 2026 |
| F | **Séries logiques** — "QCU Logique" (2019) | Logical reasoning | Inductive reasoning on numeric/alphanumeric/verbal series | MCQ, 15 questions, ~30 s each, −1 per wrong answer (2019); some items imbricate two words (e.g. two words interleaved letter by letter) | 15 q | 19 20 22 23 | **[reported]**; **dropped** per Pilotest after 2023 |
| G | **Dominos** | Logical reasoning (fluid) | Series/matrix induction with modulo-7 arithmetic | Build the missing domino (two halves 0–6) | ~20 q in ~10 min (Pilotest format) | 18, back in 24 25 26 | **[reported]** — EPLtest 2026 lists it; exact count **[assumed]** |
| H | **Airways** — "Flèches" (2019), "Gestion de flux" (EPLtest 2026) | Attention / dynamic strategy | Sustained attention in an evolving scene + strategic choices | Triangles ("aircraft") move along lines; colour buttons re-route aircraft; keep ≤4 aircraft and ≤2 blue in each grey zone while re-routing as few as possible; a violation = "crash" | 10 successive series (~5 min) | 19 20 22 23 26 | **[reported]** |
| I | **Boîte à mots** — "Catégorisation" (2019), "Classement de mots" (EPLtest 2026) | Verbal / semantic | Fast semantic categorisation in French | 4–6 empty boxes; words appear one at a time; click the box whose lexical field matches (first word of a field claims a free box). Timed per word; errors counted | 4–5 series; real test reported as easier lexical fields than Pilotest, with occasional traps | 19 20 22 23 26 | **[reported]** |
| J | **Grilles de calcul** — "Contrôle mathématique" (2019), "Erreurs mathématiques" (EPLtest 2026) | Numerical / mental arithmetic | Fast verification of arithmetic (priorities, squares, divisions) | A 3×3 grid of 9 equalities, 0–4 are wrong; click the wrong ones then validate | 8–10 grids, ~45 s each; real calculations reported "plus simples que Pilotest" | 19 20 22 23 26 | **[reported]** |
| K | **Objets 3D** — "Orientation" (2019), "Point de vue" (EPLtest 2026) | Spatial / perspective taking | Identify the viewpoint from which a 3-D scene was photographed | Scene + 8 numbered viewpoints around a circle; click the right one | 10 q (2022–2023), ~10–15 s each | 19 20 22 23 26 | **[reported]** |
| L | **Cubes 2D/3D — "Dés"** — "Patron de dé" (EPLtest 2026) | Spatial / mental folding | 2D net ↔ 3D cube reasoning | A reference cube net on the left; a second net with missing faces; drag the given faces (possibly flipped by clicking) to rebuild the same cube | 4–5 q (2020) → up to 10 (2022–2023), ~60 s each | 20 22 23 24 25 26 | **[reported]** |
| M | **Psychomoteur / Multitâche** — "Multitâches" (2019) | Multitasking / psychomotor | Divided attention: tracking + matching + arithmetic check simultaneously | Hold the arrow key in the direction a circle moves (tracking); press SPACE when the shape inside the circle equals the reference shape; press F when the framed calculation is wrong. Real tracking target reported "plus erratique" than Pilotest | ~5 min continuous | 19 20 22 23 26 | **[reported]** |
| N | **Culture générale aéronautique** — "QCU Culture Générale" | Knowledge (aeronautics + company) | Passion/interest proxy: BIA/PPL theory (flight mechanics, meteo, nav, rules of the air, instruments, licences), aviation history & figures, airports/IATA/ICAO codes, geography & time zones of the network, Air France–Transavia fleet/figures/leaders/alliances/news, the cadet path itself | Single-answer MCQ, 4 options, one per screen, no back; example first. 2018–2020: 20 q, +3/−1, "je ne sais pas" allowed, ~15 s/q. 2022–2023: 35 q. **Sept 2026: 48 q**, ~18 s/q, no negative marking announced, no "je ne sais pas". It was the **12th activity** of the 2026 session. (Pilotest's own trainer page still says "le jour J, elles sont 30… un peu moins de 18 s chacune" — an older figure; the dated Sept 2026 document says 48.) | 20 → 35 → 48 q | 19 20 22 23 26 | **[reported]** S21, S24, S16, S17 |
| O | **Anglais** | English | 2018–2021: grammar/vocabulary automatisms — sentence with a gap, choose 1 of 4 (incl. ∅), 30 q in ~7–10 min. **Dec 2022 →**: **reading comprehension**, TOEIC-like, 40–45 questions in 30 min on texts, images and graphs, the text can be re-displayed while answering; tight timing (several candidates did not finish). **2026 →**: "anglais renforcé" = **listening + reading + speaking**, speaking recorded via microphone (no live examiner) | MCQ + recorded speaking | 30 q → 45 q/30 min → L+R+S (~1 h?) | 19 20 22 23 26 | 2026 scope **[confirmed]** S1; formats **[reported]** S16, S17, S25, S11; 2026 detailed format **[open question]** |
| — | Retired activities: *Un mot sur deux* (2019–2020, alternate-word sequences), *Mots en étoile / "Nid d'abeille"* (Dec 2022 only, crossword-in-a-star), *Trouvez l'intrus* (2018), *Empilements* (3-D stacks). "Modulo" appears only in the EPLtest 2026 list (probably a modular-arithmetic drill, unverified). | | | | | | **[reported]** S5, S8 |

**Order** **[reported]**: candidates rarely report the exact order; the 2023 debrief that does gives: M3-back → Éprouvettes → Formes et couleurs → Pair/impair → Formes glissées → Logique → Airways → Boîte à mots → Calculs → Points de vue → Psychomoteur → Dés → Culture aéro → Anglais (S17). In 2026 culture was activity #12 (S24), so probably: 11 mini-games → culture (#12) → psychomotor and/or English last. Knowledge tests at the end is consistent across sessions.

**Difficulty, traps and time pressure (candidate feedback)** **[reported]**
- The activities that decide the outcome are those people *fail to finish*: **Formes glissées**, **Airways**, **Cubes**, **Boîte à mots** (many errors), **Culture aéro** ("très dur", "au max 50 % de bonnes réponses", "la mort") and **English** (timing). Memory, Formes et couleurs, Pair/impair, Grilles, Objets 3D are "100 % Pilotest, no surprise" for well-trained candidates.
- Recurrent traps: shapes/colours/keys change vs the trainer (over-conditioning), START/END labels in Pair/impair, slower or faster pacing than the trainer (N-back "bien plus lent", tracking "plus erratique"), no visible timer in the English test, forgetting the text can be re-displayed, a new surprise activity most years (2022 star-crossword, 2023 M3-back and tubes, 2024 dominos, 2026 harder Formes glissées and a longer culture test).
- Culture questions are broad and sometimes very specific (a captain's tie colour, a quote, the number of runways at a given airport) mixed with PPL-level physics/nav (stall speed vs load factor, distance at 240 kt in 15 min, cloud of a warm front, runway/wind geometry). Two question sets are used in parallel to limit leaks.
- Reported effective duration: ~1 h 30 in 2023 for 14 activities excluding the new English L/S parts; official "environ 3 h" for 2026.
- Community ethics: the Aeronet forum enforces "no debrief before the window closes"; leaks/multiple identities are a recurring complaint. Air France states that paid coaching for PSY2 brings nothing; for PSY0/PSY1 the community consensus is that **free tools + hundreds of timed reps** are enough.

### 2.5 Prep resources candidates actually use **[reported]**

| Resource | Type | Notes |
|---|---|---|
| **Pilotest.com** (S5, S21…) | Free web trainer, FR/EN, Stanine scoring | De facto standard; "the vast majority of candidates" train there; publishes post-session notes and culture-question compilations; recommends reaching Stanine 7 on each test. Content is copyrighted. |
| **EPLtest.fr** (S8) | Paid trainer | Used to "déconditionner" from Pilotest; lists the 2026 PSY0/PSY1 activities. |
| **KDTools**, **PrepaCadet.fr** (S26) | Free community tools by ex-/current candidates | Mentioned on Aeronet 2026. |
| **HappyNeuron** (S19, S22) | Cognitive-training site | Said to be the origin of the real exercises. |
| Aeronet forum + a candidates' Discord (S16, S17, S26) | Community | Debriefs, tips, moral support. |
| *Devenez pilote de ligne — Tests PSY0, PSY1 et PSY2*, F. Bourgine, Dunod 2023 (S27) | Book | Screenshots from Pilotest, explanations and tips. |
| *Manuel du pilote d'avion* (Cépaduès), BIA MCQ sites, ChezGligli.net, Air France Wikipedia/corporate site/news (S21, S16) | Culture aéro | Recommended reading for the culture test. |
| TOEIC-style reading/listening material (S25, S11) | English | Since the test is TOEIC-like; The Little English Box sells PSY0-specific coaching. |
| France Prépa, La Préparation Concours, Air Training Academy… (S3, S4) | Paid prep schools | Marketed heavily; community sceptical; one 2 500 € "prépa PSY0" flagged as a scam on Aeronet. |

---

## 3. Proposed app blueprint (input for US-060)

### 3.1 `psy0_full` — full rehearsal (~2 h 20 without the English speaking/listening parts, ~3 h with)

All durations and counts are **estimated from the reports above**; mark every value `"estimated": true` unless noted. Family ids are proposals for `TestFamily.id` (see §4 for the mapping to EPIC-03 stories). Item types refer to the US-010 model; `interactive/*` types do not exist yet in US-010 and are a change request (§4.3).

| Order | Section (family id) | Engine / item type | Items | Section time | Per-item time | Notes |
|---|---|---|---|---|---|---|
| 1 | `memory_nback` | generated, `interactive/nback` (Yes/No at fixed cadence) | 42 stimuli (2 primers) | 1 min 45 s | 1 s show + 1.5 s answer | Colours (3 of 7) by default; option digits / 3-back. Count/timing **[reported]** |
| 2 | `planning_tubes` | generated, `NumericItem` (min moves) | 10 | 7 min | 40 s | 3/2/3 tube capacities. Count **[assumed]** |
| 3 | `attention_rules` | generated, `interactive/stimulus_response` (2 keys) | 36 stimuli | 2 min | 3 s cadence, 0.5 s display | Rules randomised each run; live right/wrong feedback even in exam mode (it is part of the real test). |
| 4 | `attention_parity` | generated, `interactive/click_sequence` | 5 series × 16 numbers | 5 min | ~60 s / series | Restart series on error; START/END labels. |
| 5 | `spatial_overlay` | generated, `interactive/drag_grid` | 5 boards | 6 min | 75 s | Overlay rules navy/grey; version II overlaps. |
| 6 | `logic_dominos` | generated + seed bank, `McqItem`-like (two halves 0–6, free choice) | 16 | 8 min | 30 s | Modulo-7 laws. Count **[assumed]** (Pilotest: 20 in 10 min) |
| 7 | `attention_airways` | generated, `interactive/airways` | 10 series | 5 min | 30 s | Capacity 4 / 2 blue per zone. |
| 8 | `verbal_boxes` | content bank (FR lexical fields), `interactive/categorise` | 4 series × ~20 words | 5 min | ~3 s / word | Needs an authored bank of lexical fields (US-085 re-scope). |
| 9 | `arithmetic_grid` | generated, `interactive/multi_select` (9 cells, 0–4 wrong) | 8 grids | 6 min | 45 s | "Easier than Pilotest": integers, squares, priorities, simple divisions. |
| 10 | `spatial_viewpoint` | generated/asset-based, `McqItem` (8 options) | 10 | 2 min 30 s | 15 s | Needs rendered scenes (assets or simple 2.5-D renderer). |
| 11 | `spatial_cubes` | generated, `interactive/drag_net` | 6 | 6 min | 60 s | Nets with letters/shapes, faces flippable. |
| 12 | `culture_aero` | content bank, `McqItem` (4 options, no back) | 48 | 15 min | 18 s | No negative marking by default; `scoring: {correct:+3, wrong:-1, skip:0}` available as a realism option. Count/timing **[reported 2026]** |
| 13 | `multitask_psychomotor` | generated, `interactive/multitask` | continuous | 5 min | — | Requires physical keyboard (arrows + space + F) — see platform note §4.4. |
| 14a | `english_reading` | content bank, `McqItem` on passages/images/graphs | 45 | 30 min | 40 s | Passage stays available. **[reported 2022–2025]** |
| 14b | `english_listening` | content bank, `McqItem` with audio | 20 | 15 min | — | **[assumed]** — 2026 scope confirmed, format unknown. |
| 14c | `english_speaking` | practice-only: prompt + timed self-recording, no auto-scoring | 3 prompts | 8 min | 45 s prep + 60 s speak | **[assumed]** — practice only, flagged out of scope for scoring. |
| | **Total** | | | **≈ 2 h 08 min (14a only) / ≈ 2 h 31 min (with 14b–c)** + instruction/example screens (~1 min per section) ≈ **2 h 45 min** | | Consistent with the official "environ 3 h". |

Between sections: an instruction screen with a worked example, no time limit but a "Start" button (real app behaviour **[reported]**). No enforced break; the runner may allow a pause between sections (realism option, off by default).

### 3.2 `psy0_short` — ~20 min warm-up

| Order | Family | Items | Time |
|---|---|---|---|
| 1 | `memory_nback` | 42 stimuli | 1 min 45 s |
| 2 | `attention_rules` | 24 stimuli | 1 min 15 s |
| 3 | `attention_parity` | 2 series | 2 min |
| 4 | `arithmetic_grid` | 4 grids | 3 min |
| 5 | `spatial_viewpoint` | 6 | 1 min 30 s |
| 6 | `spatial_cubes` | 2 | 2 min |
| 7 | `logic_dominos` | 5 | 2 min 30 s |
| 8 | `culture_aero` | 12 | 3 min 40 s |
| 9 | `english_reading` | 6 (1 passage) | 4 min |
| | **Total** | | **≈ 21 min 40 s** |

---

## 4. Mapping to EPIC-03 families and recommended kanban changes

### 4.1 Family-by-family verdict

| EPIC-03 family (story) | In the real PSY0? | Verdict | Recommendation |
|---|---|---|---|
| English — grammar, vocabulary, reading (US-027) | **Yes**, but the format moved from gap-fill grammar (≤2021) to **reading comprehension** (2022→) and now **listening + reading + speaking** (2026). | **Keep, re-shape** | Primary engine = reading comprehension MCQ on passages/images/graphs with the passage re-displayable; secondary = gap-fill grammar drill (cheap, still useful); add listening MCQ if audio assets are feasible; speaking = practice prompts with self-recording, no scoring. US-082 (English bank) must author passages, not only sentences. |
| Maths / physics knowledge, bac level (US-028) | **No.** No academic maths/physics test exists in PSY0. The only "maths" are speeded arithmetic error-checking (grids) and calc-checking inside the multitask test; PPL-level flight-mechanics/nav questions live inside the culture test. | **Drop / re-scope** | Re-scope US-028 + US-083 into **`culture_aero`** (see below). Keep a small "flight physics & navigation arithmetic" sub-topic there (stall/load factor, speed–time–distance, headings, time zones). |
| Mental arithmetic (US-023) | **Yes**, as *Grilles de calcul* (verify 9 equalities, flag the wrong ones) + arithmetic checks in the multitask test. Free-input mental arithmetic drills are **PSY1**, not PSY0. | **Keep, re-shape** | Generator must produce *grids of equalities with 0–4 errors* (priorities, squares, divisions, ± traps) with multi-select answers; keep free-input drills as practice mode only. |
| Logical reasoning — series, matrices (US-024) | **Partly.** *Dominos* are current (2024→); *séries logiques* (alphanumeric MCQ) were dropped after 2023; Raven-type matrices are **PSY1**. | **Keep, re-prioritise** | Dominos generator first (modulo-7 laws), alphanumeric series second, figure matrices last (PSY1 value only). |
| Spatial reasoning — rotations, folding (US-025) | **Yes, strongly** — the largest family: *Cubes 2D/3D* (net folding, drag faces), *Objets 3D* (viewpoint), *Formes glissées II* (overlay), plus *Billes* (planning). | **Keep, expand** | Split into concrete games: `spatial_cubes`, `spatial_viewpoint`, `spatial_overlay`, `planning_tubes`. Generic "rotations/mirrors" MCQs are low value. |
| Memory — digits, patterns, sequences (US-026) | **Yes but only as N-back** (2-back colours currently; 3-back digits in 2023). Digit span / pattern recall are not used at PSY0. | **Keep, re-shape** | Build an N-back engine (n=2/3, colour/digit stimuli, fixed cadence). Drop digit span unless wanted for PSY1 later. |
| Verbal reasoning (US-030, US-085) | **Yes as semantic categorisation** (*Boîte à mots*, French): fast lexical-field sorting. Not analogies / syllogisms. | **Keep, re-shape** | Engine = word stream → click the right box; content = authored French lexical fields (5–8 fields × 15–25 words each, with deliberate near-miss traps). |
| Attention / concentration (US-029) | **Yes** — three distinct games: *Formes et couleurs* (rule-based key response with live feedback), *Pair/impair* (alternating ascending clicks with restart), *Airways* (flow management). | **Keep, split** | Three engines; all procedural. Airways is the most complex (small simulation). |
| *(missing)* Aeronautical general culture | **Yes — central, 48 items in 2026, the activity candidates fear most.** | **Add** | New family `culture_aero` + authoring story: BIA/PPL theory (14 topic areas — flight mechanics & instruments, meteorology, human factors, rules of the air, navigation/radionav, ops documents, aviation history, major accidents, airports & manufacturers, network geography, AF fleet & figures, subsidiaries & alliances, the pilot job & cadet path, institutions). Items must carry a `validAsOf` date for perishable facts (fleet counts, CEOs, new routes). |
| *(missing)* Multitasking / psychomotor | **Yes** (5 min, keyboard tracking + shape match + calc check). | **Add (desktop/keyboard only)** | New family `multitask_psychomotor`; needs physical keyboard → desktop targets or external keyboard; on touch devices offer a touch adaptation flagged "non-representative". |

### 4.2 Suggested kanban edits (to be done by the board owner, not in this PR)

1. **EPIC-03 table**: replace the eight abstract families with the concrete list of §3.1 (13 game families + English sub-engines). Keep US numbers, rename stories.
2. **US-028 / US-083**: retitle to *Aeronautical culture engine / item bank* (MCQ bank, ≥300 items across the 14 topic areas, dated facts).
3. **US-026**: retitle to *Memory N-back engine*.
4. **US-030 / US-085**: retitle to *Semantic categorisation ("boîte à mots") engine / French lexical-field bank*.
5. **US-029**: split into three stories (rules S-R, parity sequence, airways) or make it an umbrella with three sub-tasks.
6. **US-025**: split into cubes-net, viewpoint, overlay, tubes.
7. **New story**: *Multitask psychomotor engine* (keyboard), P2, desktop only.
8. **US-027 / US-082**: English = reading passages first; listening/speaking as stretch goals.
9. **US-010**: add interactive item types (§4.3).
10. **US-063 realism options**: "negative marking on culture", "hide timer in English", "randomise shapes/colours/keys", "allow pause between sections".

### 4.3 Impact on the US-010 content model

`McqItem` and `NumericItem` cover culture, English, dominos (as 2 × 7 choices), viewpoint and tubes. The other games need **engine-owned interactive item types** that the JSON contract should allow as `GeneratedItem` with a `generatorId` + `params` + `seed` (reproducible), and the engine renders its own UI. Proposed generator ids: `nback`, `stimulus_response`, `parity_sequence`, `overlay_grid`, `airways`, `word_boxes`, `arithmetic_grid`, `cube_net`, `multitask`. Blueprint sections must be able to specify **per-item time**, **per-section time** and **cadence** (fixed inter-stimulus interval) rather than only a section duration.

### 4.4 Platform note

The real test runs on a **desktop app with keyboard + mouse**. Several activities are keyboard-native (Formes et couleurs keys, multitask arrows/space/F). A phone-only trainer cannot faithfully rehearse those two; tablets with a keyboard or desktop builds (Flutter macOS/Windows/web) can. Recommend targeting **desktop/web + tablet** for exam mode and clearly labelling touch adaptations.

---

## 5. Open questions

1. **English 2026 format** — number of items, duration, item types for listening and speaking, whether speaking is scored by humans or automatically, how English weighs in the ranking (is there an eliminatory threshold?). No post-session debrief found yet (window closed 2026-09-05; Aeronet threads had not published one by 2026-09-11).
2. **Vendor** — confirm HappyNeuron/SBT vs another contractor; whether the app is still the `air-france-console-pre-selection` Electron app in 2026.
3. **Exact 2026 activity list and order** — Pilotest and EPLtest lists disagree on *Formes glissées* (Pilotest: present and harder; EPLtest list omits it) and on "Modulo" (EPLtest only). Waiting for 2026 debriefs.
4. **Item counts** for billes, dominos, cubes in the real 2026 session.
5. **Scoring model** — is speed scored per item (reaction time) or only completion within time? Are activities weighted equally in the ranking? Is there a per-activity minimum ("ne pas rater plus de 2 tests")?
6. **Negative marking in 2026** on culture (instruction silent) and whether dominos/others penalise wrong answers.
7. **Pausing** between activities and behaviour of the 36 h window (can the session be split?).
8. **PSY1 venue for cadets in 2026** (ENAC Toulouse per prep sites; official page does not name it).
9. **PSY0 for the "Pilote professionnel" track** — existed briefly in 2019–2020, apparently not since; out of scope but worth tracking.
10. **Accessibility / colour-blindness handling** of the colour N-back and Formes et couleurs in the real app (unknown).

---

## 6. Sources

Official (Air France)
- S1 — Air France Corporate, *Pilote de ligne* (FR), sections "Filière Pilote Cadet à Air France", "Le déroulé de la sélection", "Règles d'ajournement et d'élimination", FAQ "Comment se passe la pré-sélection ?". https://corporate.airfrance.com/fr/pilote-de-ligne — page last published 2026-09-04, accessed 2026-09-11 (site blocks plain fetchers; read through a text proxy). English version: https://corporate.airfrance.com/en/airline-pilot
- S2 — Air France Corporate, job offer *Pilote Cadet Air France F/H* (recruitment portal, offer 24920), https://recrutement.airfrance.com/offre-de-emploi/emploi-pilote-cadet-air-france-f-h_24920.aspx — listed by search on 2026-09-11; the portal only served its home page to our fetcher, so dates (4–5 Sept 2026, 19–30 Oct 2026) are taken from prep sites quoting it.
- S3 — Air France Corporate news, *Devenez Pilote : la campagne de recrutement du programme Cadets est ouverte !* (2025 campaign, applications 2 June–15 July 2025; >300 cadets since 2018; 25 % women in 2024). https://corporate.airfrance.com/fr/actualites/devenez-pilote-la-campagne-de-recrutement-du-programme-cadets-est-ouverte — accessed 2026-09-11.

Prep vendors / secondary (quote official material, add reported detail)
- S4 — France Prépa, *Cadets Air France : le guide le plus complet…* https://france-prepa.com/cadets-air-france/guide-cadets-air-france/ — accessed 2026-09-11.
- S5 — Pilotest, *Réussir les tests psy0 des sélections Air France cadet* (test list per category, session-to-session changes up to Sept 2025/2026, "12 à 15 épreuves, jusqu'à 2 h 30", English "≈45 questions en 30 minutes"). https://www.pilotest.com/fr/selections/preparez-la-preselection-pilotes-cadets-air-france — accessed 2026-09-11. Per-test rule/timing pages: https://www.pilotest.com/fr/tests/{airways, billes, boxes, cubes_psy0, dominos, english, formes, formes_glissees2, grille_calculs, m2back_color, objets3d, pair_ou_impair, psychomot0, series_psy0_af, culture_generale_aero_cadet_air_france} — accessed 2026-09-11.
- S6 — Pilote-de-ligne.fr, *PSY 0 cadets Air France* ("application spécialement conçue par Air France", 3 parts, culture topics, English 30 q/10 min — pre-2022 format). https://pilote-de-ligne.fr/psy-0-cadets-af/ — accessed 2026-09-11.
- S7 — France Prépa, *FAQ — Sélection Cadets Air France 2026* (PDF, July 2026, "établi d'après les informations officielles Air France"). https://france-prepa.com/wp-content/uploads/faq-selection-cadets-air-france.pdf — accessed 2026-09-11.
- S8 — EPLtest, *Préparation PSY0 & PSY1 Cadets Air France 2026* (2026 activity list: Memory chromatique, Éprouvettes de Hanoï, Suites de parité alternée, Modulo, Dominos, Patron de dé, Règles géométriques, Gestion de flux, Classement de mots, Erreurs mathématiques, Point de vue, Multitâche, Culture générale aéronautique, Anglais; PSY1 list). https://epltest.fr/fr/psy0-psy1-cadets-air-france — accessed 2026-09-11.
- S9 — TestPilote, *Air France — préparation tests pilote* and *Air France Cadet 2026 : calendrier* (claims Aon cut-e — judged unreliable; PSY1 "22 tests, 2 joysticks, élimine 70 %"). https://test-pilote.fr/compagnies/air-france , https://test-pilote.fr/blog/air-france-cadet-calendrier-2026 — accessed 2026-09-11.
- S10 — Piste on Jobs, *Air France cadet : les nouvelles étapes de sélection en 2026* (TOEIC 4-skills announced for the 2025 campaign; superseded). https://www.pisteonjobs.com/air-france-cadet-les-nouvelles-etapes-de-selection-en-2026/ — accessed 2026-09-11.
- S11 — The Little English Box, *PSY0 Air France 2026 : préparer le test d'anglais renforcé* ("Air France n'a pas publié le format exact"; speaking recorded, PC + webcam + micro). https://www.thelittleenglishbox.com/post/psy0-air-france-cadets — accessed 2026-09-11.
- S12 — Pilotecadet.fr, *Présélection — PSY0 Air France* (classes, "viser une classe 7"). https://pilotecadet.fr/preselection/ — accessed 2026-09-11.
- S13 — Superprof, *Sélection Cadets Air France : le PSY0 et le PSY1 expliqués* https://www.superprof.fr/selection-cadets-air-france-psy0-psy1-expliques.html — seen in search results 2026-09-11 (not fetched).
- S14 — Tintin dans les airs, *Sélections Cadets Air France* https://tintin-dans-les-airs.fr/selections-cadets-air-france/ — seen in search results 2026-09-11 (not fetched).
- S15 — Eco Emplois, *Comment intégrer la prestigieuse formation des cadets Air France ?* https://www.ecoemplois.fr/comment-integrer-la-prestigieuse-formation-des-cadets-air-france/ — seen in search results 2026-09-11.

Candidate feedback (primary for structure/format)
- S16 — Aeronet forum, *Débrief PSY0 — Cadets Air France 2022* (Dec 2022 session; 14 activities with per-activity counts; culture 35 q; English 40 q/30 min; support@preselectionpiloteaf.fr; waiting list). https://forum.aeronet-fr.org/viewtopic.php?t=45439 (+ &start=20, 40) — accessed 2026-09-11.
- S17 — Aeronet forum, *Debrif KD AF 2023* (Sept 2023 session; ordered activity list; M3-back and tubes new; formes glissées 5 boards; logic 15 q; airways 10; grids 8; objets 3D 10; English 45 q/30 min TOEIC-like; culture "très dur"; ~1 h 30; "pas droit au brouillon"; app ergonomics praised). https://forum.aeronet-fr.org/viewtopic.php?t=46261&start=40 — accessed 2026-09-11.
- S18 — Aeronet forum, *Résultats PSY0* (2019–2020: 14 named activities with class 1–4 per activity; app `air-france-console-pre-selection` 1.3.1; results portal). https://forum.aeronet-fr.org/viewtopic.php?t=40386&start=20 — accessed 2026-09-11.
- S19 — Aeronet forum, *Cadet AF 2023/2024* p.3 (HappyNeuron/SBT identified as PSY0 contractor; paid prep judged useless; scam warning). https://forum.aeronet-fr.org/viewtopic.php?t=45993&start=40 — accessed 2026-09-11.
- S20 — Aeronet forum, *Débrief PSY0 2020* (Jan 2020 session; 14 activities incl. un mot sur deux, code couleur, dés; "le temps est pris en compte"). https://forum.aeronet-fr.org/viewtopic.php?t=42349 — accessed 2026-09-11.
- S21 — Pilotest blog, *Culture aéronautique cadets Air France, présélection psy0* (2018: 20 q, +3/−1, ~15 s; Sept 2026: 48 q, no negative marking/"je ne sais pas" in the instruction; 14 topic areas; reading list). https://www.pilotest.com/fr/blog/culture-aeronautique-cadets — accessed 2026-09-11.
- S22 — Pilotest blog, *J-2 Présélection cadet Air France !* (2018; 4 400 applicants). https://blog.pilotest.com/preselection-cadets-air-france-2018-1/ — accessed 2026-09-11.
- S23 — Pilotest blog, *Psy0 cadets Air France — janvier 2019 — débriefing* (series 15 q with −1; multitask and word-boxes introduced; dominos and intrus removed). https://www.pilotest.com/fr/blog/psy0-cadets-air-france-2019 — accessed 2026-09-11.
- S24 — Pilotest document, *Test de culture générale aéronautique — Présélections Cadets Air France — Septembre 2026* (PDF, dated 2026-09-08: "douzième activité de la session", 48 questions, one per screen, no back, instruction text). https://www.pilotest.com/documents/test_culture_aeronautique_cadets_air_france_septembre_2026.pdf — accessed 2026-09-11. Only the structural preamble was used; questions were not copied.
- S25 — Aeronet forum, *Anglais Psy0, vos astuces ?* (Dec 2022 switch to reading comprehension "TOEIC++", text re-displayable). https://forum.aeronet-fr.org/viewtopic.php?t=45899 — accessed 2026-09-11. Also *Anglais sélection Cadets AF* (Aug 2026, candidates unsure how to prepare the new L/R/S test). https://forum.aeronet-fr.org/viewtopic.php?t=48827
- S26 — Aeronet forum, *CADET AIRFRANCE* (2026; KDTools, PrepaCadet.fr; "il faut en bouffer, des centaines"). https://forum.aeronet-fr.org/viewtopic.php?t=48634 — accessed 2026-09-11. Also *Rumeurs, conseils préparation et avis concours cadets* https://forum.aeronet-fr.org/viewtopic.php?t=46315
- S27 — F. Bourgine, *Devenez pilote de ligne — Tests PSY0, PSY1 et PSY2*, Dunod, 2023, ISBN 978-2-10-081529-6 (listing seen at https://www.dunod.com and booksellers, 2026-09-11; not consulted in full).
- S28 — YouTube series *CADETS AIR FRANCE 2025 / Episode 5 / PSY 0* (July 2025) https://www.youtube.com/watch?v=YwUfEPU4T5k — seen in search results 2026-09-11, not viewed (no transcript available to us).

Not found / negative results: no Reddit thread with substantive PSY0 content (searches on r/flying, r/aviation FR on 2026-09-11 returned nothing specific); no ENAC page describing PSY0 (ENAC hosts PSY1 only); no public Air France document describing activity-level content beyond S1.

---

## 7. Legal and ethics note

- **Unofficial.** This project is an independent training aid. It is **not affiliated with, endorsed by or connected to Air France, Transavia, ENAC, or any of their contractors**. "Air France", "Transavia" and "Cadets Air France" are trademarks of their owners and are used only to describe the target selection process. No logo or visual identity of these companies may be used in the app or store listings.
- **No reproduction of test material.** The real PSY0 items are the property of Air France / its contractor and are covered by candidate confidentiality (a confidentiality charter is signed for PSY2; PSY0/PSY1 debriefs are tolerated on forums but are not ours to republish). We do **not** reproduce real questions, real screens, or the compiled question sets published by third parties (e.g. Pilotest's culture PDFs — their compilation and explanations are Pilotest's copyright). All items, lexical fields, scenes, passages and rules texts in this app are **authored or generated by us**. Trainer sites' rule wordings must be **paraphrased**, not copied.
- **Format vs content.** Reproducing a *test format* (an N-back, a domino series, a cube net) is not copyright infringement — these are generic psychometric paradigms — but item pools, artwork and explanatory texts are. Keep it that way.
- **No guarantees.** The blueprint is an estimate; the real battery changes every year. The app must show that the content is unofficial and estimated, and must never claim to predict a candidate's result.
- **Fair play.** The app must not encourage leaking real items (no "submit the questions you saw" feature) and should remind users of the community norm of not debriefing before the window closes.
- **Data.** The trainer stores only local practice data; no webcam, no identity data. If cloud sync is added later, keep results private by default.

### Disclaimer text for the app

**FR — à afficher au premier lancement et dans "À propos"**

> **Application non officielle.** Cette application est un outil d'entraînement indépendant. Elle n'est ni affiliée à, ni approuvée par Air France, Transavia, l'ENAC ou leurs prestataires. Les marques citées appartiennent à leurs propriétaires et ne sont utilisées que pour décrire le processus de sélection visé.
> Les exercices, questions et durées proposés sont **conçus par nous** à partir d'informations publiques et de retours de candidats ; ils sont **estimatifs** et ne reproduisent aucun sujet réel. Le contenu de la sélection réelle évolue chaque année. Aucun résultat obtenu ici ne préjuge de votre réussite à la sélection.

**EN — first launch and "About"**

> **Unofficial app.** This application is an independent training tool. It is not affiliated with, nor endorsed by, Air France, Transavia, ENAC or their contractors. Trademarks mentioned belong to their owners and are used only to describe the selection process this app helps you prepare for.
> All exercises, questions and timings are **authored by us** from public information and candidate feedback; they are **estimates** and do not reproduce any real test material. The real selection changes every year. No score obtained here predicts your result in the actual selection.

Short store-listing line (FR/EN): « Entraîneur indépendant et non officiel — aucun lien avec Air France. » / "Independent, unofficial trainer — not affiliated with Air France."
