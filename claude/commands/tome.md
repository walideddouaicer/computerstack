---
description: Explain something in full depth and write it to a file
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(pwd:*), Bash(ls:*), Bash(mkdir:*), Bash(git:*)
---

Here: !`pwd`
Git repo: !`git rev-parse --is-inside-work-tree 2>/dev/null || echo no`
Existing notes: !`ls learning/ 2>/dev/null || echo "none yet"`

**First read `how-i-learn.md` from the Claude config directory and follow it throughout.**
That is `~/.claude/how-i-learn.md` on Linux and macOS, `%USERPROFILE%\.claude\how-i-learn.md`
on Windows. This is the tier where style matters most, because the result is a document
he will re-read. A tome that ignores that file is a wasted commitment.

Write a full explanation of **$ARGUMENTS** to a file.

## Where it goes

- Inside a project (a git repo, or a folder with `pyproject.toml`):
  `./learning/<topic>.md`
- Anywhere else: `~/notes/<topic>.md`

Create the folder if it does not exist. Filename is the topic in kebab-case.

**If the file already exists, read it first.** Then either extend it or rewrite
it, and say which you did. Do not append a second copy of the same thing.

**If this is a git repo,** make sure `learning/` is in `.gitignore`. Add the line
if it is missing. These are personal notes, not project files.

## What to write

As long as it needs. This is the tier with no length limit.

1. **The short version** at the very top. Three or four sentences, so future me
   can re-read that alone and remember.
2. **What problem it solves.** What did people do before, why was it worse.
3. **How it works**, built up in steps. Each step should stand on the one before.
4. **A worked example**, all the way through, with real numbers. If this project
   has relevant data, use that instead of inventing something.
5. **The maths**, if there is any, with every symbol named in words.
6. **Real code** that runs. Not pseudocode.
7. **Where it breaks.** Failure modes, when not to use it, what people get wrong.
8. **Where to go next** if I want to push further on this.

## Rules

- Simple words, short sentences. English is not my first language.
- Judge my level from the question and pitch it there.
- Show the real thing rather than describing it.
- Say "I am not sure" where you are not, instead of writing confident filler.
- No em dash.

## What comes back to the chat

**Two or three lines only. Do not print the explanation here.**

```
Written to learning/<topic>.md, ~N words.
Covers: <the three or four things it actually covers>.
```

The whole point of this command is that the long version lives in a file and
this conversation stays clean. Printing it here defeats it.
