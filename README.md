# DevOps Assignment - Cloud Infrastructure Setup

This repository contains all the necessary files to complete the DevOps assignment using AWS and GCP.

## 📐 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS (ap-south-1)                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │     DEV     │  │   STAGING   │  │    PROD     │        │
│  │  t2.micro   │  │  t2.small   │  │ t3.medium   │        │
│  │             │  │             │  │             │        │
│  │  EC2 + VPC  │  │  EC2 + VPC  │  │  EC2 + VPC  │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │         Terraform State Storage              │           │
│  │  ┌─────────┐        ┌────────────────┐     │           │
│  │  │   S3    │        │   DynamoDB     │     │           │
│  │  │ Bucket  │        │ Lock Table      │     │           │
│  │  └─────────┘        └────────────────┘     │           │
│  └─────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                      GCP (asia-south1)                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │            Cloud Run Service                 │           │
│  │         (Auto-scaling Container)            │           │
│  └─────────────────────────────────────────────┘           │
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │         Container Registry (GCR)            │           │
│  └─────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## ☁️ Hosted URLs

| Environment | Service | URL | Status |
|-------------|---------|-----|--------|
| Dev | AWS EC2 | http://3.108.194.64:3000 | ✅ Running |
| Staging | AWS EC2 | http://13.127.193.211:3000 | ✅ Running |
| Prod | AWS EC2 | http://15.206.80.55:3000 | ✅ Running |
| Render.com | Docker | Sign up at render.com | ✅ Ready to deploy |

**Health Check Endpoint:**
```
GET http://<public-ip>:3000/api/health
Response: {"status":"healthy","message":"Backend is running successfully"}
```

## 📁 Project Structure

```
Devops/
├── terraform/
│   ├── provider.tf                    # Terraform provider configuration
│   └── environments/
│       ├── dev/                       # Development environment
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── terraform.tfvars
│       │   ├── backend.tf
│       │   └── outputs.tf
│       ├── staging/                   # Staging environment
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── terraform.tfvars
│       │   ├── backend.tf
│       │   └── outputs.tf
│       └── prod/                      # Production environment
│           ├── main.tf
│           ├── variables.tf
│           ├── terraform.tfvars
│           ├── backend.tf
│           └── outputs.tf
├── scripts/
│   ├── check-tools.ps1               # Check/install required tools
│   ├── aws-setup.ps1                 # AWS infrastructure setup
│   ├── deploy-tf.ps1                 # Deploy Terraform environments
│   └── gcp-deploy.ps1                # GCP Cloud Run deployment
├── docs/
│   ├── DOCUMENTATION.md              # Cloud infrastructure documentation
│   └── DEMO-SCRIPT.md               # Demo video script
├── TODO.md                           # Task tracking
└── README.md                         # This file
```

## 🚀 How to Deploy

### Prerequisites

1. **Install Required Tools:**
   
```
powershell
   .\scripts\check-tools.ps1
   
```

   Or manually install:
   - [Terraform](https://www.terraform.io/downloads)
   - [AWS CLI](https://aws.amazon.com/cli/)
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### AWS Deployment Steps

1. **Configure AWS:**
   
```
bash
   aws configure
   
```
   - Enter Access Key
   - Enter Secret Key
   - Region: ap-south-1
   - Output format: Press Enter

2. **Setup AWS Infrastructure:**
   
```
powershell
   .\scripts\aws-setup.ps1 -BucketName "your-unique-bucket-name"
   
```

3. **Update backend.tf:**
   - Replace `YOUR_UNIQUE_BUCKET_NAME` in all `backend.tf` files with your actual S3 bucket name

4. **Deploy Environments:**
   
```
powershell
   # Deploy DEV
   .\scripts\deploy-tf.ps1 -Environment dev

   # Deploy Staging
   .\scripts\deploy-tf.ps1 -Environment staging

   # Deploy Prod
   .\scripts\deploy-tf.ps1 -Environment prod
   
```

### GCP Deployment Steps

1. **Configure GCP:**
   
```
bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   
```

2. **Deploy to Cloud Run:**
   
```
powershell
   .\scripts\gcp-deploy.ps1 -ProjectID "your-gcp-project-id"
   
```

## 📋 Instance Types by Environment

| Environment | Instance Type | vCPU | RAM |
|-------------|---------------|------|-----|
| Dev | t2.micro | 1 | 1 GB |
| Staging | t2.small | 1 | 2 GB |
| Prod | t3.medium | 2 | 4 GB |

## 🔧 Important Notes

1. **State Management**: Terraform state is stored in S3 with DynamoDB locking
2. **Backend Configuration**: Update `backend.tf` files with your actual S3 bucket name
3. **AWS Region**: ap-south-1 (Mumbai)
4. **GCP Region**: asia-south1 (Mumbai)
5. **Health Check**: Backend should respond at `/api/health` endpoint

## 📄 Documentation Links

- **Cloud Infrastructure Documentation**: [docs/DOCUMENTATION.md](docs/DOCUMENTATION.md)
- **Demo Video Script**: [docs/DEMO-SCRIPT.md](docs/DEMO-SCRIPT.md)

## 🎬 Demo Video

See `docs/DEMO-SCRIPT.md` for a structured demo video script (8-12 minutes).

**Demo Video Structure:**
1. Intro (1 min)
2. Architecture explanation (2 min)
3. AWS deployment walkthrough (3 min)
4. GCP deployment walkthrough (2 min)
5. Terraform state explanation (1 min)
6. Failure thinking (1 min)
7. Future growth (1 min)
8. What not implemented (1 min)

## 🔐 Security Considerations

- IAM User has AdministratorAccess (for learning purposes)
- Security groups allow HTTP (80), HTTPS (443), and SSH (22)
- In production, restrict SSH access and use least-privilege IAM

## 🧹 Cleanup

To destroy resources (use with caution!):

```
powershell
# Navigate to environment directory
cd terraform\environments\dev
terraform destroy
```

## 📝 Key Features Implemented

✅ AWS EC2 instances (dev, staging, prod)
✅ VPC networking with public subnets
✅ Security groups with proper rules
✅ Terraform remote state storage (S3)
✅ State versioning for corruption protection
✅ DynamoDB lock table for concurrent operations
✅ Environment isolation (separate state per env)
✅ GCP Cloud Run deployment
✅ Docker container deployment
✅ Comprehensive documentation

---

**Created for DevOps Assignment**

*This project demonstrates cloud infrastructure setup using Terraform, AWS EC2, and GCP Cloud Run with proper state management and documentation.*
