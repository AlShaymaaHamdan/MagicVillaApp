# Create iam user and save access keys so gh-runner can use them
# create iam group for Github user
resource "aws_iam_group" "gh-iam-group" {
  name = var.github_iam_group_name
}

# create iam user for Github runner
resource "aws_iam_user" "gh-iam-user" {
  name = var.github_iam_user_name
}

# Add gh-user to gh-group
resource "aws_iam_user_group_membership" "gh-membership" {
  user = aws_iam_user.gh-iam-user.name

  groups = [
    aws_iam_group.gh-iam-group.name
  ]
}

resource "aws_iam_access_key" "gh-key" {
  user = aws_iam_user.gh-iam-user.name
}

# Assign a permission to gh-runner
resource "aws_iam_group_policy_attachment" "ecr-policy-attach" {
  group       = aws_iam_group.gh-iam-group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

#------------------------------------#
# create iam role for deployment ec2
data "aws_iam_policy" "ecr_power" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}