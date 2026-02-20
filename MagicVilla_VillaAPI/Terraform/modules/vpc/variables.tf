variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
