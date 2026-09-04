# ADR-001: Omarchy takes over layers 0 and 1

**Status:** Decided
**Date:** 2026-09-04
**Supersedes:** [ADR-000](00-os-decision.md), Ubuntu 24.04 dual-boot
**Context:** No MacBook. Omarchy 4 "Quattro" shipped 2026-08-14.

---

## What changed

ADR-000 rested on one thing: a MacBook was coming in about a year, so the setup had to
transfer to macOS. That premise picked the OS, the shell, the terminal, and Homebrew.

**The MacBook is off.** The premise is gone, so the decisions built on it have to be
re-made rather than inherited.

## Decision

**Omarchy owns layers 0 and 1. computerstack keeps 2, 3 and 4.**

```
L4  AGENTS      computerstack     CLAUDE.md, how-i-learn, skills, commands, agents
L3  FOLDERS     computerstack     ~/dev, and what gets symlinked where
L2  PYTHON      computerstack     mise, uv
──────────────────────────────────────────────────────────────────────────────
L1  TERMINAL    Omarchy           its terminal, its shell, Hyprland, the bar
L0  OS          Omarchy           Arch, curated, rolling
```

## Why this is coherent rather than a reversal

**Omarchy is someone else's computerstack, for the bottom two layers.** DHH made those
decisions once and wrote them down, which is the same principle this whole repo is built
on. Adopting it is not abandoning the idea, it is applying it to a layer where somebody
else did the work better and earlier.

The top three layers were always the part that was actually ours. They survive untouched.

## What this deletes

| Goes | Reason |
|---|---|
| `dotfiles/wezterm/` | Omarchy ships Ghostty, Foot and Kitty. Not WezTerm. |
| `dotfiles/zsh/`, `dotfiles/starship/` | Omarchy manages its own shell. `omarchy update` and our symlinks would fight. |
| `bootstrap.sh` system phase | It is `apt`. Arch is `pacman`, and Omarchy wants neither, it wants its own update script. |
| Homebrew on Linux | Only ever there for macOS parity. |
| The macOS branch of `bootstrap.sh` | No macOS. |

`dotfiles/tmux/` and `dotfiles/git/` survive. Omarchy supports tmux, and the gitconfig is
ours regardless of OS.

## What this gains

Omarchy 4 treats coding agents as system citizens, which is plumbing we would never have
built:

- Nine agents on `Super+Shift+Ctrl+A`, installed on demand
- A status bar widget tracking Claude Code plan limits, weekly burn, token use
- Crashes caught off the systemd journal, a toast, and a click briefs your agent with a
  `diagnose-crash` skill that reads the backtrace

The division is clean: **Omarchy provides the wiring, computerstack provides the
content.** Our `CLAUDE.md`, `how-i-learn.md` and skills still decide how the agent
behaves. Omarchy just makes it reachable from anywhere in the desktop.

## The known collision

Omarchy 4 symlinks **its own agent skill into `~/.claude/skills/`**, teaching the agent
to reconfigure the machine.

Our bootstrap symlinked the **whole** `claude/skills` directory to that path. Together
that either drops Omarchy's skill inside this git repo, or breaks it.

**Fix, already applied:** symlink individual skills, commands and agents rather than
whole directories. Omarchy's files then sit alongside ours and neither owns the parent.

**Cost of the fix:** adding a new skill to this repo no longer appears automatically. Run
`bootstrap.sh --only claude` after adding one. That is a few seconds, and it is a better
trade than a directory nobody owns.

## Consequences

**Good**
- The desktop, terminal and theming are decided, curated, and not our problem
- Agent integration at the OS level that we would not have written
- Everything that was actually ours survives untouched

**Cost**
- **It is Arch.** ADR-000 rejected Arch on the grounds that it taxes you daily. Omarchy
  reduces that tax through curation. It does not remove it. Reported by people running
  it: GPU crashes, hibernation bugs, WiFi firmware problems, and a custom update script
  that replaces `pacman` and has had its own bugs. Hibernation and WiFi firmware are
  exactly the ThinkPad-relevant ones.
- **Rolling release.** It breaks on a random Tuesday rather than on a schedule you chose.
- **Smaller community.** When something breaks, the fix is less likely to be the first
  search result than it would have been on Ubuntu.
- Neither of us has run it. This decision is made from reading.

## Sequencing, and this is the part that matters

**Windows first, unchanged.** The whole Windows interim phase is untouched by this
decision: Claude Code, uv, and the agent layer behave identically. See
[01-windows-interim.md](01-windows-interim.md).

Two weeks of real use on the taxi data, then install Omarchy. By then we will know which
parts of the agent layer are real, and the OS underneath will be a smaller question than
it feels like today.

Rewriting an OS decision takes an hour. Rewriting it twice, because it was made before
anything had been run, takes a weekend.

## Revisit this when

- Omarchy breaks in a way that costs more than a morning, twice in one month
- Or a year passes and it has cost nothing, in which case stop thinking about it
