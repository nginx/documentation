---
description: Learn how to download and install the products in the NGINX Open Source
  Subscription.
docs: DOCS-1443
tags:
- docs
title: Install NGINX Open Source Subscription
toc: true
weight: 300
build:
  list: never
  publishResources: true
  render: always
---

## Overview
The Open Source Subscription bundle by F5 NGINX provides access to the following products:

- [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus)
- [NGINX Management Suite Instance Manager](https://www.nginx.com/products/nginx-management-suite/instance-manager/)
- [NGINX App Protect WAF and DoS](https://www.nginx.com/products/nginx-app-protect/)

It also includes commercial support for:

- [NGINX Open Source](https://www.nginx.org)
- [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus)
- [NGINX Management Suite Instance Manager](https://www.nginx.com/products/nginx-management-suite/instance-manager/)
- [NGINX App Protect WAF and DoS](https://www.nginx.com/products/nginx-app-protect/)

## Installation Guide

### Install NGINX Open Source
NGINX is the only all-in-one software web server, load balancer, reverse proxy, content cache, and API gateway.

- Download the NGINX Open Source packages for one of the supported operating systems from [NGINX Linux Packages](https://nginx.org/en/linux_packages.html).
- Follow the instructions to [install NGINX Open Source]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md" >}}).
- Alternatively, if you prefer to build NGINX from source, see [Build NGINX from source]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-open-source.md#compiling-and-installing-from-source" >}}).

### Install NGINX Plus
NGINX Plus is built on top of NGINX open source and adds enterprise‑grade features such as high availability, active health checks, DNS system discovery, session persistence, a RESTful API, and many more.

1. [Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2. Follow the instructions in the [NGINX Plus installation guide]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) to install it on a [supported operating system]({{< relref "/nginx/technical-specs.md" >}}).
3. [Install and configure NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on your NGINX Plus instance.

### Install the Instance Manager module
NGINX Management Suite Instance Manager makes it easy to inventory, configure, monitor, and secure NGINX Open Source, NGINX Plus, and NGINX App Protect WAF instances.

1. [Download the products and distributions](https://my.f5.com/manage/s/downloads) you need from MyF5.
2. Choose your target deployment environment and follow the appropriate installation guide to setup NGINX Management Suite:
    - [Install on virtual machine or bare metal]({{< relref "/nms/installation/vm-bare-metal/" >}})
    - [Install in Kubernetes using Helm]({{< relref "/nms/installation/kubernetes/" >}})

### (Optional) Install NGINX App Protect WAF
NGINX App Protect WAF is a lightweight, platform-agnostic WAF that protects applications and APIs from layer 7 attacks. You can manage WAFs using the Instance Manager module and visualize them using the Security Monitoring module.

1. [Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2. Follow the instructions in the [NGINX App Protect WAF installation guide]({{< relref "/nap-waf/v4/admin-guide/install.md" >}}) for your Linux distribution.
3. Follow the instructions in the [Security Monitoring installation guide]({{< relref "/nms/security/how-to/set-up-app-protect-instances.md">}}) to use App Protect WAF with NGINX Management Suite.

{{<note>}}NGINX App Protect WAF can only be deployed on NGINX Plus.{{</note>}}.

### (Optional) Install NGINX App Protect DoS
NGINX App Protect DoS provides comprehensive protection against Layer 7 denial-of-service attacks on your apps and APIs.

{{<note>}}The Instance Manager and Security Monitoring modules do not support App Protect DoS.{{</note>}}

1. [Download your credentials from MyF5](https://my.f5.com/), including your NGINX Plus Certificate and public key (`nginx-repo.crt` and `nginx-repo.key`).
2. Follow the instructions in the [NGINX App Protect DoS installation guide]({{< relref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}) for your Linux distribution.

Note that NGINX App Protect WAF can only be deployed on NGINX Plus.

### Next Steps
Now that you've successfully installed NGINX, use [The Complete NGINX Cookbook](https://www.nginx.com/resources/library/complete-nginx-cookbook) to find sample NGINX configurations for load balancing, cloud deployment, automation, containers, microservices, security, and more.
