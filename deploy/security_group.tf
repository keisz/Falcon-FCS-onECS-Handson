resource "aws_security_group" "ecsdemo-sg" {
  name        = "${var.app_name}-sg"
  description = "Allow http traffic."
  vpc_id      = aws_vpc.ecsdemo-vpc.id

  tags = {
    Name = "${var.app_name}-sg"
    env  = var.app_environment
  }
}

resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = aws_security_group.ecsdemo-sg.id
}

resource "aws_security_group_rule" "outbound_all" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.ecsdemo-sg.id
}

