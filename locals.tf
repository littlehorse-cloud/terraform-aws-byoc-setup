locals {
  byoc_manager_actions = concat([
    "ec2:*",
    "eks:*",
    "elasticloadbalancing:*",
    "kms:*",
    "route53:*",
    "route53domains:*"
  ], var.byoc_manager_additional_actions)
  bucket_terraform_state = var.bucket_terraform_state != "" ? var.bucket_terraform_state : "littlehorse-byoc-terraform-state"
}
