terraform {
  backend "s3" {
    bucket         = "tf-state-shaymaa"  # your S3 bucket
    key            = "prod/terraform.tfstate"     # path inside the bucket
    region         = var.region
    dynamodb_table = "tf-lock-alshaymaa"            # DynamoDB table for locking
    encrypt        = true                          # encrypt state at rest
  }
}
