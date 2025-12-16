---
title: Manage security policies and log profiles
description: Create, update, and deploy F5 WAF for NGINX security policies and log profiles using NGINX Instance Manager.
weight: 300
nd-content-type: landing-page
nd-landing-page: true
url: /nginx-instance-manager/waf-integration/policies-and-logs/
nd-product: NIMNGR
---

## Overview

F5 NGINX Instance Manager provides a centralized way to create, edit, and deploy F5 WAF for NGINX security configurations. You can manage security policies, log profiles, attack signatures, bot signatures, and threat campaigns through either the web interface or the REST API.

You can also compile security policies and associated components—such as attack signatures, bot signatures, and threat campaigns—into a single policy bundle. Precompiling these bundles improves performance by avoiding separate compilation during deployment.

{{< call-out "note" "Note" >}}
The following capabilities are available only through the NGINX Instance Manager REST API:

- Create, read, update, and delete security log profiles
- Publish security policies, log profiles, attack signatures, bot signatures, and threat campaigns to instances and instance groups

**Access the REST API**

{{< include "nim/how-to-access-nim-api.md" >}}

{{< /call-out >}}


---

## Before you begin

Before you start, complete these prerequisites:

- [Set up F5 WAF for NGINX configuration management]({{< ref "/nim/waf-integration/configuration/_index.md" >}}).
- Make sure your user account has the [required permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) to access the REST API:
  - **Module:** Instance Manager
  - **Feature:** Instance Management → `READ`
  - **Feature:** Security Policies → `READ`, `CREATE`, `UPDATE`, `DELETE`

To use policy bundles, you also need:

- `UPDATE` permissions for each referenced security policy
- The correct [`nms-nap-compiler` package]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/_index.md" >}}) for your F5 WAF for NGINX version
- The required [attack signatures, bot signatures, and threat campaigns]({{< ref "/nim/waf-integration/configuration/setup-signatures-and-threats/_index.md" >}})

---

## Featured content

{{<card-section showAsCards="true" >}}
  {{<card title="Security policies" titleUrl="policies/" >}}
    Create and manage security policies that define how traffic is inspected, including rules for cookies, parameters, URLs, and attack signatures.
  {{</card>}}
  {{<card title="Security bundles" titleUrl="bundles/" >}}
    Create and manage precompiled security bundles for consistent, efficient deployment across instances.
  {{</card>}}
  {{<card title="Security log profiles" titleUrl="log-profiles/" >}}
    Define how security events are logged and stored for analysis and troubleshooting.
  {{</card>}}
  {{<card title="Publish updates" titleUrl="publish/" >}}
    Deploy and verify updates to security policies and log profiles across managed instances.
  {{</card>}}
{{</card-section>}} 