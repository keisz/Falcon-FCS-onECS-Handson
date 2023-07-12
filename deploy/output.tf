output "alb_dns_name" {
  description = "web-dvwa ALB DNS name"
  value       = aws_alb.application_load_balancer.dns_name
}

output "alb_dns_name_auto_detection" {
  description = "detection-container ALB DNS name"
  value       = aws_alb.application_load_balancer_auto_detection.dns_name
}