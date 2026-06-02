# Terraform Project Template - Justfile

# Shell to use
set shell := ["bash", "-uc"]
set dotenv-load := true

TF_ENV := env_var_or_default("TF_ENV", "dev")
TF_UNIT := env_var_or_default("TF_UNIT", "network")

# Default recipe to show available commands
default:
  #!/usr/bin/env bash
  just --list --unsorted

# Get AWS profile from .env or fallback to "app-deployer"
_aws-profile:
    #!/usr/bin/env bash
    # Check if running in GitHub Actions
    if [ -n "$GITHUB_ACTIONS" ]; then
        # In GitHub Actions with OIDC, we don't use named profiles
        # The credentials are already set by configure-aws-credentials
        echo ""
    elif [ -f .env ]; then
        source .env && echo "${AWS_PROFILE:-app-deployer}"
    else
        echo "app-deployer"
    fi

# Initialize Terraform
init:
  #!/usr/bin/env bash
  echo "Initializing Terraform"
  AWS_PROFILE=${AWS_PROFILE:-"$(just _aws-profile)"} aws sts get-caller-identity | jq
  echo "Initializing Terraform unit: {{TF_UNIT}} (env: {{TF_ENV}})"
  echo "Backend config: terraform/{{TF_UNIT}}/backends/{{TF_ENV}}.hcl"
  cd terraform/{{TF_UNIT}} && terraform init -reconfigure \
    -backend-config=backends/{{TF_ENV}}.hcl \
    -backend-config="bucket=$TF_STATE_BUCKET" \
    -backend-config="profile=$AWS_PROFILE"

# Format Terraform files
fmt:
  #!/usr/bin/env bash
  echo "Formatting Terraform files"
  cd terraform/{{TF_UNIT}} && terraform fmt -recursive

# Validate Terraform configuration
validate:
  #!/usr/bin/env bash
  echo "Validating Terraform configuration"
  cd terraform/{{TF_UNIT}} && terraform validate

# Plan Terraform changes
plan: init
  #!/usr/bin/env bash
  echo "Planning Terraform changes"
  cd terraform/{{TF_UNIT}} && terraform plan \
    -var-file=envs/common.tfvars \
    -var-file=envs/{{TF_ENV}}.tfvars \
    -out=terraform.tfplan \
    -detailed-exitcode \
    -no-color 2>&1
  status_code=$?
  echo "Plan exit code: $status_code"

# Apply Terraform changes
apply:
  #!/usr/bin/env bash
  echo "Applying Terraform changes"
  cd terraform/{{TF_UNIT}} && terraform apply terraform.tfplan

# Destroy Terraform resources in one step
quick-destroy:
  #!/usr/bin/env bash
  echo "Destroying Terraform resources"
  cd terraform/{{TF_UNIT}} && terraform plan \
    -var-file=envs/common.tfvars \
    -var-file=envs/{{TF_ENV}}.tfvars \
    -destroy \
    -out=terraform.tfplan && terraform apply -auto-approve terraform.tfplan

# Quick apply Terraform changes in one step
quick-apply:
  #!/usr/bin/env bash
  echo "Quickly applying Terraform changes"
  cd terraform/{{TF_UNIT}} && terraform plan \
    -var-file=envs/common.tfvars \
    -var-file=envs/{{TF_ENV}}.tfvars \
    -out=terraform.tfplan && terraform apply -auto-approve terraform.tfplan

# Run pre-commit hooks on all files
lint:
  #!/usr/bin/env bash
  echo "Running pre-commit hooks on all files"
  pre-commit run --all-files

# Install pre-commit hooks
install-hooks:
  #!/usr/bin/env bash
  echo "Installing pre-commit hooks"
  pre-commit install

# Update pre-commit hooks
update-hooks:
  #!/usr/bin/env bash
  echo "Updating pre-commit hooks"
  pre-commit autoupdate

# Generate Terraform documentation
docs:
  #!/usr/bin/env bash
  echo "Generating Terraform documentation"
  cd terraform/{{TF_UNIT}} && terraform-docs markdown . --config ../../.terraform-docs.yml > ../../docs/terraform.md

# Clean up temporary files and directories
clean:
  #!/usr/bin/env bash
  echo "Cleaning up temporary files and directories"
  rm -rf terraform/{{TF_UNIT}}/.terraform/
  rm -f terraform/{{TF_UNIT}}/terraform.tfstate*
  rm -f terraform/{{TF_UNIT}}/terraform.tfplan
  rm -f terraform/{{TF_UNIT}}/.terraform.lock.hcl

# Show Terraform version
version:
  #!/usr/bin/env bash
  echo "Showing Terraform version"
  terraform version
