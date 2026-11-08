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