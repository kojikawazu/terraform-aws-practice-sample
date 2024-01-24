# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "terraform"
  region  = "us-east-1"
}

# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_address" {
  type = string
}

variable "public_1a_address" {
  type = string
}

variable "public_1c_address" {
  type = string
}

variable "private_1a_address" {
  type = string
}

variable "private_1c_address" {
  type = string
}

variable "key_pair_path" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ami_name" {
  type = string
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "db_port" {
  type = number
}

variable "app_port" {
  type = number
}

variable "ssh_port" {
  type = number
}

variable "domain" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_version" {
  type = string
}

variable "db_full_version" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_instance_type" {
  type = string
}
