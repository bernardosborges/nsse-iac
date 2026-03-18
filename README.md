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

# 1. Setup remote backend:
cd 00-remote-backend
terraform init
terraform apply

# 2. Setup networking:
cd ../01-networking
terraform init
terraform apply

# 3. Setup servers:
cd ../02-server
terraform init
terraform apply
```