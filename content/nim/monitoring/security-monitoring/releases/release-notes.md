---
title: Release notes
description: These release notes list and describe the new features, enhancements,
  and resolved issues in the F5 NGINX Security Monitoring module.
toc: true
weight: 100
doctype: reference
product: NIM
docs: DOCS-1078
---

---

## 1.7.1

October 23, 2023

### Upgrade Paths {#1-7-1-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.4.0 - 1.7.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### What's New{#1-7-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="1-7-1-whats-new-Stability-and-performance-improvements"></a>

  This release includes stability and performance improvements.


### Known Issues{#1-7-1-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.7.0

October 18, 2023

### Upgrade Paths {#1-7-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.4.0 - 1.6.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### Changes in Default Behavior{#1-7-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Security Monitoring backend service**<a name="1-7-0-changes-in-behavior-Security-Monitoring-backend-service"></a>

  The backend for Security Monitoring is now served by the `nms-sm` process instead of `nms-core`. The `nms-sm` process must be started after installation of the `nms-sm` package.


### Known Issues{#1-7-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.6.0

July 20, 2023

### Upgrade Paths {#1-6-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.3.0 - 1.5.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### Resolved Issues{#1-6-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Using empty values as filters returns inaccurate results [(42941)]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md#42941" >}})<a name="1-6-0-resolved-issues-Using-empty-values-as-filters-returns-inaccurate-results"></a>

### Known Issues{#1-6-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.5.0

June 12, 2023

### Upgrade Paths {#1-5-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.2.0 - 1.4.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### What's New{#1-5-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Improved security monitoring with violation and signature details**<a name="1-5-0-whats-new-Improved-security-monitoring-with-violation-and-signature-details"></a>

  This release adds violation and signature details to Security Monitoring. This information helps you identify false positives and gain a more comprehensive understanding of violations, allowing you to fine-tune your security policies and optimize your threat detection.


### Known Issues{#1-5-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.4.0

April 26, 2023

### Upgrade Paths {#1-4-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.1.0 - 1.3.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### What's New{#1-4-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **View violation context for requests in Event logs**<a name="1-4-0-whats-new-View-violation-context-for-requests-in-Event-logs"></a>

  You can now view the request entity and its associated details that triggered a WAF violation from the event logs.


### Changes in Default Behavior{#1-4-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Update to the Signature context pie chart**<a name="1-4-0-changes-in-behavior-Update-to-the-Signature-context-pie-chart"></a>

  The Signature context pie chart now shows information related to signature-based violations in requests and URIs, in addition to the already available header, parameter, and cookie information.


### Known Issues{#1-4-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.3.0

March 21, 2023

### Upgrade Paths {#1-3-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.0.0 - 1.2.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### What's New{#1-3-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Top Signatures section added to the Main tab**<a name="1-3-0-whats-new-Top-Signatures-section-added-to-the-Main-tab"></a>

  The "Top Signatures" section is now available in the "Main" tab of the Security Monitoring module dashboard.


### Security Updates{#1-3-0-security-updates}

{{< important >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /important >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2023-1550**<a name="1-3-0-security-updates-Instance-Manager-vulnerability-CVE-2023-1550"></a>

  NGINX Agent inserts sensitive information into a log file ([CVE-2023-1550](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-1550)). An authenticated attacker with local access to read NGINX Agent log files may gain access to private keys. This issue is exposed only when the non-default trace-level logging is enabled.

  NGINX Agent is included with NGINX Instance Manager, and used in conjunction with API Connectivity Manager and the Security Monitoring module.

  This issue has been classified as [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html).

#### Mitigation

- Avoid configuring trace-level logging in the NGINX Agent configuration file. For more information, refer to the [Configuring the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md#configuring-the-nginx-agent ">}}) section of NGINX Instance Manager documentation. If trace-level logging is required, ensure only trusted users have access to the log files.

#### Fixed in

- NGINX Agent 2.23.3
- Instance Manager 2.9.0

For more information, refer to the MyF5 article [K000133135](https://my.f5.com/manage/s/article/K000133135).


### Changes in Default Behavior{#1-3-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Improved error message when NGNIX Management Suite server is not running**<a name="1-3-0-changes-in-behavior-Improved-error-message-when-NGNIX-Management-Suite-server-is-not-running"></a>

  The Security Monitoring module now displays the message "Upstream unavailable" when the NGINX Instance Manager server is not running, instead of the previous message "Oops something went wrong."

- {{% icon-feature %}} **Single quotes are automatically escaped in filtered values**<a name="1-3-0-changes-in-behavior-Single-quotes-are-automatically-escaped-in-filtered-values"></a>

  Single quotes in filtered values are automatically escaped to ensure that the data is parsed correctly.


### Known Issues{#1-3-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.2.0

January 30, 2023

### Upgrade Paths {#1-2-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.0.0 - 1.1.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### What's New{#1-2-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Get the latest Signature and Geolocation Databases**<a name="1-2-0-whats-new-Get-the-latest-Signature-and-Geolocation-Databases"></a>

  [Update the Signature database]({{< relref "/nim/monitoring/security-monitoring/configure/update-signatures" >}}) to get the latest attack signature details.

  [Update the Geolocation Database]({{< relref "/nim/monitoring/security-monitoring/configure/update-geo-db" >}}) to get the most accurate mapping of IP address to Geolocation.


### Resolved Issues{#1-2-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} The field retrieving URIs is incorrectly listed as URL [(38377)]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md#38377" >}})<a name="1-2-0-resolved-issues-The-field-retrieving-URIs-is-incorrectly-listed-as-URL"></a>

### Known Issues{#1-2-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.1.0

December 20, 2022

### Upgrade Paths {#1-1-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.0.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.



### Changes in Default Behavior{#1-1-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Removal of Total Requests count**<a name="1-1-0-changes-in-behavior-Removal-of-Total-Requests-count"></a>

  The Total Requests count was removed from the Security Monitoring dashboards, to avoid customer confusion, as the value didn't convey different configuration scenarios for NGINX App Protect on NGINX instances.

- {{% icon-feature %}} **Removal of WAF PASSED requests count**<a name="1-1-0-changes-in-behavior-Removal-of-WAF-PASSED-requests-count"></a>

  The count of WAF `PASSED` requests was removed from the Security Monitoring dashboards to avoid customer confusion, as it counted only requests with violations and not all requests filtered by NGINX App Protect WAF.


### Known Issues{#1-1-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

---

## 1.0.0

November 17, 2022


### What's New{#1-0-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Introducing the NGINX Security Monitoring module**<a name="1-0-0-whats-new-Introducing-the-NGINX-Management-Suite-Security-Monitoring-module"></a>

  Use the NGINX Security Monitoring module to monitor the NGINX App Protect WAF protection of your apps and APIs. View protection insights for analyzing possible threats and tuning policies.

  The Security Monitoring module includes the following:

  - Informative dashboards that provide valuable protection insights
  - In-depth security log details to help with analyzing possible threats and making policy decisions

  Refer to the [Installation Guide]({{< relref "/nim/deploy/_index.md" >}}) to get started.


### Known Issues{#1-0-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nim/monitoring/security-monitoring/releases/known-issues.md" >}}) topic.

