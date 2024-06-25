---
description: ""
docs: DOCS-1247
doctypes:
  - task
tags:
  - docs
title: Build and Deploy Images
toc: true
weight: 300
---

## Overview

This guide provides step-by-step instructions for building and deploying F5 NGINX Management Suite images on different cloud providers. 

The deployment process has two stages: 

- Generate an image using Packer.
- Deploy the image using Terraform.

{{< call-out "tip" "Open-Source Project on GitHub" "fa-brands fa-github" >}}
The steps in this guide refer to the [NGINX Management Suite Infrastructure as Code (IAC)](https://github.com/nginxinc/nginx-management-suite-iac) project on GitHub.
{{< /call-out >}}

---

## Before you Begin

Before you start building and deploying images, make sure you:

- **Install Packer requirements**: Follow the instructions in the [NGINX Management Suite Image Generation](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements) README.
- **Install Terraform requirements**: Follow the instructions in the [NGINX Management Suite Image Deployment](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#Requirements) README.

---

## Packer

The Packer stage involves building the cloud image and installing NGINX Management Suite using an [Ansible role](https://github.com/nginxinc/ansible-role-nginx-management-suite). This image will be used later in the deployment stage.

### Generate the Image

To generate the image, follow the steps appropriate for your cloud deployment in the [NGINX Management Suite Image Generation](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/packer#how-to-use) README.


---

## Terraform

The Terraform stage involves deploying the cloud images created during the Packer stage. There are two types of deployment examples: Basic Reference Architecture and Standalone Architecture.

Ensure you've built the relevant images with Packer before continuing. For the Basic Reference Architecture, you'll need both NGINX Management Suite and NGINX images.


### Deploy Basic Reference Architecture Image

The Basic Reference Architecture deploys both the control plane (NGINX Management Suite) and data plane (NGINX Agent) using cloud best practices. It includes:

- Load balancers
- NGINX Management Suite and NGINX Agent instances in the private subnet

To deploy the Basic Reference Architecture, follow the steps in the [AWS NGINX Management Suite Basic Reference Architecture](https://github.com/nginxinc/nginx-management-suite-iac/blob/main/terraform/basic-reference/aws/README.md) README.

<br>

{{< img src="img/iac/aws-infrastructure.png" caption="Figure 1. AWS NGINX Management Suite basic reference architecture" alt="Diagram showing the AWS basic reference architecture. It includes an Amazon VPC with a Bastion/Jump Host in the public subnet. There is an admin accessing the VPC through an AWS Internet Gateway. The control plane consists of the NGINX Management Suite host behind an AWS Hoad Balancer in a private subnet. The data plane has the NGINX and NGINX Agent Host behind another AWS Load Balancer in a separate private subnet. Configuration Publisher and NGINX Clients interact with these components through designated ports.">}}

### Deploy Standalone Architecture Image

The Standalone Architecture deploys the control plane in isolation. This is not a best practice solution but can be used as a simple deployment option for multiple clouds. The standalone architecture includes:

- Control node in the VPC's public subnet
- Security groups to give restricted access

To deploy the Standalone Architecture, follow the steps for your infrastructure in the [How to Use](https://github.com/nginxinc/nginx-management-suite-iac/tree/main/terraform#how-to-use) section of the NGINX Management Suite Image Deployment README.

<br>

{{< img src="img/iac/standalone-architecture.png" caption="Figure 2. NGINX Management Suite standalone architecture" alt="Diagram showing the standalone architecture for NGINX Management Suite deployment. The image includes an Amazon VPC with a public subnet containing NGINX Management Suite deployed in an EC2 instance. The instance is secured with an ingress security group for ports 22 and 443. Users part of the security group access the instance through an AWS Internet Gateway.">}}

---

## Suggested Reading

- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)