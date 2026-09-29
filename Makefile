.DEFAULT_GOAL := help

TERRAFORM_DIR := terraform
ANSIBLE_DIR   := ansible
DEPLOY_USER   := deploy
SSH_KEY       := ~/.ssh/deploy

.PHONY: help init plan apply configure destroy ssh servers

help:
	@echo "  init        download Terraform providers"
	@echo "  plan        preview all changes"
	@echo "  apply       create/update servers"
	@echo "  configure   configure servers using Ansible"
	@echo "  destroy     destroy all resources"
	@echo "  servers     list all servers with IPs"
	@echo "  ssh         SSH into a server [SERVER=name]"

init:
	cd $(TERRAFORM_DIR) && terraform init

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve
	cd $(TERRAFORM_DIR) && terraform output -json server_ips | \
		jq -r '"[all]", (to_entries[] | "\(.key) ansible_host=\(.value)")' \
		> ../$(ANSIBLE_DIR)/inventory/hosts.ini

configure:
	cd $(ANSIBLE_DIR) && ansible-playbook site.yml $(if $(SSH_USER),-u $(SSH_USER),)

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

servers:
	cd $(TERRAFORM_DIR) && terraform output -json server_ips | jq -r 'to_entries[] | "\(.key)\t\(.value)"'

ssh:
	DEPLOY_USER=$(DEPLOY_USER) SSH_KEY=$(SSH_KEY) SERVER=$(SERVER) ./scripts/ssh.sh
