---
description: Review, test, and commit the current work
allowed-tools: Bash(git:*), Bash(ruff:*), Bash(pytest:*), Read, Grep, Glob, Agent
---

Current state:

- Branch: !`git branch --show-current`
- Status: !`git status -sb`
- Diff stat: !`git diff --stat HEAD`

Ship the current work. In order, stopping if any step fails:

1. **Lint & format**, `ruff format . && ruff check --fix .` (skip if not a Python repo)
2. **Test**, run the project's test command. Report actual output.
3. **Review**, spawn the `reviewer` subagent on `git diff HEAD`. Fix anything it marks
   Blocking. Report the Should-fix items to me without fixing them.
4. **Secrets check**, scan the staged diff for keys, tokens, `.env` content. Abort loudly
   if anything looks like a credential.
5. **Commit**, stage and write a commit message: imperative mood, subject under 72 chars,
   body explaining *why* if it isn't obvious. No "Generated with" footer.
6. **Stop.** Do not push. Show me the commit and wait.

$ARGUMENTS
