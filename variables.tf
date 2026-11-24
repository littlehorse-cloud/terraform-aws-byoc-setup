variable "repository_name" {
  description = "The name of the GitHub repository to be used for the Workload Identity Pool."
  type        = string
}

variable "organization_name" {
  description = "The name of the GitHub organization to be used for the Workload Identity Pool."
  type        = string
  default     = "littlehorse-cloud"
}

variable "bucket_terraform_state" {
  description = "The name of the S3 bucket to store Terraform state. Defaults to `<ACCOUNT_ID>-lh-byoc-terraform-state`."
  type        = string
  default     = ""
}

variable "byoc_manager_additional_actions" {
  description = "Additional roles to append to BYOCManager Role"
  type        = list(string)
  default     = []
}
