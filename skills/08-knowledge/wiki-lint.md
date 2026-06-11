---
name: wiki-lint
version: "1.0.0"
category: 08-knowledge
description: "Run health checks on a zone's wiki: orphans, stale index entries, broken wikilinks, near-duplicates, unresolved contradictions, pending backlog, low-confidence aging, consolidation candidates."
trigger: "lint my wiki"
when_to_use: "Periodically — after ~10 ingests or monthly. Also before a big query session."
inputs:
  - name: zone
    description: "second-brain, work, or personal."
    required: false
harness_notes: "Read-only analysis plus optional safe auto-fixes (stale index entries, missing frontmatter). Anything lossy goes to review.md for human decision."
---

## wiki-lint

Follows `AGENTS.md` §7. Read it first.

### Checks
| Check | Action |
|---|---|
| Orphan pages (no inbound `[[links]]`) | Flag; suggest links or archive |
| Stale index entries | Remove from `index.md` |
| Broken wikilinks | Flag; suggest create/fix |
| Near-duplicates (>80% title overlap or shared sources) | Flag for merge in `review.md` |
| Unresolved `⚠️ Contradiction` blocks | Surface in `review.md` |
| Pending backlog (older than config `pending_backlog_warn_days`) | Warn |
| Low-confidence pages aging (config `low_confidence_review_days`) | Suggest corroboration |
| Missing required frontmatter | Auto-fix where safe |
| Consolidation candidates (5+ update sections) | Flag (consolidation needs approval + diff log) |
| Source in `raw/processed/` with no manifest entry | Flag (moved without an ingest record) |
| Daily note missing a line in `daily/index.md` | Add the one-line summary |
| `daily/review.md` items aging (unresolved default-routings) | Warn; nudge reclassification |
| Ready-to-promote research finding (`status: ready` or `vault:promote` tag, not yet promoted) or `projects/` item tagged `vault:promote` not yet promoted | Flag "ready to promote (run research-promote)" |
| Stale research project (`status: active`, no `modified` update in N days) | Flag as stale; suggest pause or archive |

### Output
Append `## [YYYY-MM-DD] lint | N issues found, M auto-fixed` to `log.md`. Route human-decision items
to `review.md`. Never delete pages — archive only.
