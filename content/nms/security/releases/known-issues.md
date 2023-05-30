---
title: "Known Issues"
date: 2022-03-30T12:38:24-08:00
draft: false
description: "This document lists and describes the known issues and possible workarounds in the NGINX Management Suite Security Monitoring module. Fixed issues are removed after **45 days**."
# Assign weights in increments of 100
weight: 100000
toc: true
tags: [ "docs" ]
docs: "DOCS-1077"
categories: ["known issues"]
---

{{<rn-styles>}}

{{< tip >}}We recommend you upgrade to the latest version of the Security Monitoring module to take advantage of new features, improvements, and bug fixes.{{< /tip >}}

---

## 1.0.0

### {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled {#39943}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status                          |
|----------|---------------------------------|
| 39943    | Fixed in Instance Manager 2.8.0 |
{{</bootstrap-table>}}

#### Description

If you have Instance Manager 2.7 or earlier installed and attempt to enable both the API Connectivity Manager and Security Monitoring modules on the same NGINX Management Suite management plane, the API Connectivity Manager module will not load because of incompatibility issues with the Security Monitoring module.

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

### {{% icon-resolved %}} The field retrieving URIs is incorrectly listed as URL. {#38377}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 38377    | Fixed in 1.2.0 |
{{</bootstrap-table>}}

#### Description

The field with URI data is mapped to the heading URL. 

---

### {{% icon-bug %}} Filtering data by Instance Group in the Security Monitoring module does not show any results. {#38790}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 38790    | Open   |
{{</bootstrap-table>}}

#### Description

The Security Monitoring plugin for the NGINX Agent doesn't automatically pick up changes made to `agent-dynamic.conf`, causing associated Instance Groups to be missing in security violations.

#### Workaround

Restart the NGINX Agent, and the subsequent violations should be associated with the Instance Group:

```bash
systemctl restart nginx-agent
```
