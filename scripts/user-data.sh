#!/bin/bash
# User data script to install and run Node.js application

# Update and install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Create app directory
cd /home/ec2-user
mkdir -p backend
cd backend

# Create package.json
cat > package.json << 'EOF'
{
  "name": "devops-backend",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

# Create server.js
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.json({ message: 'Welcome to DevOps Assignment API', environment: 'dev' });
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'healthy', message: 'Backend is running successfully!' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log('Server running on port ' + PORT);
});
EOF

# Install dependencies
npm install

# Start the server
nohup node server.js > app.log 2>&1 &

echo "Application deployed successfully!"
sleep 2
curl -s http://localhost:3000/api/health
