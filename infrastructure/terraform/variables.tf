variable "project" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "two-tier-app"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "app_server_ami_id" {
  description = "AMI ID for EC2 instances (Ubuntu 22.04 LTS recommended)"
  type        = string
}

variable "app_server_instance_type" {
  description = "EC2 instance type for the Flask app server"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  type = string
}