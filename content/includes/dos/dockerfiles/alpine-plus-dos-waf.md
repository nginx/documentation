---
f5-product: F5 DOS for NGINX
f5-files:
- content/nap-dos/deployment-guide/learn-about-deployment.md
---

```dockerfile
# syntax=docker/dockerfile:1

# Supported OS_VER's are 3.21/3.22
ARG OS_VER="3.22"

# Base image
FROM alpine:${OS_VER}

# Install NGINX Plus and F5 DOS for NGINX


```
