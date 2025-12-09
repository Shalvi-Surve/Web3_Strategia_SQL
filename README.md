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




## 🎯 Purpose

This repo demonstrates:
- Fully SQL-driven analytics pipelines  
- Configurable scoring models  
- Web3 identity stitching  
- Region & source optimization  
- Lifecycle scoring and upsell prediction  
- Secure API layer using API Keys  
- OpenAPI documentation for all endpoints  

This repo is designed to run on:
- PostgreSQL  
- TimescaleDB (recommended for time-series data)  

---

## 🚀 Quick Start

### 1. Install Database Schema
Run all SQL files in the `/SQL` folder in order.

### 2. Generate an API Key
See `API_KEYS.md` (secure generation + DB insert).

### 3. Start Backend
Any backend (Node.js, Python, PostgREST) can wrap these SQL functions as API endpoints.

### 4. Use the API
See `docs/endpoints.md` for full endpoint documentation.

---

## 📄 Documentation

| File | Purpose |
|------|---------|
| **openapi.yaml** | Full API specification (import into Swagger / Postman) |
| **API_KEYS.md** | How API keys are generated, stored, validated |
| **docs/endpoints.md** | Detailed endpoint reference |
| **docs/architecture.md** | Data architecture + flow diagrams |
| **docs/examples.md** | cURL / Postman examples + sample JSON responses |

---

## 🔐 Security & Privacy

- All endpoints use API-key authentication  
- No PII is returned; only `unified_user_id` or aggregated data  
- Wallet addresses can be hashed or redacted  
- Configurable rate limits and scopes  

---

## 🛠 Tech Used

- PostgreSQL / TimescaleDB  
- SQL analytical models  
- OpenAPI (Swagger) for API documentation  

---

## 👥 Team

**Team CodePhoenix**  
- Shalvi Atul Surve (Team Lead)  
- Adithyan S  

---

## 📬 Contact  
For Clarifications (Competition-related only): Refer to Web3 Strategia platform.
