# CloudIt Docker Compose

CloudIt uses Docker Compose to run its multi-container application stack consistently across local development and AWS production environments.

## Application Stack

The full-stack application consists of three services:

### Frontend

- Nginx
- Serves the CloudIt web interface
- Reverse-proxies application requests to FastAPI
- Exposes the application to the client

### API

- FastAPI
- Handles application and health endpoints
- Communicates with PostgreSQL over the internal Docker network
- Includes an application health check

### Database

- PostgreSQL 16 Alpine
- Stores persistent application data
- Uses a named Docker volume for data persistence
- Includes database health validation

The runtime request path is:

```text
Client
  |
  v
Nginx Frontend
  |
  v
FastAPI
  |
  v
PostgreSQL
```

## Local Full-Stack Environment

The local development environment is defined in:

```text
compose.fullstack.yaml
```

It builds the frontend and API images locally and runs PostgreSQL as the database service.

The local environment exposes:

- Frontend: `http://localhost:8080`
- API: `http://localhost:8000`
- Health endpoint: `http://localhost:8000/health`
- Operations dashboard: `http://localhost:8080/operations.html`

### Environment Variables

The local full-stack environment requires `.env.fullstack` for PostgreSQL variable interpolation used by both the database and API services.

The file contains the following variables:

```text
POSTGRES_DB
POSTGRES_USER
POSTGRES_PASSWORD
```

The actual environment file is excluded from Git to prevent credentials from being committed to the repository.

## Local Deployment

Validate the Compose configuration:

```bash
docker compose --env-file .env.fullstack -f compose.fullstack.yaml config
```

Build and start the complete application stack:

```bash
docker compose --env-file .env.fullstack -f compose.fullstack.yaml up -d --build
```

Check container status:

```bash
docker compose --env-file .env.fullstack -f compose.fullstack.yaml ps
```

A successful deployment should show all three services running:

```text
cloudit-postgres    healthy
cloudit-api         healthy
cloudit-frontend    healthy
```

Verify API and database connectivity:

```bash
curl http://localhost:8000/health
```

Expected response:

```json
{
  "status": "healthy",
  "database": "connected"
}
```

Verify the operations dashboard:

```bash
curl -I http://localhost:8080/operations.html
```

Expected result:

```text
HTTP/1.1 200 OK
```

Stop the local environment:

```bash
docker compose --env-file .env.fullstack -f compose.fullstack.yaml down
```

## AWS Production Environment

AWS production uses a separate Compose configuration:

```text
compose.aws.fullstack.yaml
```

The production stack also consists of:

```text
Nginx
  |
  v
FastAPI
  |
  v
PostgreSQL
```

Unlike the local environment, production supports frontend and API images supplied through environment variables:

```text
FRONTEND_IMAGE
API_IMAGE
```

This allows GitHub Actions to deploy production images stored in Amazon ECR.

The production frontend is exposed on:

```text
80:80
```

PostgreSQL and FastAPI remain on the internal Docker network rather than being directly exposed publicly.

## Service Dependencies and Health Checks

CloudIt uses health-aware service dependencies.

The startup sequence is:

```text
PostgreSQL
    |
    | healthy
    v
FastAPI
    |
    | healthy
    v
Nginx
```

PostgreSQL is validated using `pg_isready`.

FastAPI exposes `/health`, which verifies that the application is running and can communicate with PostgreSQL.

The frontend health check verifies that the operations interface is available.

This prevents dependent services from being treated as ready before their required services are operational.

## Persistent Storage

PostgreSQL data is stored using named Docker volumes.

Local environment:

```text
cloudit-postgres-data
```

AWS production environment:

```text
cloudit-postgres-production
```

Container recreation therefore does not automatically remove PostgreSQL application data.

## Container Resource Controls

The Compose configurations define memory limits for application services.

These limits help prevent individual containers from consuming unrestricted host memory and provide more predictable runtime behavior.

## Production Deployment Flow

The production container delivery path is:

```text
Git Push
   |
   v
GitHub Actions
   |
   v
Build Frontend + API Images
   |
   v
Amazon ECR
   |
   v
EC2
   |
   v
Docker Compose
   |
   +--> Nginx
   |
   +--> FastAPI
   |
   +--> PostgreSQL
```

GitHub Actions publishes the production images to Amazon ECR.

The EC2 host authenticates to ECR through its IAM instance profile, pulls the latest images, and recreates the application using `compose.aws.fullstack.yaml`.

## Validation Result

The local full-stack deployment has been validated successfully with:

- PostgreSQL reporting healthy
- FastAPI reporting healthy
- Nginx frontend reporting healthy
- `/health` returning `"status": "healthy"`
- PostgreSQL connectivity returning `"database": "connected"`
- `/operations.html` returning HTTP `200 OK`

This validates the complete request path from the frontend through the API to the PostgreSQL database.
