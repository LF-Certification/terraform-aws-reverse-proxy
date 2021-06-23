data "aws_ami" "default" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["reverse-proxy2-${ami_version_filter}"]
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/user-data.sh.tmpl")}"

  vars = {
    hostname        = local.hostname
    target_ip       = var.target_ip
    target_port     = var.target_service_port
    vnc_password    = "password"
    desktop_enabled = var.desktop_enabled
    ssm_ssl_path    = var.ssm_ssl_path
  }
}

data "aws_route53_zone" "instance" {
  zone_id = var.instance_domain_zone_id
}

data "aws_caller_identity" "current" {}
