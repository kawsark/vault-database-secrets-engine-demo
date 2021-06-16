#!/bin/sh

echo "Configuring the database secrets engine for Postgres for the root user"
vault write postgres/config/infosec-postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@db:5432?sslmode=disable" \
    username="postgres" \
    password="password" \
    password_policy="database-short-example"

echo "Done."
