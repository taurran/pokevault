#!/usr/bin/env bash
# PokeVault bootstrap (macOS / Linux)
# Installs the vault and wires its skills into your coding agent(s).
#
#   ./bootstrap.sh [VAULT_ROOT]     # default: ~/PokeVault
#
# Safe + idempotent: never overwrites your knowledge. Re-run anytime to resync skills.
set -euo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Default to ~/PokeVault (home dir — NOT ~/Documents or ~/Desktop, which can be iCloud-synced).
DEFAULT_VAULT="$HOME/PokeVault"
VAULT="${1:-}"

echo "PokeVault bootstrap"
echo "  package : $PKG"
echo

# Choose the install location. An explicit argument always wins. Otherwise, when run
# interactively, offer the default and accept a custom path (press Enter to accept).
# Obsidian later holds the pointer to whatever path you choose here.
if [ -z "$VAULT" ]; then
  if [ -t 0 ]; then
    printf 'Install the vault where? (Enter = %s)\n> ' "$DEFAULT_VAULT"
    read -r reply || reply=""
    VAULT="${reply:-$DEFAULT_VAULT}"
  else
    VAULT="$DEFAULT_VAULT"
  fi
fi
# Expand a leading ~ if the user typed one.
VAULT="${VAULT/#\~/$HOME}"

echo "  vault   : $VAULT"
echo

# 1) Place the vault on first run; never clobber an existing one.
#    Default location: ~/PokeVault  (macOS: /Users/<you>/PokeVault, Linux: /home/<you>/PokeVault)
if [ ! -d "$VAULT" ]; then
  if [ -d "$PKG/vault" ]; then
    echo "→ creating vault at $VAULT"
    mkdir -p "$(dirname "$VAULT")"
    cp -R "$PKG/vault" "$VAULT"
  else
    echo "!! no vault/ in package and no existing $VAULT — aborting"; exit 2
  fi
else
  echo "→ vault exists; leaving your content untouched (adding skills + agent bindings only)"
fi

# 2) Canonical, tool-neutral home for the kit's skills: toolkit/skills/
mkdir -p "$VAULT/toolkit/skills"
if [ -d "$PKG/skills" ]; then
  echo "→ installing kit skills into toolkit/skills/"
  for f in "$PKG"/skills/*.md; do
    [ -e "$f" ] || continue
    cp "$f" "$VAULT/toolkit/skills/$(basename "$f")"
  done
fi

# 3) Generate Agent-Skills bindings for Claude Code: .claude/skills/<name>/SKILL.md
#    (open Agent Skills standard: a folder per skill containing SKILL.md)
echo "→ wiring Claude Code skills → .claude/skills/<name>/SKILL.md"
mkdir -p "$VAULT/.claude/skills"
count=0
for f in "$VAULT"/toolkit/skills/*.md; do
  [ -e "$f" ] || continue
  name="$(basename "$f" .md)"
  mkdir -p "$VAULT/.claude/skills/$name"
  cp "$f" "$VAULT/.claude/skills/$name/SKILL.md"
  count=$((count+1))
done
echo "  ✓ $count skill(s) wired"

# Optional: mirror to the vendor-neutral .agents/skills/ location (other tools).
# Uncomment if your agent reads .agents/skills/ instead of .claude/skills/:
# mkdir -p "$VAULT/.agents/skills"
# for f in "$VAULT"/toolkit/skills/*.md; do n="$(basename "$f" .md)"; mkdir -p "$VAULT/.agents/skills/$n"; cp "$f" "$VAULT/.agents/skills/$n/SKILL.md"; done

# 4) Sanity-check the engine + per-tool pointers.
echo "→ engine + pointers:"
for p in AGENTS.md CLAUDE.md .cursorrules; do
  if [ -e "$VAULT/$p" ]; then echo "  ✓ $p"; else echo "  ⚠ missing $p"; fi
done

cat <<EOF

Vault installed at: $VAULT
  → Open THIS folder in Obsidian (Open folder as vault). Obsidian will remember it.

Next steps:
  • Claude Code        : open "$VAULT" — reads CLAUDE.md → AGENTS.md; skills auto-load from .claude/skills/
  • Codex / Cursor /
    Gemini / Aider …   : open "$VAULT" — they read AGENTS.md natively; skills are listed in AGENTS.md §11
  • Any assistant      : "Read AGENTS.md and follow it." To run a skill without a skills-aware tool:
                         "Read toolkit/skills/<name>.md and follow it."
  • Finish Obsidian    : run the 'obsidian-setup' skill (install Dataview/Templater/Tag Wrangler/Periodic Notes)

Re-run this script anytime to resync skills after an update.
EOF
