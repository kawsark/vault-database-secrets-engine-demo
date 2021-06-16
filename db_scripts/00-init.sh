#!/bin/bash

# Init and unseal vault_s1
echo "Initializing Vault..."
export VAULT_ADDR=http://localhost:8200
vault operator init -format=json -n 1 -t 1 > vault.txt

echo "Setting the Vault token..."
export VAULT_TOKEN=$(cat vault.txt | jq -r '.root_token')
echo "export VAULT_TOKEN=$VAULT_TOKEN (don't do this ever)"

echo "Unsealing Vault server 1..."
export unseal_key=$(cat vault.txt | jq -r '.unseal_keys_b64[0]')
vault operator unseal ${unseal_key}
vault token lookup

echo "Unsealing Vault server 2..."
export VAULT_ADDR=http://localhost:18200
vault operator unseal ${unseal_key}

echo "Unsealing Vault server 3..."
export VAULT_ADDR=http://localhost:28200
vault operator unseal ${unseal_key}

# Reset vault addr
export VAULT_ADDR=http://localhost:8200
