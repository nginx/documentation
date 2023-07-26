---
title: "Build and Deploy Images"
date: 2023-07-20T14:44:12.320Z
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "This guide points you to step-by-step instructions for building and deploying NGINX Management Suite images on different cloud providers."
# Assign weights in increments of 100
weight: 300
toc: true
tags: ["docs"]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1247"
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

{{<custom-styles>}}

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/nginx-management-suite-iac" target="_blank">NGINX Management Suite Infrastructure as Code project on GitHub.</a> <i class="fa-regular fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{< /call-out >}}

---

## Packer

The Packer stage involves building the cloud image and installing NGINX Management Suite using the [Ansible role](https://github.com/nginxinc/ansible-role-nginx-management-suite) for later use in the deployment stage.

### Requirements

- To view the Packer requirements, click [here](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements).

### Getting Started

- To get started, follow the [appropriate Packer guide for your cloud deployment](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#how-to-use).

---

## Terraform

The Terraform stage deploys the cloud images built during the Packer stage. There are two kinds of deployment examples.

1. Basic Reference Architecture: This deploys both the control plane and data plane using cloud best practices.
2. Standalone Architecture: This deploys the control plane in isolation. Although **this is not a best practice solution**, it can be used as a simple deployment option for multiple clouds.

### Requirements

- Before proceeding, ensure you have built the relevant images in [Packer]({{< ref "#packer" >}}). For the basic reference Architecture, you will need both NGINX Management Suite and NGINX images.
- For more details about the Terraform requirements, click [here](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/terraform#Requirements).

---

### Getting Started

Get started with the basic reference architecture and deploy the following infrastructure by following the steps in the [AWS NGINX Management Suite Basic Reference Architecture](https://github.com/nginxinc/nginx-management-suite-iac/blob/main/terraform/basic-reference/aws/README.md) guide.

{{< img src="img/iac/aws-infrastructure.png" caption="Figure 1. AWS NGINX Management Suite basic reference architecture" alt="A diagram of the AWS basic reference architecture.">}}

---

## Suggested Reading

- [Teraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)
