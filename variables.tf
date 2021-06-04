variable "tags" {
  description = "A map of tags to apply to all resources created by this module."
  type        = map
}

variable "instance_hostname" {
  description = "The preferred hostname of the reverse proxy node, will have instance_domain appeneded."
}

variable "instance_key_name" {
  description = "The key used to access the AWS instance."
  default     = null
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t3.micro"
  type        = string
}

variable "instance_subnet_id" {
  description = "The VPC subnet the instance will be deployed too."
}

variable "instance_vpc_id" {
  description = "The VPC where the reverse proxy instance will be deployed."
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
  default     = []
}

variable "target_ip" {
  description = "The IP of the node hosting the terminal or IDE where offloaded HTTP connections will be forwarded."
}

variable "target_ingress_rule_security_group_id" {
  description = "This module will grant itself access to the upstream instance by creating an ingress against this security group ID."
}

variable "target_ingress_rule_target_port" {
  description = "The TCP port number to grant access. Usually 8080 when forwarding HTTP requests."
  default     = 8080
}

variable "desktop_enabled" {
  description = "This will enabled the proxy config to use Gucamole -> VNC -> Desktop presentation layer"
  default     = false
  type        = bool
}
