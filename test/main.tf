locals {
  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}

module "reverse-proxy" {
  source = "../"

  target_ip                             = "10.123.123.123"
  instance_hostname                     = "test-hostname"
  instance_vpc_id                       = module.vpc.vpc_id
  instance_key_name                     = ""
  instance_subnet_id                    = module.vpc.public_subnets[0]
  target_ingress_rule_security_group_id = aws_security_group.target.id
  instance_domain_zone_id               = aws_route53_zone.default.zone_id
  instance_domain                       = ""

  tags = local.tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.tags
}

resource "aws_route53_zone" "default" {
  name = "ae235106-d3f7-42862b-c272d46.com"

  tags = local.tags
}

resource "aws_security_group" "target" {
  name_prefix = "reverse-proxy-test"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags
}

