---
description: Follow the steps in this guide to install or upgrade the Developer Portal
  for F5 NGINX Management Suite API Connectivity Manager.
nd-docs: DOCS-1214
title: Install or Upgrade the Developer Portal
toc: true
weight: 10
type:
- tutorial
---

---

## Platform Requirements {#acm-devportal-requirements}

{{< call-out "important" >}}To run the Developer Portal, you need a **dedicated** Linux host specifically for this purpose. **Do not** install the Developer Portal on a host that is currently serving as a management or data plane.{{< /call-out >}}

Complete the following steps to prepare the Developer Portal for use with API Connectivity Manager:

1. [Install F5 NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)
2. [Install NGINX njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

{{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

</details>

<br>

---

## Prerequisites

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

{{<tabs name="install_dev_portal">}}
{{%tab name="CentOS, RHEL, RPM-Based"%}}

1. To install the Developer Portal, run the following command:

    ```bash
    sudo yum -y install nginx-devportal nginx-devportal-ui
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

1. To install the Developer Portal, run the following commands:

    ```bash
    sudo apt-get update
    sudo apt-get -y install nginx-devportal nginx-devportal-ui
    ```

{{%/tab%}}
{{</tabs>}}

3. Enable the Developer Portal service:

   ```bash
   sudo systemctl enable nginx-devportal.service
   ```

2. Start the Developer Portal service:

    ```bash
    sudo systemctl start nginx-devportal.service
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

---

## Secure Developer Portal API communication

Depending on your [deployment pattern for the Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/configure-devportal-backend.md" >}}), you may have either a single host installation(default) or a multi-host installation for high availability. We recommend using mTLS for the communication between the NGINX reverse proxy and the Developer Portal APIs to provide maximum security.

1. On the Developer Portal Service host or hosts, edit the Dev Portal configuration file located at `/etc/nginx-devportal/devportal.conf`
1. Add the location of the server certificate and certificate key, as shown in the example below.

   ```yaml
   CERT_FILE="/path/to/devportal-server.crt"
   KEY_FILE="/path/to/devportal-server.key"
   INSECURE_MODE=false
   CA_FILE="/path/to/ca.pem"  # If using mTLS
   CLIENT_VERIFY=true # If using mTLS
   ```

1. Adjust the permissions of each of the certificate and key files provided to ensure they are readable by the Dev Portal backend service.
1. Restart the developer portal backend service:

   ```shell
   sudo systemctl restart nginx-devportal
   ```

1. If mTLS is configured on your Developer Portal service, you must add a TLS Backend Policy to both;
   - The Developer Portal Cluster (Used for communication from users to the Developer Portal API)
   - The Developer Portal Internal Cluster (For communication from the API Connectivity Manager to your Devportal Portal API to publish and maintain information)
{{< call-out "note" >}}
To add a TLS Backend Policy to both clusters. Follow the [TLS Policies]({{< ref "/nms/acm/how-to/policies/tls-policies.md#add-tls-listener" >}}) documentation.
{{< /call-out >}}

---

## Secure communication from the Developer Portal to NGINX Management Suite host with mTLS

For complete Developer Portal functionality, such as the ability to create credentials from the Developer Portal, mTLS must be added for server-to-server communication.

Follow the steps below to make sure NGINX Management Suite host can verify the client certificates provided by the Developer Portals backend service.

1. Edit the NGINX Management Suite configuration file located at `/etc/nginx/conf.d/nms-http.conf`.
1. Add the location of the CA PEM file to the `ssl_client_certificate` directive, as shown in the example below:

   ```yaml
   ssl_certificate         /etc/nms/certs/manager-server.pem;
   ssl_certificate_key     /etc/nms/certs/manager-server.key;
   ssl_client_certificate  /etc/nms/certs/ca.pem;
   ```

1. Reload the NGINX configuration:

   ```shell
   sudo nginx -s reload
   ```

1. Follow the steps in the [TLS Policies]({{< ref "/nms/acm/how-to/policies/tls-policies.md#/#tls-internal-cluster" >}}) documentation to add TLS policies that will enforce mTLS using these the correct client keys to connect to the NGINX Management Suite host.
