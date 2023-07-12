resource "aws_ecr_repository" "falcon-sensor" {
  name                 = "falcon-sensor"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  tags = {
    Name = "falcon-sensor-ecr"
    env  = var.app_environment
  }
}