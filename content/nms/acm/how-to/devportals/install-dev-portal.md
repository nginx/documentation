---
title: "Install or Upgrade the Developer Portal"
date: 2023-04-06T11:59:50-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install or upgrade the Developer Portal for NGINX Management Suite API Connectivity Manager."
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

## Platform Requirements {#acm-devportal-requirements}

{{<important>}}To run the Developer Portal, you need a **dedicated** Linux host specifically for this purpose. **Do not** install the Developer Portal on a host that is currently serving as a management or data plane.{{</important>}}

Complete the following steps to prepare the Developer Portal for use with API Connectivity Manager:

1. [Install NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
2. [Install NGINX njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

</details>

<br>

---

## Installation Prerequisites

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

---

## Install the Developer Portal

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

## Upgrade the Developer Portal

{{<tabs name="upgrade_dev_portal">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the latest version of the Developer Portal, run the following command:

   ```bash
   sudo yum update -y nginx-devportal nginx-devportal-ui
   ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the latest version of the Developer Portal, run the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get upgrade -y nginx-devportal nginx-devportal-ui
   ```

{{%/tab%}}
{{</tabs>}}

2. Enable the Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

3. Restart the Developer Portal service:
  
   ```bash
   sudo systemctl restart nginx-devportal.service
   ```