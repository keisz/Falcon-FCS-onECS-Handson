# iam.tf | IAM Role Policies

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_environment}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_environment}-exe-role"
    Environment = var.app_environment
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


#--
resource "aws_iam_role" "ecsTaskRole" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  max_session_duration = "3600"
  name                 = "${var.app_environment}-role"
  path                 = "/"
}

### SSM サービス関連のアクセス許可ポリシー作成
data "aws_iam_policy_document" "ecs_task_role_ssmmessages" {
  version = "2012-10-17"
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs-exec" {
  name        = "EcsExec"
  policy = data.aws_iam_policy_document.ecs_task_role_ssmmessages.json
}

### ポリシーをロールにアタッチ
resource "aws_iam_role_policy_attachment" "ecs-exec" {
  policy_arn = aws_iam_policy.ecs-exec.arn
  role       = aws_iam_role.ecsTaskRole.name
}

