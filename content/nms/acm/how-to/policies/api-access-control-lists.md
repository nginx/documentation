---
description: Learn how to protect your upstream TCP application servers by denying/allowing
  access from certain client IP addresses, CIDR blocks, client IDs or JWT Claims.
nd-docs: DOCS-950
toc: true
weight: 200
title: API Access Control Lists
---

## Overview

{{< include "acm/how-to/policies-intro" >}}

---

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}) or [Dev Portal]({{< ref "/nms/acm/getting-started/add-devportal" >}}) clusters.
- You have published one or more [API Gateways or Developer]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}})

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

---

## Create ACL IP Restriction Policy

Take the steps in this section if you would like to deny or allow access to your API Gateways or Developer Portals to specific IP addresses or CIDR blocks with ACL lists.

{{<tabs name="add_tls_listener">}}
    {{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \<your workspace\>**, where "your workspace" is the workspace that contains the API Proxy.
1. Select **Edit Proxy** from the Actions menu for the desired API Proxy.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu.
1. Provide the desired **Allowed IP Addresses** and/or **Denied IP Addresses**. Valid values include IPv4, IPv6, and CIDR blocks. To allow or deny all, use the * symbol.


    {{%/tab%}}
    {{%tab name="API"%}}

```json
"policies": {
            "acl-ip": [
                {
                    "action": {
                        "deny": ["*"], // Polulate this array with your denied IP addresses
                        "allow": ["10.0.0.1"]
                    }
                }
            ]
        }
```

    {{%/tab%}}
{{</tabs>}}

{{< note >}}

- If you only set an allow list, then the deny list will default to deny all and vice versa.
- If IP addresses are not explicitly allowed they will be denied. To allow IP addresses as default, include the `*` symbol in the allow list.
- The most specific rule applied will be used to allow or deny traffic. For example, IP addresses take priority over CIDR blocks. Smaller CIDR blocks take priority over larger ones.
{{< /note >}}



### Verification

1. Attempt to contact the API Gateway or Developer Portal from a denied IP address. The host should return the default `403 Forbidden` return code or the custom return code you have set.
1. Contact the IP address from an allowed IP address. The traffic should not be denied.

## Create ACL Consumer Restriction Policy

Specific consumer client IDs or token claims can be denied or allowed access to your API Gateways or Developer Portals by following the steps in this section.

{{<tabs name="add_consumer_policy">}}
    {{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \<your workspace\>**, where "your workspace" is the workspace that contains the API Gateway or Dev Portal.
1. Select **Edit Advanced Config** from the **Actions** menu for the desired API Gateway or Dev Portal.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu for the **ACL Consumer Restriction Policy**.
1. Set the **lookupVariable**. To route based on either the **APIKey Authentication** or **Basic Authentication**, use "client.id" to limit the user based on client ID. For a token-based policy such as **JSON Web Token Assertion** or **OAuth2 Introspection**, you should use "token.{claimKey}. For example: "token.sub" would use the sub claim of a JWT Token.
1. Provide the desired **Allowed List** and/or **Denied List**.

    {{%/tab%}}
    {{%tab name="API"%}}

```json
"policies": {
            "acl-consumer": [
                {
                    "action": {
                        "lookupVariable": "client.id",
                        "allow": ["allowed-user"],
                        "deny": ["denied-user"]
                    }
                }
            ]
        }
```

    {{%/tab%}}

{{</tabs>}}

{{< note >}}

- If you only set an allow list, then the deny list will default to deny all and vice versa.
- If values are not allowed, they will be denied by default if neither list contains a wildcard.
  {{< /note >}}

### Verification

1. Attempt to contact the API Gateway or Developer Portal from a denied using a client that has been denied. The host should return the default `403 Forbidden` return code.
1. Attempt to contact the API Gateway or Developer Portal from an allowed client. The traffic should should be successfully proxied.
