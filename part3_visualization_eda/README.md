# Part 3: Visualization and EDA

## Install

From the repository root, create and activate a virtual environment, then
install the notebook and analysis dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install -r part3_visualization_eda/requirements.txt
```

On Windows, activate the environment with `.venv\Scripts\activate`.

## Run

From the repository root, open the notebook in JupyterLab:

```bash
python -m jupyter lab part3_visualization_eda/visualizeeda.ipynb
```

Alternatively, open `visualizeeda.ipynb` in VS Code with the Jupyter extension
and select the `.venv` Python kernel. Run all cells from top to bottom. The
notebook locates its CSV files whether the working directory is the repository
root or `part3_visualization_eda/`.

## Analysis and results

The notebook combines the GB, IN, and US video files, adds a country label,
maps category IDs to names, removes duplicate `(country, video_id,
trending_date)` records, excludes records flagged by
`video_error_or_removed`, and replaces `[none]` tags with missing values.
It reports the resulting data profile and includes Matplotlib and Plotly
visualizations. Each chart has a written interpretation explaining its
findings and why that chart type fits the variables.

Further notebook sections document the mean, median, mode, skew, and IQR
outlier analysis for views and likes; the numeric correlation heatmap and its
two strongest feature-pair interpretations; and weekly cohort comparisons.
The retention section reports day-2, day-3, day-5, and day-7 rates and
compares Music with News & Politics. The content strategy briefing and all
written interpretations are included in notebook Markdown cells.

The funnel uses unique video IDs and each video's peak views and comments.
Stage conversion is relative to the preceding stage; cumulative conversion is
relative to all videos that ever trended:

| Funnel stage | Videos | Conversion from previous | Conversion from start |
|---|---:|---:|---:|
| Ever trended | 14,688 | 100.00% | 100.00% |
| Peak views above median | 7,344 | 50.00% | 50.00% |
| Peak views above 90th percentile | 1,469 | 20.00% | 10.00% |
| Above 90th percentile and 1,000+ comments | 1,440 | 98.03% | 9.80% |

The largest drop by count is 7,344 videos at the median-view threshold; the
sharpest proportional drop is 80.00% from the above-median stage to the
above-90th-percentile stage. See the notebook for the full interpretation,
retention results, chart interpretations, cohort comparison, and briefing.
