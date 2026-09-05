# Links this repo's claude/ folder into ~/.claude so Claude Code reads it on Windows.
#
#   powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1
#   powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1 -DryRun
#
# This is the Windows stand-in for what bootstrap.sh does on Ubuntu.
# Symlinks mean there is no sync step: you edit the repo, Claude Code sees it instantly.
#
# Symlinks need EITHER Developer Mode on (Settings > System > For developers)
# OR an Administrator PowerShell. If both fail, pass -Copy to fall back to copying.

param(
    [switch]$DryRun,
    [switch]$Copy
)

$ErrorActionPreference = "Stop"

$RepoClaude = Join-Path (Split-Path $PSScriptRoot -Parent) "claude"
$TargetRoot = Join-Path $env:USERPROFILE ".claude"

if (-not (Test-Path $RepoClaude)) {
    Write-Host "ERROR: can't find $RepoClaude" -ForegroundColor Red
    exit 1
}

Write-Host "source: $RepoClaude"
Write-Host "target: $TargetRoot"
Write-Host ""

if (-not (Test-Path $TargetRoot)) {
    if (-not $DryRun) { New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null }
    Write-Host "  created $TargetRoot" -ForegroundColor Green
}

# Check ONCE whether symlinks are possible, before touching anything.
# The old behaviour degraded to a copy per file and printed the same warning
# 17 times, which reads like 17 problems instead of one setting.
if (-not $Copy) {
    $probe = Join-Path $env:TEMP "cs-symlink-probe-$(Get-Random)"
    try {
        New-Item -ItemType SymbolicLink -Path $probe -Target $RepoClaude -ErrorAction Stop | Out-Null
        Remove-Item $probe -Force
    } catch {
        Write-Host "  Symlinks are not available, so this would COPY every file instead." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Copies mean editing the repo does NOT update what Claude Code reads." -ForegroundColor Yellow
        Write-Host "  You would have to re-run this script after every change." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Fix it once:  Settings > System > For developers > Developer Mode: On" -ForegroundColor Cyan
        Write-Host "  Then open a new terminal and run this again." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Or, to copy anyway and accept the re-run step:" -ForegroundColor DarkGray
        Write-Host "     powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1 -Copy" -ForegroundColor DarkGray
        Write-Host ""
        exit 1
    }
}

# design-agent is its own repo and is gitignored here, so a fresh clone won't have it
$DesignAgent = Join-Path $RepoClaude "skills\design-agent"
if (Test-Path (Join-Path $DesignAgent ".git")) {
    if (-not $DryRun) { git -C $DesignAgent pull --ff-only | Out-Null }
    Write-Host "  design-agent up to date" -ForegroundColor Green
} elseif (Get-Command git -ErrorAction SilentlyContinue) {
    if (-not $DryRun) {
        git clone https://github.com/walideddouaicer/design_agent.git $DesignAgent | Out-Null
    }
    Write-Host "  design-agent cloned" -ForegroundColor Green
} else {
    Write-Host "  git not found, skipping design-agent" -ForegroundColor Yellow
}

function Link-One($src, $dst, $label) {
    if ($DryRun) { Write-Host "  would link $label"; return }

    if (Test-Path $dst) {
        $existing = Get-Item $dst -Force
        if ($existing.LinkType) {
            Remove-Item $dst -Force -Recurse
        } else {
            $backup = "$dst.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $dst $backup
            Write-Host "  backed up existing $label" -ForegroundColor Yellow
        }
    }

    if ($Copy) {
        Copy-Item $src $dst -Recurse -Force
        Write-Host "  copied $label" -ForegroundColor Green
        return
    }
    try {
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
        Write-Host "  linked $label" -ForegroundColor Green
    } catch {
        Write-Host "  symlink failed for $label, falling back to copy" -ForegroundColor Yellow
        Write-Host "  (turn on Developer Mode to get real links)" -ForegroundColor DarkGray
        Copy-Item $src $dst -Recurse -Force
        Write-Host "  copied $label" -ForegroundColor Green
    }
}

# Top-level files
foreach ($item in @("CLAUDE.md", "how-i-learn.md", "settings.json")) {
    $src = Join-Path $RepoClaude $item
    if (Test-Path $src) { Link-One $src (Join-Path $TargetRoot $item) $item }
}

# skills / commands / agents: link the CONTENTS, never the directory itself.
# Other tools drop their own files into these folders (Omarchy installs a skill
# into ~/.claude/skills). If the folder were a symlink into this repo, their
# files would land inside our git tree, or fail outright.
# Trade-off: re-run this script after adding a new skill.
foreach ($group in @("agents", "commands", "skills")) {
    $groupSrc = Join-Path $RepoClaude $group
    if (-not (Test-Path $groupSrc)) { continue }

    $groupDst = Join-Path $TargetRoot $group
    if ((Test-Path $groupDst) -and (Get-Item $groupDst -Force).LinkType) {
        if (-not $DryRun) { Remove-Item $groupDst -Force -Recurse }
        Write-Host "  replaced the old whole-directory symlink for $group" -ForegroundColor Yellow
    }
    if (-not $DryRun -and -not (Test-Path $groupDst)) {
        New-Item -ItemType Directory -Path $groupDst -Force | Out-Null
    }

    foreach ($child in Get-ChildItem $groupSrc) {
        Link-One $child.FullName (Join-Path $groupDst $child.Name) "$group\$($child.Name)"
    }
}

Write-Host ""
Write-Host "done." -ForegroundColor Green
Write-Host ""
Write-Host "  verify:  claude doctor"
Write-Host "  start:   cd <a project>  then  claude"
Write-Host ""
Write-Host "  If it copied instead of linked, re-run this script after editing the repo." -ForegroundColor DarkGray
