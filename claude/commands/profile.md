---
description: Profile a dataset before analyzing it
allowed-tools: Bash, Read, Write, Agent
---

Profile the dataset at: $ARGUMENTS

Use the `data-analyst` subagent. Use DuckDB unless the format demands otherwise.

Report:

1. **Shape**, rows, columns, file size, format
2. **Schema**, column names, inferred types, and where the inference looks wrong
3. **Completeness**, null rate per column, sorted worst first
4. **Keys**, cardinality of each candidate key, and the duplicate rate on it
5. **Time**, the date range, plus rows-per-day/month, so ingestion gaps are visible
6. **Numerics**, min / p1 / p25 / median / p75 / p99 / max per numeric column.
   Flag impossible values (negative ages, future dates, zeros where zero is meaningless)
7. **Categoricals**, top 10 values with counts for each low-cardinality column.
   Flag near-duplicate categories (`"US"` vs `"USA"` vs `"us"`)

Then, in plain language:

- **The three things that would bite me** if I analyzed this naively
- **What I'd need to clean** before this is trustworthy
- **What questions this data can and cannot answer**

Do not build a model. Do not draw conclusions about the domain. Profile only.
