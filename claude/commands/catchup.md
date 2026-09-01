---
description: You have been away. Where were you, and what is next.
allowed-tools: Read, Grep, Glob, Bash(pwd:*), Bash(ls:*), Bash(git:*), Bash(cat:*), Bash(head:*)
---

Here: !`pwd`
Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`
Last commit was: !`git log -1 --format='%cr, by %an' 2>/dev/null || echo "none"`
Recent commits: !`git log --oneline -12 2>/dev/null || echo "none"`
Uncommitted: !`git status -s 2>/dev/null | head -20 || echo "none"`
Learning notes: !`ls learning/ 2>/dev/null | head -10 || echo "none"`

I have been away. Tell me where I was.

## Read first

- This project's `CLAUDE.md`, especially the `## Decisions` section
- The recent commit messages above
- Whatever is uncommitted, since that is almost always where I stopped mid-thought

If there is no `CLAUDE.md`, say so once. That is the thing that would have made this
easy, and it is worth knowing it is missing.

## Report exactly this, and nothing else

```
## Where you stopped
<two or three sentences. what you were doing and how far it got.>

## In flight
<uncommitted or half-finished work. name the files.
 if a change looks abandoned mid-edit, say so, that is the most useful thing here.>

## Decisions you had made
<the two or three from CLAUDE.md that matter for picking this back up.
 skip the ones that are just background.>

## The obvious next step
<one thing. not a list. the single thing you would do first if you sat down now.>
```

## Rules

- **Short.** This is orientation, not a report. If it runs past a screen it has failed.
- Say what you found, not what you assume. If the trail goes cold after the last commit,
  say the trail goes cold. Do not invent a narrative to fill the gap.
- Do not fix anything. Do not start work. Do not offer to. Just tell me where I am.
- Do not summarise the whole project. I built it, I need reminding, not teaching.
- If nothing has happened since the last catchup, say that in one line and stop.
