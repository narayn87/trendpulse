# Part 3: Visualization and EDA

## Combined data profile

Run the profile in `visualizeeda.ipynb`, or from this folder or the repository
root with `python part3_visualization_eda/visualizationeda.py`. It combines
the GB, IN, and US files, adds a `country` column, and maps each `category_id`
to its `category_name`. Before profiling, it removes duplicate
`(country, video_id, trending_date)` records, excludes records marked by
`video_error_or_removed`, and replaces the `[none]` tags placeholder with a
missing value. Both versions report the cleaned shape, every column's data
type, and missing-value percentages for columns that contain missing values.

The notebook then uses Matplotlib to plot record counts by category, a
log-scaled views histogram, views versus likes, daily trending-record counts
by country, and views by category. The scatter plot is sampled for
readability; the daily chart and scatter plot include country legends.

It also creates two interactive Plotly charts: a sampled views-versus-likes
scatter plot with category colors and video-title hover labels, and a grouped
bar chart comparing average views by category and country. Install the
visualization dependencies from the repository root with
`pip install -r part3_visualization_eda/requirements.txt`.
