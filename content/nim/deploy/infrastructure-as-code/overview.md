---
docs: DOCS-1249
title: Overview
toc: true
weight: 100
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

Use our user-friendly Ansible role to easily install NGINX Instance Manager. The role also installs NGINX (OSS or Plus) and [ClickHouse](https://clickhouse.com), both of which are required for NGINX Instance Manager. Simplify your infrastructure management with our innovative Infrastructure as Code project, which enables you to set up the control plane and data plane as a unified solution.

## NGINX Instance Manager Ansible role

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/ansible-role-nginx-management-suite" target="_blank">Ansible NGINX Instance Manager Role project on GitHub.</a> <i class="fa-solid fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{</ call-out >}}

To get started, you’ll need:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nim/deploy/vm-bare-metal/install.md#download-cert-key" >}}).
- A host capable of running Ansible.

<br>

For more information, see [Install with Ansible]({{< relref "./configuration.md" >}}).

---

## NGINX Instance Manager Infrastructure as Code

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/nginx-management-suite-iac" target="_blank">NGINX Instance Manager Infrastructure as Code project on GitHub.</a> <i class="fa-solid fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{< / call-out >}}

The Infrastructure as Code (IaC) project makes it easy to set up the control plane and data plane together as a single solution. As of now, we offer full coverage for Amazon Web Services (AWS), with more to come.

The IaC project requires the following:

- An NGINX repository certificate and key. For instructions on how to download them, click [here]({{< relref "/nim/deploy/vm-bare-metal/install.md#download-cert-key" >}}).
- A trial or paid subscription for NGINX Instance Manager. You can [sign up for NGINX Instance Manager at MyF5](https://account.f5.com/myf5).
- A host capable of running Packer, Ansible, and Terraform.

{{< img src="img/iac/iac-process.png" caption="Figure 1. NGINX Instance Manager's IaC build and deployment process" alt="Diagram showing the build and deployment process for infrastructure using Ansible and Packer for build and publish, and Terraform for deployment. Supported platforms include Azure, AWS, Google Cloud, and VMware.”">}}

<br>

For more information, see [Build and deploy images]({{< relref "./build-and-deploy.md" >}}).
