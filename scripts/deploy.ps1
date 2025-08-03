# Change directory to the root folder containing .tf files
Set-Location -Path (Join-Path $PSScriptRoot "..")

# Remove old zip if it exists
$zipPath = "./modules/lambda-api-contact-form/lambda-contact-form-code/app.zip"
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Write-Host "Packing Lambda code into ZIP..."
# Compress app.py into the ZIP file (add other files if needed)
Compress-Archive -Path "./modules/lambda-api-contact-form/lambda-contact-form-code/app.py" -DestinationPath $zipPath

Write-Host "Initializing Terraform..."
terraform init

Write-Host "Validating config..."
terraform validate

Write-Host "Planning infrastructure..."
terraform plan

Read-Host "Apply? Press Enter to continue or Ctrl+C to cancel."

terraform apply --auto-approve
