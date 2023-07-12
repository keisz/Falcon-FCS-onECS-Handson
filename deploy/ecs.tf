resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_environment}-cluster"
  tags = {
    Name = "${var.app_environment}-ecs"
    env  = var.app_environment
  }
}
