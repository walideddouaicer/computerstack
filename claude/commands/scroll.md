---
description: Explain something properly, in a few paragraphs
allowed-tools: Read, Grep, Glob, Bash
---

**First read `how-i-learn.md` from the Claude config directory and follow it.**
That is `~/.claude/how-i-learn.md` on Linux and macOS, `%USERPROFILE%\.claude\how-i-learn.md`
on Windows. Especially the rule on formulas: never state one and move on, always take
it apart symbol by symbol.

Explain **$ARGUMENTS** properly. Aim for **300 to 500 words.**

Shape it like this, without using these as headings:

1. **What it is**, in one or two sentences.
2. **How it actually works.** One concrete example followed end to end. A real
   number, a real row, a real request. Concrete beats complete.
3. **What it is solving.** What did people do before this existed, and why was
   that worse? This is usually the part that makes it click.
4. **Where it breaks**, or when not to use it.

Rules:

- Judge my level from the question and pitch it there.
- Simple words, short sentences. English is not my first language.
- If the topic relates to this project, use this project's data or code as the
  example instead of a made-up one.
- Show real code or the real formula if there is one. Do not describe what you
  could just show.
- Say "I am not sure" where you are not.
- One analogy at most, then drop it and speak literally.
- Do not end with a summary of what you just said.

If this genuinely needs more than 500 words, stop and tell me to use `/tome`.
Do not silently write an essay into the chat.
