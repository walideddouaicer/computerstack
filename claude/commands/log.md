---
description: Write a decision into this project's CLAUDE.md
allowed-tools: Read, Write, Edit, Bash(pwd:*), Bash(ls:*), Bash(git:*)
---

Here: !`pwd`
Has CLAUDE.md: !`ls CLAUDE.md 2>/dev/null || echo "no"`

Record this decision: **$ARGUMENTS**

## Where it goes

The current project's `CLAUDE.md`, under `## Decisions`. Create the section if it is
missing. Create the file if it is missing, using the minimum shape:

```markdown
# <folder name>

## Decisions
```

Do not create a full project CLAUDE.md here. `/log` records one line, it does not
scaffold. The skills do that.

## How to write the line

Compress what I said into one clean line. Keep my meaning, drop my rambling.

```
- Merged "MA" into "Morocco". Same country, two spellings in the source.
```

Rules:

- **One line.** If it truly needs two, use two, never a paragraph.
- **Include the reason** when there is one. A decision without its reason gets
  re-litigated in a month, which is the exact thing this file exists to prevent.
- **No date.** Git already timestamps every line. Adding dates is noise.
- Present tense, plain words.

## Check for conflicts first

**Read the existing Decisions section before writing.**

- If this **contradicts** an existing line: do not append. Say which line it conflicts
  with, ask which one is right, then replace rather than adding a second.
- If it **refines** an existing line: edit that line instead of adding a near-duplicate.
- If it is genuinely new: append.

A decisions log that accumulates contradictions is worse than no log, because you can no
longer tell which line is current.

## Then

Print only the line you wrote. One line back, nothing else. This command should feel
like it costs nothing.
