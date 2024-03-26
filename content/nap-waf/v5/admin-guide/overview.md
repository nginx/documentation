---
description: This guide explains how to deploy NGINX App Protect WAF v5.
docs: DOCS-1362
doctypes:
- task
title: NGINX App Protect WAF Administration Guide
toc: true
versions:
- "5.0"
weight: 100
---

## Introduction

NGINX App Protect WAF v5, designed for NGINX Open Source and NGINX Plus environments, offers advanced Web Application Firewall (WAF) capabilities, supporting all features of [NGINX App Protect WAF v4]({{< relref "/nap-waf/v4/admin-guide/install.md" >}}). This solution, available at an additional cost, consists of a dynamic NGINX module and containerized WAF services, providing robust security and scalability.

### Key Advantages

- Ability to work with NGINX Open Source in addition to NGINX Plus.
- Scalable architecture, ideal for both small and large-scale deployments.
- Seamless integration with existing DevOps and SecOps workflows.

### Use Case Scenarios

- E-Commerce Platform: Securing transactional data and user information in a high-traffic environment.
- API Protection: Offering robust security for API gateways against common vulnerabilities.
- DevOps Environments: Integrating WAF into continuous integration and delivery pipelines to ensure security is a part of the development lifecycle.

### Technical Requirements

- Basic understanding of NGINX and containerization concepts.
- Software prerequisites include Docker or Kubernetes, depending on the chosen deployment method.

## Deployment Types

NGINX App Protect WAF v5 supports a range of deployment scenarios to meet various operational needs:

1. [Docker Compose Deployment]({{< relref "/nap-waf/v5/admin-guide/deploy-on-docker.md" >}})
   - Deploys both NGINX and WAF components within containers.
   - Suitable for environments across development, testing, and production stages.

2. [Kubernetes Deployment]({{< relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md" >}})
   - Integrates both NGINX and WAF components in a single pod.
   - Ideal for scalable, cloud-native environments.

3. [NGINX on Host/VM with Containerized WAF]({{< relref "/nap-waf/v5/admin-guide/install.md" >}})
   - NGINX is operated directly on the host system or a virtual machine, with WAF components deployed in containers.
   - Perfect for situations where NGINX is already in use on host systems, allowing for the addition of WAF components without disrupting the existing NGINX setup.

## NGINX App Protect WAF Compiler

NGINX App Protect WAF v5 enhances deployment speed through the pre-compilation of security policies and logging profiles into bundle files.

Use the [NGINX App Protect WAF Compiler]({{< relref "/nap-waf/v5/admin-guide/compiler.md" >}}) to transform security policies and logging profiles from JSON format into a consumable bundle files.

## Troubleshooting and FAQs

See common deployment challenges and solutions to ensure a smooth setup process in the [Troubleshooting Guide]({{< relref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md#nginx-app-protect-5" >}}).

Docker images for NGINX App Protect WAF v5 are built using Ubuntu 22.04 (Jammy) binaries.
