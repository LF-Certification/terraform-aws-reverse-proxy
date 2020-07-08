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
