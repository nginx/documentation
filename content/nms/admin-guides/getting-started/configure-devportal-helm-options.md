---
title: "Deployment Options for Developer Portal Helm"
date: 2022-12-01T16:42:57-08:00
# Change draft status to false to publish doc.
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This guide lists and describes the parameters you can set when deploying the Developer Portal from a Helm chart. "
# Assign weights in increments of 100
weight: 120
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1171"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{<custom-styles>}}



{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Default Developer Portal Helm Settings {#default-devportal-helm-settings}

This topic lists the default values that are used when [installing the Developer Portal from a Helm chart]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}}). You can change these values to meet your specific needs.

{{< include "admin-guides/installation/helm/acm/dev-portal-helm-configurations/configuration-options.md" >}}

---

## Common Deployment Configurations {#common-deployment-configs}

### Deploy Developer Portal with an SQLite database

{{< include "admin-guides/installation/helm/acm/dev-portal-helm-configurations/configure-helm-devportal-sqlite.md" >}}

### Deploy Developer Portal with an embedded PostgreSQL database

{{< include "admin-guides/installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-embedded-postgres.md" >}}

### Deploy Developer Portal with an external PostgreSQL database

{{< include "admin-guides/installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-external-postgres.md" >}}

### Deploy Developer Portal using TLS for the backend API service

{{< include "admin-guides/installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-api-mtls.md" >}}
