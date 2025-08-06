# Tạo Application Load Balancer
resource "aws_lb" "capstone_alb" {
  name               = "CapstoneALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]
  enable_deletion_protection = false
  tags = {
    Name = "CapstoneALB"
  }
}

# Tạo Target Group để định tuyến lưu lượng đến các EC2 instance
resource "aws_lb_target_group" "capstone_tg" {
  name     = "CapstoneTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "CapstoneTG"
  }
}

# Tạo Listener để chuyển tiếp lưu lượng HTTP đến Target Group
resource "aws_lb_listener" "capstone_listener" {
  load_balancer_arn = aws_lb.capstone_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.capstone_tg.arn
  }
}