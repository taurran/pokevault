---
name: daily-note
version: "1.0.0"
category: 08-knowledge
description: "Create or open the single daily note (work + personal), and at end-of-day route its captures to the right zones (CRM, areas, goals, calendar, wiki)."
trigger: "open today's note"
when_to_use: "Start of day to capture; end of day (or weekly) to harvest captures into the wiki."
inputs: []
harness_notes: "Obsidian's core Daily Notes already creates the note from the template on hotkey. This skill covers the assistant-driven capture-harvest flow that is not yet automated."
---

## daily-note

The daily note is your low-friction capture surface for **both work and personal** — the **front
door / inbox**: capture with zero filing friction, and synthesis routes each fragment to the right
zone later. The note is a **source**, not a wiki page — it stays in `daily/` as the dated record.
Full design: `docs/02-llm-wiki-synthesis-and-daily-notes.md` Part 3.

### Create / open
- Obsidian: trigger core Daily Notes (it uses `daily/_templates/daily.md`).
- Manual: create `daily/YYYY-MM-DD.md` from the template; fill Focus / Tasks / Log / Capture.

### Harvest & route (end of day or weekly review)
Read the day's **Capture** + **Log** and route each item per `AGENTS.md` §1 "The single daily note":
1. **People** → create/update `personal/people/<name>.md` (CRM).
2. **Areas / goals / dates** → `personal/areas | goals | calendar/`.
3. **Work** items → `work/wiki/` (via `wiki-ingest`).
4. **Durable knowledge** → `second-brain/wiki/` (via `wiki-ingest`).
5. **Reflections** → append to `second-brain/profile/patterns.md` (cognitive extraction, AGENTS.md §8).
6. **Ambiguous?** Default-route it to the best-guess zone (never strand or lose it) and log the
   decision in `daily/review.md` for one-tap reclassification. Never block; never silently misroute.

Leave the daily note intact as the dated record; optionally check off routed items. Then add a
one-line summary of the day to `daily/index.md` (powers journal pattern detection).

### Future
A scheduled assistant will do the harvest automatically (auto-capture pattern). Deferred until the
ingest skills are hardened so automation never outruns the trust rails.
