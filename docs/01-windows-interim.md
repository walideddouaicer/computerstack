# Running this on Windows, before the switch

The point of this phase: **use the agent layer for real, so it gets shaped by actual
friction instead of our guesses.** Everything here is 100% portable, none of the effort
is lost when you move to Ubuntu.

## What works on Windows right now

| | |
|---|---|
| **Claude Code** | ✅ native Windows support |
| **`~/.claude`**, CLAUDE.md, skills, commands, agents | ✅ identical behaviour |
| **uv** | ✅ full workflow: `uv init`, `uv add`, `uv run` |
| **DuckDB** | ✅ |
| **WezTerm** | ✅ if you want to try the config early |
| tmux | ❌ Ubuntu |
| `bootstrap.sh` | ❌ Ubuntu |
| Native Docker | ❌ Ubuntu (Docker Desktop works, but with the VM tax) |

---

## Setup, in order

### 0. Make computerstack a git repo

It is not one yet. Everything downstream assumes it is: the `.gitignore` that stops
design-agent nesting, and the clone-onto-the-MacBook plan. Do this first.

```powershell
cd $env:USERPROFILE\Desktop\computerstack
git init
git add -A ; git commit -m "computerstack"
gh repo create computerstack --private --source=. --push
```

Private. It holds your standing orders and your working habits.

### 1. Git for Windows

```powershell
winget install Git.Git
```

Not optional in practice, without it Claude Code falls back to PowerShell for shell
commands. With it, you get the Bash tool, which is what every skill and command in this
repo assumes.

### 2. Claude Code

```powershell
irm https://claude.ai/install.ps1 | iex
```

Then open a **new** terminal and check:

```powershell
claude --version
claude doctor
```

`claude doctor` prints install and settings diagnostics without starting a session.
Run it whenever something feels off.

### 3. uv

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

It installs to `%USERPROFILE%\.local\bin` and adds it to PATH, but **only for new
terminals**. Open a fresh one, then:

```powershell
uv --version
```

### 4. Wire up the agent layer

```powershell
cd $env:USERPROFILE\Desktop\computerstack
powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File bootstrap\windows-link.ps1
```

**Turn on Developer Mode first** (Settings → System → For developers). That lets the
script make real symlinks without Administrator, which means no sync step: you edit the
repo, Claude Code sees it immediately.

Without Developer Mode it falls back to copying, and you have to re-run the script after
every edit. Workable, but annoying enough that Developer Mode is worth the 30 seconds.

### 5. Confirm it took

```powershell
cd $env:USERPROFILE\Desktop\computerstack
claude
```

Ask it: *"what are my standing orders?"*, it should describe your CLAUDE.md back to you.

---

## Then: actually use it

This is the part that matters. For the next two weeks:

1. Start a real project with the skill, `new ml project` with any dataset
2. Every time you correct the agent **the same way twice**, add a line to
   `claude/CLAUDE.md` in the repo
3. Every time you retype the same prompt, make it a command in `claude/commands/`
4. Use `scout` when a search would flood the conversation

At the end you'll have a config shaped by real friction. That's worth far more than
anything either of us could design up front.

---

## Two Windows-only gotchas

**Paths.** Skills and commands here use Unix paths like `~/dev/project`. On Windows,
Git Bash understands `~`, but PowerShell doesn't. If a skill misbehaves, that's usually
why. It resolves itself on Ubuntu, don't rewrite the skills to be Windows-shaped, or
you'll just have to undo it.

**`~/dev` doesn't exist yet.** Create it so projects land in the right place and the
habit transfers:

```powershell
mkdir $env:USERPROFILE\dev
```

---

## When you switch to Ubuntu

```bash
git clone <repo> ~/dev/computerstack
cd ~/dev/computerstack
bash bootstrap/bootstrap.sh
```

Your CLAUDE.md, skills, commands, and agents come across exactly as they are, already broken in. The only things you'll be learning fresh are tmux and native Docker.
