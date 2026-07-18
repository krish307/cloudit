# Terraform

This directory contains the Terraform configuration used to provision the AWS infrastructure for the CloudIt project.

The infrastructure is fully managed as Infrastructure as Code (IaC), allowing repeatable and automated deployments.

---

# Resources Provisioned

- AWS EC2 Instance
- Security Group
- Latest Ubuntu 22.04 LTS AMI (dynamic lookup)
- User Data bootstrap script

---

# Files

| File | Purpose |
|------|---------|
| provider.tf | AWS provider configuration |
| variables.tf | Input variables |
| main.tf | Infrastructure resources |
| outputs.tf | Terraform outputs |
| userdata.sh | EC2 bootstrap script |
| terraform.tfvars | Variable values (not committed) |

---

# Commands

Initialize Terraform

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Preview changes

```bash
terraform plan
```

Deploy infrastructure

```bash
terraform apply
```

Destroy infrastructure

```bash
terraform destroy
```

---

# Features

- Infrastructure as Code
- Dynamic AMI lookup
- Automated EC2 provisioning
- Security Group configuration
- User Data automation
- Docker installation during boot
- Reproducible deployments

---

# Notes

- `terraform.tfvars` should not be committed to Git.
- Terraform state should not be committed to Git.
- AWS credentials are managed locally using the AWS CLI.

---

Part of the **CloudIt** project.

Repository:
https://github.com/krish307/cloudit