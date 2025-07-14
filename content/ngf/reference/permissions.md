---
title: Permissions
description: NGINX Gateway Fabric permissions required by components.
weight: 300
toc: true
type: reference
product: NGF
---

NGINX Gateway Fabric uses a split-plane architecture with three components that require different permissions:

- **Control Plane**: Manages Kubernetes APIs and data plane deployments. Needs broad API access but handles no user traffic.
- **Data Plane**: Processes user traffic. Requires minimal permissions since configuration comes from control plane via secure gRPC.
- **Certificate Generator**: One-time job that creates TLS certificates for inter-plane communication.

## Common Security Context

All components share these security settings:

- **User ID**: 101 (non-root)
- **Group ID**: 1001
- **Capabilities**: All dropped (`drop: ALL`)
- **Root Filesystem**: Read-only
- **Seccomp**: Runtime default profile

## Control Plane

Runs as a single container in the `nginx-gateway` deployment.

### Additional Security Settings

- **Privilege Escalation**: Disabled (may need enabling for NGINX reload in some environments)

### Volumes

| Volume | Type | Purpose |
|--------|------|---------|
| `nginx-agent-tls` | Secret | TLS certificates for control plane communication |

### RBAC Permissions

The control plane requires these Kubernetes API permissions:

- **Secrets, ConfigMaps, Services**: Create, update, delete, list, get, watch
- **Deployments, DaemonSets**: Create, update, delete, list, get, watch
- **ServiceAccounts**: Create, update, delete, list, get, watch
- **Namespaces, Pods**: Get, list, watch
- **Events**: Create, patch
- **EndpointSlices**: List, watch
- **Gateway API resources**: List, watch (read-only) + update status subresources only
- **NGF Custom resources**: Get, list, watch (read-only) + update status subresources only
- **Leases**: Create, get, update (for leader election)
- **CustomResourceDefinitions**: List, watch
- **TokenReviews**: Create (for authentication)

## Data Plane

NGINX containers managed by the control plane. No RBAC permissions needed since configuration comes via secure gRPC.

### Additional Security Settings

- **Privilege Escalation**: Disabled
- **Sysctl**: `net.ipv4.ip_unprivileged_port_start=0` (enables binding to ports < 1024)

### Volumes

#### Core NGINX Operations
| Volume | Type | Purpose |
|--------|------|---------|
| `nginx-conf` | EmptyDir | Main NGINX configuration |
| `nginx-stream-conf` | EmptyDir | Stream configuration |
| `nginx-secrets` | EmptyDir | TLS secrets for NGINX |
| `nginx-run` | EmptyDir | Runtime files (PID, sockets) |
| `nginx-cache` | EmptyDir | Cache directory |

#### Configuration Includes
| Volume | Type | Purpose |
|--------|------|---------|
| `nginx-main-includes` | EmptyDir | Main context includes |
| `nginx-includes` | EmptyDir | HTTP context includes |

#### NGINX Agent
| Volume | Type | Purpose |
|--------|------|---------|
| `nginx-agent` | EmptyDir | NGINX Agent configuration |
| `nginx-agent-tls` | Secret | TLS certificates for control plane communication |
| `nginx-agent-log` | EmptyDir | NGINX Agent logs |
| `nginx-agent-lib` | EmptyDir | NGINX Agent runtime data |

#### Authentication
| Volume | Type | Purpose |
|--------|------|---------|
| `token` | Projected | Service account token |

### Volume Permissions

- **EmptyDir**: Read-write (required for NGINX operation)
- **Secret/ConfigMap/Projected**: Read-only

## Certificate Generator

Kubernetes Job that creates initial TLS certificates.

### RBAC Permissions

- **Secrets**: Create, update, get (NGINX Gateway Fabric namespace only)

## OpenShift Compatibility

NGINX Gateway Fabric includes Security Context Constraints (SCCs) for OpenShift:

### Control Plane SCC

- **Privilege Escalation**: Disabled
- **Host Access**: Disabled (network, IPC, PID, ports)
- **User ID Range**: 101-101 (fixed)
- **Group ID Range**: 1001-1001 (fixed)
- **Volumes**: Secret only

### Data Plane SCC

Same restrictions as control plane, plus additional volume types:

- **Additional Volumes**: EmptyDir, ConfigMap, Projected

## Linux Capabilities

NGINX Gateway Fabric drops ALL Linux capabilities and adds none, following security best practices.

### How It Works Without Capabilities

- **Process Management**: Standard Unix signals (no elevated privileges needed)
- **Port Binding**: Uses sysctl `net.ipv4.ip_unprivileged_port_start=0` for ports < 1024
- **File Operations**: Volume mounts provide necessary write access

### Troubleshooting

If you encounter "operation not permitted" errors during NGINX reload, temporarily enable `allowPrivilegeEscalation: true` while investigating the root cause.

## Security Features

- **Separation of concerns**: Control plane (API access, no traffic) vs data plane (traffic, no API access)
- **Non-root execution**: All components run as unprivileged user (UID 101)
- **Zero capabilities**: All Linux capabilities dropped
- **Read-only root filesystem**: Prevents runtime modifications
- **Ephemeral storage**: Temporary volumes only, no persistent storage
- **Least privilege RBAC**: Minimal required permissions per component
- **Secure communication**: mTLS-encrypted gRPC (TLS 1.3+) between planes
