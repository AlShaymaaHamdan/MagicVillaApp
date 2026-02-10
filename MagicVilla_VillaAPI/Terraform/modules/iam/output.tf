output "github_iam_user_name" {
  description = "IAM user used by GitHub Runner"
  value       = aws_iam_user.gh_iam_user.name
}

# use these in GH Actions Secrets
output "github_access_key_id" {
  description = "Access key ID for GitHub Runner"
  value       = aws_iam_access_key.gh_key.id
}

output "github_secret_access_key" {
  description = "Secret access key for GitHub Runner"
  value       = aws_iam_access_key.gh_key.secret
  sensitive   = true
}
