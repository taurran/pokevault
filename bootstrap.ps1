# PokeVault bootstrap (Windows PowerShell)
# Installs the vault and wires its skills into your coding agent(s).
#
#   .\bootstrap.ps1 [-VaultRoot <path>]   # default: C:\PokeVault
#
# Safe + idempotent: never overwrites your knowledge. Re-run anytime to resync skills.
#
# If PowerShell blocks this ("not digitally signed"), allow scripts for THIS session only:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
param(
  [string]$VaultRoot
)
$ErrorActionPreference = 'Stop'
$Pkg = Split-Path -Parent $MyInvocation.MyCommand.Path
# Default to a LOCAL drive-root folder, deliberately NOT under %USERPROFILE%\Documents
# (which is often redirected into OneDrive — two sync engines on one vault cause conflicts).
$DefaultVault = Join-Path $env:SystemDrive 'PokeVault'

Write-Host "PokeVault bootstrap"
Write-Host "  package : $Pkg`n"

# Choose the install location. -VaultRoot always wins. Otherwise, when run interactively,
# offer the default and accept a custom path (press Enter to accept). Obsidian later holds
# the pointer to whatever path you choose here.
if (-not $VaultRoot) {
  $VaultRoot = $DefaultVault
  try {
    if ([Environment]::UserInteractive) {
      $reply = Read-Host "Install the vault where? (Enter = $DefaultVault)"
      if (-not [string]::IsNullOrWhiteSpace($reply)) { $VaultRoot = $reply }
    }
  } catch { }
}
Write-Host "  vault   : $VaultRoot`n"

# 1) Place the vault on first run; never clobber an existing one.
#    Default location: C:\PokeVault
if (-not (Test-Path $VaultRoot)) {
  if (Test-Path (Join-Path $Pkg 'vault')) {
    Write-Host "-> creating vault at $VaultRoot"
    $parent = Split-Path -Parent $VaultRoot
    if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item -Recurse (Join-Path $Pkg 'vault') $VaultRoot
  } else {
    Write-Error "no vault\ in package and no existing $VaultRoot - aborting"; exit 2
  }
} else {
  Write-Host "-> vault exists; leaving your content untouched (adding skills + agent bindings only)"
}

# 2) Canonical, tool-neutral home for the kit's skills: toolkit\skills\
$toolkitSkills = Join-Path $VaultRoot 'toolkit\skills'
New-Item -ItemType Directory -Force -Path $toolkitSkills | Out-Null
$pkgSkills = Join-Path $Pkg 'skills'
if (Test-Path $pkgSkills) {
  Write-Host "-> installing kit skills into toolkit\skills\"
  Get-ChildItem -Path $pkgSkills -Filter *.md | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $toolkitSkills $_.Name) -Force
  }
}

# 3) Generate Agent-Skills bindings for Claude Code: .claude\skills\<name>\SKILL.md
Write-Host "-> wiring Claude Code skills -> .claude\skills\<name>\SKILL.md"
$claudeSkills = Join-Path $VaultRoot '.claude\skills'
New-Item -ItemType Directory -Force -Path $claudeSkills | Out-Null
$count = 0
Get-ChildItem -Path $toolkitSkills -Filter *.md | ForEach-Object {
  $name = $_.BaseName
  $dir = Join-Path $claudeSkills $name
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  Copy-Item $_.FullName (Join-Path $dir 'SKILL.md') -Force
  $count++
}
Write-Host "  $count skill(s) wired"

# 4) Sanity-check the engine + per-tool pointers.
Write-Host "-> engine + pointers:"
foreach ($p in @('AGENTS.md','CLAUDE.md','.cursorrules')) {
  if (Test-Path (Join-Path $VaultRoot $p)) { Write-Host "  OK  $p" } else { Write-Host "  !!  missing $p" }
}

Write-Host @"

Vault installed at: $VaultRoot
  -> Open THIS folder in Obsidian (Open folder as vault). Obsidian will remember it.

Next steps:
  - Claude Code : open "$VaultRoot" - reads CLAUDE.md -> AGENTS.md; skills auto-load from .claude\skills\
  - Codex/Cursor/Gemini/Aider : open "$VaultRoot" - read AGENTS.md natively; skills listed in AGENTS.md section 11
  - Any assistant : "Read AGENTS.md and follow it." Run a skill manually: "Read toolkit\skills\<name>.md and follow it."
  - Finish Obsidian : run the 'obsidian-setup' skill.

Re-run this script anytime to resync skills after an update.
"@
