locals {
  bucket_terraform_state = var.bucket_terraform_state != "" ? var.bucket_terraform_state : "littlehorse-byoc-terraform-state"
}
