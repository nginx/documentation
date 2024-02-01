---
title: "NGINX One glossary"
date: 2024-01-24T11:55:26-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 1000
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

The NGINX One glossary is a short dictionary of terminology used by NGINX One and F5 Distributed Cloud.

## Namespace

In the context of F5 Distributed Cloud, namespaces group a tenant’s configuration objects and can be thought of as administrative domains. All objects of the same kind must have unique names within a given namespace, and the namespaces themselves must be unique within a tenant. Namespaces provide isolation within a tenant, ensuring objects in one namespace cannot be referred to by another.

Related guide: [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)

## Tenant
A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is a fundamental concept for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be of two types: **individual** and **enterprise**, with the latter allowing multiple users with role-based access control (RBAC) roles.

Related guide: [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)