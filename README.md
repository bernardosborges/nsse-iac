# NSSE Infrastructure as Code (Terraform)

This repository contains the NSSE infrastructure provisioned with Terraform as reference.

## Structure

- `00-remote-backend/` → Remote backend configuration (S3) to store Terraform state.
- `01-networking/` → Configuration for VPC, internet gateway, 
NAT gateway, public and private subnets, and route tables.
- `02-server/` → Configuration for key pairs, instance profile, security group, launch templates, auto scaling groups, and other instances and servers.

## Prerequisites

- Terraform >= 1.14.7
- AWS CLI configured
- AWS credentials with permissions to create resources

## How to use

Just run `init` and `apply` **folder by folder**:

```bash

# 0. (Optional) Verify your identity
aws sts get-caller-identity --profile <YOUR-PROFILE>

# 1. Set AWS profile for Terraform
export AWS_PROFILE=<YOUR-PROFILE>

# 2. Setup remote backend:
cd 00-remote-backend
terraform init
terraform apply

# 3. Setup networking:
cd ../01-networking
terraform init
terraform apply

# 4. Setup servers:
cd ../02-server
terraform init
terraform apply

# Warning!: Destroy resources in reverse order after use
terraform destroy

# Extra commands (recomended before 'apply'): 
# Formats Terraform code according to standard conventions
terraform fmt
# Check syntax and code structure for errors
terraform validate
# Shows planned changes before applying
terraform plan
# Reconfigures backend settings after any changes in backend configuration
terraform init -reconfigure
# Migrate the existing state to the new backend (run after reconfigure)
terraform init -migrate-state

```