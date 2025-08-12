---
description: Learn how to restrict access to your application servers based on JWT
  claims or header values.
nd-docs: DOCS-1265
title: Access Control Routing
toc: true
weight: 300
type:
- how-to
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Overview

{{< include "acm/how-to/policies-intro" >}}

## Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateway]({{< ref "/nms/acm/getting-started/add-api-gateway" >}}) or [Dev Portal]({{< ref "/nms/acm/getting-started/add-devportal" >}}) clusters.
- You have published one or more [API Gateways or Developer Portals]({{< ref "/nms/acm/getting-started/publish-api-proxy" >}}) with either JSON Web Token Assertion or OAuth2 Introspection enabled.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

## Create Access Control Routing Policy

Take the steps in this section if you would like to restrict access to Advanced Routes or HTTP methods based on either request headers or JWT tokens.

{{<tabs name="add_tls_listener">}}
    {{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Services > \<your workspace\>**, where "your workspace" is the workspace that contains the API Proxy.
1. Select **Edit Proxy** from the Actions menu for the desired API Proxy.
1. On the **Policies** tab, select **Add Policy** from the **Actions** menu.
1. Select **Add route** to configure a rule. Select one or more keys and approved values which will be checked before allowing the end user access to the API. Optionally select an Advanced Route or list of HTTP methods which will restrict the Access Control check to requests which match that configuration.
1. Optionally set the return code, which should be returned to requests which do not satisfy the condition specified.


    {{%/tab%}}
    {{%tab name="API"%}}

```json
"policies": {
    "access-control-routing": [
            {
                "action": {
                    "conditions": [
                        {
                            "allowAccess": {
                                "httpMethods": ["GET"]
                            },
                            "when": [
                                {
                                    "key": "token.role",
                                    "matchType": "STRING",
                                    "matchOneOf": {
                                        "values": [
                                            "admin"
                                        ]
                                    }
                                },
                                {
                                    "key": "token.sub",
                                    "matchType": "REGEX",
                                    "matchOneOf": {
                                        "values": [
                                            "^.*test.com"
                                        ]
                                    }
                                }
                            ]
                        }
                    ]
                }
            }
        ]
```

    {{%/tab%}}
{{</tabs>}}

{{< call-out "note" >}}

- Any requests which do not match a specified condition will be allowed to access the API Gateway or Developer Portal. Adding a rule with no route or HTTP method specified means that
- Adding multiple match conditions in a rule requires that all conditions are matched in order to access the API.
- Adding the same configuration of route and HTTP method to multiple rules will be treated as an OR condition.
- Any requests which match multiple rules will be checked from most to least specific.
- If `matchType` is not specified, `STRING` will be used.
- If the token claim is an array value, `STRING` and `REGEX` behave differently.
  - `STRING` will match if any of the values contained in the array match one of the values.
  - `REGEX` will check against the array converted to a comma-separated string. For example, `[ "first", "second", "third" ]` will become `first,second,third` when the regular expression is checked against it.

{{< /call-out >}}

## Verification

1. Attempt to contact the API Gateway or Developer Portal from a client
1. Contact the IP address from an allowed IP address. The traffic should not be denied.


