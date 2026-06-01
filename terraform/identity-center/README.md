# Identity Center (Terraform Unit)

This Terraform unit manages IAM Identity Center (AWS SSO) **permission sets** for an existing Identity Center instance:

- Creates permission sets
- Optionally attaches AWS managed policies
- Optionally attaches customer managed policies
- Optionally configures an inline policy per permission set

## Folder layout

```text
terraform/identity-center/
├── providers.tf
├── variables.tf
├── local.tf
├── main.tf
├── outputs.tf
├── backends/
│   ├── dev.hcl
│   └── prod.hcl
└── envs/
    ├── common.tfvars
    ├── dev.tfvars
    └── prod.tfvars
```

## Permission set model

Permission sets are defined in `permission_sets` (a map keyed by a logical name). The actual Identity Center permission set name is:

`permission_set_name_prefix + <map key>`

This is useful for keeping dev/prod permission sets separate when they share the same Identity Center instance.

## Usage

Create a `.env` file from `.env.sample`, and update the variables as needed.

```bash
cp .env.sample .env
```

### Using just (recommended)

From repo root:

```bash
# Plan
TF_UNIT=identity-center TF_ENV=dev just plan

# Apply the plan
TF_UNIT=identity-center TF_ENV=dev just apply

# Destroy the resources
TF_UNIT=identity-center TF_ENV=dev just quick-destroy
```

### Using terraform directly

From repo root:

```bash
cd terraform/identity-center
terraform init -reconfigure \
  -backend-config=backends/dev.hcl \
  -backend-config="bucket=$TF_STATE_BUCKET" \
  -backend-config="profile=$AWS_PROFILE"

terraform plan \
  -var-file=envs/common.tfvars \
  -var-file=envs/dev.tfvars
```

## Outputs

Key outputs:

- `identity_center_instance_arn`
- `permission_set_names`
- `permission_set_arns`
