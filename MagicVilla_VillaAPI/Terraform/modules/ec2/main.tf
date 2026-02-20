#################################
# Ubuntu 22.04 AMI
#################################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # official Ubuntu AMIs from Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#################################
# EC2 Instance
#################################

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

#   user_data = var.user_data

  tags = {
    Name        = var.name
    Environment = var.environment
  }
    # =========================
  # Root EBS volume
  # =========================
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30    # 30 GB
    delete_on_termination = true
  }

}


