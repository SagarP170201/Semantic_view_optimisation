# Semantic View Optimisation — Access Setup

Before kicking off the optimisation session, a Snowflake admin needs to run the script below against your account. It gives the Snowflake SE the minimum access needed to read your semantic view and validate queries against your data.

Fill in the placeholders in `customer_access_setup.sql` and have your admin run it. Once that's done, share the following:

- Your Snowflake account identifier
- The fully qualified semantic view name (`db.schema.semantic_view`)
- The warehouse your agent uses
- A few example questions your users ask (optional but helpful)
