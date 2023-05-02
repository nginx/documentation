---
categories:
- beta
- reference
description: Man page and instructions for using the NGINX Instance Manager CLI
draft: true
title: Server CLI Reference
description: "Man page and instructions for using the NGINX Instance Manager CLI."
draft: false
weight: 300
toc: true
categories: ["reference"]
docs: "DOCS-638"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help people run NGINX Instance Manager on the command line.

## Prerequisites {#prerequisites}

Install NGINX Instance Manager and know where the binary location is. By default, the packager installs nginx-manager to `/usr/sbin/nginx-manager.`

## Usage {#usage}

`nginx-manager` is the CLI binary for NGINX Instance Manager.

```bash
Usage:
  nginx-manager [flags]

Flags:
      --audit-log string              set API access log path
      --auth                          enable auth checks on server
      --bind-address string           set the bind address for all service ports (default "localhost")
      --cert string                   Path to x.509 certificate file
      --gateway-port string           set gRPC-gateway service port for API and UI (default "11000")
      --grpc-port string              set gRPC service port for agent communication (default "10000")
      --headless                      disable UI service
  -h, --help                          help for nginx-manager
      --key string                    set path to x.509 certificate key file
      --license string                set path to the license file
      --log-level string              set log level (panic, fatal, error, info, debug, trace, info) (default "info")
      --log-path string               set log path and if empty log only to stdout/stderr (default "/var/log/nginx-manager/")
      --login                         enable temp login page
      --metrics-storage-path string   set storage path on disk for metrics (default "/tmp/metrics")
      --rbac                          enable Role-Based Access Control
      --server-name string            set the bind address for all service ports
      --skip-validation               disable NGINX config validation in editor
  -v, --version                       version for nginx-manager
```
