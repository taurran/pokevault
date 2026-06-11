---
name: research-init
version: "1.0.0"
category: 02-research
description: "Scaffold a new research project folder from the template. Idempotent — re-running repairs missing pieces without overwriting existing content."
trigger: "start research <name>"
when_to_use: "Beginning a new investigation or research project."
inputs:
  - name: project_name
    description: "Human-readable name for the research project."
    required: true
  - name: vault_root
    description: "Vault root path. Default ~/PokeVault."
    required: false
harness_notes: "Harness-agnostic. Requires file-create + folder-create. An external harness may set the harness: field in the generated frontmatter."
---

## research-init

Scaffolds a research project per the structure defined in `AGENTS.md` §5 (research frontmatter) and
§10 (known folders). Templates live in `research/_templates/`.

### Steps

1. **Resolve vault root.** Use `vault_root` input or default `~/PokeVault`. Resolve `~`.
   Slugify `project_name`: lowercase, replace spaces with hyphens, strip non-alphanumeric except
   hyphens.

2. **Idempotency check.** If `research/<slug>/` already exists, enter repair mode — create only
   missing pieces; never overwrite existing files.

3. **Create project structure:**
   - `research/<slug>/raw/` — drop zone for source material (add `.gitkeep`).
   - `research/<slug>/notes/` — WIP notes (add `.gitkeep`).
   - `research/<slug>/README.md` — from `research/_templates/research-project.md`:
     set `slug`, `title` (the given name), `question` (placeholder `"TODO"`),
     `status: active`, `harness: null`, stamp `created`/`modified` to now
     (single-quoted ISO-8601 UTC with Z suffix).
   - `research/<slug>/findings.md` — from `research/_templates/research-finding.md`:
     set `project: <slug>`, `status: wip`, `sources: []`, `confidence: low`,
     stamp `created`/`modified`.

4. **Report.** List files created vs skipped. Tell the user:
   - Drop source material into `raw/`.
   - Take working notes in `notes/`.
   - Write up results in `findings.md`.
   - When ready to promote, set `status: ready` (or add tag `vault:promote`).

### Source of truth

Structure: `AGENTS.md` §5 (research frontmatter schema) + §10 (known folders).
Templates: `research/_templates/research-project.md`, `research/_templates/research-finding.md`.
