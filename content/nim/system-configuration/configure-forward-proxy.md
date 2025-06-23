---
Title: Use a third-party forward proxy
weight: 2
toc: true
type: how-to
product: NIM
docs:
---

## Overview

This guide explains how to configure NGINX Instance Manager to use a third-party forward proxy for outbound internet access. Many organizations require a proxy for security and compliance, restricting direct internet connections. This feature allows NGINX Instance Manager to send outbound traffic, such as license verification, telemetry, and updates, through a configured HTTP or HTTPS proxy.

---

## Before you begin

Ensure you have:

- NGINX Instance Manager **2.19 or later**
- Access to a configured HTTP or HTTPS forward proxy
- Permissions to modify `/etc/nms/nms.conf`
- Proxy authentication credentials, if required

{{<call-out "note" "Important considerations:" "">}}
#### Proxy SSL verification

- `proxy_ssl_verify` applies **only when** `proxy_protocol` is set to `https`.
- If not explicitly set, **`proxy_ssl_verify` defaults to `true`**. The proxy’s root CA certificate must be in the system’s trusted CA store for verification to succeed.
- To disable SSL verification, set `proxy_ssl_verify: false` (not recommended).

#### OpenShift limitation for HTTPS forward proxies

On OpenShift, pods run as non-root users, which prevents the use of `update-ca-certificates` or `update-ca-trust` to add custom CA certificates for HTTPS forward proxies. As a result, HTTPS proxy configurations (with or without authentication) may not work if the proxy requires a trusted CA certificate.

**Workarounds:**
- **Recommended**: Use an HTTP proxy instead of HTTPS.
- **Alternative (not recommended)**: Disable certificate verification by setting `proxy_ssl_verify: false`, which allows connections to proxies with untrusted or self-signed certificates.

#### Feature limitations

- **Mutual TLS (mTLS) authentication is not supported.**
- **OpenID Connect (OIDC) authentication is not supported in forward-proxy mode.**
- **OpenTelemetry (OTel) telemetry is not supported in forward-proxy mode.**
{{</call-out>}}

---

## Proxy configuration parameters

The following table describes the available proxy configuration parameters in `/etc/nms/nms.conf`:

{{<bootstrap-table "table table-striped table-bordered">}}
| Parameter              | Description |
|------------------------|-------------|
| `proxy_enable`        | Defines whether NGINX Instance Manager routes outbound traffic through a forward proxy. <br> **Supported values:** `true` (routes certain outbound requests through the proxy) or `false` (sends data directly to servers). |
| `proxy_host`          | IP address of the third-party forward proxy. |
| `proxy_port`          | Port on which the third-party proxy is running. |
| `proxy_protocol`      | Protocol used to interact with the proxy. <br> **Supported values:** `http`, `https`. |
| `proxy_auth_required` | Determines whether authentication is enforced for proxy access. <br> **Supported values:** `true` (proxy requires authentication) or `false` (proxy does not require authentication). |
| `proxy_username`      | Username for authentication with the proxy (if `proxy_auth_required: true`). |
| `proxy_password`      | Password for authentication with the proxy (if `proxy_auth_required: true`). |
| `proxy_ssl_verify`    | Controls SSL certificate verification when `proxy_protocol` is `https`. <br> **Default value:** `true`. <br> **Supported values:** `true` (only trusted proxies allowed) or `false` (allows untrusted/self-signed certificates). |
{{</bootstrap-table>}}

---

## Configure the forward proxy

### VM or bare-metal

In a VM or bare-metal deployment, configure a forward proxy by updating the `nms.conf` file on the NGINX Instance Manager host.

To configure a forward proxy:

1. Edit the `/etc/nms/nms.conf` file.

2. Add or modify the `proxy_config` section to include the proxy configuration:

    ```yaml
    proxy_config:
        proxy_enable: true
        proxy_host: <proxy-ip>
        proxy_port: <proxy-port>
        proxy_protocol: [http|https]
        proxy_auth_required: [true|false]
        proxy_ssl_verify: [true|false]
    ```

   - If the proxy requires authentication, set `proxy_auth_required` to `true`, and add the following fields:

        ```yaml
           proxy_username: "<username>"
           proxy_password: "<password>"
        ```

   - Set `proxy_protocol` to either `http` or `https`, depending on your proxy type.
   - If not explicitly set, `proxy_ssl_verify` **defaults to `true`**, meaning the proxy must have a valid certificate from a trusted Certificate Authority (CA). Note: This setting applies only when `proxy_protocol` is `https`.

     If the proxy uses a self-signed or untrusted certificate, you have two options:
       - **Recommended**: Follow the steps in the [Trust proxy certificates](#trust-proxy-certificates-if-required) section to add the proxy's CA certificate to the system's trusted store.
       - **Alternative (not recommended)**: Disable SSL verification by setting `proxy_ssl_verify=false`, which allows connections to proxies with untrusted or self-signed certificates.

3. Save the configuration file.

4. Restart NGINX Instance Manager to apply changes:

     ```shell
     sudo systemctl restart nms
     ```

### Kubernetes

In a Kubernetes deployment, configure a forward proxy by modifying the `nms-conf` ConfigMap.

To edit the ConfigMap, run:

```shell
kubectl edit cm nms-conf -n <namespace>
```

- Replace `<namespace>` with the namespace where NGINX Instance Manager is installed.
- Update the `proxy_config` section to match your proxy settings. See the [examples under "Configure the forward proxy"](#configure-the-forward-proxy).

### Docker Compose

If you’re deploying NGINX Instance Manager with Docker Compose, update the `docker-compose.yaml` file to configure a forward proxy.

1. **Before you begin**: Follow the [Docker Compose deployment guide]({{< ref "nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}) to set up Docker for the NGINX container registry. The deployment guide also covers additional environment variables you may want to consider before deployment.
2. {{< icon "download">}} {{<link "/scripts/docker-compose/docker-compose.yaml" "Download the preconfigured docker-compose.yaml file">}}
3. Update `docker-compose.yaml` with the proxy settings:

    Modify the `services.nim.environment` section to include the proxy configuration:

    ```yaml
    services:
      nim:
      image: private-registry.nginx.com/nms/nim-standalone-compose:<version>
      depends_on:
        clickhouse:
          condition: service_healthy
      hostname: nim
      ports:
        - 443:443
      networks:
        - external_network
        - clickhouse
      environment:
        - PROXY_ENABLE=true
        - PROXY_HOST=<proxy-ip>
        - PROXY_PORT=<proxy-port>
        - PROXY_PROTOCOL=[http|https]
        - PROXY_AUTH_REQUIRED=[true|false]
        - PROXY_SSL_VERIFY=[true|false]
     volumes:
        - nim-data:/data
        - proxy-certs:/usr/local/share/ca-certificates
        - ./<proxy-ca-cert-file>:/usr/local/share/ca-certificates/<proxy-ca-cert-file>
    ```

    - If the proxy requires authentication, set `PROXY_AUTH_REQUIRED` to `true`, and add the following fields:


        ```yaml
            - PROXY_AUTH_USERNAME=<username>
            - PROXY_PASSWORD=<password>
        ```

    - Replace `<proxy-ca-cert-file>` with the filename of the proxy CA certificate.
    - Set `PROXY_PROTOCOL` to either `http` or `https`, depending on your proxy type.
    - If not explicitly set, **`PROXY_SSL_VERIFY` defaults to `true`**, meaning the proxy must have a valid certificate issued by a trusted Certificate Authority (CA). Note: This setting applies only when `PROXY_PROTOCOL` is `https`.

      If the proxy uses a self-signed or untrusted certificate, you have two options:
      - **Recommended**: Follow the steps in the [Trust proxy certificates](#trust-proxy-certificates-if-required) section to add the proxy's CA certificate to the system's trusted store.
      - **Alternative (not recommended)**: Disable SSL verification by setting `PROXY_SSL_VERIFY=false`, which allows connections to proxies with untrusted or self-signed certificates.


4. Deploy NGINX Instance Manager:

    ```shell
    docker compose up -d
    ```

---

## Trust proxy certificates (if required)

If your proxy uses HTTPS and `proxy_ssl_verify` is set to `true`, NGINX Instance Manager expects the proxy’s CA certificate to be trusted. If the proxy certificate is self-signed or issued by an untrusted Certificate Authority (CA), you must manually add it to the system’s trusted store.

{{< call-out "note" >}}For Kubernetes deployments, perform these steps inside the **integrations pod**.{{< /call-out >}}

1. Copy the proxy CA certificate into the system’s trusted certificate directory. The path varies by distribution:
   - **Debian/Ubuntu**: `/usr/local/share/ca-certificates/`
   - **RHEL/CentOS**: `/etc/ssl/certs/`

2. Run the appropriate command to update the system’s trusted certificates:

   - **Debian/Ubuntu**:

     ```bash
     sudo update-ca-certificates
     ```

   - **RHEL/CentOS**:

     ```bash
     sudo update-ca-trust
     ```

3. Apply the changes:

    - **VM/bare-metal**: Restart NGINX Instance Manager:

       ```bash
       sudo systemctl restart nms
       ```

    - **Kubernetes**: Restart the **integrations pod**.

---

## Verify proxy connectivity

After applying the configuration, verify that NGINX Instance Manager is using the proxy:

- **Check system logs:** Review logs for messages confirming that traffic is being routed through the proxy. The exact log message may vary but should indicate the configured proxy details.

- **Test outbound connectivity:** Use a tool such as `curl` or `wget` to confirm that requests are routed through the proxy. The exact command depends on your proxy configuration.

- **Monitor network traffic:** If needed, use network debugging tools like `tcpdump` or `netstat` to verify that outbound requests are sent through the proxy.

If proxy traffic is not working as expected, review the [troubleshooting section](#troubleshoot-common-issues) for possible causes.

---

## Troubleshoot common issues

{{<bootstrap-table "table table-striped table-bordered">}}
| **Issue** | **Log Message** | **Possible Cause** | **Resolution** |
|-----------|---------------|---------------------|--------------|
| **Authentication failed** | N/A | Incorrect proxy credentials. | Double-check `proxy_username` and `proxy_password`. |
| **Invalid proxy configuration** | `Error: failed to initialize LLM:` <br> `invalid forward proxy config: <reason>` | The proxy configuration section is missing or improperly formatted. | - Ensure the proxy configuration is correct in `/etc/nms/nms.conf`. <br> - Verify all required parameters (`proxy_enable`, `proxy_host`, `proxy_port`, `proxy_protocol`) are set. |
| **Proxy initialization failure** | `unable to add proxy support,` <br> `err - <err>` | The proxy settings are misconfigured, or the proxy service is unavailable. | - Ensure that the proxy service is running and accessible. <br> - Verify that `proxy_enable` is set to `true` and all required parameters are correctly configured. |
| **Proxy not reachable** | N/A | Incorrect proxy IP or port. | Verify `proxy_host` and `proxy_port` in `/etc/nms/nms.conf`. |
| **TLS certificate verification error** | `proxyconnect tcp: tls:` <br> `failed to verify certificate:` <br> `x509: certificate signed by unknown authority` | SSL verification is enabled (default), but the proxy certificate is untrusted. | - Add the proxy’s CA certificate to the system’s trusted CA store. <br> - If necessary, disable SSL verification by setting proxy SSL verify to false (not recommended). |
{{</bootstrap-table>}}
