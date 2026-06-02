---
name: "terraform-quality"
description: "Ensures Terraform changes pass repo formatting, linting, and validation. Invoke when user edits Terraform, before PRs, or when Terraform CI/pre-commit checks fail."
---

# Terraform Quality (Fmt/Lint/Validate)

## Goal

Make Terraform code in this repo pass the same quality gates enforced by the repo tooling:
- Formatting: `terraform fmt` (CI uses `-check -recursive`)
- Validation: `terraform validate` (after init)
- Lint/Security: pre-commit hooks (TFLint + Checkov + local Terraform hooks)

## Repo Conventions (Read First)

- Terraform lives in `./terraform`
- Canonical automation entrypoints:
  - `just fmt`
  - `just validate`
  - `just lint` (runs `pre-commit run --all-files`)
- Pre-commit is the repo’s single “lint umbrella” (`.pre-commit-config.yaml`)
- CI additionally enforces `terraform fmt -check -recursive` and runs `terraform init` before `terraform validate` (`.github/workflows/terraform-plan-apply.yml`)

## Execution Checklist (Do In This Order)

### 1) Formatting (Fail-fast)

Use CI-equivalent format check:
```bash
cd terraform
terraform fmt -check -recursive
```

If it fails, auto-fix:
```bash
cd terraform
terraform fmt -recursive
```

If `just` is preferred:
```bash
just fmt
```

### 2) Validation (Make It Work Without AWS When Possible)

Preferred local validation without touching remote backend:
```bash
cd terraform
terraform init -backend=false
terraform validate
```

If backend configuration must be exercised (requires repo env like `AWS_ACCOUNT_ID`, `AWS_REGION` and credentials):
```bash
just init
just validate
```

### 3) Lint + Security (Repo Rules = Pre-commit)

Run the repo’s full lint suite:
```bash
just lint
```

Or directly:
```bash
pre-commit run --all-files
```

If you want to isolate Terraform-related hooks:
```bash
pre-commit run terraform-fmt --all-files
pre-commit run terraform-validate --all-files
pre-commit run terraform_tflint --all-files
pre-commit run terraform_checkov --all-files
```

## How to Respond to Failures (Fix Strategy)

- `terraform fmt` failures: run `terraform fmt -recursive`, then re-run the `-check` command.
- `terraform validate` failures:
  - ensure `terraform init -backend=false` completed successfully
  - re-run `terraform validate` from `./terraform`
- `terraform_tflint` failures: follow rule messages; re-run the specific hook to confirm.
- `terraform_checkov` failures: treat as security policy findings; fix or justify by repo policy (avoid disabling unless the repo already documents an exception pattern).

## Dependency Notes

This repo’s quality gates expect these to be available in PATH:
- `terraform`
- `pre-commit`
- Hooks may also require: `tflint`, `checkov`, `terraform-docs`
If a command is missing, install it using your team’s standard approach, then re-run the checklist.
