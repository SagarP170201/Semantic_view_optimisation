# Semantic View Optimisation — Access Setup

Before kicking off the optimisation session, a Snowflake admin needs to run the script below against your account. It gives the Snowflake SE the minimum access needed to read your semantic view and validate queries against your data.

---

## What the admin needs to do

1. Open `customer_access_setup.sql`
2. Fill in all `<placeholders>` at the top of the file
3. Run the full script against your Snowflake account as `ACCOUNTADMIN` (or a role with `CREATE USER` and `GRANT` privileges)

The script will:
- Create a dedicated user and role for the Snowflake SE
- Grant the SE read access to the semantic view and underlying tables
- Include optional steps for write-back and usage log access (commented out by default)
- Run a smoke test to confirm everything is working

---

## What to share once the script has run

- Your Snowflake account identifier (e.g. `abc12345.us-east-1`)
- The username and temporary password created in Step 1 of the script
- The fully qualified semantic view name (`db.schema.semantic_view`)
- The warehouse name
- A few example questions your users ask (optional but helpful)

---

## Connection setup (for reference)

The SE will add your account to their local Snowflake config using the credentials above. No additional access is needed beyond what the script grants.
