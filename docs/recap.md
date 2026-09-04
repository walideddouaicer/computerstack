# The whole picture

## The one idea

> **Every decision gets made once, written into a file, and never made again.**

Friction is decisions you re-make every time you open a folder. That is all it is. The
pretty terminal in the video was a side effect of this, not the cause.

---

## Mind map

```
                          THE WORKSHOP
                               │
   ┌──────────┬────────────────┼───────────────┬──────────────┐
   │          │                │               │              │
  L0 OS    L1 TERMINAL     L2 PYTHON      L3 FOLDERS      L4 AGENTS
   │          │                │               │              │
 omarchy   omarchy  shell    mise  version   ~/dev        CLAUDE.md  always
 arch +    tmux     panes    uv    libs      ~/.config    skills     when relevant
 hyprland                                    ~/.claude    commands   when typed
                                                          agents     when delegated

      L0 and L1 belong to Omarchy. L2, L3 and L4 are ours.

              DuckDB is not a layer. It is just a library.
```

---

## L0 and L1, Omarchy

**Omarchy owns the OS, the desktop, the terminal and the shell.** Arch plus Hyprland,
curated and opinionated. It is someone else's computerstack for the bottom two layers,
which is this repo's own principle applied by someone who got there first. Full
reasoning and the known collision: [01-omarchy-decision.md](01-omarchy-decision.md).

**Windows first.** None of this changes the Windows phase, where everything in `claude/`
behaves identically. [01-windows-interim.md](01-windows-interim.md).

### What we keep from L1

Three programs are stacked in any terminal:

```
THE TERMINAL   the window        fonts, colours     ← Omarchy picks this
  TMUX         splits + memory   panes, persists    ← ours, and the one that matters
    THE SHELL  the prompt        runs what you type ← Omarchy picks this
```

**tmux is the one that matters.** Work becomes a place that persists. Close the laptop,
`tmux attach`, everything is where you left it.

Six keys: `Ctrl-a` then `|` `-` `hjkl` `z` `d`. Plus `tmux attach`.

## L2, Python

**The problem:** one shared box of libraries. Project A needs pandas 1.5, project B needs
2.2. They fight.

**The fix:** one box per project (`.venv`), and two tools.

```
mise  picks the PYTHON      (3.12)
uv    picks the LIBRARIES   (polars, duckdb...)
```

| File | Is | Says |
|---|---|---|
| `pyproject.toml` | shopping list | "I need polars" |
| `uv.lock` | **receipt** | "polars 1.12.0 plus 38 others, exactly" |

The receipt is why it still works in six months, and on any other machine.

**`uv run` means you never activate anything.** You cannot forget a step that does not
exist, and it works inside scripts and agent commands where activation does not.

## L3, folders

```
~/dev/          YOUR PROJECTS       nothing else
~/.config/      HOW TOOLS BEHAVE    tmux, git, mise
~/.claude/      HOW AGENTS BEHAVE   CLAUDE.md, skills, commands, agents
```

The last two are **shortcuts into one git repo**, `~/dev/computerstack`. Fix once, fixed
everywhere, in git, and it reproduces on any machine from a clone.

Every project, in any language, has the same skeleton:

```
project/
├── <manifest>     pyproject.toml / package.json
├── <lockfile>     uv.lock
├── CLAUDE.md      what this is
├── src/  tests/
└── .env.example   the shape of the secrets, never the secrets
```

## L4, agents

You do not build agents. **You write files that change how one agent behaves.** All four
differ on one question: *when does it get read?*

| | When read | For |
|---|---|---|
| **CLAUDE.md** | always | who you are, what this project is |
| **how-i-learn.md** | by `/scroll` and `/tome` | how to explain things to you |
| **skills/** | when relevant | procedures |
| **commands/** | when you type `/x` | saved prompts |
| **agents/** | when delegated | temp workers with their own desk |

### The rule that keeps it from rotting

> **Every rule lives in exactly one place. If it appears twice, delete the lower copy.**

```
always true, everywhere        →  claude/CLAUDE.md
true whenever doing data work  →  agents/data-analyst.md
true only for one procedure    →  the skill
true only for one project      →  that project's CLAUDE.md
```

### The desk

Your conversation is a **desk**. Everything opened stays on it. Fill it and things fall
off the back.

A subagent goes to **its own desk**, makes the mess there, comes back with **one page**.

> 15 files and 3,000 lines read, one line lands on your desk.

`sonnet` for mechanical work, `opus` for judgment. **Build one, not six.** Start with
`scout`.

A subagent is **not** sandboxed. It shares your filesystem. The `tools:` line in its
file is the entire safety boundary.

---

## What is installed in `claude/`

```
skills/
  new-ml-project/    a dataset becomes a working project. profiles before modelling.
  new-web-project/   an idea becomes something running in a browser. vertical slice first.
  design-agent/      your own repo. how the screens look.

commands/
  /rune    6 sentences, ~30 seconds        learning
  /scroll  300 to 500 words                learning
  /tome    no limit, writes a file         learning
  /log     write a decision into the project's CLAUDE.md
  /catchup you have been away, where were you
  /ship    lint, test, review, commit
  /explore map an unfamiliar codebase
  /profile profile a dataset

agents/
  scout          searching, keeps your desk clean
  reviewer       adversarial pass on a diff
  data-analyst   profiling, verifies its own numbers
```

**The learning tiers run in the LEARN pane, not the trunk.** Same folder, so they read
the same project CLAUDE.md and know the project. Separate conversation, so asking
questions never fills up your main session.

---

## Docker

Two different jobs share one name, and you were taught the hard one first.

```
JOB A  USING containers        JOB B  BUILDING containers
run Postgres without           package MY app
installing Postgres
~9 lines of YAML               a Dockerfile, layers, caching
easy, useful today             hard, useful later
```

`uv.lock` already gives you reproducible Python, so reach for Docker only for
**non-Python** things: a database, a system library, CUDA.

**The model:** image = a frozen photo. Container = a **hotel room**, wiped when you
leave. Volume = your **suitcase**, it persists.

**The rule:** never type `docker run` for anything you will do twice.

> Any database container needs a named volume, or the data dies on restart.

## Data

**DuckDB is the whole data layer**, and it is just a library.

```python
duckdb.sql("SELECT count(*) FROM 'data/raw/trips.parquet'")   # no loading step
```

- **CSV is for receiving. Parquet is for keeping.** 5 to 10x smaller, faster, types kept.
- **1 to 100 GB is DuckDB territory.** You will live there for years.
- **Spark:** learn it after you can already do the analysis.
- **MLflow** needs no server: `mlflow.set_tracking_uri("file:./mlruns")`

Full version: [02-data.md](02-data.md)

## Editor

**VS Code plus tmux. Not Neovim.**

Neovim optimises typing. Typing is now about 10% of your work, the rest is reviewing.
The real question is no longer "how fast can I type" but "how fast can I read a diff and
say yes or no", which `delta` and VS Code already answer. Also VS Code's Jupyter support
is good and Neovim's is not, which for ML is decisive.

---

## Cheat sheet

```bash
# projects
uv init my-project          # new project
uv add polars duckdb        # add libraries
uv run python train.py      # run something
uv sync                     # rebuild box from receipt

# terminal
tmux attach                 # return to your session
Ctrl-a |                    # split right
Ctrl-a -                    # split down
Ctrl-a hjkl                 # move between panes
Ctrl-a z                    # zoom this pane fullscreen
Ctrl-a d                    # leave, everything keeps running
crew <project>              # open the whole workspace

# agents
claude                      # start
/rune <topic>               # 6 sentences
/tome <topic>               # writes learning/<topic>.md
/ship                       # lint, test, review, commit
```

---

## Deliberately not here

| | Why |
|---|---|
| Neovim | Optimises the 10% |
| WezTerm, zsh, starship configs | Superseded by Omarchy. Kept until it is actually installed. |
| Spark | DuckDB covers everything you will hit |
| MinIO | Fakes S3. Useful at a company, not yet. |
| Dagster / Airflow | Schedules pipelines you do not have |
| A standing Postgres compose file | Belongs in the project that needs it |
| `learned.md` | A stale model of you is worse than none |
| chezmoi | Plain symlinks are enough until two machines disagree |

## Still to come

- **Install it.** Four steps, about fifteen minutes: [01-windows-interim.md](01-windows-interim.md)
- **Use it on the taxi data.** Nothing here has run yet.
- Pseudo-university, after `/tome` has fifteen real uses behind it

---

## If you forget everything else

1. Write decisions into files, not your head
2. tmux, so work is a place you return to
3. `uv run`, so there is no step to forget
4. `CLAUDE.md`, so the agent knows you next month
5. Subagents, so your desk stays clean
6. Every rule in exactly one place
