# Dynamic Tags Helper
locals {
  tags = merge(var.default_tags, { Name = "Dynamic Resource" })
  # policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}
