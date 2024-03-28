---
description: An NGINX Instance Manager installation document.
docs: DOCS-627
doctypes:
- tutorial
tags:
- docs
title: Server Install and Configuration
toc: true
weight: 200
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document helps you get NGINX Instance Manager up and running.

## Prerequisites {#prerequisites}

1. Get the installation packages or binaries.
1. Get license files.
    1. Download NGINX Instance Manager Server license file (for production use)
    1. Optional: Download repository certificate and key (for repo access)
1. Create a Linux instance for hosting the NGINX Instance Manager Server.
    1. Ensure the firewall is open for gRPC port and API/GUI port.
    1. Suggested sizing is 2GB Memory, 1 vCPU, and 20GB disk space.

{{%heading "installation"%}}

## Install Server {#install-server}

You can choose one of the following two options:

- Use the public NGINX repositories with a certificate and key or internal package management system (like Red Hat Satellite)
- Use the packages directly by downloading them from the myF5 portal or from  NGINX/F5 sales team.

### License File Locations {#license-file}

There are three license files included with NGINX Instance Manager:

1. `NGINX-Instance-Manager.lic` (may be named differently): The nginx-manager server license is placed in the `/etc/nginx-manager/` directory. It is referenced by the `license:` option in the `/etc/nginx-manager/nginx-manager.conf` file. Without this file, you will only see the scan functions, and the inventory page will display an error.
2. `nginx-repo.crt` or `nginx-repo.cer` (this may have the extension `.cer`): This file is used to run NGINX Plus as a proxy for nginx-manager and is also used to pull packages from the public repositories. The apt and yum repository files reference this and the private key file below to pull packages. You can place these files in `/etc/ssl/nginx` following the instructions for setting up the repository below.
3. `nginx-repo.key`: This file is used with the crt file above for running NGINX Plus and accessing repositories for nginx-manager and nginx-agent.

{{<note>}}
To use the repositories without modification, rename and move the nginx-repo files to:

- `/etc/ssl/nginx/nginx-repo.crt`
- `/etc/ssl/nginx/nginx-repo.key`

{{</note>}}

### Install from the NGINX public repositories {#install-server-public}

This method allows you to use a simple `yum` or `apt-get` install and use the `nginx-repo.crt` and `nginx-repo.key`.

1. Create the /etc/ssl/nginx directory

```bash
sudo mkdir /etc/ssl/nginx
cd /etc/ssl/nginx
```

2. Log in to MyF5 Customer Portal and download your nginx-manager-repo.crt and nginx-manager-repo.key files. You should rename nginx-repo.cer and nginx-repo.key (or similar name) to the suggested names.

3. Copy the files to the /etc/ssl/nginx/ directory.

```bash
sudo cp nginx-*.crt /etc/ssl/nginx/nginx-repo.crt
sudo cp nginx-*.key /etc/ssl/nginx/nginx-repo.key
```

4. Install the required certificate authority dependencies.

{{<tabs name="install_ca">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

```bash
sudo yum install ca-certificates
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

```bash
sudo apt-get install apt-transport-https lsb-release ca-certificates
sudo wget https://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
```

{{%/tab%}}
{{</tabs>}}

5. Install the repository file.

{{<tabs name="install_repo">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

```bash
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/instance-manager.repo
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

```bash
printf "deb https://pkgs.nginx.com/instance-manager/debian stable nginx-plus\n" | sudo tee /etc/apt/sources.list.d/instance-manager.list
sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
sudo apt-get update
```

```bash
$ cat /etc/apt/apt.conf.d/90pkgs-nginx
    Acquire::https::pkgs.nginx.com::Verify-Peer "true";
    Acquire::https::pkgs.nginx.com::Verify-Host "true";
    Acquire::https::pkgs.nginx.com::SslCert     "/etc/ssl/nginx/nginx-repo.crt";
    Acquire::https::pkgs.nginx.com::SslKey      "/etc/ssl/nginx/nginx-repo.key";
```

{{%/tab%}}
{{</tabs>}}

6. Install the Instance Manager Server.

{{<tabs name="install_server">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

```bash
sudo yum install -y nginx-manager
```

If you have a signing key error, run the following:

```bash
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
sudo rpmkeys --import /tmp/nginx_signing.key
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

```bash
sudo apt-get install -y nginx-manager
```

{{%/tab%}}
{{</tabs>}}

7. Proceed to Server Configuration Section.

### Install from package files directly {#install-server-private}

You will need the packages for NGINX Instance Manager. Download them directly from [MyF5 Customer Portal](https://account.f5.com/myf5) or use the one provided by your NGINX Sales Team. Run updates manually with this method (take the following steps and run the `rpm` or `apt-get update` commands for newer packages).

{{<tabs name="install_local">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

1. Installation.

```bash
sudo yum -y --nogpgcheck install /home/user/nginx-manager-1.0.1-1.x86_64.rpm
```

2. Upgrades.

```bash
sudo yum -y --nogpgcheck upgrade /home/user/nginx-manager-1.0.2-1.x86_64.rpm
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

1. Installation.

```bash
sudo apt-get -y install /home/user/nginx-manager_1.0.0-1_amd64.deb
```

2. Upgrades.

```bash
sudo apt-get -y upgrade /home/user/nginx-manager_1.0.2-1_amd64.deb
```

{{%/tab%}}
{{</tabs>}}

## Configure NGINX Instance Manager Server {{%heading "configure-server"%}}

Configure the NGINX Instance Manager Server for use with or without an NGINX proxy.

1. Add the license file to the `/etc/nginx-manager` directory. Ensure the name matches what is in the `nginx-manager.conf` file. The above example uses `nginx-manager.lic`.

### NGINX Instance Manager without a proxy server {#noproxy-server}

NGINX Instance Manager defaults to running on 127.0.0.1 only (it is not exposed to external interfaces). It is recommended to use the included NGINX Plus package to proxy traffic to NGINX Instance Manager.

If your organization prevents this or you wish to test Instance Manager in a secured environment without any authentication, you can enable Instance Manager to listen on external interfaces.

1. Open any required firewall ports or SELinux/apparmor rules for the ports and IPs you wish to use.

2. Edit the /etc/nginx-manager/nginx-manager.conf file and change the bind_address and ports to reflect your choices. For example, the following file will listen on 10.1.1.4 IP and use the default ports of 11000 for UI/API and 10000 for grpc.

```yaml
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "127.0.0.1")
bind_address: 10.1.1.4
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL CN or servername for certs
# server_name: nginx-manager.example.com
# path to x.509 certificate file (optional)
# cert: /etc/ssl/nginx-manager/nginx-manager.crt
# path to x.509 certificate key file (optional)
# key: /etc/ssl/nginx-manager/nginx-manager.key

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/
# Path to license file
license: /etc/nginx-manager/nginx-manager.lic
```

You can also use `0.0.0.0` for the `bind_address` to enable all external ports (note, this is insecure).

### NGINX Instance Manager with a proxy server {#proxy-server}

NGINX Instance Manager is designed as a web application with an API. NGINX Plus is our recommended solution for web applications requiring advanced authentication, proxy, and load balancing. A copy of NGINX Plus is included with the NGINX Instance Manager distribution as a frontend for NGINX Instance Manager. This is the only permitted use of the included NGINX Plus instance. For external uses and other systems, contact your sales team to purchase additional subscriptions.

For installation options for using NGINX Plus or NGINX as a front-end for NGINX Instance Manager, refer to the [encryption]({{<relref "/nms/nim/previous-versions/v1/getting-started/encrypt.md">}}) and [authentication]({{<relref "/nms/nim/previous-versions/v1/getting-started/auth.md">}}) documents.

### Installing NGINX Plus as the proxy server {#nginx-plus-install}

The repository certificate and key (`nginx-repo.crt` and `nginx-repo.key`) can be used to pull an nginx-plus package that is used to proxy connections to `nginx-manager`. To setup NGINX Plus, use the included certificate and key (it may be easier to copy them into `/etc/ssl/nginx/nginx-repo.crt` and `/etc/ssl/nginx/nginx-repo.key`) and follow the [NGINX Plus Installation Steps](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/).

## SELinux {{%heading "selinux-install"%}}

NGINX Instance Manager also has an SELinux policy module that can be installed on SELinux-enabled systems. It is provided as an RPM and can be pulled from the same repository as the server packages. You can do this manually as well and place ports in the httpd context.

### Install SELinux Policy Module {#selinux-server}

```bash
sudo yum install -y nginx-manager_selinux
```

### Add ports for Instance Manager SELinux context {#selinux-ports-add}

Instance Manager uses the nginx-manager_t context in the policy module, and you will have to verify and add any ports you use. For external ports, you should also add them to the firewall exceptions.

To add a port to the nginx-manager context, you can use a similar command to one below that adds 10000 and 11000:

```bash
sudo semanage port -a -t nginx_manager_port_t -p tcp 10000
sudo semanage port -a -t nginx_manager_port_t -p tcp 11000
```

If you already have defined the port context, replace `-a` with `-m`:

```bash
sudo semanage port -m -t nginx_manager_port_t -p tcp 10000
sudo semanage port -m -t nginx_manager_port_t -p tcp 11000
```

### Remove ports for Instance Manager SELinux context {#selinux-ports-remove}

If you remove nginx-manager-selinux you should also remove the ports using a command similar to the one below:

```bash
sudo semanage port -d -t nginx_manager_port_t 10000
sudo semanage port -d -t nginx_manager_port_t 11000
```

## Start and Enable NGINX Instance Manager Server {{%heading "start-server"%}}

For systemd systems, perform the following steps:

{{<tabs name="start_server">}}
{{%tab name="systemd"%}}

1. Start the NGINX Instance Manager Server.

```bash
sudo systemctl start nginx-manager
```

2. Enable the NGINX Instance Manager Server to start on boot.

```bash
sudo systemctl enable nginx-manager
```

{{%/tab%}}
{{%tab name="upstart"%}}

```bash
sudo initctl start nginx-manager
```

{{%/tab%}}
{{</tabs>}}

{{%heading "access-server"%}}

## Access the GUI {#access-server-gui}

Point your browser to the FQDN and port you configured Instance Manager on. If your server name is `nginx-manager.example.com` and the port is `11000`, then your browser can access the web interface at `http://nginx-manager.example.com:11000`.

## Access the Swagger-UI API {#access-server-api}

To access the swagger-ui page, simply append '/swagger-ui' to the end of the URL. For example, the server above would be <http://nginx-manager.example.com:11000/swagger-ui>.

## Access the metrics endpoint {#access-server-metrics}

To access metrics through Grafana or Prometheus, configure the data source as a Prometheus endpoint and add '/metrics' to the end of the URL. For example, the server above would be <http://nginx-manager.example.com:11000/metrics>.

{{%heading "configure"%}}

## Configure Server {#configure-server}

After installing the server, you can configure options in multiple ways. The most common method is to utilize the configuration file; however, command-line options are also available.

### Using the conf file {#configure-server-conf}

NGINX Instance Manager uses a conf file located in /etc/nginx-manager/nginx-manager.conf by default.

{{<note>}}
The nginx-manager binary will look in the binary file location first for a configuration file, then use the /etc/nginx-manager/nginx-manager.conf file. Command-line options also override these. The order of precedence from highest to lowest is:

- Command Line
- Environment Variables (prefixed with "NIM_")
- First config found (".", "/etc/nginx-manager")
- Command Default
{{</note>}}

Here is a sample conf file and also the default when you install NGINX Instance Manager, located in /etc/nginx-manager/nginx-manager.conf

```yaml
#
# /etc/nginx-manager/nginx-manager.conf
#

# Configuration file for NGINX Instance Manager Server

# bind address for all service ports (default "127.0.0.1")
bind_address: 127.0.0.1
# gRPC service port for agent communication (default "10000")
grpc_port: 10000
# gRPC-gateway service port for API and UI (default "11000")
gateway_port: 11000

# SSL server name for use with cert and key below (optional)
# server_name:
# path to x.509 certificate file (optional)
# cert:
# path to x.509 certificate key file (optional)
# key:

# set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
log:
    level: info
    path: /var/log/nginx-manager/
# Metrics default storage path (default "/tmp/metrics") (directory must be already present)
metrics:
    storage_path: /var/nginx-manager/

```

## What's Next

- Configure Authentication on the Server
- Configure nginx-agent on nginx instances
- Use Grafana to display metrics
- Scan a network range for new instances
