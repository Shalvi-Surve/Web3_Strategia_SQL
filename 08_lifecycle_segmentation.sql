-- 08_lifecycle_segmentation.sql
-- Simple RFM-like lifecycle segmentation based on recency, frequency, monetary

WITH rfm AS (
  SELECT
    u.unified_user_id,
    EXTRACT(EPOCH FROM (now() - u.last_visit))/86400.0 AS days_since_last,
    COALESCE(u.total_onchain_value,0) AS monetary,
    COALESCE(u.total_events,0) AS frequency
  FROM unified_user u
)
SELECT unified_user_id,
CASE
  WHEN days_since_last IS NULL THEN 'New'
  WHEN days_since_last <= 14 AND frequency >= 5 THEN 'Active'
  WHEN days_since_last <= 60 AND frequency >= 3 AND monetary > 100 THEN 'Loyal'
  WHEN monetary >= 1000 THEN 'Advocate'
  ELSE 'At-risk'
END AS lifecycle_stage
FROM rfm;
