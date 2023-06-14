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

{{< tip >}}We recommend you [upgrade to the latest version of Instance Manager](https://docs.nginx.com/nginx-management-suite/installation/upgrade-guide/) to take advantage of new features, improvements, and bug fixes.{{< /tip >}}

---

## 2.11.0


### {{% icon-bug %}} Querying API endpoints for Security deployments associations may return empty UIDs for Attack-Signatures and Threat-Campaigns {#43034}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43034    | Open   |
{{</bootstrap-table>}}

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

### {{% icon-bug %}} Publication status of instance groups may be shown as 'not available' after restarting NGINX Management Suite {#43016}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43016    | Open   |
{{</bootstrap-table>}}

#### Description

After restarting the NGINX Management Suite services, the publication status of instance groups for deployments that include a security policy may show as 'not available'.

#### Workaround

Redeploy a new version of the security policy or an updated 'nginx.conf'.

---

### {{% icon-bug %}} When adding a Certs RBAC permission, the "Applies to" field may display as "nginx-repo" {#43012}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43012    | Open   |
{{</bootstrap-table>}}

#### Description

In certain situations, when you update a certificate or key using the NGINX Management Suite web interface, and subsequently add or edit a Certificate permission for Role-Based Access Control (RBAC) in **Settings > Roles**, you may notice that the "Applies to" name appears as "nginx-repo".

#### Workaround

Use the unique identifier to assign specific permissions to a particular certificate and key pair.

---

### {{% icon-bug %}} Agent 2.26 has issues when deployed in RHEL9 with SELinux {#43010}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43010    | Open   |
{{</bootstrap-table>}}

#### Description

NGINX Agent 2.26, which is packaged with Instance Manager 2.11, may fail to start on RHEL 9 systems with SELinux enabled. An error similar to the following is logged: "Unable to read dynamic config".

#### Workaround

Use an earlier version of the NGINX Agent. You can install the NGINX Agent from [GitHub](https://github.com/nginx/agent) or the [NGINX Plus repository]({{< relref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md" >}}).

---

### {{% icon-bug %}} Error: "Failed to create secret" when reinstalling or upgrading NGINX Management Suite in Kubernetes {#42967}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42967    | Open   |
{{</bootstrap-table>}}

#### Description

When deploying NGINX Management Suite in Kubernetes, if you have previously run the support package script and the output is still in the default location, you may encounter an error message similar to the following example when reinstalling or upgrading NGINX Management Suite:

`Failed to create: Secret "sh.helm.release.v1.(release-name).v1"`

#### Workaround

Delete or move the support package output files: `nms-hybrid/support-package/k8s-support-pkg-*.tgz`.

---

### {{% icon-bug %}} Updating Attack Signatures or Threat Campaigns on multiple instances simultaneously updates only one instance {#42838}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42838    | Open   |
{{</bootstrap-table>}}

#### Description

When updating Attack Signatures or Threat Campaign packages on multiple instances simultaneously, only one instance may be successfully updated. An error similar to the following is logged: `security policy bundle object with given ID was not found.`

#### Workaround

Update the Attack Signatures or Threat Campaigns package one instance at a time.

---

## 2.10.0

### {{% icon-bug %}} Unable to publish configurations referencing the log bundle for Security Monitor {#42932}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42932    | Open   |
{{</bootstrap-table>}}

#### Description

Configuration deployments that reference the log bundle for Security Monitoring (app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;), may fail with an error message similar to the following:

<instance>: error while retrieving NGINX App Protect profile bundle secops_dashboard info for NAP version 4.279.0: Not Found. Please create it first.
<br>

#### Workaround

On the NGINX Management Suite host, restart platform services:

```bash
sudo systemctl restart nms
```

---

### {{% icon-resolved %}} Valid licenses incorrectly identified as invalid {#42598}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 42598    | Fixed in 2.10.1 |
{{</bootstrap-table>}}

#### Description

Sometimes, valid licenses for NGINX Management Suite are incorrectly identified as invalid when uploaded. As a result, you may not be able to access features that require a valid license.

---

###  {{% icon-resolved %}} Certificate updates allow for multiples certs to share the same serial number {#42429}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 42429    | Fixed in 2.11.0 |
{{</bootstrap-table>}}

#### Description

It is possible to update an existing certificate's serial number to one already in use. This incorrectly changes the cert (matching the serial number) details to a new name.

---

###  {{% icon-resolved %}} Certificate file is not updated automatically under certain conditions {#42425}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 42425    | Fixed in 2.11.0 |
{{</bootstrap-table>}}

#### Description

Certificate file is not updated automatically when a config change is pushed to an offline instance after it comes back online.

---

### {{% icon-resolved %}} The Metrics module is interrupted during installation on Red Hat 9 {#42219}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 42219    | Fixed in 2.11.0 |
{{</bootstrap-table>}}

#### Description

When installing the Metrics module on Red Hat 9, the following error will prevent it from finishing:

```text
warning: Signature not supported. Hash algorithm SHA1 not available.
error: /tmp/nginx_signing.key: key 1 import failed.

Failed to import nginx signing key. exiting.
```

#### Workaround

Before installation, run the following command:

```text
sudo update-crypto-policies --set DEFAULT:SHA1
```

After installation, we recommend you return the default to a more secure algorithm such as SHA256.

---

### {{% icon-bug %}} When publishing a new version of Threat Campaign, the last two versions in the list cannot be selected {#42217}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42217    | Open   |
{{</bootstrap-table>}}

#### Description

The list of Threat Campaigns will disappear when scrolling down, preventing the selection of the oldest versions.
<br>

#### Workaround

Threat Campaign versions can be published with the API using the route: `api/platform/v1/security/publish`

---

### {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates {#42182}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 42182    | Fixed in 2.11.0 |
{{</bootstrap-table>}}

#### Description

When deploying a configuration with a certificate and key handled by NGINX Management Suite to a custom file path, it may deploy a duplicate copy of the certificate and key to the default `/etc/nginx/` path. When deleting the certificate and key, it will only delete the certificate and key in the custom path, leaving the duplicate copy.
<br>

#### Workaround

Manually delete the certificate and key from the `/etc/nginx/` path.

---

### {{% icon-bug %}} When upgrading to Instance Manager 2.10, there may be warnings from the Ingestion service {#42133}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42133    | Open   |
{{</bootstrap-table>}}

#### Description

When upgrading to 2.10.0 you may see a warning like the below message for the NGINX Management Suite Ingestion service. It can be safely ignored.

```text
[WARN] #011/usr/bin/nms-ingestion   #011start/start.go:497  #011error checking migrations Mismatched migration version for ClickHouse, expected 39 migrations to be applied, currently have only 44 migrations applied.
```

---

### {{% icon-bug %}} When upgrading to Instance Manager 2.10.0, the API does not return lastDeploymentDetails for existing configurations {#42119}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42119    | Open   |
{{</bootstrap-table>}}

#### Description

When upgrading to Instance Manager 2.10.0, the API does not return `lastDeploymentDetails` for existing configuration blocks. This is then reflected as "Invalid Date" in the web interface (See [42108](#42108)).
<br>

#### Workaround

Republish the configuration for the affected configuration blocks.

---

### {{% icon-bug %}} When upgrading to Instance Manager 2.10.0, the publish status on App Security pages shows "Invalid Date" {#42108}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42108    | Open   |
{{</bootstrap-table>}}

#### Description

After upgrading to Instance Manager 2.10.0, the publish status on App Security pages of Policies, Attack Signatures, and Threat Campaign shows "Invalid Date" until new configurations are published to the instance or instance group. 

---

### {{% icon-bug %}} Configuration changes for NGINX Agent take longer than expected. {#41257}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 41257    | Open   |
{{</bootstrap-table>}}

#### Description

NGINX Agent introduced the `config_reload_monitoring_period` parameter under `nginx` to define the duration which Agent will monitor the logs for relevant errors and warnings after a configuration change. As a result, configuration changes will take at least one second to appear.
<br>

#### Workaround

Adjust the `config_reload_monitoring_period` parameter to a value that suits your workflow. 

---

## 2.9.1

### {{% icon-bug %}} OIDC-authenticated users can't view the Users list using the API or web interface {#43031}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43031    | Open   |
{{</bootstrap-table>}}

#### Description

When you use OIDC-based authentication in NGINX Management Suite, if the identity provider (IdP) sends an email address with an invalid format, users will be unable to access the list of Users through the web interface or API.

#### Workaround

To resolve this issue, please update the email addresses in your identity provider and ensure that all addresses are properly formatted. Once the email addresses are correctly formatted, users will be able to view the list of Users in the NGINX Management Suite.

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

### {{% icon-resolved %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" {#41157}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 41157    | Fixed in 2.10.0 |
{{</bootstrap-table>}}

#### Description

Attempting to install NGINX Agent on FreeBSD fails with an error message: "error 2051: not implemented."

#### Workaround

If you are using FreeBSD, you can download the NGINX Agent from [https://github.com/nginx/agent/releases/tag/v2.23.2]( https://github.com/nginx/agent/releases/tag/v2.23.2) or use a previously installed version.

---

## 2.8.0

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

### {{% icon-bug %}} System reports "Attack Signature does not exist" when publishing default Attack Signature {#40020}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 40020    | Open   |
{{</bootstrap-table>}}

#### Description

The default Attack Signature (2019.07.16) is not being added to the Attack Signature database, which means it is unavailable for publishing from the control plane, even though it is listed in the web interface. Attempting to publish this Attack Signature results in the error message "Error publishing the security content: attack signature does not exist."

#### Workaround

[Download the latest version of the Attack Signature and publish it]({{< relref "/nms/nim/how-to/app-protect/setup-waf-config-management" >}}). Attack Signature 2019.07.16 should be removed from the list when you refresh the web interface.

---

## 2.7.0

### {{% icon-resolved %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed {#41327}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 41327    | Fixed in 2.10.0 |
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
       curl -k https://<NMS_FQDN>/packages-repository/nginx-signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-signing.gpg >/dev/null
       ```

2. Update the `nginx-agent.list` file to reference the new key:

    ```shell
    printf "deb [signed-by=/usr/share/keyrings/nginx-signing.gpg] https://<NMS_FQDN>/packages-repository/deb/ubuntu `lsb_release -cs` agent\n" | sudo tee /etc/apt/sources.list.d/nginx-agent.list
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

### {{% icon-bug %}} App Protect Policies page fails when deployed via Helm chart {#38782}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38782    | Open   |
{{</bootstrap-table>}}

#### Description

When installing NGINX Instance Manager on Kubernetes via Helm Chart, the App Protect page shows an error banner, and no default policies are displayed.

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

- Add the referenced cert to NGINX Management Suite as managed certificate and publish the config again.
- Move the referenced remote certificate to a directory that's not in the allowed directory list.

---

### {{% icon-bug %}} When upgrading a multi-node NGINX Management Suite deployment with helm charts the core, dpm, or integrations pods may fail to start {#38589}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38589    | Open   |
{{</bootstrap-table>}}

#### Description

When using the NGINX Management Suite Instance Manager Helm upgrade command on a multi worker node Kubernetes cluster setup, the core, dpm and integrations deployments may fail to upgrade.

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

### {{% icon-bug %}} HTTP version schema returns incorrect value in Advanced metrics module {#38041}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38041    | Open   |
{{</bootstrap-table>}}

#### Description

The values currently populated for http.version_schema are incorrect. The response is "4" for HTTP traffic and "6" for HTTPS traffic.

---

### {{% icon-resolved %}} Count of NGINX Plus graph has a delay in being populated {#37705}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status          |
|----------|-----------------|
| 37705    | Fixed in 2.11.0 |
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

Remove the existing NATs working directory and restart the NGINX Management Suite Data Plane Manager (`nms-dpm`) service as root.

{{<caution>}}Restarting the `nms-dpm` service is disruptive and may result in the loss of event data. You should schedule a maintenance window for restarting the service.{{</caution>}}

```bash
rm -rf /var/lib/nms/streaming
systemctl restart nms-dpm
```

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

## 2.0.0

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

Install a supported version of NGINX (v1.18 or later) or NGINX Plus (R22 or later). See the [Technical Specifications]({{< relref "/nms/tech-specs.md" >}}) guide for details.

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

Make sure your version of NGINX is v1.18 or later. See the [Technical Specifications]({{< relref "/nms/tech-specs.md" >}}) guide for details.
