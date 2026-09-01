# Project: <name>

<One paragraph. What does this predict or answer, and for whom?>

## Layout

```
data/raw/         immutable. the file as it arrived.
data/interim/     intermediate, regenerable
data/processed/   parquet. what you actually work with.
notebooks/        exploration only, numbered
src/config.py     paths and settings, never hardcoded
src/data/         loading, validation
src/features/     transforms, the things that must not leak
src/models/       train.py, predict.py
tests/
```

## Commands

```bash
uv sync
uv run pytest
uv run ruff check --fix . && uv run ruff format .
```

## The data

- Source: <where it comes from, how often it refreshes>
- Grain: <one row = one what?>
- Known issues: <nulls, gaps, the column that lies, the near-duplicate categories>

**`data/raw/` is immutable.** Everything reads from it, nothing writes to it.

## Rules for this project

<Delete what does not apply. Add what you learn.>

- **Split before fitting.** Any transform that learns parameters is fitted on train only.
- Target is `<col>`. Never use `<leaky_col>` as a feature, it is populated after the
  outcome is known.
- Split strategy: <random / time-based / grouped by X>. Say why.
- Notebooks explore. Working code lives in `src/`.

## Baseline

<The number to beat, and what produces it. e.g. "predict last week's value: MAE 4.2">

Anything that does not beat this is not a result.

## Decisions

<Every time you and the agent settle something about this data, it goes here.
One line each, reason included. This is the section that makes coming back in
a month easy.

`/log` appends here. `/catchup` reads it back. Do not rename this heading.>
