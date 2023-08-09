---
title: "Overview"
date: 2023-07-20T14:44:12.320Z
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "Easily install NGINX Management Suite using our user-friendly Ansible role and explore feature-rich modules like Instance Manager, API Connectivity Manager, Application Delivery Manager, and Security Monitoring. Simplify your infrastructure management with our innovative Information as Code project, which lets you set up the control plane and data plane as a single solution."
# Assign weights in increments of 100
weight: 100
toc: true
tags: ["docs"]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1249"
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

{{< custom-styles >}}

## NGINX Management Suite Ansible Role

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/ansible-role-nginx-management-suite" target="_blank">Ansible NGINX Management Suite Role project on GitHub.</a> <i class="fa-regular fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{</call-out>}}


Use the NGINX Management Suite Ansible role to install NGINX Management Suite, which includes the following modules:

- [Instance Manager]({{< relref "/nms/about.md#instance-manager" >}})
- [API Connectivity Manager]({{< relref "/nms/about.md#api-connectivity-manager" >}})
- [Application Delivery Manager]({{< relref "/nms/about.md#app-delivery-manager" >}})
- [Security Monitoring]({{< relref "/nms/about.md#security-monitoring" >}})

Additionally, the ansible role installs NGINX (OSS or Plus) and [ClickHouse](https://clickhouse.com), both prerequisites for NGINX Management Suite.

To get started, you'll need:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md#download-cert-key" >}}).
- A host capable of running Ansible.

<br>

<i class="fa-regular fa-circle-info" style="color:#009639;"></i> [Learn more]({{< relref "./configuration.md" >}})

---

## NGINX Management Suite Infrastructure as Code


{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/nginx-management-suite-iac" target="_blank">NGINX Management Suite Infrastructure as Code project on GitHub.</a> <i class="fa-regular fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{< /call-out >}}


The Infrastructure as Code (IaC) project makes it easy to set up the control plane and data plane together as a single solution. As of now, we offer full coverage for Amazon Web Services (AWS), with more to come.

The IaC project requires the following:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md#download-cert-key" >}}).
- A trial or paid subscription for NGINX Management Suite. You can [sign up for NGINX Management Suite at MyF5](https://account.f5.com/myf5).
- A host capable of running Packer, Ansible, and Terraform.

{{< img src="img/iac/iac-process.png" caption="Figure 1. NGINX Management Suite's IaC build and deployment process" alt="Diagram showing the build and deployment process for NGINX Management Suite's Infrastructure as Code.">}}

<br>

<i class="fa-regular fa-circle-info" style="color:#009639;"></i> [Learn more]({{< relref "./build-and-deploy.md" >}})
