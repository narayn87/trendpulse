from pathlib import Path

import pandas as pd


DATA_DIR = Path(__file__).parent / "data"
COUNTRIES = ("GB", "IN", "US")
RECORD_KEY = ["country", "video_id", "trending_date"]
VIDEO_COLUMNS = [
    "video_id",
    "title",
    "channel_title",
    "category_id",
    "publish_time",
    "tags",
    "thumbnail_link",
    "comments_disabled",
    "ratings_disabled",
    "video_error_or_removed",
    "description",
]
TRENDING_COLUMNS = [
    "video_id",
    "country",
    "trending_date",
    "views",
    "likes",
    "dislikes",
    "comment_count",
]


def main() -> None:
    categories = pd.read_csv(DATA_DIR / "categories.csv")
    categories = (
        categories[["category_id", "category_name"]]
        .drop_duplicates(subset="category_id", keep="first")
        .sort_values("category_id")
    )

    country_frames = []
    for country in COUNTRIES:
        frame = pd.read_csv(DATA_DIR / f"{country}videos.csv")
        frame["country"] = country
        country_frames.append(frame)

    trending_records = pd.concat(country_frames, ignore_index=True)
    trending_records = trending_records.drop_duplicates(
        subset=RECORD_KEY, keep="first"
    )
    trending_records = trending_records.loc[
        ~trending_records["video_error_or_removed"]
    ].copy()

    unknown_categories = (
        set(trending_records["category_id"].dropna()) - set(categories["category_id"])
    )
    if unknown_categories:
        raise ValueError(f"Unknown category IDs in video data: {sorted(unknown_categories)}")

    trending_records["trending_date"] = pd.to_datetime(
        trending_records["trending_date"], format="%y.%d.%m", errors="raise"
    ).dt.strftime("%Y-%m-%d")

    videos = (
        trending_records.sort_values(["country", "trending_date", "video_id"])
        .drop_duplicates(subset="video_id", keep="first")
        .loc[:, VIDEO_COLUMNS]
        .sort_values("video_id")
        .reset_index(drop=True)
    )
    trending_records = (
        trending_records.loc[:, TRENDING_COLUMNS]
        .sort_values(["country", "trending_date", "video_id"])
        .reset_index(drop=True)
    )

    categories.to_csv(DATA_DIR / "categories_clean.csv", index=False)
    videos.to_csv(DATA_DIR / "videos.csv", index=False)
    trending_records.to_csv(DATA_DIR / "trending_records.csv", index=False)

    print(f"Categories: {len(categories):,}")
    print(f"Videos: {len(videos):,}")
    print(f"Trending records: {len(trending_records):,}")
    print("Wrote categories_clean.csv, videos.csv, and trending_records.csv.")


if __name__ == "__main__":
    main()
