# Knowledge Vault Schema

> This file governs all LLM operations on this vault. Read it completely before
> performing any ingest, query, lint, or maintenance operation. It is harness-agnostic:
> any assistant with filesystem access (Claude, a local LLM, Cursor, Codex, or a
> desktop AI app) follows the same workflow described here.

**Schema version:** 1.0
**Vault kind:** PokeVault — a portable, Obsidian-native "Second Brain + LLM Wiki"
**Owner:** [OWNER]
**Created:** [INSTALL_DATE]

---

## 0. Mental Model (read first)

This vault follows the **LLM Wiki pattern** (popularized by Andrej Karpathy): instead of
re-deriving answers from raw documents on every question, an LLM **compiles** raw sources
*once* into a persistent, interlinked set of Markdown pages. Knowledge **compounds**:
cross-references are built once, contradictions are flagged, and the wiki is queried instead
of the raw pile.

Three layers, three rules:

| Layer | Folder | Rule |
|---|---|---|
| **Raw** — immutable inputs | `*/wiki/raw/` | You READ these. You NEVER modify them. |
| **Pages** — compiled synthesis | `*/wiki/pages/` | You CREATE and UPDATE these (append, don't rewrite). |
| **Ledger** — catalog + history | `index.md`, `log.md`, `review.md` | You maintain these every operation. |

**Workshop → library.** Beyond the wiki (the *library*), the vault has a *workshop*: `research/` (investigation, folder-per-project) and `projects/` (code). Workshop content is visible/readable but NOT auto-compiled. Durable findings are **promoted** from workshop to library through an explicit, frontmatter-driven gate (§8). This keeps the graph clean — only stabilized knowledge compounds.

> **The wiki is a map, not the territory.** For exact quotes, numbers, dates, or contractual
> language, always verify against the raw source and cite it.

---

## 1. Structure

This vault contains four zones plus one shared daily note:

| Zone | Path | Purpose | Privacy |
|---|---|---|---|
| Second Brain | `second-brain/` | Cognitive fingerprint (who you are) + personal knowledge wiki | Private |
| Work | `work/` | Engagement/project notes + work knowledge wiki | Private |
| Personal | `personal/` | Life management — people (CRM), areas, goals, calendar + a personal-knowledge wiki | Private |
| Toolkit | `toolkit/` | Your own skills (by category), agents, agent-sops (multi-step procedures), context files (no wiki) | Private |

A single **daily note** at the vault root (`daily/`) is the shared capture surface for *both* work
and personal — see "The single daily note" below.

Zones are top-level folders inside the Obsidian vault root (`~/PokeVault/`). Also at the root:
`daily/` (the shared daily note + its template — **visible**; your journal/capture surface).
`research/` (the **research workshop** — folder-per-project investigation; **visible**; findings are
promoted into a wiki when ready, §8). Two more top-level folders are **not** knowledge and are
excluded from Obsidian's search and graph (via `userIgnoreFilters`): `projects/` (code workspaces —
excluded from the graph but **agent-readable on demand** and **promotable** via the `vault:promote`
tag — §8) and `scratch/` (transient staging).

Each zone with wiki capability (`second-brain`, `work`, `personal`) contains:

```
wiki/
├── index.md        ← content catalog (you maintain this)
├── log.md          ← chronological record (append-only)
├── review.md       ← items needing human judgment (you append, user resolves)
├── raw/            ← immutable source documents (never modify)
│   ├── inbox/      ← universal drop zone for new sources
│   ├── meetings/   ← meeting notes / call transcripts (work zone only)
│   ├── notes/      ← quick notes + voice transcripts (frontmatter source: note|voice)
│   ├── media/      ← screenshots/whiteboards (binary) + a .md sidecar → processed as a source
│   ├── processed/  ← sources moved here AFTER successful ingest (dedup-by-absence; §2 Step 10)
│   └── _archive/   ← aged-out raw (YYYY/ subdirs); pages keep pointers
└── pages/          ← synthesized wiki pages (you write these)
    ├── sources/    ← PER-SOURCE: one summary per ingested source
    ├── entities/   ← WHO/WHAT: people, orgs, products, projects
    ├── concepts/   ← IDEAS: topics, frameworks, methods
    ├── synthesis/  ← ANALYSIS: multi-source insights, timelines, evolving theses
    └── references/ ← TABLES: comparisons, matrices, quick-reference
```

**Non-wiki zone folders** (NOT ingested as wiki pages):
`profile/` (second-brain only — cognitive fingerprint / self-model), `initiatives/` (lightweight
project/PM tracking), `deliverables/` + `deliverables/_templates/` (formal docs you author),
`records/` (official/signed copies), `artifacts/` (diagrams, decks, exports). `deliverables/` +
`records/` exist in `work/` only.

**The Personal zone** (`personal/`) is **hybrid**. Its CRM folders are operational living documents
you edit directly: `people/` (Personal CRM — one file per person), `areas/` (PARA life domains),
`goals/` (active goal tracking), `calendar/` (key dates + events + an `upcoming.md` dashboard),
`_templates/`. Alongside them, **`personal/wiki/`** is a standard wiki that compiles **synthesis about
your personal life** (relationship patterns, life-area knowledge, recurring personal themes) from
`personal/wiki/raw/`. The wiki **links to** the operational CRM records (one canonical home per
person, §6 rule 6) but **never ingests them as raw**; `personal/wiki/` compiles only from its own
`raw/`.

**Intake routing (which raw bucket a new source lands in):**
meeting note / transcript → `raw/meetings/` (work); quick note / voice transcript → `raw/notes/`;
uploaded screenshot/whiteboard → `raw/media/` (binary kept) + an OCR/transcribe `.md` sidecar
processed as a normal source; everything else → `raw/inbox/`. Links to external task boards are
referenced via `external_refs:` frontmatter (never duplicated).

### The single daily note (work + personal capture)
There is **one** daily note for everything, at `daily/YYYY-MM-DD.md`. The user captures freely and is
**not** expected to categorize. The daily note is a **routed capture source**, tracked in
`.vault/state/daily/manifest.json`. On ingest you read the day's note and **split it by content**:

- **Work** (projects, customers, meetings, deliverables) → `work/wiki/` (route per §2 Step 4).
- **People / relationships / networking** → create or update `personal/people/<name>.md` (CRM).
- **Life areas** (health, finances, hobbies, family…) → append to the relevant `personal/areas/*`.
- **Goals / aspirations** → `personal/goals/*`.
- **Dates / birthdays / reminders** → `personal/calendar/` (or a person's `birthday:` field).
- **Durable knowledge** (concepts, ideas, lessons) → `second-brain/wiki/`.
- **Personal-life synthesis** (relationship dynamics, life-area knowledge, recurring personal themes) → `personal/wiki/` (vs general/intellectual knowledge → `second-brain/wiki/`).
- **Reflections / patterns** → append to `second-brain/profile/patterns.md`.

The daily note stays in `daily/` as the dated record (never deleted). Maintain **`daily/index.md`** —
one dated line per daily note — as the journal pointer you read first for pattern detection ("you keep
revisiting X"). Optional `#work` / `#personal` cues help routing but are never required — **be smart
about the split.** When a fragment is genuinely **ambiguous, default-route it to the single best-guess
zone (never leave it stranded or lose it) and record that routing in `daily/review.md`** so the user
can reclassify it in one step (see §8 "Ambiguity & review surfacing").

---

## 2. Ingest Workflow

When processing new sources from `raw/{inbox,meetings,notes,media}/`:

> **Control tags (honor everywhere):** never ingest or refresh from a source tagged `vault:skip`;
> never overwrite, consolidate, or auto-rewrite a page tagged `vault:pin` (you may still append a
> dated section to a pinned page, but never restructure it). Treat a source/page tagged
> `vault:promote` as a promotion candidate (§8) — compile it into the wiki on the next promotion
> pass.

**Research as a source class.** Files under `research/<project>/raw/` are normal sources (ingest
like any raw input). `research/<project>/findings.md` is the project's *promotable output* (§8),
not an auto-ingested source. WIP `research/<project>/notes/` (tagged `#research/wip`) are NEVER
auto-compiled.

### Step 1 — Discover
- Scan the live raw buckets (`inbox/`, `meetings/`, `notes/`, `media/`) — **never `raw/processed/`
  or `raw/_archive/`** — for files not listed in the zone's manifest
  (`.vault/state/<zone>/manifest.json`).
- If no new files, report "No new sources to process" and stop.

### Step 2 — Fingerprint & Dedup
- Compute SHA-256 of each new file's content (normalize text: strip leading/trailing whitespace,
  collapse internal whitespace runs, lowercase; raw bytes for binary).
- Check the hash against the manifest. If duplicate: warn "Source already ingested (duplicate of
  [original])" and skip.
- Add a new entry to the manifest: `{path, fingerprint, ingested_at}`.

### Step 3 — Read & Extract
- Read the source fully.
- Identify extractable fragments: entities mentioned, concepts discussed, facts asserted,
  decisions made, action items, contradictions with existing knowledge.

### Step 4 — Route (Schema-Aware)
For each fragment, decide its destination:
- **A person you have a relationship with?** (colleague, contact, friend) → `personal/people/` (the
  CRM — their canonical home). The wiki **links** to them; it never duplicates them. A one-off or
  public figure with no real relationship may get a lightweight `entities/` page instead.
- **An org, product, project, or tool?** → `entities/`
- **An idea, framework, or method?** → `concepts/`
- **Combines or compares multiple sources?** → `synthesis/`
- **Structured reference material?** (table, matrix, checklist) → `references/`

**When in doubt, choose `synthesis/`.** Do not deliberate more than one sentence on routing.
Lint will flag misplaced content later. Getting content INTO the wiki quickly matters more
than perfect classification.

### Step 5 — Search Before Create
For each fragment, search existing pages BEFORE creating anything new:
1. **Exact title match** — does a page with this exact title exist?
2. **Key-term match** — scan `index.md` for titles containing the fragment's key terms.
3. **Synonym check** — consider variants ("Acme Corp" ≈ "Acme" ≈ "Acme Inc"; full names vs aliases).
4. **Cross-zone check** — entities have ONE canonical location across zones; check
   `work/wiki/pages/entities/` and `second-brain/wiki/pages/entities/`.

- **Match exists:** UPDATE it (see §3).
- **No match but uncertain:** note it in the triage report (Step 5.5) and ASK before creating.
- **Clearly new:** mark for creation in the triage report.

### Step 5.5 — Triage Report
Before writing any pages, emit a triage report:

```markdown
## Triage Report — [source filename]

### Pages to create (N)
- `pages/sources/<source-slug>.md` (per-source summary)
- `pages/entities/<entity-name>.md` — entity from this source
- `pages/concepts/<concept-name>.md` — concept from this source

### Pages to update (M)
- `pages/entities/acme-corp.md` — adding "Q3 outage 2026-05-08" to timeline

### Contradictions detected (P)
- New source claims X; existing page [[entity-name]] claims Y. Sources: [...]

### Uncertain routing (Q)
- Fragment "edge rollout roadmap" — could be concepts/ or synthesis/. Rec: synthesis/. Confirm?
```

**Approval gate:**
- Ingests with **>3 fragments** OR any contradictions: PAUSE for user approval.
- ≤3 fragments with no contradictions: proceed automatically; append the triage report to `log.md`.
  (Threshold is configurable in `.vault/config.yaml` → `ingest_autoapprove_max_fragments`.)

### Step 6 — Write the Source Summary First
Before fragment-level pages, create the per-source summary `pages/sources/<source-slug>.md`:
- Frontmatter pointing back to the raw source.
- 3–5 sentence summary of what the source covers.
- List of entities/concepts/decisions extracted (with wikilinks to fragment pages).
- Key quotes worth preserving verbatim.

This is the user's "what did I learn from this source?" view. Without it, knowledge fragments
across entity/concept pages with no anchor back to the original.

### Step 7 — Write Fragment Pages
- Create or update entity/concept/synthesis/reference pages with proper frontmatter (§5).
- Follow the Anti-Forgetting Rules (§4).
- Each page's `sources:` array references the per-source summary AND the raw file.

### Step 8 — Update Index
- Add new pages to `index.md`: `- [[page-name]] — one-line summary (sources: N, level: theme|topic|detail)`.
- Update existing entries if a page changed.

### Step 9 — Append to Log
- Format: `## [YYYY-MM-DD] ingest | <source filename>`.
- Include: pages created, pages updated, contradictions flagged, triage report (if not pre-approved).

### Step 10 — Mark Complete
- Update the manifest with the processed entry.
- **Move the ingested source to `raw/processed/`** (text sources from `inbox/`, `notes/`,
  `meetings/`). Absence from the live buckets — not just the manifest — is the dedup signal: periodic
  ingest scans the live buckets only, never `processed/`. Binary `media/` files stay in place (pages
  cite them directly); move only their `.md` sidecar. The manifest remains the content-fingerprint
  authority that also catches the same content re-dropped elsewhere.
- The source's resting path is now `raw/processed/<file>` — write the `sources:` paths in the pages
  (Steps 6–7) to point there, so citations never dangle after the move.
- Remove the source from `pending.json` if present.
- If the source was a daily note, add/refresh its one-line entry in `daily/index.md`.

---

## 3. Update Rules (Append, Don't Rewrite)

When updating an existing page with new information:

1. **Add a dated section** at the end of the body:
   ```markdown
   ### Update [YYYY-MM-DD]

   New information from [[source-file]]:
   - [new facts, observations, or context]
   ```
2. **Do NOT rewrite existing sections** unless (a) resolving a flagged contradiction with user
   approval, or (b) correcting a provable factual error (cite the raw source).
3. **Update frontmatter:**
   - Add the new source to `sources:` (preserve existing entries).
   - Increment `sources_count:`.
   - Recompute `confidence:` (1 source = low, 2 = medium, 3+ = high).
   - Update `modified:`.
   - Recompute `content_hash:` from the new body; set `last_agent_hash:` equal to it.

---

## 4. Anti-Forgetting Rules

These are NON-NEGOTIABLE. Violating any of these is a system error.

1. **Append, don't rewrite.** New information goes in dated sections. Existing content is preserved.
2. **Wiki is map, not territory.** For exact quotes/numbers/dates, verify against raw and cite it.
3. **Search before create.** Duplicates are a system failure. Always check first.
4. **Flag contradictions, don't resolve silently:**
   ```markdown
   > ⚠️ **Contradiction** (flagged [YYYY-MM-DD])
   >
   > Existing claim: [quote]  — Source: [[existing-source]]
   > New claim:      [quote]  — Source: [[new-source]]
   >
   > Resolution: PENDING (requires human review)
   ```
5. **Provenance on every claim.** Every page has a `sources:` array. Every factual claim references
   the source it came from.
6. **One canonical location per entity.** An entity page lives in ONE zone; other zones link to it:
   `[[work/wiki/pages/entities/acme-corp|Acme Corp]]` (vault-root-relative — link format is `absolute`
   in `.obsidian/app.json`; do NOT use `../../` traversal in wikilinks). If a physical copy is
   unavoidable, add `canonical: work/wiki/pages/entities/acme-corp.md` to its frontmatter.
   **People you know are canonical in `personal/people/` (the CRM); the wiki links to them, never
   duplicates them.**
7. **Raw content is immutable.** NEVER edit, rewrite, or delete what a raw source *says*. The ONLY
   permitted relocations are moving a source to `raw/processed/` exactly once *after* successful
   ingest (the dedup-by-absence signal, §2 Step 10) and aging into `raw/_archive/`. You write
   synthesis to `pages/`, `index.md`, `log.md`, and `review.md` only.

---

## 5. Page Frontmatter Schema

Every page in `pages/` must carry this frontmatter. **Scope:** wiki pages only. The non-wiki
sibling folders use the same YAML style (see §5.x below) with their own fields and do NOT use the
`zone:` enum:

- `initiatives/` → `type: initiative` + `status`, `owner`, `members`, `milestones`, `external_refs`
- `deliverables/` / `records/` → `type: deliverable|record` + `version`, `status`
- `daily/` → `type: daily` + `date`
- `profile/` → `type: profile` + `profile: <name>`, `owner`
- `research/` → `type: research-project|research-note|research-finding` (workshop; no `zone:`)
- `projects/**` promotable items → `type: project-component` (no `zone:`)

All frontmatter uses single-quoted ISO-8601 UTC timestamps and block-list `tags`. (The kit's
`docs/01-vault-blueprint.md` elaborates with rationale, but everything needed to operate is here.)

```yaml
---
title: "Human-Readable Page Title"
zone: sources|entities|concepts|synthesis|references
level: theme|topic|detail
sources:
  - "../raw/inbox/source-file.md"
sources_count: 1
confidence: low|medium|high
canonical: null
relationships:
  contains: []
  similar_to: []
  contradicts: []
  derived_from: []
created: YYYY-MM-DDTHH:MM:SSZ
modified: YYYY-MM-DDTHH:MM:SSZ
content_hash: <sha256-12>
last_agent_hash: <sha256-12>
external_refs: []
tags: []
---
```

| Field | Rules |
|---|---|
| `title` | Human-readable; used in index.md |
| `zone` | Must match the folder the page is in |
| `level` | `theme` (strategic), `topic` (domain), `detail` (tactical). Helps lint find orphaned details. |
| `sources` | Relative paths to raw files; NEVER empty |
| `sources_count` | Auto-computed; length of `sources` |
| `confidence` | `low` (1 source), `medium` (2), `high` (3+) |
| `canonical` | null unless this is a cross-zone copy pointing at the original |
| `relationships` | OPTIONAL typed links: `contains`, `similar_to`, `contradicts`, `derived_from` |
| `created` | Set once; never change |
| `modified` | Update on every edit |
| `content_hash` | Current SHA-256 (first 12 chars) of the body — see definition below |
| `last_agent_hash` | The `content_hash` value at the last agent write (edit detection) |
| `tags` | User-editable; merge on update, never replace |
| `external_refs` | OPTIONAL pointers to external task boards (`jira:ABC-1`); reference only |

### Body definition (for `content_hash`)
1. Content from the line after the closing `---`.
2. Strip trailing whitespace per line (preserve internal whitespace).
3. Normalize line endings to `\n`.
4. UTF-8 encode → SHA-256 → hex → first 12 chars.

`sha256(body.encode("utf-8")).hexdigest()[:12]` — must be identical across every tool.

### Edit detection
On read: compute the body's `content_hash`; compare to stored `last_agent_hash`.
- **Match** → body unchanged since last agent write; safe to update.
- **Differ** → a human edited the body. Append-only updates proceed (don't touch existing sections);
  consolidation or auto-fix PAUSES and flags `review.md`.
On write: set `last_agent_hash` = new `content_hash`; update `modified`.

### Research & promotion frontmatter (workshop types)

Research project charter — `research/<project>/README.md`:
```yaml
---
type: research-project
slug: <project-slug>
title: "Human-readable title"
question: "The driving research question"
status: active            # active | paused | complete | abandoned
harness: null             # generic owner id an external harness may set (brand-neutral)
created: '2026-06-09T00:00:00Z'
modified: '2026-06-09T00:00:00Z'
tags:
  - research
---
```
Research note (WIP) — `research/<project>/notes/*.md`: `type: research-note`, `project: <slug>`,
`status: wip`, `created`/`modified`, `tags: [research/wip]`. Visible + searchable but NEVER
auto-compiled.

Research finding (promotable output) — `research/<project>/findings.md`:
```yaml
---
type: research-finding
project: <project-slug>
status: wip               # wip | ready | promoted  (only ready, or a vault:promote tag, is eligible)
promote_target: auto      # second-brain | work | auto
sources:                  # provenance — REQUIRED before promotion
  - "raw/<source>.md"
confidence: medium        # low | medium | high
harness: null
created: '2026-06-09T00:00:00Z'
modified: '2026-06-09T00:00:00Z'
promoted_to: null         # set to the wiki page wikilink on promotion
tags:
  - research
---
```

Promotable project component — any `projects/**/*.md` (or sidecar):
```yaml
---
type: project-component
component: "what this is"
status: ready             # ready = eligible (or carry the vault:promote tag)
promote_target: auto      # second-brain | work | auto
summary: "1-3 sentence durable takeaway"
sources:
  - "<path within project>"
confidence: medium
harness: null
promoted_to: null
tags:
  - project
  - vault:promote         # control tag (no space after colon) → promotion candidate
---
```

The promoted wiki page (library side): follows the normal §5 wiki schema PLUS
`promoted_from: "<workshop path>"`, and its `sources:` cite the workshop file. On promotion the
workshop file gets `status: promoted` + `promoted_to: "[[<page>]]"` (one canonical home;
anti-forgetting rule 6).

Control tags (`vault:pin`/`vault:skip`/`vault:promote`) are colon-namespaced so another vault can mirror them with its own prefix.

---

## 6. Query Workflow

> **Three-pillar check (do this first):** ground answers in the **wiki** (`*/wiki/`), the **journal**
> (recent `daily/` notes — read **`daily/index.md`** first to scan them fast), and the **CRM**
> (`personal/people/`). For questions about a person, a commitment, or "what did I say I'd do," the
> CRM and journal usually hold what the wiki doesn't.

1. Read the zone's `index.md` to find candidate pages (or use search if index is large).
2. Read candidate pages matching the topic.
3. **Verify factual claims against raw sources.** If the answer includes specific facts
   (dates, numbers, quotes, names, decisions), verify at least one key claim against the raw source
   in the page's `sources:`. If unavailable, note "(from wiki synthesis; raw not re-verified)".
4. Synthesize with citations: `(from [[page-name]])`.
5. **The wiki grows from questions (standard step, not an afterthought).** When you answer a
   non-trivial query, synthesize the answer into a new or updated page (route per §2 Step 4), append
   a line to `log.md`, and update `index.md`. Asking should *expand* the wiki — this is what
   separates it from static RAG. (Skip for trivial lookups so you don't create noise.)
6. If no relevant page exists, search `raw/` directly, then offer to ingest.
7. **Workshop on demand.** You MAY read `research/` and `projects/` for context when answering;
   cite uncompiled material as `(from research/<project> — uncompiled)`. After answering a
   non-trivial research question, you MUST **offer to promote** durable findings into the wiki
   (§8) — do not promote silently.

---

## 7. Lint Workflow

Run periodically (after ~10 ingests, or monthly):

| Check | Action |
|---|---|
| **Orphan pages** — no inbound `[[wikilinks]]` | Flag; suggest connections or archive |
| **Stale index entries** — index points to a missing page | Remove from index |
| **Broken wikilinks** — `[[name]]` → nonexistent page | Flag; suggest create/fix |
| **Near-duplicates** — >80% title similarity or overlapping sources | Flag for merge review |
| **Contradictions** — unresolved `⚠️ Contradiction` blocks | Surface to user |
| **Pending backlog** — sources in pending.json older than N days | Warn user |
| **Low-confidence pages** — `confidence: low` older than N days | Suggest corroborating sources |
| **Missing frontmatter** — pages without required fields | Auto-fix where possible |
| **Consolidation candidates** — pages with 5+ dated update sections | Flag (see below) |

### Page consolidation (the one exception to "append, don't rewrite")
When a page accumulates 5+ `### Update [date]` sections it becomes a changelog, not synthesis.
Consolidation rewrites it as one coherent page. **All safeguards required:**
0. **Never consolidate a page tagged `vault:pin`.** Skip it.
1. Archive the old version to `_archive/<page-name>-pre-consolidation-YYYY-MM-DD.md`.
2. User approval — present the proposed consolidation and wait.
3. ALL sources from the old frontmatter preserved.
4. **Consolidation diff log (MANDATORY):** list claims/quotes PRESERVED and any DROPPED/merged with
   loss of nuance; append it to `log.md` and add a `review.md` entry "Consolidation review: [page]".
5. Reset `content_hash` + `last_agent_hash` to the new body.
6. Log: `## [date] consolidate | [[page]] (N updates → single synthesis; M preserved, K dropped)`.

**Without the diff log, consolidation becomes the catastrophic forgetting we exist to prevent.**

After lint, append: `## [YYYY-MM-DD] lint | [N] issues found, [M] auto-fixed`.

---

## 8. Cross-Zone Rules

### Linking
Use **absolute (vault-root-relative) wikilinks** for cross-zone references:
`[[work/wiki/pages/entities/acme-corp|Acme Corp]]`. The `absolute` link format in
`.obsidian/app.json` makes Obsidian resolve these from the vault root (do NOT use `../../` path
traversal inside wikilinks).

### Cognitive extraction (Work → Second Brain)
Periodically (manually or via a scheduled assistant), extract decision patterns, recurring themes,
and quality feedback from `work/` and APPEND them to `second-brain/profile/patterns.md`. This flows
insight, not raw data.

### Daily-note routing (work ⇄ personal)
The single `daily/` note feeds both work and personal (see §1 "The single daily note"). Synthesis
splits it by content; the user never pre-sorts. People → CRM, areas/goals/dates → `personal/`,
work → `work/wiki`, durable knowledge → `second-brain/wiki`; personal-life synthesis → `personal/wiki`.

### Promotion (workshop → library)
The one-way gate that compiles stabilized workshop output into the curated wiki.
- **Eligible** iff `status: ready` OR the item carries a `vault:promote` tag — AND `sources:` is
  non-empty.
- **Triggers:** (1) on request ('promote research X' / 'promote this'); (2) **proactively** — when
  a research loop completes and you present results, explicitly ask 'Promote these findings to your
  wiki? (target: <zone>)' and promote only on yes (or if `vault:promote` is already set).
- **Action:** route to the target wiki (`promote_target`, else infer per §2 Step 4:
  personal→`second-brain/wiki`, work→`work/wiki`); search-before-create (rule 3); create/append the
  wiki page with `sources:` + `promoted_from:`; set the workshop file `status: promoted` +
  `promoted_to: "[[<page>]]"`; append to the target wiki `log.md` and update its `index.md`.
- Never compile `notes/`; never auto-walk `projects/` (promote a `projects/` item only when
  explicitly asked).

### Ambiguity & review surfacing
When a fragment is genuinely ambiguous (work vs personal, or uncertain routing), **default-route it
to the single best-guess zone — never leave it stranded, block it, or lose it** — AND record the
decision in **`daily/review.md`** (the journal's reclassification queue) as a one-line entry, e.g.
`- [ ] 2026-06-09: routed "edge rollout" → work/wiki (low confidence) — reclassify?`. The user moves
it in one step if it landed wrong. This reconciles *route-by-default* with *never-silently-misroute*:
content is always filed and always reviewable. `daily/review.md` is the journal's single triage list,
distinct from each wiki zone's `review.md` (which handles wiki-internal issues: contradictions,
near-duplicates, consolidation). *How* the queue reaches the user is **platform-specific (pluggable):**
a desktop AI app may surface it as a feed/notification card during daily-processing; in plain Obsidian
you open `daily/review.md` (a Dataview of unchecked items works well). The queue is the neutral
contract; the surfacing adapter is per-platform.

### Privacy guardrail (extensible)
This kit's zones are all private. If you later add a **shared** zone (e.g., a `team/` folder
synced to a shared drive), treat it like the original design did: content from `second-brain/` or
`work/` MUST NOT be copied into a shared zone without explicit user confirmation. Publishing private
notes is a deliberate act, never an automatic one.

---

## 9. Tool Permissions

| Area | Read | Write | Never |
|---|---|---|---|
| `raw/` | ✅ all | ⚠️ only move a source to `raw/processed/` after ingest (§2 Step 10) | edit content, rename, or delete |
| `pages/` | ✅ all | ✅ create + update | delete (archive only) |
| `index.md` | ✅ | ✅ update entries | delete entries without logging |
| `log.md` | ✅ | ✅ append only | edit/delete existing entries |
| `review.md` | ✅ | ✅ append items | delete items (user resolves) |
| `profile/` | ✅ | ✅ append to existing files | overwrite or delete |
| `personal/` | ✅ | ✅ create + append (people / areas / goals / calendar) | wholesale rewrite or delete |
| `daily/` | ✅ | ✅ the dated note + `index.md` + `review.md` | delete dated notes |
| `.vault/` | ✅ state files | ✅ state files only | `config.yaml` (user-owned) |
| `toolkit/` | ✅ | ❌ (user-managed) | everything |
| `research/` | ✅ all | ✅ create + append workshop files (projects, notes, findings) | delete user research content |
| `projects/` | ✅ on demand | ⚠️ only `vault:promote` / frontmatter signal | edit code, or auto-walk |

---

## 10. Known Folders

> This folder list is **authoritative for an installed vault**. The kit's
> `docs/01-vault-blueprint.md` (ships alongside the vault, not inside it) adds rationale.

```
# Vault root: ~/PokeVault/
second-brain/profile/
second-brain/initiatives/
second-brain/artifacts/
second-brain/wiki/raw/{inbox,notes,media,processed,_archive}/
second-brain/wiki/pages/{sources,entities,concepts,synthesis,references}/
work/initiatives/
work/deliverables/_templates/
work/records/
work/artifacts/
work/wiki/raw/{inbox,meetings,notes,media,processed,_archive}/
work/wiki/pages/{sources,entities,concepts,synthesis,references}/
toolkit/skills/<NN-category>/        ← skills organized by category (01-foundations … 08-knowledge); file name == skill name
toolkit/agents/
toolkit/agent-sops/                  ← multi-step agent procedures (SOPs)
toolkit/context/
personal/people/
personal/areas/
personal/goals/
personal/calendar/
personal/_templates/
personal/wiki/raw/{inbox,notes,media,processed,_archive}/
personal/wiki/pages/{sources,entities,concepts,synthesis,references}/
daily/                       ← the single shared daily note (visible)
daily/index.md               ← chronological journal index (pattern detection)
daily/review.md              ← journal reclassification queue (defaulted routings)
daily/_templates/
research/                    ← research workshop (visible)
research/index.md            ← active projects + ready-to-promote dashboard
research/_templates/
research/_archive/
research/<project>/{README.md,raw/,notes/,findings.md}
# Top-level, outside the knowledge zones (excluded from Obsidian search/graph via userIgnoreFilters):
projects/   ← code workspaces (agent-readable on demand; promotable via vault:promote)
scratch/    ← transient staging
# Dot-folders (auto-hidden by Obsidian): .obsidian/  .vault/
```

---

## 11. Skills (reusable workflows)

Skills are plain-Markdown workflows. The tool-neutral source lives in
`toolkit/skills/<NN-category>/<name>.md` (categories organize the source tree only — they do **NOT**
propagate to runtimes); the kit's `bootstrap.sh` / `bootstrap.ps1` recurses the category dirs and
**flattens** each skill into `.claude/skills/<name>/SKILL.md` so Claude Code auto-discovers them
(open Agent-Skills standard). Each skill carries a `version` (semver) in its frontmatter — the
authoritative datapoint for invoke/update/cleanup; versions never appear in file or folder names.
Any agent that reads this file can run one by opening its source file when you say the trigger phrase.

| Skill | Category | Trigger phrase | Purpose |
|---|---|---|---|
| `vault-init` | `01-foundations` | "initialize my vault" | Scaffold or repair the vault structure (idempotent) |
| `obsidian-setup` | `01-foundations` | "set up obsidian" | Install/verify plugins + link settings |
| `profile-build` | `01-foundations` | "build my profile" | Populate the second-brain profile conversationally |
| `pokevault-update` | `01-foundations` | "update my vault" | Apply a kit update non-destructively |
| `research-init` | `02-research` | "start research <name>" | Scaffold a new research project from the template |
| `research-promote` | `02-research` | "promote research" / "promote this" | Compile a ready finding/component into the wiki (frontmatter-driven) |
| `wiki-ingest` | `08-knowledge` | "process my inbox" | Compile raw sources into wiki pages (dedup, route, link, log) |
| `wiki-lint` | `08-knowledge` | "lint my wiki" | Health checks + safe auto-fixes |
| `daily-note` | `08-knowledge` | "open today's note" | Daily capture front door + end-of-day routing |

**Invocation without a skills-aware harness:** "Read `toolkit/skills/<category>/<name>.md` and follow it."

---

Last updated: [INSTALL_DATE]
