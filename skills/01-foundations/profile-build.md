---
name: profile-build
version: "1.0.0"
category: 01-foundations
description: "Interview the user to fill in the second-brain cognitive-fingerprint files (identity, voice, preferences, goals, relationships, projects, patterns) so assistants can personalize responses."
trigger: "build my profile"
when_to_use: "Soon after setup, and whenever your role, voice, goals, or priorities shift."
inputs: []
harness_notes: "Conversational. One topic at a time. Append-only on re-runs — never wipe prior profile content."
---

## profile-build

Populates `second-brain/profile/*.md`. These files are read by assistants to write in your voice
and align to your goals. They are **static identity**, not accumulated knowledge (that's the wiki).

### Approach
- Ask about one file at a time; keep it short. Don't interrogate.
- Write concise, declarative statements (not transcripts).
- Preserve the frontmatter; update `modified`.
- On re-run, **append/refine** — never delete what's there.

### Files
| File | Ask about |
|---|---|
| `identity.md` | Name, role, focus areas, scope |
| `voice.md` | Tone, formality, words to prefer/avoid, sentence style |
| `preferences.md` | Tools, formats, working defaults |
| `goals.md` | Personal + professional goals (with rough horizons) |
| `relationships.md` | Key people and how you work with them (personal context) |
| `projects.md` | Active projects/initiatives at a glance |
| `patterns.md` | Decision frameworks + recurring patterns (also auto-fed by cognitive extraction) |

### Privacy
The profile lives in `second-brain/` and is never shared. Keep sensitive personal context here, not
in shared entity pages.
