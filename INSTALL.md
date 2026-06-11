# Installing PokeVault

PokeVault is plain files. "Installing" means: put the `vault/` folder where you want it, open it in
Obsidian, install a few plugins, and tell your AI assistant where the schema is. 10 minutes.

---

## 0. Prerequisites

- **Obsidian** (free) — https://obsidian.md/download. Optional but strongly recommended.
- **An AI assistant** that can read/write local files: Claude (Desktop/Code), Cursor, Codex, a
  local LLM with file tools, or a desktop AI app that can index a folder.
- **git** (optional) — for version history of your vault.

---

## 1. Place the vault

Pick a **local** location **outside** any cloud-sync folder (OneDrive / iCloud / Dropbox) if you plan to
use Obsidian Sync or git (see §5) — two sync engines on one vault cause conflicts and corrupt `.obsidian`.

- **Windows:** the bootstrap defaults to **`C:\PokeVault`** for exactly this reason — your `Documents`
  folder is usually redirected into OneDrive. A drive-root local folder keeps the vault off the sync
  engine and easy to find. (Pass `-VaultRoot <path>` if `C:\` is locked down on your machine.)
- **macOS / Linux:** the default **`~/PokeVault`** sits in your home dir, not the iCloud-synced
  `~/Documents`/`~/Desktop`, so it's safe as-is.

**macOS / Linux**
```bash
cp -R PokeVault/vault ~/PokeVault
```

**Windows (PowerShell)**
```powershell
Copy-Item -Recurse PokeVault\vault C:\PokeVault
```

The folder name (`PokeVault`) becomes the Obsidian vault display name. Rename if you like.

> **Easiest path — one command (recommended).** Instead of copying by hand, run the bootstrap from
> the unzipped package. It places the vault *and* wires the skills into your coding agent(s):
>
> ```bash
> cd PokeVault && ./bootstrap.sh            # macOS / Linux
> ```
> ```powershell
> cd PokeVault; .\bootstrap.ps1             # Windows
> ```
>
> Pass a path to install elsewhere: `./bootstrap.sh ~/Knowledge`. It's safe to re-run (idempotent) and
> never overwrites your content. Or build from scratch with your assistant: open `skills/01-foundations/vault-init.md`
> and say "initialize my vault at ~/PokeVault".

---

## 2. Personalize

Replace two placeholders wherever they appear:
- `[OWNER]` → your name
- `[INSTALL_DATE]` → today (ISO-8601, e.g., `2026-06-08T00:00:00Z`)

They're in `AGENTS.md` and `second-brain/profile/*.md`. Either edit by hand, or run the
`profile-build` skill with your assistant to fill the profile conversationally. (`.vault/config.yaml`
has `created: null` — the `vault-init` skill stamps it on first run, or you can set it manually.)

---

## 3. Open in Obsidian

1. Launch Obsidian → **Open folder as vault** → select `~/PokeVault`.
2. The shipped `.obsidian/` config applies automatically (absolute links, ignore filters, Daily Notes).
3. Install recommended **community plugins** (Settings → Community plugins → turn off **Restricted
   Mode**, then **Browse**). Obsidian requires you to install these yourself:
   | Plugin | Why |
   |---|---|
   | Dataview | Query wiki frontmatter (level, confidence, sources_count) |
   | Templater | Richer page/daily templates |
   | Tag Wrangler | Manage `vault:pin` / `vault:skip` tags |
   | Periodic Notes | Weekly/monthly/quarterly notes |
4. Verify Settings → Files & Links: **New link format = Absolute**, **Use [[Wikilinks]] = on**.

`projects/`, `scratch/`, and `.vault/` are hidden from the file explorer on purpose.

(Or run the `obsidian-setup` skill with your assistant for a guided version.)

---

## 4. Connect your AI assistant

Point your assistant at the schema. It's the same schema for every tool — only the entry file differs:

| Tool | What to do |
|---|---|
| **Claude Code** | Open `~/PokeVault` as the project; it reads `CLAUDE.md` → `AGENTS.md`. |
| **Cursor** | Open `~/PokeVault`; it reads `.cursorrules` → `AGENTS.md`. |
| **Codex / OpenCode** | Reads `AGENTS.md` natively. |
| **Desktop AI app / local LLM** | Add `~/PokeVault` as an indexed folder; tell it to read `AGENTS.md` first. |

### How your skills are wired
`bootstrap.sh` installs the kit's skills in two shapes so every tool can find them:
- **Canonical source** — `~/PokeVault/toolkit/skills/<NN-category>/<name>.md` (plain Markdown, readable by any agent).
- **Claude Code** — `~/PokeVault/.claude/skills/<name>/SKILL.md` (the open Agent-Skills format; one folder
  per skill, `SKILL.md` singular). Claude auto-loads a skill when your request matches its
  `description`. Just open `~/PokeVault` as the project.
- **Codex / Cursor / Gemini / Aider / Windsurf / Zed** — these read `AGENTS.md` natively; the skill
  catalog + trigger phrases live in **AGENTS.md §11**, so the agent opens `toolkit/skills/<category>/<name>.md`
  on demand.
- **Want skills available everywhere in Claude Code?** Copy the `<name>/` folders from
  `~/PokeVault/.claude/skills/` to `~/.claude/skills/` (personal scope) instead of leaving them in-vault.

> Re-run `./bootstrap.sh` after any kit update to resync the `.claude/skills/` bindings.

Then test:
1. Put a `.md` file (an article, some notes) into `second-brain/wiki/raw/inbox/`.
2. Say: **"Read AGENTS.md and process my second-brain inbox."**
3. Watch it create `pages/`, update `index.md`, and append to `log.md`.

---

## 5. Sync & backup (choose ONE primary sync)

**This desktop vault is the source of truth — seed sync FROM it.** Turn your sync engine on *here* first
(it uploads this vault); then on your phone or another machine, connect to the **same** remote and it
**downloads** a copy. You never re-create the vault on the other device — it always flows out from here.

- **Obsidian Sync / Syncthing / git:** keep the vault at `~/PokeVault`, **outside** OneDrive / iCloud /
  Dropbox / Google Drive. Two sync engines on the same files cause conflicts and corrupt `.obsidian`.
- **Cloud-folder backup only (no cross-device editing):** a cloud folder is fine, but set the files
  to **"always keep on this device"** (Windows OneDrive: right-click → *Always keep on this device*;
  macOS iCloud: disable *Optimize Storage*) so Obsidian sees real local files.
- **git (recommended either way):**
  ```bash
  cd ~/PokeVault && git init && git add . && git commit -m "Initial vault"
  ```
  The shipped `.gitignore` tracks your knowledge + shared Obsidian config and ignores OS cruft,
  Obsidian workspace/cache, plugin binaries, and `projects/`/`scratch/` content.

  > ⚠️ **Privacy:** this vault holds your private `second-brain/` and `work/` content. If you add a
  > git remote, make sure it is **private**. Never push a personal vault to a public repository.

---

## 6. Updating later (without losing data)

When a newer PokeVault release ships, you can deploy its improvements **into** your existing vault
without disturbing your content. The rules are binding (`skills/01-foundations/pokevault-update.md`):

- **Overwritten** (with a backup to `.vault/_backup/<version>/`): the engine (`AGENTS.md`), harness
  pointers, shipped docs, and reference templates.
- **Never touched:** your `wiki/raw/`, `wiki/pages/`, `index.md`, `log.md`, `review.md`, `profile/`,
  `initiatives/`/`deliverables/`/`records/`/`artifacts/`/`daily/`, `.vault/state/`, your
  `.vault/config.yaml` *values*, `toolkit/`, `projects/`, `scratch/`.
- **Added:** new structure and new config keys (merged, never overwriting your values).

To update: get the new release, then tell your assistant **"update my vault from <release path>"**
(runs `pokevault-update`: it dry-runs a plan, asks you to confirm, backs up, then applies). It's
idempotent — safe to re-run.

---

## Mobile (iOS & Android) — capture on the go, compile on desktop

PokeVault compiles on a **computer** — that's where your AI assistant runs the ingest/synthesis.
Phones are the best **capture** device, so the mobile story is deliberately simple: **no app to
install beyond Obsidian, no phone-side AI agent, nothing to sideload.**

1. **Install Obsidian Mobile** (free): https://obsidian.md/download (App Store / Google Play).
2. **Turn on Obsidian Sync** on your desktop *and* phone so the same vault lives on both. Obsidian's
   first-party sync is the least-fuss option — no need to reinvent the wheel. (Any single sync engine
   works; just never run two on the same vault — see §5.)
3. **Capture anywhere, friction-free:**
   - Open **today's daily note** and type, paste, or **dictate** (keyboard mic) into the **Capture**
     section — the front door.
   - Or drop a quick note / voice transcript as a file into `second-brain/wiki/raw/inbox/`.
4. **Compile on desktop:** back at a computer, tell your assistant **"route today's daily note"** or
   **"process my inbox"** — it runs the normal `AGENTS.md` pipeline (dedup, route, link, move to
   `raw/processed/`) and syncs the compiled pages back to your phone to read.

**Why no phone agent?** On-device agentic synthesis isn't dependable yet (the Claude *app* can't touch
vault files; Claude Code "remote control" needs an always-on desktop; cloud agents can't reach a
private repo). Capture-on-mobile + compile-on-desktop works offline, needs zero extra software, and —
since the vault is just Markdown — any future mobile agent can read it unchanged.

---

## Research projects

Say **"start research \<name\>"** to scaffold a project folder under `research/`. Drop sources in its
`raw/`, take notes in `notes/`, write `findings.md`, and mark the project `status: ready` (or tag
`vault:promote`) to promote durable findings into your wiki.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Windows: `.ps1` won't run ("not digitally signed") | Allow scripts for the session only, then re-run: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force`. |
| Cross-zone `[[links]]` don't resolve | Settings → Files & Links → New link format = **Absolute**. |
| `projects/`/`scratch/` clutter the explorer | Confirm `.obsidian/app.json` `userIgnoreFilters` applied; reopen vault. |
| Assistant edits raw files | Re-point it at `AGENTS.md`; §9 forbids writing to `raw/`. |
| Daily note has no template | Settings → Daily Notes → Template = `daily/_templates/daily`. |
| Sync conflict copies appear | You have two sync engines on the vault (§5) — keep only one. |
| Phone captures don't reach the desktop | Confirm Obsidian Sync is enabled on **both** devices for the **same** vault. |
