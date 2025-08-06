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
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  region               = var.region
}

module "rds" {
  source               = "./modules/rds"
  vpc_id               = module.vpc.vpc_id
  private_subnet_1_id  = module.vpc.private_subnet_1_id
  private_subnet_2_id  = module.vpc.private_subnet_2_id
  vpc_cidr             = var.vpc_cidr
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_user              = var.db_user
  db_password          = var.db_password
  db_name              = var.db_name
  publicly_accessible  = false
  skip_final_snapshot  = true
  storage_encrypted    = false
}

module "secrets" {
  source         = "./modules/secrets"
  rds_endpoint   = module.rds.rds_endpoint
  db_user        = var.db_user
  db_password    = var.db_password
  db_name        = var.db_name
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
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  security_group_id    = module.ec2.security_group_id
  public_subnet_1_id   = module.vpc.public_subnet_1_id
  public_subnet_2_id   = module.vpc.public_subnet_2_id
  target_group_arn     = module.alb.target_group_arn
  region               = var.region
}