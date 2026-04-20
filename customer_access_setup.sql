-- =============================================================================
-- Semantic View Optimisation - Customer Access Setup
-- =============================================================================
-- Share this script with the customer's Snowflake admin.
-- Replace all <placeholders> before running.
--
-- Variables to fill in:
--   <your_role>      : the role you will connect with (e.g. SAGAR_PAWAR_ROLE)
--   <db>             : database containing the semantic view
--   <schema>         : schema containing the semantic view
--   <semantic_view>  : name of the semantic view to optimise
--   <warehouse>      : warehouse to use for query execution
-- =============================================================================


-- =============================================================================
-- TIER 1: Always required
-- Needed to: download the semantic view YAML, run VQR validation SQL
-- =============================================================================

GRANT USAGE ON DATABASE <db>                             TO ROLE <your_role>;
GRANT USAGE ON SCHEMA <db>.<schema>                      TO ROLE <your_role>;
GRANT USAGE ON SEMANTIC VIEW <db>.<schema>.<semantic_view> TO ROLE <your_role>;
GRANT SELECT ON ALL TABLES IN SCHEMA <db>.<schema>       TO ROLE <your_role>;
GRANT USAGE ON WAREHOUSE <warehouse>                     TO ROLE <your_role>;


-- =============================================================================
-- TIER 2: Write-back (optional)
-- Needed to: push the optimised semantic view back into the customer account
-- Skip if you will hand the updated YAML back to the customer to deploy.
-- =============================================================================

-- GRANT CREATE SEMANTIC VIEW ON SCHEMA <db>.<schema> TO ROLE <your_role>;


-- =============================================================================
-- TIER 3: Log-driven optimisation (optional but recommended)
-- Needed to: analyse real Cortex Analyst usage logs to surface failing queries
-- and prioritise which verified queries to add / fix.
-- =============================================================================

-- GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_REQUESTS_VIEWER TO ROLE <your_role>;


-- =============================================================================
-- Smoke test — run as <your_role> to confirm access before starting
-- =============================================================================

USE ROLE <your_role>;
USE WAREHOUSE <warehouse>;

DESCRIBE SEMANTIC VIEW <db>.<schema>.<semantic_view>;
SELECT * FROM <db>.<schema>.<a_table_in_the_semantic_view> LIMIT 1;
SELECT SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW('<db>.<schema>.<semantic_view>');
