# Reverse Proxy

A very basic module to help deploy a reverse proxy. Really only useful with select specific AMIs.

Packages required are:
 - Nginx

This module will:
  * Deploy a reverse proxy ec2 instance (nginx) to offload SSL traffic for an exam.
  * Generate a lets encrypt certificate and install it.
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
   instance_domain_zone_id  = data.aws_route53_zone.selected.zone_id
   instance_domain          = local.instance_domain
   certbot_email            = "email@example.org"

   tags = local.tags
 }

```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certbot\_email | The email of the certbot account | `any` | n/a | yes |
| instance\_alias | The alias of the reverse proxy node, will have instance\_domain appeneded. | `any` | n/a | yes |
| instance\_domain | The actual name of the domain, ie e.exams.com. | `any` | n/a | yes |
| instance\_domain\_zone\_id | The Route53 zone where a DNS entry will be created for accessing the instance. | `any` | n/a | yes |
| instance\_hostname | The preferred hostname of the reverse proxy node, will have instance\_domain appeneded. | `any` | n/a | yes |
| instance\_key\_name | The key used to access the AWS instance. | `string` | `null` | no |
| instance\_security\_groups | A list of security groups applied to the reverse proxy EC2 instance. | `list` | n/a | yes |
| instance\_subnet\_id | The subnet the instance will be deployed too. | `any` | n/a | yes |
| tags | A map of tags to apply to all resources created by this module. | `map` | n/a | yes |
| target\_ip | The IP of the node hosting the terminal or IDE where offloaded HTTP connections will be forwarded. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| default\_instance\_private\_ip | n/a |
| default\_instance\_ssh\_login | n/a |
| default\_instance\_ssh\_user | n/a |
| instance\_public\_ip | n/a |

