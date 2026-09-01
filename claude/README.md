# The agent layer

This folder symlinks to `~/.claude`.

> **You don't build agents. You write files that change how one agent behaves.**

There's one Claude Code. What changes is what it reads when it wakes up.

---

## Four mechanisms, one difference

They differ on exactly one question: **when does it get read?**

```
~/.claude/
├── CLAUDE.md      ALWAYS            who you are, how you work
├── skills/        WHEN RELEVANT     procedures the agent finds itself
├── commands/      WHEN YOU TYPE     saved prompts, /explore
└── agents/        WHEN DELEGATED    temp workers with their own desk
```

That's the whole taxonomy. People overcomplicate this.

---

## CLAUDE.md, two levels

```
~/.claude/CLAUDE.md              how I work          ← keep it SHORT
~/dev/sales-analysis/CLAUDE.md   what this project is
```

Both are read. The project one wins on conflict.

**Keep the global one short.** It loads into every session. A 300-line CLAUDE.md doesn't
make the agent smarter, it buries the rules that matter and they start getting ignored.

**How to grow it:** don't write it up front, you'll write rules for problems you don't
have. Start with 5 lines. Then:

> Every time you correct the agent **the same way twice**, that correction becomes a line.

Every line earns its place. Six months of that and it's genuinely yours.

**The project-level one is where the real value is.** The things you learn on day 2 and
forget by day 10:

```markdown
## The data
- "MA" and "Morocco" are the same. Merge them.
- Feb 12–14 is an ingestion gap, not zero sales.
- Negative revenue = refunds. Keep, but flag.
```

Write it down once, and next month starts where last month ended.

---

## Skills

A folder: instructions plus something to copy.

```
skills/new-ml-project/
└── SKILL.md
```

**The `description` field decides whether it ever triggers.** The agent reads all
descriptions and picks a match. So describe the *situation*, not the skill.

```
❌  description: A template for machine learning projects.
✅  description: Use when Walid has a new dataset, says "new ML project",
    or drops a CSV and wants to start working on it.
```

This is the #1 reason skills sit unused. Write the description last, as *"use when…"*.

**The template it copies is a plain folder**, no `{{ templating }}`. That's deliberate:
the agent can *adapt* it (time series → add `data/splits/`) instead of stamping it.

---

## Subagents, the desk

Your conversation is a **desk**. Every file opened, every search result stays on it. Fill
it and things fall off the back, the agent forgets what you said an hour ago.

A subagent goes to **its own desk**, makes the mess there, and hands back **one page**.

> "Where is the region column cleaned?"
> → 15 files and 3,000 lines read on *its* desk
> → `src/features/clean.py:42` lands on yours

That's the value. Not "having a team."

| Agent | Model | Job |
|---|---|---|
| `scout` | sonnet | Read-only recon. Keeps your desk clean. **Start here.** |
| `reviewer` | opus | Adversarial pass on a diff before merge. |
| `data-analyst` | opus | Profiles datasets, verifies its own numbers. |

**Model choice is money.** `sonnet` for mechanical work (searching, boring tests).
`opus` for judgment (review, planning, analysis). Using Opus for a file search is paying
a senior engineer to use Ctrl-F.

### Build one, not six

Subagents don't know you, each starts blank. Six of them isn't a team, it's six
strangers hired and fired constantly. Most people build a full crew on day one and never
use five of them.

**Use `scout` for two weeks first.** Add the next one when you feel the pain.

---

## Hooks (`settings.json`)

- **PostToolUse** → every file written gets `ruff format`ed immediately. You stop
  reviewing formatting diffs forever.
- **PreToolUse** → blocks any bash command touching `.env` or a credential-shaped name.
- **Stop** → notification when the session goes idle. This one changes your day: kick off
  a long task, switch panes, get pulled back when it's *actually* done.

Hooks are shell commands receiving JSON on stdin. Debug with:

```bash
echo '{"tool_input":{"file_path":"x.py"}}' | <your hook command>
```

---

## Debugging

| Symptom | Check |
|---|---|
| Skill never triggers | Its `description`. Make it say *when to use*, not *what it is*. |
| Hook doesn't fire | Run it manually with piped JSON. Hooks fail silently by design. |
| Agent ignores a rule | It's buried in a long CLAUDE.md. Cut the file in half. |
| Context fills too fast | You're not sending searches to `scout`. |
| `/command` missing | It's `commands/name.md` → `/name`. Restart the session. |
