# Web3_Strategia_SQL
SQL scripts for the Web3 Strategia submission (Team CodePhoenix - Onchain360)

Contents:
- 01_scoring_config.sql         : create table to store configurable scoring weights
- 02_unified_user.sql          : materialized view to build unified_user from Cryptique schema
- 03_positioning_score.sql     : compute Positioning Score (config-driven)
- 04_icp_discovery.sql         : extract top-20% high-value users and aggregate attributes
- 05_regional_performance.sql  : compute regional performance and ranking
- 06_attribution_funnel.sql    : UTM -> wallet connect -> conversion funnel
- 07_upsell_readiness.sql      : compute Upsell Readiness scores
- 08_lifecycle_segmentation.sql: simple RFM-like lifecycle segmentation
- samples/                     : example JSON & notes (placeholders)

How to use:
1. Adjust table/schema names if your database uses different naming.
2. Load these scripts in PostgreSQL (TimescaleDB recommended for time-series).
3. Ensure `scoring_config` is populated with appropriate weights before running score queries.

Notes:
- These scripts are templates and include comments describing configurable parts.
- They are intentionally generic and avoid PII exposure (return internal unified_user_id or hashed wallets).
