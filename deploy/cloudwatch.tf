resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.app_environment}"
  retention_in_days = 3
}