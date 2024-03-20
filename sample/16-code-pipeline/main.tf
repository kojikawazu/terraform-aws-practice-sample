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

variable "igw_address" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "ecs_port" {
  type = number
}

variable "ecs_desired_count" {
  type = number
}

variable "ecs_cpu" {
  type = number
}

variable "ecs_memory" {
  type = number
}

variable "ecs_container_name" {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "ecr_repository_uri" {
  type = string
}

variable "code_pipeline_s3_bucket_lifecycle_expiration" {
  type = string
}

variable "code_commit_branch_name" {
  type = string
}

variable "code_build_timeout" {
  type = number
}

variable "code_build_spec_yml" {
  type = string
}

variable "code_build_ecs_log_arn" {
  type = string
}

variable "code_deploy_image_definitions" {
  type = string
}

variable "ssm_parameter_ecr_repo_uri" {
  type = string
}
