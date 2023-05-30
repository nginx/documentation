---
title: "Release Notes"
date: 2022-03-30T12:38:24-08:00
draft: false
description: "These release notes list and describe the new features, enhancements, and resolved issues in NGINX Management Suite Instance Manager."
# Assign weights in increments of 100
weight: 1
toc: true
tags: [ "docs" ]
docs: "DOCS-938"
categories: ["release notes"]
doctypes: ["reference"]
aliases:
- /nginx-instance-manager/releases/nim-2.1.0/
- /nginx-instance-manager/releases/nim-2.0.1/
- /nginx-instance-manager/releases/nim-2.0.0/
---

{{<rn-styles>}}

## 2.11.0

June 7, 2023

### Upgrade Paths {#2-11-0-upgrade-paths}

Instance Manager 2.11.0 supports upgrades from these previous versions:

- 2.8.0–2.10.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.{{</see-also>}}

### What's New {#2-11-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **The config editor now lets you see auxiliary files**

  Auxiliary files, such as certificate files and other non-config files on managed instances or instance groups, are now visible in the file tree of the config editor view. This improvement makes it easier to reference these files within a configuration.

- {{% icon-feature %}} **Introducing new predefined log profiles for NGINX App Protect WAF**

  Now, managing your NGINX App Protect WAF configuration is even easier with new predefined log profiles. In addition to the existing log_all, log_blocked, log_illegal, and log_secops log profiles, the following new predefined log profiles are now available:

  - log_f5_arcsight
  - log_f5_splunk
  - log_grpc_all
  - log_grpc_blocked
  - log_grpc_illegal

  These new log profiles make it even easier to integrate NGINX App Protect WAF with other logging systems, such as Splunk, ArcSight, and gRPC.

- {{% icon-feature %}} **You can now install Advanced Metrics automatically when you install NGINX Agent**

  When installing the NGINX Agent with NGINX Management Suite, you can include the `-a` or `--advanced-metrics` flag. Including this option installs the Advanced Metrics module along with the NGINX Agent. With this module, you gain access to extra metrics and insights that enrich the monitoring and analysis capabilities of the NGINX Management Suite, empowering you to make more informed decisions.

- {{% icon-feature %}} **NGINX Management Suite can send telemetry data to F5 NGINX**

  In order to enhance product development and support the success of our users with NGINX Management Suite, we offer the option to send limited telemetry data to F5 NGINX. This data provides valuable insights into software usage and adoption. By default, telemetry is enabled, but you have the flexibility to disable it through the web interface or API. For detailed information about the transmitted data, please refer to our documentation.


### Changes in Default Behavior {#2-11-0-changes-default-behavior}

Instance Manager 2.11.0 has the following changes in default behavior:

- **<span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **Action Required:**</span> Update OIDC configurations for management plane after upgrading to Instance Manager 2.11.0**

  In Instance Manager 2.11.0, we added support for telemetry to the OIDC configuration files. Existing OIDC configurations will continue to work, but certain telemetry events, such as login, may not be captured.
  
  To ensure the capture of login telemetry events, please take the following steps:

  1. Before upgrading, create copies of the following two files:

     - /etc/nms/nginx/oidc/openid_configuration.conf
     - /etc/nginx/conf.d/nginx.conf

  2. During the upgrade process, you will be prompted to replace the two files. Select the option to replace them.

  3. After completing the upgrade, update the two files using the OIDC settings from the backup copies you created in step 1.

- {{% icon-feature %}} **Configuration file permissions have been lowered to strengthen security**

  To strengthen the security of configuration details, certain file permissions have been modified. Specifically, the following configuration files now have lowered permissions, granting Owner Read/Write access and Group Read access (also referred to as `0640` or `rw-r-----`):

  - /etc/nms/nginx.conf
  - /etc/nginx/conf.d/nms-http.conf
  - /etc/nms/nginx/oidc/openid_configuration.conf
  - /etc/nms/nginx/oidc/openid_connect.conf

  Additionally, the following file permissions have been lowered to Owner Read/Write and Group Read/Write access (also known as `0660` or `rw-rw-----`):

  - /logrotate.d/nms.conf
  - /var/log/nms/nms.log

  These changes aim to improve the overall security of the system by restricting access to sensitive configuration files while maintaining necessary privileges for authorized users.

- {{% icon-feature %}} **The location of agent-dynamic.conf has changed**

  In this release, the agent-dynamic.conf file has been moved from /etc/nginx-agent/ to /var/lib/nginx-agent/. To assign an instance group and tags to an instance, you will now need to edit the file located in /var/lib/nginx-agent/. 

### Resolved Issues {#2-11-0-resolved-issues}

This release fixes the following issues. Select an issue's ID link to view its details.


- {{% icon-resolved %}} Count of NGINX Plus graph has a delay in being populated [(37705)]({{< relref "/nms/nim/releases/known-issues.md#37705" >}})

- {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates [(42182)]({{< relref "/nms/nim/releases/known-issues.md#42182" >}})

- {{% icon-resolved %}} The Metrics module is interrupted during installation on Red Hat 9 [(42219)]({{< relref "/nms/nim/releases/known-issues.md#42219" >}})

- {{% icon-resolved %}} Certificate file is not updated automatically under certain conditions [(42425)]({{< relref "/nms/nim/releases/known-issues.md#42425" >}})

- {{% icon-resolved %}} Certificate updates allow for multiples certs to share the same serial number [(42429)]({{< relref "/nms/nim/releases/known-issues.md#42429" >}})


### Support for NGINX App Protect WAF

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## 2.10.1

5/22/2023

### Upgrade Paths {#2-10-1-upgrade-paths}

Instance Manager 2.10.1 supports upgrades from these previous versions:

- 2.7.0–2.10.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent. {{</see-also>}}


### Resolved Issues {#2-10-1-resolved-issues}

This release fixes the following issues. Select an issue's ID link to view its details.


- {{% icon-resolved %}} Valid licenses incorrectly identified as invalid [(42598)]({{< relref "/nms/nim/releases/known-issues.md#42598" >}})


### Support for NGINX App Protect WAF

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## 2.10.0

April 26, 2023

### Upgrade Paths {#2-10-0-upgrade-paths}

Instance Manager 2.10.0 supports upgrades from these previous versions:

- 2.7.0–2.9.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.{{</see-also>}}

### What's New {#2-10-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **New "Category" Filter in the Events web interface**

  You can now filter entries in the Events web interface using a new "Category" filter. Categories for event entries include "Certs," "Instance Groups," and "Templates."

- {{% icon-feature %}} **New NGINX Agent install flag for NGINX App Protect WAF**

  The NGINX Agent installation script now has a flag to enable the default configuration required for NGINX App Protect WAF. It is used to retrieve the deployment status and `precompiled_publication` mode, with an option for the NGINX App Protect WAF instance to use the mode for policies.

- {{% icon-feature %}} **NGINX Management Suite version now visible in the web interface and API**

  You can now look up the NGINX Management Suite and NGINX Instance Manager versions in the web interface and API. Other module versions are also visible, though older versions of API Connectivity Manager and Security Monitoring may appear as undefined.

- {{% icon-feature %}} **NGINX Management Suite can now use NGINX Ingress Controller to manage routing**

  The NGINX Management Suite Helm Chart can now generate an NGINX Ingress Controller VirtualServer definition, which can be used to expose NGINX Management Suite when running in your Kubernetes cluster.  
  
  More about the VirtualServer custom resource can be found here: https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/

- {{% icon-feature %}} **Configuration Publication Status now visible in App Security pages**

  The most recent publication date and status for an instance's configuration is now visible on App Security Pages. This reflects configuration for NGINX, NGINX App Protect policies, Attack Signatures, and Threat Campaigns.

- {{% icon-feature %}} **Instance Manager can now automatically retrieve WAF compilers associated with NGINX App Protect instances**

  Using a user-provided NGINX repository certificate and key after the first setup of the WAF compiler, Instance Manager can automatically retrieve WAF compilers associated with NGINX App Protect instances. These can be used to publish App Protect WAF configurations in `precompiled_publication` mode.

- {{% icon-feature %}} **Add option to toggle ICMP scanning in the web interface**

  You can now explicitly enable or disable ICMP scanning at the top of the "Scan" interface.

- {{% icon-feature %}} **New NGINX Agent install flag for Security Monitoring**

  The NGINX Agent installation script now has a flag to enable the default configuration required for the Security Monitoring module.

### Changes in Default Behavior {#2-10-0-changes-default-behavior}

Instance Manager 2.10.0 has the following changes in default behavior:

- {{% icon-feature %}} **Improvements to Role Based Access Control for SSL Certificate and Key management**

  Role Based Access Control for SSL Certificate and Key management can now use three different objects for precise controls: certificates, systems, and instance groups. Using certificates as an object controls the viewing and assigning of specific certificate and key pairs. Using systems or instance groups allows a user to see all certificates but restricts access for publishing.

- {{% icon-feature %}} **By default, NGINX Management Suite is not exposed to the internet when installed with a Helm Chart**

  When NGINX Management Suite is installed using a Helm Chart, it now defaults to a ClusterIP without an external IP address.


### Resolved Issues {#2-10-0-resolved-issues}

This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" [(41157)]({{< relref "/nms/nim/releases/known-issues.md#41157" >}})

- {{% icon-resolved %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed [(41327)]({{< relref "/nms/nim/releases/known-issues.md#41327" >}})


### Support for NGINX App Protect WAF

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## 2.9.1

April 6, 2023

### Upgrade Paths {#2-9-1-upgrade-paths}

Instance Manager 2.9.1 supports upgrades from these previous versions:

- 2.6.0–2.9.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.{{</see-also>}}

### Resolved Issues {#2-9-1-resolved}

This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} NGINX configurations with special characters may not be editable from the web interface after upgrading Instance Manager ([41557]({{< relref "/nms/nim/releases/known-issues.md#41557" >}}))

---

## 2.9.0

March 21, 2023

### Upgrade Paths {#2-9-0-upgrade-paths}

Instance Manager 2.9.0 supports upgrades from these previous versions:

- 2.6.0–2.8.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.{{</see-also>}}

### What's New {#2-9-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **New webpages for viewing Attack Signature and Threat Campaigns**

  The Instance Manager web interface now allows you to view Attack Signatures and Threat Campaign packages published to instances and instance groups. You can also publish these packages using the precompiled publication mode.

- {{% icon-feature %}} **NGINX Agent supports Rocky Linux 8 and 9**

  The NGINX Agent now supports Rocky Linux 8 (x86_64, aarch64) and 9 (x86_64, aarch64).  The NGINX Agent supports the same distributions as NGINX Plus. For a list of the supported distributions, refer to the [NGINX Plus Technical Specs](https://docs.nginx.com/nginx/technical-specs/#supported-distributions) guide.

- {{% icon-feature %}} **New Events for CUD actions**

  Events will be triggered for `CREATE`, `UPDATE`, and `DELETE` actions on Templates, Instances, Certificates, Instance Groups, and Licenses.

- {{% icon-feature %}} **The _Certificate and Keys_ webpage has a new look!**

  Our new and improved _Certificates and Keys_ webpage makes it easier than ever to efficiently manage your TLS certificates.

- {{% icon-feature %}} **Add commit hash details to NGINX configurations for version control**

  Use the Instance Manager REST API to add a commit hash to NGINX configurations if you use version control, such as Git.

  For more information, see the following topics:

  - [Add Hash Versioning to Staged Configs]({{< relref "/nms/nim/how-to/nginx/stage-configs.md#hash-versioning-staged-configs" >}})
  - [Publish Configs with Hash Versioning to Instances]({{< relref "/nms/nim/how-to/nginx/publish-configs.md#publish-configs-instances-hash-versioning" >}})
  - [Publish Configs with Hash Versioning to Instance Groups]({{< relref "/nms/nim/how-to/nginx/publish-configs.md#publish-configs-instance-groups-hash-versioning" >}})

### Security Update {#2-9-0-security-update}

{{< important >}}For the protection of our customers, NGINX doesn't disclose security issues until an investigation has occurred and a fix is available.{{< /important >}}

This release includes the following security update:

{{< include "release-notes/41215.md" >}}

### Changes in Default Behavior {#2-9-0-changes-default-behavior}

Instance Manager 2.9.0 has the following changes in default behavior:

- <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **BREAKING CHANGE!**</span> **OIDC configurations for the management plane must be updated after upgrading to Instance Manager 2.9.0**

  OIDC configuration files were modified to improve support for automation and integration in CI/CD pipelines. To continue using OIDC after upgrading to Instance Manager 2.9.0, you'll need to update these configuration files.

  To take advantage of the expanded functionality for OIDC authentication with NGINX Management Suite, we recommend following these two options:

  **Option 1**
  
  1. During the upgrade, type `Y` when prompted to respond `Y or I: install the package mainatiner's version` for each of the following files:

     - `/etc/nms/nginx/oidc/openid_configuration.conf`
     - `/etc/nms/nginx/oidc/openid_connect.conf`
     - `/etc/nms/nginx/oidc/openid_connect.js`

  1. After the upgrade finishes, make the following changes to the `/etc/nms/nginx/oidc/openid_configuration.conf` file using the `/etc/nms/oidc/openid_connect.conf.dpkg-old` that was created as a backup:

       - Uncomment the appropriate "Enable when using OIDC with" for your IDP (for example, keycloak, azure).
       - Update `$oidc_authz_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_token_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_jwt_keyfile` value with the corresponding values from `openid_connect.conf.dpkg-old`.
       - Update `$oidc_client` and `oidc_client_secret` with corresponding values from `openid_connect.conf.dpkg-old`.
       - Review and restore any other customizations from `openid_connect.conf.dpkg-old` beyond those mentioned above.

  1. Save the file.
  1. Restart NGINX Management Suite:

      ```bash
      sudo systemctl restart nms
      ```

  1. Restart the NGINX web server:

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

- {{% icon-feature %}} **SSL Certificates can be associated with Instance Groups**

  When assigning SSL certificates for the NGINX data plane, you have the option of associating them with a single instance or with an instance group. When associated with an instance group, the certificates will be shared across all instances in the group.

### Resolved Issues {#2-9-0-resolved}

This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} After upgrading to NGINX Instance Manager 2.1.0, the web interface reports timeouts when NGINX Agent configs are published (32349)

- {{% icon-resolved %}} The Type text on the Instances overview page may be partially covered by the Hostname text (39760)

- {{% icon-resolved %}} Scan does not update an unmanaged instance to managed (37544)

- {{% icon-resolved %}} To publish security policies with Instance Manager, set the "precompiled_publication" parameter to "true" in the `nginx-agent.conf` file (39614)

- {{% icon-resolved %}} App Protect: "Assign Policy and Signature Versions" webpage may not initially display newly added policies (40085)

- {{% icon-resolved %}} Upgrading NGINX Management Suite may remove the OIDC configuration for the platform (41328)

### Known Issues {#2-9-0-known-issues}

- You can find information about known issues with Instance Manager in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

### Support for NGINX App Protect WAF {#2-9-0-support-for-nap-waf}

{{< include "tech-specs/nim-app-protect-support.md" >}}

### Open Source Licenses {#2-9-0-fossa}

The following open-source software is used by Instance Manager:

- {{< link "/fossa/license-nms.md" "Third-party software and licenses for Instance Manager" >}}
- [github.com/opencontainers/runc](https://github.com/opencontainers/runc)
- [go-genproto](https://github.com/googleapis/go-genproto)

Additionally, you can find the list of open-source packages and their licenses in `/etc/nms/license-nms.md` after installing Instance Manager.

---

## 2.8.0

January 30, 2023

### Upgrade Paths

Instance Manager 2.8.0 supports upgrades from these previous versions:

- 2.5.0–2.7.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.0 or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.0. Direct upgrades from Instance Manager 1.0 and earlier are not supported.{{< /see-also >}}

### What's New

This release includes the following new features and updates:

- {{% icon-feature %}} **Enhanced details page for SSL Certificates**

  The Instance Manager web interface now features an improved details page for SSL Certificates. This page provides important information about the certificate and any associated instances.

- {{% icon-feature %}} **Automatic retrieval of Attack Signatures and Threat Campaign updates to Instance Manager**

  Instance Manager now allows you to [set up automatic downloads of the most recent Attack Signature and Threat Campaign packages]({{< relref "/nms/nim/how-to/app-protect/setup-waf-config-management.md##automatically-download-latest-packages" >}}). By publishing these updates to your App Protect instances from Instance Manager, you can ensure your applications are shielded from all recognized attack types.

- {{% icon-feature %}} **Improved WAF Compiler error messages**

  The messaging around [security policy compilation errors]({{< relref "/nms/nim/how-to/app-protect/manage-waf-security-policies.md#check-for-compilation-errors" >}}) has been improved by providing more detailed information and alerting users if the required compiler version is missing.

### Changes in Default Behavior

Instance Manager 2.8.0 has the following changes in default behavior:

- {{% icon-feature %}} **Switching between storing secrets on disk and using Vault migrates secrets**

  When transitioning between storing secrets on disk or using HashiCorp Vault, any existing secrets can be easily migrated to the new storage method. For instructions, refer to the guide [Configure Vault for Storing Secrets]({{< relref "/nms/admin-guides/configuration/configure-vault.md" >}}).

- {{% icon-feature %}} **Create roles using either an object name or UID**

  You can now use either an object name or a unique identifier (UID) when assigning object-level permissions while creating or editing a role via the Instance Manager REST API.

- {{% icon-feature %}} **Upgrading from 2.7 or earlier, you must re-enable `precompiled_publication` to continue publishing security policies with Instance Manager**

  To continue publishing security policies with Instance Manager if you're upgrading from Instance Manager 2.7 and earlier, you must set the  `precompiled_publication` parameter to `true` in the `nginx-agent.conf` file.

  In Instance Manager 2.7 and earlier, the `pre-compiled_publication` setting was set to `true` by default. However, starting with Instance Manager 2.8, this setting is set to `false` by default. This means you'll need to change this setting to `true` again when upgrading from earlier versions.

  To publish App Protect policies from Instance Manager, add the following to your `nginx-agent.conf` file:

  ```yaml
    nginx_app_protect: 
       precompiled_publication: true   
  ```

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).

- {{% icon-resolved %}} Web interface reports no license found when a license is present (30647)

- {{% icon-resolved %}} Associating instances with expired certificates causes internal error (34182)

- {{% icon-resolved %}} Publishing to an Instance/instance-group will fail when the configuration references a JSON policy or a JSON log profile  (38357)

- {{% icon-resolved %}} Missing dimension data for Advanced Metrics with modules (38634)

- {{% icon-resolved %}} Large payloads can result in disk I/O error for database operations (38827)

- {{% icon-resolved %}} The Policy API endpoint only allows NGINX App Protect policy upsert with content length up to 3.14MB. (38839)

- {{% icon-resolved %}} Deploy NGINX App Protect policy is listed as "Not Deployed" on the Policy Version detail page (38876)

- {{% icon-resolved %}} NGINX Management Suite services may lose connection to ClickHouse in a Kubernetes deployment (39285)

- {{% icon-resolved %}} NGINX App Protect status may not be displayed after publishing a configuration with a security policy and certificate reference (39382)

- {{% icon-resolved %}} Security Policy Snippet selector adds incorrect path reference for policy directive (39492)

- {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled (39943)

### Known Issues {#2-8-0-known-issues}

- You can find information about known issues with Instance Manager in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

### Support for NGINX App Protect WAF {#support-for-nap-waf}

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## 2.7.0

December 20, 2022

### Upgrade Paths

Instance Manager 2.7.0 supports upgrades from the following versions:

- 2.4.0–2.6.0

If you are using an older version of Instance Manager, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### What's New

This release includes stability and performance improvements.

### Changes in Default Behavior

Instance Manager 2.7.0 has the following changes in default behavior:

- {{% icon-feature %}} **NGINX App Protect upgrades are supported**

  You can upgrade NGINX App Protect WAF on managed instances where Instance Manager publishes NGINX App Protect policies and configurations. For example, upgrade from App Protect release 3.12.2 to release 4.0.

- {{% icon-feature %}} **NGINX Management Suite Config file is now in YAML format**

  With the release of NGINX Instance Manager 2.7, the NGINX Management Suite configuration file is now in YAML format. Through the upgrade process, your existing configuration will automatically be updated. Any settings you have customized will be maintained in the new format. If you have existing automation tooling for the deployment of the NGINX Management Suite that makes changes to the configuration file, you will need to update it to account for the change.

- {{% icon-feature %}} **Existing NGINX Agent configuration kept during upgrade to the latest version**

  When upgrading NGINX Agent, the existing NGINX Agent configuration is maintained during the upgrade. If the Agent configuration is not present in `/etc/nginx-agent/nginx-agent.conf`, a default configuration is provided after NGINX Agent installation.

### Resolved Issues

This release fixes the following issues:

- {{% icon-resolved %}} Instance Manager returns a "Download failed" error when editing an NGINX config for instances compiled and installed from source (35851)

- {{% icon-resolved %}} Null data count is not correctly represented in the NGINX Plus usage graph. (38206)

- {{% icon-resolved %}} When upgrading Instance Manager from v2.4 to later versions of Instance Manager, certificate associations are no longer visible. (38641)

- {{% icon-resolved %}} NGINX App Protect policy deployment status not reflecting removal of associated instance. (38700)

- {{% icon-resolved %}} When upgrading a multi-node NGINX Management Suite deployment with helm charts the ingestion pod may report a "Mismatched migration version" error (38880)

- {{% icon-resolved %}} After a version upgrade of NGINX Instance Manager, NGINX Management Suite Data Plane Manager crashes if you publish NGINX configuration with App Protect enablement directive (app_protect_enable) set to ON (38904)

### Known Issues

- To view the known issues in this release, see the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

### Support for NGINX App Protect WAF {#support-for-nap-waf}

{{< include "tech-specs/nim-app-protect-support.md" >}}

---

## 2.6.0

November 17, 2022

### Upgrade Paths

Instance Manager 2.6.0 supports upgrades from the following versions:

- 2.3.0–2.5.1

If you are using an older version of Instance Manager, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Manage and deploy configurations to NGINX App Protect WAF Instances**

  This release introduces the following features to [manage and deploy configurations to NGINX App Protect instances]({{< relref "/nms/nim/about/app-protect-waf-cm-overview.md" >}}):

  - Create, upsert, and delete NGINX App Protect WAF security policies
  - Manage NGINX App Protect WAF security configurations by using the NGINX Management Suite user interface or REST API
  - Update Signatures and Threat Campaign packages
  - Compile security configurations into a binary bundle that can be consumed by NGINX App Protect WAF instances

  {{<see-also>}}See the [Support for NGINX App Protect WAF](#support-for-nap-waf) section for compatibility requirements.{{</see-also>}}

- {{% icon-feature %}} **Download metrics module package from NGINX Management Suite**

  The metrics module can now be downloaded from the NGINX Management Suite directly. It provides additional metrics dimensions.

- {{% icon-feature %}} **Adds support for RHEL 9**

  Instance Manager 2.6 supports RHEL 9. See the [Technical Specifications Guide]({{< relref "/nms/tech-specs.md#distributions" >}}) for details.

- {{% icon-feature %}} **Support for using HashiCorp Vault for storing secrets**

  NGINX Management Suite now supports the use of HashiCorp Vault to store secrets such as SSL Certificates and Keys. Use of a new or existing Vault deployment is supported.

- {{% icon-feature %}} **Graph and additional data are included in NGINX Plus usage tracking UI**

  On the NGINX Plus usage tracking page, the number of NGINX Plus instances used over time is available in a graph. You can also view the minimum, maximum, and average count of concurrent unique instances in a given time period.

- {{% icon-feature %}} **Adds support for Oracle 8**

  Oracle 8 is now [a supported distribution]({{< relref "tech-specs.md#distributions" >}}) starting with Instance Manager 2.6. You can use the RedHat/CentOS distro to install the Oracle 8 package.

### Changes in Default Behavior

Instance Manager 2.6.0 has the following changes in default behavior:

- {{% icon-feature %}} **GET /roles and /roles/{roleName} API responses now include user and group associations**

  The GET Roles API response includes any users or groups associated with a role.

### Resolved Issues

This release fixes the following issues:

- {{% icon-resolved %}} Password error "option unknown" occurs when installing NGINX Instance Manager on Ubuntu with OpenSSL v1.1.0 (33055)

- {{% icon-resolved %}} Instance Manager reports the NGINX App Protect WAF build number as the version (37510)

### Known Issues

- To view the known issues in this release, see the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

### Support for NGINX App Protect WAF {#support-for-nap-waf}

{{< include "tech-specs/nim-app-protect-support.md" >}}

{{<important>}}Instance Manager 2.6.0 does not support upgrading NGINX App Protect WAF on managed instances to which Instance Manager publishes App Protect policies and configurations.{{</important>}}

---
## 2.5.1

October 11, 2022

### Upgrade Paths

Instance Manager 2.5.1 supports direct upgrades from the following versions:

- 2.3.0–2.5.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} Extended NGINX metrics aren't reported for NGINX Plus R26 and earlier (37738)

---

## 2.5.0

October 4, 2022

### Upgrade Paths

Instance Manager 2.5.0 supports direct upgrades from the following versions:

- 2.2.0–2.4.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Track NGINX Plus usage over time**

  When viewing your NGINX Plus instances in the Instance Manager web interface, you can set a date and time filter to review the [NGINX Plus instance count]({{< relref "/nms/nim/how-to/usage-tracking/count-nginx-plus-instances" >}}) for a specific period. Also, you can use the Instance Manager REST API to view the lowest, highest, and average number of NGINX Plus instances over time.

- {{% icon-feature %}} **New helm charts for each release of Instance Manager**

  Each release of Instance Manager now includes a Helm chart, which you can use to easily [install Instance Manager on Kubernetes]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}}). You can download the helm charts from [MyF5](https://my.f5.com/manage/s/downloads).

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} OIDC is not supported for helm chart deployments (33248)

- {{% icon-resolved %}} Installing NGINX Agent on Ubuntu 22.04 LTS fails with `404 Not Found` error (35339)

- {{% icon-resolved %}} Managed certificates may be overwritten if they have the same name on different datapath certificates (36240)

- {{% icon-resolved %}} Scan overview page doesn't scroll to show the full list of instances (36514)

---

## 2.4.0

August 16, 2022

### Upgrade Paths

Instance Manager 2.4.0 supports direct upgrades from the following versions:

- 2.1.0–2.3.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Get notified about critical events**

  Instance Manager 2.4 adds a notifications panel to the web interface. After logging in to NGINX Management Suite, select the notification bell at the top of the page to view critical system events (`WARNING` or `ERROR` level events). Future releases will support additional notification options.

- {{% icon-feature %}} **See which of your NGINX Plus instances have NGINX App Protect installed**

  Now, when you [view your NGINX Plus inventory]({{< relref "/nms/nim/how-to/usage-tracking/count-nginx-plus-instances.md" >}}), you can see which instances have [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) installed. NGINX App Protect is a modern app‑security solution that works seamlessly in DevOps environments as a robust WAF or app‑level DoS defense, helping you deliver secure apps from code to customer.

### Changes in Default Behavior

Instance Manager 2.4.0 has the following changes in default behavior:

- {{% icon-feature %}} **You no longer need to associate a certificate with an instance using the web interface**

  NGINX Management Suite will automatically deploy a certificate to an NGINX instance if the instance's config references the certificate on the NGINX Management Suite platform.

- {{% icon-feature %}} **Adds nms-integrations service**

  This release adds a new service called `nms-integerations`. This service is for future integrations; no user management or configuration is needed at this time.

### Resolved Issues

This release fixes the following issues. To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).


- {{% icon-resolved %}} Unable to publish config changes to a custom nginx.conf location (35276)

---

## 2.3.1

July 21, 2022

### Upgrade Paths

Instance Manager 2.3.1 supports direct upgrades from the following versions:

- 2.0.0–2.3.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### Security Update

{{< important >}}For the protection of our customers, NGINX doesn't disclose security issues until an investigation has occurred and a fix is available.{{< /important >}}

This release includes the following security update(s):

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2022-35241**

  In versions of 2.x before 2.3.1 and all versions of 1.x, when Instance Manager is in use, undisclosed requests can cause an increase in disk resource utilization.

  This issue has been classified as [CWE-400: Uncontrolled Resource Consumption](https://cwe.mitre.org/data/definitions/400.html).

  For more information, refer to the AskF5 article [K37080719](https://support.f5.com/csp/article/K37080719).

---

## 2.3.0

June 30, 2022

### Upgrade Paths

Instance Manager 2.3.0 supports direct upgrades from the following versions:

- 2.0.0–2.2.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### What's New

This release includes the following updates:

- {{% icon-feature %}} **View a summary of your instances' most important metrics for the last 24 hours**

  This release adds a **Metrics Summary** page, from which you can view key system, network, HTTP request, and connection metrics at a glance for the last 24 hours.
  
  After logging in to Instance Manager, select an instance on the **Instances Overview** page, then select the **Metrics Summary** tab.

- {{% icon-feature %}} **Track the details for your NGINX Plus instances**

  Easily track your NGINX Plus instances from the new NGINX Plus inventory list page. [View the current count for all your NGINX Plus instances]({{< relref "/nms/nim/how-to/usage-tracking/count-nginx-plus-instances.md" >}}), as well as each instance's hostname, UID, version, and the last time each instance was reported to Instance Manager. Select the `Export` button to export the list of NGINX Plus instances to a `.csv` file.

- {{% icon-feature %}} **Explore events in Instance Manager with the Events Catalogs API**

  This release introduces a Catalogs API endpoint specifically for viewing Instance Manager events and corresponding information. You can access the endpoint at `/analytics/catalogs/events`.

- {{% icon-feature %}} **Support for provisioning users and user groups with SCIM**

  Now, you can [use SCIM to provision, update, or deprovision users and user groups]({{< relref "/nms/admin-guides/access-control/scim-provisioning.md" >}}) for your Identity Provider to Instance Manager. SCIM, short for "[System for Cross-domain Identity Management](http://www.simplecloud.info)," is an open API for managing identities.

- {{% icon-feature %}} **Instance Manager provides information about your NGINX App Protect WAF installations**

  You can configure NGINX Agent to report the following NGINX App Protect WAF installation information to NGINX Management Suite:

  - the current version of NGINX App Protect WAF
  - the current status of NGINX App Protect WAF (active or inactive)
  - the Attack Signatures package version
  - the Threat Campaigns package version

- {{% icon-feature %}} **Adds support for Ubuntu 22.04**

  The NGINX Management Suite, which includes Instance Manager, now supports Ubuntu 22.04 (Jammy).

  Refer to the [Technical Specifications Guide]({{< relref "/nms/tech-specs.md" >}}) for details.

### Changes in Default Behavior

Instance Manager 2.3.0 has the following changes in default behavior:

- {{% icon-feature %}} **New login screen**

  Sometimes it's the small things that count. Now, when logging in to Instance Manager, you're treated to an attractive-looking login screen instead of a bland system prompt. 🤩

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} Post-install steps to load SELinux policy are in the wrong order (34276)

---

## 2.2.0

May 25, 2022

### Upgrade Paths

Instance Manager 2.2.0 supports direct upgrades from the following versions:

- 2.0.0–2.1.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### What's New

- {{% icon-feature %}} **Adds reporting for NGINX worker metrics (API only)**

  The NGINX Agent now gathers metrics for NGINX workers. You can access these metrics using the Instance Manager Metrics API.

  The following worker metrics are reported:

  - The count of NGINX workers
  - CPU, IO, and memory usage

- {{% icon-feature %}} **Modules field added to Metrics and Dimensions catalogs**

  A `modules` field was added to the [Metics]({{< relref "/nms/reference/catalogs/metrics.md" >}}) and [Dimensions]({{< relref "/nms/reference/catalogs/dimensions.md" >}}) catalogs. This field indicates which module or modules the metric or dimension belongs to.

- {{% icon-feature %}} **New events for NGINX processes and configuration rollbacks**

  Now, you can use the [Instance Manager Events API]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) or [web interface]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) to view events when NGINX instances start and reload or when a configuration is rolled back.

- {{% icon-feature %}} **Role-based access control added to Events and Metrics pages**

  A warning message is shown when users try to view the Events and Metrics pages in the web interface if they don't have permission to access the Analytics feature. For instructions on assigning access to features using role-based access control (RBAC), see [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md" >}}).

- {{% icon-feature %}} **Filter events and metrics with custom time ranges**

  Now you can filter [events]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) and [metrics]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) using a custom date and time range. Select **Custom time range** in the filter list, then specify the date and time range you want to use.

### Changes in Default Behavior

Instance Manager 2.2.0 has the following changes in default behavior:

- {{% icon-feature %}} **Viewing events requires a valid license**

  A valid license is needed to view events using the Instance Manager REST API or web interface. See [Add a License]({{< relref "/nms/installation/add-license.md" >}}) for instructions on how to get and add a license.

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} Filter events and metrics with custom date and time ranges (32796)

- {{% icon-resolved %}} Role-based access control added to Events and Metrics pages (33362)

- {{% icon-resolved %}} Running Agent install script with `sh` returns "not found" error (33385)

- {{% icon-resolved %}} The DeploymentDetails API now requires values for `failure` and `success` (33560)

---

## 2.1.0

April 5, 2022

### Upgrade Paths

Instance Manager 2.1.0 supports direct upgrades from the following versions:

- 2.0.0–2.0.1

{{< see-also >}}See the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps that you must review and follow when upgrading Instance Manager and the NGINX Agent.

If you're running Instance Manager 1.x or earlier, follow the steps in the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) to migrate your system to Instance Manager 2.x. Direct upgrades from Instance Manager 1.x and earlier are not supported.{{< /see-also >}}

### What's New

This release includes the following new features and enhancements:

- {{% icon-feature %}} **Adds Docker support for NGINX Agent**

  Now you can collect metrics about the Docker containers that the NGINX Agent is running in. The NGINX Agent uses the available cgroup files to calculate metrics like CPU and memory usage.

  If you have multiple Docker containers on your data plane host, each container registers with Instance Manager as unique.

  Refer to the [NGINX Agent Docker Support]({{< relref "/nms/nginx-agent/nginx-agent-in-container.md" >}}) guide for details.

  {{< note >}}Containerizing the NGINX Agent is supported only with Docker at the moment. Look for additional container support in future releases of Instance Manager.{{< /note >}}

- {{% icon-feature %}} **New RBAC lets you limit access to Instance Manager features**

  RBAC has been updated and improved. Add users to roles -- or add users to user groups if you're using an external identity provider -- to limit access to Instance Manager features.

  For more information, see the tutorial [Set Up RBAC]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md" >}}).

- {{% icon-feature %}} **Deploy Instance Manager on Kubernetes using a helm chart**

  We recommend using the Instance Manager helm chart to install Instance Manager on Kubernetes.

  Among the benefits of deploying from a helm chart, the chart includes the required services, which you can scale independently as needed; upgrades can be done with a single helm command; and there's no requirement for root privileges.

  For instructions, see [Install from a Helm Chart]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}}).

- {{% icon-feature %}} **Improved certificate handling**

  Stability and performance improvements for managing certificates using the web interface.

- {{% icon-feature %}} **View events for your NGINX instances**

  Now you can use the Instance Manager API or web interface to view events for your NGINX instances.

  See the [View Events]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) and [View Events (API)]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) topics for instructions.

- {{% icon-feature %}} **Redesigned metrics views in the web interface**

  The metrics pages in the web interface have been revised and improved.

  See the [View Metrics]({{< relref "/nms/nim/how-to/view-events-metrics" >}}) topic to get started.

### Changes in Default Behavior

Instance Manager 2.1.0 has the following changes in default behavior:

- {{% icon-feature %}} **Tags are no longer enforced for RBAC or set when creating or updating a role**

  If you're using tags for RBAC on an earlier version of Instance Manager, you'll need to re-create your roles after upgrading. Tags assigned to instances for the purpose of RBAC won't be honored after you upgrade.

  See the [What's New](#whats-new) section for details about the new Instance Manager RBAC authorization system.

- {{% icon-feature %}} **The DeploymentDetails API now requires values for `failure` and `success`**

  The DeploymentDetails API spec has changed. Now, the `failure` and `success` fields are required. The values can be an empty array or an array of UUIDs of NGINX instances; `null` is not a valid value.

  Endpoint: `/systems/instances/deployments/{deploymentUid}`

  Example JSON Response:

  ```json
  {
  "createTime": "2022-04-18T23:09:16Z",
  "details": {
  "failure": [ ],
  "success": [
  {
    "name": "27de7cb8-f7d6-3639-b2a5-b7f48883aee1"
  }
  ]
  },
  "id": "07c6101e-27c9-4dbb-b934-b5ed75e389e0",
  "status": "finalized",
  "updateTime": "2022-04-18T23:09:16Z"
  }
  ```

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} Unable to register multiple NGINX Agents in containers on the same host (30780)

- {{% icon-resolved %}} Include cycles in the configuration cause analyzer to spin. (31025)

- {{% icon-resolved %}} System reports "error granting scope: forbidden" if user granting permissions belongs to more than one role (31215)

- {{% icon-resolved %}} When using Instance Groups, tag-based access controls are not enforced (31267)

- {{% icon-resolved %}} Bad Gateway (502) errors with Red Hat 7 (31277)

- {{% icon-resolved %}} Improved certificate handling (32457)

---

## 2.0.1 Patch Release

January 27, 2022

### Resolved Issues

This release fixes the following issues:

{{<see-also>}}To view the history for an issue, see the [Known Issues list]({{< relref "/nms/nim/releases/known-issues.md" >}}).{{</see-also>}}

<br>

- {{% icon-resolved %}} Unable to access the Instance Manager web interface after loading SELinux policy (31583)
- {{% icon-resolved %}} The `nms-dpm` service restarts when registering multiple NGINX Agents with the same identity (31612)

---

## 2.0.0

December 21, 2021

### What's New

This release includes the following new features and enhancements:

- {{% icon-feature %}} **New architecture!**

  We redesigned and improved the architecture of Instance Manager! Because of these changes, upgrading to version 2.0 is different. Make sure to read the [Migration Guide]({{< relref "/nms/nim/migration-guide.md" >}}) for instructions.

- {{% icon-feature %}} **Improved user access control**

  Instance Manager 2.x. allows you to create user access controls with tags. Administrators can grant users read or write access to perform instance management tasks. And admins can grant or restrict access to the Settings options, such as managing licenses and creating users and roles. See the [Set up Authentication]({{< relref "/nms/admin-guides/access-control/configure-authentication.md#rbac" >}}) guide for more details.

- {{% icon-feature %}} **More metrics and instance dashboards**

  Instance Manager now collects additional metrics from the NGINX instances. We also added pre-configured dashboards to the web interface for each NGINX instance managed by Instance Manager. See the [Catalog Reference]({{< relref "/nms/reference/catalogs/_index.md" >}}) documentation for a complete list of metrics.

- {{% icon-feature %}} **(Experimental) Share a configuration across multiple instances**

  With a feature called **Instance Groups**, you can share the same configuration across multiple instances. So, if your website requires a number of instances to support the load, you can publish the same configuration to each instance with ease.
