# ---------------------------------------------
# ECS - タスク定義
# ---------------------------------------------
resource "aws_ecs_task_definition" "ecs_task_def" {
  family = "nginx"

  # IAMロール
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  # データプレーンの選択
  requires_compatibilities = ["FARGATE"]

  # ECSタスクが使用可能なリソースの上限
  # タスク内のコンテナはこの上限内に使用するリソースを収める必要があり、メモリが上限に達した場合OOM Killer にタスクがキルされる
  cpu    = var.ecs_cpu
  memory = var.ecs_memory

  # ECSタスクのネットワークドライバ
  # Fargateを使用する場合は"awsvpc"決め打ち
  network_mode = "awsvpc"

  # 起動するコンテナの定義
  # 「nginxを起動し、80ポートを開放する」設定を記述。
  container_definitions = jsonencode([
    {
      name  = "nginx",
      image = "nginx:latest",
      portMappings = [
        {
          containerPort = var.http_port,
          hostPort      = var.http_port,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name,
          awslogs-region        = "ap-northeast-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ---------------------------------------------
# ECS - クラスタ
# ---------------------------------------------
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"
}

# ---------------------------------------------
# ECS - サービス
# ---------------------------------------------
resource "aws_ecs_service" "ecs_service" {
  name = "${var.project}-${var.environment}-ecs-service"

  # ECSサービスが配置されるクラスタ
  cluster = aws_ecs_cluster.ecs_cluster.id

  # 当該ECSサービスを配置するECSクラスターの指定
  launch_type = "FARGATE"

  # ECSタスクの起動数を定義
  desired_count = var.ecs_desired_count

  # ECSタスクの起動に使用するタスク定義
  task_definition = aws_ecs_task_definition.ecs_task_def.arn

  network_configuration {
    # タスクの起動を許可するサブネット
    subnets = [
      aws_subnet.public_subnet_1a.id,
      aws_subnet.public_subnet_1c.id
    ]
    # タスクに紐づけるセキュリティグループ
    security_groups = [
      aws_security_group.ecs_sg.id
    ]
    # タスクに割り当てるElastic IP
    assign_public_ip = true
  }

  # ECSタスクの起動に使用するロードバランサー
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
    container_name   = "nginx"
    container_port   = var.http_port
  }
}
