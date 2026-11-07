# Part 2: NumPy and Pandas

This part explores the GB, IN, and US trending-video CSVs with NumPy and
Pandas. The notebook covers array operations, data cleaning, filtering,
category joins, aggregations, publishing-time patterns, and channel summaries.

## Install and run

From the repository root, create and activate a virtual environment, then
install the packages used by the notebook:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install numpy pandas jupyter ipykernel
```

On Windows PowerShell, activate with:

```powershell
.\.venv\Scripts\Activate.ps1
```

Start Jupyter from either the repository root or this directory, and open
`part2_numpy_pandas/np&pddatawra.ipynb` (from the repository root) or
`np&pddatawra.ipynb` (from this directory):

```bash
jupyter lab
```

Select the `.venv` Python kernel, then run the notebook cells from top to
bottom. Keep `GBvideos.csv`, `INvideos.csv`, `USvideos.csv`, and
`categories.csv` in `part2_numpy_pandas/data/`. The notebook locates that
folder when launched from the repository root or the Part 2 directory.

## Engagement score

The notebook min-max normalizes views, likes, and comments, then computes:

```text
engagement_score = 0.20 * normalized_views
                 + 0.50 * normalized_likes
                 + 0.30 * normalized_comments
```

Likes and comments receive 80% of the weight together because they reflect
active audience responses; views contribute 20% as a reach measure. Min-max
normalization puts all three metrics on the same 0–1 scale before combining
them. Missing metrics are treated as zero for this score only. This is a
descriptive learning metric, not a platform-standard ranking.

## Data-quality findings and decisions

Counts below are from the three raw files combined (46,230 rows before
deduplication). Percentages use that raw row count.

| Finding | Count | Percentage | Decision |
|---|---:|---:|---|
| Missing `likes` | 12 | 0.0260% | Preserve as nullable integers in the cleaned DataFrames. Use zero only in a separate analysis copy when a calculation requires a value; missing does not necessarily mean zero likes. |
| Missing `comment_count` | 36 | 0.0779% | Preserve as nullable integers; fill with zero only in calculation-specific copies, for the same reason. |
| Missing `description` | 1,624 | 3.5129% | Preserve as missing. Descriptions are optional text and are not needed for the numeric analyses. |
| `tags` equal to `[none]` | 3,785 | 8.1873% | Convert this source placeholder to a missing value. It indicates that no tags were supplied; it is not a literal tag. |
| Duplicate country/video/date rows | 230 extra rows | 0.4975% of raw rows | Remove extra copies, keeping the first row for each `(country, video_id, trending_date)` key. |
| `video_error_or_removed` is true | 92 | 0.1990% | Keep the records and status flag; do not silently exclude them from the learning dataset. |
| `comments_disabled` is true | 1,048 | 2.2669% | Keep the records and flag; this describes comment availability, not invalidity. |
| `ratings_disabled` is true | 544 | 1.1767% | Keep the records and flag for the same reason. |

Duplicate detection uses `(country, video_id, trending_date)`: one video can
legitimately appear on multiple trending dates, and a video in different
country files is a separate observation. There are 75 duplicate rows in GB, 75
in IN, and 80 in US. Removing them leaves 46,000 records. The `[none]` tag
placeholder was counted before conversion; after deduplication and
normalization, 3,774 tag values are missing.

The raw files also contain 0 invalid or missing date values, 0 trending dates
before the publish calendar date, 0 invalid numeric values, 0 negative metric
values, and 0 missing or blank video IDs, titles, or channel names. The
`trending_date` values are parsed with `%y.%d.%m`; `publish_time` is parsed as
UTC. No rows were removed for missing required identity/date fields.
