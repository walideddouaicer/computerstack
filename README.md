# computerstack

Walid's workstation. One repo that turns a bare machine into the workshop.

> **The one idea:** every decision gets made once, written into a file, and never made
> again. Friction is decisions you re-make every time you open a folder. That's all it is.

Start here → **[docs/recap.md](docs/recap.md)** — the whole picture in one page.

---

## The rule that decides everything

**It must survive the move to the MacBook.**

Linux and macOS share dotfiles, Homebrew, zsh, and `~/.config`. This setup transfers
almost unchanged. That constraint picked the OS, the shell, the terminal, and the tools.

---

## Five layers

```
┌──────────────────────────────────────────────────────────┐
│  L4  AGENTS      CLAUDE.md · skills · commands · scout   │
├──────────────────────────────────────────────────────────┤
│  L3  FOLDERS     ~/dev · ~/.config · ~/.claude           │
├──────────────────────────────────────────────────────────┤
│  L2  PYTHON      mise (version) · uv (libraries)         │
├──────────────────────────────────────────────────────────┤
│  L1  TERMINAL    wezterm (window) · tmux (panes+memory)  │
├──────────────────────────────────────────────────────────┤
│  L0  OS          ubuntu 24.04 lts, dual-boot             │
└──────────────────────────────────────────────────────────┘
```

Each layer is small, almost boring. The value is in the composition.

| Layer | Why |
|---|---|
| **L0 OS** | Ubuntu dual-boot. Reasoning + install checklist: [docs/00-os-decision.md](docs/00-os-decision.md) |
| **L1 Terminal** | WezTerm is the window. **tmux is the one that matters** — work becomes a place that persists. |
| **L2 Python** | `mise` picks the Python, `uv` picks the libraries. `uv run` means you never activate anything. |
| **L3 Folders** | `~/.config` and `~/.claude` are symlinks into this repo. Fix once, fixed everywhere, in git. |
| **L4 Agents** | Four mechanisms, differing only on *when they're read*. See [claude/README.md](claude/README.md). |

Data isn't a layer. **DuckDB is just a library.** See [docs/02-data.md](docs/02-data.md).

---

## Make it a repo first

Everything here assumes this folder is under git: the `.gitignore` that keeps
design-agent from nesting, the "fix once, fixed everywhere" property, and the whole
MacBook migration. Do this once, before anything else.

```bash
cd ~/dev/computerstack        # or wherever it currently lives
git init
git add -A && git commit -m "computerstack"
gh repo create computerstack --private --source=. --push
```

Private, not public. It carries your standing orders and your working habits.

## Install

```bash
git clone <your repo> ~/dev/computerstack
cd ~/dev/computerstack
bash bootstrap/bootstrap.sh --dry-run     # see what it would do
bash bootstrap/bootstrap.sh               # do it
```

Idempotent — safe to re-run. `--only <phase>` runs one piece
(`system brew cli runtimes docker dotfiles claude`).

Then: log out and back in (docker group + zsh), open WezTerm, type `crew`.

---

## What's in here

```
computerstack/
├── docs/
│   ├── recap.md              ← read this first
│   ├── 00-os-decision.md     ubuntu vs wsl, and the dual-boot checklist
│   ├── 01-windows-interim.md running it on windows before the switch
│   └── 02-data.md            duckdb, parquet, scale, and databases
│
├── bootstrap/
│   ├── bootstrap.sh          the installer (ubuntu / macos)
│   ├── windows-link.ps1      the windows stand-in, until the switch
│   └── crew                  opens the tmux workspace for a project
│
├── dotfiles/                 symlinked into ~/.config
│   └── wezterm/  tmux/  zsh/  git/  starship/  mise/
│
└── claude/                   symlinked into ~/.claude
    ├── CLAUDE.md             standing orders, always read
    ├── how-i-learn.md        explanation style, read by /scroll and /tome
    ├── settings.json         permissions + hooks
    ├── skills/               procedures, read when relevant
    │   ├── new-ml-project/   a dataset becomes a working project
    │   │   ├── SKILL.md      the sequence
    │   │   └── template/     the folder shape it copies
    │   ├── new-web-project/  an idea becomes something running in a browser
    │   └── design-agent/     your own repo. cloned by bootstrap, gitignored here.
    ├── commands/             saved prompts, read when you type /name
    │   ├── rune scroll tome  learning, three depths
    │   ├── log catchup       write a decision down / read back where you stopped
    │   └── ship explore profile
    └── agents/               subagents, read when delegated
        └── scout reviewer data-analyst
```

**Where a rule belongs.** Each one lives in exactly one place. If it appears twice,
delete the lower copy, because the higher one is already loaded.

```
always true, everywhere        →  claude/CLAUDE.md
true whenever doing data work  →  claude/agents/data-analyst.md
true only for one procedure    →  the skill
true only for one project      →  that project's CLAUDE.md
```

---

## Deliberately not here

Removed after thinking it through, not overlooked:

| | Why |
|---|---|
| **Neovim** | Optimizes typing. Typing is ~10% of the work now. VS Code + tmux instead. |
| **Spark** | DuckDB covers everything up to ~100 GB. Learn Spark later, for the CV. |
| **MinIO** | Fakes S3 locally. Useful at a company, not yet. |
| **Dagster / Airflow** | Schedules pipelines that don't exist yet. |
| **chezmoi** | Plain symlinks are enough until two machines disagree. |

Add each the day you hit the wall it solves.

---

## Order of operations

| Phase | What | Time |
|---|---|---|
| 0 | Back up · BitLocker key · shrink partition · install Ubuntu | an evening |
| 1 | `bootstrap.sh` | 30 min |
| 2 | Write your first `~/.claude/CLAUDE.md` — 5 lines | 10 min |
| 3 | Use it on a real dataset | **2 weeks** |
| 4 | Then: the design agent, more skills, more subagents | ongoing |

Phase 3 is not optional padding. It's the phase where you find out what you actually
need — and it will not match what either of us guessed.

---

## The honest caveat

This is a force multiplier on work you're already doing. It is not a substitute for the
work, and configuring it is a very satisfying way to avoid starting.

Build phases 1 and 2, then **go use it**. Let friction tell you what to fix next.
Every choice in here is reversible. None of it is precious.
