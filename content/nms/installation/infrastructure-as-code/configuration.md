---
description: This guide shows you how to install NGINX Management Suite using the
  open-source Ansible role. Easily reproduce your installation across multiple environments
  through automation.
docs: DOCS-1248
doctypes:
- task
tags:
- docs
title: Install NGINX Management Suite with Ansible
toc: true
weight: 200
---

{{< call-out "tip" "Open-Source Project on GitHub" >}}
The steps in this guide refer to the <a href="https://github.com/nginxinc/ansible-role-nginx-management-suite" target="_blank">Ansible NGINX Management Suite Role project on GitHub.</a> <i class="fa-solid fa-arrow-up-right-from-square" style="color:#009639;"></i>
{{</call-out>}}

---

## Installation Flow

The Ansible role for NGINX Management Suite simplifies the installation process by installing all the prerequisites and any modules you specify.

{{< img src="img/iac/ansible-flow.png" caption="Figure 1. NGINX Management Suite Ansible flow" alt="A diagram showing the installation flow of the NGINX Management Suites Ansible role.">}}

---

## Requirements

- To view the Ansible role requirements, click [here](https://github.com/nginxinc/ansible-role-nginx-management-suite#requirements).

---

## Getting Started

1. Install the Ansible role by using an Ansible Galaxy requirements file. Follow the installation steps [here](https://github.com/nginxinc/ansible-role-nginx-management-suite#installation).

2. Next, run the Ansible playbook. Create a file named `nms-playbook.yml` (or any other name) with contents similar to the following example:

    ``` yaml
    - hosts: nms
      become: yes
      vars:
        nginx_license:
          certificate: ./nginx-repo.crt
          key: ./nginx-repo.key
        nms_setup: install
        nms_modules:
          - name: acm
          - name: sm
      collections:
        - nginxinc.nginx_core
      roles:
        - nginxinc.nginx_management_suite
    ```

3. Create an [Ansible hosts file](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) containing the hosts you want in the group listed in your playbook.

4. Run the playbook:

    ``` bash
    ansible-playbook -i <path-to-your-hostfile> nms-playbook.yml
    ```

{{<see-also>}}For a comprehensive list of configuration options, click [here](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/defaults/main.yml).{{</see-also>}}

---

## Getting Support

If you need assistance or have questions, you can find support from the [NGINX Management Suite Ansible Role Project](https://github.com/nginxinc/ansible-role-nginx-management-suite/blob/main/SUPPORT.md) on GitHub.
