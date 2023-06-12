---
title: "Advanced Security"
draft: false
description: Learn how to add an NGINX App Protect (NAP) WAF policy to your Environment by using the Advanced Security policy in NGINX Management Suite API Connectivity Manager.
weight: 350
toc: true
tags: [ "docs" ]
docs: "<TBD>"
doctypes: ["API Connectivity Manager", "api management", "concept"]
journeys: ["getting started", "using"]
personas: ["devops"]
---

{{<custom-styles>}}

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About Advanced Security Policy

Use the *Advanced Security* policy to add a pre-defined NGINX App Protect to your deployment. Doing so will apply the rules specified in the policy, to your APIs.
This will allow enforcement of rules to *Block* or *Monitor* security events triggering those violations set out in the policy.

#### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more [Environments with an API Gateway]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have [published one or more API Gateways]({{< relref "/nms/acm/getting-started/publish-api-proxy" >}}).
- You have [installed and set up NGINX App Protect]({{< relref "/nap-waf/admin-guide/install-nms" >}}).
- NGINX Management Suite Security Monitoring is [installed]({{< relref "/nms/installation/vm-bare-metal/_index.md#install-nms-modules" >}}) and running.

---

## Policy Settings

For the current MVP release, the only setting that can be configured is the policy that will be applied. In future release more configuration options will be made available.
As of this current release, `1.7.0`, all events created by policy rule violations will be forwarded to the `Security Monitoring` dashboard in NMS.

---

## Applying the Policy

*Please note that for this MVP release Advanced Security policies can currently only be applied to Environments*

There are two methods available to allow adding an *Advanced Security* policy to your *Environment*:

1. Through the API by adding the following JSON to our environment via a `PUT` or `POST`:
<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
     "advanced-security": [
        {
           "action": {
              "policyRef": "<my_policy_name_here>"
           }
        }
     ]
  }
}
```
</details>

2. Through the UI:

To create an *Advanced Security* policy using the web interface:

1. {{< include "acm/webui-acm-login.md" >}}
2. On the left menu, select **Infrastructure**.
3. Select a workspace in the list that contains the Environment you want to update.
4. On the workspace overview page, on the **Environments** tab, locate the Environment you want to update and select it.
5. On the Environment overview page, locate the **API Gateway** you want to update and select it.
6. On the **API Gateway** overview page, find and select the **Manage** button and select it
7. On the *Advanced > Global Policies* page, locate **Advanced Security Policy**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
8. On the *Advanced Security Policy* form, complete the necessary fields:

    - **Choose a NAP Policy Reference**: Specify the name of the policy you want to apply from the dropdown.

9. Select **Add**/**Save** to apply the policy to the Environment.
10. Select **Save and Submit** to deploy the configuration to the Environment.
