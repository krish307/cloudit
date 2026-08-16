# CloudIt Kubernetes

This directory contains the Kubernetes manifests used to run and validate CloudIt in a local Minikube environment.

## Workloads

- Nginx frontend Deployment
- FastAPI backend Deployment
- PostgreSQL StatefulSet

## Kubernetes Capabilities

- Dedicated `cloudit` namespace
- Services and internal service discovery
- ConfigMaps
- Kubernetes Secrets
- Persistent PostgreSQL storage
- Startup probes
- Readiness probes
- Liveness probes
- CPU and memory requests and limits
- Horizontal Pod Autoscaler
- Pod Disruption Budget
- Rolling updates and rollback
- Pod self-healing

## Stateful PostgreSQL

PostgreSQL runs as a StatefulSet with persistent storage.

Persistence was validated by recreating the PostgreSQL Pod and confirming that existing application data remained available.

## Reliability Validation

CloudIt has been tested for:

- Pod recreation
- Self-healing
- Manual scaling
- Horizontal autoscaling
- Controlled rolling updates
- Rollback
- Voluntary disruption protection
- Persistent-data recovery

## Observability

The Kubernetes environment integrates with:

- Prometheus
- Blackbox Exporter
- Grafana
- Kubernetes Metrics Server

See the root `README.md` for architecture, screenshots, and complete implementation details.
