# AWS IAM Identity Center + Okta (SAML & SCIM) Demo

This repository is a demonstration of configuring **SAML** (SSO) and **SCIM** (user/group provisioning) with **Okta** and **AWS IAM Identity Center** (formerly AWS SSO).

It includes:

- Step-by-step guides for Okta ↔ IAM Identity Center integration (SAML + SCIM)
- Terraform units for a reusable AWS baseline:
  - `network`: VPC, subnets, routing, optional NAT modes
  - `identity-center`: IAM Identity Center permission sets management

## 📁 Project Structure

```bash
├── terraform/                      # Terraform units
│   ├── network/                    # VPC baseline (Console “VPC and more” style)
│   └── identity-center/            # Permission sets for an existing Identity Center instance
├── docs/                           # Integration guides and diagrams
├── justfile                        # Task runner commands (init/plan/apply/etc.)
├── .env.sample                     # Example environment variables
├── .pre-commit-config.yaml         # Pre-commit hooks configuration
└── .github/workflows/              # CI workflows (plan/apply)
```

## 📚 Documentation

- Okta ↔ IAM Identity Center (SAML + SCIM)
  - [aws-identity-center-okta-integration.md](file:///Users/heyachao/Documents/trae_projects/aws-sso-integration-with-ad-demo/docs/aws-identity-center-okta-integration.md)
  - [aws-identity-center-okta-integration.zh.md](file:///Users/heyachao/Documents/trae_projects/aws-sso-integration-with-ad-demo/docs/aws-identity-center-okta-integration.zh.md)
- IAM Identity Center ↔ Active Directory (console demo)
  - [aws-identity-center-ad-integration.zh.md](file:///Users/heyachao/Documents/trae_projects/aws-sso-integration-with-ad-demo/docs/aws-identity-center-ad-integration.zh.md)

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) (version specified in `.terraform-version.yml`)
- [Just](https://just.systems/) command runner
- [pre-commit](https://pre-commit.com/) hooks framework

### Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd aws-sso-integration-with-ad-demo
   ```

2. **Create a `.env` file:**
   ```bash
   cp .env.sample .env
   ```

   Update at least:
   - `TF_STATE_BUCKET`: your Terraform remote state S3 bucket
   - `AWS_PROFILE`: your local AWS profile (or rely on env credentials in CI)

3. **Install pre-commit hooks (optional but recommended):**
   ```bash
   just install-hooks
   ```

4. **Plan/apply a Terraform unit:**
   ```bash
   TF_UNIT=network TF_ENV=dev just plan
   TF_UNIT=network TF_ENV=dev just apply
   ```

### Units

- `network`: baseline VPC networking. See [network README](file:///Users/heyachao/Documents/trae_projects/aws-sso-integration-with-ad-demo/terraform/network/README.md)
- `identity-center`: permission sets for an existing IAM Identity Center instance. See [identity-center README](file:///Users/heyachao/Documents/trae_projects/aws-sso-integration-with-ad-demo/terraform/identity-center/README.md)

## 🛠️ Available Commands

The `justfile` provides common tasks. Most Terraform commands accept:

- `TF_UNIT` (default: `network`)
- `TF_ENV` (default: `dev`)

Examples:

```bash
# Format and validate
TF_UNIT=network TF_ENV=dev just fmt
TF_UNIT=network TF_ENV=dev just validate

# Plan/apply
TF_UNIT=identity-center TF_ENV=dev just plan
TF_UNIT=identity-center TF_ENV=dev just apply

# Destroy (dangerous)
TF_UNIT=network TF_ENV=dev just quick-destroy
```

## 🔧 Development Workflow

```bash
# Lint/format
just lint
just fmt

# Validate Terraform for a unit
TF_UNIT=network just validate

# Plan changes
TF_UNIT=network TF_ENV=dev just plan
```

## 🔒 Notes

- This repo can create billable AWS resources (for example NAT Gateways). Review the `terraform/` unit variables and your plan output before applying.
- For Identity Center: this unit assumes an existing IAM Identity Center instance in the target region. You can override the instance ARN in `terraform/identity-center/envs/*.tfvars` if needed.

## 📄 License

This repository is available under the [MIT License](LICENSE).
