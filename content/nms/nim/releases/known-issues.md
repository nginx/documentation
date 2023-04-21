---
title: "Known Issues"
date: 2022-03-30T12:38:24-08:00
draft: false
description: "This document lists and describes the known issues and possible workarounds in NGINX Management Suite Instance Manager. Fixed issues are removed after **45 days**."
# Assign weights in increments of 100
weight: 100000
toc: true
tags: [ "docs" ]
docs: "DOCS-937"
categories: ["known issues"]
---

{{<rn-styles>}}

{{< tip >}}We recommend you [upgrade to the latest version of Instance Manager](https://docs.nginx.com/nginx-management-suite/admin-guides/installation/upgrade-guide/) to take advantage of new features, improvements, and bug fixes.{{< /tip >}}

---

## 2.9.0

#### <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> BREAKING CHANGE!</span> OIDC configurations for the management plane must be updated after upgrading to Instance Manager 2.9.0

  OIDC configuration files were modified to improve support for automation and integration in CI/CD pipelines. To continue using OIDC after upgrading to Instance Manager 2.9.0, you'll need to update these configuration files.

  To take advantage of the expanded functionality for OIDC authentication with NGINX Management Suite, we recommend following these two options:

  **Option 1**
  
  1. During the upgrade, type `Y` when prompted to respond `Y or I: install the package mainatiner's version` for each of the following files:

     - `/etc/nms/nginx/oidc/openid_configuration.conf`
     - `/etc/nms/nginx/oidc/openid_connect.conf`
     - `/etc/nms/nginx/oidc/openid_connect.js`

  2. After the upgrade finishes, make the following changes to the `/etc/nms/nginx/oidc/openid_configuration.conf` file using the `/etc/nms/oidc/openid_connect.conf.dpkg-old` that was created as a backup:

       - Uncomment the appropriate "Enable when using OIDC with" for your IDP (for example, keycloak, azure).
       - Update `$oidc_authz_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_token_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_jwt_keyfile` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_client` and `oidc_client_secret` with corresponding values from `openid_connect.conf.dpkg-old`.
       - Review and restore any other customizations from `openid_connect.conf.dpkg-old` beyond those mentioned above.

  3. Save the file.
  4. Restart NGINX Management Suite:

      ```bash
      sudo systemctl restart nms
      ```

  5. Restart the NGINX web server:

      ```bash
      sudo systemctl restart nginx
      ```

  <br>

  **Option 2**

  1. Before upgrading Instance Manager, edit the following files with your desired OIDC configuration settings:

      - `/etc/nginx/conf.d/nms-http.conf`
      - `/etc/nms/nginx/oidc/openid_configuration.conf`
      - `/etc/nms/nginx/oidc/openid_connect.conf`
      - `/etc/nms/nginx/oidc/openid_connect.js`

  1. During the upgrade, type `N` when prompted to respond `N or O  : keep your currently-installed version`.
  1. After the upgrade finishes replace `etc/nms/nginx/oidc/openid_connect.js` with `openid_connect.js.dpkg-dist`.
  1. Restart NGINX Management Suite:

      ```bash
      sudo systemctl restart nms
      ```

  1. Restart the NGINX web server:

      ```bash
      sudo systemctl restart nginx
      ```

---

### {{% icon-resolved %}} NGINX configurations with special characters may not be editable from the web interface after upgrading Instance Manager {#41557}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 41557    | Fixed in 2.9.1 |
{{</bootstrap-table>}}

#### Description

After upgrading to Instance Manager 2.9.0, the system may display a "URI malformed" error if you use the web interface to edit a staged configuration or `nginx.conf` that contains special characters, such as underscores ("_").

---

### {{% icon-bug %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" {#41157}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 41157    | Open   |
{{</bootstrap-table>}}

#### Description

Attempting to install NGINX Agent on FreeBSD fails with an error message: "error 2051: not implemented."

#### Workaround

If you are using FreeBSD, you can download the NGINX Agent from [https://github.com/nginx/agent/releases/tag/v2.23.2]( https://github.com/nginx/agent/releases/tag/v2.23.2) or use a previously installed version.

---

## 2.8.0

### {{% icon-resolved %}} Upgrading NGINX Management Suite may remove the OIDC configuration for the platform {#41328}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 41328    | Fixed in 2.9.0 |
{{</bootstrap-table>}}

#### Description

Upgrading the NGINX Management Suite could result in the removal of your OIDC configuration, which would prevent users from being able to log in through OIDC.
#### Workaround

Prior to upgrading, we recommend that you back up your configuration files for NGINX Management Suite and the platform proxy. Refer to the [Upgrade Guide]({{< relref "admin-guides/installation/upgrade-guide.md" >}}) for further details on this and other pre-upgrade steps.

---

### {{% icon-bug %}} Precompiled Publication setting is reverted to false after error publishing NGINX App Protect policy  {#40484}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 40484    | Open   |
{{</bootstrap-table>}}

#### Description

After enabling the `precompiled_publication` setting in the `nginx-agent.conf` file, you may encounter the following error when attempting to publish NGINX App Protect policies to an instance:

```text
{"instance:6629a097-9d91-356a-bd70-de0ce846cf2b":"unsupported file type for NGINX App Protect. Please use Nginx App Protect JSON file"}.
```

If this happens, the Precompiled Publication setting will be reverted back to false/blank on the instance's detail page in the NGINX Management Suite web interface.

#### Workaround

1. Log in to the instance you're trying to publish the NGINX App Protect policies to and check if directory `/etc/nms` exists:

    If the `/etc/nms` directory doesn't exist, run the following command to create it:

    ```bash
    sudo mkdir /etc/nms
    sudo chown root:nginx-agent /etc/nms
    ```

1. Edit the NGINX Agent configuration file and change the `precompiled_publication` setting to `false`.

    ```bash
    sudo vi /etc/nginx-agent/nginx-agent.conf
    ```

1. Restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent 
    ```

1. Edit the NGINX Agent configuration file and change the `precompiled_publication` setting to `true`.

    ```bash
    sudo vi /etc/nginx-agent/nginx-agent.conf
    ```

1. Restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent 
    ```

The instance on the NGINX Management Suite's Instance Details page should show **Precompiled Publication** as **enabled**.

---

### {{% icon-bug %}} Automatic downloads of attack signatures and threat campaigns are not supported on CentOS 7, RHEL 7, or Amazon Linux 2 {#40396}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 40396    | Open   |
{{</bootstrap-table>}}

#### Description

If you use CentOS 7, RHEL 7, or Amazon Linux 2 and you've configured auto-downloads for new new Attack Signatures or Threat Campaigns in Instance Manager, you may encounter an error similar to the following example when attempting to publish an NGINX App Protect WAF policy:

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

### {{% icon-resolved %}} App Protect: "Assign Policy and Signature Versions" webpage may not initially display newly added policies {#40085}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 40085    | Fixed in 2.9.0 |
{{</bootstrap-table>}}

#### Description

If you've published new policies by updating the `nginx.config` file, using the Instance Manager REST API, or through the web interface, you may not see the policy when you initially select **Assign Policy and Signature Versions** on the Policy Detail page.

#### Workaround

To fix this issue, return to the Policy Detail page and select **Assign Policy and Signature Versions** again.

---

### {{% icon-bug %}} System reports "Attack Signature does not exist" when publishing default Attack Signature {#40020}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 40020    | Open   |
{{</bootstrap-table>}}

#### Description

The default Attack Signature (2019.07.16) is not being added to the Attack Signature database, which means it is unavailable for publishing from the control plane, even though it is listed in the web interface. Attempting to publish this Attack Signature results in the error message "Error publishing the security content: attack signature does not exist."

#### Workaround

[Download the latest version of the Attack Signature and publish it]({{< relref "nim/how-to/app-protect/setup-waf-config-management" >}}). Attack Signature 2019.07.16 should be removed from the list when you refresh the web interface.

---

### {{% icon-bug %}} The Type text on the Instances overview page may be partially covered by the Hostname text {#39760}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 39760    | Open   |
{{</bootstrap-table>}}

#### Description

On the Instances overview page, long hostnames may overlap and interfere with the visibility of the text in the Type column that displays the NGINX type and version.

#### Workaround

Select the hostname to open the instance details page to view the full information.

---

### {{% icon-resolved %}} To publish security policies with Instance Manager, set the "precompiled_publication" parameter to "true" in the `nginx-agent.conf` file {#39614}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39614    | Fixed in 2.9.0 |
{{</bootstrap-table>}}

#### Description

In order to publish App Protect policies from Instance Manager, you must add the following to your `nginx-agent.conf` file:

```yaml
nginx_app_protect: 
precompiled_publication: true 
```

By default, `precompiled_publication` is `false`.

---

## 2.7.0

### {{% icon-bug %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed {#41327}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 41327    | Open   |
{{</bootstrap-table>}}

#### Description

On RHEL9 with the SELinux policy loaded, NGINX Management Suite may report the following errors when starting:

``` text
ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts recent

type=AVC msg=audit(1678828847.528:6775): avc:  denied  { watch } for  pid=53988 comm="nms-core" path="/var/lib/nms/modules" dev="nvme0n1p4" ino=50345930 scontext=system_u:system_r:nms_t:s0 tcontext=system_u:object_r:nms_var_lib_t:s0 tclass=dir permissive=0
```

#### Workaround

If you encounter any of the errors mentioned above, you can attempt to rebuild and reload the NGINX Management Suite policy. To do so, follow these steps:

1. Copy the `nms.te` and `nms.fc` files to a directory on your target machine.

    - {{< fa "download" >}} {{< link "/nim/release-notes/41327/nms.te" "nms.te" >}}
    - {{< fa "download" >}} {{< link "/nim/release-notes/41327/nms.fc" "nms.fc" >}}

2. Install the `policycoreutils-devel` package:

    ```bash
    yum install policycoreutils-devel
    ```

3. Change to the directory where you copied the `nms.te` and `nms.fc` files.
4. Rebuild the `nms.pp` file:

    ```bash
    make -f /usr/share/selinux/devel/Makefile nms.pp
    ```

5. Remove any existing NGINX Management Suite policy:

    ```bash
    sudo semodule -r nms
    ```

6. Install the new policy:

    ```bash
    sudo semodule -n -i nms.pp
    ```

7. To finish installing the NGINX Management Suite policy, follow the remaining instructions from the package manager output.

---

### {{% icon-resolved %}} Security Policy Snippet selector adds incorrect path reference for policy directive {#39492}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39492    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

The Security Policy Snippet selector adds `/etc/app_protect/${policy.name}` for the NGINX App Protect policy directive instead of the default path that Instance Manager expects, `/etc/nms/${policy.name}`.

#### Workaround

Before publishing the NGINX configuration (`nginx.conf`), add the correct path reference for the policy in the NGINX Agent configuration file.

1. Edit the NGINX Agent configuration file `/etc/nginx-agent/nginx-agent.conf`.
2. In the `config_dirs` section, locate the `app_protect_policy_file` setting and replace `/etc/app_protect/` with `/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms`.
3. Save the change and close the file.

---

### {{% icon-bug %}} "Public Key Not Available" error when upgrading Instance Manager on a Debian-based system {#39431}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 39431    | Open   |
{{</bootstrap-table>}}

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

---

### {{% icon-resolved %}} NGINX Management Suite services may lose connection to ClickHouse in a Kubernetes deployment {#39285}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39285    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

When deploying NMS services in Kubernetes, they must be able to establish a connection to ClickHouse in order to enter a healthy state. If ClickHouse becomes available at a later time, the services will not automatically attempt to reconnect to it.

#### Workaround

If you notice Core, DPM, or Ingestion POD logs indicating no connection to ClickHouse even though ClickHouse POD is running, restart Core, DPM, and Ingestion by scaling down and up with the following command,

```bash
kubectl -n nms scale --replicas=0 deployment.apps/core deployment.apps/dpm deployment.apps/ingestion
kubectl -n nms scale --replicas=1 deployment.apps/core deployment.apps/dpm deployment.apps/ingestion
```

---

### {{% icon-bug %}} Database error while listing instance groups {#39205}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 39205    | Open   |
{{</bootstrap-table>}}

#### Description

You may see the error message "error from rows in bind" in the NGINX Management Suite logs while querying instance group objects. This may occur when there are more than 200 instance groups. As such, creating more than 200 instance groups is not recommended at this time.

---

### {{% icon-resolved %}} Deploy NGINX App Protect policy is listed as "Not Deployed" on the Policy Version detail page {#38876}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38876    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

After using Instance Manager to publish an NGNIX App Protect policy version to an App Protect instance, the policy is shown as "Not Deployed" on the Policy Version detail page. This happens when the policy has not been fully deployed to the NGINX App Protect WAF instances.

#### Workaround

Wait for the policy to be fully deployed to the NGINX App Protect instances, then navigate away from and back to the Policy Version detail webpage. Reloading the page is not enough to resolve the issue.

---

## 2.6.0

### {{% icon-bug %}} "Unpack: parse error" when compiling security update packages on CentOS 7, RHEL 7, and Amazon Linux 2 {#39563}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 39563    | Open   |
{{</bootstrap-table>}}

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

Download the `attack-signatures` and/or `threat-campaigns` packages for CentOS 7, RHEL 7, or Amazon Linux 2 from the NGINX repo directly to your Instance Manager host instance by following the instructions in the official NGINX App Protect documentation:

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

### {{% icon-resolved %}} NGINX App Protect status may not be displayed after publishing a configuration with a security policy and certificate reference {#39382}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39382    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

When publishing an instance configuration with a security policy and a certificate reference, the App Protect page in the web interface may not show that the security policy is registered with the instance.

#### Workaround

To resolve this issue, publish the config twice: once with only the security policy reference and a second time with both the security policy and certificate references.

---

### {{% icon-resolved %}} After a version upgrade of NGINX Instance Manager, NMS Data Plane Manager crashes if you publish NGINX configuration with App Protect enablement directive (app_protect_enable) set to ON {#38904}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38904    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

After upgrading from a previous version of NGINX Instance Manager (2.5.0 or 2.5.1), the Data Plane Manager might crash. This happens when you publish NGINX configuration with App Protect enablement directive (app_protect_enable) set to ON. Also, status information for NGINX App Protect instances does not get updated.

---

### {{% icon-resolved %}} When upgrading a multi-node NMS deployment with helm charts the ingestion pod may report a "Mismatched migration version" error {#38880}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38880    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

When using the NMS Instance Manager Helm upgrade command on a multi worker node Kubernetes cluster setup, the ingestion pod may report a "Mismatched migration version" error.

#### Workaround

Post upgrade, do the following steps:

```shell
kubectl -n nms scale --replicas=0 deployment.apps/dpm; kubectl -n nms scale --replicas=1 deployment.apps/dpm
kubectl -n nms scale --replicas=0 deployment.apps/ingestion; kubectl -n nms scale --replicas=1 deployment.apps/ingestion
```

---

### {{% icon-resolved %}} The Policy API endpoint only allows NGINX App Protect policy upsert with content length up to 3.14MB. {#38839}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38839    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

The Policy API endpoint prevents App Protect creation or updates with content-length greater than 3.14 MB.

---
### {{% icon-resolved %}} Large payloads can result in disk I/O error for database operations {#38827}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38827    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

When NGINX Management Suite stores an NGINX configuration that references large payloads, a "disk I/O error" may occur. This affects configuration payloads with sizes larger than 5M, such as the NGINX App Protect policy bundle.

---

### {{% icon-bug %}} App Protect Policies page fails when deployed via Helm chart {#38782}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38782    | Open   |
{{</bootstrap-table>}}

#### Description

When installing NGINX Instance Manager on Kubernetes via Helm Chart, the App Protect page shows an error banner, and no default policies are displayed.

---

### {{% icon-resolved %}} NGINX App Protect policy deployment status not reflecting removal of associated instance. {#38700}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38700    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

This error occurs when you use NGINX App Protect on the Instance Manager and then remove all NGINX App Protect references from the NGINX Config. As a result, it incorrectly shows some NAP policies as still being deployed on this Instance.

#### Workaround

1. Login to the instance.
2. Remove `app_protect_metadata.json`:

   ```shell
    sudo rm /etc/nms/app_protect_metadata.json
    ```

3. Restart the NGINX Agent:

    ```shell
    sudo systemctl restart nginx-agent
    ```

---

### {{% icon-resolved %}} When upgrading Instance Manager from v2.4 to later versions of Instance Manager, certificate associations are no longer visible. {#38641}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38641    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

When upgrading Instance Manager from 2.4 or earlier to 2.5 or later, certificates associated with an instance will no longer reflect the association. This does not impact the functioning of the data plane instance or usage of the certificate and key.

#### Workaround

Re-associate any certificates that no longer reflect the association. 

---

### {{% icon-resolved %}} Missing dimension data for Advanced Metrics with modules {#38634}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38634    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

If you are using the NGINX Management Suite platform with the API Connectivity Manager module enabled, you may notice that several of the collected metrics are missing dimension data for `http.hostname`, `http.request_method`, `http.response_code`, and `http.uri`.

---

### {{% icon-bug %}} Config deployment could fail when referencing remote cert inside allowed directories {#38596}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38596    | Open   |
{{</bootstrap-table>}}

#### Description

Deploying NGINX config with references to remote cert that resides in allowed directories could fail, with the following error: 
`BIO_new_file() failed (SSL: error:02001002:system library:fopen:No such file or directory`. 

This can also be diagnosed with log entries in `/var/log/nginx-agent/agent.log`, noting the removal of the referenced certificate.

#### Workaround

- Add the referenced cert to NMS as managed certificate and publish the config again.
- Move the referenced remote certificate to a directory that's not in the allowed directory list.

---

### {{% icon-bug %}} When upgrading a multi-node NMS deployment with helm charts the core, dpm, or integrations pods may fail to start {#38589}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38589    | Open   |
{{</bootstrap-table>}}

#### Description

When using the NMS Instance Manager Helm upgrade command on a multi worker node Kubernetes cluster setup, the core, dpm and integrations deployments may fail to upgrade.

#### Workaround

Post upgrade, do the following steps:

```shell
kubectl -n nms scale --replicas=0 deployment.apps/dpm; kubectl -n nms scale --replicas=1 deployment.apps/dpm
kubectl -n nms scale --replicas=0 deployment.apps/core; kubectl -n nms scale --replicas=1 deployment.apps/core
kubectl -n nms scale --replicas=0 deployment.apps/integrations; kubectl -n nms scale --replicas=1 deployment.apps/integrations
```

---

### {{% icon-bug %}} Unreferenced NGINX App Protect policy file in /etc/nms {#38488}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38488    | Open   |
{{</bootstrap-table>}}

#### Description

When using NGINX Instance Manager with App Protect policies, previously referenced policies in the NGINX configuration may not be removed after they are no longer referenced in the NGINX config.

#### Workaround

Unreferenced policy files may be removed manually from /etc/nms.

---

### {{% icon-resolved %}} Publishing to an Instance/instance-group will fail when the configuration references a JSON policy or a JSON log profile  {#38357}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38357    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

Publishing to an Instance/instance-group might fail if nginx.conf references a JSON policy or a JSON log profile. NGINX App Protect directives that reference a Security Policy or a Log Profile expect a bundle (.tgz), not a JSON file.

For example, a configuration similar to the following will fail:

```nginx
            location / {    
                app_protect_enable on;                       
                app_protect_policy_file /<path-to-config-dir-on-the-instance>/policy-name.json; 
                app_protect_security_log_enable on;
                app_protect_security_log /<path-to-config-dir-on-the-instance>/log-profile-name.json; 
```

---

### {{% icon-resolved %}} Null data count is not correctly represented in the NGINX Plus usage graph. {#38206}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38206    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

When there is no NGINX Plus instance reporting to NGINX Management Suite, but there was some in the past, the graph in the UI assumes the last reported value for those times. The GUI and API both report the Min as the lowest reported number and do not factor in periods where no instances were reported. Similarly, the average value is calculated only using reported values and ignores time periods where no instances are reported.

---

### {{% icon-bug %}} HTTP version schema returns incorrect value in Advanced metrics module {#38041}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38041    | Open   |
{{</bootstrap-table>}}

#### Description

The values currently populated for http.version_schema are incorrect. The response is "4" for HTTP traffic and "6" for HTTPS traffic.

---

### {{% icon-bug %}} Count of NGINX Plus graph has a delay in being populated {#37705}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 37705    | Open   |
{{</bootstrap-table>}}

#### Description

When viewing the NGINX Plus usage in Instance Manager, the graph displaying usage over time requires several hours of data before displaying the count.

#### Workaround

The data presented in the graph can be retrieved from the API.

---

### {{% icon-bug %}} External references are not supported in App Protect policies {#36265}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 36265    | Open   |
{{</bootstrap-table>}}

#### Description

References to external files in a policy are not supported. 

For example, in the NGINX App Protect WAF JSON declarative policy, these references are not supported:

- User-defined signatures
- Security controls in external references
- Referenced OpenAPI Spec files

---

## 2.5.0

### {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled {#39943}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39943    | Fixed in 2.8.0 |
{{</bootstrap-table>}}

#### Description

If you have Instance Manager 2.7 or earlier installed and attempt to enable both the API Connectivity Manager (ACM) and Security Monitoring (SM) modules on the same NGINX Management Suite management plane, the ACM module will not load because of incompatibility issues with the SM module.

#### Workaround

Before enabling the ACM and SM modules, ensure that your Instance Manager is upgraded to version 2.8 or later. Be sure to read the release notes for each module carefully, as they may contain important information about version dependencies.

To see which version of Instance Manager you have installed, run the following command:

- CentOS, RHEL, RPM-based:

   ```bash
   yum info nms-instance-manager
   ```

- Debian, Ubuntu, Deb-based:

   ```bash
   dpkg -s nms-instance-manager
   ```

---

### {{% icon-resolved %}} Instance Manager reports the NGINX App Protect WAF build number as the version {#37510}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 37510    | Fixed in 2.6.0 |
{{</bootstrap-table>}}

#### Description

After installing NGINX App Protect WAF 3.12 on the data plane and enabling NAP status reporting for the NGINX Agent, Instance Manager reports the App Protect version as build-3.1088.1 instead of 3.12.

This version mismatch does not affect system operations.

---

### {{% icon-bug %}} Aux data fails to upload if the size is greater than 3145728 characters {#37498}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 37498    | Open   |
{{</bootstrap-table>}}

#### Description

Updating a config with an aux data file exceeding 3145728 characters fails with a validation error similar to the following example:

> Request body has an error: doesn't match the schema: Error at "/auxFiles/files/3/contents": maximum string length is 3145728

---

### {{% icon-bug %}} Staged configs fail to publish after upgrading NGINX Management Suite {#37479}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 37479    | Open   |
{{</bootstrap-table>}}

#### Description

After upgrading NGINX Management Suite to 2.5.0, when you try to publish a staged config from the web interface, the system returns an error similar to the following: 

> "The published configuration is older than the active instance configuration."

#### Workaround

Make a minor edit to a staged config, such as adding a space, then save the change. You should be able to publish now.

---

### {{% icon-bug %}} "Deployment Not Found" error when publishing NGINX config to NATS server {#37437}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 37437    | Open   |
{{</bootstrap-table>}}

#### Description

Occasionally, when publishing an NGINX config to a NATS server, the system returns a `Deployment Not Found` error, and the `nms.log` file includes the following error:

> http failure with code '131043': \<nil>.

#### Workaround

Remove the existing NATs working directory and restart the NMS Data Plane Manager (`nms-dpm`) service as root.

{{<caution>}}Restarting the `nms-dpm` service is disruptive and may result in the loss of event data. You should schedule a maintenance window for restarting the service.{{</caution>}}

```bash
rm -rf /var/lib/nms/streaming
systemctl restart nms-dpm
```

---

### {{% icon-resolved %}} Instance Manager returns a "Download failed" error when editing an NGINX config for instances compiled and installed from source {#35851}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 35851    | Fixed in 2.7.0 |
{{</bootstrap-table>}}

#### Description

When an NGINX instance is compiled and installed from source without a prefix, if you edit the instance's config in Instance Manager, the system reports an error similar to the following example:

<pre>Error getting the NGINX instance configuration: failed to download the configuration. Check /var/log/nms/nms.log and nginx-agent logs for errors.</pre>

#### Workaround

To resolve or avoid this issue, take the following steps to [compile and install NGINX](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#compiling-and-installing-from-source) from source with a prefix and restart the NGINX Agent:

1. Stop the NGINX instance:

    ```bash
    sudo stop nginx
    ```

2. Locate the source code for the NGINX instance.

3. Add a prefix:

    ```bash
    ./auto/configure --prefix=</path/to/nginx> --without-http_rewrite_module
    ```

4. Compile and install NGINX:

    ```bash
    sudo make install
    ```

5. Start NGINX:

    ``` bash
    cd </path/to/nginx/sbin/>
    ./nginx
    ```

6. Restart the NGINX Agent:

    ```bash
    service nginx-agent restart
    ```

---

## 2.4.0

### {{% icon-bug %}} Publishing an instance group config with an aux file outside the allowed directory fails {#36410}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 36410    | Open   |
{{</bootstrap-table>}}

#### Description

If an instance group's configuration references an aux file (for example, an SSL certificate) that is not in the expected allowed directory, publishing the config will fail. The system returns an error similar to the following:

```text
Config apply failed (write): the file <filename> is outside the allowed directory list.
```

#### Workaround

Move the aux file to the allowed directory and update the configuration; for example, use `/etc/nginx/` for certificates.

---

## 2.3.0

### {{% icon-bug %}} Scan misidentifies some NGINX OSS instances as NGINX Plus {#35172}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 35172    | Open   |
{{</bootstrap-table>}}

#### Description

When NGINX Plus is installed on a data path instance, then removed and replaced with NGINX OSS, Instance Manager may incorrectly identify the instance as an NGINX Plus instance. This is due to multiple NGINX entries for the same data path.

#### Workaround

Use Instance Manager's NGINX Instances API to remove the inactive NGINX instance. For instructions, refer to the API reference guide, which you can find at `https://<NGINX-INSTANCE-MANAGER-FQDN>/ui/docs`.

You may need to stop the NGINX Agent first. To stop the NGINX Agent, run the following command:

```bash
sudo systemctl stop nginx-agent
```

---

### {{% icon-bug %}} Metrics may report additional data {#34255}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 34255    | Open   |
{{</bootstrap-table>}}

#### Description

Instance Manager reports metrics at a per-minute interval and includes dimensions for describing the metric data's characteristics.

An issue has been identified in which metric data is aggregated across all dimensions, not just for existing metrics data. When querying the Metrics API with aggregations like `SUM(metric-name)`, the aggregated data causes the API to over count the metric. This overcounting skews some of the metrics dashboards.

#### Workaround

When querying the Metrics API, you can exclude the data for an aggregated dimension by specifying the dimension name in the `filterBy` query parameter.

``` text
filterBy=<dimension-name>!= ''
```

---

## 2.2.0

### {{% icon-bug %}} Giving long names (255+ characters) to certificates causes internal error {#34185}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 34185    | Open   |
{{</bootstrap-table>}}

#### Description

When adding certificates, an internal error (error code: 134018) is returned if the name given for the certificate exceeds 255 characters.

#### Workaround

Use a name that is 255 or fewer characters.

---

## 2.1.0

### {{% icon-bug %}} Duplicate instances are shown after upgrading Agent to 2.1.0  {#33307}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 33307    | Open   |
{{</bootstrap-table>}}

#### Description

After upgrading to Instance Manager 2.1.0, and updating nginx-agent from platform packaging, duplicate instances may appear on the Instance overview page. This issue is caused by a change in how the NGINX Agent generates the `system_uid`.

#### Workaround

You can safely delete the older entries or wait for them to expire.

---

### {{% icon-bug %}} "No such process" error occurs when publishing a configuration {#33160}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 33160    | Open   |
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

### {{% icon-resolved %}} After upgrading to NGINX Instance Manager 2.1.0, the web interface reports timeouts when NGINX Agent configs are published {#32349}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 32349    | Fixed in 2.9.0 |
{{</bootstrap-table>}}

#### Description

After upgrading to NGINX Instance Manager 2.1.0 from a package installation, the web interface reports timeouts when publishing NGINX Agent configs, although the updates are successfully published.

#### Workaround

To resolve these errors, restart the following NGINX Management Suite services after upgrading NGINX Instance Manager:

```bash
sudo systemctl restart nms-core
sudo systemctl restart nms-dpm
sudo systemctl restart nms-ingestion
```

---

## 2.0.0

### {{% icon-resolved %}} Scan does not update an unmanaged instance to managed {#37544}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 37544    | Fixed in 2.9.0 |
{{</bootstrap-table>}}

#### Description

Unmanaged instances are reported when scanning your network for NGINX instances. When you install the NGINX Agent on an unmanaged instance and scan again, the NGINX instance is still shown as unmanaged.

---
### {{% icon-bug %}} NGINX App Protect WAF blocks Instance Manager from publishing configurations {#32718}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 32718    | Open   |
{{</bootstrap-table>}}

#### Description

Instance Manager does not currently support managing NGINX App Protect WAF instances. NGINX App Protect WAF may block attempts to publish configurations to NGINX App Protect WAF instances.

---

### {{% icon-bug %}} Instance Manager reports old NGINX version after upgrade {#31225}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 31225    | Open   |
{{</bootstrap-table>}}

#### Description

After upgrading NGINX to a new version, the Instance Manager web interface and API report the old NGINX version until the NGINX Agent is restarted.

#### Workaround

Restart the Agent to have the new version reflected properly:

```bash
systemctl restart nginx-agent
```

---

### {{% icon-bug %}} Web interface doesn't report error when failing to upload large config files {#31081}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 31081    | Open   |
{{</bootstrap-table>}}

#### Description

In the web interface, when uploading a config file that's larger than 50 MB (max size), the system incorrectly reports the state as `Analyzing` (Status code `403`), although the upload failed.

#### Workaround

Keep config files under 50 MB.

---

### {{% icon-bug %}} CentOS 7, RHEL 7, and Amazon Linux 2 package managers allow unsupported NGINX/NGINX Plus versions {#28758}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 28758    | Open   |
{{</bootstrap-table>}}

#### Description

When installing on CentOS 7, RHEL 7, and Amazon Linux 2, the package manager doesn't prevent installing Instance Manager with unsupported versions of NGINX or NGINX Plus. As a consequence, it is possible that `nms-instance-manager` is installed without an NGINX gateway. Resulting in a less than optimal experience.

#### Workaround

Install a supported version of NGINX (v1.18 or later) or NGINX Plus (R22 or later). See the [Technical Specifications]({{< relref "/tech-specs.md" >}}) guide for details.

---

### {{% icon-bug %}} gRPC errors when starting Instance Manager {#28683}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 28683    | Open   |
{{</bootstrap-table>}}

#### Description

  When starting Instance Manager, you may see errors similar to the following in `/etc/nginx/conf.d/nms-http.conf:227`:
  
  ```text
  nginx[1234]: nginx: [emerg] unknown directive "grpc_socket_keepalive"
  ```

#### Workaround

Make sure your version of NGINX is v1.18 or later. See the [Technical Specifications]({{< relref "/tech-specs.md" >}}) guide for details.
