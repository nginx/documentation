---
description: Learn how to add an F5 NGINX App Protect WAF policy to your environment
  by using the Advanced Security policy in NGINX Management Suite API Connectivity
  Manager.
docs: DOCS-1264
doctypes:
- API Connectivity Manager
- api management
- concept
tags:
- docs
title: Advanced Security
toc: true
weight: 350
---

## Overview

{{< include "acm/how-to/policies-proxy-intro" >}}

---

## About Advanced Security Policy

Use the *Advanced Security* policy to add a pre-defined F5 NGINX App Protect to your deployment. Doing so will apply the rules specified in the policy to your APIs.
This will allow enforcement of rules to *Block* or *Monitor* security events triggering those violations set out in the policy.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}
{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more [Environments with an API Gateway]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}).
- You have [published one or more API Gateways]({{< relref "/nms/acm/getting-started/publish-api-proxy" >}}).
- You have [installed and set up NGINX App Protect]({{< relref "/nap-waf/v4/admin-guide/install-nms" >}}).
- NGINX Management Suite Security Monitoring is [installed]({{< relref "/nim/monitoring/security-monitoring/install-security-monitoring.md" >}}) and running.

---

## Policy Settings

The applied policy is configurable, and all events created by rule violations will go to the `Security Monitoring` dashboard in NGINX Management Suite.

To create a new policy or modify an existing policy, you can navigate to the *App Protect* area of the NGINX Management Suite.

*NGINX App Protect* policies can also contain a reference to an Open API Specification which will enable payload schema validation on the dataplane instance.

{{< note >}}

For information on how to configure an *App Protect* policy, please visit - [Configure NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#policy-configuration-overview)

To create an NGINX App Protect WAF policy to use in your Advanced Security policy, please see the [Create a Policy]({{< relref "/nim/nginx-app-protect/manage-waf-security-policies#create-security-policy" >}}) documentation.
{{< /note >}}

---

## Applying the Policy

*NGINX App Protect* policies can be applied to both *Environments* and *Proxies*, allowing for granular control.

Should you wish to configure a global monitoring policy (non-blocking), but require blocking on only a subset of your API endpoints, you can apply a monitoring policy to your environment and a blocking policy on the proxy you have deployed to that environment.

This means that only the specific *Proxy* that you have applied the policy to will be enforced in blocking mode and the other endpoints in that environment are unaffected, inherting the monitoring policy from their parent *Environment*.

*Proxies* in an *Environment* can also each have their own different policies applied should that be required.

There are two methods available to enable adding an *Advanced Security* policy to your Deployment:

<details closed>
<summary>Environment</summary>
{{<tabs name="add_advanced_security_policy_env">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an *Advanced Security* policy using the REST API, send an HTTP `POST` or `PUT` request to the *Environments* endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                           |
|--------|----------------------------------------------------|
| `POST` | `/infrastructure/workspaces/{infra-workspace}/environments` |
| `PUT` | `/infrastructure/workspaces/{infra-workspace}/environments/{environment-name}` |

{{</bootstrap-table>}}


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

{{%/tab%}}

{{%tab name="UI"%}}

To create an *Advanced Security* policy using the web interface:

{{< include "acm/webui-acm-login.md" >}}

1. On the left menu, select **Infrastructure**.
2. Select a workspace in the list that contains the Environment you want to update.
3. On the workspace overview page, on the **Environments** tab, locate the Environment you want to update and select it.
4. On the Environment Overview page, locate the **API Gateway** you want to update and select it.
5. On the **API Gateway** overview page, find and select the **Manage** button and select it.
6. On the *Advanced > Global Policies* page, locate **Advanced Security Policy**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
7. On the *Advanced Security Policy* form, complete the necessary fields:
8.
   - **Choose a NAP Policy Reference**: Specify the name of the policy you want to apply from the dropdown

9. Select **Add**/**Save** to apply the policy to the Environment.
10. Select **Save and Submit** to deploy the configuration to the Environment.

{{%/tab%}}

{{</tabs>}}
</details>

<details closed>
<summary>Proxy</summary>

{{<tabs name="add_advanced_security_policy_proxy">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an *Advanced Security* policy using the REST API, send an HTTP `POST` or `PUT` request to the Proxies endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                           |
|--------|----------------------------------------------------|
| `POST` | `/services/workspaces/{service-workspace}/proxies` |
| `PUT` | `/services/workspaces/{service-workspace}/proxies/{proxy-name}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

```json
{
  "policies": {
     "api-advanced-security": [
        {
           "action": {
              "policyRef": "<my_policy_name_here>",
              "appProtectMode": "<ENABLE|DISABLE>"
           }
        }
     ]
  }
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create an *Advanced Security* policy using the web interface:

{{< include "acm/webui-acm-login.md" >}}

1. On the left menu, select **Services**.
2. Select a workspace in the list that contains the *Proxy* you want to update.
3. On the workspace overview page, on the **API Proxies** tab, locate the *Proxy* you want to update and Select the **Actions** menu (represented by an ellipsis, `...`) and select **Edit proxy**
4. On the *Policies* page, locate **Advanced Security**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
5. On the *Advanced Security Policy* form, complete the necessary fields:

   - **Choose your App Protect mode**: This allows the enforcement or non-enforcement on a particular group of API endpoints, you may want to disable *App Protect* for some endpoints but not others.
   - **Choose a NAP Policy Reference**: Specify the name of the policy you want to apply from the dropdown.

6. Select **Add**/**Save** to apply the policy to the *Proxy*.
7. Select **Save and Submit** to deploy the configuration to the *Proxy*.

{{%/tab%}}

{{</tabs>}}

</details>
