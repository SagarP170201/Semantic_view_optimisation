-- Semantic View Optimisation - Customer Access Setup
-- -------------------------------------------------------
-- Fill in the placeholders below and have your Snowflake admin run this script.
--
--   <se_username>   : username to create for the Snowflake SE (e.g. se_sagar)
--   <temp_password> : temporary password — SE will change on first login
--   <se_role>       : role name to create for the SE (e.g. snowflake_se_role)
--   <db>            : database containing the semantic view
--   <schema>        : schema containing the semantic view
--   <semantic_view> : name of the semantic view
--   <warehouse>     : warehouse to use


-- ================================================================
-- STEP 1: Create a dedicated user and role for the Snowflake SE
-- ================================================================

CREATE ROLE IF NOT EXISTS <se_role>;

CREATE USER IF NOT EXISTS <se_username>
    PASSWORD           = '<temp_password>'
    DEFAULT_ROLE       = <se_role>
    MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE <se_role> TO USER <se_username>;


-- ================================================================
-- STEP 2: Grant access — always required
-- Gives the SE access to read the semantic view and run validation queries.
-- ================================================================

GRANT USAGE ON DATABASE <db>                               TO ROLE <se_role>;
GRANT USAGE ON SCHEMA <db>.<schema>                        TO ROLE <se_role>;
GRANT SELECT ON SEMANTIC VIEW <db>.<schema>.<semantic_view> TO ROLE <se_role>;
GRANT SELECT ON ALL TABLES IN SCHEMA <db>.<schema>         TO ROLE <se_role>;
GRANT USAGE ON WAREHOUSE <warehouse>                       TO ROLE <se_role>;


-- ================================================================
-- STEP 3 (optional): Allow the SE to push the optimised view back directly.
-- Skip this if you prefer to receive the updated file and deploy it yourself.
-- ================================================================

-- GRANT CREATE SEMANTIC VIEW ON SCHEMA <db>.<schema> TO ROLE <se_role>;


-- ================================================================
-- STEP 4 (optional): Allow the SE to use real usage logs to prioritise fixes.
-- This surfaces which questions are failing in production.
-- ================================================================

-- GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_REQUESTS_VIEWER TO ROLE <se_role>;


-- ================================================================
-- Smoke test — run as <se_role> once all grants are in place
-- ================================================================

USE ROLE <se_role>;
USE WAREHOUSE <warehouse>;

DESCRIBE SEMANTIC VIEW <db>.<schema>.<semantic_view>;
SELECT SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW('<db>.<schema>.<semantic_view>');
