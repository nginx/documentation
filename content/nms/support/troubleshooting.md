---
title: "Troubleshooting Guide"
date: 2021-12-21T12:00:00-07:00
draft: false
description: "This guide explains how to determine, diagnose, and fix issues you might encounter when using Instance Manager."
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["support"]
doctypes: ["reference", "task"]
docs: "DOCS-819"
aliases:
- /nginx-instance-manager/support/troubleshooting/
---

{{< custom-styles >}}

---

## Known Issues {#known-issues}

View the known issues and possible workarounds in the NGINX Management Suite modules:

- [Instance Manager]({{< relref "/nms/nim/releases/known-issues.md" >}})
- [API Connectivity Manager]({{< relref "/nms/acm/releases/known-issues.md" >}})
- [App Delivery Manager]({{< relref "/nms/adm/releases/known-issues.md" >}})
- [Security Monitoring]({{< relref "/nms/security/releases/known-issues.md" >}})

---

## NGINX Management Suite Platform

<details>
<summary>NGINX proxy gateway warns "1024 worker_connections are not enough"</summary>

#### Description

If the NGINX proxy gateway for NGINX Management Suite alerts you that there are not enough worker connections, you may need to modify the NGINX configuration (`/etc/nginx/nginx.conf` on the NGINX Management Suite host) to allow more worker connections and increase the number of file descriptors for worker processes.

#### Resolution

- For guidance on increasing the number of worker connections and file descriptors for the NGINX proxy gateway for NGINX Management Suite, refer to the guide [Optimize NGINX Proxy Gateway for Large Data Planes]({{< relref "/nms/admin-guides/configuration/configure-gateway.md" >}}).

</details>

---

## Instance Manager {#troubleshoot-nim}

<details>
<summary>New NGINX instances don't show up in Instance Manager</summary>

#### Description

After installing NGINX and the NGINX Agent on an instance, the instance is not returned when calling `GET https://hostname/api/platform/v1/systems`.

#### Resolution

The NGINX service must be running **before** you start the NGINX Agent.

- To resolve the issue, try restarting the NGINX Agent:

  ``` bash
  sudo systemctl restart nginx-agent
  ```

</details>

<details>
<summary>(RHEL 8) NGINX doesn't start after upgrading NGINX OSS</summary>

#### Description

In some cases, after upgrading NGINX OSS on RHEL 8, the NGINX service may not start and returns an error similar to the following:

``` text
Job for nginx.service failed because the control process exited with error code.
```

The error log may include entries similar to the following example:

``` text
022/05/12 16:11:23 [emerg] 69688#69688: still could not bind()
22022/05/12 16:18:34 [emerg] 70092#70092: bind() to 0.0.0.0:80 failed (98: Address already in use)
```

#### Resolution

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

</details>

<details>
<summary>Scan reports NGINX versions as `undefined` when NGINX App Protect is enabled</summary>

#### Description

When [scanning for NGINX instances]({{< relref "/nms/nim/how-to/nginx/scan-instances" >}}), the NGINX version is reported as `undefined` when NGINX App protect is installed.

#### Resolution

This behavior is **by design**. As a security precaution when NGINX App Protect is installed, the NGINX server does not report its version in any HTTP headers. The **NGINX Plus** and **Instances** pages in the web interface will continue to report the NGINX and NGINX App Protect versions.

</details>

<details>
<summary>The NGINX Agent does not reconnect after a containerized Instance Manager with no persistent volumes is restarted</summary>

#### Description

If Instance Manager is restarted without any persistent volumes configured, the NGINX Agent won't reconnect automatically.

#### Resolution

When Instance Manager is restarted, its internal API gateway may be assigned a new IP address.

To update the NGINX Agent's configuration with the new Instance Manager IP address, run the NGINX Agent with the `--server-host` CLI parameter or edit the `nginx-agent.conf` file. Using the `--server-host` CLI parameter will ensure that the setting persists across restarts.

To learn more, refer to the [NGINX Agent documentation]({{< relref "/nms/nginx-agent/install-nginx-agent.md#nginx-agent-cli-flags-usage" >}}).

</details>

<details>
<summary>"Public Key Not Available" error when upgrading Instance Manager on a Debian-based system</summary>

#### Description

When attempting to upgrade Instance Manager on a Debian-based system, the command `sudo apt-get update` may return the error “public key is not available,” preventing the NGINX Agent from being updated. To resolve this issue, you need to update the public key first.

#### Workaround

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

</details>


---

## API Connectivity Manager {#troubleshoot-acm}

<details>
<summary>System returns `403 Forbidden` errors when users try accessing authorized resources</summary>

#### Description

Users are unable to access ACM features that they've been granted permission for.

The system returns errors similar to the following examples:

- Web interface error: "ACM license not found."

- API error: "Error accessing resource: forbidden. Please contact the system administrator. User has not been granted `READ` permission."

#### Resolution

New roles require a minimum of `READ` access for the **Licensing** feature. Without `READ` access for **Licensing**, users will be unable to access pages for which they have been granted permission; instead, the system will return `403 Forbidden` errors as licensing errors.

</details>

<details>
<summary>After installing ACM, the module doesn't show up in the NMS web interface</summary>

#### Description

After installing the API Connectivity Manager module, the module doesn't appear in the NGINX Management Suite web interface.

#### Resolution

- Force refresh the web page.
- Restart the ACM service:

  ```bash
  sudo systemctl restart nms-acm
  ```

</details>

<details>
<summary>Can't delete ACM objects after upgrading NGINX instances</summary>

#### Description

After upgrading NGINX Plus instances to R27, you may not be able to delete Environments, Proxies, or Dev Portals in the API Connectivity Manager module.

#### Resolution

Try restarting the NGINX Agent after upgrading NGINX. 

- To restart the NGINX Agent, run the following command:

  ``` bash
  sudo systemctl restart nginx-agent
  ```

</details>

## Security Monitoring {#troubleshoot-sm}

<details>
<summary>Security Event log backup with Security Monitoring</summary>

#### Description

If a Security Violation event is not received by the Security Monitoring module, the data representing the attack is lost.

#### Resolution

NGINX App Protect supports logging to multiple destinations, enabling the user to send a log to NGINX agent and a copy to be stored as a backup. In the event of a failure to receive Security Events in Security Monitoring, the backup log can be checked to verify attack details. Change the settings below to enable backup logging:

1. Instance with Security Monitoring only

```nginx
app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json";
app_protect_security_log_enable on;
app_protect_security_log "/etc/app_protect/conf/log_sm.json" syslog:server=127.0.0.1:514;
app_protect_security_log "/etc/app_protect/conf/log_sm.json" <Path to store log file>;
# Example: app_protect_security_log "/etc/app_protect/conf/log_sm.json" /var/log/app_protect/security.log;
```
1. Instance with Security Monitoring and Instance Manager

```nginx
app_protect_policy_file "/etc/nms/NginxDefaultPolicy.tgz";
app_protect_security_log_enable on;
app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
app_protect_security_log "/etc/nms/secops_dashboard.tgz" <Path to store log file>;
# Example: app_protect_security_log "/etc/nms/secops_dashboard.tgz" /var/log/app_protect/security.log;
```

</details>

---

## Check Installed Module Version {#check-module-version}

{{< include "nms/look-up-version.md" >}}
