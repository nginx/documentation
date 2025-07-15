---
nd-docs: DOCS-1247
title: Build and deploy images
toc: true
weight: 300
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide provides step-by-step instructions for building and deploying F5 NGINX Instance Manager images on different cloud providers.

The deployment process has two stages:

- Generate an image using Packer.
- Deploy the image using Terraform.

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the [NGINX Instance Manager Infrastructure as Code (IAC)](https://github.com/nginxinc/nginx-management-suite-iac) project on GitHub.
{{< /call-out >}}

---

## Before you begin

Before you start building and deploying images, ensure you:

- **Install Packer requirements**: Follow the instructions in the [NGINX Instance Manager Image Generation](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements) README.
- **Install Terraform requirements**: Follow the instructions in the [NGINX Instance Manager Image Deployment](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements) README.

---

## Packer

The Packer stage involves building the cloud image and installing NGINX Instance Manager using an [Ansible role](https://github.com/nginxinc/ansible-role-nginx-management-suite). This image will be used later in the deployment stage.

### Generate the image

To generate the image, follow the steps appropriate for your cloud deployment in the [NGINX Instance Manager Image Generation](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#how-to-use) README.

---

## Terraform

The Terraform stage involves deploying the cloud images created during the Packer stage. There are two types of deployment examples: Basic Reference Architecture and Standalone Architecture.

Ensure you've built the relevant images with Packer before continuing. For the Basic Reference Architecture, you'll need both NGINX Instance Manager and NGINX images.

### Deploy basic reference architecture image

The Basic Reference Architecture deploys both the control plane (NGINX Instance Manager) and data plane (NGINX Agent) using cloud best practices. It includes:

- Load balancers
- NGINX Instance Manager and NGINX Agent instances in the private subnet

To deploy the Basic Reference Architecture, follow the steps in the [AWS NGINX Instance Manager Basic Reference Architecture](https://github.com/nginxinc/nginx-management-suite-iac/blob/main/terraform/basic-reference/aws/README.md) README.

<br>

{{< img src="img/iac/aws-infrastructure.png" caption="Figure 1. AWS NGINX Instance Manager basic reference architecture" alt="Diagram showing the AWS basic reference architecture with an Amazon VPC, load balancers, and NGINX Instance Manager components in private subnets." >}}

### Deploy standalone architecture image

The Standalone Architecture deploys the control plane in isolation. This is not a best practice solution but can be used as a simple deployment option for multiple clouds. The standalone architecture includes:

- Control node in the VPC's public subnet
- Security groups to give restricted access

To deploy the Standalone Architecture, follow the steps for your infrastructure in the [How to Use](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/terraform#how-to-use) section of the NGINX Instance Manager Image Deployment README.

<br>

{{< img src="img/iac/standalone-architecture.png" caption="Figure 2. NGINX Instance Manager standalone architecture" alt="Diagram showing the standalone architecture for NGINX Instance Manager deployment, featuring an Amazon VPC and a public subnet with NGINX Instance Manager in an EC2 instance secured by a security group." >}}

---

## Suggested reading

- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)