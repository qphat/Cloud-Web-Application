# Capstone Project - Terraform Modular Deployment on AWS

This repository provides an infrastructure-as-code solution using **Terraform** to deploy a scalable, secure, and modular web application architecture on AWS.

---

## Architecture Overview

The deployment consists of multiple Terraform modules:

* **VPC Module**: Creates a Virtual Private Cloud with public/private subnets
* **EC2 Module**: Launches EC2 instances with user data scripts
* **RDS Module**: Provisions an RDS MySQL database
* **Secrets Manager Module**: Stores database credentials securely
* **ALB Module**: Application Load Balancer in public subnets
* **Auto Scaling Module**: Launch Template + Auto Scaling Group
* **Cloud9 Module**: (Optional) Creates Cloud9 IDE in public subnet

---

## Features

* ✅ **Modular Architecture** (clean, reusable code)
* ✅ **Secure Deployment**: Private RDS, IAM roles, SGs
* ✅ **Automated User Data**: EC2 auto-deploys Node.js app
* ✅ **Secrets Manager**: Credentials pulled by EC2 at runtime
* ✅ **Auto Scaling & Load Balancing**
* ✅ **Backend State Management**: S3 + DynamoDB lock

---

## ⚙ Prerequisites

* Terraform v1.0+
* AWS CLI configured with proper credentials
* An existing AWS Key Pair (e.g. `vockey`)
* An S3 bucket and DynamoDB table for remote backend

---

## Repository Structure

```
.
├── main.tf                # Root Terraform config using all modules
├── variables.tf           # Root input variables
├── outputs.tf             # Root outputs
├── terraform.tfvars       # Variable values (optional)
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   ├── secrets/
│   ├── alb/
│   ├── autoscaling/
│   └── cloud9/             # Optional
```

---

## Quick Start

```bash
# Step 1: Initialize Terraform
terraform init

# Step 2: Review Plan
terraform plan

# Step 3: Apply Infrastructure
terraform apply
```

After completion, Terraform will output:

* ALB DNS Name
* RDS endpoint (via secret)
* EC2 Instance IDs

---

## Modules Summary

### VPC

* Public + Private subnets across 2 AZs
* Internet Gateway + Route Tables

### EC2

* 2 EC2 instances (POC + AppServer)
* Installs Node.js app via `user_data`
* Pulls DB secrets from Secrets Manager

### RDS

* MySQL 8.0
* Private Subnets
* Security Group allowing 3306 from EC2

### Secrets

* Stores DB info securely (`Mydbsecret`)
* EC2 pulls secrets at runtime via IAM permissions

### ALB

* Routes HTTP (port 80) to EC2 ASG
* DNS output shown after deploy

### Auto Scaling

* Launch Template
* Auto Scaling Group (min: 2, max: 4)
* CPU-based scaling policy (target: 30%)

---

## 📝 Variables

| Variable                | Description               | Required |
| ----------------------- | ------------------------- | -------- |
| `region`                | AWS region to deploy into | Yes      |
| `ami_id`                | AMI ID (Ubuntu preferred) | Yes      |
| `instance_type`         | EC2 type (e.g. t3.micro)  | Yes      |
| `key_name`              | SSH Key Pair name         | Yes      |
| `vpc_cidr`              | CIDR for main VPC         | Yes      |
| `public_subnet_1_cidr`  | CIDR for AZ-a             | Yes      |
| `public_subnet_2_cidr`  | CIDR for AZ-b             | Yes      |
| `private_subnet_1_cidr` | CIDR for AZ-a private     | Yes      |
| `private_subnet_2_cidr` | CIDR for AZ-b private     | Yes      |

---

## Security Notes

* **SSH Access**: Currently open via 0.0.0.0/0 (update to your IP in EC2 module)
* **Secrets**: Stored safely in AWS Secrets Manager
* **No public access** to RDS
* **IAM Instance Profile** needed: `LabInstanceProfile`

---

##  Outputs

* ALB DNS Name (access app via browser)
* EC2 Instance IDs
* RDS Endpoint (hidden inside secret)
* Security Group IDs
* Subnet & VPC IDs

---

##  Cleanup

```bash
terraform destroy
```

---

##  Cost Estimate

| Service                       | Estimated Monthly Cost      |
| ----------------------------- | --------------------------- |
| EC2 (2 x t3.micro)            | \~\$16 (Free Tier eligible) |
| RDS MySQL                     | \~\$15+                     |
| ALB                           | \~\$18+                     |
| S3 + DynamoDB (state backend) | \~\$0.50                    |

Use [AWS Calculator](https://calculator.aws.amazon.com/) for exact cost.

---

##  Learning Outcome

This Terraform project helps practice:

* Modular infrastructure design
* Remote state + locking
* Secure credential management
* Load balancing & scaling on AWS

---
