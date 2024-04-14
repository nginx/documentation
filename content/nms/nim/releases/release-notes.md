---
description: These release notes list and describe the new features, enhancements,
  and resolved issues in NGINX Management Suite Instance Manager.
docs: DOCS-938
title: Release Notes
toc: true
weight: 100
---

{{<rn-styles>}}

---

## 2.16.0

April 18, 2024

### Upgrade Paths {#2-16-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.13.0 - 2.15.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-16-0-whats-new}

This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-16-0-whats-new-Stability-and-performance-improvements-"></a>

  This release includes stability and performance improvements.

- {{% icon-feature %}} **Introducing configuration templates for simplifying NGINX configurations and self-service workflows**<a name="2-16-0-whats-new-config-templates"></a>

  This release of NGINX Instance Manager introduces [Config Templates]({{< relref "nms/nim/about/templates/config-templates.md" >}}). These templates use Go templating to make it easier to set up and standardize NGINX configurations. Now, you don't need to know all the details of NGINX syntax to create a working configuration. Just provide the required inputs for a template, and the system will do the rest. This makes setting up NGINX simpler and helps you follow best practices. To provide more control over your configurations, augment templates let you modify only specific segments of your NGINX configuration. This, when combined with [RBAC for template submissions]({{< relref "nms/nim/how-to/nginx/access-control-for-templates-and-template-submissions.md" >}}), enables self-service workflows. Look for pre-built templates for common scenarios in our GitHub repositories soon.

### Changes in Default Behavior{#2-16-0-changes-in-behavior}

This release has the following changes in default behavior:

- {{% icon-feature %}} **Change in NGINX Agent upgrade behavior**

  Starting from version v2.31.0, the NGINX Agent will automatically restart itself during an upgrade.

### Known Issues{#2-16-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.15.1

February 14, 2024

### Upgrade Paths {#2-15-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.12.0 - 2.15.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-15-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-15-1-whats-new-Stability-and-performance-improvements-"></a>

  This release includes stability and performance improvements.


### Resolved Issues{#2-15-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Helm chart backup and restore is broken in NIM 2.15.0 [(44758)]({{< relref "/nms/nim/releases/known-issues.md#44758" >}})<a name="2-15-1-resolved-issues-Helm-chart-backup-and-restore-is-broken-in-NIM-2-15-0"></a>
- {{% icon-resolved %}} Unable to use NMS Predefined Log Profiles for NAP 4.7 [(44759)]({{< relref "/nms/nim/releases/known-issues.md#44759" >}})<a name="2-15-1-resolved-issues-Unable-to-use-NMS-Predefined-Log-Profiles-for-NAP-4-7"></a>

### Known Issues{#2-15-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.15.0

December 12, 2023

### Upgrade Paths {#2-15-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.12.0 - 2.14.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-15-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Support for CA Certificates added**<a name="2-15-0-whats-new-Support-for-CA-Certificates-added"></a>

  Instance Manager now allows for managing CA Certificates to fully support NGINX directives such as _proxy_ssl_trusted_ and _proxy_ssl_verify_. The main difference after this change is that you no longer need a corresponding key to upload a certificate to Instance Manager.


### Resolved Issues{#2-15-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Instances reporting incorrect memory utilization [(44351)]({{< relref "/nms/nim/releases/known-issues.md#44351" >}})<a name="2-15-0-resolved-issues-Instances-reporting-incorrect-memory-utilization"></a>
- {{% icon-resolved %}} Data on the dashboard is updating unexpectedly [(44504)]({{< relref "/nms/nim/releases/known-issues.md#44504" >}})<a name="2-15-0-resolved-issues-Data-on-the-dashboard-is-updating-unexpectedly"></a>
- {{% icon-resolved %}} Missing Data when ClickHouse services are not running [(44586)]({{< relref "/nms/nim/releases/known-issues.md#44586" >}})<a name="2-15-0-resolved-issues-Missing-Data-when-ClickHouse-services-are-not-running"></a>
- {{% icon-resolved %}} NGINX App Protect Attack Signature, Threat Campaign and Compiler fail to download [(44603)]({{< relref "/nms/nim/releases/known-issues.md#44603" >}})<a name="2-15-0-resolved-issues-NGINX-App-Protect-Attack-Signature,-Threat-Campaign-and-Compiler-fail-to-download"></a>

### Known Issues{#2-15-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.14.1

October 19, 2023

### Upgrade Paths {#2-14-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.11.0 - 2.14.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-14-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-14-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Known Issues{#2-14-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.14.0

October 16, 2023

### Upgrade Paths {#2-14-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.11.0 - 2.13.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-14-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Instance Manager Dashboard**<a name="2-14-0-whats-new-Instance-Manager-Dashboard"></a>

  Monitor the health and performance of your NGINX instance fleet from a single page. Get insights and trends on CPU, memory, disk, and network traffic utilization. Quickly spot and mitigate common HTTP errors and TLS certificate issues. See the [Instance Manager Dashboard]({{< relref "nms/nim/about/instance-manager-dashboard.md" >}}) documentation to learn more.

- {{% icon-feature %}} **Work with NGINX App Protect Bundles from Instance Manager**<a name="2-14-0-whats-new-Work-with-NGINX-App-Protect-Bundles-from-Instance-Manager"></a>

  Starting with Instance Manager 2.14, you can now use the "/security/policies/bundles" endpoint to create, read, update, and delete NGINX App Protect bundles, which allow faster deployment through pre-compilation of security policies, attack signatures, and threat-campaign.  For additional information on how to use the API endpoint, refer to your product API documentation.
  To learn more about this feature, see the [Manage WAF Security Policies]({{< relref "nms/nim/how-to/app-protect/manage-waf-security-policies.md" >}}) documentation.

- {{% icon-feature %}} **Clickhouse LTS 23.8 support**<a name="2-14-0-whats-new-Clickhouse-LTS-23-8-support"></a>

  This release of Instance Manager has been tested and is compatible with Clickhouse LTS versions 22.3.15.33 to 23.8.


### Changes in Default Behavior{#2-14-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Inactive NGINX instances are automatically removed over time**<a name="2-14-0-changes-in-behavior-Inactive-NGINX-instances-are-automatically-removed-over-time"></a>

  If an NGINX instance has been inactive (NGINX Agent not reporting to NGINX Management Suite) for a fixed amount of time, it is now automatically removed from the instances list. Instances deployed in a virtual machine or hardware are removed after 72 hours of inactivity, and those deployed in a container are removed after 12 hours.


### Known Issues{#2-14-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.13.1

September 05, 2023

### Upgrade Paths {#2-13-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.10.0 - 2.13.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Resolved Issues{#2-13-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Validation errors in Resource Groups for certificates uploaded before 2.13 upgrade [(44254)]({{< relref "/nms/nim/releases/known-issues.md#44254" >}})<a name="2-13-1-resolved-issues-Validation-errors-in-Resource-Groups-for-certificates-uploaded-before-2-13-upgrade"></a>
- {{% icon-resolved %}} Access levels cannot be assigned to certain RBAC features [(44277)]({{< relref "/nms/nim/releases/known-issues.md#44277" >}})<a name="2-13-1-resolved-issues-Access-levels-cannot-be-assigned-to-certain-RBAC-features"></a>

### Known Issues{#2-13-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.13.0

August 28, 2023

### Upgrade Paths {#2-13-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.10.0 - 2.12.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-13-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Easily manage access to specific objects with Resource Groups**<a name="2-13-0-whats-new-Easily-manage-access-to-specific-objects-with-Resource-Groups"></a>

  With NGINX Instance Manager, you can now combine Instances, Instance Groups, and Certificates into a Resource Group. This grouping can be used when defining roles to grant access to those specific objects. When objects are added to or removed from the Resource Group, the changes are automatically reflected in any roles that use the Resource Group. For more details, refer to [Working with Resource Groups]({{< relref "nms/admin-guides/rbac/manage-resource-groups.md" >}}).

- {{% icon-feature %}} **Get version controlled NGINX configurations with an external commit hash**<a name="2-13-0-whats-new-Get-version-controlled-NGINX-configurations-with-an-external-commit-hash"></a>

    The Instance Manager REST API supports setting and retrieving instances, instance groups, and staged NGINX configurations using a version control commit hash.

    To learn how to use a commit hash with NGINX configurations, refer to these topics:

  - [Add Hash Versioning to Staged Configs]({{< relref "nms/nim/how-to/nginx/stage-configs.md#hash-versioning-staged-configs" >}})
  - [Publish Configs with Hash Versioning to Instances]({{< relref "nms/nim/how-to/nginx/publish-configs.md#publish-configs-instances-hash-versioning" >}})
  - [Publish Configs with Hash Versioning to Instance Groups]({{< relref "nms/nim/how-to/nginx/publish-configs.md#publish-configs-instance-groups-hash-versioning" >}})

- {{% icon-feature %}} **Configure analytics data retention with the nms.conf file**<a name="2-13-0-whats-new-Configure-analytics-data-retention-with-the-nms-conf-file"></a>

  You can set the data retention policy for analytics data, which includes metrics, events, and security events, in the `nms.conf` file. By default, metrics and security events are stored for 32 days, while events are stored for 120 days. To keep data for a longer period, update the retention durations in the `nms.conf` file.

- {{% icon-feature %}} **RBAC for security policies**<a name="2-13-0-whats-new-RBAC-for-security-policies"></a>

  You can now use [Role-Based Access Control (RBAC)]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}) to allow or restrict the level of access to security policies according to your security governance model.

- {{% icon-feature %}} **RBAC for log profiles**<a name="2-13-0-whats-new-RBAC-for-log-profiles"></a>

  You can now use [Role-Based Access Control (RBAC)]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}) to allow or restrict access to log profiles according to your security governance model.

- {{% icon-feature %}} **Use NGINX Plus Health Checks to easily track NGINX Plus Usage with NGINX Instance Manager**<a name="2-13-0-whats-new-Use-NGINX-Plus-Health-Checks-to-easily-track-NGINX-Plus-Usage-with-NGINX-Instance-Manager"></a>

  The NGINX Plus Health Check feature now allows you to monitor the count of both NGINX Plus and NGINX App Protect instances that you've deployed. You can view this information in the "NGINX Plus" area of the "Instance Manager" web interface, or through the `/inventory` API. For guidance on how to set this up, refer to the following documentation: [View Count of NGINX Plus Instances]({{< relref "nms/nim/how-to/monitoring/count-nginx-plus-instances.md" >}}).
  
- {{% icon-feature %}} **Improved log output for better JSON parsing**<a name="2-13-0-whats-new-Improved-log-output-for-better-JSON-parsing"></a>

  In the log output, extra whitespace has been removed, and brackets have been removed from the log `level` field. This results in clean, parsable log output, particularly when using JSON log encoding.


### Resolved Issues{#2-13-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} An "unregistered clickhouse-adapter" failure is logged every few seconds if logging is set to debug. [(43438)]({{< relref "/nms/nim/releases/known-issues.md#43438" >}})<a name="2-13-0-resolved-issues-An-&#34;unregistered-clickhouse-adapter&#34;-failure-is-logged-every-few-seconds-if-logging-is-set-to-debug-"></a>

### Known Issues{#2-13-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.12.0

July 20, 2023

### Upgrade Paths {#2-12-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.9.0 - 2.11.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-12-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New support for license tokens for automatic entitlement updates, renewals, and Flexible Consumption Reporting**<a name="2-12-0-whats-new-New-support-for-license-tokens-for-automatic-entitlement-updates,-renewals,-and-Flexible-Consumption-Reporting"></a>

  NGINX Management Suite now supports license tokens formatted as a JSON Web Token (JWT). With JWT licensing, you can automatically update entitlements during subscription renewals or amendments, and you can automate reporting for the Flexible Consumption Program (FCP). For more information, see the [Add a License]({{< relref "/nms/installation/add-license.md" >}}) topic.


### Resolved Issues{#2-12-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Filtering Analytics data with values that have double backslashes (`\\`) causes failures [(42105)]({{< relref "/nms/nim/releases/known-issues.md#42105" >}})<a name="2-12-0-resolved-issues-Filtering-Analytics-data-with-values-that-have-double-backslashes-(`\\`)-causes-failures"></a>
- {{% icon-resolved %}} Unable to publish configurations referencing the log bundle for Security Monitor [(42932)]({{< relref "/nms/nim/releases/known-issues.md#42932" >}})<a name="2-12-0-resolved-issues-Unable-to-publish-configurations-referencing-the-log-bundle-for-Security-Monitor"></a>
- {{% icon-resolved %}} Disk Usage in Metrics Summary shows incorrect data when multiple partitions exist on a system [(42999)]({{< relref "/nms/nim/releases/known-issues.md#42999" >}})<a name="2-12-0-resolved-issues-Disk-Usage-in-Metrics-Summary-shows-incorrect-data-when-multiple-partitions-exist-on-a-system"></a>

### Known Issues{#2-12-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.11.0

June 12, 2023

### Upgrade Paths {#2-11-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.8.0 - 2.10.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-11-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **The config editor now lets you see auxiliary files**<a name="2-11-0-whats-new-The-config-editor-now-lets-you-see-auxiliary-files"></a>

  Auxiliary files, such as certificate files and other non-config files on managed instances or instance groups, are now visible in the file tree of the config editor view. This improvement makes it easier to reference these files within a configuration.

- {{% icon-feature %}} **Introducing new predefined log profiles for NGINX App Protect WAF**<a name="2-11-0-whats-new-Introducing-new-predefined-log-profiles-for-NGINX-App-Protect-WAF"></a>

  Now, managing your NGINX App Protect WAF configuration is even easier with new predefined log profiles. In addition to the existing log_all, log_blocked, log_illegal, and log_secops log profiles, the following new predefined log profiles are now available:

  - log_f5_arcsight
  - log_f5_splunk
  - log_grpc_all
  - log_grpc_blocked
  - log_grpc_illegal

  These new log profiles make it even easier to integrate NGINX App Protect WAF with other logging systems, such as Splunk, ArcSight, and gRPC.

- {{% icon-feature %}} **You can now install Advanced Metrics automatically when you install NGINX Agent**<a name="2-11-0-whats-new-You-can-now-install-Advanced-Metrics-automatically-when-you-install-NGINX-Agent"></a>

  When installing the NGINX Agent with NGINX Management Suite, you can include the `-a` or `--advanced-metrics` flag. Including this option installs the Advanced Metrics module along with the NGINX Agent. With this module, you gain access to extra metrics and insights that enrich the monitoring and analysis capabilities of the NGINX Management Suite, empowering you to make more informed decisions.

- {{% icon-feature %}} **NGINX Management Suite can send telemetry data to F5 NGINX**<a name="2-11-0-whats-new-NGINX-Management-Suite-can-send-telemetry-data-to-F5-NGINX"></a>

  In order to enhance product development and support the success of our users with NGINX Management Suite, we offer the option to send limited telemetry data to F5 NGINX. This data provides valuable insights into software usage and adoption. By default, telemetry is enabled, but you have the flexibility to disable it through the web interface or API. For detailed information about the transmitted data, please refer to our documentation.


### Changes in Default Behavior{#2-11-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **The location of agent-dynamic.conf has changed**<a name="2-11-0-changes-in-behavior-The-location-of-agent-dynamic-conf-has-changed"></a>

  In this release, the `agent-dynamic.conf` file has been moved from `/etc/nginx-agent/` to `/var/lib/nginx-agent/`. To assign an instance group and tags to an instance, you will now need to edit the file located in `/var/lib/nginx-agent/`.

- {{% icon-feature %}} **<span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i>Action required:</span>Update OIDC configurations for management plane after upgrading to Instance Manager 2.11.0**<a name="2-11-0-changes-in-behavior-&lt;span-style=&#34;color:-#c20025;&#34;&gt;&lt;i-class=&#34;fas-fa-exclamation-triangle&#34;&gt;&lt;/i&gt;Action-required:&lt;/span&gt;Update-OIDC-configurations-for-management-plane-after-upgrading-to-Instance-Manager-2-11-0"></a>

  In Instance Manager 2.11.0, we added support for telemetry to the OIDC configuration files. Existing OIDC configurations will continue to work, but certain telemetry events, such as login, may not be captured.

  To ensure the capture of login telemetry events, please take the following steps:

- {{% icon-feature %}} **Configuration file permissions have been lowered to strengthen security**<a name="2-11-0-changes-in-behavior-Configuration-file-permissions-have-been-lowered-to-strengthen-security"></a>

    To strengthen the security of configuration details, certain file permissions have been modified. Specifically, the following configuration files now have lowered permissions, granting Owner Read/Write access and Group Read access (also referred to as `0640` or `rw-r-----`):

  - /etc/nms/nginx.conf
  - /etc/nginx/conf.d/nms-http.conf
  - /etc/nms/nginx/oidc/openid_configuration.conf
  - /etc/nms/nginx/oidc/openid_connect.conf

    Additionally, the following file permissions have been lowered to Owner Read/Write and Group Read/Write access (also known as `0660` or `rw-rw-----`):

  - /logrotate.d/nms.conf
  - /var/log/nms/nms.log

    These changes aim to improve the overall security of the system by restricting access to sensitive configuration files while maintaining necessary privileges for authorized users.


### Resolved Issues{#2-11-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Count of NGINX Plus graph has a delay in being populated [(37705)]({{< relref "/nms/nim/releases/known-issues.md#37705" >}})<a name="2-11-0-resolved-issues-Count-of-NGINX-Plus-graph-has-a-delay-in-being-populated"></a>
- {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates [(42182)]({{< relref "/nms/nim/releases/known-issues.md#42182" >}})<a name="2-11-0-resolved-issues-Duplicate-Certificate-and-Key-published-for-managed-certificates"></a>
- {{% icon-resolved %}} The Metrics module is interrupted during installation on Red Hat 9 [(42219)]({{< relref "/nms/nim/releases/known-issues.md#42219" >}})<a name="2-11-0-resolved-issues-The-Metrics-module-is-interrupted-during-installation-on-Red-Hat-9"></a>
- {{% icon-resolved %}} Certificate file is not updated automatically under certain conditions [(42425)]({{< relref "/nms/nim/releases/known-issues.md#42425" >}})<a name="2-11-0-resolved-issues-Certificate-file-is-not-updated-automatically-under-certain-conditions"></a>
- {{% icon-resolved %}} Certificate updates allow for multiples certs to share the same serial number [(42429)]({{< relref "/nms/nim/releases/known-issues.md#42429" >}})<a name="2-11-0-resolved-issues-Certificate-updates-allow-for-multiples-certs-to-share-the-same-serial-number"></a>

### Known Issues{#2-11-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.10.1

May 22, 2023

### Upgrade Paths {#2-10-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.7.0 - 2.10.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Resolved Issues{#2-10-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Valid licenses incorrectly identified as invalid [(42598)]({{< relref "/nms/nim/releases/known-issues.md#42598" >}})<a name="2-10-1-resolved-issues-Valid-licenses-incorrectly-identified-as-invalid"></a>

### Known Issues{#2-10-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.10.0

April 26, 2023

### Upgrade Paths {#2-10-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.7.0 - 2.9.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-10-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New &#34;Category&#34; Filter in the Events web interface**<a name="2-10-0-whats-new-New-&#34;Category&#34;-Filter-in-the-Events-web-interface"></a>

  You can now filter entries in the Events web interface using a new "Category" filter. Categories for event entries include "Certs", "Instance Groups", and "Templates".

- {{% icon-feature %}} **New NGINX Agent install flag for NGINX App Protect WAF**<a name="2-10-0-whats-new-New-NGINX-Agent-install-flag-for-NGINX-App-Protect-WAF"></a>

  The NGINX Agent installation script now has a flag to enable the default configuration required for NGINX App Protect WAF. It is used to retrieve the deployment status and `precompiled_publication` mode, with an option for the NGINX App Protect WAF instance to use the mode for policies.

- {{% icon-feature %}} **NGINX Management Suite version now visible in the web interface and API**<a name="2-10-0-whats-new-NGINX-Management-Suite-version-now-visible-in-the-web-interface-and-API"></a>

  You can now look up the NGINX Management Suite and NGINX Instance Manager versions in the web interface and API. Other module versions are also visible, though older versions of API Connectivity Manager and Security Monitoring may appear as undefined.

- {{% icon-feature %}} **NGINX Management Suite can now use NGINX Ingress Controller to manage routing**<a name="2-10-0-whats-new-NGINX-Management-Suite-can-now-use-NGINX-Ingress-Controller-to-manage-routing"></a>

  The NGINX Management Suite Helm Chart can now generate an NGINX Ingress Controller VirtualServer definition, which can be used to expose NGINX Management Suite when running in your Kubernetes cluster.
  More about the VirtualServer custom resource can be found in the [VirtualServer and VirtualServerRoute](https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/) documentation.

- {{% icon-feature %}} **Configuration Publication Status now visible in App Security pages.**<a name="2-10-0-whats-new-Configuration-Publication-Status-now-visible-in-App-Security-pages-"></a>

  The most recent publication date and status for an instance's configuration is now visible on App Security Pages. This reflects configuration for NGINX, NGINX App Protect policies, Attack Signatures and Threat Campaigns.

- {{% icon-feature %}} **Instance Manager can now automatically retrieve WAF compilers associated with NGINX App Protect instances**<a name="2-10-0-whats-new-Instance-Manager-can-now-automatically-retrieve-WAF-compilers-associated-with-NGINX-App-Protect-instances"></a>

  Using a user-provided NGINX repository certificate & key after the first set-up of the WAF compiler, Instance Manager can automatically retrieve WAF compilers associated with NGINX App Protect instances. These can be used to publish App Protect WAF configurations in `precompiled_publication` mode.

- {{% icon-feature %}} **Add option to toggle ICMP scanning in the web interface**<a name="2-10-0-whats-new-Add-option-to-toggle-ICMP-scanning-in-the-web-interface"></a>

  You can now explicitly enable or disable ICMP scanning at the top of the "Scan" interface.

- {{% icon-feature %}} **New NGINX Agent install flag for Security Monitoring**<a name="2-10-0-whats-new-New-NGINX-Agent-install-flag-for-Security-Monitoring"></a>

  The NGINX Agent installation script now has a flag to enable the default configuration required for the Security Monitoring module.


### Changes in Default Behavior{#2-10-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Improvements to Role Based Access Control for SSL Certificate and Key management**<a name="2-10-0-changes-in-behavior-Improvements-to-Role-Based-Access-Control-for-SSL-Certificate-and-Key-management"></a>

  Role Based Access Control for SSL Certificate and Key management can now use three different objects for precise controls: certificates, systems, and instance groups. Using certificates as an object controls the viewing and assigning of specific certificate and key pairs. Using systems or instance groups allows a user to see all certificates but restricts access for publishing.

- {{% icon-feature %}} **By default, NGINX Management Suite is not exposed to the internet when installed with a Helm Chart**<a name="2-10-0-changes-in-behavior-By-default,-NGINX-Management-Suite-is-not-exposed-to-the-internet-when-installed-with-a-Helm-Chart"></a>

  When NGINX Management Suite is installed using a Helm Chart, it now defaults to a ClusterIP without an external IP address.


### Resolved Issues{#2-10-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" [(41157)]({{< relref "/nms/nim/releases/known-issues.md#41157" >}})<a name="2-10-0-resolved-issues-Installing-NGINX-Agent-on-FreeBSD-fails-with-&#34;error-2051:-not-implemented&#34;"></a>
- {{% icon-resolved %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed [(41327)]({{< relref "/nms/nim/releases/known-issues.md#41327" >}})<a name="2-10-0-resolved-issues-SELinux-errors-encountered-when-starting-NGINX-Management-Suite-on-RHEL9-with-the-SELinux-policy-installed"></a>

### Known Issues{#2-10-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.9.1

April 06, 2023

### Upgrade Paths {#2-9-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.6.0 - 2.9.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Resolved Issues{#2-9-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} NGINX configurations with special characters may not be editable from the web interface after upgrading Instance Manager [(41557)]({{< relref "/nms/nim/releases/known-issues.md#41557" >}})<a name="2-9-1-resolved-issues-NGINX-configurations-with-special-characters-may-not-be-editable-from-the-web-interface-after-upgrading-Instance-Manager"></a>

### Known Issues{#2-9-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.9.0

March 21, 2023

### Upgrade Paths {#2-9-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.6.0 - 2.8.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-9-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New webpages for viewing Attack Signature and Threat Campaigns**<a name="2-9-0-whats-new-New-webpages-for-viewing-Attack-Signature-and-Threat-Campaigns"></a>

  The Instance Manager web interface now allows you to view Attack Signatures and Threat Campaign packages published to instances and instance groups. You can also publish these packages using the precompiled publication mode.

- {{% icon-feature %}} **NGINX Agent supports Rocky Linux 8 and 9**<a name="2-9-0-whats-new-NGINX-Agent-supports-Rocky-Linux-8-and-9"></a>

  The NGINX Agent now supports Rocky Linux 8 (x86_64, aarch64) and 9 (x86_64, aarch64).  The NGINX Agent supports the same distributions as NGINX Plus. For a list of the supported distributions, refer to the [NGINX Plus Technical Specs](https://docs.nginx.com/nginx/technical-specs/#supported-distributions) guide.

- {{% icon-feature %}} **New Events for CUD actions**<a name="2-9-0-whats-new-New-Events-for-CUD-actions"></a>

  Events will be triggered for `CREATE`, `UPDATE`, and `DELETE` actions on Templates, Instances, Certificates, Instance Groups, and Licenses.

- {{% icon-feature %}} **The _Certificate and Keys_ webpage has a new look!**<a name="2-9-0-whats-new-The-_Certificate-and-Keys_-webpage-has-a-new-look!"></a>

  Our new and improved _Certificates and Keys_ webpage makes it easier than ever to efficiently manage your TLS certificates.

- {{% icon-feature %}} **Add commit hash details to NGINX configurations for version control**<a name="2-9-0-whats-new-Add-commit-hash-details-to-NGINX-configurations-for-version-control"></a>

    Use the Instance Manager REST API to add a commit hash to NGINX configurations if you use version control, such as Git.

    For more information, see the following topics:

  - [Add Hash Versioning to Staged Configs]({{< relref "nms/nim/how-to/nginx/stage-configs.md#hash-versioning-staged-configs" >}})
  - [Publish Configs with Hash Versioning to Instances]({{< relref "nms/nim/how-to/nginx/publish-configs.md#publish-configs-instances-hash-versioning" >}})
  - [Publish Configs with Hash Versioning to Instance Groups]({{< relref "nms/nim/how-to/nginx/publish-configs.md#publish-configs-instance-groups-hash-versioning" >}})


### Security Updates{#2-9-0-security-updates}

{{< important >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /important >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2023-1550**<a name="2-9-0-security-updates-Instance-Manager-vulnerability-CVE-2023-1550"></a>

  NGINX Agent inserts sensitive information into a log file ([CVE-2023-1550](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-1550)). An authenticated attacker with local access to read NGINX Agent log files may gain access to private keys. This issue is exposed only when the non-default trace-level logging is enabled.

  NGINX Agent is included with NGINX Instance Manager, and used in conjunction with API Connectivity Manager and the Security Monitoring module.

  This issue has been classified as [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html).

#### Mitigation

- Avoid configuring trace-level logging in the NGINX Agent configuration file. For more information, refer to the [Configuring the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md#configuring-the-nginx-agent ">}}) section of NGINX Management Suite documentation. If trace-level logging is required, ensure only trusted users have access to the log files.

#### Fixed in

- NGINX Agent 2.23.3
- Instance Manager 2.9.0

For more information, refer to the MyF5 article [K000133135](https://my.f5.com/manage/s/article/K000133135).


### Changes in Default Behavior{#2-9-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **SSL Certificates can be associated with Instance Groups**<a name="2-9-0-changes-in-behavior-SSL-Certificates-can-be-associated-with-Instance-Groups"></a>

  When assigning SSL certificates for the NGINX data plane, you have the option of associating them with a single instance or with an instance group. When associated with an instance group, the certificates will be shared across all instances in the group.

- {{% icon-feature %}} **<span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i>Action required:</span> OIDC configurations for the management plane must be updated after upgrading to Instance Manager 2.9.0**<a name="2-9-0-changes-in-behavior-&lt;span-style=&#34;color:-#c20025;&#34;&gt;&lt;i-class=&#34;fas-fa-exclamation-triangle&#34;&gt;&lt;/i&gt;Action-required:&lt;/span&gt;-OIDC-configurations-for-the-management-plane-must-be-updated-after-upgrading-to-Instance-Manager-2-9-0"></a>

  OIDC configuration files were modified to improve support for automation and integration in CI/CD pipelines. To continue using OIDC after upgrading to Instance Manager 2.9.0, you'll need to update these configuration files.

  To take advantage of the expanded functionality for OIDC authentication with NGINX Management Suite, we recommend following these two options:

#### Option 1

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

#### Option 2

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


### Resolved Issues{#2-9-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} After upgrading to NGINX Instance Manager 2.1.0, the web interface reports timeouts when NGINX Agent configs are published [(32349)]({{< relref "/nms/nim/releases/known-issues.md#32349" >}})<a name="2-9-0-resolved-issues-After-upgrading-to-NGINX-Instance-Manager-2-1-0,-the-web-interface-reports-timeouts-when-NGINX-Agent-configs-are-published"></a>
- {{% icon-resolved %}} Scan does not update an unmanaged instance to managed [(37544)]({{< relref "/nms/nim/releases/known-issues.md#37544" >}})<a name="2-9-0-resolved-issues-Scan-does-not-update-an-unmanaged-instance-to-managed"></a>
- {{% icon-resolved %}} "Public Key Not Available" error when upgrading Instance Manager on a Debian-based system [(39431)]({{< relref "/nms/nim/releases/known-issues.md#39431" >}})<a name="2-9-0-resolved-issues-&#34;Public-Key-Not-Available&#34;-error-when-upgrading-Instance-Manager-on-a-Debian-based-system"></a>
- {{% icon-resolved %}} The Type text on the Instances overview page may be partially covered by the Hostname text [(39760)]({{< relref "/nms/nim/releases/known-issues.md#39760" >}})<a name="2-9-0-resolved-issues-The-Type-text-on-the-Instances-overview-page-may-be-partially-covered-by-the-Hostname-text"></a>
- {{% icon-resolved %}} App Protect: "Assign Policy and Signature Versions" webpage may not initially display newly added policies [(40085)]({{< relref "/nms/nim/releases/known-issues.md#40085" >}})<a name="2-9-0-resolved-issues-App-Protect:-&#34;Assign-Policy-and-Signature-Versions&#34;-webpage-may-not-initially-display-newly-added-policies"></a>
- {{% icon-resolved %}} Upgrading NGINX Management Suite may remove the OIDC configuration for the platform [(41328)]({{< relref "/nms/nim/releases/known-issues.md#41328" >}})<a name="2-9-0-resolved-issues-Upgrading-NGINX-Management-Suite-may-remove-the-OIDC-configuration-for-the-platform"></a>

### Known Issues{#2-9-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.8.0

January 30, 2023

### Upgrade Paths {#2-8-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.5.0 - 2.7.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-8-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Enhanced details page for SSL Certificates**<a name="2-8-0-whats-new-Enhanced-details-page-for-SSL-Certificates"></a>

  The Instance Manager web interface now features an improved details page for SSL Certificates. This page provides important information about the certificate and any associated instances.

- {{% icon-feature %}} **Automatic retrieval of Attack Signatures and Threat Campaign updates to Instance Manager**<a name="2-8-0-whats-new-Automatic-retrieval-of-Attack-Signatures-and-Threat-Campaign-updates-to-Instance-Manager"></a>

  Instance Manager now allows you to [set up automatic downloads of the most recent Attack Signature and Threat Campaign packages]({{< relref "nms/nim/how-to/app-protect/setup-waf-config-management.md##automatically-download-latest-packages" >}}). By publishing these updates to your App Protect instances from Instance Manager, you can ensure your applications are shielded from all recognized attack types.

- {{% icon-feature %}} **Improved WAF Compiler error messages**<a name="2-8-0-whats-new-Improved-WAF-Compiler-error-messages"></a>

  The messaging around [security policy compilation errors]({{< relref "nms/nim/how-to/app-protect/manage-waf-security-policies.md#check-for-compilation-errors" >}}) has been improved by providing more detailed information and alerting users if the required compiler version is missing.


### Changes in Default Behavior{#2-8-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Switching between storing secrets on disk and using Vault migrates secrets**<a name="2-8-0-changes-in-behavior-Switching-between-storing-secrets-on-disk-and-using-Vault-migrates-secrets"></a>

  When transitioning between storing secrets on disk or using HashiCorp Vault, any existing secrets can be easily migrated to the new storage method. For instructions, refer to the guide [Configure Vault for Storing Secrets]({{< relref "/nms/admin-guides/configuration/configure-vault.md" >}}).

- {{% icon-feature %}} **Create roles using either an object name or UID**<a name="2-8-0-changes-in-behavior-Create-roles-using-either-an-object-name-or-UID"></a>

  You can now use either an object name or a unique identifier (UID) when assigning object-level permissions while creating or editing a role via the Instance Manager REST API.

- {{% icon-feature %}} **Upgrading from 2.7 or earlier, you must re-enable `precompiled_publication` to continue publishing security policies with Instance Manager**<a name="2-8-0-changes-in-behavior-Upgrading-from-2-7-or-earlier,-you-must-re-enable-`precompiled_publication`-to-continue-publishing-security-policies-with-Instance-Manager"></a>

    To continue publishing security policies with Instance Manager if you're upgrading from Instance Manager 2.7 and earlier, you must set the  `precompiled_publication` parameter to `true` in the `nginx-agent.conf` file.

    In Instance Manager 2.7 and earlier, the `pre-compiled_publication` setting was set to `true` by default. However, starting with Instance Manager 2.8, this setting is set to `false` by default. This means you'll need to change this setting to `true` again when upgrading from earlier versions.

    To publish App Protect policies from Instance Manager, add the following to your `nginx-agent.conf` file:

    ```yaml
      nginx_app_protect:
         precompiled_publication: true
    ```


### Resolved Issues{#2-8-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Web interface reports no license found when a license is present [(30647)]({{< relref "/nms/nim/releases/known-issues.md#30647" >}})<a name="2-8-0-resolved-issues-Web-interface-reports-no-license-found-when-a-license-is-present"></a>
- {{% icon-resolved %}} Associating instances with expired certificates causes internal error [(34182)]({{< relref "/nms/nim/releases/known-issues.md#34182" >}})<a name="2-8-0-resolved-issues-Associating-instances-with-expired-certificates-causes-internal-error"></a>
- {{% icon-resolved %}} Publishing to an Instance/instance-group will fail when the configuration references a JSON policy or a JSON log profile  [(38357)]({{< relref "/nms/nim/releases/known-issues.md#38357" >}})<a name="2-8-0-resolved-issues-Publishing-to-an-Instance/instance-group-will-fail-when-the-configuration-references-a-JSON-policy-or-a-JSON-log-profile-"></a>
- {{% icon-resolved %}} Missing dimension data for Advanced Metrics with modules [(38634)]({{< relref "/nms/nim/releases/known-issues.md#38634" >}})<a name="2-8-0-resolved-issues-Missing-dimension-data-for-Advanced-Metrics-with-modules"></a>
- {{% icon-resolved %}} Large payloads can result in disk I/O error for database operations [(38827)]({{< relref "/nms/nim/releases/known-issues.md#38827" >}})<a name="2-8-0-resolved-issues-Large-payloads-can-result-in-disk-I/O-error-for-database-operations"></a>
- {{% icon-resolved %}} The Policy API endpoint only allows NGINX App Protect policy upsert with content length upto 3.14MB. [(38839)]({{< relref "/nms/nim/releases/known-issues.md#38839" >}})<a name="2-8-0-resolved-issues-The-Policy-API-endpoint-only-allows-NGINX-App-Protect-policy-upsert-with-content-length-upto-3-14MB-"></a>
- {{% icon-resolved %}} Deploy NGINX App Protect policy is listed as "Not Deployed" on the Policy Version detail page [(38876)]({{< relref "/nms/nim/releases/known-issues.md#38876" >}})<a name="2-8-0-resolved-issues-Deploy-NGINX-App-Protect-policy-is-listed-as-&#34;Not-Deployed&#34;-on-the-Policy-Version-detail-page"></a>
- {{% icon-resolved %}} NGINX Management Suite services may lose connection to ClickHouse in a Kubernetes deployment [(39285)]({{< relref "/nms/nim/releases/known-issues.md#39285" >}})<a name="2-8-0-resolved-issues-NGINX-Management-Suite-services-may-lose-connection-to-ClickHouse-in-a-Kubernetes-deployment"></a>
- {{% icon-resolved %}} NGINX App Protect status may not be displayed after publishing a configuration with a security policy and certificate reference [(39382)]({{< relref "/nms/nim/releases/known-issues.md#39382" >}})<a name="2-8-0-resolved-issues-NGINX-App-Protect-status-may-not-be-displayed-after-publishing-a-configuration-with-a-security-policy-and-certificate-reference"></a>
- {{% icon-resolved %}} Security Policy Snippet selector adds incorrect path reference for policy directive [(39492)]({{< relref "/nms/nim/releases/known-issues.md#39492" >}})<a name="2-8-0-resolved-issues-Security-Policy-Snippet-selector-adds-incorrect-path-reference-for-policy-directive"></a>
- {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled [(39943)]({{< relref "/nms/nim/releases/known-issues.md#39943" >}})<a name="2-8-0-resolved-issues-The-API-Connectivity-Manager-module-won&#39;t-load-if-the-Security-Monitoring-module-is-enabled"></a>
- {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled [(44433)]({{< relref "/nms/nim/releases/known-issues.md#44433" >}})<a name="2-8-0-resolved-issues-The-API-Connectivity-Manager-module-won&#39;t-load-if-the-Security-Monitoring-module-is-enabled"></a>

### Known Issues{#2-8-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.7.0

December 20, 2022

### Upgrade Paths {#2-7-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.4.0 - 2.6.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Changes in Default Behavior{#2-7-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **NGINX App Protect upgrades are supported**<a name="2-7-0-changes-in-behavior-NGINX-App-Protect-upgrades-are-supported"></a>

  You can upgrade NGINX App Protect WAF on managed instances where Instance Manager publishes NGINX App Protect policies and configurations. For example, upgrade from App Protect release 3.12.2 to release 4.0.

- {{% icon-feature %}} **NGINX Management Suite Config file is now in YAML format**<a name="2-7-0-changes-in-behavior-NGINX-Management-Suite-Config-file-is-now-in-YAML-format"></a>

  With the release of NGINX Instance Manager 2.7, the NGINX Management Suite configuration file is now in YAML format. Through the upgrade process, your existing configuration will automatically be updated. Any settings you have customized will be maintained in the new format. If you have existing automation tooling for the deployment of the NGINX Management Suite that makes changes to the configuration file, you will need to update it to account for the change.

- {{% icon-feature %}} **Existing NGINX Agent configuration kept during upgrade to the latest version**<a name="2-7-0-changes-in-behavior-Existing-NGINX-Agent-configuration-kept-during-upgrade-to-the-latest-version"></a>

  When upgrading NGINX Agent, the existing NGINX Agent configuration is maintained during the upgrade. If the Agent configuration is not present in `/etc/nginx-agent/nginx-agent.conf`, a default configuration is provided after NGINX Agent installation.


### Resolved Issues{#2-7-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Instance Manager reports old NGINX version after upgrade [(31225)]({{< relref "/nms/nim/releases/known-issues.md#31225" >}})<a name="2-7-0-resolved-issues-Instance-Manager-reports-old-NGINX-version-after-upgrade"></a>
- {{% icon-resolved %}} Instance Manager returns a "Download failed" error when editing an NGINX config for instances compiled and installed from source [(35851)]({{< relref "/nms/nim/releases/known-issues.md#35851" >}})<a name="2-7-0-resolved-issues-Instance-Manager-returns-a-&#34;Download-failed&#34;-error-when-editing-an-NGINX-config-for-instances-compiled-and-installed-from-source"></a>
- {{% icon-resolved %}} Null data count is not correctly represented in the NGINX Plus usage graph. [(38206)]({{< relref "/nms/nim/releases/known-issues.md#38206" >}})<a name="2-7-0-resolved-issues-Null-data-count-is-not-correctly-represented-in-the-NGINX-Plus-usage-graph-"></a>
- {{% icon-resolved %}} When upgrading Instance Manager from v2.4 to later versions of Instance Manager, certificate associations are no longer visible. [(38641)]({{< relref "/nms/nim/releases/known-issues.md#38641" >}})<a name="2-7-0-resolved-issues-When-upgrading-Instance-Manager-from-v2-4-to-later-versions-of-Instance-Manager,-certificate-associations-are-no-longer-visible-"></a>
- {{% icon-resolved %}} NGINX App Protect policy deployment status not reflecting removal of associated instance. [(38700)]({{< relref "/nms/nim/releases/known-issues.md#38700" >}})<a name="2-7-0-resolved-issues-NGINX-App-Protect-policy-deployment-status-not-reflecting-removal-of-associated-instance-"></a>
- {{% icon-resolved %}} When upgrading a multi-node NMS deployment with helm charts the ingestion pod may report a "Mismatched migration version" error [(38880)]({{< relref "/nms/nim/releases/known-issues.md#38880" >}})<a name="2-7-0-resolved-issues-When-upgrading-a-multi-node-NMS-deployment-with-helm-charts-the-ingestion-pod-may-report-a-&#34;Mismatched-migration-version&#34;-error"></a>
- {{% icon-resolved %}} After a version upgrade of NGINX Instance Manager, NMS Data Plane Manager crashes if you publish NGINX configuration with App Protect enablement directive (app_protect_enable) set to ON [(38904)]({{< relref "/nms/nim/releases/known-issues.md#38904" >}})<a name="2-7-0-resolved-issues-After-a-version-upgrade-of-NGINX-Instance-Manager,-NMS-Data-Plane-Manager-crashes-if-you-publish-NGINX-configuration-with-App-Protect-enablement-directive-(app_protect_enable)-set-to-ON"></a>

### Known Issues{#2-7-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.6.0

November 17, 2022

### Upgrade Paths {#2-6-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.3.0 - 2.5.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-6-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Manage and deploy configurations to NGINX App Protect WAF Instances**<a name="2-6-0-whats-new-Manage-and-deploy-configurations-to-NGINX-App-Protect-WAF-Instances"></a>

  This release introduces the following features to [manage and deploy configurations to NGINX App Protect instances]({{< relref "/nms/nim/about/app-protect-waf-cm-overview.md" >}}):

  - Create, upsert, and delete NGINX App Protect WAF security policies
  - Manage NGINX App Protect WAF security configurations by using the NGINX Management Suite user interface or REST API
  - Update Signatures and Threat Campaign packages
  - Compile security configurations into a binary bundle that can be consumed by NGINX App Protect WAF instances

- {{% icon-feature %}} **Adds support for RHEL 9**<a name="2-6-0-whats-new-Adds-support-for-RHEL-9"></a>

  Instance Manager 2.6 supports RHEL 9. See the [Technical Specifications Guide]({{< relref "nms/tech-specs.md#distributions" >}}) for details.

- {{% icon-feature %}} **Support for using HashiCorp Vault for storing secrets**<a name="2-6-0-whats-new-Support-for-using-HashiCorp-Vault-for-storing-secrets"></a>

  NGINX Management Suite now supports the use of Hashicorp Vault to store secrets such as SSL Certificates and Keys. Use of a new or existing Vault deployment is supported.

- {{% icon-feature %}} **Graph and additional data are included in NGINX Plus usage tracking interface**<a name="2-6-0-whats-new-Graph-and-additional-data-are-included-in-NGINX-Plus-usage-tracking-interface"></a>

  On the NGINX Plus usage tracking page, the number of NGINX Plus instances used over time is available in a graph. You can also view the minimum, maximum, and average count of concurrent unique instances in a given time period.

- {{% icon-feature %}} **Adds support for Oracle 8**<a name="2-6-0-whats-new-Adds-support-for-Oracle-8"></a>

  Oracle 8 is now [a supported distribution]({{< relref "nms/tech-specs.md#distributions" >}}) starting with Instance Manager 2.6. You can use the RedHat/CentOS distro to install the Oracle 8 package.


### Changes in Default Behavior{#2-6-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **GET Roles API responses now include user and group associations**<a name="2-6-0-changes-in-behavior-GET-Roles-API-responses-now-include-user-and-group-associations"></a>

  `GET /roles` and `GET/roles/{roleName}` API responses include any user(s) or group(s) associated with a role now.


### Resolved Issues{#2-6-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Password error "option unknown" occurs when installing NGINX Instance Manager on Ubuntu with OpenSSL v1.1.0 [(33055)]({{< relref "/nms/nim/releases/known-issues.md#33055" >}})<a name="2-6-0-resolved-issues-Password-error-&#34;option-unknown&#34;-occurs-when-installing-NGINX-Instance-Manager-on-Ubuntu-with-OpenSSL-v1-1-0"></a>
- {{% icon-resolved %}} Instance Manager reports the NGINX App Protect WAF build number as the version [(37510)]({{< relref "/nms/nim/releases/known-issues.md#37510" >}})<a name="2-6-0-resolved-issues-Instance-Manager-reports-the-NGINX-App-Protect-WAF-build-number-as-the-version"></a>

### Known Issues{#2-6-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.5.1

October 11, 2022

### Upgrade Paths {#2-5-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.2.0 - 2.5.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Resolved Issues{#2-5-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Extended NGINX metrics aren't reported for NGINX Plus R26 and earlier [(37738)]({{< relref "/nms/nim/releases/known-issues.md#37738" >}})<a name="2-5-1-resolved-issues-Extended-NGINX-metrics-aren&#39;t-reported-for-NGINX-Plus-R26-and-earlier"></a>

### Known Issues{#2-5-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.5.0

October 04, 2022

### Upgrade Paths {#2-5-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.2.0 - 2.4.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-5-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Track NGINX Plus usage over time**<a name="2-5-0-whats-new-Track-NGINX-Plus-usage-over-time"></a>

  When viewing your NGINX Plus instances in the Instnace Manager web interface, you can set a date and time filter to review the [NGINX Plus instance count]({{< relref "nms/nim/how-to/monitoring/count-nginx-plus-instances.md" >}}) for a specific period. Also, you can use the Instance Manager REST API to view the lowest, highest, and average number of NGINX Plus instances over time.
  
- {{% icon-feature %}} **New helm charts for each release of Instance Manager**<a name="2-5-0-whats-new-New-helm-charts-for-each-release-of-Instance-Manager"></a>

  Each release of Instance Manager now includes a helm chart, which you can use to easily [install Instance Manager on Kubernetes]({{< relref "nms/installation/kubernetes/deploy-instance-manager.md" >}}). You can download the helm charts from [MyF5](https://my.f5.com/manage/s/downloads).


### Resolved Issues{#2-5-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} OIDC is not supported for helm chart deployments [(33248)]({{< relref "/nms/nim/releases/known-issues.md#33248" >}})<a name="2-5-0-resolved-issues-OIDC-is-not-supported-for-helm-chart-deployments"></a>
- {{% icon-resolved %}} Managed certificates may be overwritten if they have the same name on different datapath certificates [(36240)]({{< relref "/nms/nim/releases/known-issues.md#36240" >}})<a name="2-5-0-resolved-issues-Managed-certificates-may-be-overwritten-if-they-have-the-same-name-on-different-datapath-certificates"></a>
- {{% icon-resolved %}} Scan overview page doesn't scroll to show the full list of instances [(36514)]({{< relref "/nms/nim/releases/known-issues.md#36514" >}})<a name="2-5-0-resolved-issues-Scan-overview-page-doesn&#39;t-scroll-to-show-the-full-list-of-instances"></a>

### Known Issues{#2-5-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.4.0

August 16, 2022

### Upgrade Paths {#2-4-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.1.0 - 2.3.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-4-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Get notified about critical events**<a name="2-4-0-whats-new-Get-notified-about-critical-events"></a>

  Instance Manager 2.4 adds a notifications panel to the web interface. After logging in to NGINX Management Suite, select the notification bell at the top of the page to view critical system events (`WARNING` or `ERROR` level events). Future releases will support additional notification options.

- {{% icon-feature %}} **See which of your NGINX Plus instances have NGINX App Protect installed**<a name="2-4-0-whats-new-See-which-of-your-NGINX-Plus-instances-have-NGINX-App-Protect-installed"></a>

  Now, when you [view your NGINX Plus inventory]({{< relref "nms/nim/how-to/monitoring/count-nginx-plus-instances.md" >}}), you can see which instances have [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) installed. NGINX App Protect is a modern app‑security solution that works seamlessly in DevOps environments as a robust WAF or app‑level DoS defense, helping you deliver secure apps from code to customer.
  

### Changes in Default Behavior{#2-4-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **You no longer need to associate a certificate with an instance using the web interface**<a name="2-4-0-changes-in-behavior-You-no-longer-need-to-associate-a-certificate-with-an-instance-using-the-web-interface"></a>

  NGINX Management Suite will automatically deploy a certificate to an NGINX instance if the instance's config references the certificate on the NMS platform.

- {{% icon-feature %}} **Adds nms-integrations service**<a name="2-4-0-changes-in-behavior-Adds-nms-integrations-service"></a>

  This release adds a new service called `nms-integerations`. This service is for future integrations; no user management or configuration is needed at this time.


### Resolved Issues{#2-4-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Unable to publish config changes to a custom nginx.conf location [(35276)]({{< relref "/nms/nim/releases/known-issues.md#35276" >}})<a name="2-4-0-resolved-issues-Unable-to-publish-config-changes-to-a-custom-nginx-conf-location"></a>

### Known Issues{#2-4-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.3.1

July 21, 2022

### Upgrade Paths {#2-3-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.0.0 - 2.3.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Security Updates{#2-3-1-security-updates}

{{< important >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /important >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2022-35241**<a name="2-3-1-security-updates-Instance-Manager-vulnerability-CVE-2022-35241"></a>

  In versions of 2.x before 2.3.1 and all versions of 1.x, when Instance Manager is in use, undisclosed requests can cause an increase in disk resource utilization.

  This issue has been classified as [CWE-400: Uncontrolled Resource Consumption](https://cwe.mitre.org/data/definitions/400.html).

  For more information, refer to the AskF5 article [K37080719](https://support.f5.com/csp/article/K37080719).


### Known Issues{#2-3-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.3.0

June 30, 2022

### Upgrade Paths {#2-3-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.0.0 - 2.2.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-3-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Instance Manager provides information about your NGINX App Protect WAF installations**<a name="2-3-0-whats-new-Instance-Manager-provides-information-about-your-NGINX-App-Protect-WAF-installations"></a>

  You can configure NGINX Agent to report the following NGINX App Protect WAF installation information to NGINX Management Suite:

  - The current version of NGINX App Protect WAF
  - The current status of NGINX App Protect WAF (active or inactive)
  - The Attack Signatures package version
  - The Threat Campaigns package version

- {{% icon-feature %}} **View a summary of your instances&#39; most important metrics for the last 24 hours**<a name="2-3-0-whats-new-View-a-summary-of-your-instances&#39;-most-important-metrics-for-the-last-24-hours"></a>

  This release adds a **Metrics Summary** page, from which you can view key system, network, HTTP request, and connection metrics at a glance for the last 24 hours. After logging in to Instance Manager, select an instance on the **Instances Overview** page, then select the **Metrics Summary** tab.

- {{% icon-feature %}} **Track the details for your NGINX Plus instances**<a name="2-3-0-whats-new-Track-the-details-for-your-NGINX-Plus-instances"></a>

   Easily track your NGINX Plus instances from the new NGINX Plus inventory list page. [View the current count for all your NGINX Plus instances]({{< relref "nms/nim/how-to/monitoring/count-nginx-plus-instances.md" >}}), as well as each instance's hostname, UID, version, and the last time each instance was reported to Instance Manager. Select the `Export` button to export the list of NGINX Plus instances to a `.csv` file.
  
- {{% icon-feature %}} **Explore events in NGINX Instance Manager with the Events Catalogs API**<a name="2-3-0-whats-new-Explore-events-in-NGINX-Instance-Manager-with-the-Events-Catalogs-API"></a>

  This release introduces a Catalogs API endpoint specifically for viewing NGINX Instance Manager events and corresponding information. You can access the endpoint at `/analytics/catalogs/events`.

- {{% icon-feature %}} **Support for provisioning users and user groups with SCIM**<a name="2-3-0-whats-new-Support-for-provisioning-users-and-user-groups-with-SCIM"></a>

  Now, you can [use SCIM to provision, update, or deprovision users and user groups]({{< relref "nms/admin-guides/authentication/oidc/scim-provisioning.md" >}}) for your Identity Provider to NGINX Instance Manager. SCIM, short for "[System for Cross-domain Identity Management](http://www.simplecloud.info)," is an open API for managing identities.

- {{% icon-feature %}} **Adds support for Ubuntu 22.04**<a name="2-3-0-whats-new-Adds-support-for-Ubuntu-22-04"></a>

  The NGINX Management Suite, which includes NGINX Instance Manager, now supports Ubuntu 22.04 (Jammy).

  Refer to the [Technical Specifications Guide]({{< relref "nms/tech-specs.md" >}}) for details.


### Changes in Default Behavior{#2-3-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **New login screen**<a name="2-3-0-changes-in-behavior-New-login-screen"></a>

  Sometimes it's the small things that count. Now, when logging in to NGINX Instance Manager, you're treated to an attractive-looking login screen instead of a bland system prompt. 🤩


### Resolved Issues{#2-3-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Post-install steps to load SELinux policy are in the wrong order [(34276)]({{< relref "/nms/nim/releases/known-issues.md#34276" >}})<a name="2-3-0-resolved-issues-Post-install-steps-to-load-SELinux-policy-are-in-the-wrong-order"></a>

### Known Issues{#2-3-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.2.0

May 25, 2022

### Upgrade Paths {#2-2-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.0.0 - 2.1.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-2-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New events for NGINX processes and configuration rollbacks**<a name="2-2-0-whats-new-New-events-for-NGINX-processes-and-configuration-rollbacks"></a>

    Now, you can use the [NGINX Instance Manager Events API]({{< relref "nms/nim/how-to/monitoring/view-events-metrics.md" >}}) or [web interface]({{< relref "nms/nim/how-to/monitoring/view-events-metrics.md" >}}) to view events when NGINX instances start and reload or when a configuration is rolled back.
  
- {{% icon-feature %}} **Filter events and metrics with custom date and time ranges**<a name="2-2-0-whats-new-Filter-events-and-metrics-with-custom-date-and-time-ranges"></a>

  Now you can filter [events]({{< relref "/nms/nim/how-to/monitoring/view-events-metrics" >}}) and [metrics]({{< relref "/nms/nim/how-to/monitoring/view-events-metrics" >}}) using a custom date and time range. Select **Custom time range** in the filter list, then specify the date and time range you want to use.
  
- {{% icon-feature %}} **Role-based access control added to Events and Metrics pages**<a name="2-2-0-whats-new-Role-based-access-control-added-to-Events-and-Metrics-pages"></a>

  A warning message is shown when users try to view the Events and Metrics pages in the web interface if they don't have permission to access the Analytics feature. For instructions on assigning access to features using role-based access control (RBAC), see [Set Up RBAC]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}).

- {{% icon-feature %}} **Modules field added to Metrics and Dimensions catalogs**<a name="2-2-0-whats-new-Modules-field-added-to-Metrics-and-Dimensions-catalogs"></a>

  A `modules` field was added to the [Metics]({{< relref "nms/reference/catalogs/metrics.md" >}}) and [Dimensions]({{< relref "nms/reference/catalogs/dimensions.md" >}}) catalogs. This field indicates which module or modules the metric or dimension belongs to.

- {{% icon-feature %}} **Adds reporting for NGINX worker metrics (API only)**<a name="2-2-0-whats-new-Adds-reporting-for-NGINX-worker-metrics-(API-only)"></a>

  The NGINX Agent now gathers metrics for NGINX workers. You can access these metrics using the NGINX Instance Manager Metrics API.

  The following worker metrics are reported:

  - The count of NGINX workers
  - CPU, IO, and memory usage


### Resolved Issues{#2-2-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Running Agent install script with sh returns “not found” error  [(33385)]({{< relref "/nms/nim/releases/known-issues.md#33385" >}})<a name="2-2-0-resolved-issues-Running-Agent-install-script-with-sh-returns-“not-found”-error-"></a>

### Known Issues{#2-2-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.1.0

April 05, 2022

### Upgrade Paths {#2-1-0-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.0.0 - 2.0.1

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-1-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Adds Docker support for NGINX Agent**<a name="2-1-0-whats-new-Adds-Docker-support-for-NGINX-Agent"></a>

  Now you can collect metrics about the Docker containers that the NGINX Agent is running in. The NGINX Agent uses the available cgroup files to calculate metrics like CPU and memory usage.

  If you have multiple Docker containers on your data plane host, each container registers with Instance Manager as unique.

  Refer to the [NGINX Agent Docker Support](https://docs.nginx.com/nginx-agent/installation-upgrade/container-environments/docker-support/) guide for details.

  {{< note >}}Containerizing the NGINX Agent is supported only with Docker at the moment. Look for additional container support in future releases of Instance Manager.{{< /note >}}

- {{% icon-feature %}} **Redesigned metrics views in the web interface**<a name="2-1-0-whats-new-Redesigned-metrics-views-in-the-web-interface"></a>

  The metrics pages in the web interface have been revised and improved.
  
  See the [View Metrics]({{< relref "/nms/nim/how-to/monitoring/view-events-metrics" >}}) topic to get started.
  
- {{% icon-feature %}} **New RBAC lets you limit access to NGINX Instance Manager features**<a name="2-1-0-whats-new-New-RBAC-lets-you-limit-access-to-NGINX-Instance-Manager-features"></a>

  RBAC has been updated and improved. Add users to roles -- or add users to user groups if you're using an external identity provider -- to limit access to Instance Manager features.

  For more information, see the tutorial [Set Up RBAC]({{< relref "/nms/admin-guides/rbac/rbac-getting-started.md" >}}).

- {{% icon-feature %}} **Improved certificate handling**<a name="2-1-0-whats-new-Improved-certificate-handling"></a>

  Stability and performance improvements for managing certificates using the web interface.

- {{% icon-feature %}} **View events for your NGINX instances**<a name="2-1-0-whats-new-View-events-for-your-NGINX-instances"></a>

  Now you can use the Instance Manager API or web interface to view events for your NGINX instances.
  
  See the [View Events]({{< relref "/nms/nim/how-to/monitoring/view-events-metrics" >}}) and [View Events (API)]({{< relref "/nms/nim/how-to/monitoring/view-events-metrics" >}}) topics for instructions.
  
- {{% icon-feature %}} **Deploy NGINX Instance Manager on Kubernetes using a helm chart**<a name="2-1-0-whats-new-Deploy-NGINX-Instance-Manager-on-Kubernetes-using-a-helm-chart"></a>

  We recommend using the Instance Manager helm chart to install Instance Manager on Kubernetes.

  Among the benefits of deploying from a helm chart, the chart includes the required services, which you can scale independently as needed; upgrades can be done with a single helm command; and there's no requirement for root privileges.

  For instructions, see [Install from a Helm Chart]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}}).


### Changes in Default Behavior{#2-1-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Tags are no longer enforced for RBAC or set when creating or updating a role**<a name="2-1-0-changes-in-behavior-Tags-are-no-longer-enforced-for-RBAC-or-set-when-creating-or-updating-a-role"></a>

  If you're using tags for RBAC on an earlier version of Instance Manager, you'll need to re-create your roles after upgrading. Tags assigned to instances for the purpose of RBAC won't be honored after you upgrade.

- {{% icon-feature %}} **The DeploymentDetails API now requires values for `failure` and `success`**<a name="2-1-0-changes-in-behavior-The-DeploymentDetails-API-now-requires-values-for-`failure`-and-`success`"></a>

  The DeploymentDetails API spec has changed. Now, the `failure` and `success` fields are required. The values can be an empty array or an array of UUIDs of NGINX instances.

  Endpoint: `/systems/instances/deployments/{deploymentUid}`

  Example JSON Response

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


### Resolved Issues{#2-1-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Unable to register multiple NGINX Agents in containers on the same host [(30780)]({{< relref "/nms/nim/releases/known-issues.md#30780" >}})<a name="2-1-0-resolved-issues-Unable-to-register-multiple-NGINX-Agents-in-containers-on-the-same-host"></a>
- {{% icon-resolved %}} Include cycles in the configuration cause analyzer to spin. [(31025)]({{< relref "/nms/nim/releases/known-issues.md#31025" >}})<a name="2-1-0-resolved-issues-Include-cycles-in-the-configuration-cause-analyzer-to-spin-"></a>
- {{% icon-resolved %}} System reports "error granting scope: forbidden" if user granting permissions belongs to more than one role [(31215)]({{< relref "/nms/nim/releases/known-issues.md#31215" >}})<a name="2-1-0-resolved-issues-System-reports-&#34;error-granting-scope:-forbidden&#34;-if-user-granting-permissions-belongs-to-more-than-one-role"></a>
- {{% icon-resolved %}} When using Instance Groups, tag-based access controls are not enforced [(31267)]({{< relref "/nms/nim/releases/known-issues.md#31267" >}})<a name="2-1-0-resolved-issues-When-using-Instance-Groups,-tag-based-access-controls-are-not-enforced"></a>
- {{% icon-resolved %}} Bad Gateway (502) errors with Red Hat 7 [(31277)]({{< relref "/nms/nim/releases/known-issues.md#31277" >}})<a name="2-1-0-resolved-issues-Bad-Gateway-(502)-errors-with-Red-Hat-7"></a>

### Known Issues{#2-1-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.0.1

January 27, 2022

### Upgrade Paths {#2-0-1-upgrade-paths}

Instance Manager  supports upgrades from these previous versions:

- 2.0.0

If your Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{< relref "/nms/installation/upgrade-guide.md" >}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### Resolved Issues{#2-0-1-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Unable to access the NGINX Instance Manager web interface after loading SELinux policy [(31583)]({{< relref "/nms/nim/releases/known-issues.md#31583" >}})<a name="2-0-1-resolved-issues-Unable-to-access-the-NGINX-Instance-Manager-web-interface-after-loading-SELinux-policy"></a>
- {{% icon-resolved %}} The `nms-dpm` service restarts when registering multiple NGINX Agents with the same identity [(31612)]({{< relref "/nms/nim/releases/known-issues.md#31612" >}})<a name="2-0-1-resolved-issues-The-`nms-dpm`-service-restarts-when-registering-multiple-NGINX-Agents-with-the-same-identity"></a>

### Known Issues{#2-0-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

---

## 2.0.0

December 21, 2021


<details closed>
<summary><i class="fa-solid fa-circle-exclamation"></i> Support for NGINX App Protect WAF</summary>

{{< include "tech-specs/nim-app-protect-support.md" >}}

</details>


### What's New{#2-0-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **(Experimental) Share a configuration across multiple instances**<a name="2-0-0-whats-new-(Experimental)-Share-a-configuration-across-multiple-instances"></a>

  With a feature called **Instance Groups**, you can share the same configuration across multiple instances. So, if your website requires a number of instances to support the load, you can publish the same configuration to each instance with ease.

- {{% icon-feature %}} **More metrics and instance dashboards**<a name="2-0-0-whats-new-More-metrics-and-instance-dashboards"></a>

  Instance Manager now collects additional metrics from the NGINX instances. We also added pre-configured dashboards to the web interface for each NGINX instance managed by Instance Manager. See the [Catalog Reference]({{< relref "/nms/reference/catalogs/_index.md" >}}) documentation for a complete list of metrics.

- {{% icon-feature %}} **New architecture!**<a name="2-0-0-whats-new-New-architecture!"></a>

  We redesigned and improved the architecture of Instance Manager! Because of these changes, upgrading to version 2.0 is different. Make sure to read the [Migration Guide]({{< relref "/nms/nim/previous-versions/migration-guide.md" >}}) for instructions.
  
- {{% icon-feature %}} **Improved user access control**<a name="2-0-0-whats-new-Improved-user-access-control"></a>

  Instance Manager 2.x. allows you to create user access controls with tags. Administrators can grant users read or write access to perform instance management tasks. And admins can grant or restrict access to the Settings options, such as managing licenses and creating users and roles. See the [Set up Authentication]({{< relref "/nms/admin-guides/authentication/basic-authentication.md#rbac" >}}) guide for more details.


### Known Issues{#2-0-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/nim/releases/known-issues.md" >}}) topic.

