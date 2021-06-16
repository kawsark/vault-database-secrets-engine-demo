.DEFAULT_GOAL := info

all: clean up-detach init terraform approle token

.PHONY: clean up up-detach init terraform approle

up:
	cd docker-compose \
	  && docker compose up

up-detach:()
	cd docker-compose \
	  && docker compose up --detach

init:
	cd docker-compose/scripts \
	  && ./init.sh
	export PGPASSWORD=password \
	  && psql -h localhost -p 5432 -d products -U postgres --file=docker-compose/scripts/pg_createuser.sql

terraform:
	rm -rf terraform/terraform.tfstate*
	rm -rf terraform/.terraform
	cd docker-compose/scripts \
	  && ./run_terraform.sh

approle:
	cd docker-compose/scripts \
	  && ./approle.sh

clean:
	cd docker-compose \
	  && docker compose down
	rm -rf terraform/terraform.tfstate*
	rm -rf terraform/.terraform
	rm -f docker-compose/vault-agent/role_id
	rm -f docker-compose/vault-agent/secret_id
	rm -f docker-compose/vault-agent/login.json
	rm -f docker-compose/vault-agent/token
	rm -f docker-compose/scripts/vault.txt
	rm -f docker-compose/nginx/index.html
	rm -f docker-compose/nginx/previous.txt

token:
	cat docker-compose/scripts/vault.txt | jq -r .root_token

license:
	./apply_license.sh

agent:
	helm install consul-k8s -f consul-k8s.values.yaml .

upgrade:
	helm upgrade consul-k8s -f consul-k8s.values.yaml .
