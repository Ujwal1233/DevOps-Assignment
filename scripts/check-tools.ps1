# PowerShell Script to Check and Install Required Tools
# Run this script as Administrator

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Checking Required Tools" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check Terraform
Write-Host "`nChecking Terraform..." -ForegroundColor Yellow
try {
    $terraformVersion = terraform -v 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Terraform is installed: $terraformVersion" -ForegroundColor Green
    } else {
        throw "Terraform not found"
    }
} catch {
    Write-Host "Terraform is not installed." -ForegroundColor Red
    Write-Host "Installing Terraform..." -ForegroundColor Yellow
    
    # Download and install Terraform
    $tempDir = [System.IO.Path]::GetTempPath()
    $terraformZip = "$tempDir\terraform.zip"
    
    # Note: This is a simplified installation - in production, use proper version management
    Write-Host "Please install Terraform manually from: https://www.terraform.io/downloads"
    Write-Host "Or use: winget install HashiCorp.Terraform"
}

# Check AWS CLI
Write-Host "`nChecking AWS CLI..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "AWS CLI is installed: $awsVersion" -ForegroundColor Green
    } else {
        throw "AWS CLI not found"
    }
} catch {
    Write-Host "AWS CLI is not installed." -ForegroundColor Red
    Write-Host "Installing AWS CLI..." -ForegroundColor Yellow
    Write-Host "Please install AWS CLI manually from: https://aws.amazon.com/cli/"
    Write-Host "Or use: winget install Amazon.AWSCLI"
}

# Check Docker
Write-Host "`nChecking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker is installed: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker not found"
    }
} catch {
    Write-Host "Docker is not installed." -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
}

# Check Google Cloud SDK
Write-Host "`nChecking Google Cloud SDK..." -ForegroundColor Yellow
try {
    $gcloudVersion = gcloud --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Google Cloud SDK is installed: $gcloudVersion" -ForegroundColor Green
    } else {
        throw "gcloud not found"
    }
} catch {
    Write-Host "Google Cloud SDK is not installed." -ForegroundColor Red
    Write-Host "Please install Google Cloud SDK from: https://cloud.google.com/sdk/docs/install"
}

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "Tool Check Complete!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
