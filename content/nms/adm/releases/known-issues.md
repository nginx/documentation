---
title: "Known Issues"
date: 
draft: false
description: "This document is a summary of the known issues in NGINX Management Suite App Delivery Manager. Fixed issues are removed after **45 days**. <p>We recommend upgrading to the latest version of App Delivery Manager to take advantage of new features, improvements, and bug fixes.</p>"
# Assign weights in increments of 100
weight: 100000
toc: true
tags: [ "docs" ]
url: /nginx-management-suite/adm/releases/known-issues/
docs: "DOCS-000"
categories: ["known issues"]

---
{{<rn-styles>}}

---

## 4.0.0


### {{% icon-bug %}} Gateway referencing mix of instance groups with and without WAF goes to Error state. {#43313}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 43313 | Open   |
{{</bootstrap-table>}}

#### Description
When the NGINX WAF use case is enabled, a gateway referencing a mix of instance groups with WAF and without WAF goes into an error state if there is a component with WAF enabled referencing another gateway that has an instance group with WAF as a placement.

#### Workaround

Do not use gateways that reference instance groups with and without WAF

---

### {{% icon-bug %}} Cannot remove ADM object if deletion results in an error {#42520}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42520 | Open   |
{{</bootstrap-table>}}

#### Description
If a system error on the nginx instance prevents a new configuration from being applied, it can result in App Delivery Manager objects going into an error state when deleted.  This prevents the object from being removed from an environment.  Multiple attempts to delete the object will also fail.

#### Workaround

To remove the object, the instance groups that the object is referencing (direct if a gateway object; indirectly if a component) must temporarily have the instances removed from the instance group.

---

### {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates {#42517}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42517 | Fixed in App Delivery Manager 4.0.0-EA2   |
{{</bootstrap-table>}}

#### Description
When deploying a configuration with a certificate and key handled by NGINX Management Suite to a custom file path, it may deploy a duplicate copy of the certificate and key to the default /etc/nginx/ path. When deleting the certificate and key, it will only delete the certificate and key in the custom path, leaving the duplicate copy.

#### Workaround

Manually delete the certificate and key from the /etc/nginx/ path.

---

### {{% icon-resolved %}} Certificate updates allow for multiples certs to share the same serial number {#42429}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42429 | Fixed in Instance Manager 2.11.0   |
{{</bootstrap-table>}}

#### Description
It is possible to update an existing certificate's serial number to one already in use. This incorrectly changes the cert (matching the serial number) details to a new name.

#### Workaround

None

---

### {{% icon-resolved %}} Certificate file is not updated automatically under certain conditions {#42425}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42425 | Fixed in Instance Manager 2.11.0   |
{{</bootstrap-table>}}

#### Description
Certificate file is not updated automatically when a config change is pushed to an offline instance after it comes back online.

#### Workaround

None

---

### {{% icon-bug %}} API Documention is not displaying some description fields for schemas containing references to other objects. {#42146}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42146 | Open   |
{{</bootstrap-table>}}

#### Description
API Documentation for Sites, Web Components, and TcpUdp Components displays the `environmentRef` parameter as part of the response in metadata. `environmentRef` is not a part of the response of those endpoints.

#### Workaround

None

---

### {{% icon-bug %}} Config push failure when Agent and NGINX Plus with the metrics module are deployed in a container  {#41868}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 41868 | Open   |
{{</bootstrap-table>}}

#### Description
When the NGINX Agent and NGINX Plus are installed in a container, and the metrics module is also installed on that NGINX Plus instance, any config push to an instance group with that instance will fail. 

#### Workaround

The stream module requires stream block to be in the config so when loading the metrics module use the stream block as well. 

---

### {{% icon-bug %}} System Metrics not available without elevated access rights {#40945}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 40945 | Open   |
{{</bootstrap-table>}}

#### Description
System metrics, as seen in the Overview page, are not displayed for users with roles without elevated access rights, e.g., a Read-only role with no rights to perform other operations like Create, Update, or Delete. 

#### Workaround

None

---

### {{% icon-bug %}} Modules that share the same Instance Group can create config conflicts {#38638}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 38638 | Open   |
{{</bootstrap-table>}}

#### Description
When multiple modules are deployed on the same NGINX Management Suite instance, modules may configure the same server block, and only one config will be applied.

#### Workaround

Use [Role-based Account Control]({{< relref "/nms/admin-guides/access-control/set-up-rbac.md" >}}) to prevent sharing of instance groups between App Delivery Manager and API Connectivity Manager.

---

