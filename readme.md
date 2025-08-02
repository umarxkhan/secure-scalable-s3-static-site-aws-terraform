# Secure and Scalable S3 Static Website with CloudFront and ACM

This Terraform project configures a CloudFront distribution and ACM certificate for an **existing S3 bucket** hosting a static website.

---

## Folder Structure

```plaintext
secure-scalable-s3-static-site-aws-terraform/
├── main.tf                  # Root Terraform config referencing modules and data sources
├── variables.tf             # Variables definitions used in root module
├── outputs.tf               # Outputs from the root module
├── terraform.tfvars         # Your variable values (DON'T commit secrets here!)
├── modules/
│   ├── cloudfront-acm/      # CloudFront + ACM module
│   │   ├── main.tf          # Module’s Terraform config
│   │   ├── variables.tf     # Module variables
│   │   └── outputs.tf       # Module outputs
│   └── lambda-api-contact-form/ # Lambda API module for contact form (optional)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── scripts/
└── deploy.ps1           # PowerShell deploy script for Terraform
```plaintext
---

## Overview

- Uses a **pre-created S3 bucket** (outside this project) as the website origin
- Sets up **CloudFront distribution** to serve content securely and efficiently
- Configures **Origin Access Identity (OAI)** so only CloudFront can access the S3 bucket
- Applies bucket policy to allow CloudFront read access
- Supports optional ACM certificate for HTTPS (currently uses default CloudFront cert)
- Modular Terraform code for easy reuse and maintenance

---

## Prerequisites

- You must have an existing **S3 bucket** hosting your static website content.
- The bucket should be **private** or accessible only through CloudFront OAI.
- You should know the bucket name and website endpoint (e.g., `bucket-name.s3-website-us-east-1.amazonaws.com`).

---

## Usage

1. Update `terraform.tfvars` with your existing bucket name and other parameters.

2. Run Terraform commands:

   ```bash
   terraform init
   terraform plan
   terraform apply

3. After deployment, your website will be accessible via the CloudFront domain provided in the outputs.

---

## Notes

* This project **does NOT create or manage the S3 bucket** itself.
* It assumes the bucket already contains your static website files.
* Ensure the bucket policy allows access for the CloudFront OAI (this is managed by this Terraform project).
* Adjust your DNS records to point your domain to the CloudFront distribution if needed.

---

## License

This project is provided as-is with no warranties. Use at your own risk.

---

## Author

Mubarak Ahmad Khan
