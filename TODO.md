# DevOps Assignment - Cloud Infrastructure Setup

## STEP 1: AWS Setup (Terraform) - ✅ COMPLETED
- [x] 1.1 Install Terraform and AWS CLI
- [x] 1.2 Create IAM User with AdministratorAccess
- [x] 1.3 Configure AWS CLI with credentials
- [x] 1.4 Create S3 bucket for Terraform state storage
- [x] 1.5 Enable versioning on S3 bucket
- [x] 1.6 Create DynamoDB lock table
- [x] 1.7 Setup Terraform folder structure
- [x] 1.8 Deploy DEV environment

## STEP 2: Create Staging & Prod - ✅ COMPLETED
- [x] 2.1 Copy dev to staging and update instance type
- [x] 2.2 Copy dev to prod and update instance type
- [x] 2.3 Deploy staging environment
- [x] 2.4 Deploy prod environment

## STEP 3: GCP Setup (Cloud Run) - IN PROGRESS
- [ ] 3.1 Create GCP account and project
- [ ] 3.2 Enable Cloud Run API
- [ ] 3.3 Build and push Docker image to GCR
- [ ] 3.4 Deploy to Cloud Run

## STEP 4: Documentation - IN PROGRESS
- [x] 4.1 Document Cloud & Region Choice
- [x] 4.2 Document Compute Decision
- [x] 4.3 Document Scaling strategy
- [x] 4.4 Document Failure Thinking
- [x] 4.5 Document What We Did NOT Do

## STEP 5: Demo Video
- [ ] 5.1 Prepare demo script

## Current Infrastructure Status
- DEV: EC2 t2.micro at 3.108.194.64:3000
- STAGING: EC2 t2.small at 13.127.193.211
- PROD: EC2 t3.medium
