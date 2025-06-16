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
  description = "The name of the GCS bucket to store Terraform state."
  default     = ""
  type        = string
}
