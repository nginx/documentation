---
title: Release Notes 1.4.1
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs).  Lists of new features and known issues are provided.
weight: -1401
nd-docs: DOCS-1484
type:
- reference
---

## NGINX Service Mesh Version 1.4.1

26 May 2022

This hotfix release enhances previous versions as described below.

**Egress upstream should be resilient**:

Ability to send egress traffic to a pool of NGINX Ingress Controller endpoints. This applies to a single NGINX Ingress Controller deployment with multiple replicas, not multiple NGINX Ingress Controller deployments.
