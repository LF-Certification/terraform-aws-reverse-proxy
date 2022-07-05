# Reverse Proxy

A very basic module to help deploy a reverse proxy.

Packages required are:
 - Ubuntu18 or 20 AMI
 - Nginx

This module will:
  * Configure Nginx on boot.
  * Setup DNS entries for the reverse proxy using the partner\_resid.

 \_A current limitation of this approach might be that a reboot of the instance won't be handled by Route53.\_

 Usage:
 ```
 module "reverse-proxy" {
   source = "./modules/reverse-proxy"

   target_ip                = aws_instance.default.private_ip
   instance_hostname        = "webterm-${var.partner_resid}"
   instance_alias           = var.partner_resid
   instance_key_name        = "booboo"
   instance_subnet_id       = random_shuffle.subnet.result[0]
   instance_security_groups = [aws_security_group.public.id]
   instance_route53_zone_id  = data.aws_route53_zone.selected.zone_id
   instance_domain          = local.instance_domain

   tags = local.tags
 }

 ```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_version_filter"></a> [ami\_version\_filter](#input\_ami\_version\_filter) | The filter for locating the ami to run (e.g.  reverse-proxy2-<VERSION>) | `string` | `"master-*"` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Enable/Disable Datadog agent | `bool` | `false` | no |
| <a name="input_desktop_enabled"></a> [desktop\_enabled](#input\_desktop\_enabled) | This will enabled the proxy config to use Gucamole -> VNC -> Desktop presentation layer | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_instance_domain"></a> [instance\_domain](#input\_instance\_domain) | The actual name of the domain, ie e.exams.com. | `any` | n/a | yes |
| <a name="input_instance_domain_zone_id"></a> [instance\_domain\_zone\_id](#input\_instance\_domain\_zone\_id) | The Route53 zone where a DNS entry will be created for accessing the instance. | `any` | n/a | yes |
| <a name="input_instance_hostname"></a> [instance\_hostname](#input\_instance\_hostname) | The preferred hostname of the reverse proxy node, will have instance\_domain appeneded. | `any` | n/a | yes |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | The key used to access the AWS instance. | `string` | `null` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | The AWS EC2 instance profile ARN to use to the instance. | `string` | n/a | yes |
| <a name="input_instance_security_groups"></a> [instance\_security\_groups](#input\_instance\_security\_groups) | A list of security groups applied to the reverse proxy EC2 instance. | `list` | `[]` | no |
| <a name="input_instance_subnet_id"></a> [instance\_subnet\_id](#input\_instance\_subnet\_id) | The VPC subnet the instance will be deployed too. | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type | `string` | `"t3.micro"` | no |
| <a name="input_instance_vpc_id"></a> [instance\_vpc\_id](#input\_instance\_vpc\_id) | The VPC where the reverse proxy instance will be deployed. | `any` | n/a | yes |
| <a name="input_partner_resid"></a> [partner\_resid](#input\_partner\_resid) | The reservation PARTNER\_RESID | `string` | n/a | yes |
| <a name="input_ssm_ssl_path"></a> [ssm\_ssl\_path](#input\_ssm\_ssl\_path) | SSM Base path for Nginx SSL files | `string` | `"/LF/Certification/reverse-proxy/SSL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources created by this module. | `map` | n/a | yes |
| <a name="input_target_ip"></a> [target\_ip](#input\_target\_ip) | The IP of the node hosting the terminal or IDE where offloaded HTTP connections will be forwarded. | `any` | n/a | yes |
| <a name="input_target_security_group_id"></a> [target\_security\_group\_id](#input\_target\_security\_group\_id) | Used to grant the reverse proxy access to a target | `any` | n/a | yes |
| <a name="input_target_service_port"></a> [target\_service\_port](#input\_target\_service\_port) | The TCP port which the target service is listening on | `number` | `8080` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_instance_private_ip"></a> [default\_instance\_private\_ip](#output\_default\_instance\_private\_ip) | n/a |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | n/a |
