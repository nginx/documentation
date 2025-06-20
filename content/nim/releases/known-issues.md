---
docs: DOCS-937
type: reference
title: Known issues
toc: true
weight: 200
---

{{<rn-styles>}}
This document lists and describes the known issues and possible workarounds in F5 NGINX Instance Manager. We also list the issues resolved in the latest releases.

{{< tip >}}We recommend you upgrade to the latest version of NGINX Instance Manager to take advantage of new features, improvements, and bug fixes.{{< /tip >}}

---

## 2.20.0

June 16, 2025

### {{% icon-bug %}} Failing to fetch CVE data when using forward proxy in K8s environments {#46177}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 46177 | Open  |
{{</bootstrap-table>}}

#### Description

Fetching latest CVE data from internet might fail if you enable "ssl_verify" in Kubernetes environments.


#### Workaround

1. Switch to the offline CVE database. To switch add the property "offline_nginx_cve: true" under the DPM section in the "nms.conf" file.

   ```cfg
   dpm:
       offline_nginx_cve: true
   ```

2. Download the latest security advisories file from the [nginx.org repository]( https://raw.githubusercontent.com/nginx/nginx.org/main/xml/en/security_advisories.xml) and save them with "cve.xml" as filename in "/usr/share/nms/cve.xml”
3. Restart the `nms` service.

   ```shell
   sudo systemctl restart nms
   ```

After the restart you will see the line “loading CVE data from file” in the "nms.log" file.

---

### {{% icon-bug %}} New warning message when no usage data or report is available {#46022}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 46022 | Won't be resolved  |
{{</bootstrap-table>}}

#### Description

Users now see a warning message when they click the **Send Usage To F5** button if no new usage data or report is available. The message reads:

> "Usage data is not available at the moment. Please try submitting usage details again later."

---


## 2.19.1

March 27, 2025

### {{% icon-resolved %}} The certificate stats are not displayed correctly in the Certificates and Keys page as well as the Dashboard page. {#45991}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45991 | Fixed in Instance Manager 2.20.0  |
{{</bootstrap-table>}}

#### Description

When the dashboard page and certificates page are loaded, the count displayed for total, valid, expired, expires soon, managed and unmanaged are incorrect.

#### Workaround

The changes required have been made and the UI displays the values correctly now. Pagination also works well along with the certificate stats.

---


## 2.19.0

February 06, 2025

### {{% icon-resolved %}} Publishing the NAP policy fails with the error “The attack signatures with the given version was not found” {#45845}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45845 | Fixed in Instance Manager 2.19.1  |
{{</bootstrap-table>}}

#### Description

In NGINX Instance Manager v2.19.0, publishing an NGINX App Protect WAF policy from the UI fails if the latest NGINX App Protect WAF compiler v5.264.0 (for NGINX App Protect WAF v4.13.0 or v5.5.0) is manually installed without adding the NGINX repository certificate and key.

#### Workaround

1. Download the NGINX repository certificate and key:
   - Log in to [MyF5](https://account.f5.com/myf5).
   - Go to **My Products and Plans > Subscriptions**.
   - Download the SSL certificate (*nginx-repo.crt*) and private key (*nginx-repo.key*) for your NGINX App Protect subscription.

2. Upload the certificate and key using the NGINX Instance Manager web interface:
   - Go to **Settings > NGINX Repo Connect**.
   - Select **Add Certificate**.
   - Choose **Select PEM files** or **Manual entry**.
   - If using manual entry, copy and paste your *certificate* and *key* details.

    For detailed steps, see [Upload NGINX App Protect WAF certificate and key](https://docs.nginx.com/nginx-instance-manager/nginx-app-protect/setup-waf-config-management/#upload-nginx-app-protect-waf-certificate-and-key).

3. Restart the `nms-integrations` service:

    ```shell
    sudo systemctl restart nms-integrations
    ```


---


## 2.18.0

November 08, 2024

### {{% icon-resolved %}} Automatic downloading of NAP compiler versions 5.210.0 and 5.264.0 fails on Ubuntu 24.04 {#45846}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45846 | Fixed in Instance Manager 2.19.1  |
{{</bootstrap-table>}}

#### Description

On Ubuntu 24.04, NGINX Instance Manager v2.18.0 and v2.19.0 fail to automatically download NGINX App Protect WAF compiler v5.210.0 (for NGINX App Protect WAF v4.12.0) and v5.264.0 (for NGINX App Protect WAF v4.13.0) from the NGINX repository.

#### Workaround

Manually install the missing compiler by following the instructions in [Install the WAF compiler]({{< ref "nim/nginx-app-protect/setup-waf-config-management.md#install-the-waf-compiler" >}}).

---

### {{% icon-resolved %}} Syntax errors while saving template configuration {#45573}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45573 | Fixed in Instance Manager 2.19.0  |
{{</bootstrap-table>}}

#### Description

Saving templates as “staged configs” causes syntax errors due to Augment templates being multiple directories down the tree.

---

### {{% icon-resolved %}} NGINX configuration error messages overlap outside the error window {#45570}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45570 | Fixed in Instance Manager 2.19.0  |
{{</bootstrap-table>}}

#### Description

If there is an NGINX configuration error when pushing a template configuration, the text overlaps outside the error window.


---

### {{% icon-resolved %}} .tgz files are not accepted in templates {#45301}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45301 | Fixed in Instance Manager 2.19.0  |
{{</bootstrap-table>}}

#### Description

`.tgz` files are not accepted in templates while `.tar.gz` files are.

---

### {{% icon-resolved %}} Error messages persist after fix {#45024}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 45024 | Fixed in Instance Manager 2.19.0  |
{{</bootstrap-table>}}

#### Description

There is an issue that causes previous error messages to persist in the web interface, even after fixing the error causing the message.

---


## 2.17.0

July 10, 2024

### {{% icon-bug %}} Web Analytics are not enabled after upgrading Instance Manager when keeping existing nms-http.conf {#45131}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 45131 | Open  |

{{</bootstrap-table>}}
#### Description

When using NGINX Instance Manager, you configure OIDC by manually editing the /etc/nginx/conf.d/nms-http.conf and /etc/nms/nms.conf files.

During the upgrade to 2.17.0, the user is asked if they would like to keep their own nms-http.conf, or replace it with the new default. As Web Analytics are enabled via the /etc/nginx/conf.d/nms-http.conf file, if a user decides to keep their own config when prompted during upgrade, these will not get enabled.

#### Workaround

To keep the existing nms-http.conf file while maintaining the web analytics functionality, add the following to "/etc/nginx/conf.d/nms-http.conf" , inside the `/ui` location block:

```text
add_header Content-Security-Policy "default-src 'none'; block-all-mixed-content; frame-ancestors 'self'; object-src 'none'; manifest-src 'self'; script-src 'self' https://*.walkme.com 'unsafe-inline' 'unsafe-eval'; style-src 'self' https://*.walkme.com fonts.googleapis.com 'unsafe-inline'; img-src 'self' https://*.walkme.com s3.walkmeusercontent.com d3sbxpiag177w8.cloudfront.net data:; font-src 'self' https://*.walkme.com data: https://fonts.gstatic.com; connect-src 'self' https://*.walkme.com; frame-src 'self' https://*.walkme.com blob:; worker-src 'self' blob: https://*.walkme.com;";
```

---

### {{% icon-bug %}} Failure to retrieve instance configuration when NAP-enabled instance doesn't register properly {#45113}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 45113 | Open  |

{{</bootstrap-table>}}
#### Description

If NGINX Agent is configured to monitor NGINX App Protect before App Protect is installed, NGINX Agent will send an empty App Protect metadata structure to NGINX Instance Manager. This causes Instance Manager to fail to register the NGINX instance properly.

#### Workaround

Edit the "/etc/nginx-agent/nginx-agent.conf" file and configure "precompiled_publication" as "false". Then restart the nginx-agent process running `sudo systemctl restart nginx-agent`.

---


## 2.15.0

December 12, 2023

### {{% icon-bug %}} Some NGINX Management Suite features not available after adding license {#44698}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44698 | Open  |

{{</bootstrap-table>}}
#### Description

After adding a license, some NGINX Management Suite features might be disabled, even if they are included in the license.

#### Workaround

Restart NGINX Management Suite to make all the features available for use. To restart NGINX Management Suite, open a terminal on the host and run the command:

```shell
sudo systemctl restart nms
```

---

### {{% icon-bug %}}   Licenses for NGINX Plus applied prior to Instance Manager 2.15 don't show the full feature set {#44685}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44685 | Open  |

{{</bootstrap-table>}}
#### Description

With the introduction of Instance Manager 2.15, we are expanding the features available for some licenses, such as those with only NGINX Plus entitlement. If such a license was applied before upgrading to 2.15, the expanded set of features will not be available as intended.

#### Workaround

Terminate the license applied previously. Re-apply the license.

---


## 2.14.0

October 16, 2023

### {{% icon-bug %}} Scan results may not include CVE count with App Protect installed {#44554}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44554 | Open  |

{{</bootstrap-table>}}
#### Description

When using the Scan feature, the CVE column may provide a value of '--' for instances running specific versions of NGINX App Protect, including App Protect 4.4 and potentially others.

---

### {{% icon-bug %}} Certain instances not showing in the Network Utilization drawer {#44547}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44547 | Open  |

{{</bootstrap-table>}}
#### Description

Under certain conditions, instances that are not reporting request totals may not show in the Network Utilization panel or drawer when data is sorted by Request count. This typically happens when NGINX is not configured to stream metrics data to NGINX Agent.

#### Workaround

Configure NGINX Plus or NGINX Stub Status APIs to send correctly the NGINX metrics using NGINX Agent. See the [Metrics]({{< ref "nim/monitoring/overview-metrics.md" >}}) documentation to learn more.

---

### {{% icon-bug %}} Built-in security policies may not be accessible {#44520}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44520 | Open  |

{{</bootstrap-table>}}
#### Description

Users might not have permission to access the built-in policies (NginxDefaultPolicy and NginxStrictPolicy) while using NGINX Management Suite.

#### Workaround

Use RBAC to assign the following permissions to the user:
- (At minimum) READ access to any other custom security policy
or
- READ access to the security policy feature: `/api/platform/v1/security/policies`

---


## 2.13.0

August 28, 2023

### {{% icon-bug %}} If you publish a configuration with an uncompiled policy, it will fail the first time {#44267}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44267 | Open  |

{{</bootstrap-table>}}
#### Description

In Instance Manager 2.13, a new configuration is published before the compile stage of a WAF policy is complete. This happens only when the policy is first referenced. This leads to a deployment failure, and the configuration rolls back. Typically, by the time you try to submit the configuration again, the policy has finished compiling, and the request goes through.

The initial failure message looks like this:

```text
Config push failed - err: failure from multiple instances. Affected placements: instance/70328a2c-699d-3a90-8548-b8fcec15dabd (instance-group: ig1) - err: failed building config payload: config: aux payload /etc/nms/NginxDefaultPolicy.tgz for instance:70328a2c-699d-3a90-8548-b8fcec15dabd not ready aux payload not ready, instance/2e637e08-64b3-36f9-8f47-b64517805e98 (instance-group: ig1) - err: failed building config payload: config: aux payload /etc/nms/NginxDefaultPolicy.tgz for instance:2e637e08-64b3-36f9-8f47-b64517805e98 not ready aux payload not ready
```

#### Workaround

Retry pushing the new configuration. The deployment should work the second time around.

---

### {{% icon-bug %}} Inaccurate Attack Signatures and Threat Campaigns versions {#43950}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 43950 | Open  |

{{</bootstrap-table>}}
#### Description

If `precompiled_publication` is set to `true`, NGINX Management Suite may incorrectly report the version of Attack Signatures (AS) and Threat Campaigns (TC) that you previously installed on the NAP WAF instance.

---


## 2.11.0

June 12, 2023

### {{% icon-bug %}} Updating Attack Signatures or Threat Campaigns on multiple instances simultaneously updates only one instance {#42838}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42838 | Open  |

{{</bootstrap-table>}}
#### Description

When updating Attack Signatures or Threat Campaign packages on multiple instances simultaneously, only one instance may be successfully updated. An error similar to the following is logged: `security policy bundle object with given ID was not found.`

#### Workaround

Update the Attack Signatures or Threat Campaigns package one instance at a time.

---


## 2.10.0

April 26, 2023

### {{% icon-bug %}} When publishing a new version of Threat Campaign, the last two versions in the list cannot be selected {#42217}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42217 | Open  |

{{</bootstrap-table>}}
#### Description

The list of Threat Campaigns will disappear when scrolling down, preventing the selection of the oldest versions.

#### Workaround

Threat Campaign versions can be published with the API using the route: `api/platform/v1/security/publish`

---

### {{% icon-bug %}} When upgrading to Instance Manager 2.10, there may be warnings from the Ingestion service {#42133}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42133 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When upgrading to 2.10 you may see a warning like the below message for the NGINX Management Suite Ingestion service. It can be safely ignored.

```none
[WARN] #011/usr/bin/nms-ingestion               #011start/start.go:497                 #011error checking migrations Mismatched migration version for ClickHouse, expected 39 migrations to be applied, currently have only 44 migrations applied.
```

---

### {{% icon-bug %}} When upgrading to Instance Manager 2.10, the API does not return lastDeploymentDetails for existing configurations {#42119}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42119 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

After upgrading to Instance Manager 2.10, the API does not return lastDeploymentDetails for existing configuration blocks. This is then reflected as "Invalid Date" in the UI (See #42108).

#### Workaround

Republish the configuration for the affected configuration blocks.

---


## 2.6.0

November 17, 2022

### {{% icon-bug %}} App Protect Policies page fails when deployed via Helm chart {#38782}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38782 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When installing NGINX Instance Manager on Kubernetes via Helm Chart, the App Protect page shows an error banner, and no default policies are displayed.

---

### {{% icon-bug %}} Config deployment could fail when referencing remote cert inside allowed directories {#38596}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38596 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

Deploying NGINX config with references to remote cert that resides in allowed directories could fail, with the following error:
`BIO_new_file() failed (SSL: error:02001002:system library:fopen:No such file or directory`.

This can also be diagnosed with log entries in `/var/log/nginx-agent/agent.log`, noting the removal of the referenced certificate.

#### Workaround

- Add the referenced cert to NMS as managed certificate and publish the config again.
- Move the referenced remote certificate to a directory that's not in the allowed directory list.

---

### {{% icon-bug %}} Unreferenced NGINX App Protect policy file in /etc/nms {#38488}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38488 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When using NGINX Instance Manager with App Protect policies, previously referenced policies in the NGINX configuration may not be removed after they are no longer referenced in the NGINX config.

#### Workaround

Unreferenced policy files may be removed manually from /etc/nms.

---

### {{% icon-bug %}} HTTP version schema returns incorrect value in Advanced metrics module {#38041}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38041 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

The values currently populated for http.version_schema are incorrect. The response is "4" for HTTP traffic and "6" for HTTPS traffic.

---

### {{% icon-bug %}} External references are not supported in App Protect policies {#36265}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36265 | Open  |

{{</bootstrap-table>}}
#### Description

References to external files in a policy are not supported.

For example, in the NGINX App Protect WAF JSON declarative policy, these references are not supported:
- User-defined signatures - " not supporting for a while" @dan
- Security controls in external references
- Referenced OpenAPI Spec files

---


## 2.5.0

October 04, 2022

### {{% icon-bug %}} Aux data fails to upload if the size is greater than 3145728 characters {#37498}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 37498 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

Updating a config with an aux data file exceeding 3145728 characters fails with a validation error similar to the following example:

Request body has an error: doesn't match the schema: Error at "/auxFiles/files/3/contents": maximum string length is 3145728

---

### {{% icon-bug %}} "Deployment Not Found" error when publishing NGINX config to NATS server {#37437}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 37437 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

Occasionally, when publishing an NGINX config to a NATS server, the system returns a `Deployment Not Found` error, and the `nms.log` file includes the error `http failure with code '131043': <nil>`.

#### Workaround

Remove the existing NATs working directory and restart the NMS Data Plane Manager (`nms-dpm`) service as root.

{{<caution>}}Restarting the `nms-dpm` service is disruptive and may result in the loss of event data. You should schedule a maintenance window for restarting the service.{{</caution>}}

```bash
rm -rf /var/lib/nms/streaming
systemctl restart nms-dpm
```

---


## 2.3.0

June 30, 2022

### {{% icon-bug %}} Metrics may report additional data {#34255}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 34255 | Open  |

{{</bootstrap-table>}}
#### Description

NGINX Instance Manager reports metrics at a per-minute interval and includes dimensions for describing the metric data's characteristics.

An issue has been identified in which metric data is aggregated across all dimensions, not just for existing metrics data. When querying the Metrics API with aggregations like `SUM(metric-name)`, the aggregated data causes the API to over count the metric. This overcounting skews some of the metrics dashboards.

#### Workaround

When querying the Metrics API, you can exclude the data for an aggregated dimension by specifying the dimension name in the `filterBy` query parameter.

```none
filterBy=<dimension-name>!= ''
```

---


## 2.2.0

May 25, 2022

### {{% icon-bug %}} Giving long names (255+ characters) to certificates causes internal error {#34185}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 34185 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When adding certificates, an internal error (error code: 134018) is returned if the name given for the certificate exceeds 255 characters.

#### Workaround

Use a name that is 255 or fewer characters.

---


## 2.1.0

April 05, 2022

### {{% icon-bug %}} An unexpected number of instances are shown after upgrading nginx-agent to 2.1.0 {#33307}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 33307 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

After upgrading to NGINX Instance Manager 2.1.0, and updating nginx-agent from platform packaging, duplicate instances may appear on the Instance overview page. This issue is caused by a change in how the NGINX Agent generates the `system_uid`.

#### Workaround

You can safely delete the older entries or wait for them to expire.

---

### {{% icon-bug %}} “No such process” error occurs when publishing a configuration {#33160}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 33160 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When publishing a configuration, you might encounter an error similar to the following example:

``` text
config action failed: Config apply failed (write): no such process
```

This error can occur when there is a desyncronization between the NGINX Agent and NGINX PID, often after manually restarting NGINX when the Agent is running.

#### Workaround

Restart the NGINX Agent:

``` bash
sudo systemctl restart nginx-agent
```

---


## 2.0.0

December 21, 2021

### {{% icon-bug %}} NGINX App Protect WAF blocks NGINX Instance Manager from publishing configurations {#32718}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 32718 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

NGINX Instance Manager does not currently support managing NGINX App Protect WAF instances. NGINX App Protect WAF may block attempts to publish configurations to NGINX App Protect WAF instances.

---

### {{% icon-bug %}} Web interface doesn’t report error when failing to upload large config files {#31081}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 31081 | Open  |

{{</bootstrap-table>}}
#### Description

In the web interface, when uploading a config file that's larger than 50 MB (max size), the system incorrectly reports the state as `Analyzing` (Status code `403`), although the upload failed.

#### Workaround

Keep config files under 50 MB.

---

### {{% icon-bug %}} CentOS 7, RHEL 7, and Amazon Linux 2 package managers allow unsupported NGINX/NGINX Plus versions {#28758}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 28758 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

When installing on CentOS 7, RHEL 7, and Amazon Linux 2, the package manager doesn't prevent installing NGINX Instance Manager with unsupported versions of NGINX or NGINX Plus. As a consequence, it is possible that `nms-instance-manager` is installed without an NGINX gateway. Resulting in a less than optimal experience.

#### Workaround

Install a supported version of NGINX (v1.18 or later) or NGINX Plus (R22 or later). See the [Technical Specifications]({{< ref "nim/fundamentals/tech-specs.md" >}}) guide for details.

---

### {{% icon-bug %}} gRPC errors occur when starting NGINX Instance Manager {#28683}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 28683 | Won't be resolved  |

{{</bootstrap-table>}}
#### Description

  When starting NGINX Instance Manager, you may see errors similar to the following in `/etc/nginx/conf.d/nms-http.conf:227`:

  ```text
  nginx[1234]: nginx: [emerg] unknown directive "grpc_socket_keepalive"
  ```

#### Workaround

Make sure your version of NGINX is v1.18 or later.
