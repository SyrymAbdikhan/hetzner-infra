.DEFAULT_GOAL := help

TERRAFORM_DIR := terraform
ANSIBLE_DIR   := ansible
DEPLOY_USER   := deploy
SSH_KEY       := ~/.ssh/deploy

.PHONY: help init plan apply configure destroy ssh

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  init       Initialize Terraform providers"
	@echo "  plan       Show Terraform execution plan"
	@echo "  apply      Provision infrastructure with Terraform"
	@echo "  configure  Configure server with Ansible"
	@echo "  destroy    Destroy all infrastructure"
	@echo "  ssh        Open SSH session as \"deploy\" user"

init:
	cd $(TERRAFORM_DIR) && terraform init

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

configure:
	cd $(ANSIBLE_DIR) && ansible-playbook site.yml $(if $(USER),-u $(USER),)

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

ssh:
	ssh -i $(SSH_KEY) $(DEPLOY_USER)@$$(cd $(TERRAFORM_DIR) && terraform output -raw server_ip)
