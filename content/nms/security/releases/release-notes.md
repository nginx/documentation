---
title: "Release Notes"
date: 2022-03-30T12:38:24-08:00
draft: false
description: "These release notes list and describe the new features, enhancements, and resolved issues in the NGINX Management Suite Security Monitoring module."
# Assign weights in increments of 100
weight: 1
toc: true
tags: [ "docs" ]
docs: "DOCS-1078"
categories: ["release notes"]
doctypes: ["reference"]
---

{{<rn-styles>}}

<br>

<details closed>
<summary><i class="fa-solid fa-circle-info"></i> Dependencies with Instance Manger, NGINX App Protect WAF, and NGINX Plus</summary>

{{< include "tech-specs/security-management-plane-dependencies.md" >}}

<br>

{{< include "tech-specs/security-data-plane-dependencies.md" >}}

</details>

---

## 1.3.0 {#1-3-0}

March 21, 2023

### What's New {#1-3-0-whats-new}

- {{% icon-feature %}} **Top Signatures section added to the Main tab**

  The "Top Signatures" section is now available in the "Main" tab of the Security Monitoring module.

### Security Update {#1-3-0-security-update}

{{< important >}}For the protection of our customers, NGINX doesn't disclose security issues until an investigation has occurred and a fix is available.{{< /important >}}

This release includes the following security update:

{{< include "release-notes/41215.md" >}}

### Changes in Default Behavior {#1-3-0-change-in-behavior}

- {{% icon-feature %}} **Improved error message when NGINX Management Suite server is not running**

  The Security Monitoring module now displays the message "Upstream unavailable" when the NGINX Management Suite server is not running, instead of the previous message "Oops something went wrong."

- {{% icon-feature %}} **Single quotes are automatically escaped in filtered values**

  Single quotes in filtered values are automatically escaped to ensure that the data is parsed correctly.

### Known Issues {#1-3-0-known-issues}

- To view the known issues in this release, see the [Known Issues]({{< relref "/security/releases/known-issues.md" >}}) topic.

---

## 1.2.0

January 30, 2023

### What's New

- {{% icon-feature %}} **Get the latest Signature and Geolocation Databases**

  [Update the Signature database]({{< relref "/security/how-to/update-signatures" >}}) to get the latest attack signature details.

  [Update the Geolocation Database]({{< relref "/security/how-to/update-geo-db" >}}) to get the most accurate mapping of IP address to Geolocation.

### Resolved Issues

This release fixes the following issue. To view the history for an issue, see the [Known Issues list]({{< relref "/security/releases/known-issues.md" >}}).


- {{% icon-resolved %}} The field retrieving URIs is incorrectly listed as URL (38377)

### Known Issues

- To view the known issues in this release, see the [Known Issues]({{< relref "/security/releases/known-issues.md" >}}) topic.

---

## 1.1.0

December 20, 2022

### What's New

- This release includes stability and performance improvements.

### Changes in Default Behavior

Security Monitoring 1.1.0 has the following changes in default behavior:


- {{% icon-feature %}} **Removal of Total Requests count**

  The Total Requests count was removed from the Security Monitoring dashboards, to avoid customer confusion, as the value didn't convey different configuration scenarios for NGINX App Protect on NGINX instances.

- {{% icon-feature %}} **Removal of WAF PASSED requests count**

  The count of WAF `PASSED` requests was removed from the Security Monitoring dashboards to avoid customer confusion, as it counted only requests with violations and not all requests filtered by NGINX App Protect WAF.

### Known Issues

- To view the known issues in this release, see the [Known Issues]({{< relref "/security/releases/known-issues.md" >}}) topic.

---

## 1.0.0

November 17, 2022

### What's New

This release includes the following updates:

- {{% icon-feature %}} **Introducing the NGINX Management Suite Security Monitoring module**

  Use the NGINX Management Suite Security Monitoring module to monitor the NGINX App Protect WAF protection of your apps and APIs. View protection insights for analyzing possible threats and tuning policies.

  The Security Monitoring module includes the following:

  - Informative dashboards that provide valuable protection insights
  - In-depth security log details to help with analyzing possible threats and making policy decisions

  Refer to the [Installation Guide]({{< relref "/admin-guides/installation/on-prem/install-guide.md" >}}) to get started.

### Known Issues

- To view the known issues in this release, see the [Known Issues]({{< relref "/security/releases/known-issues.md" >}}) topic.
