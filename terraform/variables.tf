variable "aws_region" {
  description = "AWS region used for the DevOps lab"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "aws-cicd-devops-lab"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}
