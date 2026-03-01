# PowerShell Script to Deploy Terraform Environments

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$envPath = "$projectRoot\terraform\environments\$Environment"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Deploying $Environment Environment" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check if environment directory exists
if (-not (Test-Path $envPath)) {
    Write-Host "Error: Environment '$Environment' not found at $envPath" -ForegroundColor Red
    exit 1
}

# Change to environment directory
Set-Location $envPath
Write-Host "Working directory: $envPath" -ForegroundColor Yellow

# Check if Terraform is installed
Write-Host "`nChecking Terraform..." -ForegroundColor Yellow
try {
    $null = terraform -v
    Write-Host "Terraform is installed." -ForegroundColor Green
} catch {
    Write-Host "Error: Terraform is not installed. Please install Terraform first." -ForegroundColor Red
    exit 1
}

# Initialize Terraform
Write-Host "`n[1/3] Initializing Terraform..." -ForegroundColor Yellow
$initOutput = terraform init
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Terraform init failed" -ForegroundColor Red
    Write-Host $initOutput
    exit 1
}
Write-Host "Terraform initialized successfully!" -ForegroundColor Green

# Run Terraform Plan
Write-Host "`n[2/3] Creating Terraform plan..." -ForegroundColor Yellow
$planOutput = terraform plan -out="$Environment.tfplan"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Terraform plan failed" -ForegroundColor Red
    Write-Host $planOutput
    exit 1
}
Write-Host "Terraform plan created successfully!" -ForegroundColor Green

# Show plan summary
Write-Host "`nPlan Summary:" -ForegroundColor Cyan
terraform show "$Environment.tfplan" | Select-Object -First 20

if ($PlanOnly) {
    Write-Host "`nPlan only mode - no changes applied." -ForegroundColor Yellow
    Write-Host "To apply changes, run without -PlanOnly flag." -ForegroundColor Yellow
} else {
    # Confirm before applying
    Write-Host "`n[3/3] Applying Terraform changes..." -ForegroundColor Yellow
    Write-Host "Type 'yes' to confirm or 'no' to cancel: " -NoNewline -ForegroundColor Yellow
    $confirm = Read-Host
    
    if ($confirm -ne "yes") {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    $applyOutput = terraform apply "$Environment.tfplan"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Terraform apply failed" -ForegroundColor Red
        Write-Host $applyOutput
        exit 1
    }
    
    Write-Host "`n=====================================" -ForegroundColor Green
    Write-Host "$Environment environment deployed successfully!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    
    # Show outputs
    Write-Host "`nDeployment Outputs:" -ForegroundColor Cyan
    terraform output
}

# Return to original directory
Set-Location $projectRoot
