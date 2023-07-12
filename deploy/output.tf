output "alb_dns_name" {
  description = "web-dvwa ALB DNS name"
  value       = aws_alb.application_load_balancer.dns_name
}

output "alb_dns_name_auto_detection" {
  description = "detection-container ALB DNS name"
  value       = aws_alb.application_load_balancer_auto_detection.dns_name
}

output "falcon-sensor_repository_url" {
  description = "Falcon Sensor Repository URL"
  value       = aws_ecr_repository.falcon-sensor.repository_url
}