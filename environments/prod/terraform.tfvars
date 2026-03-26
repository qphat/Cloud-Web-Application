# -----------------------------------------------------
# General
# -----------------------------------------------------
project_name = "application"
environment  = "prod"
aws_region   = "us-east-1"

# -----------------------------------------------------
# Networking
# -----------------------------------------------------
vpc_cidr             = "10.2.0.0/16"
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# -----------------------------------------------------
# EC2 / Auto Scaling (production sized)
# -----------------------------------------------------
instance_type        = "t3.medium"
asg_min_size         = 2
asg_max_size         = 8
asg_desired_capacity = 4

# -----------------------------------------------------
# RDS (production sized)
# -----------------------------------------------------
db_instance_class    = "db.t3.medium"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_name              = "appdb"
db_username          = "admin"
db_allocated_storage = 100
db_multi_az          = true
skip_final_snapshot  = true
