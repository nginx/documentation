---
description: Analyze your software performance by instrumenting, generating, collecting,
  and exporting telemetry data.
nd-docs: DOCS-1207
title: OpenTelemetry
toc: true
weight: 100
type:
- how-to
---

[OpenTelemetry](https://opentelemetry.io/) (OTel) is an observability framework for monitoring, tracing, troubleshooting, and optimizing applications. OTel enables the collection of telemetry data from a deployed application stack.

The `nginx-plus-module-otel` module is an [NGINX-authored]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-authored-dynamic-modules" >}}) dynamic module that enables NGINX Plus to send telemetry data to an OTel collector. The module supports [W3C](https://w3c.github.io/trace-context/) trace context propagation, OpenTelemetry Protocol (OTLP)/gRPC trace exports, and offers several advantages over existing OTel modules including:

- Enhanced performance: with the module enabled, request processing overhead is limited to 10-15%, compared to other OpenTelemetry implementations, which can introduce performance degradation of up to 50%.

- Simplified provisioning through NGINX configuration file.

- Dynamic, variable-based control of trace parameters with cookies, tokens, and variables. See [Ratio-based Tracing](#example) example for details.

- Dynamic control of sampling parameters via the [NGINX Plus API]({{< ref "/nginx/admin-guide/monitoring/live-activity-monitoring.md#using-the-rest-api" >}}) and [key-value storage]({{< ref "/nginx/admin-guide/security-controls/denylisting-ip-addresses.md" >}}).

The source code for the module is available in the official [GitHub repository](https://github.com/nginxinc/nginx-otel). The official documentation, including module reference and usage examples, is available on the [nginx.org](https://nginx.org/en/docs/ngx_otel_module.html) website.

The OpenTelemetry module supersedes the deprecated [OpenTracing]({{< ref "opentracing.md" >}}) module which was available until NGINX Plus [Release 34]({{< ref "/nginx/releases.md#r34" >}}).


## Installation

The installation process closely follows the [NGINX Plus installation procedure]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). The module is available as the prebuilt `nginx-plus-module-otel` package for various Linux distributions and can be installed directly from the official NGINX Plus repository. Prior to installation, you need to add the NGINX Plus package repository for your distribution and update the repository metadata.

1.  Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

    {{< call-out "note" >}} The OpenTelemetry module cannot be installed on Amazon Linux 2 LTS and SLES 15 SP5+. {{< /call-out >}}

2.  Make sure you have the latest version of NGINX Plus. In Terminal, run the command:

    ```shell
    nginx -v
    ```

    Expected output of the command:

    ```shell
    nginx version: nginx/1.27.4 (nginx-plus-r34)
    ```

3.  Ensure you have the **nginx-repo.crt** and **nginx-repo.key** files from [MyF5 Customer Portal](https://account.f5.com/myf5) in the **/etc/ssl/nginx/** directory. These files are required for accessing the NGINX Plus repository.

    ```shell
    sudo cp <downloaded-file-name>.crt /etc/ssl/nginx/nginx-repo.crt && \
    sudo cp <downloaded-file-name>.key /etc/ssl/nginx/nginx-repo.key
    ```

    For Alpine, the **nginx-repo.crt** to **/etc/apk/cert.pem** and **nginx-repo.key** files should be added to **/etc/apk/cert.key**. Ensure these files contain only the specific key and certificate as Alpine Linux does not support mixing client certificates for multiple repositories.

    For FreeBSD, the path to these files should also be added to the `/usr/local/etc/pkg.conf` file:

    ```shell
    PKG_ENV: { SSL_NO_VERIFY_PEER: "1",
    SSL_CLIENT_CERT_FILE: "/etc/ssl/nginx/nginx-repo.crt",
    SSL_CLIENT_KEY_FILE: "/etc/ssl/nginx/nginx-repo.key" }
    ```

4.  Ensure that all required dependencies for your operating system are installed.

    For Amazon Linux 2023, AlmaLinux, CentOS, Oracle Linux, RHEL, and Rocky Linux:

    ```shell
    sudo dnf update && \
    sudo dnf install ca-certificates
    ```

    For Debian:

    ```shell
    sudo apt update && \
    sudo apt install apt-transport-https \
                     lsb-release \
                     ca-certificates \
                     wget \
                     gnupg2 \
                     debian-archive-keyring
    ```

    For Ubuntu:

    ```shell
    sudo apt update  && \
    sudo apt install apt-transport-https \
                     lsb-release \
                     ca-certificates \
                     wget \
                     gnupg2 \
                     ubuntu-keyring
    ```

    For FreeBSD:

    ```shell
    sudo pkg update  && \
    sudo pkg install ca_root_nss
    ```

5.  Ensure that the NGINX signing key has been added, if required by your operating system.

    For Debian:

    ```shell
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    ```

    For Ubuntu:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" \
    | sudo tee /etc/apt/sources.list.d/nginx-plus.list
    ```

    For Alpine:

    ```shell
    sudo wget -O /etc/apk/keys/nginx_signing.rsa.pub https://cs.nginx.com/static/keys/nginx_signing.rsa.pub
    ```

6.  Ensure that your package management system is configured to pull packages from the NGINX Plus repository. See [Installing NGINX Plus]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}) for details.

7.  Update the repository information and install the `nginx-plus-module-otel` package. In a terminal, run the appropriate command for your operating system.

    For CentOS, Oracle Linux, and RHEL:

    ```shell
    sudo yum update  && \
    sudo yum install nginx-plus-module-otel
    ```

    For Amazon Linux 2023, AlmaLinux, Rocky Linux:

    ```shell
    sudo dnf update  && \
    sudo dnf install nginx-plus-module-otel
    ```

    For Debian and Ubuntu:

    ```shell
    sudo apt update  && \
    sudo apt install nginx-plus-module-otel
    ```

    For Alpine:

    ```shell
    sudo apk update  && \
    sudo apk add nginx-plus-module-otel
    ```

    For FreeBSD:

    ```shell
    sudo pkg update  && \
    sudo pkg install nginx-plus-module-otel
    ```

    The resulting `ngx_otel_module.so`  dynamic module will be written to the following directory, depending on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux distributions
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

8.  Enable dynamic loading of the module.

    - In a text editor, open the NGINX Plus configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

    -  On the top-level (or “`main`”) context, specify the path to the dynamic module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive:

    ```nginx
    load_module modules/ngx_otel_module.so;

    http {
    #...
    }
    ```
    - Save the configuration file.

9.  Test the NGINX Plus configuration. In a terminal, type-in the command:

    ```shell
    nginx -t
    ```

    Expected output of the command:

    ```shell
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf is successful
    ```

10. Reload the NGINX Plus configuration to enable the module:

    ```shell
    nginx -s reload
    ```


## Configuration

In a text editor, open the NGINX Plus configuration file:
  - `/etc/nginx/nginx.conf` for Linux
  - `/usr/local/etc/nginx/nginx.conf` for FreeBSD

For a complete list of directives, embedded variables, default span attributes, refer to the `ngx_otel_module` official documentation.

List of directives:

[`https://nginx.org/en/docs/ngx_otel_module.html#directives`](https://nginx.org/en/docs/ngx_otel_module.html#directives)

List of variables:

[`https://nginx.org/en/docs/ngx_otel_module.html#variables`](https://nginx.org/en/docs/ngx_otel_module.html#variables)

Default span attributes:

[`https://nginx.org/en/docs/ngx_otel_module.html#span`](https://nginx.org/en/docs/ngx_otel_module.html#span)


## Usage examples

### Simple Tracing

This configuration enables basic request tracing, capturing tracing information for every incoming request, even in non-distributed environments.

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

This configuration enables parent-based tracing, where NGINX Plus captures and propagates trace information from incoming requests, allowing tracing contexts to be inherited from the parent request. It is useful in scenarios where NGINX Plus is used as a reverse proxy within a distributed tracing system.

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

This configuration enables sampling of a specified percentage of requests or user sessions for tracing, based on configurable ratios.

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

## More info

- [NGINX Native OpenTelemetry module GitHub project](https://github.com/nginxinc/nginx-otel)

- [Official documentation for the NGINX Native OpenTelemetry module](https://nginx.org/en/docs/ngx_otel_module.html)

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
