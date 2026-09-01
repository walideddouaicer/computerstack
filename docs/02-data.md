# Data

## DuckDB is the whole data layer

It is a library, not a service.

```bash
uv add duckdb
```

No server, no Docker, no ports.

```python
import duckdb

# reads the file where it sits. no loading step.
duckdb.sql("SELECT count(*) FROM 'data/raw/trips.parquet'")

# a real question, on millions of rows, instantly
duckdb.sql("""
    SELECT borough, median(fare) AS med, count(*) AS n
    FROM 'data/raw/*.parquet'
    GROUP BY borough ORDER BY med DESC
""")
```

Works on files bigger than your RAM. It spills to disk instead of dying.

## What else it does

```python
duckdb.sql("SELECT * FROM my_polars_df WHERE borough = 'Manhattan'")   # dataframes in place
duckdb.sql("SELECT * FROM 'data/processed/*.parquet'")                 # a folder as one table
duckdb.sql("ATTACH 'postgresql://lab:lab@localhost:5432/lab' AS pg (TYPE postgres)")
```

Files, dataframes, and a real database in one SQL statement. That is why it sits at
the centre instead of being a side tool.

## DuckDB or polars?

They read each other's data for free. Do not agonize.

- Thinking in **SQL** goes to DuckDB
- Thinking in **Python chains** goes to polars

Both, same notebook, same data.

---

## One free upgrade: Parquet

```python
duckdb.sql("COPY (SELECT * FROM 'trips.csv') TO 'trips.parquet'")
```

- 5 to 10 times smaller on disk
- much faster to query
- **types are remembered**, so no more dates read as strings

> **CSV is for receiving data. Parquet is for keeping it.**

```
data/raw/trips.csv              as it arrived. never touched.
data/processed/trips.parquet    what you actually work with
```

---

## Scale: where you actually are

| Data size | Tool |
|---|---|
| under 1 GB | polars or pandas, in memory |
| **1 to 100 GB** | **DuckDB**. You will live here for years. |
| 100 GB to a few TB | DuckDB on partitioned Parquet |
| beyond that | Spark, and you would have a cluster and a team |

**On Spark:** learn it after you can already do the analysis. Then you are learning a
distribution strategy, not learning data work through the hardest possible lens. At
that point it is a week, not a month.

---

## When you need a real database

DuckDB reads files. It cannot be a shared database for a running app. When you build
something with users, you need Postgres.

Do not keep a compose file lying around for that day. **Ask Claude to write one into
the project that needs it.** Nine lines, written correctly, in the right place.

But know the one thing that gets forgotten:

> **Any database container needs a named volume, or the data is wiped on every restart.**

```yaml
volumes:
  - dbdata:/var/lib/postgresql/data     # the suitcase
```

A container is a hotel room. Clean when you arrive, wiped when you leave. A volume is
your suitcase. That is the line to check before you trust anything with real data.

Also: `docker compose down` keeps the data. `docker compose down -v` deletes it. The
`-v` is the difference between "stop" and "burn the suitcase".

---

## MLflow, if you need it

Only when you are training repeatedly and losing track of which run gave which number.
No server required:

```python
import mlflow
mlflow.set_tracking_uri("file:./mlruns")
```

Logs to a folder in your project. `mlflow ui` to look at it. Add a real server only if
runs need sharing across machines. They do not.

---

## Deliberately not here

| | Why |
|---|---|
| **MinIO** | Fakes S3 locally. Useful when building pipelines against a company's real S3. |
| **Spark** | See above. |
| **Dagster / Airflow** | Schedules pipelines you do not have yet. |
| **A standing Postgres compose file** | Belongs in the project that needs it, written on demand. |

Add each the day you hit the wall it solves.

---

## Housekeeping

Docker quietly eats disk. Once a month:

```bash
docker system df          # what is using space
docker image prune -a     # remove unused images
docker builder prune      # build cache, usually the biggest offender
```

Avoid `docker system prune -a --volumes` unless you mean it. That deletes your databases.
