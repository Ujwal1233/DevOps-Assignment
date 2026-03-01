# Demo Video Script (8-12 minutes)

## 🎬 Introduction (1 minute)
- Welcome and introduction
- Brief overview of what will be demonstrated
- Mention the two main cloud providers used: AWS and GCP

---

## 🎯 Section 1: Architecture Overview (1 minute)

### 1.1 Explain the Architecture
- Show the architecture diagram
- Explain AWS EC2 setup (dev, staging, prod)
- Explain GCP Cloud Run setup
- Mention Terraform state management

---

## 🎯 Section 2: AWS Console Show (3 minutes)

### 2.1 Show Terraform State Storage (1 minute)
- Navigate to S3 console
- Show the bucket created for Terraform state
- Explain versioning is enabled
- Navigate to DynamoDB and show the lock table

### 2.2 Show Deployed EC2 Instances (1 minute)
- Navigate to EC2 console
- Show the three instances: dev, staging, prod
- Point out the different instance types (t2.micro, t2.small, t3.medium)
- Show the VPC and networking configuration

### 2.3 Show Security Groups (30 seconds)
- Display the security groups created
- Explain the inbound rules (HTTP, HTTPS, SSH)

### 2.4 Show Terraform in Action (30 seconds)
- Show the GitHub repository with Terraform code
- Explain the folder structure (dev, staging, prod)

---

## 🎯 Section 3: GCP Cloud Run (2 minutes)

### 3.1 Show GCP Console (1 minute)
- Navigate to Cloud Run console
- Show the deployed service
- Display the HTTPS URL provided

### 3.2 Show Container Registry (1 minute)
- Navigate to Container Registry
- Show the Docker image pushed

---

## 🎯 Section 4: GitHub Repository (2 minutes)

### 4.1 Repository Structure (1 minute)
- Show the folder structure
- Highlight terraform/environments/
- Show scripts/ folder
- Show docs/ folder

### 4.2 Key Files (1 minute)
- Show main.tf for any environment
- Show variables.tf
- Show backend.tf explaining state storage

---

## 🎯 Section 5: State Management Explanation (2 minutes) - CRITICAL

### 5.1 Why S3? (30 seconds)
- "We use S3 for remote state storage"
- "This allows team members to access the same state"
- "S3 provides 99.999999999% durability"

### 5.2 Why Versioning? (30 seconds)
- "Versioning protects us from accidental corruption"
- "We can recover previous versions if something goes wrong"
- "It's like having a time machine for infrastructure"

### 5.3 Why DynamoDB Lock? (30 seconds)
- "The lock table prevents two people from running terraform apply at the same time"
- "This prevents state corruption from concurrent modifications"
- "Essential for team collaboration"

### 5.4 State Isolation (30 seconds)
- "Each environment (dev, staging, prod) has its own state file"
- "This prevents accidental modifications across environments"

---

## 🎯 Section 6: Failure Thinking (2 minutes) - HIGHLY EVALUATED

### 6.1 Smallest Failure Unit (1 minute)
- "For AWS, the smallest failure unit is the EC2 instance"
- "If it crashes, we must manually recreate it"
- "For GCP, the smallest unit is the container instance"
- "But Cloud Run automatically restarts failed containers"

### 6.2 What Breaks First? (30 seconds)
- "AWS: EC2 crash, security group misconfiguration"
- "GCP: Container crash, wrong image deployed"

### 6.3 What Self-Recovers? (30 seconds)
- "AWS: Nothing (without Auto Scaling Group)"
- "GCP: Cloud Run automatically restarts containers"

---

## 🎯 Section 7: Future Growth Strategy (1 minute) - BIG IMPACT

### 7.1 If Traffic Increases 10x (20 seconds)
- "AWS: Add Auto Scaling Group + Load Balancer"
- "GCP: Cloud Run auto-scales, just increase max instances"

### 7.2 New Backend Service (20 seconds)
- "Create separate Terraform module"
- "Deploy additional EC2 or Cloud Run service"

### 7.3 Client Isolation (20 seconds)
- "Separate VPC per client"
- "Or separate project per client"

---

## 🎯 Section 8: What We Did NOT Do (1 minute) - SHOWS MATURITY

- "We did NOT implement CI/CD pipeline"
- "We did NOT implement monitoring alerts"
- "We did NOT implement load balancers"
- "We did NOT use Kubernetes"
- "Why? Because this is a beginner-level assignment"
- "These are all areas for future improvement"

---

## 📝 Talking Points

1. **Cloud & Region Choice**: "We chose ap-south-1 (Mumbai) for both AWS and GCP because it provides lower latency for India-based users and is cost-effective for learning."

2. **Compute Decision**: "For AWS, we used EC2 to get full control and learn the fundamentals. For GCP, we used Cloud Run because it's serverless and auto-scales."

3. **Scaling**: "In AWS, we manually change instance types for different environments. In GCP, Cloud Run automatically scales."

4. **Failure Thinking**: "If an EC2 crashes, we need to recreate it. But Cloud Run automatically restarts containers."

5. **State Management**: "We use S3 with versioning for state storage, and DynamoDB for locking. This is critical for team collaboration."

6. **What We Did NOT Do**: "We intentionally did NOT implement CI/CD, monitoring alerts, load balancers, or Kubernetes - because this is a beginner-level assignment. But these are areas for future growth."

---

## ✅ Checklist Before Recording

- [ ] AWS Console is logged in
- [ ] GCP Console is logged in
- [ ] GitHub repository is accessible
- [ ] All three EC2 instances are running
- [ ] Cloud Run service is deployed
- [ ] Health check endpoint is working
- [ ] Screen recording software is ready
- [ ] Microphone is working
- [ ] Demo script is printed or on second screen

---

## 🎤 Key Phrases to Use

- "This is a critical section worth 15% of the evaluation"
- "State management is mandatory for production systems"
- "The smallest failure unit determines our recovery strategy"
- "Senior thinking means planning for future growth"
- "Maturity is acknowledging what we did NOT do"

---

## 🚨 What NOT to Do in Demo

- ❌ Don't rush through state management
- ❌ Don't skip failure thinking section
- ❌ Don't forget to mention what you didn't implement
- ❌ Don't overcomplicate - keep it beginner-friendly but thoughtful
- ❌ Don't panic if you don't have actual URLs - explain the setup
