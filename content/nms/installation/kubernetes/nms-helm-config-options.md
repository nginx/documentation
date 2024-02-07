---
title: "Configurable Helm Settings"
date: 2023-01-17T10:47:56-08:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "This reference guide lists the configurable Helm chart parameters and default settings for the NGINX Management Suite platform and modules."
# Assign weights in increments of 100
weight: 90
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1112"
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

{{< shortversions "2.5.0" "latest" "nimvers" >}}

## NGINX Management Suite Helm Chart Settings {#nms-helm-settings}

{{< include "installation/helm/nim/configuration-options.md" >}}

---

## API Connectivity Manager Helm Chart Settings {#acm-helm-settings}

{{< include "installation/helm/acm/configuration-options.md" >}}

---