
# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name
}

# VPC for EKS
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(local.tags, { Name = "eks-vpc" })
}

resource "aws_subnet" "eks_subnets" {
  count           = var.number_of_subnets
  vpc_id          = aws_vpc.eks_vpc.id
  cidr_block      = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.tags, { Name = "eks-subnet-${count.index}" })
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(local.tags, { Name = "eks-igw" })
}

resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = merge(local.tags, { Name = "eks-route-table" })
}

resource "aws_route_table_association" "eks_route_table_assoc" {
  count          = var.number_of_subnets
  subnet_id      = aws_subnet.eks_subnets[count.index].id
  route_table_id = aws_route_table.eks_route_table.id
}

# EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role1"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
  })

  tags = merge(local.tags, { Name = "eks-cluster-role" })
}

# Attaching recommended policies to the cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy",
  ])

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.key
  
}


resource "aws_iam_role" "eks-node-role" {
  name = "eks-node-group-example1"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
					"ec2.amazonaws.com",
					"pods.eks.amazonaws.com"
				]
      }
    }]
    Version = "2012-10-17"
  })
  tags = merge(local.tags, { Name = "eks-node-group-example" })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}
resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.eks-node-role.name
}
resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.eks-node-role.name
}



resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }

  tags = merge(local.tags, { Name = var.eks_cluster_name })
}
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "main-node"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = aws_subnet.eks_subnets[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# SQS Queue
resource "aws_sqs_queue" "my_queue" {
  name                      = var.sqs_queue_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400

  tags = merge(local.tags, { Name = var.sqs_queue_name })
}


