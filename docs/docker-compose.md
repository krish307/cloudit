# Docker Compose Deployment

## Objective

This phase upgrades the CloudIt project from a single `docker run` command to Docker Compose, making the deployment reproducible and easier to manage.

---

## Technologies Used

- Docker Desktop
- Docker Compose
- Nginx
- Dockerfile
- WSL2

---

## Project Structure

```
CloudIt/
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── Website/
└── docs/
    └── screenshots/
        └── docker-compose/
```

---

## Validation Steps

### Validate configuration

```bash
docker compose config
```

### Build and start

```bash
docker compose up --build -d
```

### Check running containers

```bash
docker compose ps
```

### Verify application

```bash
curl.exe -I http://localhost
```

Expected response:

```
HTTP/1.1 200 OK
```

---

## Outcome

- Docker image built successfully.
- Docker Compose network created.
- Container started successfully.
- Nginx served the application on port 80.
- Health checks configured.
- Website verified locally.

---

## Screenshots

See:

`docs/screenshots/docker-compose/`