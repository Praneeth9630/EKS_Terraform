terraform {
  backend "s3" {
    bucket = "praneeth9630" # Replace with your actual S3 bucket name
    key    = "EKS_Terraform_Dir/terraform.tfstate"
    region = "us-east-1"
  }
}
