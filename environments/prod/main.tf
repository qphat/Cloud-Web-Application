# -----------------------------------------------------
# Networking
# -----------------------------------------------------
module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# -----------------------------------------------------
# Database (must be created before IAM for secret ARN)
# -----------------------------------------------------
module "database" {
  source = "../../modules/database"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  rds_security_group_id = module.networking.rds_security_group_id
  db_instance_class     = var.db_instance_class
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_name               = var.db_name
  db_username           = var.db_username
  db_allocated_storage  = var.db_allocated_storage
  db_multi_az           = var.db_multi_az
  skip_final_snapshot   = var.skip_final_snapshot
}

# -----------------------------------------------------
# IAM
# -----------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  project_name  = var.project_name
  environment   = var.environment
  db_secret_arn = module.database.db_secret_arn
}

# -----------------------------------------------------
# Compute
# -----------------------------------------------------
module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  ec2_security_group_id = module.networking.ec2_security_group_id
  instance_profile_name = module.iam.instance_profile_name
  instance_type         = var.instance_type
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
}
