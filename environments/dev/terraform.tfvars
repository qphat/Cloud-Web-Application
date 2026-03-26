# -----------------------------------------------------
# General
# -----------------------------------------------------
project_name = "application"
environment  = "dev"
aws_region   = "us-east-1"

# -----------------------------------------------------
# Networking
# -----------------------------------------------------
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# -----------------------------------------------------
# EC2 / Auto Scaling (small for dev)
# -----------------------------------------------------
instance_type        = "t3.micro"
asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1

# -----------------------------------------------------
# RDS (minimal for dev)
# -----------------------------------------------------
db_instance_class    = "db.t3.micro"
db_engine            = "mysql"
db_engine_version    = "8.0"
db_name              = "appdb"
db_username          = "admin"
db_allocated_storage = 20
db_multi_az          = false
skip_final_snapshot  = true
