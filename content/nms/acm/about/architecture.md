---
description: Learn about the F5 NGINX Management Suite API Connectivity Manager architecture.
nd-docs: DOCS-892
title: Architecture Overview
toc: true
weight: 400
type:
- concept
---

{{< shortversions "1.0.0" "latest" "acmvers" >}}

## Overview

This topic provides an overview of the API Connectivity Manager architecture and personas.

---

## Terminology

This document introduces the following concepts.

### Topology

{{<bootstrap-table "table table-striped table-bordered">}}

| <div style="width:150px">Term</div> | Description                                                                                                                                                                                                                                                                              |
|-------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Management Plane                    | The management plane is an abstraction layer used to configure, monitor, and manage the layers of a network stack. API Connectivity Manager, a part of the management plane, establishes guardrails and configures rules for the data plane.                                             |
| Data Plane                          | [F5 NGINX Plus](https://www.f5.com/products/nginx/nginx-plus) instances in the traffic path that act as load balancers, API gateways, firewalls, ingress controllers, and caching systems.                                                            |
| Proxy Cluster                       | <p>NGINX is widely known as a reverse proxy, and a Proxy Cluster is a set of one or more NGINX Plus servers working together. A proxy cluster keeps configurations in sync across all instances and maintains data consistency by sharing the runtime state.</p><p>Examples:</p><ul><li>**API Gateway Cluster**: A cluster of one or more NGINX Plus instances acting as a single proxy for API requests.</li><li>**Dev Portal Cluster**: A cluster of one or more NGINX Plus instances configured to act as Developer Portals. Developer portals provide a framework for hosting API documentation, provisioning access keys, and managing approval workflows. In addition, you can test your APIs with the "Try It Out" feature.</li></ul>                                |

{{</bootstrap-table>}}

### Platform Services

API Connectivity Manager uses [NATS](https://nats.io) to communicate with the NGINX Management Suite platform services.

{{< include "nms/services/platform-services.md" >}}

---

## Architecture

The following diagram shows how API Connectivity Manager's components are organized and interact.

{{< call-out "note" >}}API Connectivity Manager takes an API-first approach: commands issued using the web interface are processed using the API Connectivity Manager REST API.
{{< /call-out >}}

{{<img src="/acm/about/acm-architecture-diagram.png" alt="API Connectivity Manager architecture" >}}

---

## Personas

### Infrastructure Admin

Infrastructure Admins, interacting primarily with the management plane, manage the infrastructure for hosts.

#### Routine tasks

- Configure SSO
- Provision the infrastructure
- Configure domain names
- Manage data plane hosts
- Manage certificates
- Enforce global/enterprise policies

### API Owner

API Owners oversee the API lifecycle, which they can maintain using a CI/CD pipeline.

The API Owner relies on the Infrastructure Admin to complete the initial configuration before beginning work.

#### Routine tasks

- Set up an API team
- On-board an API
- Configure policies to meet *Quality of Service (QoS)* commitments
- Select the API Gateway cluster for publishing an API
- Select the Dev Portal cluster for publishing API documentation

### Application Owner

Application Owners develop new digital experiences.

#### Routine tasks

- Learn about APIs and API contracts by reading the documentation on the Dev Portal.
- Test APIs using the "Try It Out" feature in the on-board documentation.
