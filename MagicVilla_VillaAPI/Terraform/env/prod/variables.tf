#################################
# EC2
#################################

variable "ami_id" {
  description = "AMI ID for prod server"
  type        = string
}


variable "subnet_id" {
  description = "Subnet where EC2 will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to EC2"
  type        = list(string)
}

#################################
# Common tags
#################################

# variable "environment" {
#   description = "Environment name"
#   type        = string
# }
#################################
# EC2 Variables
#################################
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "environment" {
  description = "Environment name, e.g., prod, dev"
  type        = string
}

#################################
# VPC Variables
#################################
variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for public subnet"
  type        = string
}
