# Tạo secret trong AWS Secrets Manager để lưu trữ thông tin đăng nhập RDS
resource "aws_secretsmanager_secret" "mydbsecret" {
  name        = "Mydbsecret"
  description = "Database secret for web application"
  tags = {
    Name = "Mydbsecret"
  }
}

# Tạo phiên bản secret với thông tin đăng nhập RDS
resource "aws_secretsmanager_secret_version" "mydbsecret_version" {
  secret_id = aws_secretsmanager_secret.mydbsecret.id
  secret_string = jsonencode({
    user     = var.db_user
    password = var.db_password
    host     = var.rds_endpoint
    db       = var.db_name
  })
}