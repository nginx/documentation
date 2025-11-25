---
nd-docs: DOCS-1248
title: Install with Ansible
toc: true
weight: 200
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Introduction

This guide explains how to install F5 NGINX Instance Manager using the open-source Ansible role.

With Ansible, you can automate and replicate your installation across multiple environments.

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the [Ansible NGINX Instance Manager Role](https://github.com/nginxinc/ansible-role-nginx-management-suite) project on GitHub.
{{< /call-out >}}

---

## Overview

The Ansible role for NGINX Instance Manager simplifies the installation process by installing all the prerequisites and any modules you specify.

{{< img src="img/iac/ansible-flow.png" caption="Figure 1. NGINX Instance Manager Ansible flow" alt="A diagram showing the installation flow of the NGINX Instance Manager Ansible role, with four steps: installing NGINX, installing ClickHouse, adding the NGINX Instance Manager repository, and installing the NGINX Instance Manager module(s).">}}

---

## System requirements

- The Ansible role requirements can be viewed [on GitHub](https://github.com/nginxinc/ansible-role-nginx-management-suite#requirements).

---

## Installation steps

1. Install Ansible by following the [installation steps on GitHub](https://github.com/nginxinc/ansible-role-nginx-management-suite?tab=readme-ov-file#ansible).
2. Create the inventory file with the details of the host you want to install NGINX Instance Manager on. Make sure you have access to the host. [Example here](https://github.com/nginxinc/ansible-role-nginx-management-suite?tab=readme-ov-file#create-inventory-file).
3. Create the requirements file and install the required Ansible role by following [these steps](https://github.com/nginxinc/ansible-role-nginx-management-suite?tab=readme-ov-file#install-required-roles-and-collections).

4. Create and run the Ansible playbook. Create a file named `nms-playbook.yml` (or any other name) with contents similar to the following example:

    ```yaml
    - hosts: nms
      become: yes
      vars:
        nginx_license:
          certificate: ./nginx-repo.crt
          key: ./nginx-repo.key
        nms_setup: install
        nms_version: 2.16.0*
        nms_user_name: admin
        nms_user_passwd: default
        nms_modules:
          - name: sm
      collections:
        - nginxinc.nginx_core
      roles:
        - nginxinc.nginx_management_suite
    ```

5. Run the playbook:

    ```shell
    ansible-playbook -i <path-to-your-hostfile> nms-playbook.yml
    ```

{{< call-out "note" >}} For a comprehensive list of configuration options, view the [default `main.yaml` file](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/defaults/main.yml) on GitHub. {{< /call-out>}}

---

## Getting support

If you need help or have questions, you can request support from the [NGINX Instance Manager Ansible Role Project](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/SUPPORT.md) on GitHub.