data "aws_ami" "default" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["reverse-proxy2-*"]
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/user-data.sh.tmpl")}"

  vars = {
    hostname        = local.hostname
    target_ip       = var.target_ip
    target_port     = var.target_ingress_rule_target_port
    vnc_password    = "password"
    desktop_enabled = var.desktop_enabled
  }
}

data "aws_route53_zone" "instance" {
  zone_id = var.instance_domain_zone_id
}
