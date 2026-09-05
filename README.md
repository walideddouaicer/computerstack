# computerstack

Walid's workstation. One repo that turns a bare machine into the workshop.

> **The one idea:** every decision gets made once, written into a file, and never made
> again. Friction is decisions you re-make every time you open a folder. That's all it is.

Start here → **[docs/recap.md](docs/recap.md)**, the whole picture in one page.

---

## The rule that decides everything

**It must be reproducible from a git clone.**

Not "it works on my machine." A fresh machine plus `git clone` plus one script equals the
same workshop. That is why `~/.config` and `~/.claude` are symlinks into this repo rather
than files you edited once and forgot.

*(This replaced the old rule, "it must survive the move to the MacBook." The MacBook is
off. See [ADR-001](docs/01-omarchy-decision.md).)*

---

## Five layers, and who owns them

```
┌──────────────────────────────────────────────────────────┐
│  L4  AGENTS      CLAUDE.md · skills · commands · agents  │  ours
├──────────────────────────────────────────────────────────┤
│  L3  FOLDERS     ~/dev · ~/.config · ~/.claude           │  ours
├──────────────────────────────────────────────────────────┤
│  L2  PYTHON      mise (version) · uv (libraries)         │  ours
├══════════════════════════════════════════════════════════┤
│  L1  TERMINAL    omarchy's terminal + shell · tmux       │  Omarchy
├──────────────────────────────────────────────────────────┤
│  L0  OS          omarchy (arch + hyprland)               │  Omarchy
└──────────────────────────────────────────────────────────┘
```

**Omarchy is someone else's computerstack for the bottom two layers.** DHH already made
those decisions and wrote them down, which is this repo's own principle applied by
somebody who got there first. The top three were always the part that was actually ours.

| Layer | |
|---|---|
| **L0 OS** | Omarchy. Arch, curated, rolling. [ADR-001](docs/01-omarchy-decision.md) |
| **L1 Terminal** | Omarchy's terminal and shell. **tmux is the piece we keep**, because it makes work a place that persists. |
| **L2 Python** | `mise` picks the Python, `uv` picks the libraries. `uv run` means you never activate anything. |
| **L3 Folders** | `~/.claude` contents symlinked into this repo. Fix once, fixed everywhere, in git. |
| **L4 Agents** | Four mechanisms, differing only on *when they're read*. See [claude/README.md](claude/README.md). |

Data isn't a layer. **DuckDB is just a library.** See [docs/02-data.md](docs/02-data.md).

---

## Where things stand

**Nothing has been installed. Nothing has been run.** The repo is complete on paper.

The plan is Windows first, deliberately:

| Phase | What | Status |
|---|---|---|
| **1** | Install Omarchy alongside Windows | ← **you are here** |
| **2** | `bootstrap.sh --only claude`, then use it on the taxi data | |
| **3** | Rewrite the apt phases of bootstrap for pacman | |

Guide: **[docs/03-omarchy-install.md](docs/03-omarchy-install.md)**. Checked against your
actual disk. BitLocker is off, which removes the one hazard that could have locked you
out of Windows.

Phase 2 is not padding. It is the phase that tells you which parts of the agent layer are
real, and it will not match what either of us guessed. Changing the OS underneath before
that means guessing twice.

**Windows:** [docs/01-windows-interim.md](docs/01-windows-interim.md). Everything in
`claude/` behaves identically there, so none of that effort is thrown away.

---

## What's in here

```
computerstack/
├── docs/
│   ├── recap.md                  ← read this first
│   ├── 00-os-decision.md         superseded, kept for the reasoning
│   ├── 01-omarchy-decision.md    what Omarchy takes over, and why
│   ├── 01-windows-interim.md     running it on Windows, before the switch
│   ├── 03-omarchy-install.md     the dual-boot, step by step. read from your phone.
│   └── 02-data.md                duckdb, parquet, scale, databases
│
├── bootstrap/
│   ├── bootstrap.sh              the Linux installer
│   ├── windows-link.ps1          the Windows stand-in, until the switch
│   └── crew                      opens the tmux workspace for a project
│
├── dotfiles/
│   ├── tmux/  git/  mise/        kept, OS-independent
│   └── wezterm/  zsh/  starship/ superseded by Omarchy, see below
│
└── claude/                       contents symlinked into ~/.claude
    ├── CLAUDE.md                 standing orders, always read
    ├── how-i-learn.md            explanation style, read by /scroll and /tome
    ├── settings.json             permissions + hooks
    ├── skills/                   procedures, read when relevant
    │   ├── new-ml-project/       a dataset becomes a working project
    │   ├── new-web-project/      an idea becomes something in a browser
    │   └── design-agent/         your own repo. cloned by bootstrap, gitignored here.
    ├── commands/                 saved prompts, read when you type /name
    │   ├── rune scroll tome      learning, three depths
    │   ├── log catchup           write a decision / read back where you stopped
    │   └── ship explore profile
    └── agents/                   subagents, read when delegated
        └── scout reviewer data-analyst
```

**Why the contents of `claude/` are linked, not the folders.** Omarchy installs its own
skill into `~/.claude/skills/`. If that folder were a symlink into this repo, Omarchy's
file would land inside our git tree, or fail. Linking per item means both sets coexist.
Cost: run `bootstrap.sh --only claude` after adding a new skill.

**Where a rule belongs.** Each one lives in exactly one place. If it appears twice,
delete the lower copy, because the higher one is already loaded.

```
always true, everywhere        →  claude/CLAUDE.md
true whenever doing data work  →  claude/agents/data-analyst.md
true only for one procedure    →  the skill
true only for one project      →  that project's CLAUDE.md
```

---

## Install

**Windows, now:** [docs/01-windows-interim.md](docs/01-windows-interim.md)

**Omarchy, later:**

```bash
git clone <your repo> ~/dev/computerstack
cd ~/dev/computerstack
bash bootstrap/bootstrap.sh --dry-run     # see what it would do
bash bootstrap/bootstrap.sh               # do it
```

Idempotent, safe to re-run. `--only <phase>` runs one piece
(`system brew cli runtimes docker dotfiles claude`).

The `system`, `brew` and `cli` phases still assume `apt` and will need rewriting for
Arch. The `claude` phase, the one that matters, is OS-independent and works today.

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
| **A standing Postgres compose file** | Belongs in the project that needs it. |
| **`learned.md`** | A stale model of what you know is worse than none. |

## Superseded, but not yet deleted

`dotfiles/wezterm/`, `dotfiles/zsh/` and `dotfiles/starship/` are replaced by Omarchy,
which ships its own terminal and shell config and will fight our symlinks on update.

They stay until Omarchy is actually installed and running. Deleting working configuration
for an OS nobody has booted yet is the same mistake as designing for one.

---

## The honest caveat

This is a force multiplier on work you're already doing. It is not a substitute for the
work, and configuring it is a very satisfying way to avoid starting.

Do phase 1, then **go use it**. Let friction tell you what to fix next. Every choice in
here is reversible. None of it is precious.
