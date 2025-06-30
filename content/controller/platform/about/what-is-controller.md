---
description: Overview of F5 NGINX Controller.
nd-docs: DOCS-781
title: Get to Know NGINX Controller
toc: true
weight: 100
type:
- concept
---

## Overview

F5 NGINX Controller is designed to let you manage and monitor your NGINX Plus instances. With NGINX Controller, it's easy to proactively configure, analyze, and respond to problems related to running and scaling NGINX-based web applications.

You can use NGINX Controller to do the following:

- Visualize and identify NGINX performance bottlenecks, overloaded servers, or potential DDoS attacks
- Configure NGINX using a graphical user interface
- Improve and optimize NGINX performance with intelligent advice and recommendations
- Get notified when something is wrong with the application infrastructure
- Plan web application capacity and performance
- Keep track of the systems running NGINX

## NGINX Controller Components

NGINX Controller includes the following key components:

- **NGINX Controller Server**

  The core server component, installed on your enterprise network. The NGINX Controller server encompasses scalable metrics collection infrastructure, a database, an analytics engine, and a [REST API]({{< ref "/controller/api/overview.md" >}}).

- **NGINX Controller User Interface**

 The web-based user interface compatible with all major browsers. The user interface is accessible only via TLS/SSL.

- **NGINX Controller Agent**

 The [Controller Agent]({{< ref "/controller/admin-guides/config-agent/about-controller-agent.md" >}}) is a Golang application that runs on monitored systems. All communications between the NGINX Controller Agent and NGINX Controller are done securely over SSL/TLS. The NGINX Controller Agent always initiates all traffic.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
