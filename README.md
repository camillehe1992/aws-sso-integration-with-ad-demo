# Terraform Project Template

A comprehensive template repository for managing cloud infrastructure with Terraform.
This template provides a standardized structure with built-in linting, formatting, and
documentation tools.

## 📁 Project Structure

```bash
├── .gitignore                    # Git ignore rules
├── .github/workflows/           # GitHub Actions workflows
├── README.md                    # Project documentation
├── .pre-commit-config.yaml      # Pre-commit hooks configuration
├── justfile                     # Task runner commands
├── .markdownlint.json           # Markdown linting rules
├── .markdownlintignore.yaml     # Markdown linting ignore files
├── .terraform-lint.yml          # Terraform linting configuration
├── .terraform-docs.yml          # Terraform documentation generator config
├── .terraform-version.yml       # Terraform version specification
├── terraform/                   # Terraform infrastructure code
├── src/                         # Application source code
├── docs/                        # Project documentation
└── scripts/                     # Utility scripts
```

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) (version specified in `.terraform-version.yml`)
- [Just](https://just.systems/) command runner
- [pre-commit](https://pre-commit.com/) hooks framework

### Setup

1. **Clone and initialize the repository:**
   ```bash
   git clone <your-repo-url>
   cd terraform-project-template
   ```

2. **Install pre-commit hooks:**
   ```bash
   just install-hooks
   ```

3. **Initialize Terraform:**
   ```bash
   just init
   ```

4. **Run linting and formatting:**
   ```bash
   just lint
   just fmt
   ```

## 🛠️ Available Commands

Use the `justfile` for common development tasks:

```bash
# Show all available commands
just

# Initialize Terraform
just init

# Format Terraform code
just fmt

# Validate Terraform configuration
just validate

# Plan infrastructure changes
just plan

# Apply infrastructure changes
just apply

# Destroy infrastructure
just destroy

# Run all linting and checks
just lint

# Generate documentation
just docs

# Clean up temporary files
just clean

# Show Terraform version
just version
```

## 📋 Configuration Files

### Linting and Formatting

- **`.markdownlint.json`**: Configuration for Markdown linting rules
- **`.terraform-lint.yml`**: Terraform-specific linting configuration
- **`.pre-commit-config.yaml`**: Pre-commit hooks for code quality

### Documentation

- **`.terraform-docs.yml`**: Configuration for auto-generating Terraform documentation
- **`docs/`**: Directory for project documentation

### Version Management

- **`.terraform-version.yml`**: Specifies Terraform and provider versions

## 🏗️ Infrastructure Organization

### Terraform Directory (`terraform/`)

Place all your Terraform infrastructure code here. Consider organizing by:

- Environment (dev, staging, prod)
- Resource type (compute, networking, storage)
- Service or application

### Source Code (`src/`)

For application code, configuration files, or scripts that support your infrastructure.

### Documentation (`docs/`)

Project documentation, architecture diagrams, and operational guides.

### Scripts (`scripts/`)

Utility scripts for deployment, maintenance, or operational tasks.

## 🔧 Development Workflow

1. **Create a new feature branch:**
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes to Terraform code**

3. **Run formatting and validation:**
   ```bash
   just fmt
   just validate
   ```

4. **Run linting:**
   ```bash
   just lint
   ```

5. **Plan your changes:**
   ```bash
   just plan
   ```

6. **Generate documentation:**
   ```bash
   just docs
   ```

7. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add new infrastructure component"
   ```

## 📊 Pre-commit Hooks

This template includes pre-commit hooks for:

- **Markdown linting**: Ensures consistent Markdown formatting
- **Terraform formatting**: Auto-formats Terraform files
- **Terraform validation**: Validates Terraform syntax
- **General file checks**: Trailing whitespace, large files, merge conflicts

## 📝 Contributing

1. Follow the existing code structure and naming conventions
2. Use meaningful commit messages
3. Run all linting and formatting before committing
4. Update documentation as needed
5. Test your changes with `just plan` before applying

## 🔒 Security Best Practices

- Never commit sensitive data (passwords, API keys, etc.)
- Use Terraform variables for sensitive values
- Consider using Terraform workspaces for environment separation
- Review security groups and IAM policies carefully

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices.html)
- [Just Command Runner](https://just.systems/)
- [Pre-commit Framework](https://pre-commit.com/)

## 📄 License

This project template is open source and available under the [MIT License](LICENSE).

---
