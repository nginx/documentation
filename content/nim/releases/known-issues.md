---
nd-docs: DOCS-937
type: reference
title: Known issues
toc: true
weight: 200
nd-product: NIMNGR
nd-content-type: reference
---

This document lists and describes the known issues and possible workarounds in F5 NGINX Instance Manager. We also list the issues resolved in the latest releases.

{{< call-out "tip" >}}We recommend you upgrade to the latest version of NGINX Instance Manager to take advantage of new features, improvements, and bug fixes.{{< /call-out >}}

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
| 46726 | Open  |

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

## 2.19.0

February 06, 2025

### {{% icon-resolved %}} Publishing the NAP policy fails with the error “The attack signatures with the given version was not found” {#45845}

| Issue ID       | Status |
|----------------|--------|
| 45845 | Fixed in Instance Manager 2.19.1  |

#### Description

In NGINX Instance Manager v2.19.0, publishing an F5 WAF for NGINX policy from the UI fails if the latest F5 WAF for NGINX compiler v5.264.0 (for F5 WAF for NGINX v4.13.0 or v5.5.0) is manually installed without adding the NGINX repository certificate and key.

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

    For detailed steps, see [Upload F5 WAF for NGINX certificate and key](https://docs.nginx.com/nginx-instance-manager/nginx-app-protect/setup-waf-config-management/#upload-nginx-app-protect-waf-certificate-and-key).

3. Restart the `nms-integrations` service:

    ```shell
    sudo systemctl restart nms-integrations
    ```

---

## 2.18.0

November 08, 2024

### {{% icon-resolved %}} Error messages persist after fix {#45024}

| Issue ID       | Status |
|----------------|--------|
| 45024 | Fixed in Instance Manager 2.19.0  |

#### Description

There is an issue that causes previous error messages to persist in the web interface, even after fixing the error causing the message.

---

### {{% icon-resolved %}} .tgz files are not accepted in templates {#45301}

| Issue ID       | Status |
|----------------|--------|
| 45301 | Fixed in Instance Manager 2.19.0  |

#### Description

`.tgz` files are not accepted in templates while `.tar.gz` files are.

---

### {{% icon-resolved %}} NGINX configuration error messages overlap outside the error window {#45570}

| Issue ID       | Status |
|----------------|--------|
| 45570 | Fixed in Instance Manager 2.19.0  |

#### Description

If there is an NGINX configuration error when pushing a template configuration, the text overlaps outside the error window.

---

### {{% icon-resolved %}} Syntax errors while saving template configuration {#45573}

| Issue ID       | Status |
|----------------|--------|
| 45573 | Fixed in Instance Manager 2.19.0  |

#### Description

Saving templates as “staged configs” causes syntax errors due to Augment templates being multiple directories down the tree.

---

### {{% icon-resolved %}} Automatic downloading of NAP compiler versions 5.210.0 and 5.264.0 fails on Ubuntu 24.04 {#45846}

| Issue ID       | Status |
|----------------|--------|
| 45846 | Fixed in Instance Manager 2.19.1  |

#### Description

On Ubuntu 24.04, NGINX Instance Manager v2.18.0 and v2.19.0 fail to automatically download NGINX App Protect WAF compiler v5.210.0 (for NGINX App Protect WAF v4.12.0) and v5.264.0 (for NGINX App Protect WAF v4.13.0) from the NGINX repository.

#### Workaround

Manually install the missing compiler by following the instructions in [Install the WAF compiler]({{< ref "nim/waf-integration/configuration/install-waf-compiler/_index.md" >}}).

---

## 2.17.3

September 13, 2024

### {{% icon-resolved %}} The web interface can't display more than 100 certificates {#45565}

| Issue ID       | Status |
|----------------|--------|
| 45565 | Fixed in Instance Manager 2.19.0  |

#### Description

The Certificate Management screen can only show up to 100 certificates.

---

## 2.17.0

July 10, 2024

### {{% icon-resolved %}} Editing template submissions now allows for using most recent template version {#44971}

| Issue ID       | Status |
|----------------|--------|
| 44971 | Fixed in Instance Manager 2.17.0  |

#### Description

When editing a template submission, you can now choose between using a snapshot of the template from when it was first deployed or the latest version of the template. **Important:** Note that if you use the latest version, changes to the templates might make an augment template incompatible with a base template, causing the publication to the data plane to fail.

---

### {{% icon-resolved %}} Failure to notify user when template configuration publish fails {#44975}

| Issue ID       | Status |
|----------------|--------|
| 44975 | Fixed in Instance Manager 2.18.0  |

#### Description

When publishing a configuration template fails, the system only displays "Accepted" without providing the final result, such as "Success" or "Failure."

---

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

### {{% icon-resolved %}} NGINX Agent 2.36.0 fails to validate certain NGINX configurations in NGINX Instance Manager 2.17.0 {#45153}

| Issue ID       | Status |
|----------------|--------|
| 45153 | Fixed in nginxagent-2.36.0  |

#### Description

In NGINX Instance Manager 2.17.0, an "invalid number of arguments" error appears in the web interface when using specific configuration parameters in NGINX Agent 2.36.0.

#### Workaround

Install NGINX Agent **2.35.1** if you're using NGINX Instance Manager 2.17.0. This version is included with NGINX Instance Manager 2.17.0 by default.

If you're installing NGINX Agent from package files, follow the steps in the [Installing NGINX Agent](https://github.com/nginx/agent?tab=readme-ov-file#installing-nginx-agent-from-package-files) guide.

---

### {{% icon-resolved %}} Mismatch in date formats in custom date selection on NGINX usage graph {#45512}

| Issue ID       | Status |
|----------------|--------|
| 45512 | Fixed in Instance Manager 2.18.0  |

#### Description

The months in the custom date range were not displayed correctly because NGINX Instance Manager assumed the data format was in the US timezone.

---

## 2.16.0

April 18, 2024

### {{% icon-resolved %}} REST API does not work until you log into the web interface first {#44877}

| Issue ID       | Status |
|----------------|--------|
| 44877 | Fixed in Instance Manager 2.17.0  |

#### Description

If you get an "Error accessing resource: forbidden" message while using the NGINX Instance Manager REST API, try logging into the web interface. After logging in, you should be able to use the API.

---

### {{% icon-resolved %}}  Editing template submissions uses the latest versions, may cause "malformed" errors {#44961}

| Issue ID       | Status |
|----------------|--------|
| 44961 | Fixed in Instance Manager 2.17.0  |

#### Description

When editing a template submission, the system currently uses the latest template files instead of the specific snapshot of files associated with the submission. The latest template files might not be well-formed and can cause errors when generating a configuration. This can lead to an error message saying "malformed."

#### Workaround

Use caution when editing template submissions. If you encounter a "malformed" error, check the template for any changes that could have caused the issue.

To keep a template from being changed accidentally, set it to "Ready for Use" by doing the following:

1. Go to **Templates**.
2. Find the template you want to lock and click the **Actions** button (three dots).
3. Select **Edit**.
4. Select the **Ready for Use** option.

If you need to modify a template that you have already submitted, create a copy instead of editing the original:

1. On the **Templates** page, locate the template you want to edit.
2. Select the **Actions** button and choose **Edit Template Files**.
3. Select **Save As** to duplicate the template, then give it a name.

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

### {{% icon-resolved %}} Users receive login error when NGINX Management Suite is deployed in Kubernetes {#44686}

| Issue ID       | Status |
|----------------|--------|
| 44686 | Fixed in Instance Manager 2.17.0  |

#### Description

After deploying NGINX Management Suite in a Kubernetes environment, when a user tries to log on for the first time, a generic error is displayed.

#### Workaround

Refreshing the browser clears the error and allows the user to log on.

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

### {{% icon-resolved %}} Helm chart backup and restore is broken in NIM 2.15.0 {#44758}

| Issue ID       | Status |
|----------------|--------|
| 44758 | Fixed in Instance Manager 2.15.1  |

#### Description

Helm backup and restore will not run in 2.15.0 due to an underlying change in the dqlite client. Customers are advised to upgrade to 2.15.1.

#### Workaround

Upgrade to NGINX Instance Manager 2.15.1.

---

### {{% icon-resolved %}} Unable to use NMS Predefined Log Profiles for NAP 4.7 {#44759}

| Issue ID       | Status |
|----------------|--------|
| 44759 | Fixed in Instance Manager 2.15.1  |

#### Description

The predefined NGINX Management Suite Log Profiles are incompatible with NGINX App Protect 4.7.

#### Workaround

To use the NGINX Management Suite predefined log profiles with NGINX App Protect 4.7 follow these steps:

1. Retrieve the content of the NMS predefined log profile through the NMS Log Profile APIs, accessible in the (Manage WAF Security Policies and Security Log Profiles) section.
1. Decode the content obtained in the previous step using base64 encoding.
1. Modify the "max_request_size" and "max_message_size" values within the decoded content to the following:

    **"max_request_size": "2k", "max_message_size": "32k"**

1. Create a custom log profile using the NMS Log Profile APIs, incorporating the base64 encoded content from the adjusted configuration.
1. Update your NGINX configuration to reference the new custom log profile in the NGINX App Protect log profile directive.

---

## 2.14.0

October 16, 2023

### {{% icon-resolved %}} Instances reporting incorrect memory utilization {#44351}

| Issue ID       | Status |
|----------------|--------|
| 44351 | Fixed in Instance Manager 2.15.0  |

#### Description

An upgrade to NGINX Agent v2.30 or later is required for instances to stream memory utilization data correctly. Note that even after the upgrade, historical data recorded before the upgrade will not be correct.

#### Workaround

[Upgrade NGINX Agent](https://docs.nginx.com/nginx-agent/installation-upgrade) to version v2.30 or later.

---

### {{% icon-resolved %}} Data on the dashboard is updating unexpectedly {#44504}

| Issue ID       | Status |
|----------------|--------|
| 44504 | Fixed in Instance Manager 2.15.0  |

#### Description

Dashboard data may update unexpectedly when opening a drawer view. The updated data accurately represents the latest available information about your NGINX instances.

---

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

### {{% icon-resolved %}} NGINX Agent does not report NGINX App Protect status {#44531}

| Issue ID       | Status |
|----------------|--------|
| 44531 | Fixed in Instance Manager 2.14.0  |

#### Description

NGINX Agent does not report NGINX App Protect as "Active" when the Attack Signature or Threat Campaign version is newer than 2023.10.01.

#### Workaround

[Upgrade NGINX Agent](https://docs.nginx.com/nginx-agent/installation-upgrade) to version v2.30.1 or later.

---

### {{% icon-resolved %}} Issues sorting HTTP errors in the dashboard {#44536}

| Issue ID       | Status |
|----------------|--------|
| 44536 | Fixed in Instance Manager 2.14.0  |

#### Description

Sorting HTTP errors by “Request Count” sometimes shows the data in an incorrect order.

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

### {{% icon-resolved %}} Missing Data when ClickHouse services are not running {#44586}

| Issue ID       | Status |
|----------------|--------|
| 44586 | Fixed in Instance Manager 2.15.0  |

#### Description

The ClickHouse database service is a required component of the Instance Manager Dashboard. The dashboard may display an error message if the ClickHouse service does not start or quits unexpectedly.

#### Workaround

Restart the Clickhouse service.

---

### {{% icon-resolved %}} NGINX App Protect Attack Signature, Threat Campaign and Compiler fail to download {#44603}

| Issue ID       | Status |
|----------------|--------|
| 44603 | Fixed in Instance Manager 2.15.0  |

#### Description

NGINX App Protect Attack Signatures package, Threat Campaigns package, and WAF Compiler can fail to download automatically with an error similar to the following:

```none
Oct 20 22:22:57 ip-127-0-0-1 <DPM>[9553]: 2023-10-20T22:22:57.648Z	ERROR	81c818dd-ffff-aaaa-8b9d-134a60020d20	authz/authz.go:245	failed to get license status: getting license status: Get "http://unix-socket/api/platform/v1/license/status": context deadline exceeded
Oct 20 22:22:57 ip-127-0-0-1 <INT>[9527]: 2023-10-20T22:22:57.653Z	ERROR	nms-integrations	compiler-controller/security_updates_downloader.go:94	security_updates_downloader: error when creating the nginx repo retriever - unexpected status when retrieving certs: 500 Internal Server Error
```

#### Workaround

Download manually the latest [Attack Signatures package, Threat Campaign package]({{< ref "/nim/waf-integration/configuration/setup-signatures-and-threats/manual-update/" >}}), and [WAF Compiler]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/install/" >}}).

---

## 2.13.1

September 05, 2023

### {{% icon-resolved %}} Certificates may not appear in resource group  {#44323}

| Issue ID       | Status |
|----------------|--------|
| 44323 | Fixed in Instance Manager 2.14.0  |

#### Description

If you have certificates that were added to NGINX Management Suite before upgrading, they may not appear in the list of available certs when creating or editing a resource group.

#### Workaround

Restarting the DPM process will make all certificates visible in the Resource Group web interface and API.

For VM and bare metal deployments:
```shell
sudo systemctl restart nms-dpm
```

For Kubernetes deployments:

```shell
kubectl -n nms scale --replicas=0 deployment.apps/dpm
kubectl -n nms scale --replicas=1 deployment.apps/dpm
```

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

### {{% icon-resolved %}} getAttackCountBySeverity endpoint broken with NGINX App Protect 4.4 and above {#44051}

| Issue ID       | Status |
|----------------|--------|
| 44051 | Fixed in Instance Manager 2.14.0  |

#### Description

The reporting of severities has been disabled in NGINX App Protect 4.4. As a result, the `getAttackCountBySeverity` endpoint on the NGINX Management Suite's API will report zeroes for all severities, and the related "Severity" donut diagram in the Security Monitoring Dashboard won't display any values.

---

### {{% icon-resolved %}} Validation errors in Resource Groups for certificates uploaded before 2.13 upgrade {#44254}

| Issue ID       | Status |
|----------------|--------|
| 44254 | Fixed in Instance Manager 2.13.1  |

#### Description

If you upgrade to Instance Manager 2.13 and already have certificates in place, you may encounter validation errors in the web interface when you try to create or edit a Resource Group and access the Certs list. You will not be able to save the Resource Group if you encounter these errors.

This issue doesn't occur if you upload certificates _after_ upgrading to version 2.13, nor does it affect new 2.13 installations. Instance Groups and Systems are unaffected.

#### Workaround

To work around this issue, you have two options:

1. When creating or editing a Resource Group, don't use the Certs list. Instance Groups and Systems can still be used.
2. If you must use Resource Groups with Certs, delete any certificates that were uploaded before upgrading to 2.13, and then re-upload them.

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

### {{% icon-resolved %}} Access levels cannot be assigned to certain RBAC features {#44277}

| Issue ID       | Status |
|----------------|--------|
| 44277 | Fixed in Instance Manager 2.13.1  |

#### Description

When configuring role-based access control (RBAC), you can't assign access levels to some features, including Analytics and Security Policies.

---

## 2.12.0

July 20, 2023

### {{% icon-resolved %}} An "unregistered clickhouse-adapter" failure is logged every few seconds if logging is set to debug. {#43438}

| Issue ID       | Status |
|----------------|--------|
| 43438 | Fixed in Instance Manager 2.13.0  |

#### Description

If NGINX Management Suite logging is set to debug, it may log an "unregistered clickhouse-adapter" failure every few seconds. These logs do not affect the system's performance and can safely be ignored.

#### Workaround

Choose a less verbose logging level, such as warning, error, or info.

---

### {{% icon-resolved %}} A JWT license for an expired subscription cannot be terminated from the web interface {#43580}

| Issue ID       | Status |
|----------------|--------|
| 43580 | Fixed in Instance Manager 2.12.0  |

#### Description

When a JWT license from an expired subscription is uploaded to NGINX Management Suite, it cannot be replaced or terminated from the web interface.

#### Workaround

Upload a valid JWT or S/MIME license file using the Platform API.

More information is available in the Platform API reference guide, under the License endpoint. In a web browser, go to the FQDN for your NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Documentation**.

---

### {{% icon-resolved %}} Upgrading to 2.12 disables telemetry {#43606}

| Issue ID       | Status |
|----------------|--------|
| 43606 | Fixed in Instance Manager 2.16.0  |

#### Description

Upgrading to Instance Manager 2.12 will stop NGINX Management Suite from transmitting telemetry.

#### Workaround

Toggle the telemetry setting off and on. You can do this by selecting **Settings > License** from the NGINX Management Suite web interface.

---

### {{% icon-resolved %}} On Kubernetes, uploading a JWT license for NGINX Management Suite results in the error "secret not found" {#43655}

| Issue ID       | Status |
|----------------|--------|
| 43655 | Fixed in Instance Manager 2.12.0  |

#### Description

When uploading a JWT license to an NGINX Management Suite deployment on Kubernetes, you may see error messages in the web interface and logs similar to the following example:

<pre>[ERROR] /usr/bin/nms-integrations   license/secrets.go:100    jwt-manager: failed to get [secret=dataEncryptionKey] from remote store. secret not found</pre>

#### Workaround

This error can be resolved by deleting the integrations pod and restarting it. You can do this by running the following command on the NGINX Management Suite host:

```bash
kubectl -n nms scale --replicas=0 deployment.apps/integrations; kubectl -n nms scale --replicas=1 deployment.apps/integrations
```

---

### {{% icon-resolved %}} Licensing issues when adding JWT licenses in firewalled environments {#43719}

| Issue ID       | Status |
|----------------|--------|
| 43719 | Fixed in Instance Manager 2.18.0  |

#### Description

If firewall rules prevent access to F5 servers, attempting to license NGINX Management Suite with a JWT license may result in the product being unable to terminate the license or upload another one, even if connectivity is restored.

#### Workaround

To fix this issue, follow the steps below for your environment type.

<br>

##### Virtual Machine or Bare Metal

1. Stop the integrations service:

   ``` bash
   sudo systemctl stop nms-integrations
   ```

2. Delete the contents of `/var/lib/nms/dqlite/license`

3. Start the integrations service:

   ```bash
   sudo systemctl start nms-integrations
   ```

4. Upload a valid S/MIME license.

   Alternatively, to use a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

   - https://product.apis.f5.com
   - https://product-s.apis.f5.com/ee

##### Kubernetes

1. Run the following command to stop the integrations service by scaling down:

   ```bash
   kubectl -n nms scale --replicas=0 deployment.apps/integrations
   ```
2. Access the Dqlite volume for the integrations service and delete the contents of `/var/lib/nms/dqlite/license`.

3. Run the following command to start the integrations service by scaling up:

   ```bash
   kubectl -n nms scale --replicas=1 deployment.apps/integrations
   ```

4. Upload a valid S/MIME license.

   Alternatively, to use a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

   - https://product.apis.f5.com
   - https://product-s.apis.f5.com/ee

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

### {{% icon-resolved %}} Error: "Failed to create secret" when reinstalling or upgrading NGINX Management Suite in Kubernetes {#42967}

| Issue ID       | Status |
|----------------|--------|
| 42967 | Fixed in Instance Manager 2.13.0  |

#### Description

When deploying NGINX Management Suite in Kubernetes, if you have previously run the support package script and the output is still in the default location, you may encounter an error message similar to the following example when reinstalling or upgrading NGINX Management Suite:

`Failed to create: Secret "sh.helm.release.v1.(release-name).v1"`

#### Workaround

Delete or move the support package output files: `nms-hybrid/support-package/k8s-support-pkg-*.tgz`.

---

### {{% icon-resolved %}} Agent 2.26 has issues when deployed in RHEL9 with SELinux {#43010}

| Issue ID       | Status |
|----------------|--------|
| 43010 | Fixed in nginxagent-2.26.1  |

#### Description

NGINX Agent 2.26, which is packaged with Instance Manager 2.11, may fail to start on RHEL 9 systems with SELinux enabled. An error similar to the following is logged: "Unable to read dynamic config".

#### Workaround

Use an earlier version of the NGINX Agent. You can install the NGINX Agent from [GitHub](https://github.com/nginx/agent) or the [NGINX Plus repository]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

---

### {{% icon-resolved %}} When adding a Certs RBAC permission, the "Applies to" field may display as "nginx-repo" {#43012}

| Issue ID       | Status |
|----------------|--------|
| 43012 | Fixed in Instance Manager 2.12.0  |

#### Description

In certain situations, when you update a certificate or key using the NGINX Management Suite web interface, and subsequently add or edit a Certificate permission for Role-Based Access Control (RBAC) in **Settings > Roles**, you may notice that the "Applies to" name appears as "nginx-repo".

#### Workaround

Use the unique identifier to assign specific permissions to a particular certificate and key pair.

---

### {{% icon-resolved %}} Publication status of instance groups may be shown as 'not available' after restarting NGINX Management Suite {#43016}

| Issue ID       | Status |
|----------------|--------|
| 43016 | Fixed in Instance Manager 2.12.0  |

#### Description

After restarting the NGINX Management Suite services, the publication status of instance groups for deployments that include a security policy may show as "not available".

#### Workaround

Redeploy a new version of the security policy or an updated `nginx.conf`.

---

### {{% icon-resolved %}} Querying API endpoints for Security deployments associations may return empty UIDs for Attack-Signatures and Threat-Campaigns {#43034}

| Issue ID       | Status |
|----------------|--------|
| 43034 | Fixed in Instance Manager 2.15.0  |

#### Description

When querying the following API endpoints for Security deployment associations, you may encounter results where the UID value for Attack-Signatures and Threat-Campaigns is empty.

- /api/platform/v1/security/deployments/attack-signatures/associations
- /api/platform/v1/security/deployments/threat-campaigns/associations
- /api/platform/v1/security/deployments/associations/NginxDefaultPolicy

#### Workaround

To obtain the UID value for Attack-Signatures and Threat-Campaigns, you can query the following API endpoints:

- /api/platform/v1/security/attack-signatures
- /api/platform/v1/security/threat-campaigns

---

## 2.10.0

April 26, 2023

### {{% icon-resolved %}} Configuration changes for NGINX Agent take longer than expected. {#41257}

| Issue ID       | Status |
|----------------|--------|
| 41257 | Fixed in Instance Manager 2.10.0  |

#### Description

NGINX Agent introduced the config_reload_monitoring_period parameter under nginx to define the duration which Agent will monitor the logs for relevant errors and warnings after a configuration change. As a result, configuration changes will take at least one second to appear.

#### Workaround

Adjust the config_reload_monitoring_period parameter to a value that suits your workflow.

---

### {{% icon-resolved %}} Filtering Analytics data with values that have double backslashes (`\\`) causes failures {#42105}

| Issue ID       | Status |
|----------------|--------|
| 42105 | Fixed in Instance Manager 2.12.0  |

#### Description

When you apply a filter with double backslashes (`\\`) on any of the Analytics endpoints, such as metrics, events, or the security dashboard, the API fails to parse and apply the filter correctly.

---

### {{% icon-resolved %}} When upgrading to Instance Manager 2.10, the publish status on App Security pages shows "Invalid Date" {#42108}

| Issue ID       | Status |
|----------------|--------|
| 42108 | Fixed in Instance Manager 2.11.0  |

#### Description

After upgrading to Instance Manager 2.10, the publish status on App Security pages of Policies, Attack Signatures, and Threat Campaign shows "Invalid Date" until new configurations are published to the instance or instance group.

---

### {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates {#42182}

| Issue ID       | Status |
|----------------|--------|
| 42182 | Fixed in Instance Manager 2.11.0  |

#### Description

When deploying a configuration with a certificate and key handled by NGINX Management Suite to a custom file path, it may deploy a duplicate copy of the certificate and key to the default /etc/nginx/ path. When deleting the certificate and key, it will only delete the certificate and key in the custom path, leaving the duplicate copy.

#### Workaround

Manually delete the certificate and key from the /etc/nginx/ path.

---

### {{% icon-bug %}} When publishing a new version of Threat Campaign, the last two versions in the list cannot be selected {#42217}

| Issue ID       | Status |
|----------------|--------|
| 42217 | Open  |

#### Description

The list of Threat Campaigns will disappear when scrolling down, preventing the selection of the oldest versions.

#### Workaround

Threat Campaign versions can be published with the API using the route: `api/platform/v1/security/publish`

---

### {{% icon-resolved %}} The Metrics module is interrupted during installation on Red Hat 9 {#42219}

| Issue ID       | Status |
|----------------|--------|
| 42219 | Fixed in Instance Manager 2.11.0  |

#### Description

When installing the Metrics module on Red Hat 9, the following error will prevent it from finishing:

```none
warning: Signature not supported. Hash algorithm SHA1 not available.
error: /tmp/nginx_signing.key: key 1 import failed.

Failed to import nginx signing key. exiting.
```

#### Workaround

Before installation, run the following command:

```bash
sudo update-crypto-policies --set DEFAULT:SHA1
```

After installation, we recommend you return the default to a more secure algorithm such as SHA256.

---

### {{% icon-resolved %}} Valid licenses incorrectly identified as invalid {#42598}

| Issue ID       | Status |
|----------------|--------|
| 42598 | Fixed in Instance Manager 2.10.1  |

#### Description

Sometimes, valid licenses for NGINX Management Suite are incorrectly identified as invalid when uploaded. As a result, you may not be able to access features that require a valid license.

---

### {{% icon-resolved %}} Unable to publish configurations referencing the log bundle for Security Monitor {#42932}

| Issue ID       | Status |
|----------------|--------|
| 42932 | Fixed in Instance Manager 2.12.0  |

#### Description

Configuration deployments that reference the log bundle for Security Monitoring (app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;), may fail with an error message similar to the following:

```none
: error while retrieving Nginx App Protect profile bundle secops_dashboard info for NAP version 4.279.0: Not Found. Please create it first
```

#### Workaround

On the NGINX Management Suite host, restart platform services:

```bash
sudo systemctl restart nms
```

---

### {{% icon-resolved %}} Disk Usage in Metrics Summary shows incorrect data when multiple partitions exist on a system {#42999}

| Issue ID       | Status |
|----------------|--------|
| 42999 | Fixed in Instance Manager 2.12.0  |

#### Description

The Disk Usage metric on the Metrics Summary page averages disk usage across all the partitions instead of summing it.

---

## 2.9.1

April 06, 2023

### {{% icon-resolved %}} OIDC-authenticated users can't view the Users list using the API or web interface {#43031}

| Issue ID       | Status |
|----------------|--------|
| 43031 | Fixed in Instance Manager 2.14.0  |

#### Description

When you use OIDC-based authentication in NGINX Management Suite, if the identity provider (IdP) sends an email address with an invalid format, users will be unable to access the list of Users through the web interface or API.

#### Workaround

To resolve this issue, please update the email addresses in your identity provider and ensure that all addresses are properly formatted. Once the email addresses are correctly formatted, users will be able to view the list of Users in the NGINX Management Suite.

---

## 2.9.0

March 21, 2023

### {{% icon-resolved %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" {#41157}

| Issue ID       | Status |
|----------------|--------|
| 41157 | Fixed in Instance Manager 2.10.0  |

#### Description

Attempting to install NGINX Agent on FreeBSD fails with an error message: "error 2051: not implemented."

#### Workaround

If you are using FreeBSD, you can download the NGINX Agent from [https://github.com/nginx/agent/releases/tag/v2.23.2]( https://github.com/nginx/agent/releases/tag/v2.23.2) or use a previously installed version.

---

### {{% icon-resolved %}} NGINX configurations with special characters may not be editable from the web interface after upgrading Instance Manager {#41557}

| Issue ID       | Status |
|----------------|--------|
| 41557 | Fixed in Instance Manager 2.9.1  |

#### Description

After upgrading to Instance Manager 2.9.0, the system may display a "URI malformed" error if you use the web interface to edit a staged configuration or `nginx.conf` that contains special characters, such as underscores ("_").

---

## 2.8.0

January 30, 2023

### {{% icon-resolved %}} The Type text on the Instances overview page may be partially covered by the Hostname text {#39760}

| Issue ID       | Status |
|----------------|--------|
| 39760 | Fixed in Instance Manager 2.9.0  |

#### Description

On the Instances overview page, long hostnames may overlap and interfere with the visibility of the text in the Type column that displays the NGINX type and version.

#### Workaround

Select the hostname to open the instance details page to view the full information.

---

### {{% icon-resolved %}} System reports "Attack Signature does not exist" when publishing default Attack Signature {#40020}

| Issue ID       | Status |
|----------------|--------|
| 40020 | Fixed in Instance Manager 2.9.0  |

#### Description

The default Attack Signature might be unavailable for publishing from Instance Manager, even though it is listed on the web interface. Attempting to publish this Attack Signature results in the error message "Error publishing the security content: attack signature does not exist."

#### Workaround

[Download another (latest recommended) version of the Attack Signature and publish it]({{< relref "/nim/waf-integration/configuration/" >}}).  Attack Signature 2019.07.16 should be removed from the list when you refresh the web interface.

---

### {{% icon-resolved %}} App Protect: "Assign Policy and Signature Versions" webpage may not initially display newly added policies {#40085}

| Issue ID       | Status |
|----------------|--------|
| 40085 | Fixed in Instance Manager 2.9.0  |

#### Description

If you've published new policies by updating the `nginx.config` file, using the Instance Manager REST API, or through the web interface, you may not see the policy when you initially select **Assign Policy and Signature Versions** on the Policy Detail page.

#### Workaround

To fix this issue, return to the Policy Detail page and select **Assign Policy and Signature Versions** again.

---

### {{% icon-resolved %}} Automatic downloads of attack signatures and threat campaigns are not supported on CentOS 7, RHEL 7, or Amazon Linux 2 {#40396}

| Issue ID       | Status |
|----------------|--------|
| 40396 | Fixed in Instance Manager 2.8.0  |

#### Description

If you use CentOS 7, RHEL 7, or Amazon Linux 2 and you have configured auto-downloads for new new Attack Signatures or Threat Campaigns in Instance Manager, you may encounter an error similar to the following example when attempting to publish an NGINX App Protect WAF policy:

```json
{
  "error_message": "Data::MessagePack->unpack: parse error",
  "completed_successfully": false,
  "componentVersions": {
    "wafEngineVersion": "10.179.0"
  },
  "event": "configuration_load_failure"
}
```

#### Workaround

This issue is related to [bug 39563](#39563) and has the same workaround.

---

### {{% icon-resolved %}} Precompiled Publication setting is reverted to false after error publishing NGINX App Protect policy  {#40484}

| Issue ID       | Status |
|----------------|--------|
| 40484 | Fixed in Instance Manager 2.9.0  |

#### Description

After enabling the `precompiled_publication` setting in the `nginx-agent.conf` file, you may encounter the following error when attempting to publish NGINX App Protect policies to an instance:

```text
{"instance:6629a097-9d91-356a-bd70-de0ce846cf2b":"unsupported file type for Nginx App Protect. Please use Nginx App Protect JSON file"}.
```

If this happens, the Precompiled Publication setting will be reverted to false/blank on the instance's detail page in the NGINX Management Suite web interface.

#### Workaround

1. Log in to the instance you're trying to publish the NGINX App Protect policies to and check if directory **/etc/nms** exists:
  If directory **/etc/nms** doesn't exist, please create it first.
    ```bash
    sudo mkdir /etc/nms
    sudo chown root:nginx-agent /etc/nms
    ```
2. Change the **precompiled_publication** setting in nginx-agent.conf to **false**
    ```bash
    sudo vi /etc/nginx-agent/nginx-agent.conf
    ```
3. Restart nginx-agent
    ```bash
    sudo systemctl restart nginx-agent
    ```
4. Change the **precompiled_publication** setting in nginx-agent.conf to **true**
    ```bash
    sudo vi /etc/nginx-agent/nginx-agent.conf
    ```
5. Restart nginx-agent
    ```bash
    sudo systemctl restart nginx-agent
    ```
The instance on the NGINX Management Suite's Instance Details page should show **Precompiled Publication** as **enabled**.

---

### {{% icon-resolved %}} Upgrading NGINX Management Suite may remove the OIDC configuration for the platform {#41328}

| Issue ID       | Status |
|----------------|--------|
| 41328 | Fixed in Instance Manager 2.9.0  |

#### Description

Upgrading the NGINX Management Suite could result in the removal of your OIDC configuration, which would prevent users from being able to log in through OIDC.

#### Workaround

Prior to upgrading, we recommend that you [back up your configuration files]({{< relref "/nim/admin-guide/backup-and-recovery.md" >}}) and the platform proxy.

---

## 2.7.0

December 20, 2022

### {{% icon-resolved %}} "Public Key Not Available" error when upgrading Instance Manager on a Debian-based system {#39431}

| Issue ID       | Status |
|----------------|--------|
| 39431 | Fixed in Instance Manager 2.9.0  |

#### Description

When attempting to upgrade Instance Manager on a Debian-based system, the command `sudo apt-get update` may return the error “public key is not available,” preventing the NGINX Agent from being updated. To resolve this issue, you need to update the public key first.

#### Workaround

To manually update the public key, take the following steps:

1. Download a new key from the NGINX Management Suite host:

   - secure

       ```shell
       curl https://<NMS_FQDN>/packages-repository/nginx-signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-signing.gpg >/dev/null
       ```

   - insecure:

       ```shell
       curl -k https://<NMS_FQDN>/packages-repository/nginx-signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-signing.gpg >/dev/null
       ```

2. Update the `nginx-agent.list` file to reference the new key:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-signing.gpg] https://<NMS_FQDN>/packages-repository/deb/ubuntu `lsb_release -cs` agent\n" | sudo tee /etc/apt/sources.list.d/nginx-agent.list
    ```

---

### {{% icon-resolved %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed {#41327}

| Issue ID       | Status |
|----------------|--------|
| 41327 | Fixed in Instance Manager 2.10.0  |

#### Description

On RHEL9 with the SELinux policy loaded, NGINX Management Suite may report the following errors when starting:

``` text
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts recent

type=AVC msg=audit(1678828847.528:6775): avc:  denied  { watch } for  pid=53988 comm="nms-core" path="/var/lib/nms/modules" dev="nvme0n1p4" ino=50345930 scontext=system_u:system_r:nms_t:s0 tcontext=system_u:object_r:nms_var_lib_t:s0 tclass=dir permissive=0
```

#### Workaround

If you encounter any of the errors mentioned above, you can attempt to rebuild and reload the NGINX Management Suite policy. To do so, follow these steps:

1. Copy the `nms.te` and `nms.fc` files to a directory on your target machine.

    - {{<icon "download">}} {{< link "/nim/release-notes/41327/nms.te" "nms.te" >}}
    - {{<icon "download">}} {{< link "/nim/release-notes/41327/nms.fc" "nms.fc" >}}

2. [Install the `policycoreutils-devel` package](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/using_selinux/index#selinux-architecture_getting-started-with-selinux).
3. Change to the directory where you copied the `nms.te` and `nms.fc` files.
4. Rebuild the `nms.pp` file:

    ```bash
    make -f /usr/share/selinux/devel//Makefile nms.pp
    ```

5. Remove any existing NGINX Management Suite policy:

    ```bash
    sudo semodule -r nms
    ```

6. Install the new policy:

    ```bash
    sudo semodule -n -i nms.pp
    ```

7. To finish installing the NGINX Management Suite policy, follow the remaining instructions from the package manager output and restart the NGINX Management Suite services:

    ```bash
    sudo systemctl restart nms
    ```

8. After 10 minutes, check there are no more SELinux errors:

    ```bash
    sudo ausearch -m avc --raw -se nms -ts recent
    ```

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

### {{% icon-resolved %}} Count of NGINX Plus graph has a delay in being populated {#37705}

| Issue ID       | Status |
|----------------|--------|
| 37705 | Fixed in Instance Manager 2.11.0  |

#### Description

When viewing the NGINX Plus usage in Instance Manager, the graph displaying usage over time requires several hours of data before displaying the count.

#### Workaround

The data presented in the graph can be retrieved from the API.

---

### {{% icon-resolved %}} When upgrading a multi-node NMS deployment with helm charts the core, dpm, or integrations pods may fail to start {#38589}

| Issue ID       | Status |
|----------------|--------|
| 38589 | Fixed in Instance Manager 2.7.0  |

#### Description

When using the NMS Instance Manager Helm upgrade command on a multi worker node kubernetes cluster setup, the core, dpm and integrations deployments may fail to upgrade.

#### Workaround

Post upgrade, do the following steps:

> kubectl -n nms scale --replicas=0 deployment.apps/dpm; kubectl -n nms scale --replicas=1 deployment.apps/dpm
> kubectl -n nms scale --replicas=0 deployment.apps/core; kubectl -n nms scale --replicas=1 deployment.apps/core
> kubectl -n nms scale --replicas=0 deployment.apps/integrations; kubectl -n nms scale --replicas=1 deployment.apps/integrations

---

### {{% icon-resolved %}} "Unpack: parse error" when compiling security update packages on CentOS 7, RHEL 7, and Amazon Linux 2 {#39563}

| Issue ID       | Status |
|----------------|--------|
| 39563 | Fixed in Instance Manager 2.8.0  |

#### Description

If you are trying to publish an NGINX App Protect WAF policy after adding a new Attack Signature or Threat Campaign to Instance Manager, either through the `security/attack-signatures` or `security/threat-campaigns` API endpoints, or by enabling auto-downloads of signatures and threat campaigns, you may encounter an error similar to the following:

```json
{
  "error_message": "Data::MessagePack->unpack: parse error",
  "completed_successfully": false,
  "componentVersions": {
    "wafEngineVersion": "10.179.0"
  },
  "event": "configuration_load_failure"
}
```

Example error output in `/var/log/nms`:

```log
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.625Z#011[INFO] #011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:261#011starting compilation for compilation request identified by the fields - policy UID (19fa1ed0-c87d-4356-9ab0-d250c3b630f3), compiler version (4.2.0), attack signatures version (2022.10.27), threat campaigns version (2022.11.02), global state UID (d7b6b5b4-6aa6-4bd7-a3e2-bfaaf035dbe0)
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.625Z#011[DEBUG]#011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:294#011performing pre compilation
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.625Z#011[DEBUG]#011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:588#011Updating attack signatures from 2019.07.16 to 2022.10.27
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.643Z#011[DEBUG]#011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:487#011copying the files for attack signature 2022.10.27
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.644Z#011[DEBUG]#011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:515#011successfully copied over attack signatures version 2022.10.27 to compiler 4.2.0
Feb  6 18:58:58 ip-172-16-0-23 <INT>: 2023-02-06T18:58:58.644Z#011[INFO] #011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:639#011executing the following pre compilation command - /opt/nms-nap-compiler/app_protect-4.2.0/bin/config_set_compiler --update-signatures
Feb  6 18:59:02 ip-172-16-0-23 <INT>: 2023-02-06T18:59:02.750Z#011[INFO] #011b5c8de8a-8243-4128-bc8f-5c02ea8df839+1675709938565522240#011compiler-controller/compiler.go:642#011stdout and stderr produced from the pre compilation command '/opt/nms-nap-compiler/app_protect-4.2.0/bin/config_set_compiler --update-signatures':
Feb  6 18:59:02 ip-172-16-0-23 <INT>: --- stdout ---
Feb  6 18:59:02 ip-172-16-0-23 <INT>: {"error_message":"Data::MessagePack->unpack: parse error","completed_successfully":false,"componentVersions":{"wafEngineVersion":"10.179.0"},"event":"configuration_load_failure"}
Feb  6 18:59:02 ip-172-16-0-23 <INT>: --- stderr ---
```

#### Workaround

Download the `attack-signatures` and/or `threat-campaigns` packages for CentOS 7, RHEL 7, or Amazon Linux 2 from the NGINX repo directly to your Instance Manager host by following the instructions in the official NGINX App Protect documentation:

- [Attack Signatures Documentation](https://docs.nginx.com/nginx-app-protect/admin-guide/install/#centos--rhel-74--amazon-linux-2)
- [Threat Campaigns Documentation](https://docs.nginx.com/nginx-app-protect/admin-guide/install/#centos--rhel-74--amazon-linux-2-1)

After downloading the `attack-signatures` and/or `threat-campaigns` packages onto your Instance Manager host, give Instance Manager about 15 seconds to recognize these packages.

If the logging level is set to `debug`, you should see the following logs that confirm a successful installation:

```log
Feb  6 20:35:17 ip-172-16-0-23 <INT>: 2023-02-06T20:35:17.174Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:256#011detected change in attack signature files [/opt/app_protect/var/update_files/signatures/signatures.bin.tgz /opt/app_protect/var/update_files/signatures/signature_update.yaml /opt/app_protect/var/update_files/signatures/version]... syncing
Feb  6 20:35:17 ip-172-16-0-23 <INT>: 2023-02-06T20:35:17.175Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:307#011downloading attack signatures version - 2023.01.26
Feb  6 20:35:17 ip-172-16-0-23 <INT>: 2023-02-06T20:35:17.193Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:349#011successfully downloaded attack signatures version - 2023.01.26
Feb  6 20:46:02 ip-172-16-0-23 <INT>: 2023-02-06T20:46:02.176Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:274#011detected change in threat campaign files [/opt/app_protect/var/update_files/threat_campaigns/threat_campaigns.bin.tgz /opt/app_protect/var/update_files/threat_campaigns/threat_campaign_update.yaml /opt/app_protect/var/update_files/threat_campaigns/version]... syncing
Feb  6 20:46:02 ip-172-16-0-23 <INT>: 2023-02-06T20:46:02.176Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:370#011downloading threat campaigns version - 2023.01.11
Feb  6 20:46:02 ip-172-16-0-23 <INT>: 2023-02-06T20:46:02.191Z#011[DEBUG]#011nms-integrations                     #011compiler-controller/security_updates_monitor.go:412#011successfully downloaded threat campaigns version - 2023.01.11
```

Once the `attack-signatures` and/or `threat-campaigns` packages have been added to the library, you can list them by making a `GET` request to the corresponding API endpoints.

- attack signatures - `https://{nms-fqdn}/api/platform/v1/security/attack-signatures`
- threat campaigns - `https://{nms-fqdn}/api/platform/v1/security/threat-campaigns`

---

## 2.5.0

October 04, 2022

### {{% icon-resolved %}} Staged configs fail to publish after upgrading NGINX Management Suite {#37479}

| Issue ID       | Status |
|----------------|--------|
| 37479 | Fixed in Instance Manager 2.13.0  |

#### Description

After upgrading NGINX Management Suite to 2.5.0, when you try to publish a staged config from the web interface, the system returns an error similar to the following:

> "The published configuration is older than the active instance configuration."

#### Workaround

Make a minor edit to a staged config, such as adding a space, then save the change. You should be able to publish now.

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
filterBy=<DIMENSION_NAME>!= ''
```

---

### {{% icon-resolved %}} Scan misidentifies some NGINX OSS instances as NGINX Plus {#35172}

| Issue ID       | Status |
|----------------|--------|
| 35172 | Fixed in Instance Manager 2.9.0  |

#### Description

When NGINX Plus is installed on a datapath instance, then removed and replaced with NGINX OSS, NGINX Instance Manager may incorrectly identify the instance as an NGINX Plus instance. This is due to multiple NGINX entries for the same datapath.

#### Workaround

Use NGINX Instance Manager's NGINX Instances API to remove the inactive NGINX instance. For instructions, refer to the API reference guide, which you can find at `https://<NIM_FQDN>/ui/docs`.

You may need to stop the NGINX Agent first. To stop the NGINX Agent, take the following steps:

```bash
sudo systemctl stop nginx-agent
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

### {{% icon-resolved %}} Instance Manager reports old NGINX version after upgrade {#31225}

| Issue ID       | Status |
|----------------|--------|
| 31225 | Fixed in Instance Manager 2.7.0  |

#### Description

  After upgrading NGINX to a new version, the NGINX Instance Manager web interface and API report the old NGINX version until the NGINX Agent is restarted.

#### Workaround

  Restart the Agent to have the new version reflected properly:

  ```bash
  systemctl restart nginx-agent
  ```

---
