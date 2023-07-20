---
title: "Overview"
date: 2023-07-20T14:44:12.320Z
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "This section aims to help you get started with NMS as quickly as possible. We have created two open source repositories to help the installation process of Bare Metal/Virtual machines."
# Assign weights in increments of 100
weight: 100
toc: true
tags: ["docs"]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "security"]
doctypes: ["task"]
journeys:
  ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

1. [NMS Ansible Role](https://github.com/nginxinc/ansible-role-nginx-management-suite)
2. [NMS Infrastructure as Code](https://github.com/nginxinc/nginx-management-suite-iac)

---

### NMS Ansible Role

This Ansible role can install NGINX Management Suite which includes the following modules:

- Instance Manager
- API Connectivity Manager
- Application Delivery Manager
- Security Monitoring

In addition the role will install NGINX (OSS or Plus) and Clickhouse.

- NGINX repository cert and key. [Follow these]({{< relref "../vm-bare-metal/prerequisites.md#download-cert-key" >}}) instructions to obtain them.
- A host capable of running Ansible.

[Learn More]({{< relref "./configuration.md" >}})

---

### NGINX Management Suite Infrastructure as Code

The IaC project aims to setup both control-plane and data-plane in one solution. We currently have full coverage for AWS with more to come. The IaC project currently requires

- NGINX repository cert and key. [Follow these]({{< relref "../vm-bare-metal/prerequisites.md#download-cert-key" >}}) instructions to obtain them.
- A trial or paid subscription for NGINX Management Suite. [Sign up for NGINX Management Suite at MyF5](https://account.f5.com/myf5).
- A host capable of running Packer, Ansible and Terraform.

{{< img src="img/iac/iac-process.svg" caption="Figure 1. NGINX Management Suite IaC Process" alt="A diagram showing the architecture of the NGINX Management Suites Infrastructure as Code build and deploy process.">}}

[Learn More]({{< relref "./build-and-deploy.md" >}})
