# PokeVault Blueprint — Structure, Obsidian Compatibility & Frontmatter Standards

> **This is the canonical reference for the vault.** Everything else — `AGENTS.md`, the zone
> READMEs, the wiring skills — derives from this document. If you are setting the vault up on a
> new machine from scratch, you can reconstruct the entire thing from this file plus
> `02-llm-wiki-synthesis-and-daily-notes.md`.

**Kit:** PokeVault — a portable, brand-neutral "Second Brain + LLM Wiki."
**Interface:** Obsidian (optional but recommended).
**Engine:** any LLM assistant with filesystem access, driven by `vault/AGENTS.md`.
**Status of this build:** structure + engine + wiring are complete and usable today. The wiki
*ingest automation* and *daily-note automation* are documented designs you drive manually with an
assistant until purpose-built skills ship (see File B and the project roadmap).

---

## 1. What this vault is (and the one big idea)

A knowledge vault that **compounds**. You collect raw material (articles, notes, meeting records,
voice memos, screenshots) into immutable `raw/` folders. An AI assistant **compiles** that
material — once — into interlinked Markdown pages under `pages/`. From then on you (and your
assistants) query the *compiled* wiki instead of re-reading the raw pile. New sources update the
pages; contradictions get flagged; nothing silently overwrites prior knowledge.

This is the **LLM Wiki pattern** (Karpathy). The deep treatment is in File B; this file is the
structural contract.

Three properties make it portable and durable:

1. **Plain files.** Everything is Markdown + a little YAML + JSON state. No database, no server,
   no lock-in. Copy the folder and it works anywhere.
2. **Obsidian-native, but Obsidian-optional.** It is a valid Obsidian vault out of the box, yet
   every file is readable and editable without Obsidian.
3. **Harness-agnostic.** The `AGENTS.md` schema is tool-neutral. Claude, Cursor, Codex, a
   local model, or a desktop AI app all follow the same instructions.

---

## 2. Where to put the vault (placement best practice)

The vault root is **`~/PokeVault/`** by convention. You can name it anything; the folder name becomes
the Obsidian vault display name.

**macOS / Linux:** `~/PokeVault` (i.e., `/Users/<you>/PokeVault` or `/home/<you>/PokeVault`).

**Windows:** `C:\PokeVault` (a local, drive-root folder — deliberately *not* under `Documents`, which is usually OneDrive-synced).

### Cloud sync vs. Obsidian Sync — choose one primary

This matters and trips people up:

- If you sync the vault with **Obsidian Sync** (or Syncthing / git), **do not also put it inside a
  cloud-synced folder** like OneDrive, iCloud Drive, Dropbox, or Google Drive. Two sync engines
  fighting over the same files create conflict copies and corrupt `.obsidian` state. Put the vault
  at `~/PokeVault` (outside any cloud folder) and let one sync tool own it.
- If you have **no cross-device sync** and just want a backup, a cloud folder is fine — but expect
  a sync icon on the folder, and prefer "keep on device" so files are always local (Obsidian needs
  real local files, not cloud placeholders).
- On Windows, if you must keep it under OneDrive Known-Folder-Move, right-click → **Always keep on
  this device** to prevent dehydration.

**Recommended for the disconnected-but-Obsidian-synced machine this kit targets:** install at
`~/PokeVault`, enable Obsidian Sync (or git), and keep it out of OneDrive/iCloud.

---

## 3. Complete folder structure (annotated)

```
~/PokeVault/                                ← Obsidian vault root (open THIS)
│
├── AGENTS.md                           ← the wiki engine: schema every assistant reads
├── CLAUDE.md                           ← Claude Code entry point → AGENTS.md
├── .cursorrules                        ← Cursor entry point → AGENTS.md
├── README.md                           ← human landing page
│
├── .obsidian/                          ← Obsidian config (tracked: see §4). Auto-hidden by Obsidian.
│   ├── app.json                        ←   absolute links + ignore filters
│   ├── core-plugins.json               ←   Daily Notes + Templates enabled
│   ├── community-plugins.json          ←   recommended plugin IDs (you still install them)
│   ├── daily-notes.json                ←   daily notes → daily/, template seeded
│   └── templates.json                  ←   core Templates folder
│
├── .vault/                             ← system state (NOT knowledge). Auto-hidden by Obsidian.
│   ├── config.yaml                     ←   vault preferences (user-owned, safe to edit)
│   └── state/
│       ├── second-brain/{manifest.json,pending.json}
│       ├── work/{manifest.json,pending.json}
│       └── daily/{manifest.json,pending.json}   ← daily-note routing state
│
├── .gitignore                          ← git-friendly defaults (see §9)
│
├── second-brain/                       ← ZONE: WHO YOU ARE + WHAT YOU KNOW (private)
│   ├── README.md
│   ├── profile/                        ←   cognitive fingerprint / self-model (read by assistants)
│   │   ├── identity.md  voice.md  preferences.md
│   │   ├── goals.md  relationships.md  projects.md  patterns.md
│   ├── initiatives/                    ←   personal project/goal tracking
│   ├── artifacts/                      ←   diagrams, exports, personal artifacts
│   └── wiki/                           ←   personal LLM wiki (see §3.1)
│
├── work/                               ← ZONE: YOUR WORK (private)
│   ├── README.md
│   ├── initiatives/                    ←   per-project/engagement tracking (PM)
│   ├── deliverables/                   ←   formal docs you author
│   │   └── _templates/
│   ├── records/                        ←   official / signed copies
│   ├── artifacts/                      ←   diagrams, decks, exports
│   └── wiki/                           ←   work LLM wiki (see §3.1)
│
├── personal/                           ← ZONE: YOUR LIFE (private, hybrid — CRM + wiki)
│   ├── README.md
│   ├── people/                         ←   Personal CRM (one file per person)
│   ├── areas/                          ←   PARA life domains (health, finances, hobbies…)
│   ├── goals/                          ←   active goal tracking
│   ├── calendar/                       ←   key dates, events, upcoming.md dashboard
│   ├── _templates/                     ←   person / area / goal / event
│   └── wiki/                           ←   personal-life LLM wiki (see §3.1; clone of second-brain/wiki, no meetings/)
│
├── toolkit/                            ← ZONE: YOUR AI ADDITIONS (private, no wiki)
│   ├── README.md
│   ├── skills/   agents/   context/
│
├── daily/                              ← the ONE shared daily note (work + personal) — visible
│   ├── index.md                        ←   chronological journal index (pattern detection)
│   ├── review.md                       ←   reclassification queue (defaulted routings)
│   └── _templates/daily.md
│
├── research/                           ← WORKSHOP: investigation projects (visible, not wiki)
│   ├── README.md
│   ├── index.md                        ←   catalog of active/completed research projects
│   ├── _templates/                     ←   project scaffold template
│   ├── _archive/                       ←   completed/abandoned projects
│   └── <project-slug>/                 ←   one folder per investigation
│       ├── README.md                   ←     scope, question, status
│       ├── raw/                        ←     project-local source material
│       ├── notes/                      ←     working notes and drafts
│       └── findings.md                 ←     final synthesis (promotion candidate)
│
├── projects/                           ← code workspaces — Obsidian-ignored, git-ignored
│   └── README.md
└── scratch/                            ← transient staging — Obsidian-ignored, git-ignored
    └── README.md
```

### 3.1 The wiki layout (identical in every wiki-bearing zone)

```
wiki/
├── index.md        ← content catalog (assistant-maintained; one line per page)
├── log.md          ← append-only chronological record of every operation
├── review.md       ← human-attention queue (contradictions, dupes, consolidation)
├── raw/            ← IMMUTABLE inputs (assistants read, never write)
│   ├── inbox/      ←   universal drop zone
│   ├── meetings/   ←   meeting notes / transcripts (work zone only)
│   ├── notes/      ←   quick notes + voice transcripts (frontmatter source: note|voice)
│   ├── media/      ←   screenshots/whiteboards (binary) + a .md sidecar processed as a source
│   ├── processed/  ←   sources moved here after ingest (dedup-by-absence; never rescanned)
│   └── _archive/   ←   aged-out raw (YYYY/ subdirs); pages keep pointers
└── pages/          ← COMPILED synthesis (assistants create + update)
    ├── sources/    ←   one summary per ingested source ("what did I learn from X?")
    ├── entities/   ←   people, orgs, products, projects
    ├── concepts/   ←   ideas, frameworks, methods
    ├── synthesis/  ←   multi-source analyses, timelines, evolving theses
    └── references/ ←   tables, matrices, quick-reference
```

### 3.2 Why each piece exists

| Piece | Why it's there |
|---|---|
| **`raw/` is separate and immutable** | Provenance. The wiki is a *map*; raw is the *territory*. You can always re-derive synthesis from raw, so raw must never be mutated or lost. |
| **`pages/` split into 5 buckets** | Routing makes synthesis findable and keeps pages single-purpose. Entities vs concepts vs cross-source analysis vs tables are genuinely different shapes of knowledge. |
| **`sources/` per-source summaries** | Without an anchor back to each original, knowledge fragments across entity/concept pages and you lose "what did this article actually say?" |
| **`index.md` / `log.md` / `review.md`** | The ledger. Index = what exists; Log = what happened (audit trail); Review = what needs you. Together they make the wiki self-describing and safe to automate. |
| **`profile/` (second-brain only)** | Your cognitive fingerprint. Assistants read it to write in your voice, respect your priorities, and align to your goals. It is *static identity*, not accumulated knowledge — that's why it's not in `wiki/`. |
| **`initiatives/ deliverables/ records/ artifacts/`** | Not everything is wiki synthesis. Formal docs, signed copies, and tracked projects have their own lifecycle and shouldn't be ingested as wiki pages. |
| **`personal/` (people / areas / goals / calendar)** | The life-management layer — Personal CRM + PARA Areas + goals + key dates. Operational living docs, *not* wiki synthesis, so they're edited directly and the wiki links to them rather than ingesting them. **Consumer-generic by design** (friends/family/contacts; `person` = birthday/relationship/met). It's a **peer zone** built to coexist collision-free with a separate professional vault's own zone — two peer zones, zero shared paths, never merged into one. |
| **`raw/processed/`** | After ingest, sources move here. Absence from the live buckets is a filesystem-level dedup signal (the manifest is the content-level one); the periodic ingest never rescans it. |
| **`daily/index.md` + `daily/review.md`** | The journal's pointer + triage. Index = scannable one-liners for pattern detection; review = the reclassification queue where default-routed ambiguous captures are logged for one-tap correction. |
| **`daily/` — one shared note** | A single low-friction capture surface for work *and* personal. The user never pre-sorts; synthesis reads the note and routes each fragment to the right zone. The note stays as the dated record. |
| **`projects/` + `scratch/` at the root, ignored** | Code and throwaway are not knowledge. Keeping them in the vault is convenient (one folder for everything) but hiding them from Obsidian + git keeps the graph and history clean. |
| **`research/` at the root, visible** | The workshop where investigation happens per-project. Each project is self-contained (`raw/`, `notes/`, `findings.md`). Findings get **promoted** into the wiki when ready — `research/` is the working bench; the wiki is the finished shelf. It is *not* a fifth knowledge zone; it's a staging area with a one-way gate into `*/wiki/pages/`. |
| **`.vault/` state** | Dedup + queue state lives outside the knowledge so it can be machine-managed without cluttering the graph. |

### 3.3 Content layers at a glance

| Layer | Folder | In the wiki / graph? | Agent reads? |
|---|---|---|---|
| Curated knowledge | `*/wiki/pages/` | Yes | Yes |
| Research workshop | `research/` | No (until promoted) | Yes |
| Code workspace | `projects/` | No | On demand |
| Throwaway | `scratch/` | No | No |

The model is **workshop → library**: `research/` and `projects/` are the workshop (visible and
readable, but uncompiled); `*/wiki/pages/` is the library. **Promotion** is the one-way,
frontmatter-driven gate that graduates workshop findings into wiki pages.

### 3.4 Frontmatter at a glance

Every file with structured metadata uses YAML frontmatter (`---` fences). The full schemas are in
§5; the style contract in brief:

- **Spaces only** — never tabs. Valid YAML.
- **`type:` discriminator** — tells agents/Dataview what kind of file this is.
- **Tags as a block list** — `tags:\n  - foo` (never inline CSV).
- **Timestamps** — single-quoted ISO-8601 UTC: `created: '2026-06-08T16:00:00Z'`.
- **Control tags** live in the `tags:` list with a `vault:` prefix: `vault:pin` (keep forever),
  `vault:skip` (never ingest), `vault:promote` (eligible for promotion into the wiki).

---

## 4. Obsidian compatibility

The vault ships a pre-seeded `.obsidian/` so it behaves correctly the moment you open it.

### 4.1 Settings that matter (`.obsidian/app.json`)

| Setting | Value | Why |
|---|---|---|
| `newLinkFormat` | `absolute` | Cross-zone wikilinks (`[[work/wiki/pages/entities/acme-corp]]`) resolve correctly. Shortest-path links break across deep folders. |
| `useMarkdownLinks` | `false` | Use `[[wikilinks]]`, not `[md](paths)` — wikilinks survive file moves and power the graph. |
| `alwaysUpdateLinks` | `true` | Renames/moves update inbound links automatically. |
| `userIgnoreFilters` | `["projects/","scratch/",".vault/"]` | Hides non-knowledge folders from the file explorer, search, and graph. |
| `attachmentFolderPath` | `./` | New attachments land next to the note; for wiki media prefer dropping into `raw/media/`. |

`.obsidian/` itself and any dotfolder (`.vault/`) are auto-hidden by Obsidian — you don't need to
list them, but `.vault/` is included in the ignore filter for older Obsidian versions.

### 4.2 Plugins

**Core (built-in, enabled in `core-plugins.json` — no install needed):**
Daily Notes, Templates, Graph, Backlinks, Outgoing Links, Tag pane, Properties, Quick Switcher,
Search, Outline, Page Preview, File Recovery.

**Community (recommended; you must install via Settings → Community plugins — Obsidian's security
model requires consent):**

| Plugin | Why |
|---|---|
| **Dataview** | Query frontmatter — list pages by `level`, `confidence`, `sources_count`, `tags`. The wiki's structured frontmatter is built for this. |
| **Templater** | Richer templates than core (dynamic dates, prompts) for pages and daily notes. |
| **Tag Wrangler** | Rename/merge tags safely, including the `vault:` control tags. |
| **Periodic Notes** | Weekly/monthly/quarterly notes layered on top of core Daily Notes (see File B). |

**Browser (optional):** the Obsidian **Web Clipper** extension — clip articles straight into
`second-brain/wiki/raw/inbox/`.

### 4.3 Daily Notes (wired now)

`.obsidian/daily-notes.json` points new daily notes at `daily/`, names them `YYYY-MM-DD`, and
applies `daily/_templates/daily.md`. Today's note is one hotkey away. The template includes a
**Capture → wiki** section so daily notes feed the ingest pipeline (File B §daily notes).

---

## 5. Frontmatter standards

Frontmatter is YAML at the very top of a file between `---` fences. Obsidian renders it as
**Properties**. Four content types in this vault carry frontmatter; they share one **style** but
have different **fields**.

### 5.1 YAML style rules (apply to ALL frontmatter)

- One `---` block at the very top; valid YAML; **spaces only**, never tabs.
- **Tags as a block list** (Obsidian "list" property), never inline CSV. Empty = `[]`:
  ```yaml
  tags:
    - knowledge
    - migration
  ```
- **Timestamps:** ISO-8601 UTC, single-quoted, `Z` suffix — `created: '2026-06-08T16:00:00Z'`.
- **Strings:** unquoted unless they contain YAML specials (`:`, `#`, leading `[`/`{`). Quote when
  needed — `title: "Acme Corp: Q3 review"`.
- `null` for an intentionally-empty scalar; `[]` / `{}` for empty collections.
- On merge/update: **lists replace, maps merge, scalars replace.** `tags` are union-merged
  (case-insensitive dedup) so user tags survive re-ingest.

#### Control tags
Two namespaced tags let you steer the engine:
- `vault:pin` — always keep this page/section; never auto-refresh or consolidate it away.
- `vault:skip` — never ingest/refresh from this source.

### 5.2 Wiki page frontmatter (`pages/**`)

The full schema and field rules live in `AGENTS.md` §5 (it's the agent-facing contract). Summary:

```yaml
---
title: "Human-Readable Page Title"
zone: sources|entities|concepts|synthesis|references   # matches the folder
level: theme|topic|detail                               # strategic | domain | tactical
sources: ["../raw/inbox/source-file.md"]                # NEVER empty
sources_count: 1
confidence: low|medium|high                             # 1 | 2 | 3+ sources
canonical: null                                         # set if this is a cross-zone copy
relationships: { contains: [], similar_to: [], contradicts: [], derived_from: [] }
created: '2026-06-08T16:00:00Z'
modified: '2026-06-08T16:00:00Z'
content_hash: <sha256-12>                               # first 12 hex chars of the body
last_agent_hash: <sha256-12>                            # = content_hash at last agent write
external_refs: []                                       # e.g. jira:ABC-1 (reference only)
tags: []
---
```

`content_hash` is computed from the body (everything after the closing `---`, trailing whitespace
stripped per line, LF endings, UTF-8, `sha256()[:12]`). Comparing the live hash to
`last_agent_hash` detects human edits so automation never clobbers your manual changes. **This
definition must be identical across every tool** or dedup/edit-detection silently breaks.

### 5.3 Raw source frontmatter (`raw/**`)

Sources you drop in can be plain Markdown with no frontmatter — the engine still ingests them. When
you (or a capture tool) add frontmatter, use this generic shape:

```yaml
---
title: "Source title"
source: "https://... or original filename"
source_type: article|note|voice|meeting|clipping|document|media-sidecar
captured: '2026-06-08T16:00:00Z'
tags: []
---
```

> Note: the original (internal) system carried export-tool-specific fields (notebook/section/page
> IDs). Those are intentionally **not** part of the portable standard — keep raw frontmatter generic
> so any capture source fits.

### 5.4 Profile frontmatter (`second-brain/profile/**`)

```yaml
---
type: profile
profile: identity|voice|preferences|goals|relationships|projects|patterns
owner: "[OWNER]"
created: '2026-06-08T16:00:00Z'
modified: '2026-06-08T16:00:00Z'
tags: [profile]
---
```

### 5.5 Daily-note frontmatter (`daily/**`)

```yaml
---
type: daily
date: 2026-06-08
tags: [daily]
---
```

### 5.6 Initiatives / deliverables / records (non-wiki)

These follow the general style with their own fields and do **not** use the `zone:` enum:
- **initiatives:** `type: initiative`, `status`, `owner`, `members`, `milestones`, `external_refs`.
- **deliverables / records:** `type: deliverable|record`, `version`, `status`.

### 5.7 Personal-zone frontmatter (`personal/**`)

```yaml
# person — personal/people/<Full Name>.md
type: person
name: "Full Name"
relationship: friend|family|colleague|mentor|network
birthday: 2026-06-12          # or --06-12 if the year is unknown
location: "City"
met: "where / when"
tags: [person]
```

Other personal types (full templates in `personal/_templates/`):
- **area** — `personal/areas/<area>.md`: `type: area`, `status`, `review`
- **goal** — `personal/goals/<goal>.md`: `type: goal`, `status`, `horizon`, `target_date`, `area`
- **event** — `personal/calendar/<event>.md`: `type: event`, `date`, `recurring`, `remind_before`

Date fields (`birthday`, `date`) power the `personal/calendar/upcoming.md` Dataview dashboard.

---

## 6. Anti-forgetting rules (the trust contract)

Reproduced from `AGENTS.md` §4 because they are the soul of the system. Every assistant operation
obeys all seven:

1. **Append, don't rewrite.** New info goes in dated sections; existing content is preserved.
2. **Wiki is map, not territory.** Verify exact facts against raw and cite the source.
3. **Search before create.** Duplicates are a failure; always check first.
4. **Flag contradictions, don't resolve silently.** Surface both claims with sources; let the human decide.
5. **Provenance on every claim.** Every page has a `sources:` array; every fact references its source.
6. **One canonical location per entity.** Other zones link, not duplicate.
7. **Raw is immutable.** Read from `raw/`; write only to `pages/`, `index.md`, `log.md`, `review.md`.

---

## 7. Ingest, query & cross-zone flow (summary)

Full workflow is in `AGENTS.md` (§2 ingest, §6 query, §8 cross-zone). The shape:

```
drop source → fingerprint/dedup → extract fragments → route (entities/concepts/synthesis/references)
→ search-before-create → triage report (pause if >3 fragments or contradictions)
→ write source summary → write/append fragment pages → update index → append log → mark manifest
```

**Cross-zone:**
- **Cognitive extraction (Work → Second Brain):** recurring patterns and decision frameworks from
  `work/` are appended to `second-brain/profile/patterns.md`. Insight flows; raw data does not.
- **Linking:** entities have one canonical home; other zones reference via relative wikilink.
- **Privacy guardrail (extensible):** if you add a shared zone later, content from `second-brain/`
  or `work/` must never be auto-copied into it without explicit confirmation.

---

## 8. Hygiene conventions

- **`_archive/`** — nothing is deleted; stale raw and pre-consolidation page versions move to
  `_archive/` (with `YYYY/` subdirs). Pages keep pointers to archived sources.
- **`log.md`** — the audit trail. Every ingest, lint, and consolidation is logged. Append-only.
- **`review.md`** — the attention queue. Contradictions, near-duplicates, uncertain routing, and
  consolidation proposals land here. You resolve and remove; resolutions are logged.
- **Lint** — periodic health pass (after ~10 ingests or monthly): orphan pages, stale index
  entries, broken wikilinks, near-duplicates, unresolved contradictions, pending backlog,
  low-confidence aging, missing frontmatter, consolidation candidates.
- **Consolidation** — the *one* exception to "append, don't rewrite." When a page hits 5+ dated
  update sections it's rewritten as fresh synthesis, but only with: archived prior version, user
  approval, all sources preserved, and a **mandatory diff log** of what was preserved vs. dropped.
  Without the diff log, consolidation becomes the forgetting we exist to prevent.

---

## 9. Git & backup

The vault is plain files, so `git init` gives you free page history, branching, and rollback —
the simplest possible anti-forgetting safety net.

`vault/.gitignore` (shipped) tracks knowledge + shared Obsidian config and ignores: OS cruft,
Obsidian volatile state (`workspace.json`, cache, `.trash`), per-machine plugin binaries, and the
content of `projects/` and `scratch/` (keeping their pointer READMEs).

Recommended: commit after meaningful ingests, or let a scheduled assistant commit daily. If you
also use Obsidian Sync, git is your durable history; Sync is your live cross-device mirror — they
coexist fine as long as the vault isn't *also* in a cloud-sync folder (see §2).

---

## 10. Cross-harness compatibility

| Tool | Entry file it reads | How it picks up the schema |
|---|---|---|
| Claude Code | `CLAUDE.md` | Points to `AGENTS.md` |
| Cursor | `.cursorrules` | Points to `AGENTS.md` |
| Codex / OpenCode | `AGENTS.md` (native) | Reads directly |
| Desktop AI apps / local LLMs | `AGENTS.md` | Load it as context; the app indexes the folder |

The schema is deliberately tool-neutral: it never assumes a specific runtime, API, or plugin. Any
assistant that can read and write files in this folder is a valid wiki maintainer.

---

## 11. Taxonomy (terms used throughout)

| Term | Meaning here | Industry grounding |
|---|---|---|
| **Knowledge Vault** | This folder structure; works standalone or with Obsidian | — |
| **Obsidian vault** | The generic Obsidian concept (any folder Obsidian opens) | Obsidian |
| **Zone** | A privacy-bounded subdivision of the vault (second-brain / work / personal / toolkit) | trust zones |
| **Personal zone** | Hybrid life-management layer: CRM + areas + goals + calendar, plus a personal-life wiki | PARA + Personal CRM |
| **Personal CRM** | One file per person; relationships, networking, birthdays, interaction log | personal CRM |
| **Area** | An ongoing life domain with no end date (health, finances, hobbies…) | PARA (Tiago Forte) |
| **Journal / daily note** | The single shared daily capture surface; routed to zones by synthesis | 3-pillar (Wiki/CRM/Journal) |
| **Wiki** | The LLM-maintained, compiled knowledge layer (Karpathy pattern) | Karpathy LLM Wiki |
| **Raw** | Immutable source inputs | — |
| **Page** | A compiled synthesis artifact | wiki |
| **Source summary** | One page per ingested source | — |
| **Profile** | Static identity files that personalize assistants | "second brain" PKM |
| **Skill** | A reusable instruction file an assistant can follow | Alexa/agent skills |
| **Control tag** | `vault:pin` / `vault:skip` steering tags | — |
| **PokeVault** | This portable kit (the project that ships the vault + docs + skills) | — |

---

## 12. Reconstructing from zero (one-shot checklist)

On a fresh machine with nothing but this file:

1. Create `~/PokeVault/` and the tree in §3 (or run the `vault-init` skill in `skills/`).
2. Drop in `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `README.md`.
3. Seed `.obsidian/` (§4) and `.vault/` (config + empty `manifest.json`/`pending.json` per zone).
4. Seed each `wiki/` with `index.md`, `log.md`, `review.md` and the empty `raw/`+`pages/` buckets.
5. Seed `second-brain/profile/` with the 7 stubs; replace `[OWNER]` / `[INSTALL_DATE]`.
6. Open `~/PokeVault/` in Obsidian; install the recommended community plugins; verify link settings.
7. Point your AI assistant at `AGENTS.md` and drop your first source into a `raw/inbox/`.

That's the whole system. Everything after that is just feeding it.
