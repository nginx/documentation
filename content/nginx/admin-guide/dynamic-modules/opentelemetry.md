---
description: Analyze your software performance by instrumenting, generating, collecting,
  and exporting telemetry data.
docs: DOCS-1207
title: OpenTelemetry
toc: true
weight: 100
type:
- how-to
---

## Overview {#overview}

[OpenTelemetry](https://opentelemetry.io/) (OTel) is an observability framework for monitoring, tracing, troubleshooting, and optimizing applications. OTel enables the collection of telemetry data from a deployed application stack.

The `nginx-plus-module-otel` module is NGINX-authored dynamic module that enables NGINX Plus to send telemetry data to an OTel collector. The module supports [W3C](https://w3c.github.io/trace-context/) trace context propagation, OpenTelemetry Protocol (OTLP)/gRPC trace exports, and offers several advantages over existing OTel modules including:

- Enhanced performance: other OTel implementations can reduce request processing by up to 50%, while `nginx-plus-module-otel` minimizes this impact to just 10-15%.

- Simplified provisioning through NGINX configuration file.

- Dynamic, variable-based control of trace parameters with cookies, tokens, and variables. See [Ratio-based Tracing](#example) example for details.

- Dynamic control of sampling parameters via the [NGINX Plus API]({{< ref "/nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-rest-api" >}}) and [key-value storage]({{< ref "/nginx/admin-guide/security-controls/denylisting-ip-addresses.md" >}}).

The repository can be found on [GitHub](https://github.com/nginxinc/nginx-otel). The documentation can be found on [nginx.org](https://nginx.org/en/docs/ngx_otel_module.html).


## Installation {#install}

Similar to [NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}), prebuilt packages of the `nginx-plus-module-otel` module can can be installed directly from the official repository for different distributions. Before installation you will need to add NGINX Plus package repositories for your distribution and update the repository metadata.

1. Check the [Technical Specifications]({{< ref "nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

   {{< note >}} The OpenTelemetry module cannot be installed on Amazon Linux 2 LTS and SLES 15 SP5+. {{< /note >}}

2. Make sure you have the latest version of NGINX Plus or you have upgraded NGINX Plus to the latest version. In Terminal, run the command:

   ```shell
   nginx -v
   ```

   Expected output of the command:

   ```shell
   nginx version: nginx/1.27.4 (nginx-plus-r34)
   ```

3. Make sure you have installed dependencies required for your operating system.

   For Amazon Linux 2023, AlmaLinux, CentOS, Oracle Linux, RHEL, and Rocky Linux:

   ```shell
   sudo dnf update
   sudo dnf install ca-certificates
   sudo dnf update-ca-certificates #use if ca-certificates are installed
   ```

   For Debian:

   ```shell
   sudo apt update
   sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 debian-archive-keyring
   ```

   ```shell
   wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
   ```

   For Ubuntu:

   ```shell
   sudo apt update
   sudo apt install apt-transport-https lsb-release ca-certificates wget gnupg2 ubuntu-keyring
   ```

   ```shell
   printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
   https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
   | sudo tee /etc/apt/sources.list.d/nginx-plus.list
   ```

   For Alpine:

   ```shell
   sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
   ```

   For FreeBSD:

   ```shell
   sudo pkg update
   sudo pkg install ca_root_nss
   ```

3. Make sure you have obtained the **nginx-repo.crt** and **nginx-repo.key** files from MyF5 and put them to the **/etc/ssl/nginx/** directory. These files are required for accessing the NGINX Plus repository:

   ```shell
   sudo cp nginx-repo.crt /etc/ssl/nginx/
   sudo cp nginx-repo.key /etc/ssl/nginx/
   ```

   For Alpine, upload **nginx-repo.crt** to **/etc/apk/cert.pem** and **nginx-repo.key** to **/etc/apk/cert.key**. Ensure these files contain only the specific key and certificate as Alpine Linux does not support mixing client certificates for multiple repositories.

4. Make sure your package management system is configured to pull from NGINX Plus repository. See [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) for details.

4. Update the repository information and install the package. In Terminal, run the appropriate command for your operating system.

   For CentOS, Oracle Linux, and RHEL:

   ```shell
   sudo yum update
   sudo yum install nginx-plus-module-otel
   ```

   For Amazon Linux 2023, AlmaLinux, Rocky Linux:

   ```shell
   sudo dnf update
   sudo dnf install nginx-plus-module-otel
   ```

   For Debian and Ubuntu:

   ```shell
   sudo apt update
   sudo apt install nginx-plus-module-otel
   ```

   For Alpine:

   ```shell
   sudo apk update
   sudo apk add nginx-plus-module-otel
   ```

   For FreeBSD:

   ```shell
   sudo pkg update
   sudo pkg install nginx-plus-module-otel
   ```

   The module will be installed into `/usr/local/nginx` directory.

6. Copy the `ngx_otel_module.so` dynamic module binary to `/usr/local/nginx/modules`.

7. Enable dynamic loading of the module. Open the NGINX Plus configuration file, `nginx.conf` in a text editor, and specify the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive on the top-level (“`main`”) context:

   ```nginx
   load_module modules/ngx_otel_module.so;

   http {
   #...
   }
   ```

3. Save the configuration file.

4. Test and reload NGINX Plus configuration to enable the module.  In Terminal, type-in the command:

   ```shell
   nginx -t && nginx -s reload
   ```


## Configuration {#configure}

For a complete list of directives, embedded variables, default span attributes, refer to the `ngx_otel_module` official documentation.

List of directives:

[`https://nginx.org/en/docs/ngx_otel_module.html#directives`](https://nginx.org/en/docs/ngx_otel_module.html#directives)

List of variables:

[`https://nginx.org/en/docs/ngx_otel_module.html#variables`](https://nginx.org/en/docs/ngx_otel_module.html#variables)

Default span attributes:

[`https://nginx.org/en/docs/ngx_otel_module.html#span`](https://nginx.org/en/docs/ngx_otel_module.html#span)


## Usage examples {#example}

### Simple Tracing

Dumping all the requests could be useful even in non-distributed environment.

```nginx
http {
    otel_trace on;
    server {
        location / {
        proxy_pass http://backend;
        }
    }
}
```

### Parent-based Tracing

```nginx
http {
    server {
        location / {
            otel_trace $otel_parent_sampled;
            otel_trace_context propagate;

            proxy_pass http://backend;
        }
    }
}
```

### Ratio-based Tracing

```nginx
http {
    # trace 10% of requests
    split_clients $otel_trace_id $ratio_sampler {
        10%     on;
        *       off;
    }

    # or we can trace 10% of user sessions
    split_clients $cookie_sessionid $session_sampler {
        10%     on;
        *       off;
    }

    server {
        location / {
            otel_trace $ratio_sampler;
            otel_trace_context inject;

            proxy_pass http://backend;
        }
    }
}
```

## More Info {#info}

- [GitHub Repository for the NGINX Native OpenTelemetry Module](https://github.com/nginxinc/nginx-otel)

- [Official Documentation for the NGINX Native OpenTelemetry Module](https://nginx.org/en/docs/ngx_otel_module.html)

- [NGINX Dynamic Modules]({{< ref "dynamic-modules.md" >}})

- [NGINX Plus Technical Specifications]({{< ref "nginx/technical-specs.md" >}})
