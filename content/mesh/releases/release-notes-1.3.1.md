---
title: Release Notes 1.3.1
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs). Lists of new features and known issues are provided.
weight: -1301
nd-docs: DOCS-717
type:
- reference
---

## NGINX Service Mesh Version 1.3.1

22 November 2021

<!-- vale off -->

This hotfix release resolves an issue affecting version 1.3.0 described below.

**Fix issue when upgrading from 1.2 to 1.3 (NSM-622)**:

Fixed an issue that would result in a failed upgrade from 1.2 to 1.3 if the original deployment used a custom upstream CA.
