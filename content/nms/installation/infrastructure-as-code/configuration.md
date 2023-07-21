---
title: "Install with Ansible"
date: 2023-07-20T14:44:12.320Z
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO.
# The description text appears in search results and at the top of the doc.
description: "The guide provides step-by-step instructions to install NGINX Management Suite using our open source ansible role. Easily reproduce your installation across many different environments throught automation."
# Assign weights in increments of 100
weight: 200
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

## {{<custom-styles>}}

---

{{< img src="img/iac/ansible-flow.png" caption="Figure 1. NGINX Management Suite Ansible Flow" alt="A diagram showing the install flow of the NGINX Management Suites Ansible role.">}}

### Prerequisites

- A host capable of running ansible.
- Ansible version >= 2.12.
- NGINX repository cert and key. [Follow these]({{< relref "../vm-bare-metal/prerequisites.md#download-cert-key" >}}) instructions to obtain them.

### Getting Started

Install the Ansible role using an ansible galaxy requirements file. For example:

```
collections:
  - name: nginxinc.nginx_core
roles:
  - name: ansible-role-nginx-management-suite
    version: 0.3.0
```

<br />
<br />

Create and run the ansible playbook. For example:

```
- hosts: nms
  become: yes
  vars:
    nginx_license:
      certificate: ./nginx-repo.crt
      key: ./nginx-repo.key
    nms_setup: install
    nms_modules:
      - name: acm
      - name: adm
      - name: sm
  collections:
    - nginxinc.nginx_core
  roles:
    - ansible-role-nginx-management-suite
```

<br />
<br />

{{<note>}}The entire list of configuration options can be seen [here](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/defaults/main.yml){{</note>}}

### Getting support

Access the support network via the [github Ansible role project](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/SUPPORT.md).
