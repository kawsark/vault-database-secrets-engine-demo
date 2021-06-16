# Vault Dynamic Database Secrets Engine Demo

## Usage

### Setup Vault, Consul and a Postgres DB

```bash
cd docker-compose
docker-compose up
```

### Initialize and Unseal Vault

```bash
cd scripts
source ./init.sh
```

### Vault Environment Variables for Root

```bash
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=$(cat vault.txt | jq -r '.root_token')
```

### Vault Environment Variables for Users / Apps
```bash
cd terraform
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=$(cat terraform.tfstate | jq -r '.resources[-1].instances[0].attributes.client_token')
```

### Configure the Database Secrets Engine for Static Roles

```bash
cd ../../terraform
terraform init && terraform apply --auto-approve
```

### Read the Static Role

```
TODO
```

### Read the Dynamic Roles

```bash
vault read postgres/creds/INFOSEC-dynamic-postgres-human
vault read postgres/creds/INFOSEC-dynamic-postgres-app-1234
vault read postgres/creds/INFOSEC-dynamic-postgres-app-xyz

vault read postgres/creds/INFOSEC-dynamic-postgres-app-xyz
```

Show that we can log into Postgres with each of these keypairs that are generated.

```bash
TODO
```

# TODO: open up Postgres to show the user


### To show an example webapp reading postgres creds
```bash
make all

# Read vault agent logs
docker logs vault-agent

# Go to this URL to access the App:
http://localhost:8080

# Previous passwords in KV:
http://localhost:8080/previous.txt
```

### Cleanup the Containers

```bash
cd terraform
terraform destroy --auto-approve

cd ../docker-compose
docker compose down
```
