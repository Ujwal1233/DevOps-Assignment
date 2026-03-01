# Manual Deployment Instructions

Since your SSH key is not available on this computer, you'll need to deploy manually.

## Option 1: Deploy using AWS Systems Manager (Session Manager)

1. Go to AWS Console → EC2 → Instances
2. Select your DEV instance (i-086ece3e6120f47b7)
3. Click "Connect" → "Session Manager" → "Connect"
4. In the terminal that opens, run:

```
bash
# Install Node.js
sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Create app directory
cd /home/ec2-user
mkdir -p backend
cd backend

# Create the application
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to DevOps API', environment: 'dev' });
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'healthy', message: 'Backend is running!' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

# Create package.json
cat > package.json << 'EOF'
{
  "name": "devops-backend",
  "version": "1.0.0",
  "dependencies": { "express": "^4.18.2" }
}
EOF

# Install and start
npm install
nohup node server.js > app.log 2>&1 &
echo "Started!"

# Test
curl http://localhost:3000/api/health
```

5. The app will be available at: http://3.108.194.64:3000

## Option 2: Use GitHub + User Data (Recommended for future)

1. Upload your code to GitHub
2. Update Terraform user_data to pull from GitHub on startup
3. Recreate instances with: terraform destroy && terraform apply

## Test Your Deployment

After deploying, visit:
- http://3.108.194.64:3000/
- http://3.108.194.64:3000/api/health
