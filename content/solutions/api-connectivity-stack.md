---
description: This article explains how to download and install the products in the
  [F5 NGINX API Connectivity Stack](https://www.nginx.com/solutions/api-connectivity-stack/).
docs: DOCS-1442
tags:
- docs
title: Install the API Connectivity Stack
toc: true
weight: 200
---

## Overview
The API Connectivity Stack by F5 NGINX includes access to the following products:

- [F5 NGINX Plus as an API Gateway](https://www.f5.com/products/nginx/nginx-plus/api-gateway/)
- [F5 NGINX App Protect WAF and DoS](https://www.f5.com/products/nginx/nginx-app-protect/)
- [F5 NGINX Management Suite Instance Manager](https://www.f5.com/products/nginx/instance-manager/)
- [F5 NGINX Management Suite Security Monitoring]({{< ref "nms/security" >}})

## Installation Guide

### Install the Instance Manager module
NGINX Management Suite Instance Manager makes it easy to inventory, configure, monitor, and secure NGINX Open Source, NGINX Plus, and NGINX App Protect WAF instances.

1. [Download the products and distributions](https://my.f5.com/manage/s/downloads) you need from MyF5.
2. Choose your target deployment environment and follow the appropriate installation guide to setup NGINX Management Suite:
    - [Install on virtual machine or bare metal]({{< ref "/nms/installation/vm-bare-metal/_index.md" >}})
    - [Install in Kubernetes using Helm]({{< ref "/nms/installation/kubernetes/_index.md" >}})

### (Optional) Install the Security Monitoring module
NGINX Management Suite Security Monitoring provides global visibility into your fleet of NGINX App Protect WAF instances, including protection insights and the ability to analyze threats. Install this module if you plan to install NGINX App Protect WAF.

- [Install on virtual machine or bare metal]({{< ref "/nms/installation/vm-bare-metal/install-security-monitoring" >}})

{{< important >}}The Security Monitoring module is not supported in Kubernetes. The Kubernetes Helm chart does not support installing the Security Monitoring module.{{< /important >}}

### (Optional) Install the API Connectivity Manager module
NGINX Management Suite API Connectivity Manger makes it easy to manage, govern, and secure API gateways deployed across multi-cloud and hybrid environments. Install this module if you want  centralized management for your NGINX Plus API gateways.

- [Install on virtual machine or bare metal]({{< ref "/nms/acm/how-to/install-acm.md" >}})
- [Install in Kubernetes using Helm]({{< ref "/nms/acm/how-to/deploy-api-connectivity-manager.md" >}})

### Install NGINX Plus as an API Gateway
NGINX Plus can act as an API gateway for monolithic applications and microservices. It is the data plane that transports application traffic. Management plane tools like NGINX Management Suite API Connectivity Manager apply configurations to NGINX Plus instances.

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the instructions in the [NGINX Plus installation guide]({{< ref "installing-nginx-plus" >}}) to install it on a [supported operating system]({{< ref "nginx/technical-specs" >}})
3.	[Install and configure NGINX Agent]({{< ref "install-nginx-agent" >}}) on your NGINX Plus instance.

If you plan to use API Connectivity Manager to manage NGINX Plus as an API Gateway, refer to the instructions about [how to set up an API gateway environment]({{< ref "add-api-gateway" >}}).

### (Optional) Install NGINX App Protect WAF
NGINX App Protect WAF is a lightweight, platform-agnostic WAF that protects applications and APIs from layer 7 attacks. You can manage WAFs using the Instance Manager module and visualize them using the Security Monitoring module.

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the instructions in the [NGINX App Protect WAF installation guide]({{< ref "/nap-waf/v4/admin-guide/" >}}) for your Linux distribution.
3.  Follow the instructions in the [Security Monitoring installation guide]({{< ref "set-up-app-protect-instances">}}) to use App Protect WAF with NGINX Management Suite.

### (Optional) Install NGINX App Protect DoS
NGINX App Protect DoS provides comprehensive protection against Layer 7 denial-of-service attacks on your apps and APIs.

{{<note>}}The Instance Manager and Security Monitoring modules do not support App Protect DoS.{{</note>}}

1.	[Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2.	Follow the instructions in the [NGINX App Protect DoS installation guide]({{< ref "nap-dos/deployment-guide/learn-about-deployment" >}}) for your Linux distribution

## Next steps
Now that you’ve successfully deployed the API Connectivity Stack, use this free eBook to learn more about [deploying NGINX as an API gateway](https://www.nginx.com/resources/library/nginx-api-gateway-deployment/).
