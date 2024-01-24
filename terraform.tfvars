project            = "sample-project"
environment        = "dev"
vpc_address        = "192.168.0.0/20"
public_1a_address  = "192.168.11.0/24"
public_1c_address  = "192.168.12.0/24"
private_1a_address = "192.168.13.0/24"
private_1c_address = "192.168.14.0/24"
key_pair_path      = "./private/key/app-dev-keypair.pub"
ec2_instance_type  = "t2.micro"
//ami_name      = "al2023-ami-2023.3.20231218.0-kernel-6.1-x86_64"
ami_name         = "sample-project-app-ami"
http_port        = 80
https_port       = 443
db_port          = 3306
app_port         = 3000
ssh_port         = 22
domain           = "kawariru.com"
db_engine        = "mysql"
db_version       = "8.0"
db_full_version  = "8.0.35"
db_username      = "admin"
db_name          = "mysql_db_name"
db_instance_type = "db.t2.micro"
