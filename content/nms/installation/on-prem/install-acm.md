---
title: "Install API Connectivity Manager"
date: 2023-04-06T11:59:50-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 20
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

---

## Before You Begin

### Install Prerequisites

{{< include "installation/nms-prerequisites.md" >}}

### Dependencies with Instance Manager

{{< include "tech-specs/acm-nim-dependencies.md" >}}

---

## Install API Connectivity Manager

{{<tabs name="install-acm">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of API Connectivity Manager, run the following command:

    ```bash
    sudo yum install -y nms-api-connectivity-manager
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of API Connectivity Manager, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get install nms-api-connectivity-manager
    ```

{{%/tab%}}

{{</tabs>}}

2. Enable and start the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations nms-acm --now
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

3. Restart the NGINX web server:

   ```bash
   sudo systemctl restart nginx
   ```

### Post-Installation Steps

{{< include "installation/optional-installation-steps.md" >}}

### Accessing the Web Interface

{{< include "installation/access-web-ui.md" >}}

---

## Add License

A valid license is required in order to use the API Connectivity Manager.

### Download License

{{< include "installation/download-license.md" >}}

### Apply License

{{< include "installation/add-license.md" >}}

---

## Set Up the Data Plane

API Connectivity Manager requires one or more data plane hosts for the API Gateway.

Complete the following steps for each data plane instance you want to use with API Connectivity Manager:

1. [Install NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
2. [Install NGINX njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)
3. [Install the NGINX Agent]({{< relref "nginx-agent/install-nginx-agent.md" >}}) on your data plane instances to register them with NGINX Management Suite.

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/nms-supported-distros.md" >}}

</details>

---

## Install Developer Portal

Follow the steps in this section to install the Developer Portal.

### Platform Requirements {#acm-devportal-requirements}

{{<important>}}To run the Developer Portal, you need a **dedicated** Linux host specifically for this purpose. **Do not** install the Developer Portal on a host that is currently serving as a management or data plane.{{</important>}}

Complete the following steps to prepare the Developer Portal for use with API Connectivity Manager:

1. [Install NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
2. [Install NGINX njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

</details>

<br>

### Add NGINX Management Suite Repository {#add-yum-apt}

{{< include "installation/add-nms-repo.md" >}}

### Install PostgreSQL or SQLite

The Developer Portal requires a PostgreSQL or SQLite database to store configuration settings and analytics information.

Select the tab for the database you want to use, then follow the installation instructions.

{{<tabs name="dev-portal-db">}}

{{%tab name="PostgreSQL"%}}

To use PostgreSQL for the Developer Portal database, take the following steps:

1. Install PostgreSQL:

    - CentOS, RHEL, RPM-based:

        ```bash
        sudo yum install -y postgresql-server
        sudo postgresql-setup initdb
        ```

    - Debian, Ubuntu, Deb-based:

        ```bash
        sudo apt-get install -y postgresql
        ```

2. Configure the PostgreSQL host-based authentication (HBA) file:

    - CentOS, RHEL, RPM-based:

        ``` bash
        cat << EOF | sudo tee /var/lib/pgsql/data/pg_hba.conf

        # TYPE DATABASE USER ADDRESS METHOD

        local all postgres peer
        local all all md5
        # IPv4 local connections:
        host all all 127.0.0.1/32 md5
        # IPv6 local connections:
        host all all ::1/128 md5
        EOF
        ```

    - Debian, Ubuntu, Deb-based:

        ``` bash
        cat << EOF | sudo tee /etc/postgresql/<pg_version>/main/pg_hba.conf

        # TYPE DATABASE USER ADDRESS METHOD

        local all postgres peer
        local all all md5
        # IPv4 local connections:
        host all all 127.0.0.1/32 md5
        # IPv6 local connections:
        host all all ::1/128 md5
        EOF
        ```

3. Restart PostgreSQL:

    ``` bash
    sudo systemctl restart postgresql
    ```

4. Create the `devportal` database, add the `nginxdm` user, and assign privileges:

    ```bash
    sudo -u postgres createdb devportal
    sudo -u postgres psql -c "CREATE USER nginxdm WITH LOGIN PASSWORD 'nginxdm';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE devportal TO nginxdm;"
    ```

{{%/tab%}}

{{%tab name="SQLite"%}}

To use SQLite for the Developer Portal database, run the following commands:

```bash
echo 'DB_TYPE="sqlite"' | sudo tee -a /etc/nginx-devportal/devportal.conf
echo 'DB_PATH="/var/lib/nginx-devportal"' | sudo tee -a /etc/nginx-devportal/devportal.conf
```

<br>

{{%/tab%}}

{{</tabs>}}

### Install the Developer Portal

1. To install the Developer Portal, run the following command(s):

   - CentOS, RHEL, RPM-based:

      ```bash
      sudo yum -y install nginx-devportal nginx-devportal-ui
      ```

   - Debian, Ubuntu, Deb-based:

      ```bash
      sudo apt-get update
      sudo apt-get -y install nginx-devportal nginx-devportal-ui
      ```

2. Start the Developer Portal:

    ```bash
    sudo systemctl start nginx-devportal
    ```

---

## What's Next

### Install Other NGINX Management Suite Modules

- [Install App Delivery Manager]({{< relref "installation/on-prem/install-adm.md" >}})
- [Install Security Monitoring]({{< relref "installation/on-prem/install-security-monitoring.md" >}})

### Get Started with API Connectivity Manager

- [Create Workspaces and Environments for your API Infrastructure]({{< relref "acm/how-to/infrastructure/manage-api-infrastructure.md" >}})