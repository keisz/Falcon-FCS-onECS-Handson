# web-dvwa task 
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.app_name}-container",
    "image": "${var.image_url}",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/${var.app_environment}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs-${var.app_name}"
       }
     }
  }
]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskRole.arn

  tags = {
    Name = "${var.app_name}-task"
    env  = var.app_environment
  }
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-svc"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecsdemo-sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.listener]
}

###############################################
## detection-container task

resource "aws_ecs_task_definition" "aws-ecs-task_auto_detection" {
  family = "${var.app_name_auto_detection}-task"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.app_name_auto_detection}-container",
    "image": "${var.image_url_auto_detection}",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/${var.app_environment}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs-${var.app_name_auto_detection}"
       }
     }
  }
]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskRole.arn

  tags = {
    Name = "${var.app_name_auto_detection}-task"
    env  = var.app_environment
  }
}

resource "aws_ecs_service" "aws-ecs-service_auto_detection" {
  name                 = "${var.app_name_auto_detection}-svc"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task_auto_detection.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecsdemo-sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_auto_detection.arn
    container_name   = "${var.app_name_auto_detection}-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.listener_auto_detection]
}