# ---------------------------------------------
# Security Group
# ---------------------------------------------
# web security group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web front security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_out_tcp3000" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.app_port
  to_port                  = var.app_port
  source_security_group_id = aws_security_group.app_sg.id
}

# ---------------------------------------------------------------------------

# app security group
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app_in_tcp3000" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.app_port
  to_port                  = var.app_port
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app_out_http" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app_out_https" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app_out_tcp3306" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.db_sg.id
}

# ---------------------------------------------------------------------------

# opmng security group
resource "aws_security_group" "opmng_sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "operation management security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "opmng_in_ssh" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_in_tcp3000" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.app_port
  to_port           = var.app_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_http" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_https" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------------------------------------

# DB security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "db server security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.app_sg.id
}