#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Use: $0 <REPOSITORY_NAME> OPTIONAL:<AWS_REGION>"
  exit 1
fi

REPOSITORY_NAME="$1"
REGION="${2:-${AWS_REGION:-${AWS_DEFAULT_REGION:-}}}"
ORGANIZATION_NAME="littlehorse-cloud"
TERRAFORM_VERSION="1.9.8"
MODULE_VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/littlehorse-cloud/terraform-aws-byoc-setup.git | grep -v '\^{}' | tail -n1 | sed 's/.*\///; s/^v//')"

WORKDIR="tf-byoc-module"

# When piped (curl | bash) stdin is the script itself, so prompts must read from the terminal.
prompt() {
  read -r -p "$1" "$2" </dev/tty
}

if [ -z "$MODULE_VERSION" ]; then
  echo "Error: Unable to fetch the latest module version."
  exit 1
fi

if [ -d "$WORKDIR" ]; then
  echo "Error: There is an existing state, if you want to preserve state then run terraform from within ./$WORKDIR folder, otherwise delete the folder and try again."
  exit 1
fi

if ! command -v aws &>/dev/null; then
  echo "aws cli is not installed. Please install it first."
  exit 1
fi

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

if [ -z "$REGION" ]; then
  REGION="$(aws configure get region 2>/dev/null || true)"
fi

if [ -z "$REGION" ]; then
  echo "Error: No AWS region found. Pass it as the second argument or set AWS_REGION."
  exit 1
fi

while true; do
  prompt "Setup BYOC in AWS account $ACCOUNT_ID, region $REGION? (y/n): " CONFIRMATION
  case "$CONFIRMATION" in
  [Yy]*)
    echo "Confirmed. Using account $ACCOUNT_ID in region $REGION"
    break
    ;;
  [Nn]*)
    echo "Setup canceled."
    exit 1
    ;;
  *)
    echo "Please answer y (yes) or n (no)."
    ;;
  esac
done

if ! command -v terraform &>/dev/null; then
  echo "Terraform not found, installing terraform $TERRAFORM_VERSION..."
  case "$(uname -m)" in
  x86_64) TF_ARCH="amd64" ;;
  aarch64 | arm64) TF_ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
    ;;
  esac
  TF_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  TF_TMP="$(mktemp -d)"
  curl -sSL -o "$TF_TMP/terraform.zip" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TF_OS}_${TF_ARCH}.zip"
  unzip -q "$TF_TMP/terraform.zip" -d "$TF_TMP"
  mkdir -p "$HOME/.local/bin"
  mv "$TF_TMP/terraform" "$HOME/.local/bin/terraform"
  rm -rf "$TF_TMP"
  export PATH="$HOME/.local/bin:$PATH"
fi

mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat >main.tf <<EOF
module "setup_byoc" {
  source  = "littlehorse-cloud/byoc-setup/aws"
  version = "$MODULE_VERSION"

  repository_name   = "aws-byoc-$REPOSITORY_NAME"
  organization_name = "$ORGANIZATION_NAME"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

output "byoc_setup_details" {
  value = merge(module.setup_byoc.byoc_setup_details, {
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
    role_arn   = "arn:aws:iam::\${data.aws_caller_identity.current.account_id}:role/LittleHorseBYOCManager"
  })
  description = "Details of the BYOC setup."
}

provider "aws" {
  region = "$REGION"
}
EOF

terraform init
terraform apply -auto-approve

echo "Setup complete."
