---
description: ''
docs: DOCS-1396
doctypes:
- reference
tags:
- docs
title: NGINX One glossary
toc: true
weight: 1000
---

This glossary defines terms used in NGINX One and F5 Distributed Cloud.

<i class="fas fa-book"></i> Related guide: [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)

## Namespace

In F5 Distributed Cloud, a namespace groups a tenant's configuration objects, similar to administrative domains. Every object within a namespace must have a unique name, and each namespace must be unique to its tenant. This setup ensures isolation, preventing cross-reference of objects between namespaces.

## Tenant
A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is a fundamental concept for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be of two types: **individual** and **enterprise**, with the latter allowing multiple users with role-based access control (RBAC) roles.

