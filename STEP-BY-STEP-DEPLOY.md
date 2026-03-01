# Step-by-Step Deployment Guide

## Your EC2 Instances (Already Running)
| Environment | IP Address | Instance Type |
|-------------|-------------|---------------|
| Dev | 3.108.194.64 | t2.micro |
| Staging | 13.127.193.211 | t2.small |
| Prod | 15.206.80.55 | t3.medium |

---

## Step 1: Connect to AWS Console

1. Open your browser and go to: https://console.aws.amazon.com/
2. Log in with your AWS account
3. Make sure you're in the **ap-south-1 (Mumbai)** region (check top-right corner)

---

## Step 2: Find Your EC2 Instance

1. In the AWS search bar, type **EC2** and click on it
2. On the left menu, click **Instances**
3. You should see 3 instances listed:
   - dev-web-server
   - staging-web-server  
   - prod-web-server

---

## Step 3: Connect Using Session Manager

1. **Check the box** next to "dev-web-server" (Instance ID: i-086ece3e6120f47b7)
2. Click the **Connect** button (top right)
3. A new window will open
4. Select the **Session Manager** tab
5. Click **Connect** again

---

## Step 4: Install and Run the Application

Once the Session Manager terminal opens, type these commands one by one:

### Command 1: Update the server
```
bash
sudo yum update -y
```
Press Enter and wait for it to finish (may take 1-2 minutes)

### Command 2: Install Node.js
```
bash
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash - && sudo yum install -y nodejs
```
Press Enter and wait (may take 2-3 minutes)

### Command 3: Create app directory
```
bash
cd /home/ec2-user && mkdir -p backend && cd backend
```

### Command 4: Create the server file
```
bash
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
```

### Command 5: Create package.json
```
bash
cat > package.json << 'EOF'
{
  "name": "devops-backend",
  "version": "1.0.0",
  "dependencies": { "express": "^4.18.2" }
}
EOF
```

### Command 6: Install dependencies
```
bash
npm install
```
Wait for it to finish (may take 1-2 minutes)

### Command 7: Start the server
```
bash
nohup node server.js > app.log 2>&1 &
```

### Command 8: Test the application
```
bash
curl http://localhost:3000/api/health
```

You should see: `{"status":"healthy","message":"Backend is running successfully!"}`

---

## Step 5: Test from Your Browser

Now open your browser and visit:
```
http://3.108.194.64:3000/api/health
```

You should see the JSON response!

---

## Step 6: Repeat for Staging and Prod

Follow the same steps for:
- **Staging**: Connect to instance 13.127.193.211, change 'dev' to 'staging' in the code
- **Prod**: Connect to instance 15.206.80.55, change 'dev' to 'prod' in the code

---

## Troubleshooting

**If curl fails:**
- Wait 10 seconds and try again
- Check if the server started: `curl http://localhost:3000/`

**To check if server is running:**
```
bash
ps aux | grep node
```

**To view server logs:**
```
bash
cat /home/ec2-user/backend/app.log
```

**To restart if needed:**
```
bash
cd /home/ec2-user/backend
pkill node
nohup node server.js > app.log 2>&1 &
```

---

## Success! 🎉

After completing all steps, your URLs will work:
- Dev: http://3.108.194.64:3000
- Staging: http://13.127.193.211:3000
- Prod: http://15.206.80.55:3000
