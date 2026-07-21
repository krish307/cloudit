resource "aws_s3_bucket" "terraform_state" {
  bucket = "cloudit-terraform-state-832569408670"

  tags = {
    Name        = "CloudIt Terraform State"
    Project     = "CloudIt"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "cloudit-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project   = "CloudIt"
    ManagedBy = "Terraform"
  }
}