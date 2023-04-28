---
title: "Known Issues"
date: 
draft: false
description: "This document is a summary of the known issues in NGINX Management Suite App Delivery Manager. Fixed issues are removed after **45 days**. <p>We recommend upgrading to the latest version of App Delivery Manager to take advantage of new features, improvements, and bug fixes.</p>"
# Assign weights in increments of 100
weight: 100000
toc: true
tags: [ "docs" ]
docs: "DOCS-000"
categories: ["known issues"]
doctypes: ["reference"]
---
{{<rn-styles>}}

---

## 4.0.0

###  {{% icon-bug %}} ADM and ACM  Interoperability - Cannot share Instance Groups {#00001}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID               | Status          |
| ---------------------- | --------------- |
| 00001                  | Open            |
{{</bootstrap-table>}}

#### Description

The Application Delivery Manager (ADM) and API Connectivity Manager (ACM) cannot share the same instance groups.  If both managers reference the same instance groups, incorrect configurations may be generated.

#### Workaround

None.  Each manager should deploy only to instance groups created specifically for that manager.
