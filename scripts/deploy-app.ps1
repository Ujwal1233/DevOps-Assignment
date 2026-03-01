# Deploy Application to EC2 Instance

param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$HostIP,
    
    [string]$KeyPath = "$env:USERPROFILE\.ssh\id_rsa"
)

$ErrorActionPreference = "Stop"

Write-Host "Deploying to $Environment environment at $HostIP" -ForegroundColor Cyan

# Check if key file exists
if (-not (Test-Path $KeyPath)) {
    Write-Host "SSH key not found at $KeyPath" -ForegroundColor Yellow
    Write-Host "Please provide the path to your SSH key file" -ForegroundColor Yellow
    exit 1
}

# Commands to run on remote server
$remoteCommands = @"
sudo yum update -y
sudo yum install -y nodejs npm git
cd /home/ec2-user
mkdir -p backend
cd backend
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git . 2>/dev/null || echo "Manual upload needed"
npm install
PORT=3000 NODE_ENV=$Environment node server.js > /tmp/app.log 2>&1 &
echo "Application deployed!"
sleep 2
curl -s http://localhost:3000/api/health || echo "App may not be running yet"
"@

Write-Host "Note: Please manually deploy the application using these steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Copy backend files to EC2:" -ForegroundColor Green
Write-Host "   scp -i $KeyPath -r backend/* ec2-user@$HostIP:~/" 
Write-Host ""
Write-Host "2. SSH into the server:" -ForegroundColor Green
Write-Host "   ssh -i $KeyPath ec2-user@$HostIP"
Write-Host ""
Write-Host "3. Install dependencies and start:" -ForegroundColor Green
Write-Host "   cd ~/backend"
Write-Host "   npm install"
Write-Host "   PORT=3000 NODE_ENV=$Environment node server.js &"
Write-Host ""
Write-Host "4. Test the application:" -ForegroundColor Green
Write-Host "   curl http://$HostIP:3000/api/health"
Write-Host ""
