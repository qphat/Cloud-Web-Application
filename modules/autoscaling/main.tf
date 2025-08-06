# Tạo Launch Template cho Auto Scaling Group
resource "aws_launch_template" "capstone_launch_template" {
  name          = "CapstoneLaunchTemplate"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
  user_data = base64encode(<<-EOF
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
  )
  tags = {
    Name = "CapstoneLaunchTemplate"
  }
}

# Tạo Auto Scaling Group
resource "aws_autoscaling_group" "capstone_asg" {
  name                = "CapstoneAutoScalingGroup"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4
  vpc_zone_identifier = [var.public_subnet_1_id, var.public_subnet_2_id]
  target_group_arns   = [var.target_group_arn]
  launch_template {
    id      = aws_launch_template.capstone_launch_template.id
    version = "$Latest"
  }
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tags = [
    {
      key                 = "Name"
      value               = "CapstoneASGInstance"
      propagate_at_launch = true
    }
  ]
}

# Tạo Scaling Policy dựa trên CPU utilization
resource "aws_autoscaling_policy" "capstone_scaling_policy" {
  name                   = "CapstoneScalingPolicy"
  autoscaling_group_name = aws_autoscaling_group.capstone_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}