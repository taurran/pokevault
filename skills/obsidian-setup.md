---
name: obsidian-setup
description: "Open the vault in Obsidian, install the recommended community plugins, and verify the link/ignore settings that the wiki depends on."
trigger: "set up obsidian"
when_to_use: "Once per machine, after the vault folder exists."
inputs: []
harness_notes: "Mostly user-guided UI steps. Obsidian's security model requires the user to install community plugins manually."
---

## obsidian-setup

### 1. Open the vault
Launch Obsidian → "Open folder as vault" → select `~/PokeVault` (Windows: `C:\PokeVault`).
The shipped `.obsidian/` config applies automatically.

### 2. Install recommended community plugins
Settings → Community plugins → Browse, then install + enable:

| Plugin | Why |
|---|---|
| Dataview | Query wiki frontmatter (`level`, `confidence`, `sources_count`, `tags`) |
| Templater | Richer templates for pages and daily notes |
| Tag Wrangler | Manage tags incl. `vault:pin` / `vault:skip` |
| Periodic Notes | Weekly/monthly/quarterly notes on top of core Daily Notes |

Optional browser add-on: **Obsidian Web Clipper** → set its output folder to
`second-brain/wiki/raw/inbox/`.

### 3. Verify settings (Settings → Files & Links)
- "New link format" = **Absolute path in vault**
- "Use [[Wikilinks]]" = **enabled**
- "Automatically update internal links" = **enabled**

If these differ, the shipped `.obsidian/app.json` was skipped — re-run `vault-init` or set them by hand.

### 4. Confirm hidden folders
`projects/`, `scratch/`, and `.vault/` should not appear in the file explorer (they're in
`userIgnoreFilters`). If they do, check Settings → Files & Links → Excluded files.

### 5. Daily notes
Core Daily Notes is enabled and points at `daily/` with the seeded template. Trigger "Open
today's daily note" to confirm. The journal also ships `daily/index.md` (a Dataview-backed
chronological index) and `daily/review.md` (the reclassification queue — a Dataview lists any
unresolved default-routed captures). Open both once to confirm Dataview renders them.
