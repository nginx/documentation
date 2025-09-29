---
title: "Technical specifications"
weight: 100
toc: true
nd-docs: DOCS-1092
nd-content-type: how-to
---

This document describes the requirements for NGINX Agent version 2.

This document provides technical specifications for NGINX Agent. It includes information on supported distributions, deployment environments, NGINX versions, sizing recommendations, and logging.

## NGINX Agent 3.0 Compatibility

| NGINX Product                | Agent Version  |
|------------------------------|----------------|
| **NGINX One Console**        | 3.x            |
| **NGINX Gateway Fabric**     | 3.x            |
| **NGINX Plus**               | 2.x, 3.x       |
| **NGINX Ingress Controller** | 2.x, 3.x       |
| **NGINX Instance Manager**   | 2.x            |

## Supported Distributions

NGINX Agent can run in most environments. We support the following distributions:

| | AlmaLinux | Alpine Linux | Amazon Linux | Amazon Linux 2| Debian |
|-|-----------|--------------|--------------|----------------|--------|
|**Version**|8 <br><hr>9 <br><hr>10|  3.19<br><hr>3.20<br><hr> 3.21<br><hr> 3.22|  2023|  LTS|  11<br><hr> 12|
|**Architecture**| x86_84<br><hr>aarch64| x86_64<br><hr>aarch64 | x86_64<br><hr>aarch64 | x86_64<br><hr>aarch64 | x86_64<br><hr>aarch64 | x86_64<br><hr>aarch64 |

| |FreeBSD | Oracle Linux | Red Hat <br>Enterprise Linux <br>(RHEL) | Rocky Linux | SUSE Linux <br>Enterprise Server <br>(SLES) | Ubuntu |
|-|--------|--------------|---------------------------------|-------------|-------------------------------------|--------|
|**Version**|13<br><hr>14|8.1+<br><hr>9<br><hr>10|8.1+<br><hr>9.0+<br><hr>10|8<br><hr>9<br><hr>10|15 SP2|22.04 LTS<br><hr>24.04 LTS<br><hr>25.04 LTS|
|**Architecture**|amd64|x86_64|x86_64<br><hr>aarch64|x86_64<br><hr>aarch64|x86_64|x86_64<br><hr>aarch64|


## Supported deployment environments

NGINX Agent can be deployed in the following environments:

- Bare Metal
- Container
- Public Cloud: AWS, Google Cloud Platform, and Microsoft Azure
- Virtual Machine

## Supported NGINX versions

NGINX Agent works with all supported versions of NGINX Open Source and NGINX Plus.


## Sizing recommendations

Minimum system sizing recommendations for NGINX Agent:

| CPU        | Memory   | Network   | Storage |
|------------|----------|-----------|---------|
| 1 CPU core | 1 GB RAM | 1 GbE NIC | 20 GB   |

## Logging

NGINX Agent utilizes log files and formats to collect metrics. Increasing the log formats and instance counts will result in increased log file sizes. To prevent system storage issues due to a growing log directory, it is recommended to add a separate partition for `/var/log/nginx-agent` and enable [log rotation](http://nginx.org/en/docs/control.html#logs).