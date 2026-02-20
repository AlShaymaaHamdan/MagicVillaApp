# Created a GH self-hosted runner instead

# # Create iam user and save access keys so gh-runner can use them
# # create iam group for Github user
# resource "aws_iam_group" "gh-iam-group" {
#   name = var.github_iam_group_name
# }

# # create iam user for Github runner
# resource "aws_iam_user" "gh-iam-user" {
#   name = var.github_iam_user_name
# }

# # Add gh-user to gh-group
# resource "aws_iam_user_group_membership" "gh-membership" {
#   user = aws_iam_user.gh-iam-user.name

#   groups = [
#     aws_iam_group.gh-iam-group.name
#   ]
# }

# resource "aws_iam_access_key" "gh-key" {
#   user = aws_iam_user.gh-iam-user.name
# }

# # Assign a permission to gh-runner
# resource "aws_iam_group_policy_attachment" "ecr-policy-attach" {
#   group       = aws_iam_group.gh-iam-group.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
# }

#------------------------------------#
#################################
# Assume role for EC2
#################################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#################################
# Role
#################################

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

#################################
# Policy 
#################################

resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.role_name}-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      #################################
      # ECR Pull
      #################################
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
      },

      #################################
      # SSM (Session Manager)
      #################################
      {
        Effect = "Allow"
        Action = [
          "ssm:*",
          "ec2messages:*",
          "ssmmessages:*"
        ]
        Resource = "*"
      },

      #################################
      # EC2 Describe (optional but safe)
      #################################
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }

    ]
  })
}

#################################
# Instance Profile
#################################

resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name
}