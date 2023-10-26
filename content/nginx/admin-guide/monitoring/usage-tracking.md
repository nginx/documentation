---
title: "Tracking NGINX Plus Deployments and Usage"
date: 2023-10-26T10:27:57-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to configure your environment for tracking your NGINX Plus instances and reporting usage metrics to F5."
# Assign weights in increments of 100
weight: 600
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
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

{{< custom-styles >}}

## Overview

This guide will help you configure your NGINX environment for tracking and reporting to F5. It covers two key scenarios:

- Tracking and reporting NGINX Plus instances using NGINX Management Suite's Instance Manager.
- Tracking NGINX Ingress Controller and Kubernetes Stack deployments.


## Tracking NGINX Plus and NGINX App Protect Deployments

For commercial plans like the Flexible Consumption Program, it's a requirement to set up Instance Manager to monitor and report your usage of F5 NGINX products. The setup process involves three key steps:

1. Install Instance Manager.
2. Configure your NGINX Plus products to report their data to Instance Manager.
3. Use Instance Manager to send the usage data to F5.

Applying a JSON Web Token license to Instance Manager, which you can obtain from MyF5, allows you to automate the third step. Once the license is applied, you have the option to send usage reports to F5 either automatically or on-demand.


### Install NGINX Instance Manager on a dedicated host

### Install NGINX Agent on each NGINX Plus instance

### Configure NGINX Plus to report to Instance Manager

### View and track your NGINX Plus instances

## Tracking NGINX Ingress Controller and Kubernetes Stack Deployments

## Reporting NGINX Product Usage to F5
