# Terraform Backend Configuration for State Storage

terraform {
  backend "s3" {
    bucket         = "devops-tf-state-12345"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
