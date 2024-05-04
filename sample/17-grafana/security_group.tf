# ---------------------------------------------
# Security Group
# ---------------------------------------------
# grafana security group
resource "aws_security_group" "grafana_sg" {
  name        = "${var.project}-${var.environment}-grafana-sg"
  description = "grafana security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-grafana-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "grafana_in_ssh" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_in_telnet" {
  security_group_id        = aws_security_group.grafana_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.telnet_port
  to_port                  = var.telnet_port
  source_security_group_id = aws_security_group.exporter_sg.id
}

resource "aws_security_group_rule" "grafana_in_icmp" {
  security_group_id        = aws_security_group.grafana_sg.id
  type                     = "ingress"
  from_port                = 8 # Echo request
  to_port                  = 0 # Echo reply
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.exporter_sg.id
}

resource "aws_security_group_rule" "grafana_in_grafana" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.grafana_port
  to_port           = var.grafana_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_in_prometheus" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.prometheus_port
  to_port           = var.prometheus_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_in_blackbox_exporter" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.blackbox_exporter_port
  to_port           = var.blackbox_exporter_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_out_telnet" {
  security_group_id        = aws_security_group.grafana_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.telnet_port
  to_port                  = var.telnet_port
  source_security_group_id = aws_security_group.exporter_sg.id
}


resource "aws_security_group_rule" "grafana_out_icmp" {
  security_group_id        = aws_security_group.grafana_sg.id
  type                     = "egress"
  from_port                = 8 # Echo request
  to_port                  = 0 # Echo reply
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.exporter_sg.id
}

resource "aws_security_group_rule" "grafana_out_http" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_out_https" {
  security_group_id = aws_security_group.grafana_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "grafana_out_node_exporter" {
  security_group_id        = aws_security_group.grafana_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.node_exporter_port
  to_port                  = var.node_exporter_port
  source_security_group_id = aws_security_group.exporter_sg.id
}

# -------------------------------------------------------------------------------
# exporter security group
resource "aws_security_group" "exporter_sg" {
  name        = "${var.project}-${var.environment}-exporter-sg"
  description = "exporter security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-exporter-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "exporter_in_ssh" {
  security_group_id = aws_security_group.exporter_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "exporter_in_telnet" {
  security_group_id        = aws_security_group.exporter_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.telnet_port
  to_port                  = var.telnet_port
  source_security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "exporter_in_icmp" {
  security_group_id        = aws_security_group.exporter_sg.id
  type                     = "ingress"
  from_port                = 8 # Echo request
  to_port                  = 0 # Echo reply
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "exporter_in_node_exporter" {
  security_group_id = aws_security_group.exporter_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.node_exporter_port
  to_port           = var.node_exporter_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "exporter_in_node_exporter2" {
  security_group_id        = aws_security_group.exporter_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.node_exporter_port
  to_port                  = var.node_exporter_port
  source_security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "exporter_out_telnet" {
  security_group_id        = aws_security_group.exporter_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.telnet_port
  to_port                  = var.telnet_port
  source_security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "exporter_out_icmp" {
  security_group_id        = aws_security_group.exporter_sg.id
  type                     = "egress"
  from_port                = 8 # Echo request
  to_port                  = 0 # Echo reply
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "exporter_out_http" {
  security_group_id = aws_security_group.exporter_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = [var.igw_address]
}

resource "aws_security_group_rule" "exporter_out_https" {
  security_group_id = aws_security_group.exporter_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = [var.igw_address]
}
