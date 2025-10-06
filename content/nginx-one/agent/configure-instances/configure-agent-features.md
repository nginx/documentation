---
title: Review and configure features
weight: 350
toc: true
nd-docs: DOCS-000
nd-content-type: how-to
---

## Overview

This guide describes the F5 NGINX Agent features, and how to enable and disable them using the NGINX Agent configuration file, CLI flags, environment variables, and gRPC updates.

## Before you begin

Before you start, make sure that you have:

- [NGINX Agent installed]({{< ref "/nginx-one/agent/install-upgrade/" >}}) in your system.
- Access to the NGINX Agent configuration file, CLI, or container environment.

## Features

The following table lists the NGINX Agent features:

{{< table "features" >}}
| Feature Name        | Description                                                                 | Default |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| configuration       | Full read/write management of configurations, controlled by DataPlaneConfig ConfigMode. | On      |
| certificates        | Inclusion of public keys and other certificates in the configurations toggled by DataPlaneConfig CertMode                 | Off     |
| connection          | Sends an initial connection message reporting instance information on presence of Command ServerConfig Host and Port                 | On      |
| file-watcher        | Monitoring of file changes in the allowed directories list and references from product configs.             | On      |
| agent-api           | REST API for NGINX Agent.                                                    | Off     |
| metrics             | Full metrics reporting.                                                      | On      |
| > metrics-host      | Host-level metrics (cpu, disk, load, fs, memory, network, paging).           | On      |
| > metrics-container | Container-level metrics from cgroup information.                             | On      |
| > metrics-instance  | OSS and Plus metrics depending on NGINX instance.                            | On      |
| logs                | Collection and reporting of NGINX error logs.                                | Off     |
| > logs-nap          | F5 WAF for NGINX logs.                                                       | Off     |
{{< /table >}}

## Configuration sources

You can enable or disable features using several configuration sources:

### CLI parameters

Enable features at launch:

   ```shell
   ./nginx-agent --features=connection,configuration,metrics,file-watcher,agent-api
   ```

### Environment variables

Use environment variables for containerized deployments:

   ```shell
   export NGINX_AGENT_FEATURES="connection,configuration,metrics,file-watcher,agent-api"
   ```

### Configuration file

Define features in the `nginx-agent.conf` file:

   ```yaml
   features:
   - connection
   - configuration
   - metrics
   - file-watcher
   - agent-api
   ```

## Use cases

### Enable metrics only

1. Access the NGINX instance: Connect using SSH to the VM or server where NGINX Agent is running.

   `ssh user@your-nginx-instance`

1. Open the NGINX Agent configuration file in a text editor.

   `sudo vim /etc/nginx-agent/nginx-agent.conf`

1. Add the features section: Add the following to the end of the configuration file if it doesn't already exist.

   ```yaml
   features:
   - metrics
   - metrics-host
   - metrics-container
   - metrics-instance
   ```

1. Restart the NGINX Agent service to apply the changes.

   `sudo systemctl restart nginx-agent`

Once the steps have been completed, users will be able to view metrics data being sent but will not have the capability to push NGINX configuration changes.

