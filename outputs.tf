output "byoc_setup_details" {
  description = "Details for BYOC setup"
  value = {
    bucket_name       = aws_s3_bucket.terraform_state.id
    workload_provider = aws_iam_openid_connect_provider.github.url
  }
}
