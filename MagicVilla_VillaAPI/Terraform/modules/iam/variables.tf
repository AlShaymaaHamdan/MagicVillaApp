variable "github_iam_user_name" {
  description = "IAM user name for GitHub runner"
  type        = string
  default     = "gh-runner"
}

variable "github_iam_group_name" {
  description = "IAM group name for GitHub runner"
  type        = string
  default     = "gh-group"
}

