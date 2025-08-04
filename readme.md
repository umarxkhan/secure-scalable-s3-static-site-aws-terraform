# Secure and Scalable S3 Static Website with CloudFront, ACM, and Lambda Contact API

This Terraform project provisions a secure and scalable infrastructure on AWS to host a static website on Amazon S3 (pre-existing), delivered globally via Amazon CloudFront CDN for low latency and high availability. The site is secured with HTTPS using an AWS Certificate Manager (ACM) SSL/TLS certificate.

To facilitate user interaction, this project deploys a backend AWS Lambda function (app.py), packaged and stored in a dedicated S3 bucket that is provisioned alongside other resources via Terraform. This Lambda function is exposed through Amazon API Gateway, providing a secure and scalable API endpoint for the contact form.

Submitted messages are:

* Stored in **Amazon DynamoDB** for persistence
* **Emailed** to a specified recipient via **Amazon SNS**

Additionally, Origin Access Control (OAC) is implemented to restrict direct public access to the static website’s S3 bucket, ensuring that all requests are served exclusively through CloudFront. The entire infrastructure is designed with modular Terraform configurations to enable streamlined, repeatable, and maintainable deployments.
---

## 📁 Folder Structure

```plaintext
secure-scalable-s3-static-site-aws-terraform/
├── main.tf                   # Root Terraform config referencing modules
├── variables.tf              # Root variable definitions
├── outputs.tf                # Outputs from the root module
├── terraform.tfvars          # Variable values (DO NOT commit secrets)
├── modules/
│   ├── cloudfront-acm/		 # CloudFront + ACM module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda-api-contact-form/	# Lambda API module for contact form
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── lambda-contact-form-code/
│   │       ├── app.py			 # Lambda handler
│   │       └── app.zip			 # Zipped Lambda package
│   └── sns-email/
│       ├── main.tf              # SNS topic and subscription module
│       ├── variables.tf
│       └── outputs.tf
├── scripts/
│   ├── deploy.ps1				# Script to deploy infrastructure and upload Lambda ZIP 
└── .gitignore					# Excludes .tfvars, .zip, etc.
```

---

## ✅ Features

* **S3-hosted static site** behind **CloudFront** for performance and security
* **ACM certificate** (in `us-east-1`) for HTTPS support
* **Origin Access Control (OAC)** to restrict direct access to S3
* **Lambda + API Gateway** for contact form integration
* **DynamoDB integration** for message persistence
* **Email notifications via SNS** upon contact form submission
* **Modular Terraform** code for clean separation
* **Lambda deployed as ZIP archive** stored in S3
* **One-step PowerShell deployment script**

---

## 🚀 Deployment Steps

> 🔒 AWS credentials must be configured in your shell environment.

### Deploy Infrastructure


```powershell
cd scripts
.\deploy.ps1
```

This will:

* Package app.py in a zip file and name it app.zip
* Upload your latest `app.zip` Lambda package
* Deploy/redeploy all infrastructure modules
* Attach the right IAM roles and policies
* Confirm the SNS subscription (you’ll receive a confirmation email once)
---

## 🧠 Prerequisites

* Terraform installed and configured
* PowerShell (for running deploy scripts on Windows)
* Valid AWS credentials with permissions for S3, Lambda, ACM, CloudFront, API Gateway, DynamoDB, and SNS
* Lambda ZIP (`app.zip`) in `modules/lambda-api-contact-form/lambda-contact-form-code/`

---

## 📝 Configuration Notes

* **S3 bucket** for storing app.py is **created automatically** and made private
* **Lambda ZIP** is uploaded to a secure S3 bucket and referenced in the Lambda function
* **Lambda environment variables** include:

  * `DYNAMODB_TABLE`: your contact message table
  * `SNS_TOPIC_ARN`: the ARN of your SNS topic (email recipient)
  * `SENDER_EMAIL`: domain-based identity (for later SES use)
* **SNS email subscription** is auto-provisioned and must be **manually confirmed**
* **CORS** is configured for API Gateway (can be modified via variables)
* **DNS** (e.g., Route 53) though not included, can be added separately to map a custom domain to the CloudFront URL

---

## ✏️ Variables You Must Provide (`terraform.tfvars`)

```hcl
region = "us-east-1"
domain_name = "yourdomain.com"
hosted_zone_id = "ZXXXXXXXXXXX"     # Optional, if using Route53
certificate_arn = "arn:aws:acm:us-east-1:XXXXXXXXXXXX:certificate/abcd-1234"
lambda_code_bucket = "your-existing-or-created-bucket"
lambda_zip_path = "modules/lambda-api-contact-form/lambda-contact-form-code/app.zip"
notification_email = "you@example.com"  # Email to receive form messages
```

---

## 🛡️ Security Considerations

* S3 bucket is **not public**; access is granted only to CloudFront
* IAM roles follow **least privilege**, with:

  * `dynamodb:PutItem` for message saving
  * `sns:Publish` for sending alerts
* API Gateway is protected with **CORS** origin rules
* Email delivery is done via **SNS** (no SMTP or SES config required)

---

## 🧼 Cleanup

```bash
terraform destroy
```
This removes:

* CloudFront distribution
* API Gateway & Lambda
* IAM roles
* SNS topic + email subscription
* DynamoDB table
* Optional: Lambda code S3 bucket (force\_destroy enabled)

Make sure your Lambda ZIP and website data are backed up externally if needed.

---

## 👤 Author

Mubarak Ahmad Khan

---

## 📜 License

This project is provided as-is with no warranties. Use at your own risk.
