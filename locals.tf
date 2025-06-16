locals {
  bucket_terraform_state = var.bucket_terraform_state != "" ? var.bucket_terraform_state : "${var.project_id}-terraform-state"
}
