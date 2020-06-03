variable "tags" {
  description = "A map of tags to apply to all resources created by this module."
  type        = map
}

variable "certbot_email" {
  description = "The email of the certbot account"
}

variable "instance_hostname" {
  description = "The preferred hostname of the reverse proxy node, will have instance_domain appeneded."
}

variable "instance_alias" {
  description = "The alias of the reverse proxy node, will have instance_domain appeneded."
}

variable "instance_key_name" {
  description = "The key used to access the AWS instance."
  default     = null
  type        = string
}

variable "instance_subnet_id" {
  description = "The subnet the instance will be deployed too."
}
variable "instance_domain_zone_id" {
  description = "The Route53 zone where a DNS entry will be created for accessing the instance."
}

variable "instance_domain" {
  description = "The actual name of the domain, ie e.exams.com."
}

variable "instance_security_groups" {
  description = "A list of security groups applied to the reverse proxy EC2 instance."
  type        = list
}

variable "target_ip" {
  description = "The IP of the node hosting the terminal or IDE where offloaded HTTP connections will be forwarded."
}
