variable "name" {
  description = "Name tag for the instance"
  type        = string
}

# variable "ami_id" {
#   description = "AMI ID"
#   type        = string
# }

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

# variable "user_data" {
#   description = "User data script"
#   type        = string
#   default     = null
# }


variable "environment" {
  description = "Environment name"
  type        = string
}
