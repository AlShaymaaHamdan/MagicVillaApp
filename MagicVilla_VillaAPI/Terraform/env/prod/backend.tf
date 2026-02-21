terraform {
  backend "s3" {
    bucket         = "tf-state-shaymaa"  # your S3 bucket
    key            = "/envprod/terraform.tfstate"     # path inside the bucket
    region         = "us-west-2"
    dynamodb_table = "tf-lock-alshaymaa"            # DynamoDB table for locking
    encrypt        = true                          # encrypt state at rest
  }
}
