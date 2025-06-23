---
nd-docs: DOCS-794
title: Secure client access and network traffic
toc: true
weight: 600
type:
- tutorial
---

{{< include "nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide explains how to secure client connections to NGINX Instance Manager and protect traffic between NGINX Instance Manager and NGINX instances.

With NGINX Plus R33, telemetry data must be reported to a usage reporting endpoint, such as NGINX Instance Manager. This data validates subscription entitlements and tracks usage metrics. This guide also covers how to use the [`ssl_verify`](#ssl_verify-and-usage-reporting-in-nginx-plus-r33) directive to secure telemetry reporting through certificate verification.

{{< call-out "important" >}}Never expose your management server to the public internet. The settings in this guide reduce risk, but they can't replace keeping your server inaccessible to unauthorized users.{{< /call-out >}}

{{< call-out "tip" "See also:" "fa-solid fa-book" >}}
- To learn how to secure traffic for NGINX Agent, see [NGINX Agent TLS Settings](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/).
- For details on NGINX Plus entitlement and usage reporting, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}).{{< /call-out >}}

---

## NGINX Proxy SSL Termination

SSL termination is the process where SSL-encrypted traffic is decrypted at the proxy, in this case, NGINX Instance Manager. Once decrypted, the traffic can be sent to its destination unencrypted or re-encrypted, depending on the configuration.

To secure traffic between NGINX Plus instances and NGINX Instance Manager, you must configure an SSL certificate and key in the NGINX configuration. This setup applies to both NGINX Open Source and NGINX Plus. For more details, see the [NGINX SSL Termination guide](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/).

Starting with NGINX Plus R33, you must also enable `ssl_verify` to verify the SSL certificate used by NGINX Instance Manager when reporting telemetry data. See the section on [`ssl_verify` and usage reporting](#ssl_verify-and-usage-reporting-in-nginx-plus-r33) for more details.

The example below shows how to set up SSL termination for NGINX Instance Manager:

<details open>
    <summary>/etc/nginx/conf.d/nms-http.conf</summary>

```nginx
# Main external HTTPS server, needs port 443
server {
    listen 443 ssl;
    http2  on;
    root   /var/www/nms;

    server_name _;

    ssl_protocols       TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    ssl_certificate         /etc/nms/certs/manager-server.pem;
    ssl_certificate_key     /etc/nms/certs/manager-server.key;
    ssl_client_certificate  /etc/nms/certs/ca.pem;
```

</details>

<br>

---

## Mutual Client Certificate Authentication Setup (mTLS)

Mutual TLS (mTLS) is a security method that uses client certificates to verify both the server and the client during communication. This ensures that both NGINX Instance Manager and NGINX Plus instances are securely authenticated, protecting your network from unauthorized access.

With mTLS, each NGINX instance has a unique client certificate that NGINX Instance Manager verifies before allowing communication. You can configure NGINX as a proxy to handle client certificates for this secure exchange.

Follow these steps to set up mTLS using a Public Key Infrastructure (PKI) system:

### Certificate Authority (CA) Setup

1. **Create a private Certificate Authority (CA)**:
   - If you're testing, you can generate the CA on the same machine as NGINX Instance Manager.
   - For production environments, follow your organization's security standards (these often require generating CAs on secure, offline machines).

2. **Set up root and intermediate CAs**:
   - The root CA issues certificates to an intermediate CA. The intermediate CA, in turn, issues certificates for clients and servers. This layered setup adds extra security by ensuring that the root CA is only used for top-level tasks.

3. **Issue Client and Server Certificates**:
   - The intermediate CA signs the certificate signing requests (CSRs) and issues certificates to NGINX clients and NGINX Instance Manager.

### Generate Certificates

To generate the necessary certificates, follow these steps. You can modify these instructions to suit your specific environment.

1. **Install OpenSSL** (if it isn't installed already).
2. **Create the certificate generation script**:
   - Use the following example script to generate the certificates for your CA, server, and client. Save the script as `make_certs.sh`.


    <details>
        <summary>make_certs.sh</summary>

    ```bash
    #!/bin/bash
    set -e

    make_ca() {
        echo "Creating Self-Signed Root CA certificate and key"
        openssl req \
            -new \
            -nodes \
            -x509 \
            -keyout ca.key \
            -out ca.crt \
            -config ca.cnf \
            -extensions v3_req \
            -days 1826  # 5 years
    }

    make_int() {
        echo "Creating Intermediate CA certificate and key"
        openssl req \
            -new \
            -nodes \
            -keyout ca_int.key \
            -out ca_int.csr \
            -config ca-intermediate.cnf \
            -extensions v3_req
        openssl req -in ca_int.csr -noout -verify
        openssl x509 \
            -req \
            -CA ca.crt \
            -CAkey ca.key \
            -CAcreateserial \
            -in ca_int.csr \
            -out ca_int.crt \
            -extfile ca-intermediate.cnf \
            -extensions v3_req \
            -days 365 # 1 year
        openssl verify -CAfile ca.crt ca_int.crt
        echo "Creating CA chain"
        cat ca_int.crt ca.crt > ca.pem
    }

    make_server() {
        echo "Creating nginx-manager certificate and key"
        openssl req \
            -new \
            -nodes \
            -keyout server.key \
            -out server.csr \
            -config server.cnf
        openssl req -in server.csr -noout -verify
        openssl x509 \
            -req \
            -CA ca_int.crt \
            -CAkey ca_int.key \
            -CAcreateserial \
            -in server.csr \
            -out server.crt \
            -extfile server.cnf \
            -extensions v3_req \
            -days 365 # 1 year
        openssl verify -CAfile ca.pem server.crt
    }

    make_agent() {
        echo "Creating Agent certificate and key"
        openssl req \
            -new \
            -nodes \
            -keyout agent.key \
            -out agent.csr \
            -config agent.cnf
        openssl req -in agent.csr -noout -verify
        openssl x509 \
            -req \
            -CA ca.crt \
            -CAkey ca.key \
            -CAcreateserial \
            -in agent.csr \
            -out agent.crt \
            -extfile agent.cnf \
            -extensions v3_req \
            -days 365 # 1 year
        openssl verify -CAfile ca.pem agent.crt
    }

    # MAIN
    make_ca
    make_int
    make_server
    make_agent
    ```

    </details><br/>

3. **Place the configuration files**:
   - Put the following OpenSSL `.cnf` files in the same directory as the `make_certs.sh` script. These files are needed to configure the certificate authority and generate the appropriate certificates.

    <details>
        <summary>ca.cnf</summary>

    {{< icon "download">}} {{<link "/admin/encrypt/ca.cnf" "ca.cnf">}}

    ``` yaml
    [req]
    default_bits        = 4096
    distinguished_name  = req_distinguished_name
    prompt              = no
    default_md          = sha256
    req_extensions      = v3_req

    # recommend changing these to your needs
    [req_distinguished_name]
    countryName                 = US
    stateOrProvinceName         = California
    localityName                = San Francisco
    organizationName            = NGINX, Inc.
    commonName                  = nms-ca

    [v3_req]
    basicConstraints = critical, CA:true
    keyUsage = critical, keyCertSign, cRLSign
    subjectKeyIdentifier = hash
    ```

    </details>

    <details>
        <summary>ca-intermediate.cnf</summary>

    ``` yaml
    [req]
    default_bits        = 4096
    distinguished_name  = req_distinguished_name
    prompt              = no
    default_md          = sha256
    req_extensions      = v3_req

    # recommend changing these to your needs
    [req_distinguished_name]
    countryName                 = US
    stateOrProvinceName         = California
    localityName                = San Francisco
    organizationName            = NGINX, Inc.
    commonName                  = nms-int-ca

    [v3_req]
    basicConstraints = critical, CA:true
    keyUsage = critical, keyCertSign, cRLSign
    subjectKeyIdentifier = hash
    ```

    </details>

    <details>
        <summary>server.cnf</summary>

    ``` yaml
    [req]
    prompt             = no
    default_bits       = 4096
    x509_extensions    = v3_req
    req_extensions     = v3_req
    default_md         = sha256
    distinguished_name = req_distinguished_name

    # recommend changing these to your needs
    [req_distinguished_name]
    countryName                 = US
    stateOrProvinceName         = California
    localityName                = San Francisco
    organizationName            = NGINX, Inc.
    commonName                  = nginx-manager.example.com

    [v3_req]
    basicConstraints = CA:FALSE
    keyUsage         = nonRepudiation, digitalSignature, keyEncipherment, keyAgreement
    extendedKeyUsage = critical, serverAuth
    subjectAltName = @alt_names

    # apply any DNS or IP SANs as needed
    [alt_names]
    DNS.1 = <NGINX-INSTANCE-MANAGER-FQDN>
    IP.1 = <NGINX-INSTANCE-MANAGER-IP>
    ```

    </details>

    <details>
        <summary>agent.cnf</summary>

    ``` yaml
    [req]
    prompt             = no
    default_bits       = 2048
    x509_extensions    = v3_req
    req_extensions     = v3_req
    default_md         = sha256
    distinguished_name = req_distinguished_name

    # recommend changing these to your needs
    [req_distinguished_name]
    countryName                 = US
    stateOrProvinceName         = California
    localityName                = San Francisco
    organizationName            = NGINX, Inc.
    commonName                  = agent.example.com

    [v3_req]
    basicConstraints = CA:FALSE
    keyUsage         = nonRepudiation, digitalSignature, keyEncipherment, keyAgreement
    extendedKeyUsage = critical, clientAuth
    ```

    </details><br/>

4. **Run the script**:
    - After saving the script, make it executable and run it to generate the certificates.

    ```bash
    sudo chmod +x ./make_certs.sh
    sudo ./make_certs.sh
    ```

5. **Copy the certificates to the NGINX instance**:
    - Once generated, copy the ca.pem, agent.crt, and agent.key files to the NGINX instance where the NGINX Agent certificates will be installed.

    ```bash
    sudo mkdir -p /etc/nms/certs
    sudo cp ca.pem /etc/nms/certs/
    sudo cp agent.crt /etc/nms/certs/
    sudo cp agent.key /etc/nms/certs/
    ```

6. **Modify the NGINX Agent configuration**:
	- Modify the `nginx-agent.conf` file to match the example below. The TLS options configure the NGINX Agent to use client certificate authentication with the NGINX proxy on NGINX Instance Manager. The `ca.pem` file is included as the certificate authority that the agent will use to verify NGINX Instance Manager’s server certificate.
	- If the CA is trusted by the operating system, you can omit the ca option.
	- Update the server host to match the NGINX Instance Manager address.

    {{< call-out "note" >}}For additional information about TLS configurations for the NGINX Agent, refer to the [NGINX Agent TLS Settings](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/) topic. {{< /call-out>}}

    <details>
        <summary>/etc/nginx-agent/nginx-agent.conf</summary>

    ```yaml {hl_lines=[8,22,23,24,25]}
    #
    # /etc/nginx-agent/nginx-agent.conf
    #
    # Configuration file for NGINX Agent.
    #
    # This file is to track agent configuration values that are meant to be statically set. There
    # are additional agent configuration values that are set via the API and agent install script
    # which can be found in /var/lib/nginx-agent/agent-dynamic.conf.

    # specify the server grpc port to connect to
    server:
        # host of the control plane
        host: <NGINX-INSTANCE-MANAGER-FQDN>
        grpcPort: 443
        # provide servername overrides if using SNI
        metrics: "nginx-manager.example.com"
        command: "nginx-manager.example.com"
    # tls options
    tls:
        enable: true
        skip_verify: false
        cert: /etc/nms/certs/agent.crt
        key: /etc/nms/certs/agent.key
        ca: /etc/nms/certs/ca.pem
    log:
        # set log level (panic, fatal, error, info, debug, trace; default "info")
        level: info
        # set log path. if empty, don't log to file.
        path: /var/log/nginx-agent/
    # data plane status message / 'heartbeat'
    nginx:
        # path of NGINX logs to exclude
        exclude_logs: ""

    dataplane:
        sync:
            enable: true
        # poll interval for data plane status
        status:
            poll_interval: 30s
    metrics:
        # specify the size of a buffer to build before sending metrics
        bulk_size: 20
        # specify metrics poll interval
        report_interval: 1m
        collection_interval: 15s
        mode: aggregated

    # OSS NGINX default config path
    # path to aux file dirs can also be added
    config_dirs: "/etc/nginx:/usr/local/etc/nginx"
    ```

    </details>

7. Copy `ca.pem`, `server.crt`, and `server.key` to NGINX Instance Manager.

    ```bash
    sudo cp ca.pem /etc/nms/certs/
    sudo cp server.crt /etc/nms/certs/
    sudo cp server.key /etc/nms/certs/
    ```

8. Add a new server to NGINX proxy for gRPC in the NGINX Instance Manager configuration with the newly generated certificates, then reload the service.

    - The `server_name` should match the `server.metrics` and `server.command` values in `nginx-agent.conf`.
    - You can remove `MetricsService` and `Commander` locations from the existing server.
    - The new server will enforce mTLS communication between NGINX Agent and NGINX Instance Manager, while the previous server can continue serving static content for the web interface and API without mTLS requirements.

    When `tls.skip_verify` is set to `false`, NGINX Agent verifies the server's certificate chain and hostname. Ensure the `server_name` in the configuration matches the Common Name (CN) or Subject Alternative Name (SAN) in the generated certificate.

    ```nginx
    # gRPC HTTPS server, needs port 443
    server {
        listen 443 ssl;
        http2  on;
        root   /var/www/nms;

        server_name nginx-instance-manager.example.com;

        ssl_protocols       TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;

        ssl_certificate         /etc/nms/certs/server.crt;
        ssl_certificate_key     /etc/nms/certs/server.key;
        ssl_client_certificate  /etc/nms/certs/ca.pem;
        ssl_verify_client on;

        # gRPC service for metric ingestion
        location /f5.nginx.agent.sdk.MetricsService {
            include /etc/nms/nginx/errors-grpc.loc_conf;
            grpc_socket_keepalive on;
            grpc_read_timeout 5m;
            grpc_send_timeout 5m;
            client_body_timeout 10m;
            grpc_pass grpc://ingestion-grpc-service;
        }

        # gRPC service for DPM
        location /f5.nginx.agent.sdk.Commander {
            include /etc/nms/nginx/errors-grpc.loc_conf;
            grpc_socket_keepalive on;
            grpc_read_timeout 5m;
            grpc_send_timeout 5m;
            client_body_timeout 10m;
            grpc_pass grpc://dpm-grpc-service;
        }
    ```

9. **Reload NGINX proxy configuration**:
   - Apply the new settings by reloading NGINX proxy configuration.

    ```bash
    sudo nginx -s reload
    ```

10. **Restart NGINX Agent**:
    - Start or restart NGINX Agent to apply the changes.

    ```bash
    sudo systemctl restart nginx-agent
    ```

---

## Configure SSL verification for usage reporting with self-signed certificates {#configure-ssl-verify}

{{<call-out "note" "Version requirements" "">}}
Usage reporting for NGINX Plus R33 or later in disconnected environments requires **NGINX Instance Manager version 2.18 or later**.
{{</call-out>}}

Starting with NGINX Plus R33, NGINX Plus must report usage data to a reporting endpoint, such as NGINX Instance Manager. For more information, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}).

The [`ssl_verify`](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_verify) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block ensures that NGINX Plus connects only to trusted reporting endpoints by validating the server's SSL certificate. The `ssl_verify` directive is set to `on` by default.

### Why `ssl_verify` is important

When `ssl_verify` is enabled:

- NGINX Plus validates the SSL certificate presented by NGINX Instance Manager, ensuring it's from a trusted source.
- Secure telemetry transmission prevents man-in-the-middle (MITM) attacks.

If the certificate is untrusted or invalid, telemetry reporting will fail. This failure can affect subscription validation and may prevent NGINX Plus from functioning properly.

### Trusting self-signed certificates

If NGINX Instance Manager uses a self-signed certificate, you must configure NGINX Plus to trust it explicitly. Use the [`ssl_trusted_certificate`](https://pp.nginx.com/yar/libxslt/en/docs/ngx_mgmt_module.html#ssl_trusted_certificate) directive to specify a PEM-formatted file that contains the trusted CA certificate:

```nginx
mgmt {
    usage_report endpoint=<NGINX-INSTANCE-MANAGER-FQDN>;
    ssl_verify on;
    ssl_trusted_certificate <CA-CERT-FILE-FROM-NGINX-INSTANCE-MANAGER>;
    ssl_name manager-server;
}
```

Using self-signed certificates requires careful configuration to avoid connection issues or potential vulnerabilities.

### Disabling `ssl_verify`

Disabling `ssl_verify` bypasses SSL certificate verification, which reduces security and is **not recommended** for production environments. However, you can disable it in specific cases, such as testing environments or troubleshooting connectivity issues:

```nginx
mgmt {
    ssl_verify off;
}
```

---

## Troubleshooting

If NGINX Agent and NGINX Instance Manager are having communication issues, follow these steps to troubleshoot:

1. **Check access and error logs**:
    - Make sure access and error logging are enabled to capture detailed information about errors and request processing.
    - By default, both logs are enabled in the `http` block of the main NGINX configuration file:

    ```nginx
    # nginx.conf
    http {
        ...
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        ...
    }
    ```

2. **Check the logs for certificate issues**:
    - Review the logs for any errors related to certificates. Ensure the server is using the correct certificates and Certificate Authority (CA).
