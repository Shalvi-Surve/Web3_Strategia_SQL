-- 06_attribution_funnel.sql
-- UTM -> wallet connect -> conversion funnel

WITH utm_sessions AS (
  SELECT session_id, utm_source, user_id, wallet_address, start_time FROM sessions WHERE utm_source IS NOT NULL
),
wallet_connected AS (
  SELECT DISTINCT session_id FROM events WHERE event_name = 'Wallet Connected'
),
conversions AS (
  SELECT DISTINCT session_id FROM transactions
)
SELECT
  utm_source,
  COUNT(DISTINCT utm_sessions.session_id) AS sessions,
  COUNT(DISTINCT wallet_connected.session_id) FILTER (WHERE wallet_connected.session_id IS NOT NULL) AS wallets_connected,
  COUNT(DISTINCT conversions.session_id) FILTER (WHERE conversions.session_id IS NOT NULL) AS conversions,
  ROUND(100.0 * COUNT(DISTINCT conversions.session_id)::numeric / NULLIF(COUNT(DISTINCT utm_sessions.session_id),0), 2) AS conversion_rate_pct
FROM utm_sessions
LEFT JOIN wallet_connected USING(session_id)
LEFT JOIN conversions USING(session_id)
GROUP BY utm_source
ORDER BY conversion_rate_pct DESC;
