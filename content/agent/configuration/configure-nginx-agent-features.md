---
title: Features configuration
weight: 150
toc: true
nd-docs: DOCS-000
nd-content-type: how-to
---

## Overview

This guide describes the F5 NGINX Agent features, and how to enable and disable features using the NGINX Agent configuration file.

## Before you begin

Before you start, make sure that you have:

- [NGINX Agent installed]({{< ref "/agent/installation-upgrade/" >}}) in your system.
- Access to the NGINX Agent configuration file.

## Features

The following table lists the NGINX Agent features:

{{< table "features" >}}
| Feature Name     | Description                                                             | Default/Non-default |
| ---------------- | ----------------------------------------------------------------------- | ------------------- |
| registration     | Registering the NGINX Agent with the management plane.                  | Default             |
| nginx-config-async | Enable the publishing and uploading of NGINX configurations from the management plane. | Default             |
| metrics          | Enable collecting of NGINX metrics.                                     | Default             |
| metrics-throttle | Batch metrics before sending.                                           | Non-default         |
| metrics-sender   | Reports metrics over the gRPC connection.                               | Non-default         |
| dataplane-status | Report the health of the NGINX Instance.                                | Default             |
| process-watcher  | Observe changes to the NGINX process.                                   | Default             |
| file-watcher     | Observe changes to the NGINX configuration or any changes to files on disk. | Default          |
| activity-events  | Send NGINX or NGINX Agent related events to the management plane.       | Default             |
| agent-api        | Enable the NGINX Agent REST API.                                        | Default             |
{{< /table >}}

## Use cases

### Enable metrics only

1. Access the NGINX instance: Connect using SSH to the VM or server where NGINX Agent is running.

   `ssh user@your-nginx-instance`

1. Open the NGINX Agent configuration file in a text editor.

   `sudo vim /etc/nginx-agent/nginx-agent.conf`

1. Add the features section: Add the following to the end of the configuration file if it doesn't already exist.

   ```nginx
   features:
      - metrics
      - metrics-throttle
      - dataplane-status
   ```

1. Restart the NGINX Agent service to apply the changes.

   `sudo systemctl restart nginx-agent`

Once the steps have been completed, users will be able to view metrics data being sent but will not have the capability to push NGINX configuration changes.

### Enable the publishing of NGINX configurations and disable the collection of metrics

1. Access the NGINX instance: Connect using SSH to the VM or server where NGINX Agent is running.

   `ssh user@your-nginx-instance`

1. Open the NGINX Agent configuration file in a text editor.

   `sudo vim /etc/nginx-agent/nginx-agent.conf`

1. Add the fetures section: Add the following to the end of the configuration file if it doesn't already exist.

   ```nginx
   features:
      - nginx-config-async
      - dataplane-status
      - file-watcher

1. Restart the NGINX Agent service to apply the changes.

   `sudo systemctl restart nginx-agent`

Once the steps have been completed, users will be able to publish NGINX configurations but metrics data will not be collected by the NGINX Agent.
