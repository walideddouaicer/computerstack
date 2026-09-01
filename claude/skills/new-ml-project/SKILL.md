---
name: new-ml-project
description: Set up a new machine learning or data analysis project from a dataset. Use when Walid has a new CSV/Parquet/dataset, says "new ML project", "new data project", "let's look at this dataset", or drops a data file and wants to start working on it.
---

# New ML project

This skill owns the **sequence**. It does not restate the data rules, which already
live in `~/.claude/CLAUDE.md` and `agents/data-analyst.md`.

## Steps

**1. Name it.** Ask if not given. kebab-case. Confirm before creating anything.

**2. Build the folder** from `template/` next to this file. Copy it, then adapt:
time series wants `data/splits/`, text projects drop the tabular scaffolding.
Rename `gitignore` to `.gitignore`.

**The template is a starting point, not a law.** If the project is unusual, change it
and say what you changed.

**3. Move the dataset** into `data/raw/`. If it is a URL or a Kaggle link, download it
there. From here on `data/raw/` is immutable.

**4. Set up the environment.** The template already has a `pyproject.toml`, so use
`uv sync`, not `uv init`:

```bash
uv sync                 # polars, duckdb, ruff, pytest
```

Then add only what this project actually needs:

| If the project will... | add |
|---|---|
| use notebooks | `jupyterlab ipykernel` |
| train models | `scikit-learn` |
| plot | `matplotlib` |
| train repeatedly and compare runs | `mlflow` |

Don't install a library the project has no use for yet. `uv add` takes seconds later.

**5. Write the project's `CLAUDE.md`** using `template/CLAUDE.md` as the shape. Fill in
only what you actually know. It grows as you learn.

**6. Profile the data.** Hand this to the `data-analyst` subagent. It has the checklist.

Do not model. Do not draw conclusions about the domain. Profile only.

**7. Report the findings** in plain language, and specifically answer:
- What are the three things that would bite me if I analyzed this naively?
- What needs cleaning before this is trustworthy?
- What questions can this data **not** answer?

**8. Write the decisions from that conversation into the project's `CLAUDE.md`.**

This is the step that makes next month easy, and it is the one most likely to get
skipped. The "MA vs Morocco" kind of fact belongs here, permanently.

Put them under a `## Decisions` heading, one line each, reason included. That is the
same section `/log` appends to and `/catchup` reads back, so it has to exist and it has
to be called that.

**9. Create `notebooks/01-first-look.ipynb`** with the profiling code that was actually
run, so the numbers are reproducible. Verify it runs before saying it is done.

## Procedure rules

These are specific to setting up a project. General data rules are already loaded.

- **Profile before modelling. Always.** Even when the question looks simple.
- **Baseline before model.** Predict the mean, the majority class, or last period's
  value, and log it. Roughly half of ML projects have models that never beat it, and
  learning that on day one beats a week of tuning.
- **Notebooks explore. `src/` holds working code.** The moment something works, move it.
- Setup and profiling only. **Do not build a model in this skill.**
