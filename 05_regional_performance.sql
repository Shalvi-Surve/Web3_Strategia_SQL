-- 05_regional_performance.sql
-- Compute region-level performance metrics using sessions and transactions.

SELECT
  s.country,
  COUNT(DISTINCT s.session_id) AS sessions,
  AVG(s.pages_viewed) AS avg_pages,
  SUM(tx.value) AS total_value,
  ROUND( (SUM(tx.value) / NULLIF(COUNT(DISTINCT s.session_id),0))::numeric,2) AS value_per_session,
  ROUND( ( (COALESCE(SUM(tx.value),0) / NULLIF(COUNT(DISTINCT s.session_id),1)) * COALESCE(AVG(s.pages_viewed),0) )::numeric,2) AS region_performance
FROM sessions s
LEFT JOIN transactions tx ON tx.from_address = s.wallet_address OR tx.to_address = s.wallet_address
GROUP BY s.country
ORDER BY region_performance DESC
LIMIT 100;
