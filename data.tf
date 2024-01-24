data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3"
}

data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}