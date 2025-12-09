-- 03_positioning_score.sql
-- Compute Positioning Score for all unified users using configurable weights from scoring_config.

WITH cfg AS (
  SELECT metric, weight FROM scoring_config WHERE score_name = 'positioning'
),
metrics AS (
  SELECT
    u.unified_user_id,
    -- normalize to 0..1 using simple caps
    LEAST(1.0, COALESCE(u.avg_pages_viewed,0) / 10.0) AS engagement,
    LEAST(1.0, COALESCE(u.total_onchain_value,0) / 1000.0) AS value_activity,
    LEAST(1.0, COALESCE(u.total_time_spent,0) / 3600.0) AS retention,
    -- trust proxy: combination of wallet_networth and session longevity
    LEAST(1.0, COALESCE(u.wallet_networth,0) / 10000.0) AS wallet_trust,
    (CASE WHEN u.first_visit IS NOT NULL AND u.last_visit IS NOT NULL
          THEN LEAST(1.0, EXTRACT(EPOCH FROM (u.last_visit - u.first_visit)) / (3600*24*30))
          ELSE 0 END) AS repeat_visits_months
  FROM unified_user u
),
pos AS (
  SELECT
    m.unified_user_id,
    (
      m.engagement * (SELECT weight FROM cfg WHERE metric='engagement')
      + ((m.wallet_trust + m.repeat_visits_months)/2.0) * (SELECT weight FROM cfg WHERE metric='trust')
      + m.value_activity * (SELECT weight FROM cfg WHERE metric='value_activity')
      + m.retention * (SELECT weight FROM cfg WHERE metric='retention')
    ) AS raw_score
  FROM metrics m
)
SELECT
  unified_user_id,
  ROUND(GREATEST(0, LEAST(100, raw_score * 100))::numeric,2) AS positioning_score
FROM pos
ORDER BY positioning_score DESC
LIMIT 1000;
