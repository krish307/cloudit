# CloudIt Terraform Deployment

CloudIt uses Terraform to provision the AWS infrastructure required by the production environment.

The Terraform configuration manages networking, compute, container registry integration, CI/CD authentication, remote state, and EC2 bootstrap configuration.

## Terraform File Layout

```text
terraform/
├── provider.tf
├── variables.tf
├── network.tf
├── main.tf
├── ecr.tf
├── github-oidc.tf
├── backend.tf
├── backend-config.tf
├── outputs.tf
├── userdata.sh
└── README.md