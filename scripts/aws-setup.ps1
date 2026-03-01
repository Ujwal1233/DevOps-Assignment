# PowerShell Script to Setup AWS Infrastructure
# Run this after configuring AWS CLI

param(
    [Parameter(Mandatory=$false)]
    [string]$BucketName = "devops-terraform-state-YOURUNIQUEID",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "ap-south-1"
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "AWS Infrastructure Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Check if AWS CLI is configured
Write-Host "`n[1/4] Checking AWS CLI configuration..." -ForegroundColor Yellow
try {
    $identity = aws sts get-caller-identity 2>&1 | ConvertFrom-Json
    Write-Host "AWS CLI is configured. User: $($identity.Arn)" -ForegroundColor Green
} catch {
    Write-Host "AWS CLI is not configured. Please run 'aws configure' first." -ForegroundColor Red
    Write-Host "Run: aws configure"
    exit 1
}

# Step 2: Create S3 bucket for Terraform state
Write-Host "`n[2/4] Creating S3 bucket for Terraform state..." -ForegroundColor Yellow
$bucketCheck = aws s3api head-bucket --bucket $BucketName --region $Region 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "S3 bucket '$BucketName' already exists." -ForegroundColor Yellow
} else {
    Write-Host "Creating S3 bucket: $BucketName"
    $createOutput = aws s3api create-bucket `
        --bucket $BucketName `
        --region $Region `
        --create-bucket-configuration LocationConstraint=$Region 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "S3 bucket created successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to create S3 bucket: $createOutput" -ForegroundColor Red
    }
}

# Step 3: Enable versioning on S3 bucket
Write-Host "`n[3/4] Enabling versioning on S3 bucket..." -ForegroundColor Yellow
$versioningOutput = aws s3api put-bucket-versioning `
    --bucket $BucketName `
    --versioning-configuration Status=Enabled `
    --region $Region 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "Versioning enabled successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to enable versioning: $versioningOutput" -ForegroundColor Red
}

# Step 4: Create DynamoDB table for state locking
Write-Host "`n[4/4] Creating DynamoDB table for state locking..." -ForegroundColor Yellow
$tableCheck = aws dynamodb describe-table `
    --table-name terraform-lock-table `
    --region $Region 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "DynamoDB table 'terraform-lock-table' already exists." -ForegroundColor Yellow
} else {
    Write-Host "Creating DynamoDB table: terraform-lock-table"
    $createTableOutput = aws dynamodb create-table `
        --table-name terraform-lock-table `
        --attribute-definitions AttributeName=LockID,AttributeType=S `
        --key-schema AttributeName=LockID,KeyType=HASH `
        --billing-mode PAY_PER_REQUEST `
        --region $Region 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "DynamoDB table created successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to create DynamoDB table: $createTableOutput" -ForegroundColor Red
    }
}

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "AWS Infrastructure Setup Complete!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Update backend.tf files with your bucket name: $BucketName"
Write-Host "2. Run: cd terraform/environments/dev"
Write-Host "3. Run: terraform init"
Write-Host "4. Run: terraform plan"
Write-Host "5. Run: terraform apply"
