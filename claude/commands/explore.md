---
description: Understand an unfamiliar codebase before touching it
allowed-tools: Read, Grep, Glob, Bash, Agent
---

Repo: !`basename $(git rev-parse --show-toplevel 2>/dev/null || pwd)`
Tree: !`eza --tree --level=2 --ignore-glob=".git|node_modules|__pycache__|.venv" 2>/dev/null | head -60`

Build me a map of this codebase. Use the `scout` subagent for the search-heavy parts so
this context stays clean.

Cover:

1. **What it does**, in two sentences, from the README and the entry points
2. **How to run it**, install, run, test. The actual commands, verified against
   pyproject.toml / package.json / Makefile / docker-compose.yml
3. **The shape**, the 5–8 directories that matter and what each owns. Ignore the rest.
4. **The main flow**, trace one representative path end to end with file:line refs
5. **Data & state**, what persists, where, and what the schema looks like
6. **Conventions**, naming, error handling, testing style. What would make a PR look
   out of place here?
7. **Smells**, anything that looks half-migrated, duplicated, or abandoned

End with the three files I should read myself, and why those three.

Focus area (optional): $ARGUMENTS
