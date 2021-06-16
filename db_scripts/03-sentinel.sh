#!/bin/sh

echo "Configuring the database secrets engine for Postgres for the root user"

# TODO: Make this more specific?
vault write sys/policies/egp/cidr-check \
        policy=@policies/sentinel/cidr-check.sentinel \
        paths="*" \
        enforcement_level="hard-mandatory"

vault read sys/policies/egp/cidr-check

echo "Done."
