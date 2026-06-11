# Toolkit

Your personal AI additions — the skills, agents, agent SOPs, and context files you author or
customize. This zone has **no wiki**; it is not ingested.

## Structure

- `skills/` — skills organized by **category folder**: `skills/<NN-category>/<name>.md`
- `agents/` — your custom scheduled or event-driven agents
- `agent-sops/` — multi-step agent procedures (SOPs) that tie skills + agents into a larger
  workflow; same portable tier, read directly by any cross-runtime agent
- `context/` — your custom always-on context files

## Skill categories & conventions

Skills live in real category folders. Stable numbers — **never renumber**; reserved categories
(`03-communication`, `04-project-management`, `05-development`, `06-design`, `07-authoring`) get a
folder only when first used.

| Category | Kit skills |
|---|---|
| `01-foundations/` | `vault-init`, `obsidian-setup`, `profile-build`, `pokevault-update` |
| `02-research/` | `research-init`, `research-promote` |
| `08-knowledge/` | `wiki-ingest`, `wiki-lint`, `daily-note` |

Conventions: `{area}-{action}` naming; file name == skill `name:` == wired `.claude/skills/<name>/`
folder; `version` (semver) lives in frontmatter, never in file or folder names; `category:` must
equal the folder the skill lives in. **Categories organize the source tree only — they do NOT
propagate to runtimes.** The bootstrap flattens every skill to `.claude/skills/<name>/SKILL.md`.

## Relationship to the shipped kit

The PokeVault kit ships its reference skills in the package's top-level `skills/<NN-category>/`
folders; the bootstrap installs them here (categorized) and wires the flat runtime bindings.
Copy any of them elsewhere in `toolkit/` to customize — your copies are never overwritten by a
PokeVault update (kit-owned files in the category folders are resynced by the bootstrap).

## Distribution

`toolkit/` is private to you. It is not shared; updates only add structure and resync kit-owned
skill files — your own additions are never touched.
