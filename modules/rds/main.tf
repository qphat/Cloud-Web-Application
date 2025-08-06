# Tạo nhóm bảo mật cho RDS, cho phép lưu lượng MySQL (cổng 3306) từ CIDR block của VPC
resource "aws_security_group" "capstone_db_sg" {
  vpc_id      = var.vpc_id
  name        = "CapstoneDBSG"
  description = "Security group for RDS database"

  # Quy tắc inbound cho MySQL (chỉ từ CIDR block của VPC)
  ingress {
    description = "Allow MySQL traffic from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Quy tắc outbound cho phép tất cả lưu lượng
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CapstoneDBSG"
  }
}

# Tạo nhóm subnet RDS cho private subnets
resource "aws_db_subnet_group" "capstone_db_subnet_group" {
  name       = "capstone-db-subnet-group"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]
  description = "Subnet group for RDS database"
  tags = {
    Name = "CapstoneDBSubnetGroup"
  }
}

# Tạo cơ sở dữ liệu RDS MySQL
resource "aws_db_instance" "capstone_db" {
  identifier             = "capstonedb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "nodeapp"
  password               = "student12"
  db_name                = "STUDENTS"
  vpc_security_group_ids = [aws_security_group.capstone_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.capstone_db_subnet_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = false
  tags = {
    Name = "CapstoneDB"
  }
}