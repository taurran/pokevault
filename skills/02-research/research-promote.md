---
name: research-promote
version: "1.0.0"
category: 02-research
description: "Compile a ready research finding or a vault:promote-tagged item into the curated wiki, with full provenance. Frontmatter-driven."
trigger: "promote research"
when_to_use: "A finding has status: ready, user asks to promote, or a research loop just completed. Also responds to 'promote this'."
harness_notes: "Honors vault:promote control tag. Pure prompt-driven; requires file read/write. Never auto-promotes."
---

## research-promote

Mirrors `AGENTS.md` §8 (Promotion). Read it before running.

### Steps

1. **Find eligible items.** Scan `research/**/findings.md` (or any file) for:
   - `status: ready` OR carrying a `vault:promote` tag,
   - AND non-empty `sources:` list.

   For `projects/` items: consider ONLY when the user explicitly asks (never auto-walk `projects/`).

2. **Route to target wiki.** Use the item's `promote_target` if set; otherwise infer per
   AGENTS §2 Step 4 (personal → `second-brain/wiki`, work → `work/wiki`). When unsure, ask.

3. **Search before create** (AGENTS §4 rule 3). Check the target wiki's `index.md` and
   `pages/` for an existing page on the same topic. Update it if found; create a new page in
   the appropriate `pages/` subfolder otherwise.

4. **Write the wiki page.** Full §5 frontmatter PLUS `promoted_from: "<workshop path>"`.
   The page's `sources:` cite the workshop file.

5. **Flip the workshop file.** Set `status: promoted` and
   `promoted_to: "[[<wiki-page>]]"` — one canonical home (anti-forgetting rule 6). The
   workshop copy becomes a pointer, not a duplicate.

6. **Update ledger.** Append a line to the target wiki's `log.md`; update its `index.md`.

7. **At research-loop completion.** If invoked after presenting research results, first
   PRESENT the findings and explicitly ASK:
   > "Promote these to your wiki? (target: \<zone\>)"

   Promote only on user confirmation (or if `vault:promote` is already set).

### Guardrails

- Never compile `notes/` (WIP content).
- Never auto-promote — always require explicit user confirmation or a pre-set `vault:promote` tag.
- Never auto-walk `projects/` — promote project items only on explicit request.
- Require non-empty `sources:` before promoting (no provenance = no promotion).
