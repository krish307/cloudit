\# CloudIt Terraform Infrastructure



This directory contains the Terraform configuration used to provision and manage the AWS infrastructure for CloudIt.



Terraform provides reproducible Infrastructure as Code (IaC) for the production environment and supports automated application deployment through GitHub Actions.



\## AWS Infrastructure



The Terraform configuration provisions the AWS resources required by the CloudIt production environment, including:



\- Custom VPC

\- Public subnet

\- Internet Gateway

\- Route table and route-table association

\- Security Group

\- EC2 production instance

\- Dynamic Ubuntu 22.04 LTS AMI lookup

\- Encrypted EBS root storage

\- Amazon ECR repository

\- EC2 IAM role and instance profile

\- GitHub Actions OIDC IAM integration

\- Remote Terraform state infrastructure



\## Infrastructure Architecture



```text

Terraform

&#x20;  |

&#x20;  +--> VPC

&#x20;  |     |

&#x20;  |     +--> Public Subnet

&#x20;  |     |

&#x20;  |     +--> Internet Gateway

&#x20;  |     |

&#x20;  |     +--> Route Table

&#x20;  |     |

&#x20;  |     +--> Security Group

&#x20;  |

&#x20;  +--> EC2

&#x20;  |     |

&#x20;  |     +--> IAM Instance Profile

&#x20;  |     |

&#x20;  |     +--> Docker Runtime

&#x20;  |

&#x20;  +--> Amazon ECR

&#x20;  |

&#x20;  +--> GitHub Actions IAM / OIDC

&#x20;  |

&#x20;  +--> Remote Terraform State

```



\## Dynamic AMI Selection



CloudIt does not hardcode an Ubuntu AMI ID.



Terraform uses an AWS data source to dynamically locate the appropriate Ubuntu 22.04 LTS image for the configured AWS region.



This improves portability and avoids maintaining region-specific AMI identifiers manually.



\## EC2 Production Host



The EC2 instance acts as the Docker Compose production host.



During infrastructure bootstrap, User Data prepares the instance with the software required to run CloudIt.



The production host is subsequently used by the CI/CD pipeline to run:



```text

Nginx

FastAPI

PostgreSQL

```



through:



```text

compose.aws.fullstack.yaml

```



\## Amazon ECR



CloudIt uses Amazon Elastic Container Registry to store production container images.



The CI/CD pipeline publishes independently deployable frontend and API images:



```text

cloudit-app:frontend-latest

cloudit-app:api-latest

```



The EC2 instance pulls these private images during production deployment.



\## IAM and Authentication



CloudIt separates CI/CD permissions from production runtime permissions.



\### GitHub Actions



GitHub Actions authenticates to AWS using OpenID Connect (OIDC).



This allows the workflow to assume a restricted IAM role without storing permanent AWS access keys in GitHub.



\### EC2



The production EC2 host uses an IAM instance profile.



Temporary AWS credentials obtained through the instance profile allow the server to authenticate to Amazon ECR and pull private production images.



This avoids storing permanent AWS credentials on the EC2 host.



\## Remote Terraform State



Terraform state is maintained remotely using AWS infrastructure rather than relying only on local state.



The remote-state design includes:



\- Amazon S3 state storage

\- S3 versioning

\- Server-side encryption

\- Terraform state locking



This provides safer infrastructure management and protects against concurrent Terraform modifications.



\## Security Controls



Infrastructure security controls include:



\- IMDSv2 enforcement

\- Encrypted EBS root storage

\- Security Group network controls

\- IAM roles instead of permanent AWS credentials

\- GitHub Actions OIDC authentication

\- Restricted ECR access

\- Remote Terraform state

\- State encryption and versioning

\- Terraform state locking

\- Sensitive local variable files excluded from Git

\- SSH private keys excluded from Git



\## Terraform Workflow



Initialize Terraform:



```bash

terraform init

```



Format configuration:



```bash

terraform fmt

```



Validate configuration:



```bash

terraform validate

```



Preview infrastructure changes:



```bash

terraform plan

```



Create a saved execution plan:



```bash

terraform plan -out=cloudit.tfplan

```



Apply the saved plan:



```bash

terraform apply cloudit.tfplan

```



Inspect Terraform outputs:



```bash

terraform output

```



Destroy managed infrastructure when required:



```bash

terraform destroy

```



\## Important Files



The Terraform directory contains configuration for:



```text

Provider configuration

Input variables

Networking

EC2 infrastructure

Security Groups

IAM

Amazon ECR

Remote state

Outputs

User Data bootstrap

```



The exact `.tf` files in this directory remain the authoritative implementation of these resources.



\## Production Delivery Integration



Terraform provisions the infrastructure on which the CI/CD system operates.



The complete delivery relationship is:



```text

Terraform

&#x20;  |

&#x20;  v

AWS Infrastructure

&#x20;  |

&#x20;  +--> Amazon ECR

&#x20;  |

&#x20;  +--> EC2 Production Host



Git Push

&#x20;  |

&#x20;  v

GitHub Actions

&#x20;  |

&#x20;  +--> OIDC --> AWS

&#x20;  |

&#x20;  +--> Build Images

&#x20;  |

&#x20;  +--> Push --> Amazon ECR

&#x20;  |

&#x20;  +--> Deploy --> EC2

```



Terraform therefore manages the infrastructure lifecycle, while GitHub Actions manages application delivery.



\## Sensitive Files



Files containing local credentials, secrets, private keys, or Terraform state must not be committed to the repository.



Examples include:



```text

terraform.tfvars

\*.tfstate

\*.tfstate.\*

\*.pem

```



See the root `README.md` for the complete CloudIt architecture, CI/CD pipeline, security controls, screenshots, and production deployment documentation.
