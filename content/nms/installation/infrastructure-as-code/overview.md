---
description: Easily install NGINX Management Suite using our user-friendly Ansible
  role and explore feature-rich modules like Instance Manager and Security Monitoring. Simplify your infrastructure
  management with our innovative Information as Code project, which lets you set up
  the control plane and data plane as a single solution.
docs: DOCS-1249
doctypes:
- task
tags:
- docs
title: Overview
toc: true
weight: 100
---

## NGINX Management Suite Ansible Role

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/ansible-role-nginx-management-suite" target="_blank">Ansible NGINX Management Suite Role project on GitHub.</a> <i class="fa-solid fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{</call-out>}}


Use the NGINX Management Suite Ansible role to install NGINX Management Suite, which includes the following modules:

- [Instance Manager]({{< relref "/nms/about.md#instance-manager" >}})
- [Security Monitoring]({{< relref "/nms/about.md#security-monitoring" >}})

Additionally, the ansible role installs NGINX (OSS or Plus) and [ClickHouse](https://clickhouse.com), both prerequisites for NGINX Management Suite.

To get started, you'll need:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md#download-cert-key" >}}).
- A host capable of running Ansible.

<br>

<i class="fa-solid fa-circle-info" style="color:#009639;"></i> [Learn more]({{< relref "./configuration.md" >}})

---

## NGINX Management Suite Infrastructure as Code


{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/nginx-management-suite-iac" target="_blank">NGINX Management Suite Infrastructure as Code project on GitHub.</a> <i class="fa-solid fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{< /call-out >}}


The Infrastructure as Code (IaC) project makes it easy to set up the control plane and data plane together as a single solution. As of now, we offer full coverage for Amazon Web Services (AWS), with more to come.

The IaC project requires the following:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md#download-cert-key" >}}).
- A trial or paid subscription for NGINX Management Suite. You can [sign up for NGINX Management Suite at MyF5](https://account.f5.com/myf5).
- A host capable of running Packer, Ansible, and Terraform.

{{< img src="img/iac/iac-process.png" caption="Figure 1. NGINX Management Suite's IaC build and deployment process" alt="Diagram showing the build and deployment process for NGINX Management Suite's Infrastructure as Code.">}}

<br>

<i class="fa-solid fa-circle-info" style="color:#009639;"></i> [Learn more]({{< relref "./build-and-deploy.md" >}})
