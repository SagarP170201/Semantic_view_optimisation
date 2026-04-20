# Semantic View Optimisation — Customer Setup

Use this repo to prepare a customer environment before running the **Semantic View Optimisation** skill in Cortex Code.

---

## Files

| File | Purpose |
|---|---|
| `customer_access_setup.sql` | SQL grants to share with the customer's Snowflake admin |
| `connections_template.toml` | Template block to add to `~/.snowflake/connections.toml` on your laptop |

---

## Step-by-step

### 1. Info to get from the customer

- Fully qualified semantic view name: `<db>.<schema>.<semantic_view>`
- Warehouse name their agent uses
- A few real user questions they care about (for VQR validation)
- Their Snowflake account identifier

### 2. Send `customer_access_setup.sql` to their admin

Fill in the placeholders and ask their admin to run it.

**Tier 1 (always required)** — enables YAML download + SQL validation:
```sql
GRANT USAGE ON DATABASE <db> TO ROLE <your_role>;
GRANT USAGE ON SCHEMA <db>.<schema> TO ROLE <your_role>;
GRANT USAGE ON SEMANTIC VIEW <db>.<schema>.<semantic_view> TO ROLE <your_role>;
GRANT SELECT ON ALL TABLES IN SCHEMA <db>.<schema> TO ROLE <your_role>;
GRANT USAGE ON WAREHOUSE <warehouse> TO ROLE <your_role>;
```

**Tier 2 (optional)** — only if you will push the optimised view back directly:
```sql
GRANT CREATE SEMANTIC VIEW ON SCHEMA <db>.<schema> TO ROLE <your_role>;
```

**Tier 3 (optional, recommended)** — enables log-driven optimisation using real usage data:
```sql
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_REQUESTS_VIEWER TO ROLE <your_role>;
```

> **Note:** No `CORTEX_ANALYST_USER` or `CORTEX_USER` database role is needed.
> The skill calls Cortex Analyst via the REST API — your session token is sufficient.

### 3. Configure your connection

Add the block from `connections_template.toml` to `~/.snowflake/connections.toml`, filling in the customer's account details.

### 4. Smoke test

```sql
USE ROLE <your_role>;
USE WAREHOUSE <warehouse>;
DESCRIBE SEMANTIC VIEW <db>.<schema>.<semantic_view>;
SELECT SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW('<db>.<schema>.<semantic_view>');
```

### 5. Run the optimisation skill in Cortex Code

Open Cortex Code, set your connection to the customer connection, then say:

> "Use the semantic view optimisation skill to audit and optimise `<db>.<schema>.<semantic_view>`."

---

## What the skill does

1. Downloads the semantic view YAML via `SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW()`
2. Runs all verified queries (VQRs) through Cortex Analyst and validates the generated SQL
3. Checks best practices (descriptions, synonyms, relationships, metrics)
4. Proposes optimisations — **nothing is applied without your approval**
5. Optionally uploads the improved semantic view back to Snowflake
