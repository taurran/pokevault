---
name: wiki-ingest
version: "1.0.0"
category: 08-knowledge
description: "Compile new raw sources in a zone's wiki/raw/ into interlinked wiki pages, following the AGENTS.md schema. Dedups, routes, flags contradictions, updates index + log."
trigger: "process my inbox"
when_to_use: "After dropping one or more sources into a zone's wiki/raw/{inbox,meetings,notes,media}/."
inputs:
  - name: zone
    description: "second-brain, work, or personal. Default: ask, or use config default_inbox."
    required: false
harness_notes: "Pure prompt-driven; the LLM does the routing/synthesis. Requires file read/write. Honors vault:pin / vault:skip control tags."
---

## wiki-ingest

This skill is a thin trigger over the authoritative workflow in `AGENTS.md` §2. **Read AGENTS.md
before running.** Do not re-implement the rules here — follow them there.

### Steps (mirrors AGENTS.md §2)

1. **Discover** new files in the live raw buckets (`inbox/ meetings/ notes/ media/`) — **not
   `processed/` or `_archive/`** — that aren't in `.vault/state/<zone>/manifest.json`.
2. **Fingerprint & dedup** (SHA-256, normalized). Skip duplicates.
3. **Read & extract** fragments (entities, concepts, facts, decisions, contradictions).
4. **Route** each fragment (entities/concepts/synthesis/references; default synthesis).
5. **Search before create** — update existing pages instead of duplicating.
6. **Triage report** — if >3 fragments or any contradiction, PAUSE for approval; else proceed and
   append the report to `log.md`.
7. **Write source summary** in `pages/sources/`, then fragment pages (proper frontmatter, §5).
8. **Update `index.md`**, **append `log.md`**, **update `manifest.json`**, clear `pending.json`.
9. **Move each ingested source to `raw/processed/`** (text from `inbox/`, `notes/`, `meetings/`;
   binary `media/` stays in place, its `.md` sidecar moves) — the dedup-by-absence signal. If a
   daily note was processed, refresh its one-line entry in `daily/index.md`.

### Guardrails
- Never edit raw *content*; the only permitted move is a source → `raw/processed/` after ingest.
- Append to existing pages; never rewrite (except approved consolidation).
- Every page gets a `sources:` array. Flag contradictions; never resolve silently.
- `research/<project>/raw/` files may be ingested like any raw source. A project's `findings.md`
  is promoted via the `research-promote` skill (AGENTS §8), not auto-ingested. Never compile
  `research/<project>/notes/` (WIP).
