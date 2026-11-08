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
`trendpulse_analytics` database and its related tables. Import the prepared
CSVs in foreign-key order: `categories_clean.csv` into `categories`,
`videos.csv` into `videos`, and `trending_records.csv` into `trending_records`.
The columns are aligned with the schema; `record_id` is auto-generated when
importing trending records.
