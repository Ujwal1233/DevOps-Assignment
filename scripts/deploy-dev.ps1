# Deploy to DEV instance using AWS SSM
$instanceId = "i-086ece3e6120f47b7"

# Command to run - install node, create app, start it
$commands = @"
#!/bin/bash
sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
cd /home/ec2-user
mkdir -p backend
cd backend
npm init -y
npm install express
echo 'const express = require("express");
const app = express();
const PORT = 3000;
app.get("/", (req, res) => res.json({message: "DevOps API"}));
app.get("/api/health", (req, res) => res.json({status: "healthy", message: "Backend running!"}));
app.listen(PORT, "0.0.0.0", () => console.log("Server running on port " + PORT));' > server.js
nohup node server.js > app.log 2>&1 &
sleep 3
curl -s http://localhost:3000/api/health
"@

# Send command to instance
$result = aws ssm send-command `
    --instance-ids $instanceId `
    --document-name "AWS-RunShellScript" `
    --comment "Deploy Node.js app to DEV" `
    --parameters @{"commands"=$commands} `
    --region "ap-south-1" `
    --output json

Write-Host "Command sent! Checking status..."
Write-Host $result

# Get command ID
$commandId = ($result | ConvertFrom-Json).Command.CommandId
Write-Host "Command ID: $commandId"

# Wait and check result
Start-Sleep -Seconds 10

# Get command invocation
$invocation = aws ssm get-command-invocation `
    --CommandId $commandId `
    --InstanceId $instanceId `
    --region "ap-south-1" `
    --output json

Write-Host "Invocation result:"
$invocation | ConvertFrom-Json | Select-Object -ExpandProperty StandardOutputContent
