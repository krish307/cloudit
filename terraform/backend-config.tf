terraform {
  backend "s3" {
    bucket         = "cloudit-terraform-state-832569408670"
    key            = "cloudit/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "cloudit-terraform-lock"
    encrypt        = true
  }
}
