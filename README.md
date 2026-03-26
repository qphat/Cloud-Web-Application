# AWS Application Infrastructure

Terraform project for deploying a multi-environment AWS application infrastructure.

## Architecture

```
Internet
    │
    ▼
┌──────────────────────────────────────────────┐
│ VPC                                          │
│  ┌──────────────┐    ┌──────────────┐        │
│  │ Public Sub A │    │ Public Sub B │        │
│  │    (AZ1)     │    │    (AZ2)     │        │
│  │  ┌────────┐  │    │  ┌────────┐  │        │
│  │  │  ALB   │◄─┼────┼──┤  ALB   │  │        │
│  │  └───┬────┘  │    │  └───┬────┘  │        │
│  │      ▼       │    │      ▼       │        │
│  │  ┌────────┐  │    │  ┌────────┐  │        │
│  │  │  EC2   │  │    │  │  EC2   │  │        │
│  │  │ (ASG)  │  │    │  │ (ASG)  │  │        │
│  │  └───┬────┘  │    │  └───┬────┘  │        │
│  └──────┼───────┘    └──────┼───────┘        │
│  ┌──────┼───────┐    ┌──────┼───────┐        │
│  │ Private Sub A│    │ Private Sub B│        │
│  │      ▼       │    │              │        │
│  │  ┌────────┐  │    │  ┌────────┐  │        │
│  │  │  RDS   │◄─┼────┼──┤  RDS   │  │        │
│  │  │(primary)│  │    │  │(standby)│ │        │
│  │  └────────┘  │    │  └────────┘  │        │
│  └──────────────┘    └──────────────┘        │
└──────────────────────────────────────────────┘
```

## Components

| Component | Description |
|---|---|
| VPC | Isolated network with 2 AZs |
| Public Subnets | EC2 instances, ALB, NAT Gateway |
| Private Subnets | RDS database (no internet access) |
| ALB | Application Load Balancer (HTTP) |
| ASG | Auto Scaling Group with launch template |
| RDS | MySQL Multi-AZ with encrypted storage |
| IAM | EC2 role with Secrets Manager access |
| Secrets Manager | Stores DB credentials (auto-generated) |
| Key Pair | SSH key pair (TLS generated) |

## Project Structure

```
application/
├── backend/                  # S3 + DynamoDB for state management
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── modules/                  # Reusable modules (shared by all envs)
│   ├── networking/           # VPC, subnets, IGW, NAT, routes, SGs
│   ├── compute/              # ALB, key pair, launch template, ASG
│   ├── database/             # RDS, Secrets Manager, random password
│   └── iam/                  # IAM role, policy, instance profile
└── environments/             # Environment-specific configs
    ├── dev/                  # Small, cheap, for development
    ├── staging/              # Medium, mirrors prod for testing
    └── prod/                 # Full scale, for production
```

## Environment Differences

| Setting | Dev | Staging | Prod |
|---|---|---|---|
| VPC CIDR | 10.0.0.0/16 | 10.1.0.0/16 | 10.2.0.0/16 |
| Instance type | t3.micro | t3.small | t3.medium |
| ASG desired | 1 | 2 | 4 |
| RDS class | db.t3.micro | db.t3.small | db.t3.medium |
| RDS storage | 20 GB | 50 GB | 100 GB |
| Multi-AZ | No | Yes | Yes |
| Skip snapshot | Yes | Yes | No |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- AWS CLI configured with valid credentials
- S3 bucket and DynamoDB table for state (created via `backend/`)

## Quick Start

### 1. Create Backend (once)

```bash
cd backend
terraform init
terraform apply
```

### 2. Deploy an Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### 3. Get Outputs

```bash
# ALB DNS name
terraform output alb_dns_name

# SSH key
terraform output -raw private_key_pem > key.pem
chmod 400 key.pem

# RDS endpoint
terraform output rds_endpoint
```

### 4. SSH into EC2

```bash
# Get instance IP
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=application-dev-asg-instance" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text

# Connect
ssh -i key.pem ec2-user@<IP>
```

### 5. Connect to RDS (from EC2)

```bash
# Get DB credentials
aws secretsmanager get-secret-value \
  --secret-id application/dev/db-credentials \
  --query SecretString --output text

# Connect
sudo yum install -y mariadb105
mysql -h <RDS_ENDPOINT> -u admin -p
```

### 6. Destroy

```bash
terraform destroy
```

## Security

- RDS is in private subnets (no internet access)
- Security groups are layered: Internet → ALB → EC2 → RDS
- DB password is auto-generated, stored in Secrets Manager
- S3 state bucket is encrypted with KMS, versioned, public access blocked
- SSH key is in Terraform state (marked sensitive)

## Common Issues

| Error | Fix |
|---|---|
| Backend credential error | `rm -rf .terraform && terraform init` |
| S3 bucket name taken | Add unique suffix to bucket name |
| Secret scheduled for deletion | `aws secretsmanager delete-secret --secret-id <name> --force-delete-without-recovery` |
| Skip snapshot blocking destroy | Set `skip_final_snapshot = true` in tfvars, apply, then destroy |
