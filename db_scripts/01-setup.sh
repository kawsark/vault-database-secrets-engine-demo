#!/bin/sh

echo "Creating a database user in Postgres..."
export PGPASSWORD=password
psql -U postgres -h localhost -p 5432 -d products -U postgres --file=sql/pg_createuser.sql

echo "Enabling the database secrets engine..."
vault secrets enable -path=postgres database

echo "Enabling the kv secrets engine..."
vault secrets enable -version=2 kv

echo "Loading the password policies..."
vault write sys/policies/password/database-example policy=@policies/passwords/database-example.hcl
vault write sys/policies/password/database-short-example policy=@policies/passwords/database-short-example.hcl

vault read sys/policies/password/database-example/generate
vault read sys/policies/password/database-short-example/generate

echo "Configuring the database secrets engine for Postgres for the root user"
vault write postgres/config/infosec-postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@db:5432?sslmode=disable" \
    username="postgres" \
    password="password" \
    password_policy="database-example"

echo "Configuring the database secrets engine for some dynamic Postgres roles..."
vault write postgres/roles/infosec-postgres-human \
    db_name=infosec-postgresql \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="30s" \
    max_ttl="24h"

vault write postgres/roles/infosec-postgres-app-1234 \
    db_name=infosec-postgresql \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="30s" \
    max_ttl="24h"

vault write postgres/roles/infosec-postgres-app-xyz \
    db_name=infosec-postgresql \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="30s"

echo "Configuring the database secrets engine for the static Postgres role..."
vault write postgres/static-roles/infosec-static \
    db_name=infosec-postgresql \
    rotation_statements="ALTER USER {{username}} WITH PASSWORD '{{password}}';" \
    username="infosec" \
    rotation_period=30

echo "Done."
