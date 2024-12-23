aws_region        = "eu-central-1"
vpc_cidr          = "10.0.0.0/16"
number_of_subnets = 3
s3_bucket_name    = "shoval-s3-bucket-prjcloud"
eks_cluster_name  = "shoval-eks-cluster-prjcloud"
sqs_queue_name    = "shoval-sqs-queue-prjcloud"
default_tags = {
  Environment = "Prod"
  ManagedBy   = "Terraform"
  Project     = "CloudTeams"
}
