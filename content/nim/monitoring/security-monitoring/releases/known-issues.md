---
title: Known issues
description: This document lists and describes the known issues and possible workarounds
  in the F5 NGINX Security Monitoring module. Fixed issues are removed
  after **45 days**.
toc: true
weight: 200
doctype: reference
product: NIM
docs: DOCS-1077
---

{{< tip >}}We recommend you upgrade to the latest version of the Security Monitoring module to take advantage of new features, improvements, and bug fixes.{{< /tip >}}

---

## 1.7.0
October 18, 2023

### {{% icon-bug %}} Web interface fails to load after restarting NGINX Instance Manager {#44587}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44587 | Open   |

{{</bootstrap-table>}}
#### Description
The NGINX Instance Manager web interface can fail to load with a "Page not found"  error after restarting its service. The security monitoring module will fail to appear on the launchpad until the page is manually reloaded.

#### Workaround

Reload the page in the browser to resolve this issue.

---

## 1.5.0
June 12, 2023

### {{% icon-resolved %}} Using empty values as filters returns inaccurate results {#42941}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42941 | Fixed in Security Monitoring -1.6.0   |

{{</bootstrap-table>}}
#### Description
Using an empty string as a key or value results in an empty dataset.

---

## 1.0.0
November 17, 2022

### {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled {#44433}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44433 | Fixed in Instance Manager 2.8.0   |

{{</bootstrap-table>}}
#### Description
If you have Instance Manager 2.7 or earlier installed and attempt to enable both the API Connectivity Manager and Security Monitoring modules on the same NGINX Instance Manager management plane, the API Connectivity Manager module will not load because of incompatibility issues with the Security Monitoring module.

#### Workaround

Before enabling the API Connectivity Manager and Security Monitoring modules, ensure that your Instance Manager is upgraded to version 2.8 or later. Be sure to read the release notes for each module carefully, as they may contain important information about version dependencies.

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

### {{% icon-bug %}} Filtering data by Instance Group in the Security Monitoring module does not show any results. {#38790}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38790 | Open   |

{{</bootstrap-table>}}
#### Description
The Security Monitoring plugin on NGINX Agent does not automatically pick up changes made to agent-dynamic.conf, causing the Instance Group association to be missing in the Security Violations generated.

#### Workaround

Restart the NGINX Agent, and the subsequent Violations should be associated with the Instance Group:

`systemctl restart nginx-agent`

---

### {{% icon-resolved %}} The field retrieving URIs is incorrectly listed as URL {#38377}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38377 | Fixed in Security Monitoring -1.2.0   |

{{</bootstrap-table>}}
#### Description
The field with URI data was mapped to the heading URL. The name of the field has been corrected.
