---
title: "Virtual machine or bare metal"
weight: 100
toc: true
nd-banner:
    enabled: true
    start-date: 2025-08-30
    md: /_banners/waf-virtual-restriction.md
nd-content-type: how-to
nd-product: F5WAFN
---

This page describes how to install F5 WAF for NGINX in a virtual machine or bare metal environment.

## Before you begin

To complete this guide, you will need the following prerequisites:

- A [supported operating system]({{< ref "/waf/fundamentals/technical-specifications.md#supported-operating-systems" >}}).
- An active F5 WAF for NGINX subscription. Available from [MyF5](https://my.f5.com/manage/s/) (Purchased or trial).
  - Download the [SSL certificate, private key, and the JWT license](#Download your subscription credentials) file associated with your F5 WAF for NGINX subscription from the MyF5 Customer Portal.
- A working [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). If NGINX Plus is not installed separately it will be installed automatically during F5 WAF for NGINX installation.
- F5 WAF for NGINX will work by default with the default values like default policy, logging profile, etc unless the user sets custom configurations

Depending on your deployment type, you may have additional requirements:

You should read the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) topics for additional set-up configuration if you want to use them immediately.

{{< include "waf/install-selinux-warning.md" >}}

## Download your subscription credentials 

### General subscription credentials needed for deployments 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

### Additional subscription credentials needed for deployments

To use NGINX Plus, you will need to download the the JWT license file associated with your F5 WAF for NGINX WAF subscription from the [MyF5](https://my.f5.com/manage/s/) Customer Portal:

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

## Platform-specific instructions

Navigate to your chosen operating system, which are alphabetically ordered.

### Alpine Linux

Add the F5 WAF for NGINX signing key:

```shell
sudo wget -O /etc/apk/keys/app-protect-security-updates.rsa.pub https://cs.nginx.com/static/keys/app-protect-security-updates.rsa.pub
```

Add the F5 WAF for NGINX repository:

```shell
printf "https://pkgs.nginx.com/app-protect/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
printf "https://pkgs.nginx.com/app-protect-security-updates/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | sudo tee -a /etc/apk/repositories
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apk update
sudo apk add openssl ca-certificates app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `apk info` to list available versions, then append it to the package name:

```shell
sudo apk info app-protect
sudo apk add openssl ca-certificates app-protect=<desired-version>
```

{{< /details >}}

### Amazon Linux

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-amazonlinux2023.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.amazonlinux2023.repo
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `--showduplicates list` to list available versions, then append it to the package name:

```shell
sudo dnf --showduplicates list app-protect
sudo dnf install app-protect-=<desired-version>
```

{{< /details >}}

### Debian

Add the F5 WAF for NGINX signing key:

```shell
wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | \
sudo tee /usr/share/keyrings/app-protect-security-updates.gpg > /dev/null
```

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
https://pkgs.nginx.com/app-protect-security-updates/debian `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `apt-cache` to list available versions, then append it to the package name:

```shell
sudo apt-get update
sudo apt-cache policy app-protect
sudo apt-get install app-protect=<desired-version>
```

When installing a specific version of F5 WAF for NGINX, you will also need to manually install its package dependencies. 

You can use the following script to get the dependent packages:

```shell
findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
findDeps app-protect=<desired-version>
```

{{< /details >}}

### Oracle Linux / RHEL / Rocky Linux 8

{{< call-out "important" >}}

The steps are identical for these platforms due to their similar architecture.

{{< /call-out >}}

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-8.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```

Enable F5 WAF for NGINX dependencies:

```shell
sudo dnf config-manager --set-enabled crb
```

Enable the _ol8_codeready_builder_ repository:

```shell
sudo dnf config-manager --set-enabled ol8_codeready_builder
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `--showduplicates list` to list available versions, then append it to the package name:

```shell
sudo dnf --showduplicates list app-protect
sudo dnf install app-protect-=<desired-version>
```

{{< /details >}}

### RHEL / Rocky Linux 9

Add the F5 WAF for NGINX repository:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-9.repo
```

Add F5 WAF for NGINX dependencies:

```shell
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
```

Enable F5 WAF for NGINX dependencies:

```shell
sudo dnf config-manager --set-enabled crb
```

Install the F5 WAF for NGINX package and its dependencies:

```shell
sudo dnf install app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `--showduplicates list` to list available versions, then append it to the package name:

```shell
sudo dnf --showduplicates list app-protect
sudo dnf install app-protect-=<desired-version>
```

{{< /details >}}

### Ubuntu

Add the F5 WAF for NGINX signing key:

```shell
wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg > /dev/null
```

Add the F5 WAF for NGINX repositories:

```shell
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/app-protect-security-updates.list
```

Update the repositories, then install the F5 WAF for NGINX package and its dependencies:

```shell
sudo apt-get update
sudo apt-get install app-protect
```

{{< details summary="Installing a specific version of F5 WAF for NGINX" >}}

If you need to install a specific version of F5 WAF for NGINX, you can use `apt-cache` to list available versions, then append it to the package name:

```shell
sudo apt-get update
sudo apt-cache policy app-protect
sudo apt-get install app-protect=<desired-version>
```

When installing a specific version of F5 WAF for NGINX, you will also need to manually install its package dependencies.

You can use the following script to get the dependent packages:

```shell
findDeps () { local pkgs=$(apt show $1 2>/dev/null | grep Depends: | grep -oE "(nginx-plus-module|app-protect)-[a-z]+ *\(= *[0-9\+\.-]+~`lsb_release -cs`\)" | tr -d ' ()'); for p in ${pkgs[@]}; do echo $p; findDeps $p; done; }
findDeps app-protect=<desired-version>
```

{{< /details >}}

## Update configuration files

Once you have installed F5 WAF for NGINX, you must load it as a module in the main context of your NGINX configuration.

```nginx
load_module modules/ngx_http_app_protect_module.so;
```

And finally, F5 WAF for NGINX can enabled on a _http_, _server_ or _location_ context:

```nginx
app_protect_enable on;
```

{{< call-out "warning" >}}

You should only enable F5 WAF for NGINX on _proxy_pass_ and _grpc_pass_ locations.

{{< /call-out >}}

Here are two examples of how these additions could look in configuration files:

{{< tabs name="configuration-examples" >}}

{{% tab name="nginx.conf" %}}

The default path for this file is `/etc/nginx/nginx.conf`.

```nginx {hl_lines=[5]}
user  nginx;
worker_processes  auto;

# F5 WAF for NGINX
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

{{% /tab %}}

{{% tab name="default.conf" %}}

The default path for this file is `/etc/nginx/conf.d/default.conf`.

```nginx {hl_lines=[9]}
server {
    listen 80;
    server_name domain.com;


    location / {

        # F5 WAF for NGINX
        app_protect_enable on;

        client_max_body_size 0;
        default_type text/html;
        proxy_pass http://127.0.0.1:8080/;
    }
}

server {
    listen 8080;
    server_name localhost;


    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

{{% /tab %}}

{{< /tabs >}}

Once you have updated your configuration files, you can reload NGINX to apply the changes. You have two options depending on your environment:

- `nginx -s reload`
- `sudo systemctl reload nginx`

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

## Next steps

{{< include "waf/install-next-steps.md" >}}
