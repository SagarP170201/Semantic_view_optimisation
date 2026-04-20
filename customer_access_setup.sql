-- Semantic View Optimisation - Customer Access Setup
-- -------------------------------------------------------
-- Fill in the placeholders below and send to the customer's Snowflake admin.
--
--   <your_role>     : the role you'll connect with
--   <db>            : database containing the semantic view
--   <schema>        : schema containing the semantic view
--   <semantic_view> : name of the semantic view
--   <warehouse>     : warehouse to use


-- TIER 1: Always required
-- Gives you access to download the semantic view and run validation queries.

GRANT USAGE ON DATABASE <db>                               TO ROLE <your_role>;
GRANT USAGE ON SCHEMA <db>.<schema>                        TO ROLE <your_role>;
GRANT USAGE ON SEMANTIC VIEW <db>.<schema>.<semantic_view> TO ROLE <your_role>;
GRANT SELECT ON ALL TABLES IN SCHEMA <db>.<schema>         TO ROLE <your_role>;
GRANT USAGE ON WAREHOUSE <warehouse>                       TO ROLE <your_role>;


-- TIER 2: Uncomment if you want to push the optimised view back directly.
-- Skip this if you'll hand the updated file back to them to deploy themselves.

-- GRANT CREATE SEMANTIC VIEW ON SCHEMA <db>.<schema> TO ROLE <your_role>;


-- TIER 3: Uncomment if you want to use real usage logs to drive the optimisation.
-- This surfaces which questions are actually failing in production.

-- GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_REQUESTS_VIEWER TO ROLE <your_role>;


-- Smoke test — run as <your_role> once grants are in place
USE ROLE <your_role>;
USE WAREHOUSE <warehouse>;

DESCRIBE SEMANTIC VIEW <db>.<schema>.<semantic_view>;
SELECT SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW('<db>.<schema>.<semantic_view>');
