CREATE DATABASE IF NOT EXISTS trendpulse_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE trendpulse_analytics;

CREATE TABLE categories (
    category_id INT UNSIGNED NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_categories_category_name (category_name)
) ENGINE = InnoDB;

CREATE TABLE videos (
    video_id VARCHAR(32) NOT NULL,
    title VARCHAR(500) NOT NULL,
    channel_title VARCHAR(255) NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    publish_time DATETIME NOT NULL COMMENT 'Source timestamp stored as UTC',
    tags TEXT NULL,
    thumbnail_link VARCHAR(2048) NULL,
    comments_disabled BOOLEAN NOT NULL DEFAULT FALSE,
    ratings_disabled BOOLEAN NOT NULL DEFAULT FALSE,
    video_error_or_removed BOOLEAN NOT NULL DEFAULT FALSE,
    description TEXT NULL,
    PRIMARY KEY (video_id),
    KEY idx_videos_category_id (category_id),
    CONSTRAINT fk_videos_category
        FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE trending_records (
    record_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    video_id VARCHAR(32) NOT NULL,
    country ENUM('GB', 'IN', 'US') NOT NULL,
    trending_date DATE NOT NULL,
    views BIGINT UNSIGNED NOT NULL,
    likes BIGINT UNSIGNED NULL,
    dislikes BIGINT UNSIGNED NOT NULL,
    comment_count BIGINT UNSIGNED NULL,
    PRIMARY KEY (record_id),
    UNIQUE KEY uq_trending_video_country_date
        (video_id, country, trending_date),
    KEY idx_trending_country_date (country, trending_date),
    CONSTRAINT fk_trending_records_video
        FOREIGN KEY (video_id)
        REFERENCES videos (video_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Import in foreign-key order. These LOCAL INFILE paths match this checkout;
-- update the repository path if it is in a different location.
LOAD DATA LOCAL INFILE '/Users/narayanan/Desktop/trendpulse/part4_sql_spreadsheet/data/categories_clean.csv'
INTO TABLE categories
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(category_id, category_name);

LOAD DATA LOCAL INFILE '/Users/narayanan/Desktop/trendpulse/part4_sql_spreadsheet/data/videos.csv'
INTO TABLE videos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    video_id,
    title,
    channel_title,
    category_id,
    @publish_time,
    @tags,
    @thumbnail_link,
    @comments_disabled,
    @ratings_disabled,
    @video_error_or_removed,
    @description
)
SET
    publish_time = CASE
        WHEN @publish_time LIKE '%Z' THEN STR_TO_DATE(
            REPLACE(REPLACE(@publish_time, 'T', ' '), 'Z', ''),
            '%Y-%m-%d %H:%i:%s.%f'
        )
        ELSE STR_TO_DATE(@publish_time, '%Y-%m-%d %H:%i:%s')
    END,
    tags = NULLIF(@tags, ''),
    thumbnail_link = NULLIF(@thumbnail_link, ''),
    comments_disabled = CASE
        WHEN @comments_disabled IN ('True', '1') THEN TRUE
        ELSE FALSE
    END,
    ratings_disabled = CASE
        WHEN @ratings_disabled IN ('True', '1') THEN TRUE
        ELSE FALSE
    END,
    video_error_or_removed = CASE
        WHEN @video_error_or_removed IN ('True', '1') THEN TRUE
        ELSE FALSE
    END,
    description = NULLIF(@description, '');

LOAD DATA LOCAL INFILE '/Users/narayanan/Desktop/trendpulse/part4_sql_spreadsheet/data/trending_records.csv'
INTO TABLE trending_records
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    video_id,
    country,
    trending_date,
    views,
    @likes,
    dislikes,
    @comment_count
)
SET
    likes = NULLIF(@likes, ''),
    comment_count = NULLIF(@comment_count, '');

-- Expected counts from the prepared CSV files:
-- categories: 17; videos: 14688; trending_records: 45908.
SELECT COUNT(*) AS categories_row_count FROM categories;
SELECT COUNT(*) AS videos_row_count FROM videos;
SELECT COUNT(*) AS trending_records_row_count FROM trending_records;

