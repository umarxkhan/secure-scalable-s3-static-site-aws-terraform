#!/bin/bash
set -e  # Exit on any error

echo "Initializing Terraform..."
terraform init

echo "Validating config..."
terraform validate

echo "Planning infrastructure..."
terraform plan

echo "Apply? Press Enter to continue or Ctrl+C to cancel."
read

terraform apply --auto-approve
