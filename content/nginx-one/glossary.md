---
description: ''
docs: DOCS-1396
doctypes:
- reference
tags:
- docs
title: Glossary
toc: true
weight: 1000
---

This glossary defines terms used in the F5 NGINX One and F5 Distributed Cloud.


{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Data Plane** | The data plane is the part of a network architecture that carries user traffic. It handles tasks like forwarding data packets between devices and managing network communication. In the context of NGINX, the data plane is responsible for tasks such as load balancing, caching, and serving web content. |
| **Namespace** | In F5 Distributed Cloud, a namespace groups a tenant’s configuration objects, similar to administrative domains. Every object in a namespace must have a unique name, and each namespace must be unique to its tenant. This setup ensures isolation, preventing cross-referencing of objects between namespaces. |
| **Tenant** | A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is fundamental for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be either individual or enterprise, with the latter allowing multiple users with role-based access control (RBAC). |
{{</bootstrap-table>}}

---

## References

- [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)