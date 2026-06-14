.DEFAULT_GOAL := help

TERRAFORM_DIR := terraform
DEPLOY_USER   := deploy

.PHONY: help init plan apply destroy

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  init       Initialize Terraform providers"
	@echo "  plan       Show Terraform execution plan"
	@echo "  apply      Provision infrastructure with Terraform"
	@echo "  destroy    Destroy all infrastructure"

init:
	cd $(TERRAFORM_DIR) && terraform init

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
