==============================================================================
 PokeVault  -  a portable "Second Brain + LLM Wiki" you carry to any machine
 Version 1.1.0
==============================================================================

WHAT IT IS
------------------------------------------------------------------------------
Clone it, run one script, open it in Obsidian, and point any AI assistant at
AGENTS.md. Raw material you collect gets compiled into persistent, interlinked
notes that compound over time. Plain Markdown - no database, no server, no
accounts, no lock-in. Works with Claude Code, Cursor, Codex, Gemini CLI, Aider,
a local LLM, or a desktop AI app.

The idea in one line: compile raw sources into a living Markdown wiki ONCE;
query the wiki, not the pile; never overwrite, never forget.


INSTALL (about 60 seconds)
------------------------------------------------------------------------------
1. GET IT
   Clone (recommended - easiest to update later):
     git clone https://github.com/taurran/pokevault.git && cd pokevault
   Or download the ZIP (no git needed) and extract it:
     https://github.com/taurran/pokevault/archive/refs/heads/master.zip

2. RUN THE BOOTSTRAP  (installs the vault into a local folder + wires skills;
   safe and idempotent - re-run anytime; asks where to install)
   macOS / Linux:   ./bootstrap.sh
   Windows:         .\bootstrap.ps1
     (if blocked "not digitally signed", first run this once for the session:
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force)
   Custom path:     ./bootstrap.sh ~/Knowledge
                    .\bootstrap.ps1 -VaultRoot D:\Vaults\PokeVault
   The bootstrap prints the final vault path on completion - point Obsidian
   at it.

   OR LET YOUR AI AGENT RUN IT - point your assistant at this folder and paste:
     "Run the PokeVault bootstrap in this folder: execute ./bootstrap.sh (macOS/Linux)
      or .\bootstrap.ps1 (Windows) to install the vault to ~/PokeVault and wire its skills.
      Then open ~/PokeVault, read AGENTS.md, and tell me when it's ready."

   Default vault location:
     macOS    /Users/<you>/PokeVault
     Linux    /home/<you>/PokeVault
     Windows  C:\PokeVault

3. OPEN IN OBSIDIAN
   Don't have Obsidian? Download it free (official): https://obsidian.md/download
   Launch Obsidian -> "Open folder as vault" -> select your vault folder.
   The shipped .obsidian/ config applies automatically. Then install the
   recommended community plugins: Dataview, Templater, Tag Wrangler,
   Periodic Notes (or run the "obsidian-setup" skill).

4. PERSONALIZE
   Replace [OWNER] and [INSTALL_DATE] in AGENTS.md and second-brain/profile/*,
   or tell your assistant "build my profile" and "initialize my vault".

   Full walkthrough (sync/backup, updates, troubleshooting): see INSTALL.md


WHAT THE BOOTSTRAP DOES
------------------------------------------------------------------------------
1. Copies vault/ to ~/PokeVault (skips if one exists - never clobbers your data).
2. Installs skills to ~/PokeVault/toolkit/skills/<name>.md (tool-neutral source).
3. Generates Claude Code bindings at ~/PokeVault/.claude/skills/<name>/SKILL.md.
4. Confirms the engine (AGENTS.md) and per-tool pointers are in place.


CONNECT YOUR AI ASSISTANT  (same schema everywhere; only the entry file differs)
------------------------------------------------------------------------------
Claude Code .................. open the vault; reads CLAUDE.md -> AGENTS.md;
                               skills auto-load from .claude/skills/
Codex / Cursor / Gemini /
  Aider / Windsurf / Zed ..... open the vault; they read AGENTS.md natively;
                               skill list + triggers are in AGENTS.md section 11
Local LLM / desktop AI app ... add the vault as an indexed folder; tell it to
                               read AGENTS.md first

FIRST TEST
   1. Put a .md file into  second-brain/wiki/raw/inbox/
   2. Say: "Read AGENTS.md and process my second-brain inbox."
   3. It creates pages/, updates index.md, appends log.md, and moves the
      source to raw/processed/.


THE FOUR ZONES
------------------------------------------------------------------------------
second-brain/  your self-model (profile/) + personal knowledge wiki
work/          projects, deliverables, records + work knowledge wiki
personal/      life management - people (CRM), areas, goals, calendar + a personal-life wiki
toolkit/       your own skills, agents, context

One shared daily/ note is the front door: capture freely, your assistant routes
each note to the right zone (anything ambiguous goes to daily/review.md for
one-tap reclassification). daily/index.md is the scannable journal index.
research/ is the investigation workshop - one folder per project - where
findings are promoted into the wiki when ready.


THE GUARANTEE
------------------------------------------------------------------------------
Seven anti-forgetting rules (AGENTS.md section 4): append don't rewrite, verify
against sources, search before create, flag contradictions, provenance on every
claim, one canonical page per entity, raw is immutable. Every future update
deploys INTO your vault without touching your data.


REQUIREMENTS
------------------------------------------------------------------------------
- Obsidian (free) - the primary surface - download: https://obsidian.md/download
- An AI assistant with filesystem access
- bash (macOS/Linux) or PowerShell (Windows) to run the bootstrap


CLEAN-ROOM NOTE
------------------------------------------------------------------------------
PokeVault is an independent, clean-room project: plain-Markdown conventions and
public patterns only - no proprietary code or content, no vendor lock-in.


CREDITS
------------------------------------------------------------------------------
Builds on public patterns: the LLM Wiki pattern (Andrej Karpathy), Obsidian
(Daily/Periodic Notes, Dataview), PARA (Tiago Forte), and three ingest patterns
from OB1 / Open Brain (Nate B. Jones, FSL-1.1-MIT) - implemented from scratch,
no code vendored. See docs/02 Research Appendix.

License: Apache-2.0 (see LICENSE).
==============================================================================
