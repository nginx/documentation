---
title: "Release Notes"
description: "These release notes list and describe the new features, enhancements, and resolved issues in the NGINX Management Suite Security Monitoring module."
weight: 100
toc: true
tags: [ "docs" ]
docs: "DOCS-1078"
categories: ["release notes"]
doctypes: ["reference"]
---

{{<rn-styles>}}

---

## 1.7.0

October 18, 2023

### Upgrade Paths {#1-7-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.4.0 - 1.6.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{'{{< relref "/nms/installation/upgrade-guide.md" >}}'}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### Changes in Default Behavior{#1-7-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Security Monitoring backend service**<a name="1-7-0-changes-in-behavior-Security-Monitoring-backend-service"></a>

  The backend for Security Monitoring is now served by the `nms-sm` process instead of `nms-core`. The `nms-sm` process must be started after installation of the `nms-sm` package.
  

### Known Issues{#1-7-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/security/releases/known-issues.md" >}}) topic.

---

## 1.6.0

July 20, 2023

### Upgrade Paths {#1-6-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.3.0 - 1.5.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{'{{< relref "/nms/installation/upgrade-guide.md" >}}'}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### Resolved Issues{#1-6-0-resolved-issues}
This release fixes the following issues. Select an issue's ID link to view its details.

- {{% icon-resolved %}} Using empty values as filters returns inaccurate results [(42941)]({{< relref "/nms/security/releases/known-issues.md#42941" >}})<a name="1-6-0-resolved-issues-Using-empty-values-as-filters-returns-inaccurate-results"></a>

### Known Issues{#1-6-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/security/releases/known-issues.md" >}}) topic.

---

## 1.5.0

June 12, 2023

### Upgrade Paths {#1-5-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.2.0 - 1.4.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{'{{< relref "/nms/installation/upgrade-guide.md" >}}'}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### What's New{#1-5-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Improved security monitoring with violation and signature details**<a name="1-5-0-whats-new-Improved-security-monitoring-with-violation-and-signature-details"></a>

  This release adds violation and signature details to Security Monitoring. This information helps you identify false positives and gain a more comprehensive understanding of violations, allowing you to fine-tune your security policies and optimize your threat detection.
  

### Known Issues{#1-5-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/security/releases/known-issues.md" >}}) topic.

---

## 1.4.0

April 26, 2023

### Upgrade Paths {#1-4-0-upgrade-paths}

Security Monitoring  supports upgrades from these previous versions:

- 1.1.0 - 1.3.0

If your Security Monitoring version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

{{< see-also >}}
Refer to the [Upgrade Guide]({{'{{< relref "/nms/installation/upgrade-guide.md" >}}'}}) for important information and steps to follow when upgrading Instance Manager and the NGINX Agent.
{{< /see-also >}}

### What's New{#1-4-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **View violation context for requests in Event logs**<a name="1-4-0-whats-new-View-violation-context-for-requests-in-Event-logs"></a>

  You can now view the request entity and its associated details that triggered a WAF violation from the event logs.
  

### Changes in Default Behavior{#1-4-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Update to the Signature context pie chart**<a name="1-4-0-changes-in-behavior-Update-to-the-Signature-context-pie-chart"></a>

  The Signature context pie chart now shows information related to signature-based violations in requests and URIs, in addition to the already available header, parameter, and cookie information.
  

### Known Issues{#1-4-0-known-issues}

You can find information about known issues in the [Known Issues]({{< relref "/nms/security/releases/known-issues.md" >}}) topic.

