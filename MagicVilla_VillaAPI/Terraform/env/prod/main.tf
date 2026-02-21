module "iam" {
  source    = "../../modules/iam"
  role_name = "prod-server-role"
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = "${var.environment}-vpc"
  cidr_block         = var.cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  environment        = var.environment
}

module "security" {
  source      = "../../modules/security"
  vpc_id      = module.vpc.vpc_id
  name        = "prod-ec2-sg"
  environment = "prod"
}

module "ecr" {
  source      = "../../modules/ecr"
  name        = "prod-app"
  environment = "prod"
}

module "ec2" {
  source                = "../../modules/ec2"
  name                  = "${var.environment}-server"
  instance_type         = var.instance_type
  subnet_id             = module.vpc.public_subnet_id
  security_group_ids    = [module.security.security_group_id]
  instance_profile_name = module.iam.instance_profile_name
  environment           = var.environment
  # user_data             = file("${path.module}/user_data.sh")
}

resource "local_file" "ansible_inventory" {
  content = <<EOL
all:
  hosts:
    app-server:
      ansible_host: ${module.ec2.public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: /tmp/key.pem
EOL

  filename = "../../../Ansible/inventory.yaml"
}
