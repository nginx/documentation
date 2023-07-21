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

{{< img src="img/iac/ansible-flow.png" caption="Figure 1. NGINX Management Suite Ansible Flow" alt="A diagram showing the install flow of the NGINX Management Suites Ansible role.">}}

### Requirements

See [the Ansible role requirements here.](https://github.com/nginxinc/ansible-role-nginx-management-suite#requirements)

### Getting Started

1. Install the Ansible role using an ansible galaxy requirements file. Follow the Installation steps [here](https://github.com/nginxinc/ansible-role-nginx-management-suite#installation).

2. The next step is to run the ansible playbook. Create a file similar to the following named "nms-playbook.yml" or similar.

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

3. Create an [Ansible hosts file](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) containing the hosts you want in the group listed in your playbook.

4. Run the playbook.

```
ansible-playbook -i <path-to-your-hostfile> nms-playbook.yml
```

<br />
<br />

{{<note>}}The entire list of configuration options can be seen [here](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/defaults/main.yml){{</note>}}

### Getting support

Get support from the [github Ansible role project](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/SUPPORT.md).
