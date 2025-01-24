---
docs: DOCS-805
doctypes: reference
title: Technical Specifications
toc: true
weight: 20
---

## Overview

NGINX Instance Manager provides centralized management for NGINX Open Source and NGINX Plus instances across various environments, including bare metal, containers, public clouds (AWS, Azure, Google Cloud), and virtual machines. It supports several Linux distributions, including Amazon Linux, CentOS, Debian, RHEL, and Ubuntu. This guide outlines the technical specifications, minimum requirements, and supported platforms for deploying NGINX Instance Manager, ensuring optimal performance in both small and large environments.

## Supported deployment environments {#supported-environments}

You can deploy NGINX Instance Manager in the following environments:

- **Bare metal**
- **Container**
- **Public cloud**: AWS, Google Cloud Platform, Microsoft Azure
- **Virtual machine**

## Supported Linux Distributions {#supported-distributions}

{{< include "nim/tech-specs/supported-distros.md" >}}

## Supported NGINX Versions {#nginx-versions}

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

## Sizing recommendations for Managing NGINX Instances {#system-sizing}

The following recommendations provide the minimum guidelines for NGINX Instance Manager. These guidelines ensure adequate performance, but for optimal results, we strongly recommend using solid-state drives (SSDs) for storage. If you set up [deployments with NGINX App Protect](#system-sizing-app-protect), you may need additional memory and CPU. 

### Standard NGINX configuration deployments

This section outlines the recommendations for NGINX Instance Manager deployments with data plane instances using standard configurations, without NGINX App Protect. **Standard configurations** typically support up to **40 upstream servers** with associated location and server blocks, and up to **350 certificates**. This is ideal for medium-sized environments or applications with moderate traffic.

We recommend using SSDs to enhance storage performance. 

{{<bootstrap-table "table table-striped table-bordered">}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 10                             | 2 vCPU | 4 GB RAM | 1 GbE NIC | 100 GB  |
| 100                            | 2 vCPU | 4 GB RAM | 1 GbE NIC | 1 TB    |
| 1000                           | 4 vCPU | 8 GB RAM | 1 GbE NIC | 3 TB    |
{{</bootstrap-table>}}

These values represent the minimum resources needed for deployments that fall under standard configurations.

### Large NGINX configuration deployments

For environments requiring more resources, **large configurations** are suitable. These configurations can support up to **300 upstream servers** and are designed for enterprise environments or applications handling high traffic and complex configurations, without NGINX App Protect.

{{<bootstrap-table "table table-striped table-bordered">}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 50                             | 4 vCPU | 8 GB RAM | 1 GbE NIC | 1 TB    |
| 250                            | 4 vCPU | 8 GB RAM | 1 GbE NIC | 2 TB    |
{{</bootstrap-table>}}

### NGINX configuration deployments with NGINX App Protect {#system-sizing-app-protect}

If using NGINX App Protect features in NGINX Instance Manager, this requires additional CPU and Memory for policy compilation and security monitoring features. At a minimum, 8gb Memory and 4 CPUs are required for a standard NGINX App Protect use case (under 20 NGINX Plus instances). The requirements are heavily dependent on the number of policies being managed, the frequency of updates and the number of events being that occur in the security monitoring feature. 

### License and usage reporting only {#reporting-sizing}

This section assumes you've configured NGINX Instance Manager to manage your NGINX instances for licensing and usage reporting only. NGINX commercial license and usage reporting is done in an “unmanaged” way, where NGINX sends a request periodically to NGINX Instance Manager solely for counting purposes. For more information, see how you would [Prepare your environment for reporting]({{< relref "/solutions/about-subscription-licenses.md#set-up-environment" >}}).

Therefore, the requirements for NGINX Instance Manager when used solely for licensing and usage reporting are minimal.

{{<bootstrap-table "table table-striped table-bordered">}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| n/a                            | 2 vCPU | 4 GB RAM | 1 GbE NIC | 20 GB   |
{{</bootstrap-table>}}

### Sizing benchmarks for storage

The following benchmarks focus on **disk storage** requirements for NGINX Instance Manager. Storage needs depend on the **number of instances** and **data retention periods** (in days). The benchmarks are divided into three configuration sizes:

- **Small configuration**: Typically supports about **15 servers**, **50 locations**, and **30 upstreams/backends**. Each instance generates **3,439 metrics per minute**.
- **Medium configuration**: Usually includes about **50 servers**, **200 locations**, and **200 upstreams/backends**. Each instance generates **16,766 metrics per minute**.
- **Generic Large configuration**: Handles up to **100 servers**, **1,000 locations**, and **900 upstreams/backends**. In **NGINX Plus**, each instance generates **59,484 metrics per minute**.

#### Storage requirements for NGINX Plus

The table below provides storage estimates for **NGINX Plus** based on configuration size, number of instances, and a 14-day data retention period. Larger configurations and longer retention periods will require proportionally more storage.

{{<bootstrap-table "table table-striped table-bordered">}}
| Config Size         | Instances | Retention (days) | Estimated Disk Usage (NGINX Plus) |
|---------------------|-----------|------------------|-----------------------------------|
| **Small Size**       | 10        | 14               | 5 GiB                             |
|                     | 50        | 14               | 25 GiB                            |
|                     | 100       | 14               | 45 GiB                            |
|                     | 1000      | 14               | 450 GiB                           |
| **Medium Size**      | 10        | 14               | 25 GiB                            |
|                     | 50        | 14               | 126 GiB                           |
|                     | 100       | 14               | 251 GiB                           |
|                     | 500       | 14               | 1.157 TiB                         |
| **Generic Large Size** | 10        | 14               | 100 GiB                           |
|                     | 50        | 14               | 426 GiB                           |
|                     | 100       | 14               | 850 GiB                           |
|                     | 250       | 14               | 2 TiB                             |
{{</bootstrap-table>}}

{{<note>}}MiB (mebibyte), GiB (gibibyte), and TiB (tebibyte) are units of data storage. MiB equals 1,024^2 (2^20) bytes, GiB equals 1,024^3 (2^30) bytes, and TiB equals 1,024^4 (2^40) bytes. These are often used in computing to represent binary data storage capacities, as opposed to MB (megabyte), GB (gigabyte), and TB (terabyte), which use decimal units.{{</note>}}

#### Storage requirements for NGINX OSS

**NGINX OSS** collects fewer metrics per instance compared to NGINX Plus. This is because NGINX OSS lacks the advanced features of NGINX Plus, such as the NGINX Plus API, which limits the amount of operational data collected and stored. For example, in the **Generic Large configuration**, NGINX OSS generates only **167 metrics per minute per instance**, compared to **59,484 metrics per minute** in NGINX Plus.

The table below shows the estimated storage requirements for **NGINX OSS**, based on the number of instances and a 14-day retention period.

{{<bootstrap-table "table table-striped table-bordered">}}
| Config Size           | Instances | Retention (days) | Estimated Disk Usage (NGINX OSS) |
|-----------------------|-----------|------------------|----------------------------------|
| **Generic Large Size** | 10        | 14               | 200 MiB                          |
|                       | 50        | 14               | 850 MiB                          |
|                       | 100       | 14               | 1.75 GiB                         |
|                       | 250       | 14               | 4 GiB                            |
{{</bootstrap-table>}}

## Firewall ports {#firewall}

NGINX Instance Manager and NGINX Agent use the Unix domain socket by default and proxy through the gateway on port `443`.

To ensure smooth communication, make sure port 443 is open on any firewalls between NGINX Instance Manager, NGINX Agent, and other systems they need to communicate with. This allows secure HTTPS traffic to pass through.

## Logging {#logging}

NGINX Instance Manager stores its log files in `/var/log/nms`. To prevent your system from running out of disk space as logs grow, we recommend either creating a separate partition for logs or enabling [log rotation](http://nginx.org/en/docs/control.html#logs).

## Supported Browsers {#supported-browsers}

The NGINX Instance Manager web interface works best on the latest versions of these browsers:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

## Support for NGINX App Protect WAF

{{< include "nim/tech-specs/nim-app-protect-support.md" >}}

## Security Monitoring Module {#security-monitoring}


### Dependencies with NGINX Instance Manager

#### Control plane requirements

{{< include "nim/tech-specs/security-management-plane-dependencies.md" >}}

### Dependencies with NGINX App Protect WAF and NGINX Plus

#### Data plane requirements

{{< include "nim/tech-specs/security-data-plane-dependencies.md" >}}

## NGINX Agent

#### Data plane requirements

- **Supported distributions**: The NGINX Agent can run on most environments. For the supported distributions, see the [NGINX Agent Technical Specs](https://docs.nginx.com/nginx-agent/technical-specifications/) guide.
