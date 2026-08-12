---
f5-docs: DOCS-937
type: reference
title: Known issues
toc: true
weight: 2
f5-product: F5 NGINX Instance Manager
f5-content-type: reference
description: "Known issues and possible workarounds for F5 NGINX Instance Manager, with issue IDs and conditions under which they occur."
f5-summary: >
  Look up known issues in F5 NGINX Instance Manager and find workarounds where available.
  Issues are listed by ID with the affected version, a description of the problem, and any available workaround.
---

This document lists and describes the known issues and possible workarounds in F5 NGINX Instance Manager. We also list the issues resolved in the latest releases.

{{< call-out class="tip" >}}We recommend you upgrade to the latest version of NGINX Instance Manager to take advantage of new features, improvements, and bug fixes.{{< /call-out >}}

## 2.22.2

July 17, 2026

### {{% icon-bug %}} Mutual TLS is disabled by default {#47465}

| Issue ID       | Status |
|----------------|--------|
| 47465 | Open  |

#### Description

Mutual TLS, or mTLS, client certificate verification for NGINX Agent and internal service connections is off by default.

This change simplifies first-time deployments. If you need mTLS, follow the steps below to turn it back on.

How to re-enable mTLS for NGINX Agent and internal service connections:

- VM or package-based installation

    File: `/etc/nginx/conf.d/nms-http.conf`

    1. Re-enable client certificate loading and verification in the `server` block.

        Locate the `server { listen 443 ssl http2; }` block, then uncomment `ssl_client_certificate` and change `ssl_verify_client` from `off` to `optional` or `on`.

        ```nginx
        ssl_certificate /etc/nms/certs/manager-server.pem;
        ssl_certificate_key /etc/nms/certs/manager-server.key;
        ssl_client_certificate /etc/nms/certs/ca.pem;

        ssl_verify_client optional;
        ```

        Use `ssl_verify_client optional` if some agents may not present a certificate. Use `ssl_verify_client on` to reject connections without a valid certificate.

    2. Enable mTLS enforcement on gRPC agent endpoints.

        In the gRPC location blocks for agent connections, `/f5.nginx.agent.sdk.MetricsService` and `/f5.nginx.agent.sdk.Commander`, uncomment the `auth_request` directive.

        ```nginx
        location /f5.nginx.agent.sdk.MetricsService {
            auth_request /check-agent-client-cert;
            grpc_pass grpc://ingestion-grpc-service;
            ...
        }

        location /f5.nginx.agent.sdk.Commander {
            auth_request /check-agent-client-cert;
            grpc_pass grpc://dpm-grpc-service;
            ...
        }
        ```

        The internal `/check-agent-client-cert` location rejects any agent that does not present a certificate validated by the CA in `ca.pem`.

    3. Optionally enable `proxy_ssl` for internal service communication.

        If your deployment routes internal NGINX Instance Manager services over TCP instead of Unix sockets, turn on TLS for the proxy connections inside the `/api` location.

        ```nginx
        location /api {
            proxy_ssl_trusted_certificate /etc/nms/certs/ca.pem;
            proxy_ssl_certificate /etc/nms/certs/manager-client.pem;
            proxy_ssl_certificate_key /etc/nms/certs/manager-client.key;
            proxy_ssl_verify on;
            proxy_ssl_name platform;
            proxy_ssl_server_name on;

            proxy_pass https://$mapped_upstream;
            ...
        }
        ```

    4. Reload NGINX.

    ```shell
    sudo nginx -t && sudo systemctl reload nginx
    ```

- Kubernetes (Helm) installation

    File: `k8s/charts/generated/nms-http.conf`

    (This file is generated from Helm templates. Configure it through `values.yaml`, not by editing the generated file directly.)

    1. Enable mTLS enforcement in Helm values.

        In `values.yaml`, set:

        ```yaml
        agent:
        secure: true
        ```

        This flag controls the conditional `auth_request /check-agent-client-cert;` directive in both gRPC agent location blocks, `/f5.nginx.agent.sdk.MetricsService` and `/f5.nginx.agent.sdk.Commander`.

    2. Re-enable client certificate loading and verification in the `server` block.

        After rendering with Helm, or in the generated `nms-http.conf`, locate the `server` block that listens on `8443`, then apply the following settings:

        ```nginx
        ssl_client_certificate /etc/nms/certs/ca.pem;
        ssl_verify_client optional;
        ```

        The CA certificate must be the same CA that signed the agent client certificates.

    3. Verify internal TLS.

        In Kubernetes, internal service-to-service communication already uses TLS with `proxy_pass https://...` and `grpc_pass grpcs://...`. The platform handles internal certificate management, so no additional changes are needed.

    4. Apply the Helm upgrade.

        ```shell
        helm upgrade <release-name> <chart-path> -f values.yaml
        ```

---

## 2.22.0

April 28, 2026

### {{% icon-bug %}} Custom users can't access security log profile objects {#47286}

| Issue ID       | Status |
|----------------|--------|
| 47286 | Open  |

#### Description

Custom users can't perform any actions on the **Security Log Profiles** tab.

---

### {{% icon-bug %}} NATS messages flush slowly after switching to connected mode {#47287}

| Issue ID       | Status |
|----------------|--------|
| 47287 | Open  |

#### Description

When NGINX Instance Manager switches from disconnected to connected mode, NATS messages flush very slowly, processing one message at a time.

---

## 2.21.0

November 07, 2025

### {{% icon-bug %}} Duplicate security policies appear during RBAC role creation when an F5 WAF for NGINX policy has more than one version {#46754}

| Issue ID       | Status |
|----------------|--------|
| 46754 | Open  |

#### Description

If an F5 WAF for NGINX policy has more than one version, the same policy name may appear more than once when you’re assigning access during RBAC role creation. This happens because the system doesn’t show which version is which.

---

### {{% icon-resolved %}} Security Monitoring dashboard doesn't load for custom users {#46763}

| Issue ID       | Status |
|----------------|--------|
| 46763 | Open  |

#### Description

When you sign in using a custom user account that has:

- read permissions for Security Monitoring
- create, read, update, and delete (CRUD) permissions for Security Policies

the Security Monitoring dashboard shows the message:  **Metrics are disabled**

This happens even when ClickHouse is enabled.

#### Workaround

Add license read permission to the custom role or user.  This allows the Security Monitoring dashboard to complete its license check and load as expected.

---

### {{% icon-resolved %}} Usage reporting shows higher values than actual consumption {#46867}

| Issue ID       | Status |
|----------------|--------|
| 46867 | Fixed in Instance Manager 2.21.1  |

#### Description

The reported usage in NGINX Instance Manager can be higher than the actual consumption.

---

## 2.20.0

June 16, 2025

### {{% icon-resolved %}} Failing to fetch CVE data when using forward proxy in K8s environments {#46177}

| Issue ID       | Status |
|----------------|--------|
| 46177 | Fixed in Instance Manager 2.21.0  |

#### Description

Fetching latest CVE data from internet might fail if you enable "ssl_verify" in Kubernetes environments.

#### Workaround

1. Switch to the offline CVE database. To switch add the property "offline_nginx_cve: true" under the DPM section in the "nms.conf" file.

   ```cfg
   dpm:
       offline_nginx_cve: true
   ```

2. Download the latest security advisories file from the [nginx.org repository](https://raw.githubusercontent.com/nginx/nginx.org/main/xml/en/security_advisories.xml) and save them with "cve.xml" as filename in "/usr/share/nms/cve.xml”
3. Restart the `nms` service.

   ```shell
   sudo systemctl restart nms
   ```

After the restart you will see the line “loading CVE data from file” in the "nms.log" file.

---

### {{% icon-bug %}} NGINX configuration editor shows errors for instance group configs created with augment templates {#46726}

| Issue ID       | Status |
|----------------|--------|
| 46726 | Won't be resolved  |

#### Description

The NGINX configuration editor may show errors for files in the `conf.d` directory when a configuration created with augment templates is published to an instance group. The configuration is valid, but the editor doesn’t recognize all template-generated files.

#### Workaround

To avoid this issue, use a standalone `nginx.conf` file instead of augment templates when publishing to instance groups.

---

## 2.19.1

March 27, 2025

### {{% icon-resolved %}} The certificate stats are not displayed correctly in the Certificates and Keys page as well as the Dashboard page. {#45991}

| Issue ID       | Status |
|----------------|--------|
| 45991 | Fixed in Instance Manager 2.20.0  |

#### Description

When the dashboard page and certificates page are loaded, the count displayed for total, valid, expired, expires soon, managed and unmanaged are incorrect.

#### Workaround

The changes required have been made and the UI displays the values correctly now. Pagination also works well along with the certificate stats.

---

## 2.17.0

July 10, 2024

### {{% icon-bug %}} Failure to retrieve instance configuration when NAP-enabled instance doesn't register properly {#45113}

| Issue ID       | Status |
|----------------|--------|
| 45113 | Open  |

#### Description

If NGINX Agent is configured to monitor NGINX App Protect before App Protect is installed, NGINX Agent will send an empty App Protect metadata structure to NGINX Instance Manager. This causes Instance Manager to fail to register the NGINX instance properly.

#### Workaround

Edit the "/etc/nginx-agent/nginx-agent.conf" file and configure "precompiled_publication" as "false". Then restart the nginx-agent process running `sudo systemctl restart nginx-agent`.

---

### {{% icon-bug %}} Web Analytics are not enabled after upgrading Instance Manager when keeping existing nms-http.conf {#45131}

| Issue ID       | Status |
|----------------|--------|
| 45131 | Open  |

#### Description

When using NGINX Instance Manager, you configure OIDC by manually editing the /etc/nginx/conf.d/nms-http.conf and /etc/nms/nms.conf files.

During the upgrade to 2.17.0, the user is asked if they would like to keep their own nms-http.conf, or replace it with the new default. As Web Analytics are enabled via the /etc/nginx/conf.d/nms-http.conf file, if a user decides to keep their own config when prompted during upgrade, these will not get enabled.

#### Workaround

To keep the existing nms-http.conf file while maintaining the web analytics functionality, add the following to "/etc/nginx/conf.d/nms-http.conf" , inside the `/ui` location block:

```text
add_header Content-Security-Policy "default-src 'none'; block-all-mixed-content; frame-ancestors 'self'; object-src 'none'; manifest-src 'self'; script-src 'self' https://*.walkme.com 'unsafe-inline' 'unsafe-eval'; style-src 'self' https://*.walkme.com fonts.googleapis.com 'unsafe-inline'; img-src 'self' https://*.walkme.com s3.walkmeusercontent.com d3sbxpiag177w8.cloudfront.net data:; font-src 'self' https://*.walkme.com data: https://fonts.gstatic.com; connect-src 'self' https://*.walkme.com; frame-src 'self' https://*.walkme.com blob:; worker-src 'self' blob: https://*.walkme.com;";
```

---

## 2.15.0

December 12, 2023

### {{% icon-bug %}}   Licenses for NGINX Plus applied prior to Instance Manager 2.15 don't show the full feature set {#44685}

| Issue ID       | Status |
|----------------|--------|
| 44685 | Open  |

#### Description

With the introduction of Instance Manager 2.15, we are expanding the features available for some licenses, such as those with only NGINX Plus entitlement. If such a license was applied before upgrading to 2.15, the expanded set of features will not be available as intended.

#### Workaround

Terminate the license applied previously. Re-apply the license.

---

### {{% icon-bug %}} Some NGINX Management Suite features not available after adding license {#44698}

| Issue ID       | Status |
|----------------|--------|
| 44698 | Open  |

#### Description

After adding a license, some NGINX Management Suite features might be disabled, even if they are included in the license.

#### Workaround

Restart NGINX Management Suite to make all the features available for use. To restart NGINX Management Suite, open a terminal on the host and run the command:

```shell
sudo systemctl restart nms
```

---

## 2.14.0

October 16, 2023

### {{% icon-bug %}} Built-in security policies may not be accessible {#44520}

| Issue ID       | Status |
|----------------|--------|
| 44520 | Open  |

#### Description

Users might not have permission to access the built-in policies (NginxDefaultPolicy and NginxStrictPolicy) while using NGINX Management Suite.

#### Workaround

Use RBAC to assign the following permissions to the user:
- (At minimum) READ access to any other custom security policy
or
- READ access to the security policy feature: `/api/platform/v1/security/policies`

---

### {{% icon-bug %}} Certain instances not showing in the Network Utilization drawer {#44547}

| Issue ID       | Status |
|----------------|--------|
| 44547 | Open  |

#### Description

Under certain conditions, instances that are not reporting request totals may not show in the Network Utilization panel or drawer when data is sorted by Request count. This typically happens when NGINX is not configured to stream metrics data to NGINX Agent.

#### Workaround

Configure NGINX Plus or NGINX Stub Status APIs to send correctly the NGINX metrics using NGINX Agent. See the [Metrics]({{< ref "nim/monitoring/overview-metrics.md" >}}) documentation to learn more.

---

### {{% icon-bug %}} Scan results may not include CVE count with App Protect installed {#44554}

| Issue ID       | Status |
|----------------|--------|
| 44554 | Open  |

#### Description

When using the Scan feature, the CVE column may provide a value of '--' for instances running specific versions of NGINX App Protect, including App Protect 4.4 and potentially others.

---

## 2.13.0

August 28, 2023

### {{% icon-bug %}} Inaccurate Attack Signatures and Threat Campaigns versions {#43950}

| Issue ID       | Status |
|----------------|--------|
| 43950 | Open  |

#### Description

If `precompiled_publication` is set to `true`, NGINX Management Suite may incorrectly report the version of Attack Signatures (AS) and Threat Campaigns (TC) that you previously installed on the NAP WAF instance.

---

### {{% icon-bug %}} If you publish a configuration with an uncompiled policy, it will fail the first time {#44267}

| Issue ID       | Status |
|----------------|--------|
| 44267 | Open  |

#### Description

In Instance Manager 2.13, a new configuration is published before the compile stage of a WAF policy is complete. This happens only when the policy is first referenced. This leads to a deployment failure, and the configuration rolls back. Typically, by the time you try to submit the configuration again, the policy has finished compiling, and the request goes through.

The initial failure message looks like this:

```text
Config push failed - err: failure from multiple instances. Affected placements: instance/70328a2c-699d-3a90-8548-b8fcec15dabd (instance-group: ig1) - err: failed building config payload: config: aux payload /etc/nms/NginxDefaultPolicy.tgz for instance:70328a2c-699d-3a90-8548-b8fcec15dabd not ready aux payload not ready, instance/2e637e08-64b3-36f9-8f47-b64517805e98 (instance-group: ig1) - err: failed building config payload: config: aux payload /etc/nms/NginxDefaultPolicy.tgz for instance:2e637e08-64b3-36f9-8f47-b64517805e98 not ready aux payload not ready
```

#### Workaround

Retry pushing the new configuration. The deployment should work the second time around.

---

## 2.11.0

June 12, 2023

### {{% icon-bug %}} Updating Attack Signatures or Threat Campaigns on multiple instances simultaneously updates only one instance {#42838}

| Issue ID       | Status |
|----------------|--------|
| 42838 | Won't be resolved  |

#### Description

When updating Attack Signatures or Threat Campaign packages on multiple instances simultaneously, only one instance may be successfully updated. An error similar to the following is logged: `security policy bundle object with given ID was not found.`

#### Workaround

Update the Attack Signatures or Threat Campaigns package one instance at a time.

---

## 2.10.0

April 26, 2023

### {{% icon-bug %}} When publishing a new version of Threat Campaign, the last two versions in the list cannot be selected {#42217}

| Issue ID       | Status |
|----------------|--------|
| 42217 | Open  |

#### Description

The list of Threat Campaigns will disappear when scrolling down, preventing the selection of the oldest versions.

#### Workaround

Threat Campaign versions can be published with the API using the route: `api/platform/v1/security/publish`

---

## 2.6.0

November 17, 2022

### {{% icon-bug %}} External references are not supported in App Protect policies {#36265}

| Issue ID       | Status |
|----------------|--------|
| 36265 | Open  |

#### Description

References to external files in a policy are not supported.

For example, in the F5 WAF for NGINX JSON declarative policy, these references are not supported:
- User-defined signatures - " not supporting for a while" @dan
- Security controls in external references
- Referenced OpenAPI Spec files

---

## 2.3.0

June 30, 2022

### {{% icon-bug %}} Metrics may report additional data {#34255}

| Issue ID       | Status |
|----------------|--------|
| 34255 | Open  |

#### Description

NGINX Instance Manager reports metrics at a per-minute interval and includes dimensions for describing the metric data's characteristics.

An issue has been identified in which metric data is aggregated across all dimensions, not just for existing metrics data. When querying the Metrics API with aggregations like `SUM(metric-name)`, the aggregated data causes the API to over count the metric. This overcounting skews some of the metrics dashboards.

#### Workaround

When querying the Metrics API, you can exclude the data for an aggregated dimension by specifying the dimension name in the `filterBy` query parameter.

```none
filterBy=<dimension-name>!= ''
```

---

## 2.0.0

December 21, 2021

### {{% icon-bug %}} Web interface doesn’t report error when failing to upload large config files {#31081}

| Issue ID       | Status |
|----------------|--------|
| 31081 | Open  |

#### Description

In the web interface, when uploading a config file that's larger than 50 MB (max size), the system incorrectly reports the state as `Analyzing` (Status code `403`), although the upload failed.

#### Workaround

Keep config files under 50 MB.

---
