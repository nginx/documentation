---
description: This topic describes possible issues users might encounter when using
  Instance Manager. When possible, suggested workarounds are provided.
docs: DOCS-1224
title: Troubleshooting
toc: true
weight: 1000
draft: true
type:
- reference
---

## New NGINX instances don't show up in Instance Manager

### Description

After installing NGINX and the NGINX Agent on an instance, the instance is not returned when calling `GET https://hostname/api/platform/v1/systems`.

### Resolution

The NGINX service must be running **before** you start the NGINX Agent.

- To resolve the issue, try restarting the NGINX Agent:

  ``` bash
  sudo systemctl restart nginx-agent
  ```

---

## (RHEL 8) NGINX doesn't start after upgrading NGINX OSS

### Description

In some cases, after upgrading NGINX OSS on RHEL 8, the NGINX service may not start and returns an error similar to the following:

``` text
Job for nginx.service failed because the control process exited with error code.
```

The error log may include entries similar to the following example:

``` text
022/05/12 16:11:23 [emerg] 69688#69688: still could not bind()
22022/05/12 16:18:34 [emerg] 70092#70092: bind() to 0.0.0.0:80 failed (98: Address already in use)
```

### Resolution

Ensure there isn't a process bound to port `80` or `443`.

1. To stop processes bound to ports `80` and `443`, run the following commands:

    ```bash
    sudo fuser -k 80/tcp
    sudo fuser -k 443/tcp
    ```

2. Restart the NGINX service:

    ```bash
    sudo service nginx restart
    ```

---

## Scan reports NGINX versions as `undefined` when NGINX App Protect is enabled

### Description

When [scanning for NGINX instances]({{< ref "/nim/nginx-instances/scan-instances" >}}), the NGINX version is reported as `undefined` when NGINX App protect is installed.

### Resolution

This behavior is **by design**. As a security precaution when NGINX App Protect is installed, the NGINX server does not report its version in any HTTP headers. The **NGINX Plus** and **Instances** pages in the web interface will continue to report the NGINX and NGINX App Protect versions.

---

## The NGINX Agent does not reconnect after a containerized Instance Manager with no persistent volumes is restarted

### Description

If Instance Manager is restarted without any persistent volumes configured, the NGINX Agent won't reconnect automatically.

### Resolution

When Instance Manager is restarted, its internal API gateway may be assigned a new IP address.

To update the NGINX Agent's configuration with the new Instance Manager IP address, run the NGINX Agent with the `--server-host` CLI parameter or edit the `nginx-agent.conf` file. Using the `--server-host` CLI parameter will ensure that the setting persists across restarts.

To learn more, refer to the [NGINX Agent documentation]({{< ref "/nms/nginx-agent/install-nginx-agent.md#nginx-agent-cli-flags-usage" >}}).

---

## "Public Key Not Available" error when upgrading Instance Manager on a Debian-based system

### Description

When attempting to upgrade Instance Manager on a Debian-based system, the command `sudo apt-get update` may return the error “public key is not available,” preventing the NGINX Agent from being updated. To resolve this issue, you need to update the public key first.

### Workaround

To manually update the public key, take the following steps:

1. Download a new key from the NGINX Management Suite host:

   - Secure:

       ```shell
       curl https://<NMS_FQDN>/packages-repository/nginx-signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-signing.gpg >/dev/null
       ```

   - Insecure:

       ```shell
       curl --insecure https://<NMS_FQDN>/packages-repository/nginx-signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-signing.gpg >/dev/null
       ```

2. Update the `nginx-agent.list` file to reference the new key:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-signing.gpg] https://<NMS_FQDN>/packages-repository/deb/ubuntu `lsb_release -cs` agent\n" | sudo tee /etc/apt/sources.list.d/nginx-agent.list
    ```

---

## Publishing to an instance or instance group returns error "outside the allowed directory list"

### Description

If an instance or instance group's configuration references an aux file (for example, an SSL certificate) that is not in the expected allowed directory, publishing the config will fail. The same can happen when a certificate is assigned a file path outside the allowed directory. In both cases, the system returns an error similar to the following:

```text
Config apply failed (write): the file <filename> is outside the allowed directory list.
```

### Resolution

For a failure when publishing of a configuration, move the aux file to the allowed directory and update the configuration; for example, use `/etc/nginx/` for certificates.

For a failure when publishing a certificate to an instance or instance group, ensure the assigned file paths are set to the allowed directory; for example, use `/etc/nginx`.

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}

