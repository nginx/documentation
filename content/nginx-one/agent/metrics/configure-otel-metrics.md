---
title: Export NGINX instance metrics
weight: 450
toc: true
nd-docs: DOCS-1882
---

## Overview

F5 NGINX Agent now includes an embedded [OpenTelemetry](https://opentelemetry.io/) collector, streamlining observability and metric collection for NGINX instances. With this feature, you can collect:

* Metrics from NGINX Plus and NGINX Open Source
* Host metrics (CPU, memory, disk, and network activity) from VMs or Containers

{{< note >}}
The OpenTelemetry exporter is enabled by default. Once a valid connection to the management plane is established, the Agent will automatically begin exporting metrics.
{{< /note >}}

### Key benefits

* Seamless Integration: No need to deploy an external OpenTelemetry Collector. All components are embedded within the Agent for streamlined observability.
* Standardized Protocol: Support for OpenTelemetry standards ensures interoperability with a wide range of observability backends, including Jaeger, Prometheus, Splunk, and more.

### Verify that metrics are exported

You can validate that metrics are successfully exported by using the methods below:

- **NGINX One dashboard**

   - When an instance has connected to NGINX One Console [See: Connect to NGINX One Console]({{< ref "/nginx-one/connect-instances/add-instance.md" >}}), you should see metrics showing on the NGINX One Console Dashboard.

- **Agent logs**

   Check the OpenTelemetry Collector logs for confirmation of successful metric processing:

   1. Open the file: `/var/log/nginx-agent/opentelemetry-collector-agent.log`
   2. Look for the following logs:

      ```text
      Everything is ready. Begin running and processing data.
      ```
