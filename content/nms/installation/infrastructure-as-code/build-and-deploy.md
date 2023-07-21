---
title: "Build and deploy images"
date: 2023-07-20T14:44:12.320Z
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "This guide shows you where to find the step-by-step instructions to build and deploy NGINX Management Suite images on various cloud providers."
# Assign weights in increments of 100
weight: 300
toc: true
tags: ["docs"]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOC-21"
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

---

### Packer

#### Overview

The Packer stage builds the cloud image and installs NMS using the ansible role for later consumption in the deployment stage.

#### Requirements

See [the requirements here.](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements)

#### Getting Started

To get started, follow the [appropriate packer guide for your cloud.](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#how-to-use)

---

### Terraform

#### Overview

The Terraform stage deploys the cloud images built during the Packer stage. There are two kinds of deployment examples.

1. Basic Reference Architecture which will deploy both control-plane and data-plane using cloud best practices.
2. Standalone Architecture which will deploy the control plane in isolation. _This is not a best practice solution_ but can be used as a simple deployment available for multiple clouds.

#### Requirements

See [the requirements here.](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements)

#### Getting Started

To get started with the basic reference architecture and deploy the following infrastructure, use the [AWS guide.](https://github.com/nginxinc/nginx-management-suite-iac/blob/main/terraform/basic-reference/aws/README.md)

{{< img src="img/iac/aws-infrastructure.png" caption="Figure 1. AWS NGINX Management Suite basic reference architecture" alt="A diagram the AWS basic reference architecture.">}}
