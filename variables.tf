variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "project_name" {
  type    = string
  default = "devops-mse"
}

variable "owner" {
  type    = string
  default = "student"
}

variable "ami_name" {
  type    = string
  default = "al2023-ami-2023.*-x86_64"
}