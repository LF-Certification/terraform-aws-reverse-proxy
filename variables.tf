variable "tags" {
  description = "A map of tags to apply to all resources created by this module."
  type        = map
}

variable "ami_version_filter" {
  description = "The filter for locating the ami to run (e.g.  reverse-proxy2-<VERSION>)"
  default     = "master-*"
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

variable "target_security_group_id" {
  description = "Used to grant the reverse proxy access to a target"
}

variable "target_service_port" {
  description = "The TCP port which the target service is listening on"
  default     = 8080
}

variable "desktop_enabled" {
  description = "This will enabled the proxy config to use Gucamole -> VNC -> Desktop presentation layer"
  default     = false
  type        = bool
}

variable "ssm_ssl_path" {
  description = "SSM Base path for Nginx SSL files"
  default     = "/LF/Certification/reverse-proxy/SSL"
  type        = string
}

variable "instance_profile" {
    description = "The AWS EC2 instance profile ARN to use to the instance."
    type        = string
}

variable "environment" {
    description = "Environment"
    type        = string
}

variable "partner_resid" {
    description = "The reservation PARTNER_RESID"
    type        = string
}

variable "datadog_enabled" {
    description = "Enable/Disable Datadog agent"
    type        = bool
    default     = false
}

variable "monitoring" {
    description = "If true, the launched EC2 instance will have detailed monitoring enabled"
    type        = bool
    default     = false
}
