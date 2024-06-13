---
description: Man page and instructions for using the NGINX Agent CLI
docs: DOCS-814
draft: true
title: Agent CLI Reference
toc: true
weight: 300
---

<!-- vale off --> 
<!-- remove the vale comment and this one before flipping draft status -->

{{< shortversions "2.0.0" "latest" "nimvers" >}}

{{%heading "overview"%}}

This document is intended to help people run NGINX Agent on the command line. The agent runs as a linux daemon and sends information to the Instance Manager server over grpc polling every 1 seconds.

## Prerequisites {#prerequisites}

Install NGINX Agent and know where the binary location is.  By default the packager installs nginx-manager to /usr/sbin/nginx-agent.

## Usage {#usage}

`nginx-agent` is the CLI binary for NGINX agent.

```bash
Usage:
  nginx-agent [flags]

Flags:
      --api-token string                       set token to auth to commander & metrics service
      --config-dirs string                     set comma-separated list of allowed config directories (default "/etc/nginx")
  -h, --help                                   help for nginx-agent
      --log-level string                       set log level (panic, fatal, error, info, debug, trace, info) (default "info")
      --log-path string                        set log path. If empty, logs only to stdout/stderr instead (default "/var/log/nginx-agent")
      --metadata stringToString                set metadata for the specific instance/machine. Each entry is a key/value pair separated by an equals sign. (default [])
      --metrics-mode string                    set type of nginx metrics collected (nim, controller) (default "nim")
      --metrics-server string                  set gRPC port of the metrics server to connect to
      --nginx-bin-path string                  set path to the NGINX Binary
      --nginx-exclude-logs string              set comma-separated list of NGINX access log paths to exclude from metrics
      --nginx-metrics-poll-interval duration   set metrics poll interval (default 1s)
      --nginx-pid-path string                  set path to the NGINX PID file
      --nginx-plus-api string                  set NGINX plus status api URL (see nginx.org/r/api)
      --nginx-stub-status string               set NGINX stub status URL (see: nginx.org/r/stub_status)
      --server string                          set gRPC port of the server to connect to (default "localhost:10000")
      --tags strings                           set comma-separated list of tags for this specific instance / machine for inventory purposes
      --tls-ca string                          set path to CA certificate file
      --tls-cert string                        set path to certificate file
      --tls-enable                             set to True for grpcs or False for offloading grpc without encrypting grpcs on nginx-manager. Omit for no encryption.
      --tls-key string                         set path to the certificate key file
  -v, --version                                version for nginx-agent
```
