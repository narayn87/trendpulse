# Part 1: Python Foundations

This part uses Python and pandas to load and clean video records, explore core
data structures and loops, and classify videos with rules in
[`configure.ipynb`](./configure.ipynb).

## Install and run

From the repository root, create a virtual environment, install the Part 1
dependency plus Jupyter, and launch the notebook:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r part1_python_foundations/requirements.txt notebook ipykernel
jupyter notebook part1_python_foundations/configure.ipynb
```

On Windows, activate the environment with `.venv\Scripts\activate` instead of
the `source` command. Select the `.venv` Python kernel if prompted, then choose
**Restart and Run All**. The notebook searches the current directory and its
parents for `dataset/`, so it can be launched from the repository root or this
folder.

## Countries and files

The notebook loads and combines these country CSVs:

| Country | File | Rows |
|---|---|---:|
| Great Britain (GB) | `dataset/GBvideos.csv` | 15,075 |
| India (IN) | `dataset/INvideos.csv` | 15,075 |
| United States (US) | `dataset/USvideos.csv` | 16,080 |
| Category lookup | `dataset/categories.csv` | 17 |

The country files contain video metadata, views, likes, dislikes, comment
counts, trending and publish dates, and comments/ratings/error flags.
`categories.csv` maps category IDs to names.

## Cleaning rules

The loader checks for the expected video columns. The cleaning step keeps every
row, including duplicates and records flagged `video_error_or_removed`.

- `views`, `likes`, `dislikes`, and `comment_count` are converted to integers;
  missing or invalid values become `0`.
- `comments_disabled`, `ratings_disabled`, and `video_error_or_removed` are
  converted from `true`/`false` or `1`/`0` to booleans; missing or invalid
  values become `False`.
- `trending_date` is parsed from `yy.dd.mm` into a date, and `publish_time` is
  parsed as an ISO datetime. Missing or invalid values become `None`.
- Parse failures are counted and displayed by field. Since a substituted zero
  is indistinguishable from a genuine zero in the cleaned value, consult these
  counts when interpreting metrics.

## Classification thresholds

The notebook calculates the like ratio as
`likes / (likes + dislikes)`. If the total ratings are zero, it returns
**Unrated** without dividing. Thresholds and labels are:

- **Viral Hit:** at least 1,000,000 views, a like ratio of at least `0.90`, and
  comments enabled.
- **Divisive:** at least 100,000 views and a like ratio below `0.65`, unless
  the Viral Hit rule already matched.
- **Steady Performer:** at least 100,000 views and a like ratio of at least
  `0.65` when the Viral Hit rule does not match.
- **Low Engagement:** remaining rated records, including records with zero
  views or fewer than 100,000 views.
- **Unrated:** missing or invalid required metrics/flags, negative counts,
  ratings disabled, or zero total likes and dislikes.

Disabled comments prevent the Viral Hit label but do not prevent
classification by views and ratings.

## Data source

The included files are synthetic, generated with fixed seed 42 by
[`../dataset/generate_dataset.py`](../dataset/generate_dataset.py). They mimic
the schema and selected quirks of the public
*Trending YouTube Video Statistics* dataset; they are not downloaded from the
public dataset and contain no real YouTube statistics. Treat analysis results
as examples using generated data, not conclusions about actual YouTube trends.
See [`../dataset/README.md`](../dataset/README.md) for generation details and
notes on using real files instead.
