# Vault Database Secrets Demo

## Dynamic Secrets - Postgres

Log into Postgres.

```bash
psql -U postgres -h localhost -p 5432 # enter "password" for the password
```

View the users in the system.

```bash
SELECT * FROM pg_catalog.pg_user;
```

### Initialize and Setup Vault

First initialize Vault, and be sure to `source` the file to set some env vars.

```bash
source 00-init.sh
```

Then set up Vault for the demo.

```bash
./01-setup.sh
```

### Show Example Passwords

```bash
vault read sys/policies/password/database-example/generate
vault read sys/policies/password/database-short-example/generate
```

### Generate Postgres Dynamic Secrets

```bash
vault read postgres/creds/infosec-postgres-human
vault read postgres/creds/infosec-postgres-app-1234
vault read postgres/creds/infosec-postgres-app-xyz
```

### Update the Password Policy

```bash
./02-change-password-policies.sh
```

### Read Static Postgres Secrets

View the role.

```bash
vault read postgres/static-roles/infosec-static
```

Read the creds.

```bash
vault read postgres/static-creds/infosec-static
```

Show the time based rotation.

```bash
watch -n 1 vault read postgres/static-creds/infosec-static
```

### Sentinel to Lock Down IP Ranges

```bash
./03-sentinel.sh
```

### Postgres Root Credential Rotation

Rotate the root password so it's no longer "password".

```bash
vault write -force database/rotate-root/example-postgresql-database
```

Demonstrate that you can no longer sign into the Postgres database using the password from earlier.

```bash
psql -U postgres -h localhost -p 5432 # "password" should fail now
```
