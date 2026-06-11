---
name: vault-init
version: "1.0.0"
category: 01-foundations
description: "Scaffold a fresh PokeVault knowledge vault on this machine — folders, engine files, .obsidian config, .vault state, profile stubs, and wiki seeds. Idempotent. Use on a new machine or to repair a partial vault."
trigger: "initialize my vault"
when_to_use: "First-time setup on a new machine, or to re-create any missing structural files without disturbing existing content."
inputs:
  - name: vault_root
    description: "Where to create the vault. Default ~/PokeVault (macOS/Linux) or C:\PokeVault (Windows)."
    required: false
  - name: owner
    description: "Your name; substituted for [OWNER] in seeded files."
    required: false
harness_notes: "Harness-agnostic. Any assistant with file-create + folder-create can run this. On Windows substitute the path separator."
---

## vault-init

Builds the vault defined in `docs/01-vault-blueprint.md` §3. **Never overwrites existing files** —
only creates what's missing. Safe to re-run.

### Steps

1. **Resolve root.** Use `vault_root` or default `~/PokeVault`. Resolve `~`/`%USERPROFILE%`.
2. **Idempotency check.** If `<root>/.vault/config.yaml` exists, this is a repair run: preserve
   everything; only create missing files/folders. Otherwise a fresh build.
3. **Create folders** (no-op if present) from the blueprint:
   - `second-brain/{profile,initiatives,artifacts}` and `second-brain/wiki/{raw/{inbox,notes,media,processed,_archive},pages/{sources,entities,concepts,synthesis,references}}`
   - `work/{initiatives,deliverables/_templates,records,artifacts,daily/_templates}` and `work/wiki/{raw/{inbox,meetings,notes,media,processed,_archive},pages/{sources,entities,concepts,synthesis,references}}`
   - `personal/{people,areas,goals,calendar,_templates}` and `personal/wiki/{raw/{inbox,notes,media,processed,_archive},pages/{sources,entities,concepts,synthesis,references}}` (hybrid zone: operational CRM folders + a wiki — clone of `second-brain/wiki`, no `meetings/` bucket)
   - `toolkit/{skills,agents,context}`
   - `research/{_templates,_archive}`
   - `projects/`, `scratch/`
   - `.obsidian/`, `.vault/state/{second-brain,work,personal}`
4. **Write engine + pointers** (skip if present): `AGENTS.md`, `CLAUDE.md`, `.cursorrules`,
   `README.md`. Substitute `[OWNER]` and `[INSTALL_DATE]`
   (today, ISO-8601 UTC).
5. **Write `.obsidian/`** config (skip if present): `app.json`, `core-plugins.json`,
   `community-plugins.json`, `daily-notes.json`, `templates.json` (values per blueprint §4).
   **Obsidian is PokeVault's first-class surface — this wiring is part of init, not an optional
   add-on.** It enables core Daily Notes → `daily/`, Templates, and absolute wikilinks out of the box.
6. **Write `.vault/`** state (skip if present): `config.yaml` (stamp `created`), and per zone
   `state/<zone>/manifest.json` = `{}`, `pending.json` = `[]`.
7. **Seed zone files** (skip if present): zone READMEs; `second-brain/profile/` 7 stubs;
   each wiki zone's (`second-brain`, `work`, `personal`) `wiki/` `index.md`/`log.md`/`review.md`; `daily/_templates/daily.md`; `daily/index.md`
   (journal index); `daily/review.md` (reclassification queue); `projects/README.md`;
   `scratch/README.md`; `research/README.md`; `research/index.md`;
   `research/_templates/{research-project,research-note,research-finding}.md`;
   `research/_archive/.gitkeep`.
8. **Report.** List created vs skipped. Tell the user to open `<root>` in Obsidian, install the
   recommended community plugins, and run `obsidian-setup` to verify.

### Source of truth
All structure decisions come from `docs/01-vault-blueprint.md`. If the blueprint and this skill ever
disagree, the blueprint wins — update the skill.
