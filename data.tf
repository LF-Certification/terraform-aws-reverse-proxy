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
    hostname      = local.hostname
    alias         = local.alias
    target_ip     = var.target_ip
    certbot_email = var.certbot_email
  }
}
