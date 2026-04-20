# Semantic View Optimisation

This repo has everything needed to get access to a customer's Snowflake environment and run a semantic view optimisation session.

---

## Before you start — get these from the customer

- Their Snowflake account identifier
- The fully qualified semantic view name: `db.schema.semantic_view`
- The warehouse their agent uses

---

## Step 1 — Send the customer's admin `customer_access_setup.sql`

Fill in the placeholders (your role, their db/schema/warehouse) and ask their admin to run it. The script is tiered — Tier 1 is the only hard requirement. Uncomment Tier 2 and 3 based on what you need.

| Tier | What it unlocks | Run it? |
|---|---|---|
| 1 | Download the semantic view + validate queries against their data | Always |
| 2 | Push the optimised view back directly into their account | Only if they want you to deploy |
| 3 | Pull real usage logs to see what's actually failing | Recommended |

---

## Step 2 — Add their account to your connection config

Copy the block from `connections_template.toml` into `~/.snowflake/connections.toml` and fill in their account details. Use `externalbrowser` — no passwords needed.

---

## Step 3 — Smoke test before you start

Run this as your role in their account to confirm everything is wired up:

```sql
USE ROLE <your_role>;
USE WAREHOUSE <warehouse>;

DESCRIBE SEMANTIC VIEW <db>.<schema>.<semantic_view>;
SELECT SYSTEM$READ_YAML_FROM_SEMANTIC_VIEW('<db>.<schema>.<semantic_view>');
```

If both come back clean, you're good to go.

---

## Step 4 — Run the optimisation in Cortex Code

Open Cortex Code, connect using the customer connection you just added, and say:

> "Use the semantic view optimisation skill to audit and optimise `db.schema.semantic_view`."

The skill downloads their semantic view, runs all their verified queries through Cortex Analyst, checks for gaps in descriptions/relationships/metrics, and proposes fixes. Nothing gets changed without your sign-off.
