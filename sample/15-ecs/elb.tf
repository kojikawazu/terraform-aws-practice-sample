# ---------------------------------------------
# ELB - ALB
# ---------------------------------------------
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.ecs_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]
}

# ---------------------------------------------
# ELB - ターゲットグループ
# ---------------------------------------------
resource "aws_lb_target_group" "ecs_alb_target_group" {
  name = "${var.project}-${var.environment}-ecs-alb-tg"

  # ターゲットグループを作成するVPC
  vpc_id = aws_vpc.vpc.id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-alb-tg"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# ELB - リスナー
# ---------------------------------------------
resource "aws_lb_listener" "ecs_alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }
}

# ---------------------------------------------
# ELB - リスナールール
# ---------------------------------------------
resource "aws_lb_listener_rule" "ecs_alb_listerner_rule" {
  # ルールを追加するリスナー
  listener_arn = aws_lb_listener.ecs_alb_listener_http.arn

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
