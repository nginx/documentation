---
description: An NGINX Agent installation and configuration document.
docs: DOCS-623
doctypes:
- tutorial
tags:
- docs
title: Agent Install and Configuration
toc: true
weight: 300
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document helps you get NGINX Agent up and running.

## Prerequisites {#prerequisites}

1. Get the installation packages or binaries.
2. Get the license files.
    1. Download the NGINX Instance Manager Server license file (for production use).
    2. Optional: Download the repository certificate and key (for repository ("repo") access).
3. Install and configure the NGINX Instance Manager Server.
    1. Know the fully qualified domain name ("FQDN") and gRPC port number.
    2. This document uses the example `nginx-manager.example.com:10000`.
4. Have NGINX running on your instance.
    1. Know the binary location for NGINX.
    2. Know the process ID ("pid") location for NGINX.

{{<note>}}

You can run NGINX Open Source or NGINX Plus, or your own compiled version of NGINX. Our support list is suggestive.
We currently offer 64bit (x86_64 and amd64) binaries and packages that can run on a variety of 64bit Linux systems.
{{</note>}}

{{%heading "installation"%}}

## Install Agent {#install-agent}

The most difficult part is getting the packages onto your installed OS. You can choose one of the following two options:

- Use the public NGINX repositories with a certificate and key or an internal package management system (e.g. Red Hat Satellite)
- Use the packages directly by downloading them from the myF5 portal or from your NGINX/F5 sales team.

### License File Locations {#license-file}

There are two license files included with `nginx-agent` that are needed for the repository install:

1. `nginx-repo.crt` or `nginx-repo.cer` (this may have the extension `.cer`): This file is used to pull packages from the public repositories. The apt and yum repository files reference this and the private key file below to pull packages. You can place these files in `/etc/ssl/nginx` following the instructions for setting up the repository below.
2. `nginx-repo.key`: This file is used with the crt file above for running NGINX Plus and accessing repositories for nginx-manager and nginx-agent.

{{<note>}}
To use the repositories without modification; rename, and move, the nginx-repo files to:

- `/etc/ssl/nginx/nginx-repo.crt`
- `/etc/ssl/nginx/nginx-repo.key`

{{</note>}}

### Install from the NGINX public repositories {#install-agent-public}

This method allows you to use a simple `yum` or `apt-get` install and use of the `nginx-repo.crt` and `nginx-repo.key`.

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
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-agent.repo
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

```bash
printf "deb https://pkgs.nginx.com/nginx-agent/debian stable nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-agent.list
sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
sudo apt-get update
```

```bash
cat /etc/apt/apt.conf.d/90pkgs-nginx
    Acquire::https::pkgs.nginx.com::Verify-Peer "true";
    Acquire::https::pkgs.nginx.com::Verify-Host "true";
    Acquire::https::pkgs.nginx.com::SslCert     "/etc/ssl/nginx/nginx-repo.crt";
    Acquire::https::pkgs.nginx.com::SslKey      "/etc/ssl/nginx/nginx-repo.key";
```

{{%/tab%}}
{{</tabs>}}

6. Install the NGINX Agent.

{{<tabs name="install_agent">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

```bash
sudo yum install -y nginx-agent
```

If you have a signing key error run the following

```bash
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
sudo rpmkeys --import /tmp/nginx_signing.key
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

```bash
sudo apt-get install -y nginx-agent
```

{{%/tab%}}
{{</tabs>}}

7. Proceed to Agent Configuration Section.

### Install from package files directly {#install-agent-private}

You will need the packages for NGINX Instance Manager. Download them directly from the [MyF5 Customer Portal](https://account.f5.com/myf5) or use the one provided by your NGINX Sales Team. Run the updates manually with this method (follow the steps below and run the `rpm` or `apt-get update` commands for newer packages).

{{<tabs name="install_local">}}
{{%tab name="CentOS, RHEL, and rpm-based distributions"%}}

1. Installation.

```bash
sudo yum -y --nogpgcheck install /home/user/nginx-agent-1.0.1-1.x86_64.rpm
```

2. Upgrades.

```bash
sudo yum -y --nogpgcheck upgrade /home/user/nginx-agent-1.0.2-1.x86_64.rpm
```

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and deb-based distributions"%}}

1. Installation.

```bash
sudo apt-get -y install /home/user/nginx-agent_1.0.1-1_amd64.deb
```

2. Upgrades.

```bash
sudo apt-get -y upgrade /home/user/nginx-agent_1.0.2-1_amd64.deb
```

{{%/tab%}}
{{</tabs>}}

{{%heading "configure"%}}

Configure the NGINX Instance Manager Server for use with or without an NGINX proxy.

## NGINX Instance Manager configuration {#configure-agent}

NGINX Agent defaults to `127.0.0.1` on a new installation which almost always fails (you must change the server flag).

1. Open any required firewall ports or SELinux/apparmor rules for the ports and IPs you want to use.

2. Edit the `/etc/nginx-agent/nginx-agent.conf` file and change the server and ports to reflect your choices. For example, the following file will listen on `10.1.1.4` IP and use the default ports of `11000` for UI/API and `10000` for gRPC.

Additionally, you can specify a separate metrics address via `metrics_server`, as well as specifying TLS with `metrics-tls`. `server` on it's own will use the same address and TLS for both.

The `api-token` argument is also exposed and will be added to client streaming if specified in order to authenticate to NCC metrics ingest and command services.

Change the appropriate options below, focusing on the server, bin_path, conf_path, and the URLs (depending on if you use NGINX Open Source or NGINX Plus).

{{<note>}}

Comment out the `stub_status` if you use NGINX Plus or `plus_api` line if you use NGINX Open Source. Otherwise you will receive 400 errors as the agent checks that location for metrics. For NGINX Open Source, you may also want to disable access logging on the stub_status page to keep those responses out of the metrics collection.
{{</note>}}

```yaml
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent

# specify the server grpc port to connect to
server: nginx-manager.example.com:10000
# tls options
tls:
  # path to certificate
  cert: /etc/ssl/nginx-agent/agent.crt
  # path to certificate key
  key: /etc/ssl/nginx-agent/agent.key
  # path to CA cert bundle
  ca: /etc/ssl/nginx-agent/ca.pem
log:
  # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
# tags:
# - web
# - staging
# - etc
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
# nginx configuration options
nginx:
  # path of nginx to manage
  bin_path: /usr/sbin/nginx
  # path of nginx config to manage
  conf_path: /etc/nginx/nginx.conf
  # specify stub status URL (see: nginx.org/r/stub_status)
  stub_status: "http://127.0.0.1:80/nginx_status"
  # specify plus status api url (see nginx.org/r/api)
  plus_api: "http://127.0.0.1:8080/api"
  # specify metrics poll interval
  metrics_poll_interval: 1000ms
```

## SELinux for nginx-agent {{%heading "selinux"%}}

### Install SELinux Policy Module {#selinux-agent}

```bash
sudo yum install -y nginx-agent_selinux
```

### Add ports for Instance Manager SELinux context {#selinux-ports-add}

NGINX may need some adjustments to comply with SELinux, especially for ports outside the httpd context. Refer to the article [Using NGINX and NGINX Plus with SELinux](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) for more information.
For external ports, you should also add them to the firewall exceptions.

When using ports outside the standard httpd context, you may need to allow nginx to connect to them. A boolean is enabled below to do this.

```bash
sudo setsebool -P httpd_can_network_connect 1
```

## Start and Enable NGINX Agent {{%heading "start-agent"%}}

For systemd systems perform the following steps.

{{<tabs name="start_agent">}}
{{%tab name="systemd"%}}

1. Start the NGINX Agent.

```bash
sudo systemctl start nginx-agent
```

2. Enable the NGINX Agent to start on boot.

```bash
sudo systemctl enable nginx-agent
```

{{%/tab%}}
{{%tab name="upstart"%}}

```bash
sudo initctl start nginx-agent
```

{{%/tab%}}
{{</tabs>}}

## What's Next

Check the browser interface or API on the Instance Manager server, you should now see your instance on the inventory list. There is no additional action needed to have the instance information come up. To remove the instance, ensure that the service is stopped and won't run. Then you can remove the instance in the inventory.
