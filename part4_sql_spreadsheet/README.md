# Part 4: SQL and Spreadsheets

## Prepare the CSV tables

The raw GB, IN, and US trending files and `categories.csv` are stored in this
Part's `data/` folder. From the repository root, run:

```bash
python -m pip install -r part4_sql_spreadsheet/requirements.txt
python part4_sql_spreadsheet/prepare_data.py
```

The Pandas script prepares three import-ready tables in the same folder:

- `categories_clean.csv`: distinct category IDs and names, sorted by ID.
- `videos.csv`: one row per unique `video_id`, containing video metadata and
  `category_id`.
- `trending_records.csv`: one row per video, country, and trending date,
  containing views, likes, dislikes, and comment counts.

The script concatenates the three country files with a `country` column,
removes duplicate `(country, video_id, trending_date)` rows, excludes records
flagged as removed or erroneous, and checks that every video category has a
category-table entry. Video metadata is consistent across country records for
the same video ID; the script keeps one deterministic copy. Dates in
`trending_records.csv` are converted from `yy.dd.mm` to ISO `YYYY-MM-DD`.
Missing likes and comment counts remain missing rather than being replaced
with zero.

The prepared tables contain 17 categories, 14,688 videos, and 45,908 trending
records. The script can be rerun to regenerate them from the raw CSVs.

## MySQL schema

Run [`schema.sql`](./schema.sql) in MySQL Workbench to create the
`trendpulse_analytics` database, tables, load the prepared CSVs, and run
`SELECT COUNT(*)` for each table. The `LOAD DATA LOCAL INFILE` paths in the
script match this checkout; update the repository path if needed. If MySQL
rejects local file loading, enable `LOCAL INFILE` in the MySQL server and
Workbench connection settings, or import each CSV with Workbench's Table Data
Import Wizard in this order: `categories_clean.csv` → `categories`, `videos.csv`
→ `videos`, and `trending_records.csv` → `trending_records`.

The loader maps empty likes and comment counts to SQL `NULL`; it accepts
boolean values as either `True`/`False` or `0`/`1`, and converts UTC publish
timestamps into MySQL `DATETIME`.
The SQL file's count queries should return **17 categories**, **14,688 videos**,
and **45,908 trending records** after loading. Run the file against an empty
schema (or clear existing rows first) to avoid primary-key or unique-key
conflicts on repeat imports.

## Basic queries

Run [`basic_queries.sql`](./basic_queries.sql) in MySQL Workbench after loading
the tables. It demonstrates `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `DISTINCT`,
column aliases, joins, `GROUP BY`, aggregate functions, and `HAVING`. The first
query returns the top 10 most-viewed GB trending records; the second lists
distinct country/category pairs. The grouped queries return categories whose
average views exceed 1,000,000 and channels with at least five distinct
trending videos.
