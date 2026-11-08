USE trendpulse_analytics;

-- SELECT, WHERE, aliases, ORDER BY, and LIMIT:
-- Top 10 most-viewed trending records in Great Britain.
SELECT
    tr.video_id AS video_id,
    v.title AS video_title,
    c.category_name AS category,
    tr.trending_date AS trending_date,
    tr.views AS view_count
FROM trending_records AS tr
JOIN videos AS v
    ON v.video_id = tr.video_id
JOIN categories AS c
    ON c.category_id = v.category_id
WHERE tr.country = 'GB'
ORDER BY tr.views DESC, tr.trending_date DESC, tr.video_id
LIMIT 10;

-- DISTINCT countries and categories represented in trending records.
SELECT DISTINCT
    tr.country AS country_code,
    c.category_name AS category
FROM trending_records AS tr
JOIN videos AS v
    ON v.video_id = tr.video_id
JOIN categories AS c
    ON c.category_id = v.category_id
ORDER BY country_code, category;

-- GROUP BY and HAVING:
-- Categories with average views above 1,000,000 per trending record.
SELECT
    c.category_name AS category,
    COUNT(*) AS trending_record_count,
    ROUND(AVG(tr.views), 2) AS average_views
FROM trending_records AS tr
JOIN videos AS v
    ON v.video_id = tr.video_id
JOIN categories AS c
    ON c.category_id = v.category_id
GROUP BY c.category_id, c.category_name
HAVING AVG(tr.views) > 1000000
ORDER BY average_views DESC;

-- Channels with at least five distinct videos that appeared in trending records.
SELECT
    v.channel_title AS channel,
    COUNT(DISTINCT tr.video_id) AS distinct_trending_videos,
    COUNT(*) AS trending_record_count
FROM trending_records AS tr
JOIN videos AS v
    ON v.video_id = tr.video_id
GROUP BY v.channel_title
HAVING COUNT(DISTINCT tr.video_id) >= 5
ORDER BY distinct_trending_videos DESC, channel;

-- INNER JOIN: show trending records with their required video and category data.
-- This returns only records that match a video and category, which is the
-- correct choice when the result must include all three entities.
SELECT
    tr.record_id AS record_id,
    tr.country AS country_code,
    tr.trending_date AS trending_date,
    v.title AS video_title,
    c.category_name AS category,
    tr.views AS view_count
FROM trending_records AS tr
INNER JOIN videos AS v
    ON v.video_id = tr.video_id
INNER JOIN categories AS c
    ON c.category_id = v.category_id
ORDER BY tr.views DESC
LIMIT 20;

-- LEFT JOIN: find categories that have no video in the prepared video table.
-- Starting from all categories preserves unused categories; an INNER JOIN
-- would discard them and could not answer this question.
SELECT
    c.category_id AS category_id,
    c.category_name AS category
FROM categories AS c
LEFT JOIN videos AS v
    ON v.category_id = c.category_id
WHERE v.video_id IS NULL
ORDER BY c.category_id;

-- RIGHT JOIN: audit that every trending record has matching video metadata.
-- The RIGHT JOIN preserves every trending record, including any orphaned row;
-- an INNER JOIN would hide those rows. The expected result is empty because
-- the schema's foreign key requires every record to reference a video.
SELECT
    tr.record_id AS record_id,
    tr.video_id AS video_id,
    tr.country AS country_code,
    tr.trending_date AS trending_date
FROM videos AS v
RIGHT JOIN trending_records AS tr
    ON v.video_id = tr.video_id
WHERE v.video_id IS NULL
ORDER BY tr.country, tr.trending_date, tr.record_id;
