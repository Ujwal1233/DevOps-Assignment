# PowerShell Script to Deploy to GCP Cloud Run
# Run this after setting up GCP account

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectID = "YOUR_PROJECT_ID",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "asia-south1",
    
    [Parameter(Mandatory=$false)]
    [string]$ServiceName = "backend-app",
    
    [Parameter(Mandatory=$false)]
    [string]$ImageName = "backend-app"
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "GCP Cloud Run Deployment" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Check if gcloud is installed
Write-Host "`n[1/6] Checking Google Cloud SDK..." -ForegroundColor Yellow
try {
    $gcloudVersion = gcloud --version 2>&1
    Write-Host "Google Cloud SDK is installed." -ForegroundColor Green
} catch {
    Write-Host "Error: Google Cloud SDK is not installed." -ForegroundColor Red
    Write-Host "Please install from: https://cloud.google.com/sdk/docs/install"
    exit 1
}

# Step 2: Set project
Write-Host "`n[2/6] Setting GCP project..." -ForegroundColor Yellow
gcloud config set project $ProjectID

# Step 3: Enable required APIs
Write-Host "`n[3/6] Enabling Cloud Run API..." -ForegroundColor Yellow
gcloud services enable run.googleapis.com
Write-Host "Cloud Run API enabled!" -ForegroundColor Green

# Step 4: Configure Docker
Write-Host "`n[4/6] Configuring Docker for GCR..." -ForegroundColor Yellow
gcloud auth configure-docker

# Step 5: Build and push Docker image
Write-Host "`n[5/6] Building and pushing Docker image..." -ForegroundColor Yellow
$imageUri = "gcr.io/$ProjectID/$ImageName"

# Build the image
Write-Host "Building Docker image..."
docker build -t $ImageName .

# Tag the image
Write-Host "Tagging Docker image..."
docker tag $ImageName $imageUri

# Push to GCR
Write-Host "Pushing to Google Container Registry..."
gcloud builds submit --tag $imageUri

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to build/push Docker image" -ForegroundColor Red
    exit 1
}

Write-Host "Docker image pushed successfully!" -ForegroundColor Green

# Step 6: Deploy to Cloud Run
Write-Host "`n[6/6] Deploying to Cloud Run..." -ForegroundColor Yellow
$deployOutput = gcloud run deploy $ServiceName `
    --image $imageUri `
    --platform managed `
    --region $Region `
    --allow-unauthenticated 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to deploy to Cloud Run" -ForegroundColor Red
    Write-Host $deployOutput
    exit 1
}

Write-Host "`n=====================================" -ForegroundColor Green
Write-Host "GCP Cloud Run Deployment Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Extract and display the URL
Write-Host "`nYour Cloud Run service is available at:" -ForegroundColor Cyan
Write-Host $deployOutput | Select-String "https://"
