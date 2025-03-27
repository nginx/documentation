---
title: "Technical Specifications"
toc: true
weight: 700
docs: DOCS-000
---

## Overview

This document outlines the technical specifications for the F5 NGINX Agent, including details on supported operating systems, deployment environments, compatible NGINX versions, minimum system sizing requirements, and logging considerations.

---

## Supported Distributions

The NGINX Agent is versatile and can operate across various environments. Currently, the following distributions are supported:

| Distribution                       | Supported Versions                    | Architectures       |
|------------------------------------|---------------------------------------|---------------------|
| **AlmaLinux**                      | 8, 9                                  | x86_64, aarch64     |
| **Alpine Linux**                   | 3.16, 3.17, 3.18, 3.19                | x86_64, aarch64     |
| **Amazon Linux**                   | 2023                                  | x86_64, aarch64     |
| **Amazon Linux 2**                 | LTS                                   | x86_64, aarch64     |
| **CentOS**                         | 7.4+                                  | x86_64, aarch64     |
| **Debian**                         | 11, 12                                | x86_64, aarch64     |
| **Oracle Linux**                   | 7.4+, 8.1+, 9                         | x86_64              |
| **Red Hat Enterprise Linux (RHEL)**| 7.4+, 8.1+, 9.0+                      | x86_64, aarch64     |
| **Rocky Linux**                    | 8, 9                                  | x86_64, aarch64     |
| **SUSE Linux Enterprise Server (SLES)** | 12 SP5, 15 SP2                      | x86_64              |
| **Ubuntu**                         | 20.04 LTS, 22.04 LTS                  | x86_64, aarch64     |

---

## Supported Deployment Environments

The NGINX Agent supports deployment in the following environments:

- **Bare Metal** machines
- **Containers**
- **Public Cloud** platforms, including AWS, Google Cloud Platform, and Microsoft Azure
- **Virtual Machines**

---

## Supported NGINX Versions

The NGINX Agent is compatible with all supported releases of NGINX Open Source and NGINX Plus.

---

## Minimum System Requirements

Below are the recommended minimum system specifications for running the NGINX Agent:

| **Resource** | **Minimum Requirement** |
|--------------|--------------------------|
| **CPU**      | 1 CPU core              |
| **Memory**   | 1 GB RAM                |
| **Network**  | 1 GbE NIC               |
| **Storage**  | 20 GB                   |

---

## Logging

The NGINX Agent uses log files in standardized formats to collect metrics. As the number of log formats or instances grows, the size of these log files will increase correspondingly.

To avoid system storage constraints caused by expanding log directories, it is recommended to:

- Set up a **dedicated partition** for `/var/log/nginx-agent`.
- Enable **[log rotation](https://linux.die.net/man/8/logrotate)** to manage log file growth effectively.

For additional details on managing logs, refer to the [Configuration Overview]({{< relref "/agent/how-to/configuration-overview.md#logs" >}}).