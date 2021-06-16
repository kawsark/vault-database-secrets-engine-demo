#!/bin/bash

export VAULT_ADDR=http://localhost:8200
# This exports VAULT_ADDR and VAULT_TOKEN based on initialization output in vault.txt
export VAULT_TOKEN=$(cat vault.txt | jq -r '.root_token')

# Export role and secret IDs
cd ../../terraform
export ROLE_ID=$(terraform output role_ids | grep app-1234 | tr -d '"' | awk '{print $NF}')
echo ${ROLE_ID} > ../docker-compose/vault-agent/role_id
export SECRET_ID=$(terraform output secret_ids | grep app-1234 | tr -d '"' | awk '{print $NF}')
echo ${SECRET_ID} > ../docker-compose/vault-agent/secret_id

# Login test
vault write -format=json auth/approle/login role_id=$ROLE_ID secret_id=$SECRET_ID > ../docker-compose/vault-agent/login.json
APP_TOKEN=$(cat ../docker-compose/vault-agent/login.json | jq -r .auth.client_token)

# Restart the Vault agent container
cd ../

# docker compose restart vault-agent
