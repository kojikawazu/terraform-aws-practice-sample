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

variable "region" {
  type = string
}

variable "key_pair_path" {
  type = string
}

variable "public_1a_address" {
  type = string
}

variable "public_1c_address" {
  type = string
}

variable "igw_address" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "telnet_port" {
  type = number
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "grafana_port" {
  type = number
}

variable "prometheus_port" {
  type = number
}

variable "node_exporter_port" {
  type = number
}

variable "blackbox_exporter_port" {
  type = number
}

variable "ec2_instance_type" {
  type = string
}

variable "ami_name" {
  type = string
}