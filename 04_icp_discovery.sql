-- 04_icp_discovery.sql
-- Identify top 20% users by total_onchain_value and aggregate common attributes to derive ICP signals.

WITH ranked AS (
  SELECT
    unified_user_id,
    total_onchain_value,
    avg_pages_viewed,
    wallet_chain,
    total_events,
    NTILE(5) OVER (ORDER BY total_onchain_value DESC) AS value_quintile
  FROM unified_user
),
top20 AS (
  SELECT * FROM ranked WHERE value_quintile = 1
)
SELECT
  COUNT(*) AS top_count,
  ROUND(AVG(total_onchain_value)::numeric,2) AS avg_value,
  ROUND(AVG(avg_pages_viewed)::numeric,2) AS avg_pages,
  MODE() WITHIN GROUP (ORDER BY wallet_chain) AS common_chain,
  ROUND(AVG(total_events)::numeric,2) AS avg_events
FROM top20;

-- Example: to list top attributes by frequency:
SELECT wallet_chain, COUNT(*) AS cnt
FROM top20
GROUP BY wallet_chain
ORDER BY cnt DESC
LIMIT 10;
