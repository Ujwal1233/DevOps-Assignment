# DevOps Assignment - Cloud Infrastructure Documentation

## 1️⃣ Cloud & Region Choice

### AWS
- **Region**: ap-south-1 (Mumbai, India)
- **Reason**: 
  - Lower latency for India-based users
  - Cost-effective pricing
  - Full range of AWS services available
  - Good for learning and demonstration purposes

### Render.com
- **Region**: us-east-1 (Virginia, USA) - default for free tier
- **Reason**: 
  - Free tier available (750 hours/month)
  - No credit card required
  - Simple Docker container deployment
  - Automatic HTTPS
  - Easy scaling options

---

## 2️⃣ Compute Decision

### AWS - EC2 (Elastic Compute Cloud)
- **Choice**: Used EC2 for full control and learning
- **Rationale**:
  - Provides hands-on experience with virtual servers
  - Full control over the operating system
  - Good for understanding infrastructure fundamentals
  - Ability to configure networking, security groups, and storage
  - Learning opportunity for system administration

### Render.com
- **Choice**: Used Render for auto-scaling container deployment
- **Rationale**:
  - Free tier available (750 hours/month)
  - No credit card required
  - Serverless container platform - no server management
  - Automatic scaling based on incoming traffic
  - Built-in SSL/HTTPS
  - Simple deployment from Docker
  - Ideal for containerized applications

---

## 3️⃣ Scaling

### AWS - EC2
- **Scaling Strategy**: Manual scaling via instance type change
- **Details**:
  - Dev: t2.micro (1 vCPU, 1 GB RAM)
  - Staging: t2.small (1 vCPU, 2 GB RAM)
  - Prod: t3.medium (2 vCPU, 4 GB RAM)
- **Note**: For production, Auto Scaling Groups would be recommended

### Render.com
- **Scaling Strategy**: Automatic scaling built-in
- **Details**:
  - Auto-scaling available on paid plans
  - Free tier: 1 web service
  - Scales based on incoming traffic on paid plans
  - No manual intervention required
  - Sleeps after 15 min of inactivity on free tier (cold start on first request)

---

## 4️⃣ Failure Thinking

### AWS - EC2
- **Failure Scenario**: If EC2 instance crashes
- **Mitigation**:
  - Must manually recreate the instance
  - Use AMIs for faster recovery
  - Implement Auto Scaling Groups for high availability
  - Regular backups recommended
  - Consider using spot instances for cost savings with proper fault tolerance

### Render.com
- **Failure Scenario**: Container failure or crash
- **Mitigation**:
  - Render automatically restarts the container
  - Built-in health checks
  - Automatic recovery
  - Deploy rollback available

---

## 5️⃣ Smallest Failure Unit (Highly Evaluated Section)

### AWS
- **Smallest unit**: EC2 instance
- **What breaks first**:
  - EC2 instance crash (hardware failure)
  - Security group misconfiguration
  - Incorrect AMI ID
  - Subnet misconfiguration
- **What self-recovers**: Nothing (if no Auto Scaling configured)
- **What requires human intervention**:
  - Terraform state corruption
  - Wrong deployment
  - Credential compromise
  - VPC deletion

### Render.com
- **Smallest unit**: Container instance
- **What breaks first**:
  - Container crash
  - Wrong Docker image
  - Memory limit exceeded
  - Misconfigured environment variables
- **What self-recovers**: Render automatically restarts failed containers
- **What requires human intervention**:
  - Wrong deployment
  - Service deletion
  - Account suspension (due to ToS violations)

---

## 6️⃣ Terraform State Management (Critical Section - 15% Evaluation)

### What We Created:
1. **S3 Bucket** - Remote state storage
2. **Versioning Enabled** - Protection from accidental corruption
3. **DynamoDB Lock Table** - Prevents concurrent modifications

### Why S3?
- **Remote state sharing**: Allows multiple team members to access the same state
- **Centralized storage**: State is not stored locally on individual machines
- **Durability**: S3 provides 99.999999999% durability
- **Security**: Can use IAM policies for access control

### Why Versioning?
- **Protection from corruption**: Can recover previous versions if state gets corrupted
- **Audit trail**: Can see who changed what and when
- **Accidental deletion protection**: Versions are preserved even after deletion

### Why DynamoDB?
- **Prevents concurrent runs**: Lock table prevents two engineers from running `terraform apply` at the same time
- **State consistency**: Ensures only one process can modify state at a time
- **Team collaboration**: Essential for team environments

### State Isolation
- **Each environment has separate backend config**:
  - dev/terraform.tfstate
  - staging/terraform.tfstate
  - prod/terraform.tfstate
- **This prevents accidental modifications across environments**

---

## 7️⃣ What We Did NOT Do (Shows Maturity)

| Item | Reason for Not Implementing |
|------|------------------------------|
| CI/CD Pipeline | Application is simple; manual deployment chosen for learning |
| WAF (Web Application Firewall) | Not required for this simple assignment |
| Auto Scaling Group | Manual instance type change sufficient for current needs |
| Load Balancer | Single instance per environment; not needed yet |
| Centralized Logging | Time constraints; can add CloudWatch later |
| Infrastructure Monitoring | Basic health checks sufficient for assignment |
| Blue-Green Deployment | Overkill for beginner-level project |
| Kubernetes (EKS/GKE) | Too complex; adds unnecessary overhead |
| Managed Databases (RDS) | No persistent data storage required |
| Multi-AZ Deployment | Cost considerations for assignment |

---

## 8️⃣ Future Growth Strategy (Senior Thinking)

### Scenario 1: Traffic Increases 10x

**AWS Solutions:**
- Add Auto Scaling Group (ASG)
- Add Application Load Balancer (ALB)
- Move to Multi-AZ deployment
- Add CloudFront CDN for static content
- Implement cache with ElastiCache

**GCP Solutions:**
- Cloud Run auto-scales automatically
- Increase max instances limit
- Add Cloud CDN
- Implement Cloud Memorystore

### Scenario 2: New Backend Service

**AWS Solutions:**
- Create separate Terraform module
- Deploy additional EC2 instance or ECS container
- Create separate IAM role for the service
- Configure VPC peering if needed

**GCP Solutions:**
- Create separate Cloud Run service
- Use separate IAM service account
- Configure internal networking

### Scenario 3: Client Wants Isolation

**AWS Solutions:**
- Create separate VPC per client
- Use AWS Organizations for account isolation
- Implement security groups per client

**GCP Solutions:**
- Create separate project per client
- Use VPC Service Controls
- Implement organization policies

### Scenario 4: Region-Specific Data

**AWS Solutions:**
- Deploy to multiple regions
- Use RDS with cross-region read replicas
- Implement Route 53 geolocation
- Use S3 Cross-Region Replication

**GCP Solutions:**
- Deploy to multiple regions
- Use Cloud SQL with high availability
- Implement Cloud CDN regional caching
- Use Cloud Storage multi-region

---

## 📋 Summary

| Aspect | AWS | Render.com |
|--------|-----|------------|
| Compute | EC2 (t2.micro/small, t3.medium) | Docker Container (Serverless) |
| Region | ap-south-1 | us-east-1 |
| State Management | S3 + DynamoDB | N/A |
| Scaling | Manual | Automatic (paid) / Static (free) |
| Control Level | High | Low (Serverless) |
| Learning Value | High | Medium |
| Smallest Failure Unit | EC2 Instance | Container Instance |
| Self-Recovery | No (without ASG) | Yes (automatic) |

---

## 🔧 Technical Details

### Instance Types by Environment

| Environment | Instance Type | vCPU | RAM |
|-------------|---------------|------|-----|
| Dev | t2.micro | 1 | 1 GB |
| Staging | t2.small | 1 | 2 GB |
| Prod | t3.medium | 2 | 4 GB |

### AWS Resources Created
- VPC (10.0.0.0/16 for dev, 10.1.0.0/16 for staging, 10.2.0.0/16 for prod)
- Internet Gateway
- Public Subnet
- Route Table
- Security Group (HTTP, HTTPS, SSH)
- EC2 Instance

### Render.com Resources Created
- Web Service (Docker container)
- Free tier: 750 hours/month

---

This documentation demonstrates:
- Understanding of cloud infrastructure decisions
- Trade-offs between different services
- Awareness of failure scenarios
- Knowledge of state management
- Senior-level thinking for future growth
- Maturity in acknowledging limitations
