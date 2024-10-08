/**
* # Reverse Proxy
*
* A very basic module to help deploy a reverse proxy.
*
* Packages required are:
*  - Ubuntu18 or 20 AMI
*  - Nginx
*
* This module will:
*   * Configure Nginx on boot.
*   * Setup DNS entries for the reverse proxy using the partner_resid.
*
*  _A current limitation of this approach might be that a reboot of the instance won't be handled by Route53._
*
*  Usage:
*  ```
*  module "reverse-proxy" {
*    source = "./modules/reverse-proxy"
*
*    target_ip                = aws_instance.default.private_ip
*    instance_hostname        = "webterm-${var.partner_resid}"
*    instance_alias           = var.partner_resid
*    instance_key_name        = "booboo"
*    instance_subnet_id       = random_shuffle.subnet.result[0]
*    instance_security_groups = [aws_security_group.public.id]
*    instance_route53_zone_id  = data.aws_route53_zone.selected.zone_id
*    instance_domain          = local.instance_domain
*
*    tags = local.tags
*  }
*
*  ```
*
*/

locals {
  domain_name = replace(data.aws_route53_zone.instance.name, "/\\.$/", "")
  hostname    = "${var.instance_hostname}.${local.domain_name}"

  tags = {
    Role = "reverse-proxy"
    Name = var.instance_hostname
  }
}


resource "aws_instance" "default" {
  ami                    = data.aws_ami.default.id
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = var.instance_subnet_id
  iam_instance_profile   = var.instance_profile
  user_data              = data.template_file.init.rendered
  monitoring             = var.monitoring

  tags = merge(var.tags, local.tags)
}

resource "aws_route53_record" "default" {
  zone_id = var.instance_domain_zone_id
  name    = local.hostname
  type    = "A"
  ttl     = "30"
  records = [aws_instance.default.public_ip]
}

resource "aws_security_group" "this" {
  vpc_id      = var.instance_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, local.tags)
}

# This rule is appended to the reservation instance to allow
resource "aws_security_group_rule" "target" {
  type                     = "ingress"
  from_port                = var.target_service_port
  to_port                  = var.target_service_port
  protocol                 = "tcp"
  security_group_id        = var.target_security_group_id
  source_security_group_id = aws_security_group.this.id
}
