
data "aws_subnet" "existing_subnet" {
  id = "subnet-06ac653833db86d12" # Replace with the ID of your existing subnet
}

data "aws_security_group" "existing_security_group" {
  name = "Mark-1-SG" # Replace with the name of your existing security group
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.3"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"
  subnet_ids      = [data.aws_subnet.existing_subnet.id] # Use the existing subnet
  vpc_id          = "vpc-0db38383340f9b93c" # Replace with your VPC ID
  # Other EKS configurations here
}

resource "aws_eks_cluster" "cluster" {
  name     = module.eks.cluster_name
  role_arn = module.eks.cluster_iam_role_arn
  # Other EKS cluster configurations here
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "Node-cloud"
  node_role_arn    = aws_iam_role.example1.arn
  subnet_ids       = [data.aws_subnet.existing_subnet.id] # Use the existing subnet

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t2.medium"]
}

resource "aws_iam_role" "example1" {
  name = "eks-node-group-example"
  # Other IAM role configurations here
}

# Use the existing security group for the EKS cluster
resource "aws_eks_cluster" "example" {
  # Other EKS cluster configurations here
  vpc_config {
    security_group_ids = [data.aws_security_group.existing_security_group.id]
    # Other VPC configurations here
  }
}
