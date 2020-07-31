data "aws_ami" "default" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["reverse-proxy-*"]
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/user-data.sh.tmpl")}"
  vars = {
    hostname  = local.hostname
    target_ip = var.target_ip
  }
}

data "aws_route53_zone" "instance" {
  zone_id = var.instance_domain_zone_id
}
