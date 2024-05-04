# ---------------------------------------------
# key pair
# ---------------------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("${var.key_pair_path}")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# EC2 instance
# ---------------------------------------------
resource "aws_instance" "grafana_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.grafana_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name
  key_name             = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2-grafana"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}

resource "aws_instance" "exporter_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet_1c.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.exporter_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name
  key_name             = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2-exporter"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}