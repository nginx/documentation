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

This glossary defines terms used in NGINX One and F5 Distributed Cloud.

## Namespace

In F5 Distributed Cloud, a namespace groups a tenant's configuration objects, similar to administrative domains. Every object within a namespace must have a unique name, and each namespace must be unique to its tenant. This setup ensures isolation, preventing cross-reference of objects between namespaces.

Related guide: [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)

## Tenant
A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is a fundamental concept for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be of two types: **individual** and **enterprise**, with the latter allowing multiple users with role-based access control (RBAC) roles.

Related guide: [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)