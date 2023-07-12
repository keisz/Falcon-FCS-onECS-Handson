# web-dvwa alb 
resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.ecsdemo-sg.id]

  tags = {
    Name = "${var.app_name}-alb"
    env  = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecsdemo-vpc.id

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "15"
    path                = "/login.php"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    env = var.app_environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

############################################################
# detection-container alb 
resource "aws_alb" "application_load_balancer_auto_detection" {
  name               = "${var.app_name_auto_detection}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.ecsdemo-sg.id]

  tags = {
    Name = "${var.app_name_auto_detection}-alb"
    env  = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group_auto_detection" {
  name        = "${var.app_name_auto_detection}-${var.app_environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecsdemo-vpc.id

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "15"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name_auto_detection}-lb-tg"
    env = var.app_environment
  }
}

resource "aws_lb_listener" "listener_auto_detection" {
  load_balancer_arn = aws_alb.application_load_balancer_auto_detection.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_auto_detection.id
  }
}
