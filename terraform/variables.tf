# AWS Region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

# CIDR Block for VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Number of Subnets
variable "number_of_subnets" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

# Tags for all resources
variable "default_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# S3 Bucket Name
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# EKS Cluster Name
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# SQS Queue Name
variable "sqs_queue_name" {
  description = "Name of the SQS queue"
  type        = string
}
