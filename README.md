# LittleHorse AWS BYOC Setup

This module is to create the required resources to host littlehorse BYOC.

## How to use

```hcl

module "byoc" {
  source  = "littlehorse-cloud/byoc-setup/aws"
  version = "$MODULE_VERSION"
  repository_name = "$REPOSITORY_NAME"
}

provider "aws" {
  region = "$REGION"
}

```

### Replace:

`$MODULE_VERSION` with the latest version of this module.
`$REPOSITORY_NAME` with the github repository hosting the byoc configuration.
`$REGION` with the target AWS region of the installation

## Install via AWS cloud shell

Open AWS CloudShell in the target region.

The script only needs the repository name as a parameter, the AWS region is optional
(defaults to the CloudShell region, `AWS_REGION`).

Run the script

```sh

curl -sSL https://raw.githubusercontent.com/littlehorse-cloud/terraform-aws-byoc-setup/main/scripts/setup.sh | bash -s <REPOSITORY_NAME>

```

**Note: the repository name assumes the prefix `aws-byoc-<REPOSITORY_NAME>`**

If terraform is not installed, the script installs it in `~/.local/bin`.
The default terraform state bucket is named `<ACCOUNT_ID>-lh-byoc-terraform-state`.

Once the process ends, share the output with the sales representative.

## How to contribute

### Requirements

- pre-commit `pip install pre-commit`
- hcledit `brew install minamijoyo/hcledit/hcledit`
- tflint `brew install tflint`

Make sure to install pre-commit

```sh
pre-commit install
```

## Releases

The releases of this module are automated with `git-cliff`.

Conventional commits are used to decide which version will be released

- `fix:` -> increments PATCH.
- `feat:` -> increments MINOR.
- `<scope>!:` (breaking changes) -> increments MAJOR.
- `chore|ci|refactor|style|test|doc"` -> Ignored, won't create a release.

Look at [`cliff.toml`](./cliff.toml) to see a more up to date configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99, < 6 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1, < 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.99, < 6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_versioning.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.github_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_terraform_state"></a> [bucket\_terraform\_state](#input\_bucket\_terraform\_state) | The name of the S3 bucket to store Terraform state. Defaults to `<ACCOUNT_ID>-lh-byoc-terraform-state`. | `string` | `""` | no |
| <a name="input_byoc_manager_additional_actions"></a> [byoc\_manager\_additional\_actions](#input\_byoc\_manager\_additional\_actions) | Additional roles to append to BYOCManager Role | `list(string)` | `[]` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the GitHub organization to be used for the Workload Identity Pool. | `string` | `"littlehorse-cloud"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the GitHub repository to be used for the Workload Identity Pool. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_byoc_setup_details"></a> [byoc\_setup\_details](#output\_byoc\_setup\_details) | Details for BYOC setup |
<!-- END_TF_DOCS -->
