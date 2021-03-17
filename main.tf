# Terraform configuration

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "vc-vpc-tf" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vc-vpc
  cidr = var.vpc-cidr

  azs              = var.vpc-azs
  private_subnets  = var.vc-pv-sn
  public_subnets   = var.vc-pb-sn
  database_subnets = var.rds-sn

  tags = var.vc-tags
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "web-server"
  description         = "Security group for ec2 instance, custom ports and VPC"
  vpc_id              = module.vc-vpc-tf.vpc_id
  ingress_cidr_blocks = [var.cidr-web-sg]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]

}

module "vc-rds-sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "rds-sg"
  vpc_id              = module.vc-vpc-tf.vpc_id
  ingress_cidr_blocks = [var.cidr-web-sg]
  ingress_rules       = ["mysql-tcp"]
  egress_rules        = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.web_server_sg.this_security_group_id
    },
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Service name"
      source_security_group_id = module.web_server_sg.this_security_group_id
    }
  ]


}

module "ec2_instances" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.12.0"
  ami                    = "ami-04d29b6f966df1537"
  instance_type          = "t2.micro"
  name                   = "vc-web-glob-instance"
  key_name               = var.key
  vpc_security_group_ids = [module.web_server_sg.this_security_group_id]
  subnet_id              = module.vc-vpc-tf.public_subnets[0]
  user_data              = filebase64("${path.module}/install_wp.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "vc-mysql-rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.30.0"

  allocated_storage         = "20"
  backup_window             = "03:00-06:00"
  engine                    = "mysql"
  engine_version            = "5.7.22"
  identifier                = "vc-glob-univ-rds"
  instance_class            = "db.t2.micro"
  maintenance_window        = "Mon:00:00-Mon:03:00"
  password                  = var.rds-pass
  port                      = "3306"
  username                  = "globdb"
  create_db_subnet_group    = true
  vpc_security_group_ids    = [module.vc-rds-sg.this_security_group_id]
  family                    = "mysql5.7"
  subnet_ids                = module.vc-vpc-tf.database_subnets
  create_db_parameter_group = false
  skip_final_snapshot       = true


  # DB option group
  major_engine_version = "5.7"
}




