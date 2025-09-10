---
description: Automates SSL/TLS certificate lifecycle management by enabling direct communication between clients and certificate authorities.
title: ACME
toc: true
weight: 100
type:
- how-to
---

The ACME protocol automates SSL/TLS certificate lifecycle management by enabling direct communication between clients and certificate authorities for issuance, installation, revocation, and replacement of SSL certificates. 

The `nginx-plus-module-acme` module is an [NGINX-authored]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#nginx-authored-dynamic-modules" >}}) dynamic module that implements the automatic certificate management ([ACMEv2](https://www.rfc-editor.org/rfc/rfc8555.html)) protocol.

The source code for the module is available in the official [GitHub repository](https://github.com/nginx/nginx-acme). The official documentation, including module reference and usage examples, is available on the [nginx.org](https://nginx.org/en/docs/http/ngx_http_acme_module.html) website.


## Installation

The installation process closely follows the [NGINX Plus installation procedure]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}). The module is available as the prebuilt `nginx-plus-module-acme` package for various Linux distributions and can be installed directly from the official NGINX Plus repository. Prior to installation, you need to add the NGINX Plus package repository for your distribution and update the repository metadata.

1.  Check the [Technical Specifications]({{< ref "/nginx/technical-specs.md" >}}) page to verify that the module is supported by your operating system.

2.  Make sure you have the latest version of NGINX Plus. In Terminal, run the command:

    ```shell
    nginx -v
    ```

    Expected output of the command:

    ```shell
    nginx version: nginx/1.29.0 (nginx-plus-r35)
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

7.  Update the repository information and install the `nginx-plus-module-acme` package. In a terminal, run the appropriate command for your operating system.

    For CentOS, Oracle Linux, and RHEL:

    ```shell
    sudo yum update  && \
    sudo yum install nginx-plus-module-acme
    ```

    For Amazon Linux 2023, AlmaLinux, Rocky Linux:

    ```shell
    sudo dnf update  && \
    sudo dnf install nginx-plus-module-acme
    ```

    For Debian and Ubuntu:

    ```shell
    sudo apt update  && \
    sudo apt install nginx-plus-module-acme
    ```

    For Alpine:

    ```shell
    sudo apk update  && \
    sudo apk add nginx-plus-module-acme
    ```

    For FreeBSD:

    ```shell
    sudo pkg update  && \
    sudo pkg install nginx-plus-module-acme
    ```

    The resulting `ngx_http_acme_module.so`  dynamic module will be written to the following directory, depending on your operating system:

   - `/usr/lib64/nginx/modules/` for most Linux distributions
   - `/usr/lib/nginx/modules` for Debian, Ubuntu, Alpine
   - `/usr/local/etc/nginx/modules` for FreeBSD

8.  Enable dynamic loading of the module.

    - In a text editor, open the NGINX Plus configuration file (`/etc/nginx/nginx.conf` for Linux or `/usr/local/etc/nginx/nginx.conf` for FreeBSD).

    -  On the top-level (or “`main`”) context, specify the path to the dynamic module with the [`load_module`](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive:

    ```nginx
    load_module modules/ngx_http_acme_module.so;

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


For a complete list of directives and variables refer to the `ngx_http_acme_module` [official documentation](https://nginx.org/en/docs/http/ngx_http_acme_module.html) and [NGINX ACME module GitHub project](https://github.com/nginx/nginx-acme).

1. To enable ACME functionality, specify the directory URL of the ACME server with the [`uri`](https://nginx.org/en/docs/http/ngx_http_acme_module.html#uri) directive.

   Additionally, you can provide information regarding how to contact the client in case of certificate-related issues or where to store module data with the [`contact`](https://nginx.org/en/docs/http/ngx_http_acme_module.html#contact) and [`state_path`](https://nginx.org/en/docs/http/ngx_http_acme_module.html#state_path) directives.

   ```nginx
   acme_issuer letsencrypt {
       uri         https://acme-v02.api.letsencrypt.org/directory;
       # contact   admin@example.test;
       state_path  /var/cache/nginx/acme-letsencrypt;

       accept_terms_of_service;
   }
   ```

2. If necessary, you can increase the default shared memory zone that stores certificates, private keys, and challenge data for all the configured certificate issuers with the [`acme_shared_zone`](https://nginx.org/en/docs/http/ngx_http_acme_module.html#acme_shared_zone) directive. The default  zone size is `256k`.

   ```nginx
   acme_shared_zone zone=acme_shared:1M;
   ```

3. Configure Challenges by defining a listener on port 80 in the nginx configuration to process ACME HTTP-01 challenges:

   ```nginx
   server {
       # listener on port 80 is required to process ACME HTTP-01 challenges
       listen 80;

       location / {
           #Serve a basic 404 response while listening for challenges
           return 404;
        }
   }
   ```

4. Automate the issuance or renewal of TLS certificates with the [`acme_certificate`](https://nginx.org/en/docs/http/ngx_http_acme_module.html#acme_certificate) directive in the respective [`server`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block. The directive requires the list of identifiers (domains) for which the certificates need to be dynamically issued that can be defined with the [`server_name`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive. The [`$acme_certificate`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_acme_certificate_key) and [`$acme_certificate_key`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_acme_certificate_key) variables are used to pass the SSL certificate and key information for the associated domain:

   ```nginx
   server {

       listen 443 ssl;

       server_name  .example.com;

       acme_certificate letsencrypt;

       ssl_certificate       $acme_certificate;
       ssl_certificate_key   $acme_certificate_key;
       ssl_certificate_cache max=2;
   }
   ```

   Note that not all values accepted by the [`server_name`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directive are valid identifiers. Wildcards and regular expressions are not supported.


## Full example

```nginx
resolver 127.0.0.1:53;

acme_issuer example {
    uri         https://acme.example.com/directory;
    # contact   admin@example.test;
    state_path  /var/cache/nginx/acme-example;
    accept_terms_of_service;
}

acme_shared_zone zone=ngx_acme_shared:1M;

server {
    listen 443 ssl;
    server_name  .example.test;

    acme_certificate example;

    ssl_certificate       $acme_certificate;
    ssl_certificate_key   $acme_certificate_key;

    # do not parse the certificate on each request
    ssl_certificate_cache max=2;
}

server {
    # listener on port 80 is required to process ACME HTTP-01 challenges
    listen 80;

    location / {
        return 404;
    }
}
```

## More info

- [Native support for ACME blog post](https://blog.nginx.org/blog/native-support-for-acme-protocol)

- [NGINX ACME module GitHub project](https://github.com/nginx/nginx-acme)

- [Official documentation for the NGINX ACME module](https://nginx.org/en/docs/http/ngx_http_acme_module.html)

- [NGINX Plus technical specifications]({{< ref "/nginx/technical-specs.md" >}})

- [NGINX dynamic modules]({{< ref "dynamic-modules.md" >}})

- [Uninstalling a dynamic module]({{< ref "uninstall.md" >}})
