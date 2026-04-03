---
nd-content-type: tech-specs
nd-docs: DOCS-0042
nd-product: BREWMASTER
title: BrewMaster Controller technical specifications
description: "Hardware requirements, performance limits, compatibility, and networking specifications for the BrewMaster Controller."
weight: 100
toc: true
nd-keywords: "BrewMaster Controller, technical specifications, system requirements, performance limits, compatibility, networking, ports, protocols, supported platforms, brew rate, extraction pressure"
nd-summary: >
  This page covers the technical specifications for the BrewMaster Controller, the core processing unit of the F5 BrewMaster automated coffee system.
  Use this page to verify hardware requirements, confirm platform compatibility, and look up performance limits and networking requirements before deployment.
  These specifications apply to BrewMaster Controller version 3.x running on supported Linux platforms.
nd-audience: operator
---

The BrewMaster Controller is the core processing unit of the F5 BrewMaster automated coffee system. It manages extraction scheduling, pressure regulation, and telemetry collection across all connected brewing nodes.

## Overview

Use this page to verify the technical specifications for the BrewMaster Controller. It lists the minimum and recommended hardware requirements, performance limits, compatible platforms and integrations, networking requirements, and known constraints. These specifications apply to BrewMaster Controller version 3.x. For version 2.x specifications, see [BrewMaster Controller 2.x technical specifications](./tech-specs-brewmaster-2x.md).

---

## Architecture diagram

![Architecture diagram of the BrewMaster Controller system showing: (1) the BrewMaster Controller as the central orchestration node, (2) up to 128 connected brewing nodes communicating over UDP port 9001, (3) the GrindSync API receiving inbound connections on TCP port 9000, (4) the BeanVault inventory service receiving outbound connections on TCP port 443, and (5) the BrewMetrics dashboard and management UI accessible on TCP port 8443.](brewmaster-controller-architecture.png)

| Number | Component | Description |
|:--- |:--- |:--- |
| 1 | BrewMaster Controller | The central orchestration node. Manages extraction scheduling, pressure regulation, and telemetry collection for all connected brewing nodes. |
| 2 | Brewing nodes | Individual brewing units managed by the controller. Each node receives recipe instructions and reports telemetry back to the controller. |
| 3 | GrindSync API | The inbound interface through which grind profiles and recipe updates are delivered to the controller from external grind management systems. |
| 4 | BeanVault inventory service | The external inventory system. The controller queries BeanVault outbound to verify bean stock availability before scheduling brew requests. |
| 5 | BrewMetrics dashboard and management UI | The operator-facing interface for monitoring brewing node status, configuring the controller, and viewing telemetry. Accessible on port 8443. |

---

## System requirements

### Minimum requirements

The following table lists the minimum hardware and software configuration on which the BrewMaster Controller is supported. Running on a minimum configuration is suitable for development and testing environments only.

| Component | Minimum |
|:--- |:--- |
| CPU | 2 cores, x86_64 architecture |
| RAM | 4 GB |
| Disk | 20 GB free space on the installation partition |
| Operating system | Ubuntu 22.04 LTS |
| Network interface | 1 Gbps Ethernet |

### Recommended requirements

The following table lists the hardware and software configuration that delivers reliable performance in production environments.

| Component | Recommended |
|:--- |:--- |
| CPU | 8 cores, x86_64 architecture |
| RAM | 16 GB |
| Disk | 100 GB SSD on the installation partition |
| Operating system | Ubuntu 24.04 LTS |
| Network interface | 10 Gbps Ethernet |

---

## Performance limits

The following table lists the performance limits for the BrewMaster Controller under standard operating conditions. All limits assume the recommended hardware configuration unless otherwise noted.

| Metric | Limit | Notes |
|:--- |:--- |:--- |
| `max_brew_requests_per_second` | 500 brew requests per second | Throughput decreases to 200 brew requests per second on minimum hardware. |
| `max_concurrent_brewing_nodes` | 128 nodes | Each additional node beyond 64 requires 512 MB of additional RAM. |
| `max_extraction_pressure` | 15 bar | Requests above 15 bar are rejected with error code `PRESSURE_LIMIT_EXCEEDED`. |
| `max_recipe_payload_size` | 512 KB per recipe | Recipes above this size are rejected with error code `PAYLOAD_TOO_LARGE`. |
| `max_telemetry_events_per_minute` | 10,000 events per minute | Events above this rate are dropped and logged as `TELEMETRY_OVERFLOW`. |
| `max_grind_profile_entries` | 1,000 entries per profile | Profiles exceeding this limit cannot be saved. |

---

## Compatibility

### Supported operating systems

| Operating system | Supported versions | Notes |
|:--- |:--- |:--- |
| Ubuntu | 22.04 LTS, 24.04 LTS | Ubuntu 20.04 LTS reached end of support in BrewMaster Controller 3.2. |
| Debian | 11 (Bullseye), 12 (Bookworm) | Debian 10 is not supported on version 3.x. |
| Red Hat Enterprise Linux | 8, 9 | Requires the `brewmaster-rhel` package variant. |
| Amazon Linux | 2023 | ARM64 architecture is not supported. |

### Supported integrations

| Integration | Supported versions | Notes |
|:--- |:--- |:--- |
| GrindSync API | 2.0, 2.1, 2.2 | GrindSync API 1.x is not supported on BrewMaster Controller 3.x. |
| BeanVault inventory service | 4.x | BeanVault 3.x requires the compatibility shim. See [Connect BeanVault 3.x to BrewMaster Controller](./how-to-beanvault-shim.md). |
| BrewMetrics dashboard | 1.5 and later | BrewMetrics 1.4 and earlier do not support the v3 telemetry schema. |
| OpenTelemetry Collector | 0.90 and later | Earlier versions do not support the `brewmaster_extraction` metric namespace. |

### Supported browsers (management UI)

| Browser | Supported versions |
|:--- |:--- |
| Google Chrome | 120 and later |
| Mozilla Firefox | 121 and later |
| Microsoft Edge | 120 and later |
| Safari | 17 and later |

---

## Networking specifications

The BrewMaster Controller requires the following ports to be open for inbound and outbound traffic. All connections use TLS 1.2 or later unless noted.

| Port | Protocol | Direction | Purpose | Notes |
|:--- |:--- |:--- |:--- |:--- |
| `8443` | TCP | Inbound | Management UI and REST API | TLS required. |
| `9000` | TCP | Inbound | GrindSync API listener | TLS required. |
| `9001` | UDP | Inbound | Telemetry ingestion from brewing nodes | Plaintext. Restrict to the internal network. |
| `4317` | TCP | Outbound | OpenTelemetry Collector export | TLS required when exporting to a remote collector. |
| `443` | TCP | Outbound | BeanVault inventory service | TLS required. |

Minimum bandwidth requirement: 100 Mbps dedicated to brewing node traffic. Maximum observed latency for the GrindSync API listener: 50 ms round-trip on the local network.

---

## Security specifications

| Property | Value | Notes |
|:--- |:--- |:--- |
| TLS versions supported | TLS 1.2, TLS 1.3 | TLS 1.0 and TLS 1.1 are not supported. |
| Minimum certificate key length | 2,048-bit RSA or 256-bit ECDSA | Shorter keys are rejected at startup. |
| Authentication methods | API key, mutual TLS (mTLS) | Basic authentication is not supported on version 3.x. |
| FIPS mode | Supported | Requires the `brewmaster-fips` package variant and a FIPS hardware security module (HSM). |

---

## Known limits and constraints

- The BrewMaster Controller does not support running multiple instances on the same host. Attempting to start a second instance returns error code `INSTANCE_CONFLICT`.
- The maximum log file size is 2 GB. When the log file reaches 2 GB, the BrewMaster Controller stops writing log entries until the file is rotated or cleared.
- The BrewMaster Controller does not support IPv6 on version 3.x. All networking requires IPv4 addresses.
- Brew recipes that contain more than 50 steps are not supported. Recipes exceeding this limit are rejected with error code `RECIPE_TOO_COMPLEX`.
- The BrewMaster Controller cannot be deployed in a disconnected (network-restricted) environment when BeanVault integration is enabled. Disable BeanVault integration before deploying in a disconnected environment.

---

## References

For more information, see:

- [Install the BrewMaster Controller](./install-brewmaster-controller.md)
- [Connect brewing nodes to the BrewMaster Controller](./how-to-connect-brewing-nodes.md)
- [BrewMaster Controller configuration parameters](./reference-brewmaster-config.md)
- [BrewMaster Controller release notes](./release-notes-brewmaster.md)