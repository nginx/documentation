---
docs: DOCS-794
doctypes:
- tutorial
tags:
- docs
title: Secure Client Access and Network Traffic
toc: true
weight: 600
---

This document provides guidance on securing client connections to NGINX Management Suite as well as securing the traffic between the NGINX Management Suite management plane and NGINX data planes.

{{< shortversions "2.0.0" "latest" "nimvers" >}}
## Overview

{{< important >}}A management server should **NEVER** be exposed to the public internet. You can mitigate exposure with the settings described here, but these are not a substitute for preventing unneeded exposure.{{< /important >}}

{{< see-also >}}For instructions on configuring TLS settings for the NGINX Agent, refer to the [NGINX Agent TLS Settings](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/) guide.{{< /see-also >}}

## NGINX Proxy SSL Termination

Configure the SSL certificate and key inside the NGINX configuration. For instructions, refer to the [NGINX SSL Termination](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-http/) guide.

### SSL Termination for NGINX OSS

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

## Mutual Client Certificate Auth Setup (mTLS)

Using client certificates unique to each endpoint allows you to secure and authorize NGINX instances with NGINX Management Suite. You can run NGINX as a proxy to offload client cert handling.

Use PKI methods to secure your enterprise. Refer to the following instructions for guidance.

Generate a private Certificate Authority (CA) for all the methods described below. The CA can be on the NGINX Management Suite host for testing. For production, follow your organization's standards (typically an offline machine without network connections).

The root CA provides a certificate for an intermediate CA, which should be secured. The root CA (or intermediate CA) issues client and server certificates. The CA (either root or intermediate) signs certificate signing requests (CSRs) and issues certificates. The following examples assume you have the following components setup:

1. NGINX Management Suite
2. NGINX instance with NGINX Agent installed

### Generate Certificates

Modify the following example according to your needs. There are many ways to generate certificates; these examples are suggestions.

1. Install OpenSSL, if you haven't done so already.
2. Use a script similar to the following example to set up the certificates you need. Save this script as `make_certs.sh`.

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
        echo "Creating nginx-manger certificate and key"
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

3. Put the following OpenSSL `.cnf` files in the same directory.

    <details>
        <summary>ca.cnf</summary>

    {{<fa "download">}} {{<link "/admin/encrypt/ca.cnf" "ca.cnf">}}

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

4. Make the script executable and then run the script to generate the certificates.

    ```bash
    sudo chmod +x ./make_certs.sh
    sudo ./make_certs.sh
    ```

5. Copy the `ca.pem`, `agent.crt`, and `agent.key` to the NGINX instance where the NGINX Agent certs are installed.

    ```bash
    sudo mkdir -p /etc/nms/certs
    sudo cp ca.pem /etc/nms/certs/
    sudo cp agent.crt /etc/nms/certs/
    sudo cp agent.key /etc/nms/certs/
    ```

6. Modify the `nginx-agent.conf` file to resemble the following example. Note the TLS options that are configured. The specified cert and key tell the NGINX Agent to use client cert authentication with the NGINX proxy on the NGINX Management Suite. The `ca.pem` is included as the certificate authority that the agent will use to verify the NGINX Management Suite's server certificate. If the CA is trusted by the OS, you can omit the ca option. Update the server `host` to the NGINX Management Suite address.

    {{< see-also >}}For additional information about TLS configurations for the NGINX Agent, refer to the [NGINX Agent TLS Settings](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/) topic. {{< /see-also >}}

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

7. Copy the `ca.pem`, `server.crt`, and `server.key` to the NGINX Management Suite.

    ```bash
    sudo cp ca.pem /etc/nms/certs/
    sudo cp server.crt /etc/nms/certs/
    sudo cp server.key /etc/nms/certs/
    ```

8. Add a new server to the NGINX proxy for gRPC in the NGINX Management Suite config with the newly generated certs, then reload the service. The `server_name` should match the `server.metrics` value and the `server.command` values in the `nginx-agent.conf`. You can remove the  `MetricsService` and `Commander` locations from the existing server.
The new server will enforce mTLS communication between the NGINX Agent and NGINX Management Suite. The previous server can continue to serve static content for the web interface and API without the requirements of mTLS.
When `tls.skip_verify` is set to `false`, the NGINX Agent verifies the server's certificate chain and hostname. The `server_name` in the config must match the generated cert's Common Name (CN) or Subject Alt Name (SAN).

    ```nginx
    # gRPC HTTPS server, needs port 443
    server {
        listen 443 ssl;
        http2  on;
        root   /var/www/nms;

        server_name nginx-manager.example.com;

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

10. Reload the NGINX proxy configuration.

    ```bash
    sudo nginx -s reload
    ```

11. Start or restart the NGINX Agent.

    ```bash
    sudo systemctl restart nginx-agent
    ```

Now, the NGINX Agent and NGINX Management Suite should be using secure, mutual TLS connectivity.

---

## Troubleshooting

If the NGINX Agent and NGINX Management Suite have issues communicating, take the following steps to troubleshoot the problem.

1. Verify access and error logging are enabled to capture detailed information about errors and request processing in log files.

    The access log and error log are enabled by default in the `http` directive in the main NGINX configuration file:

    ``` nginx
    # nginx.conf
    http {
        ...
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        ...
    }
    ```

2. Check the log files for certificate errors. Ensure the server uses the correct certs and Certificate Authority (CA).
