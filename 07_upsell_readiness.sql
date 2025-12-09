-- 07_upsell_readiness.sql
-- Compute Upsell Readiness Scores for unified users

WITH metrics AS (
  SELECT
    u.unified_user_id,
    LEAST(1.0, COALESCE(u.avg_pages_viewed,0) / 10.0) AS feature_depth,
    LEAST(1.0, COALESCE(u.total_onchain_value,0) / 1000.0) AS tx_momentum,
    LEAST(1.0, COALESCE(u.total_time_spent,0) / 3600.0) AS retention
  FROM unified_user u
),
cfg AS (
  SELECT metric, weight FROM scoring_config WHERE score_name='upsell'
)
SELECT
  m.unified_user_id,
  ROUND(100 * (
    (m.feature_depth * (SELECT weight FROM cfg WHERE metric='feature_depth'))
    + (m.tx_momentum * (SELECT weight FROM cfg WHERE metric='tx_momentum'))
    + (m.retention * (SELECT weight FROM cfg WHERE metric='retention'))
  ),2) AS upsell_score
FROM metrics m
ORDER BY upsell_score DESC
LIMIT 1000;
