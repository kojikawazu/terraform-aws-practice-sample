# ---------------------------------------------
# ECS - IAM role
# ---------------------------------------------
resource "aws_iam_role" "ecs_iam_role" {
  name = "${var.project}-${var.environment}-ecs-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ---------------------------------------------
# CloudWatch - IAMロール
# ---------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-${var.environment}-cw-ecs-task-execution-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ---------------------------------------------
# CloudWatch - IAMロールポリシー
# ---------------------------------------------
resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name = "${var.project}-${var.environment}--cw-ecs-task-execution-iam-role-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}