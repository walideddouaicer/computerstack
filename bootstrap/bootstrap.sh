#!/usr/bin/env bash
# computerstack bootstrap — Ubuntu 24.04 and macOS
#
#   bash bootstrap/bootstrap.sh              # full run
#   bash bootstrap/bootstrap.sh --dry-run    # print what would happen, change nothing
#   bash bootstrap/bootstrap.sh --only cli   # run one phase: system|brew|cli|runtimes|docker|dotfiles|claude
#
# Safe to re-run. Every step checks before it acts.

set -Eeuo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
ONLY=""

# ── plumbing ──────────────────────────────────────────────────────────────────
c_reset=$'\033[0m'; c_blue=$'\033[1;34m'; c_green=$'\033[1;32m'
c_yellow=$'\033[1;33m'; c_red=$'\033[1;31m'; c_dim=$'\033[2m'

log()   { printf '%s==>%s %s\n' "$c_blue" "$c_reset" "$*"; }
ok()    { printf '%s  ok%s %s\n' "$c_green" "$c_reset" "$*"; }
warn()  { printf '%s  !!%s %s\n' "$c_yellow" "$c_reset" "$*"; }
die()   { printf '%s ERR%s %s\n' "$c_red" "$c_reset" "$*" >&2; exit 1; }
skip()  { printf '%s  ~~ %s (already present)%s\n' "$c_dim" "$*" "$c_reset"; }

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '%s  would run:%s %s\n' "$c_dim" "$c_reset" "$*"
  else
    "$@"
  fi
}

have() { command -v "$1" >/dev/null 2>&1; }

phase_enabled() { [[ -z "$ONLY" || "$ONLY" == "$1" ]]; }

trap 'die "failed at line $LINENO — nothing further was run"' ERR

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --only)    ONLY="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) die "unknown flag: $1" ;;
  esac
done

# ── detect platform ───────────────────────────────────────────────────────────
case "$(uname -s)" in
  Linux)  OS=linux ;;
  Darwin) OS=macos ;;
  *) die "unsupported OS: $(uname -s)" ;;
esac

if [[ $OS == linux ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  warn "WSL detected. This repo targets native Linux; most things will still work."
fi

log "platform: $OS   repo: $REPO_DIR   dry-run: $DRY_RUN"

# ── phase: system packages ────────────────────────────────────────────────────
if phase_enabled system; then
  log "phase 1/7 — system packages"
  if [[ $OS == linux ]]; then
    run sudo apt-get update -qq
    run sudo apt-get install -y --no-install-recommends \
      build-essential procps curl file git unzip ca-certificates gnupg \
      pkg-config libssl-dev zsh tlp tlp-rdw fonts-firacode
    # tlp = battery life on ThinkPads; enable it once
    if ! systemctl is-enabled tlp >/dev/null 2>&1; then
      run sudo systemctl enable --now tlp
      ok "tlp enabled (battery life)"
    else
      skip "tlp"
    fi
  else
    if ! xcode-select -p >/dev/null 2>&1; then
      run xcode-select --install
      warn "finish the Xcode CLT install in the GUI, then re-run this script"
      exit 0
    else
      skip "xcode command line tools"
    fi
  fi
fi

# ── phase: homebrew (both platforms, so formula names match) ──────────────────
if phase_enabled brew; then
  log "phase 2/7 — homebrew"
  if ! have brew; then
    if [[ $DRY_RUN -eq 1 ]]; then
      printf '%s  would run:%s homebrew install script\n' "$c_dim" "$c_reset"
    else
      NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  else
    skip "homebrew"
  fi

  # put brew on PATH for the rest of this script, whether it was just installed or not
  for prefix in /home/linuxbrew/.linuxbrew /opt/homebrew /usr/local; do
    if [[ -x "$prefix/bin/brew" ]]; then
      eval "$("$prefix/bin/brew" shellenv)"
      break
    fi
  done

  have brew && run brew update || true
fi

# ── phase: cli toolbelt ───────────────────────────────────────────────────────
if phase_enabled cli; then
  log "phase 3/7 — cli toolbelt"
  BREW_PKGS=(
    starship tmux fzf zoxide atuin
    eza bat fd ripgrep sd git-delta jq yq tree
    gh lazygit lazydocker
    shellcheck shfmt
    ruff                 # the format-on-write hook calls this bare, it must be global
    mise duckdb
    zsh-autosuggestions zsh-syntax-highlighting
  )
  if have brew; then
    for pkg in "${BREW_PKGS[@]}"; do
      if brew list --formula "$pkg" >/dev/null 2>&1; then
        skip "$pkg"
      else
        run brew install "$pkg"
      fi
    done
  else
    warn "brew missing — skipping toolbelt (run: bootstrap.sh --only brew)"
  fi

  # wezterm ships outside core brew on Linux
  if ! have wezterm; then
    if [[ $OS == macos ]]; then
      run brew install --cask wezterm
    else
      log "installing wezterm (apt repo)"
      run bash -c 'curl -fsSL https://apt.fury.io/wez/gpg.key \
        | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg'
      run bash -c 'echo "deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" \
        | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null'
      run sudo apt-get update -qq
      run sudo apt-get install -y wezterm
    fi
  else
    skip "wezterm"
  fi
fi

# ── phase: language runtimes ──────────────────────────────────────────────────
if phase_enabled runtimes; then
  log "phase 4/7 — runtimes"
  # mise picks the PYTHON. uv picks the LIBRARIES.
  if have mise; then
    run mise use -g python@3.12
    run mise use -g node@lts     # for the full-stack side
    ok "mise: python 3.12, node lts"
  else
    warn "mise missing — skipping"
  fi

  if ! have uv; then
    run bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
  else
    skip "uv"
  fi
fi

# ── phase: docker ─────────────────────────────────────────────────────────────
if phase_enabled docker; then
  log "phase 5/7 — docker"
  if have docker; then
    skip "docker"
  elif [[ $OS == linux ]]; then
    run sudo install -m 0755 -d /etc/apt/keyrings
    run bash -c 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg'
    run sudo chmod a+r /etc/apt/keyrings/docker.gpg
    run bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null'
    run sudo apt-get update -qq
    run sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin
    run sudo usermod -aG docker "$(id -un)"
    warn "log out and back in before 'docker' works without sudo"
  else
    warn "macOS: install OrbStack manually (brew install --cask orbstack) — faster than Docker Desktop"
  fi
fi

# ── phase: dotfiles ───────────────────────────────────────────────────────────
if phase_enabled dotfiles; then
  log "phase 6/7 — dotfiles"
  DOT="$REPO_DIR/dotfiles"
  link() {  # link <source> <target>
    local src="$1" dst="$2"
    run mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" ]]; then
      run rm "$dst"
    elif [[ -e "$dst" ]]; then
      run mv "$dst" "$dst.bak.$(date +%s)"
      warn "backed up existing $dst"
    fi
    run ln -s "$src" "$dst"
    ok "linked $(basename "$dst")"
  }
  link "$DOT/wezterm/wezterm.lua"   "$HOME/.config/wezterm/wezterm.lua"
  link "$DOT/starship/starship.toml" "$HOME/.config/starship.toml"
  link "$DOT/tmux/tmux.conf"        "$HOME/.config/tmux/tmux.conf"
  link "$DOT/zsh/zshrc"             "$HOME/.zshrc"
  link "$DOT/zsh/aliases.zsh"       "$HOME/.config/zsh/aliases.zsh"
  link "$DOT/git/gitconfig"         "$HOME/.gitconfig"
  link "$DOT/mise/config.toml"      "$HOME/.config/mise/config.toml"

  # crew launcher on PATH
  run mkdir -p "$HOME/.local/bin"
  run chmod +x "$REPO_DIR/bootstrap/crew"
  [[ -L "$HOME/.local/bin/crew" ]] && run rm "$HOME/.local/bin/crew"
  run ln -sf "$REPO_DIR/bootstrap/crew" "$HOME/.local/bin/crew"
  ok "linked crew launcher"

  # project tree
  run mkdir -p "$HOME/dev"

  if ! have zsh; then
    warn "zsh not installed — skipping default-shell change"
  elif [[ "${SHELL:-}" == *zsh ]]; then
    skip "zsh is already the default shell"
  else
    run sudo chsh -s "$(command -v zsh)" "$(id -un)"
    warn "default shell set to zsh — takes effect at next login"
  fi
fi

# ── phase: the crew ───────────────────────────────────────────────────────────
if phase_enabled claude; then
  log "phase 7/7 — claude agent layer"
  if ! have claude; then
    run bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
  else
    skip "claude code"
  fi
  # design-agent is its own repo, gitignored here, so a fresh clone won't have it
  DA="$REPO_DIR/claude/skills/design-agent"
  if ! have git; then
    warn "git not installed, skipping design-agent (run the system phase first)"
  elif [[ -d "$DA/.git" ]]; then
    run git -C "$DA" pull --ff-only
    ok "design-agent up to date"
  else
    run git clone https://github.com/walideddouaicer/design_agent.git "$DA"
    ok "design-agent cloned"
  fi

  run mkdir -p "$HOME/.claude"
  for item in CLAUDE.md how-i-learn.md settings.json agents commands skills; do
    src="$REPO_DIR/claude/$item"
    dst="$HOME/.claude/$item"
    [[ -e "$src" ]] || continue
    if [[ -L "$dst" ]]; then run rm "$dst"
    elif [[ -e "$dst" ]]; then run mv "$dst" "$dst.bak.$(date +%s)"; fi
    run ln -s "$src" "$dst"
    ok "linked ~/.claude/$item"
  done
fi

printf '\n%s all done%s\n' "$c_green" "$c_reset"
cat <<'NEXT'

  next:
    1. log out and back in   (docker group + zsh default shell)
    2. open WezTerm
    3. tmux                  then prefix is Ctrl-a
    4. crew                  launches the agent workspace layout
    5. cd ~/dev/<project> && claude

NEXT
