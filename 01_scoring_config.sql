-- 01_scoring_config.sql
-- Create a config table to hold scoring weights for different score types.

CREATE TABLE IF NOT EXISTS scoring_config (
  score_name TEXT NOT NULL,
  metric TEXT NOT NULL,
  weight NUMERIC NOT NULL,
  PRIMARY KEY (score_name, metric)
);

-- Example inserts (customize weights as needed)
INSERT INTO scoring_config (score_name, metric, weight) VALUES
  ('positioning','engagement',0.25) ON CONFLICT DO NOTHING,
  ('positioning','trust',0.25) ON CONFLICT DO NOTHING,
  ('positioning','value_activity',0.25) ON CONFLICT DO NOTHING,
  ('positioning','retention',0.25) ON CONFLICT DO NOTHING;

INSERT INTO scoring_config (score_name, metric, weight) VALUES
  ('upsell','feature_depth',0.4) ON CONFLICT DO NOTHING,
  ('upsell','tx_momentum',0.3) ON CONFLICT DO NOTHING,
  ('upsell','retention',0.3) ON CONFLICT DO NOTHING;
