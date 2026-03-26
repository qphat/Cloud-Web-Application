# -----------------------------------------------------
# General
# -----------------------------------------------------
project_name = "application"
environment  = "staging"
aws_region   = "us-east-1"

# -----------------------------------------------------
# Networking
# -----------------------------------------------------
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# -----------------------------------------------------
# EC2 / Auto Scaling (moderate for staging)
# -----------------------------------------------------
instance_type        = "t3.small"
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2

# -----------------------------------------------------
# RDS (moderate for staging)
# -----------------------------------------------------
db_instance_class    = "db.t3.small"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_name              = "appdb"
db_username          = "admin"
db_allocated_storage = 50
db_multi_az          = true
skip_final_snapshot  = true
