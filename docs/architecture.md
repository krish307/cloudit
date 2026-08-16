# CloudIt Architecture

CloudIt is implemented across two environments:

## AWS Production

GitHub
→ GitHub Actions
→ Amazon ECR
→ EC2
→ Docker Compose
→ Nginx
→ FastAPI
→ PostgreSQL

AWS infrastructure is provisioned through Terraform using:

- Custom VPC
- Public subnet
- Internet Gateway
- Route table
- Security Group
- EC2
- Amazon ECR
- IAM
- S3 remote state
- DynamoDB state locking

## Kubernetes Environment

CloudIt also runs in a local Kubernetes environment using Minikube.

The Kubernetes architecture includes:

- Nginx frontend Deployment
- FastAPI Deployment
- PostgreSQL StatefulSet
- Persistent storage
- ConfigMaps
- Secrets
- Startup, readiness, and liveness probes
- Horizontal Pod Autoscaler
- Pod Disruption Budget
- Prometheus
- Blackbox Exporter
- Grafana

The Kubernetes environment is used for orchestration, persistence, scaling, self-healing, and observability validation.

See the root `README.md` for the complete architecture and deployment documentation.
