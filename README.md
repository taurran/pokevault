# PokeVault

**A portable "Second Brain + LLM Wiki" you can carry to any machine.** Clone it, run one script, open
it in **Obsidian**, and point any AI assistant at `AGENTS.md`. Raw material you collect gets *compiled*
into persistent, interlinked notes that **compound over time** — instead of being re-derived from
scratch on every question.

Plain Markdown. No database, no server, no accounts, no vendor lock-in. Works with Claude Code,
Cursor, Codex, Gemini CLI, Aider, a local LLM, or any desktop AI app.

### Get it
**`git clone https://github.com/taurran/pokevault.git`** — or **[download the ZIP](https://github.com/taurran/pokevault/archive/refs/heads/master.zip)** (no git needed).
Then run `./bootstrap.sh` (macOS/Linux) or `.\bootstrap.ps1` (Windows). That's it — details below.

> **The idea in one line:** compile raw sources into a living Markdown wiki *once*; query the wiki,
> not the pile; never overwrite, never forget.

---

## Install (60 seconds)

### 1. Get it

**Clone (recommended — easiest to update later):**
```bash
git clone https://github.com/taurran/pokevault.git && cd pokevault
```
**Or download the ZIP** (no git needed): **[⬇️ pokevault.zip](https://github.com/taurran/pokevault/archive/refs/heads/master.zip)** — extract it and open the `pokevault` folder in a terminal.

<sub>On Windows, a cloned copy usually runs the bootstrap with no fuss; a *downloaded* ZIP can trip PowerShell's script policy — one-line fix in step 2.</sub>

### 2. Run the bootstrap
The bootstrap installs the vault into a **local folder** — default `C:\PokeVault` on Windows, `~/PokeVault`
on macOS/Linux — **and** wires its skills into your coding agent. It asks where to install (press Enter for
the default or type a custom path), is safe + idempotent, and prints the final vault path on completion.

- **macOS / Linux:**
  ```bash
  ./bootstrap.sh
  ```
- **Windows (PowerShell):**
  ```powershell
  .\bootstrap.ps1
  ```
  **If PowerShell blocks it** ("…not digitally signed"), allow scripts for *this terminal only*, then re-run:
  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
  .\bootstrap.ps1
  ```
- **Custom location:** `./bootstrap.sh ~/Knowledge` (or `.\bootstrap.ps1 -VaultRoot D:\Vaults\PokeVault`).

**Or let your AI agent run it for you.** Point your AI assistant at the
`pokevault` folder and paste this prompt:

> Run the PokeVault bootstrap in this folder: execute `./bootstrap.sh` (macOS/Linux) or
> `.\bootstrap.ps1` (Windows) to install the vault to `~/PokeVault` and wire its skills. Then open
> `~/PokeVault`, read `AGENTS.md`, and tell me when it's ready.

**Default vault location:**

| OS | Vault path |
|---|---|
| macOS | `/Users/<you>/PokeVault` |
| Linux | `/home/<you>/PokeVault` |
| Windows | `C:\PokeVault` |

### 3. Open in Obsidian
**Don't have Obsidian yet?** Download it free from the official site: **[obsidian.md/download](https://obsidian.md/download)**.

Launch Obsidian → **Open folder as vault** → select your vault folder. The shipped `.obsidian/` config
applies automatically (absolute wikilinks, Daily Notes → `daily/`, ignore filters). Then install the
recommended community plugins (run the `obsidian-setup` skill, or do it by hand): **Dataview,
Templater, Tag Wrangler, Periodic Notes**.

### 4. Personalize
Replace `[OWNER]` and `[INSTALL_DATE]` in `AGENTS.md` and `second-brain/profile/*` — or just tell your
assistant **"build my profile"** (the `profile-build` skill) and **"initialize my vault"** (`vault-init`).

Full, detailed walkthrough (sync/backup, troubleshooting, updates): **`INSTALL.md`**.

---

## What the bootstrap does

1. Copies the `vault/` into a local folder — `~/PokeVault` (`C:\PokeVault` on Windows) — skipping if one already exists (never clobbers your data).
2. Installs the kit's skills to `~/PokeVault/toolkit/skills/<NN-category>/<name>.md` (tool-neutral source, organized by category).
3. Generates **Claude Code** skill bindings at `~/PokeVault/.claude/skills/<name>/SKILL.md` (the open
   Agent-Skills format — one folder per skill).
4. Confirms the engine (`AGENTS.md`) and per-tool pointers are in place.

---

## Connect your AI assistant

The schema is identical for every tool — only the entry file differs. `AGENTS.md` is the engine; the
others point to it.

| Tool | What to do |
|---|---|
| **Claude Code** | Open your vault as the project. Reads `CLAUDE.md` → `AGENTS.md`; skills auto-load from `.claude/skills/`. |
| **Codex / Cursor / Gemini CLI / Aider / Windsurf / Zed** | Open the vault. They read `AGENTS.md` natively; the skill catalog + trigger phrases live in **AGENTS.md §11**. |
| **Local LLM / desktop AI app** | Add the vault as an indexed folder; tell it to read `AGENTS.md` first. |

**Skills everywhere (optional):** to use the skills in Claude Code outside this vault, copy the
`<name>/` folders from `~/PokeVault/.claude/skills/` to `~/.claude/skills/` (personal scope).

### First test
1. Drop a `.md` file (an article, some notes) into `second-brain/wiki/raw/inbox/`.
2. Say: **"Read AGENTS.md and process my second-brain inbox."**
3. Watch it create `pages/`, update `index.md`, append to `log.md`, and move the source to `raw/processed/`.

---

## What's inside

```
pokevault/
├── README.md            ← you are here (the install guide)
├── README.txt           ← plain-text quickstart (same steps, no formatting)
├── INSTALL.md           ← detailed setup: Obsidian, sync/backup, updates, troubleshooting
├── VERSION              ← 1.1.1
├── bootstrap.sh         ← one-command installer (macOS/Linux)
├── bootstrap.ps1        ← one-command installer (Windows)
├── docs/
│   ├── 01-vault-blueprint.md                    ← structure, Obsidian compat, frontmatter, taxonomy
│   └── 02-llm-wiki-synthesis-and-daily-notes.md ← the LLM-wiki pattern, synthesis, daily notes
├── skills/              ← the wiring skills, by category (installed into the vault by bootstrap)
│   ├── 01-foundations/  ← vault-init, obsidian-setup, profile-build, pokevault-update
│   ├── 02-research/     ← research-init, research-promote
│   └── 08-knowledge/    ← wiki-ingest, wiki-lint, daily-note
└── vault/               ← THE vault (bootstrap copies this to ~/PokeVault)
    ├── AGENTS.md         ← the engine: the schema every AI assistant reads
    ├── CLAUDE.md  .cursorrules  ← per-tool entry points → AGENTS.md
    ├── second-brain/  work/  personal/  toolkit/  ← the four zones
    ├── daily/                                     ← one shared daily note + index + review queue
    ├── research/                                  ← research workshop: per-project investigation, promoted into the wiki when ready
    ├── projects/  scratch/                        ← non-knowledge (Obsidian-ignored)
    └── .obsidian/  .vault/                         ← config + state
```

### The four zones

| Zone | Holds | Wiki? |
|---|---|---|
| `second-brain/` | Your self-model (`profile/`) + personal knowledge wiki | ✅ |
| `work/` | Projects, deliverables, records + work knowledge wiki | ✅ |
| `personal/` | Life management — people (CRM), areas, goals, calendar + a personal-life wiki | ✅ (hybrid) |
| `toolkit/` | Your own skills (by category), agents, agent-sops (multi-step procedures), context files | — |

One shared **`daily/`** note is the frictionless front door: capture work + personal freely, and your
assistant routes each fragment to the right zone (logging anything ambiguous to `daily/review.md` for
one-tap reclassification). `daily/index.md` keeps a scannable journal index. **`research/`** is the
investigation workshop — one folder per project — where findings are promoted into the wiki when ready.

---

## Everyday use

The loop never changes — **capture → compile → query**:

1. **Capture (zero friction).** Jot anything into today's note (say *"open today's note"*), or drop a
   source — an article, PDF text, meeting notes — into a zone's `wiki/raw/inbox/`. Don't categorize; just capture.
2. **Compile.** Say *"process my inbox"* (or *"process today's note"*). Your assistant reads the raw
   material, routes each fragment to the right zone, writes interlinked wiki **pages** with provenance,
   updates the zone `index.md`, and moves the source to `raw/processed/`. People → your CRM
   (`personal/people/`); durable knowledge → `second-brain/wiki/`; work → `work/wiki/`; personal-life
   synthesis → `personal/wiki/`.
3. **Query.** Just ask. The assistant answers from the compiled wiki + your CRM + the journal —
   grounded, cited, consistent — instead of re-deriving from scratch each time.
4. **Maintain.** Every ~10 ingests (or monthly) say *"lint my wiki"* to catch orphans, stale links,
   near-duplicates, and consolidation candidates.

Investigations get their own workshop: *"start research &lt;name&gt;"* scaffolds a project folder; when a
finding is solid, *"promote research"* compiles it into the curated wiki with full provenance.

## The skills

Nine tool-neutral skills ship in `skills/` and install into your vault. Trigger them by phrase, or tell
any assistant *"Read `toolkit/skills/<category>/<name>.md` and follow it."*

| Skill | Category | Say | What it does |
|---|---|---|---|
| `vault-init` | `01-foundations` | *"initialize my vault"* | Scaffold a fresh vault — folders, engine, config, seeds. Idempotent; repairs a partial vault. |
| `profile-build` | `01-foundations` | *"build my profile"* | Interview you to fill the `second-brain/profile/` cognitive-fingerprint files. |
| `obsidian-setup` | `01-foundations` | *"set up obsidian"* | Install the recommended plugins and verify the link/ignore settings the wiki needs. |
| `pokevault-update` | `01-foundations` | *"update my vault"* | Apply a newer release into your vault without touching your data. |
| `research-init` | `02-research` | *"start research &lt;name&gt;"* | Scaffold a research project folder from the template. |
| `research-promote` | `02-research` | *"promote research"* | Compile a ready finding into the curated wiki, with provenance. |
| `wiki-ingest` | `08-knowledge` | *"process my inbox"* | Compile new `raw/` sources into interlinked wiki pages — dedup, route, cite, flag contradictions. |
| `wiki-lint` | `08-knowledge` | *"lint my wiki"* | Health-check a zone's wiki: orphans, stale index entries, broken links, duplicates, consolidation. |
| `daily-note` | `08-knowledge` | *"open today's note"* | Open the shared daily note; route end-of-day captures to the right zones. |

---

## The guarantee

Your assistant follows seven **anti-forgetting rules** (`AGENTS.md` §4): append don't rewrite, verify
against sources, search before create, flag contradictions, provenance on every claim, one canonical
page per entity, raw is immutable. And every future **update deploys *into* your vault without touching
your data** (`skills/01-foundations/pokevault-update.md`).

## Updating later
Pull a newer release and re-run `./bootstrap.sh` — it adds new structure and re-syncs skills without
overwriting your notes, profile, raw sources, or state. Details in `INSTALL.md`.

## On your phone (iOS & Android)
Phones are for **capture**, not compiling. Install **[Obsidian Mobile](https://obsidian.md/download)**,
turn on **Obsidian Sync** so the same vault lives on desktop + phone, and jot or **dictate** into
today's daily note (or `raw/inbox/`) on the go. Your desktop assistant compiles it later — no phone-side
AI agent needed. Full steps in `INSTALL.md`.

## Requirements
- **[Obsidian](https://obsidian.md/download)** (free) — the primary surface. Official download: https://obsidian.md/download
- An AI assistant with filesystem access (Claude Code, Cursor, Codex, Gemini CLI, Aider, a local
  LLM, or a desktop AI app).
- `bash` (macOS/Linux) or PowerShell (Windows) to run the bootstrap.

## Clean-room note
PokeVault is an independent, clean-room project: plain-Markdown conventions and public patterns only —
no proprietary code or content, no vendor lock-in.

## Credits
Builds on public patterns: the **LLM Wiki** pattern (Andrej Karpathy), **Obsidian** (Daily/Periodic
Notes, Dataview), **PARA** (Tiago Forte), and three ingest patterns from **OB1 / Open Brain**
(Nate B. Jones, FSL-1.1-MIT) — implemented from scratch, no code vendored. See `docs/02` Research Appendix.

## License
[Apache-2.0](LICENSE).
