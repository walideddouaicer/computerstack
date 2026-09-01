# ~/.config/zsh/aliases.zsh

# ── modern replacements ──────────────────────────────────────────────────────
alias ls='eza --group-directories-first --icons'
alias ll='eza -lh --group-directories-first --icons --git'
alias la='eza -lah --group-directories-first --icons --git'
alias lt='eza --tree --level=2 --icons --ignore-glob=".git|node_modules|__pycache__"'
alias cat='bat --paging=never'
alias catp='bat -p --paging=never'          # plain, for piping
alias grep='rg'
alias find='fd'
alias du='du -h'
alias df='df -h'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkcd='_mkcd(){ mkdir -p "$1" && cd "$1"; }; _mkcd'

# ── git ──────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -v'
alias gca='git commit -v --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull --rebase'
alias gb='git branch'
alias lg='lazygit'
# fuzzy branch switch
alias gbf='git switch $(git branch --format="%(refname:short)" | fzf)'
# worktree helper: gwt <branch> -> ../<repo>-<branch>, for parallel agent work
gwt() {
  local b="$1"
  local root; root="$(git rev-parse --show-toplevel)"
  git worktree add "../$(basename "$root")-$b" -b "$b" 2>/dev/null \
    || git worktree add "../$(basename "$root")-$b" "$b"
  cd "../$(basename "$root")-$b" || return
}

# ── docker ───────────────────────────────────────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias lzd='lazydocker'
alias dprune='docker system prune -af --volumes'   # careful: nukes unused volumes

# ── python / ml ──────────────────────────────────────────────────────────────
alias py='python'
alias uvr='uv run'
alias uvs='uv sync'
alias uva='uv add'
alias jl='uv run jupyter lab --no-browser'
alias nb='uv run jupyter lab --no-browser'
# new uv project with the usual dev deps
pynew() {
  uv init "$1" && cd "$1" && uv add --dev ruff pytest ipykernel
}

# ── agents ───────────────────────────────────────────────────────────────────
alias cl='claude'
alias clc='claude --continue'
alias clr='claude --resume'
alias clp='claude -p'                        # one-shot, prints and exits

# ── tmux ─────────────────────────────────────────────────────────────────────
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'

# ── navigation ───────────────────────────────────────────────────────────────
alias dev='cd "$DEV"'
alias stack='cd "$DEV/computerstack"'
# fuzzy-jump to any project under ~/dev
p() {
  local dir
  dir=$(fd -t d -d 2 . "$DEV" | fzf --preview 'eza -l --icons {}') || return
  cd "$dir"
}

# ── misc ─────────────────────────────────────────────────────────────────────
alias reload='exec zsh'
alias path='echo -e ${PATH//:/\\n}'
# ss on linux, lsof on macos. this repo has to survive the move.
if command -v ss >/dev/null 2>&1; then
  alias ports='ss -tulpn'
else
  alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
fi
alias myip='curl -s ifconfig.me'
alias weather='curl -s wttr.in?format=3'
alias serve='python -m http.server 8000'
