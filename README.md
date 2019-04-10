# GuardDuty with Terraform

![Guarduty](https://d2908q01vomqb2.cloudfront.net/22d200f8670dbdb3e253a90eee5098477c95c23d/2018/03/13/AmazonGuardDuty-for-featured-image.png)
This example shows enabling [GuardDuty](https://aws.amazon.com/documentation/guardduty/)

It includes setting up a group with the policies allowing use of GuardDuty, and an S3 bucket.

# Terraform-module-guarduty

A terraform module to create a manage [Guarduty](https://aws.amazon.com/guardduty/) across multiple regions
through the [Terraform](https://terraform.io/).


Read the [AWS docs on Guarduty](https://docs.aws.amazon.com/guardduty/index.html).

| Branch | Build status                                                                                                                                                      |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
![master](http://jenkins.sagepaylabs.io/job/terraform-module-guardutyjob/master/badge/icon)

![development](http://jenkins.sagepaylabs.io/job/terraform-module-guarduty/job/master/badge/icon)

## Assumptions

* You want to enable Guarduty in one region at a time
* Need comprehensive threat identiifacitn
* You'are onboarding an account that hasn't been enabled yet

## Usage example

```hcl terraform
module "guarduty" {
  source = "<your_source"

  aws_account_id = 000000
  users = "['admin']"
  aws_region = "eu-west-2"
}
```

## Other documentation

- [SecurityHub](docs/securityhub.md): High level Overview of the components

## Testing


## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](docs/hooks.md) to install pre-commit locally.

And install `terraform-docs` with `go get github.com/segmentio/terraform-docs` or `brew install terraform-docs`.

## IAM Permissions

Testing and using this repo requires a minimum set of IAM permissions. Test permissions
are listed in the [iam README](docs/iam.md).

## Authors

Created and maintained by [Alessio Garofalo](alessio@linux.com)

## License

MIT Licensed. See [LICENSE](LICENSE.md) for full details.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_account\_id |  | string | n/a | yes |
| aws\_profile |  | string | n/a | yes |
| aws\_region |  | string | n/a | yes |
| bucket\_prefix |  | string | `"security"` | no |
| group\_name |  | string | `"guardduty-admin"` | no |
| guardduty\_assets |  | string | `"guardduty"` | no |
| tags |  | map | `<map>` | no |
| users |  | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn |  |
| guardduty\_account\_id |  |
| guardduty\_id |  |

