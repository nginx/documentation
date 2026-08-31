---
f5-docs: DOCS-805
title: Technical specifications
toc: true
weight: 20
f5-content-type: reference
f5-product: NGINX Instance Manager
description: "Technical specifications for F5 NGINX Instance Manager. Covers supported operating systems, Kubernetes distributions, NGINX versions, browsers, and hardware requirements."
f5-summary: >
  Check the technical specifications for F5 NGINX Instance Manager before you install it.
  This reference lists supported operating systems, Kubernetes distributions, NGINX versions, browsers, and hardware requirements.
---

## Overview

F5 NGINX Instance Manager provides centralized management for NGINX Open Source and NGINX Plus instances. Supported environments are bare metal, containers, public clouds, and virtual machines. Supported public clouds are AWS, Microsoft Azure, and Google Cloud Platform. NGINX Instance Manager supports several Linux distributions: Amazon Linux, CentOS, Debian, RHEL, and Ubuntu.

This guide outlines the technical specifications, minimum requirements, and supported platforms for NGINX Instance Manager deployments. These specifications help you achieve optimal performance in small and large environments.

## Supported deployment environments {#supported-environments}

You can deploy NGINX Instance Manager in the following environments:

- **Bare metal**
- **Container**
- **Public cloud**: AWS, Google Cloud Platform, Microsoft Azure
- **Virtual machine**

## Supported Linux distributions {#supported-distributions}

{{< include "nim/tech-specs/supported-distros.md" >}}

## Supported NGINX Instance Manager versions {#supported-nginx-instance-manager-versions}

F5 recommends the latest version of NGINX Instance Manager. It includes the newest features, improvements, and security fixes.

[Technical support](https://www.f5.com/support) is available for the current release and for any version released within two years of the current version's release date.

The following table shows end-of-support (EoS) dates for recent versions.

| NGINX Instance Manager | End of support (EoS) |
|------------------------|-----------------------|
| 2.22.x                 | April 27, 2028        |
| 2.21.x                 | November 07, 2027     |
| 2.20.x                 | June 16, 2027         |
| 2.19.x                 | February 06, 2027     |
| 2.18.x                 | November 08, 2026     |
| 2.17.x                 | July 10, 2026         |
| 2.16.x                 | April 18, 2026        |
| 2.15.x                 | December 12, 2025     |

## Supported NGINX versions {#nginx-versions}

{{< include "nim/tech-specs/supported-nginx-versions.md" >}}

## Sizing recommendations for managing NGINX instances {#system-sizing}

The following recommendations are minimum guidelines for NGINX Instance Manager. For optimal results, F5 recommends solid-state drives (SSDs) for storage. If you set up [deployments with F5 WAF for NGINX](#system-sizing-app-protect), you may need additional memory and CPU.

### Standard NGINX configuration deployments

This section outlines recommendations for NGINX Instance Manager deployments with data plane instances that use standard configurations, without F5 WAF for NGINX. Standard configurations typically support up to 40 upstream servers with associated location and server blocks, and up to 350 certificates. This fits medium-sized environments or applications with moderate traffic.

F5 recommends SSDs to improve storage performance.

{{<table>}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 10                             | 2 vCPU | 4 GB RAM | 1 GbE NIC | 100 GB  |
| 100                            | 2 vCPU | 4 GB RAM | 1 GbE NIC | 1 TB    |
| 1000                           | 4 vCPU | 8 GB RAM | 1 GbE NIC | 3 TB    |
{{</table >}}

These values are the minimum resources for deployments under standard configurations.

### Large NGINX configuration deployments

For environments that need more resources, large configurations are suitable. These configurations can support up to 300 upstream servers. They're designed for enterprise environments or applications that handle high traffic and complex configurations, without F5 WAF for NGINX.

{{<table>}}
| Number of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|--------------------------------|--------|----------|-----------|---------|
| 50                             | 4 vCPU | 8 GB RAM | 1 GbE NIC | 1 TB    |
| 250                            | 4 vCPU | 8 GB RAM | 1 GbE NIC | 2 TB    |
{{</table >}}

### NGINX configuration deployments with F5 WAF for NGINX {#system-sizing-app-protect}

If you use F5 WAF for NGINX features in NGINX Instance Manager, you need additional CPU and memory for policy compilation and security monitoring. A standard F5 WAF for NGINX use case (under 20 NGINX Plus instances) requires a minimum of 8 GB of memory and 4 CPUs.

Requirements depend on the number of policies you manage, how often you update them, and how many events occur in the security monitoring feature.

### Lightweight mode {#lightweight-mode}

(New in 2.20.0) You can run NGINX Instance Manager without ClickHouse. If you don't need monitoring data or want a simpler deployment, use this setup. It reduces system requirements and removes the need to manage a metrics database. If your needs change, you can add ClickHouse later. For instructions, see [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}).

F5 tested Lightweight mode with ten managed NGINX instances and configuration publishing. Without F5 WAF for NGINX, it ran with as little as 1 CPU core and 1 GB of memory. With F5 WAF for NGINX enabled, NGINX Instance Manager needed 2 CPU cores and 4 GB of memory to compile policies.

These figures reflect the minimum tested configuration. If you experience performance issues, allocate more system resources.

{{< call-out class="note" title="Note: Raw usage record storage" >}}
These figures don't include storage or memory for raw usage records. If your NGINX Plus instances report usage data, see [Configure the retention window]({{< ref "nim/licensing-and-reporting/view-recent-nginx-usage.md#configure-the-retention-window" >}}) for sizing guidance based on your instance count and retention period.
{{< /call-out >}}

### License and usage reporting only {#reporting-sizing}

This section applies when you use NGINX Instance Manager only for licensing and usage reporting. In this setup, NGINX instances report license and usage data in an "unmanaged" way. Each instance sends periodic updates to NGINX Instance Manager for counting purposes only.

For details on how to configure this setup, see [Prepare your environment for reporting]({{< ref "/solutions/about-subscription-licenses.md#set-up-environment" >}}).

If you use NGINX Instance Manager only for licensing and usage reporting, it needs minimal CPU and network resources. Regardless of fleet size, this means 2 vCPU and a 1 GbE NIC. F5 recommends [Lightweight mode](#lightweight-mode) for this case, to avoid the ClickHouse dependency, especially if you don't plan to use other features.

Memory and storage depend on your instance count and the retention period you configure for raw usage records, from 0 to 365 days (120-day default). The following table shows estimates at the default 120-day retention and the maximum 365-day (1-year) retention. These figures assume NGINX Plus's default cadence of one usage report per instance per hour.

{{<table>}}
| Instances | 120-day storage | 120-day working memory | 1-year storage | 1-year working memory |
|-----------|------------------|--------------------------|------------------|--------------------------|
| 50        | ~0.13 GB         | ~2.4 GB                  | ~0.4 GB          | ~2.9 GB                  |
| 100       | ~0.26 GB         | ~2.6 GB                  | ~0.8 GB          | ~3.5 GB                  |
| 500       | ~1.3 GB          | ~4.2 GB                  | ~4.0 GB          | ~8.3 GB                  |
| 800       | ~2.1 GB          | ~5.4 GB                  | ~6.3 GB          | ~11.7 GB                 |
| 1,000     | ~2.6 GB          | ~6.2 GB                  | ~7.9 GB          | ~14.1 GB                 |
{{</table >}}

{{< call-out class="note" title="Note: Tested range" >}}
NGINX Instance Manager's scale testing for 1-year retention covered up to 800 instances. The 1,000-instance figures in this table extrapolate beyond that tested point.
{{< /call-out >}}

For retention periods between 120 days and 1 year, memory and storage scale roughly linearly with the number of days you configure. See [Estimate storage for extended retention]({{< ref "nim/licensing-and-reporting/view-recent-nginx-usage.md#estimate-storage-for-extended-retention" >}}) for host-sizing guidance and the per-record storage model behind these figures.

### Sizing benchmarks for storage

The following benchmarks focus on disk storage requirements for NGINX Instance Manager. Storage needs depend on the number of instances and data retention periods (in days). These benchmarks group into three configuration sizes:

- **Small configuration**: Supports about 15 servers, 50 locations, and 30 upstreams or backends. Each instance generates 3,439 metrics per minute.
- **Medium configuration**: Includes about 50 servers, 200 locations, and 200 upstreams or backends. Each instance generates 16,766 metrics per minute.
- **Generic large configuration**: Handles up to 100 servers, 1,000 locations, and 900 upstreams or backends. In NGINX Plus, each instance generates 59,484 metrics per minute.

#### Storage requirements for NGINX Plus

The following table provides storage estimates for NGINX Plus, based on configuration size, instance count, and a 14-day data retention period. Larger configurations and longer retention periods will require proportionally more storage.

{{<table>}}

| Config size            | Instances | Retention (days) | Estimated disk usage (NGINX Plus) |
|------------------------|-----------|-------------------|------------------------------------|
| **Small size**         | 10        | 14                | 5 GiB                              |
|                        | 50        | 14                | 25 GiB                             |
|                        | 100       | 14                | 45 GiB                             |
|                        | 1000      | 14                | 450 GiB                            |
| **Medium size**        | 10        | 14                | 25 GiB                             |
|                        | 50        | 14                | 126 GiB                            |
|                        | 100       | 14                | 251 GiB                            |
|                        | 500       | 14                | 1.157 TiB                          |
| **Generic large size** | 10        | 14                | 100 GiB                            |
|                        | 50        | 14                | 426 GiB                            |
|                        | 100       | 14                | 850 GiB                            |
|                        | 250       | 14                | 2 TiB                              |

{{</table >}}

{{< call-out class="note" title="Note" >}}
MiB (mebibyte), GiB (gibibyte), and TiB (tebibyte) measure data storage in binary units: MiB equals 1,024² (2²⁰) bytes, GiB equals 1,024³ (2³⁰) bytes, and TiB equals 1,024⁴ (2⁴⁰) bytes. MB (megabyte), GB (gigabyte), and TB (terabyte) measure storage in decimal units instead.
{{< /call-out >}}

#### Storage requirements for NGINX Open Source

NGINX Open Source collects fewer metrics per instance than NGINX Plus. This is because NGINX Open Source lacks advanced features such as the NGINX Plus API, which limits the operational data it collects and stores. For example, in the generic large configuration, NGINX Open Source generates only 167 metrics per minute per instance, compared to 59,484 metrics per minute in NGINX Plus.

The following table shows estimated storage requirements for NGINX Open Source, based on instance count and a 14-day retention period.

{{<table>}}

| Config size            | Instances | Retention (days) | Estimated disk usage (NGINX Open Source) |
|------------------------|-----------|-------------------|--------------------------------------------|
| **Generic large size** | 10        | 14                | 200 MiB                                    |
|                        | 50        | 14                | 850 MiB                                    |
|                        | 100       | 14                | 1.75 GiB                                   |
|                        | 250       | 14                | 4 GiB                                      |

{{</table >}}

## Directory requirements for NGINX Instance Manager

The following directory requirements and storage recommendations apply to fresh, minimal, and moderate NGINX Instance Manager deployments (under 100 instances).

{{< call-out class="important" >}}
These recommendations apply if you use NGINX Agent to connect NGINX instances to NGINX Instance Manager for full management capabilities:

- Manage configurations
- View metrics
- Apply F5 WAF for NGINX policies
- Manage certificates

If you're interested only in usage reporting, you don't need NGINX Agent. Usage reporting needs significantly fewer resources. For usage-reporting-only deployments, NGINX Instance Manager receives and stores usage data sent directly from the instances.
{{< /call-out >}}

{{<table>}}
| Directory path         | Content                                   | Recommendation                                                                              |
|------------------------|---------------------------------------------|-----------------------------------------------------------------------------------------------|
| /usr/bin               | Stores NGINX Instance Manager binaries    | 500 MB                                                                                        |
| /var/lib/nms/dqlite    | Stores DQLite database data               | 2 GiB without F5 WAF for NGINX. 5 GiB with F5 WAF for NGINX enabled and large compiled bundles. |
| /var/lib/nms/streaming | Stores NATS streaming messages            | 500 MiB                                                                                       |
| /var/lib/nms/secrets   | Stores secrets for LLM (Local License Manager) license handshakes | 10 MiB                                                                                        |
| /var/lib/nms/modules   | Stores static content like manager.json   | 100 KiB (12 KiB minimum)                                                                       |
| /var/lib/clickhouse    | Stores ClickHouse metrics data            | Recommended: 2.5 GB per instance (25 GB for 10 instances, 250 GB for 100 instances). This applies only if you enable ClickHouse metrics. |
| /var/log/nms           | Stores NGINX Instance Manager logs with rotation enabled | Recommended: 50 MiB per week if you archive logs once a month. |
| /etc/nms/              | Stores NGINX Instance Manager configuration files | 50 MiB                                                                                |
| /etc/nginx             | Stores NGINX configuration files          | Typical size is 10-50 MiB.                                                                     |
{{</table >}}

## ClickHouse tuning {#clickhouse-tuning}

The default ClickHouse configuration works efficiently with NGINX Instance Manager. If you change the configuration and ClickHouse runs out of memory, see the [ClickHouse configuration guide]({{< ref "/nim/system-configuration/configure-clickhouse.md#clickhouse-tuning" >}}) to adjust the settings.

## Firewall ports {#firewall}

NGINX Instance Manager and NGINX Agent use the Unix domain socket by default and proxy through the gateway on port `443`.

Make sure port 443 is open on any firewalls between NGINX Instance Manager, NGINX Agent, and the systems they communicate with. Port 443 carries secure HTTPS traffic between these systems.

## Logging {#logging}

NGINX Instance Manager stores its log files in `/var/log/nms`. As logs grow, your system can run out of disk space. To prevent this, create a separate log partition, or enable [log rotation](http://nginx.org/en/docs/control.html#logs).

## Supported browsers {#supported-browsers}

The NGINX Instance Manager web interface works best on the latest versions of these browsers:

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

## Support for F5 WAF for NGINX {#f5-waf}

{{< include "nim/tech-specs/nim-app-protect-support.md" >}}

## NGINX Agent

### Data plane requirements

- **Supported distributions**: NGINX Agent can run on most environments. For the supported distributions, see the [NGINX Agent technical specifications](https://docs.nginx.com/nginx-agent/technical-specifications/) guide.