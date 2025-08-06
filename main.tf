provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket" # Thay bằng tên bucket S3 của bạn
    key            = "capstone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock" # Bảng DynamoDB cho khóa trạng thái
  }
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  region               = var.region
}

module "ec2" {
  source               = "./modules/ec2"
  vpc_id               = module.vpc.vpc_id
  public_subnet_1_id   = module.vpc.public_subnet_1_id
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = "vockey"
  iam_instance_profile = "LabInstanceProfile"
  region               = var.region
}

module "rds" {
  source               = "./modules/rds"
  vpc_id               = module.vpc.vpc_id
  private_subnet_1_id  = module.vpc.private_subnet_1_id
  private_subnet_2_id  = module.vpc.private_subnet_2_id
  vpc_cidr             = var.vpc_cidr
}

module "secrets" {
  source         = "./modules/secrets"
  rds_endpoint   = module.rds.rds_endpoint
  db_user        = "nodeapp"
  db_password    = "student12"
  db_name        = "STUDENTS"
}

module "alb" {
  source               = "./modules/alb"
  vpc_id               = module.vpc.vpc_id
  public_subnet_1_id   = module.vpc.public_subnet_1_id
  public_subnet_2_id   = module.vpc.public_subnet_2_id
  security_group_id    = module.ec2.security_group_id
}

module "autoscaling" {
  source               = "./modules/autoscaling"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = "vockey"
  iam_instance_profile = "LabInstanceProfile"
  security_group_id    = module.ec2.security_group_id
  public_subnet_1_id   = module.vpc.public_subnet_1_id
  public_subnet_2_id   = module.vpc.public_subnet_2_id
  target_group_arn     = module.alb.target_group_arn
  region               = var.region
}