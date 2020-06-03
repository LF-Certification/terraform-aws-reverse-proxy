output "instance_public_ip" {
  value = aws_instance.default.public_ip
}

output "default_instance_private_ip" {
  value = aws_instance.default.private_ip
}

output "default_instance_ssh_user" {
  value = aws_instance.default.tags.SSHUser
}

output "default_instance_ssh_login" {
  value = "${aws_instance.default.tags.SSHUser}@${local.hostname}"
}
