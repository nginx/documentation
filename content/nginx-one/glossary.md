---
description: ''
nd-docs: DOCS-1396
title: Glossary
toc: true
weight: 1000
nd-content-type: reference
---

This glossary defines terms used in the F5 NGINX One Console and F5 Distributed Cloud.

## General terms

{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Config Sync Group** | A group of NGINX systems (or instances) with identical configurations. They may also share the same certificates. However, the instances in a Config Sync Group could belong to different systems and even different clusters. For more information, see this explanation of [Important considerations]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md#important-considerations" >}}) |
| **Control Plane** | The control plane is the part of a network architecture that manages and controls the flow or data or traffic (the Data Plane). It is responsible for system-level tasks such as routing and traffic management. |
| **Data Plane** | The data plane is the part of a network architecture that carries user traffic. It handles tasks like forwarding data packets between devices and managing network communication. In the context of NGINX, the data plane is responsible for tasks such as load balancing, caching, and serving web content. |
| **Instance** | An instance is an individual system with NGINX installed. You can group the instances of your choice in a Config Sync Group. When you add an instance to NGINX One, you need to use a data plane key. |
| **Namespace** | In F5 Distributed Cloud, a namespace groups a tenant’s configuration objects, similar to administrative domains. Every object in a namespace must have a unique name, and each namespace must be unique to its tenant. This setup ensures isolation, preventing cross-referencing of objects between namespaces. You'll see the namespace in the NGINX One Console URL as `/namespaces/<namespace name>/` |
| **NGINX Agent**                      | A lightweight software component installed on NGINX instances to enable communication with the NGINX One console.                                      |
| **Staged Configurations** | Also known as **Staged Configs**. Allows you to save "work in progress." You can create it from scratch, an Instance, another Staged Config, or a Config Sync Group. It does _not_ have to be a working configuration until you publish it to an instance or a Config Sync Group. You can even manage your **Staged Configurations** through our [API]({{< ref "/nginx-one/api/api-reference-guide/#tag/StagedConfigs" >}}). |
| **Tenant** | A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is fundamental for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be either individual or enterprise, with the latter allowing multiple users with role-based access control (RBAC). |
{{</bootstrap-table>}}

## NGINX App Protect WAF terminology

{{< include "nap-waf/config/common/nginx-app-protect-waf-terminology.md" >}}

## Legal notice: Licensing agreements for NGINX products

Using NGINX One is subject to our End User Service Agreement (EUSA). For [NGINX Plus]({{< ref "/nginx" >}}), usage is governed by the End User License Agreement (EULA). Open source projects, including [NGINX Agent](https://github.com/nginx/agent) and [NGINX Open Source](https://github.com/nginx/nginx), are covered under their respective licenses. For more details on these licenses, follow the provided links.

---

## References

- [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)
