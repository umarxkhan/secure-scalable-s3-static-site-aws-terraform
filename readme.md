# Secure and Scalable S3 Static Website with CloudFront, ACM, and Lambda Contact API

This Terraform project provisions a secure and scalable infrastructure on AWS to host a static website on Amazon S3 (pre-existing), delivered globally via Amazon CloudFront CDN for low latency and high availability. The site is secured with HTTPS using an AWS Certificate Manager (ACM) SSL/TLS certificate. To facilitate user interaction, this project deploys a backend AWS Lambda function (app.py), packaged and stored in a dedicated S3 bucket that is provisioned alongside other resources via Terraform. This Lambda function is exposed through Amazon API Gateway, providing a secure and scalable API endpoint for the contact form. Additionally, Origin Access Control (OAC) is implemented to restrict direct public access to the static website’s S3 bucket, ensuring that all requests are served exclusively through CloudFront. The entire infrastructure is designed with modular Terraform configurations to enable streamlined, repeatable, and maintainable deployments.
---

## 📁 Folder Structure

```plaintext
secure-scalable-s3-static-site-aws-terraform/
├── main.tf                   # Root Terraform config referencing modules
├── variables.tf              # Root variable definitions
├── outputs.tf                # Outputs from the root module
├── terraform.tfvars          # Variable values (DO NOT commit secrets)
├── modules/
│   ├── cloudfront-acm/       # CloudFront + ACM module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── lambda-api-contact-form/     # Lambda API module for contact form
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── lambda-contact-form-code/
│           ├── app.py        # Lambda handler
│           └── app.zip       # Zipped Lambda package
├── scripts/
│   ├── deploy.ps1            # Script to deploy infrastructure and upload Lambda ZIP 
│
└── .gitignore                # Excludes .tfvars, .zip, etc.
```

---

## ✅ Features

* **S3-hosted static site** behind **CloudFront** for performance and security
* **ACM certificate** (in us-east-1) for HTTPS support
* **Origin Access Control (OAC)** to restrict direct access to S3
* **Modular Terraform** code for clean separation
* **Lambda + API Gateway** for contact form integration
* **Lambda deployed as ZIP archive** stored in S3
* **one-step deployment** to simplify lifecycle and avoid dependency issues

---

## 🚀 Deployment Steps

> 🔒 AWS credentials must be configured in your shell environment.

### Deploy Infrastructure

This provisions CloudFront, S3 bucket (if not already created), API Gateway, and the initial Lambda function with a placeholder or uploaded ZIP.

```powershell
cd scripts
.\deploy.ps1
```
---

## 🧠 Prerequisites

* Terraform installed and configured
* PowerShell (for running deploy scripts on Windows)
* Valid AWS credentials with permissions for S3, Lambda, ACM, CloudFront, and API Gateway
* Your Lambda ZIP (`app.zip`) in `modules/lambda-api-contact-form/lambda-contact-form-code/`

---

## 📝 Configuration Notes

* **S3 bucket** is **created automatically** and made private
* **Lambda ZIP** is uploaded to a secure S3 bucket and referenced in the Lambda function
* **CORS** is configured for API Gateway (can be modified via variables)
* **DNS** (e.g., Route 53) can be added separately to map a custom domain to the CloudFront URL

---

## ✏️ Variables You Must Provide (`terraform.tfvars`)

```hcl
region = "us-east-1"
domain_name = "yourdomain.com"
hosted_zone_id = "ZXXXXXXXXXXX"     # Optional, if using Route53
certificate_arn = "arn:aws:acm:us-east-1:XXXXXXXXXXXX:certificate/abcd-1234"
lambda_code_bucket = "your-existing-or-created-bucket"
lambda_zip_path = "modules/lambda-api-contact-form/lambda-contact-form-code/app.zip"
```

---

## 🛡️ Security Considerations

* S3 bucket is **not public**; access is granted only to CloudFront
* Contact form Lambda API is exposed only to defined CORS origins
* IAM roles follow **least privilege** with custom managed policies

---

## 🧼 Cleanup

```bash
terraform destroy
```

Will remove all created AWS resources. Make sure your Lambda ZIP and website data are backed up externally if needed.

---

## 👤 Author

Mubarak Ahmad Khan

---

## 📜 License

This project is provided as-is with no warranties. Use at your own risk.

```

---