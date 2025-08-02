# Change directory to the root folder containing .tf files
Set-Location -Path (Join-Path $PSScriptRoot "..")

Write-Host "Initializing Terraform..."
terraform init

Write-Host "Validating config..."
terraform validate

Write-Host "Planning infrastructure..."
terraform plan

Read-Host "Apply? Press Enter to continue or Ctrl+C to cancel."

terraform apply --auto-approve
