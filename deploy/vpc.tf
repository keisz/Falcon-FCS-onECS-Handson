resource "aws_vpc" "ecsdemo-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = false
  enable_dns_support   = true
  tags = {
    Name = "${var.app_environment}-vpc"
    env  = var.app_environment
  }

}