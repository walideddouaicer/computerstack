# Links this repo's claude/ folder into ~/.claude so Claude Code reads it on Windows.
#
#   powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1
#   powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1 -DryRun
#
# This is the Windows stand-in for what bootstrap.sh does on Ubuntu.
# Symlinks mean there's no sync step — you edit the repo, Claude Code sees it instantly.
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

$items = @("CLAUDE.md", "how-i-learn.md", "settings.json", "agents", "commands", "skills")

foreach ($item in $items) {
    $src = Join-Path $RepoClaude $item
    $dst = Join-Path $TargetRoot $item

    if (-not (Test-Path $src)) { continue }

    if ($DryRun) {
        Write-Host "  would link $item"
        continue
    }

    # back up anything real that's already there
    if (Test-Path $dst) {
        $existing = Get-Item $dst -Force
        if ($existing.LinkType) {
            Remove-Item $dst -Force -Recurse
        } else {
            $backup = "$dst.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Move-Item $dst $backup
            Write-Host "  backed up existing $item -> $(Split-Path $backup -Leaf)" -ForegroundColor Yellow
        }
    }

    if ($Copy) {
        Copy-Item $src $dst -Recurse -Force
        Write-Host "  copied $item" -ForegroundColor Green
    } else {
        try {
            New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
            Write-Host "  linked $item" -ForegroundColor Green
        } catch {
            Write-Host "  symlink failed for $item — falling back to copy" -ForegroundColor Yellow
            Write-Host "  (turn on Developer Mode to get real links)" -ForegroundColor DarkGray
            Copy-Item $src $dst -Recurse -Force
            Write-Host "  copied $item" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "done." -ForegroundColor Green
Write-Host ""
Write-Host "  verify:  claude doctor"
Write-Host "  start:   cd <a project>  then  claude"
Write-Host ""
Write-Host "  If it copied instead of linked, re-run this script after editing the repo." -ForegroundColor DarkGray
