#!/bin/sh

# This script runs the /vault-agent/postgres2kv.sh script after adjusting permissions

# Only run if the KV_PATH environment variable is set
echo "KV_PATH: ${KV_PATH}"
[[ -z ${KV_PATH} ]] && exit 0

echo "Storing dynamic secret in KV"
set +e
export VAULT_TOKEN=$(cat /vault-agent/token)
vault token lookup
chmod +x /vault-agent/postgres2kv.sh
/vault-agent/postgres2kv.sh
exit 0