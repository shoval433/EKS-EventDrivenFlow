output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.arn
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_vpc_id" {
  description = "The VPC ID for EKS"
  value       = aws_vpc.eks_vpc.id
}

output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.my_queue.id
}
