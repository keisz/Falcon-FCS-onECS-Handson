variable "aws_region" {
  type = string
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_name_auto_detection" {
  type        = string
  description = "fileless App Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "image_url" {
  type        = string
  description = "web-dvwa container image url"
}

variable "image_url_auto_detection" {
  type        = string
  description = "crowdstrike detection container image url"
}

variable "falcon-sensor_ecr_name" {
  type        = string
  description = "Elastic Container Registry for Falcon-Sensor"
}

