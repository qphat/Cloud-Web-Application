# Tạo nhóm bảo mật cho ứng dụng web, cho phép lưu lượng HTTP (cổng 80) và SSH (cổng 22)
resource "aws_security_group" "capstone_app_sg" {
  vpc_id      = var.vpc_id
  name        = "CapstoneAPPSG"
  description = "Security group for web application"

  # Quy tắc inbound cho HTTP
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Quy tắc inbound cho SSH (để quản lý EC2 instance)
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "CapstoneAPPSG"
  }
}

# Tạo phiên bản EC2 CapstonePOC cho ứng dụng web cơ bản
resource "aws_instance" "capstone_poc" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [aws_security_group.capstone_app_sg.id]
  key_name               = var.key_name

  # Kịch bản user data để cài đặt Node.js và ứng dụng web
  user_data = <<-EOF
#!/bin/bash -xe
# Cập nhật hệ thống
apt update -y
# Cài đặt Node.js, unzip, wget, npm
apt install nodejs unzip wget npm -y
# Tải mã nguồn ứng dụng
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1/code.zip -P /home/ubuntu
cd /home/ubuntu
# Giải nén mã nguồn, bỏ qua thư mục node_modules
unzip code.zip -x "resources/codebase_partner/node_modules/*"
cd resources/codebase_partner
# Cài đặt các phụ thuộc
npm install aws aws-sdk
# Cấu hình biến môi trường cho ứng dụng
export APP_PORT=80
# Khởi động ứng dụng
npm start &
# Đảm bảo ứng dụng tự động chạy khi khởi động lại
echo '#!/bin/bash -xe
cd /home/ubuntu/resources/codebase_partner
export APP_PORT=80
npm start' > /etc/rc.local
chmod +x /etc/rc.local
EOF

  tags = {
    Name = "CapstonePOC"
  }
}

# Tạo phiên bản EC2 CapstoneAppServer cho ứng dụng web tách biệt
resource "aws_instance" "capstone_app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [aws_security_group.capstone_app_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  # Kịch bản user data để cài đặt Node.js và ứng dụng web, tích hợp với Secrets Manager
  user_data = <<-EOF
#!/bin/bash -xe
# Cập nhật hệ thống
apt update -y
# Cài đặt Node.js, unzip, wget, npm, và jq (để xử lý JSON từ Secrets Manager)
apt install nodejs unzip wget npm jq -y
# Tải mã nguồn ứng dụng
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-DEV/code.zip -P /home/ubuntu
cd /home/ubuntu
# Giải nén mã nguồn, bỏ qua thư mục node_modules
unzip code.zip -x "resources/codebase_partner/node_modules/*"
cd resources/codebase_partner
# Cài đặt các phụ thuộc
npm install aws aws-sdk
# Lấy thông tin đăng nhập RDS từ Secrets Manager
export APP_DB_HOST=$(aws secretsmanager get-secret-value --secret-id Mydbsecret --query SecretString --output text --region ${var.region} | jq -r .host)
export APP_DB_USER=$(aws secretsmanager get-secret-value --secret-id Mydbsecret --query SecretString --output text --region ${var.region} | jq -r .user)
export APP_DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id Mydbsecret --query SecretString --output text --region ${var.region} | jq -r .password)
export APP_DB_NAME=$(aws secretsmanager get-secret-value --secret-id Mydbsecret --query SecretString --output text --region ${var.region} | jq -r .db)
# Cấu hình cổng ứng dụng
export APP_PORT=80
# Khởi động ứng dụng
npm start &
# Đảm bảo ứng dụng tự động chạy khi khởi động lại
echo '#!/bin/bash -xe
cd /home/ubuntu/resources/codebase_partner
export APP_PORT=80
npm start' > /etc/rc.local
chmod +x /etc/rc.local
EOF

  tags = {
    Name = "CapstoneAppServer"
  }
}