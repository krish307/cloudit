resource "aws_ecr_repository" "cloudit" {
  name                 = "cloudit-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "cloudit-app"
    Project     = "CloudIt"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
resource "aws_ecr_lifecycle_policy" "cloudit" {
  repository = aws_ecr_repository.cloudit.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Remove untagged images after 7 days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2

        description = "Keep only the latest 10 tagged images"

        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["sha-"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}