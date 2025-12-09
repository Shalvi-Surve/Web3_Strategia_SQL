-- 02_unified_user.sql
-- Materialized view to create a unified user profile (non-PII internal id)

CREATE MATERIALIZED VIEW IF NOT EXISTS unified_user AS
WITH latest_ui AS (
  SELECT
    ui.user_id,
    ui.primary_wallet_address,
    ui.wallet_networth,
    ui.wallet_chain,
    ui.is_web3_user,
    ui.first_visit,
    ui.last_visit,
    ui.total_time_spent,
    ui.social_telegram, ui.social_discord, ui.social_x
  FROM user_identities ui
),
sessions_agg AS (
  SELECT
    user_id,
    AVG(pages_viewed) AS avg_pages_viewed,
    AVG(duration) AS avg_session_duration,
    COUNT(*) AS session_count,
    SUM(CASE WHEN is_bounce THEN 1 ELSE 0 END)::INT AS bounce_count
  FROM sessions
  GROUP BY user_id
),
tx_agg AS (
  SELECT
    COALESCE(from_address, to_address) AS wallet,
    SUM(value) AS total_value,
    COUNT(*) AS tx_count
  FROM transactions
  GROUP BY COALESCE(from_address, to_address)
),
events_agg AS (
  SELECT user_id, COUNT(*) AS total_events
  FROM events
  GROUP BY user_id
)
SELECT
  lu.user_id AS unified_user_id,
  lu.primary_wallet_address,
  lu.wallet_networth,
  lu.wallet_chain,
  lu.is_web3_user,
  lu.first_visit,
  lu.last_visit,
  lu.total_time_spent,
  COALESCE(s.avg_pages_viewed,0) AS avg_pages_viewed,
  COALESCE(s.avg_session_duration,0) AS avg_session_duration,
  COALESCE(s.session_count,0) AS session_count,
  COALESCE(s.bounce_count,0) AS bounce_count,
  COALESCE(t.total_value,0)::numeric AS total_onchain_value,
  COALESCE(t.tx_count,0) AS tx_count,
  COALESCE(e.total_events,0) AS total_events
FROM latest_ui lu
LEFT JOIN sessions_agg s ON s.user_id = lu.user_id
LEFT JOIN tx_agg t ON t.wallet = lu.primary_wallet_address
LEFT JOIN events_agg e ON e.user_id = lu.user_id;

-- OPTIONAL: Refresh materialized view periodically:
-- REFRESH MATERIALIZED VIEW unified_user;
