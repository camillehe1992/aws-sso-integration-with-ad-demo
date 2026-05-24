# Setup GitHub Actions Workflows

## Terraform Plan and Apply Workflow

Workflow: [terraform-plan-apply.yml](./terraform-plan-apply.yml)

Add below secrets in GitHub Repository Secrets:

Note: I use one AWS account for both dev and prod environments, I only need to set the secrets in Repository Secrets.
If you use different AWS accounts for dev and prod environments, you need to set the secrets in each environment.

- AWS_ACCOUNT_ID (the AWS account ID is used in s3 bucket name, use `S3_TF_BUCKET_NAME` if you want to use a custom one)
- AWS_REGION (for OIDC authentication)
- ROLE_TO_ASSUME (for OIDC authentication)

Workflow Description:
- **Single workflow** with two separate jobs: `terraform-plan` and `terraform-apply`
- Triggered on push on `main` branch, `develop` branch, and pull request events on `main` branch with paths matching `terraform/**`
- Manual trigger available via `workflow_dispatch` with environment selection
- **Plan Job**: Validates and plans Terraform changes
- **Apply Job**: Executes changes only when plan detects changes (exit code 2) and on main branch or manual trigger

### Key Features

- **Simplified Structure**: Single workflow file instead of two separate workflows
- **Smart Job Dependencies**: Apply job only runs when plan job succeeds and detects changes
- **Environment Protection**: Apply job uses `prod` environment for approval requirements
- **Comprehensive Logging**: Detailed GitHub step summaries for both plan and apply phases
- **Resource Optimization**: Eliminates duplicate setup steps between workflows

### Job Flow

1. **terraform-plan**: Always runs first, validates and plans changes
2. **terraform-apply**: Only runs if:
   - Plan job completed successfully
   - Changes were detected (exit code = 2)
   - On main branch or manual workflow trigger
   - Passes environment approval (if configured)

### Environment Protection (Recommended)

Configure environment protection rules for the `prod` environment in GitHub:
1. Go to Settings → Environments → New environment
2. Name: `prod`
3. Configure protection rules:
   - Required reviewers (recommended: 1-2 people)
   - Deployment protection rules
   - Environment secrets (if needed)

This ensures terraform apply requires manual approval before executing changes.
