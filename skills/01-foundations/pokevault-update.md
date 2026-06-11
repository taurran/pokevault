---
name: pokevault-update
version: "1.0.0"
category: 01-foundations
description: "Apply a newer PokeVault release into an existing ~/PokeVault WITHOUT disturbing user content. Updates the engine, docs, skills, and templates; adds new structure; merges new config keys; never touches knowledge, raw, profile, state, or user config values."
trigger: "update my vault"
when_to_use: "When a new PokeVault version ships and you want its improvements deployed into a vault that already has your data."
inputs:
  - name: vault_root
    description: "The live vault to update. Default ~/PokeVault."
    required: false
  - name: release_path
    description: "Path to the new PokeVault release (the kit's vault/ template + docs/ + skills/)."
    required: false
status: "SPEC — the executable skill is built and shipped with the release that needs it. This file is the binding contract that every future update obeys."
harness_notes: "Must be idempotent. Must dry-run and report a plan before writing. Must back up overwritten engine files to .vault/_backup/<version>/ before replacing."
---

## pokevault-update

> **The non-destructive update contract.** Updates deploy *into* the vault. They add capability and
> refresh shipped files. They **never** lose or alter your data. This contract is non-negotiable and
> applies to every PokeVault release, forever.

### The update contract

**OVERWRITE (shipped, version-managed — safe to replace):**
- `AGENTS.md`, `CLAUDE.md`, `.cursorrules`
- `docs/**` (if docs are shipped into the vault)
- Reference templates: `daily/_templates/**`, `work/deliverables/_templates/**`, zone READMEs, `vault/README.md`
- `.obsidian/{core-plugins,community-plugins,templates,daily-notes}.json` (config schema, not user workspace)
- `vault/.gitignore` (shipped defaults)

Before overwriting any file, copy the current version to `.vault/_backup/<old-version>/<path>` so
the user can diff/restore.

**NEVER TOUCH (user-owned — read-only to the updater):**
- `*/wiki/raw/**` — immutable sources
- `*/wiki/pages/**`, `index.md`, `log.md`, `review.md` — your knowledge
- `second-brain/profile/**` — your fingerprint
- `*/initiatives/**`, `deliverables/**` (except `deliverables/_templates/**`), `records/**`, `artifacts/**`, `daily/**` (except `daily/_templates/**`)
- `.vault/state/**` — manifests + pending queues
- `.vault/config.yaml` **values** — user-owned (see merge rule)
- `toolkit/**` — your own skills/agents/context
- `projects/**`, `scratch/**`
- `.obsidian/app.json` user edits, `.obsidian/workspace*.json`, plugin data

**ADD (new in the release):**
- New folders/zones → create if missing (idempotent).
- New shipped skills → write into the kit's `skills/` (and tell the user; copies they put in
  `toolkit/` are never overwritten).
- New config keys → **merge** into `.vault/config.yaml`: add missing keys with defaults; **never**
  overwrite an existing user value. If a new key is *required*, prompt for it conversationally.

### Procedure (idempotent)

1. **Read versions.** Compare release `VERSION` to `.vault/config.yaml` `pokevault_version`.
   If equal and no `--force`, report "already current" and stop.
2. **Plan (dry-run first).** Produce a change plan: files to overwrite (with backup target), files
   to add, config keys to merge, new required prompts. **Show the plan; do not write yet.**
3. **Confirm.** Wait for user approval (this is a write to their vault).
4. **Backup.** Copy every file slated for overwrite into `.vault/_backup/<old-version>/`.
5. **Apply.** Overwrite shipped files; create new structure; merge config keys.
6. **Migrate (if the release ships a migration note).** Run only additive, reversible migrations,
   each described in the release's migration notes / CHANGELOG. Record each migration in
   `.vault/migrations.log` (machine state) — **never** in a zone's knowledge `log.md`, which the
   updater treats as read-only.
7. **Stamp.** Set `.vault/config.yaml` `pokevault_version` to the new version.
8. **Report.** What was overwritten (and where the backup is), what was added, what config was
   merged, and anything that needs the user's attention.

### Guarantees the user can rely on
- Re-running is safe (idempotent).
- A failed/partial run leaves data intact (writes are additive + backed up).
- No knowledge, raw source, profile, or state is ever read-modified-written by the updater.
