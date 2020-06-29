/**
* # Reverse Proxy
*
* A very basic module to help deploy a reverse proxy. Really only useful with select specific AMIs.
*
* Packages required are:
*  - Nginx
*  - Certbot
*
* This module will:
*   * Deploy a reverse proxy ec2 instance (nginx) to offload SSL traffic for an exam.
*   * Generate a lets encrypt certificate and install it.
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
*    instance_domain_zone_id  = data.aws_route53_zone.selected.zone_id
*    instance_domain          = local.instance_domain
*    certbot_email            = "email@example.org"
*
*    tags = local.tags
*  }
*
*  ```
*
*/

locals {
  hostname = "${var.instance_hostname}.${var.instance_domain}"
  alias    = "${var.instance_alias}.${var.instance_domain}"

  tags = {
    "Role" = "reverse-proxy"
  }
}

resource "aws_instance" "default" {
  #TODO(pmyjavec) lookup dynamically
  ami                    = data.aws_ami.default.id
  instance_type          = "t3.micro"
  key_name               = var.instance_key_name
  vpc_security_group_ids = var.instance_security_groups
  subnet_id              = var.instance_subnet_id
  user_data              = data.template_file.init.rendered

  tags = merge(var.tags, local.tags)
}

resource "aws_route53_record" "default" {
  zone_id = var.instance_domain_zone_id
  name    = local.hostname
  type    = "A"
  ttl     = "30"
  records = [aws_instance.default.public_ip]
}

# This alias record exists so a certbot validation will succeed because the hostname scheme chosen
# exceeded the allowed 64 character limit:
# https://community.letsencrypt.org/t/ssl-for-a-63-character-max-number-of-characters-domain-name-s/36387/20
resource "aws_route53_record" "alias" {
  zone_id = var.instance_domain_zone_id
  name    = local.alias
  type    = "CNAME"
  ttl     = "30"
  records = [local.hostname]
}
