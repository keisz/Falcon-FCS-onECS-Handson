resource "aws_ecr_repository" "falcon-sensor" {
  name                 = var.falcon-sensor_ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    Name = var.falcon-sensor_ecr_name
    env  = var.app_environment
  }
}