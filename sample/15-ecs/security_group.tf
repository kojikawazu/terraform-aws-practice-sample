# ---------------------------------------------
# ELB - セキュリティグループ
# ---------------------------------------------
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-${var.environment}-ecs-sg"
  description = "ecs security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-sg"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# ELB - セキュリティルール
# ---------------------------------------------
resource "aws_security_group_rule" "ecs_in_http" {
  security_group_id = aws_security_group.ecs_sg.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = var.http_port
  to_port     = var.http_port
  cidr_blocks = [var.igw_address]
}

resource "aws_security_group_rule" "ecs_out_http" {
  security_group_id = aws_security_group.ecs_sg.id

  type        = "egress"
  protocol    = "tcp"
  from_port   = var.http_port
  to_port     = var.http_port
  cidr_blocks = [var.igw_address]
}

resource "aws_security_group_rule" "ecs_in_https" {
  security_group_id = aws_security_group.ecs_sg.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = var.https_port
  to_port     = var.https_port
  cidr_blocks = [var.igw_address]
}

resource "aws_security_group_rule" "ecs_out_https" {
  security_group_id = aws_security_group.ecs_sg.id

  type        = "egress"
  protocol    = "tcp"
  from_port   = var.https_port
  to_port     = var.https_port
  cidr_blocks = [var.igw_address]
}