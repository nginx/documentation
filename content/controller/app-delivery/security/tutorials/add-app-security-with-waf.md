---
description: How to add F5 NGINX Controller App Security to your applications.
docs: DOCS-484
title: Manage App Security
toc: true
weight: 100
type:
- concept
- reference
---

## Overview

You can use the App Security add-on for F5 NGINX Controller ADC to enable Web Application Firewall (WAF) capabilities to protect your applications. WAF lets you flag or block suspicious requests or attacks. WAF can be added to individual app components.


## Before You Begin

Before proceeding with this guide, complete the following tasks.
{{<note>}}These steps may need to be completed by a user with admin permissions.{{</note>}}

1. [Add an NGINX App Protect instance]({{< ref "/controller/infrastructure/instances/add-nap-instance.md" >}}) to NGINX Controller.

In addition, the following resources must exist in order to complete the steps in this topic:

- [Environment]({{< ref "/controller/services/manage-environments.md" >}})
- [Gateway]({{< ref "/controller/services/manage-gateways.md" >}})
- [Certs]({{< ref "/controller/services/manage-gateways.md" >}}) (required if your Components use HTTPS)
- [App and Component(s)]({{< ref "/controller/app-delivery/manage-apps.md" >}})

## Enable WAF for a Component using the Default Security Strategy

To enable WAF functionality for Application Security using the default security strategy, send a POST or PUT request to the Components endpoint, with a JSON object similar to the following:

```json
        "security": {
            "waf": {
                "isEnabled": true
            }
        }
```

{{<note>}}You need READ access to the `/security/strategies/` API path to enable WAF on a component. By default, only users with an admin role have full access to all API endpoint resources.{{</note>}}

This JSON object should be added to the Component endpoint similar to the following example:

```json
{
    "metadata": {
        "name": "secure",
        "displayName": "protected web server",
        "description": "ProtectedWeb Server",
        "tags": [
            "dev",
            "protected"
        ]
    },
    "desiredState": {
        "ingress": {
            "gatewayRefs": [
                {
                    "ref": "/services/environments/dev/gateways/dev-gw"
                }
            ],
            "uris": {
                "/secure": {
                    "matchMethod": "PREFIX"
                }
            }
        },
        "security": {
            "strategyRef": {
                "ref": "/security/strategies/balanced_default"
            },
            "waf": {
                "isEnabled": true
            }
        },
        "backend": {
            "ntlmAuthentication": "DISABLED",
            "preserveHostHeader": "DISABLED",
            "workloadGroups": {
                "farm": {
                    "locationRefs": [
                        {
                            "ref": "/infrastructure/locations/unspecified"
                        }
                    ],
                    "loadBalancingMethod": {
                        "type": "ROUND_ROBIN"
                    },
                    "uris": {
                        "http://{{workload-1}}:8080": {
                            "isBackup": false,
                            "isDown": false,
                            "isDrain": false,
                            "resolve": "DISABLED"
                        },
                        "http://{{workload-2}}:8080": {
                            "isBackup": false,
                            "isDown": false,
                            "isDrain": false,
                            "resolve": "DISABLED"
                        },
                        "http://{{workload-3}}:8080": {
                            "isBackup": false,
                            "isDown": false,
                            "isDrain": false,
                            "resolve": "DISABLED"
                        },
                        "http://{{workload-4}}:8080": {
                            "isBackup": false,
                            "isDown": false,
                            "isDrain": false,
                            "resolve": "DISABLED"
                        }
                    }
                }
            }
        },
        "logging": {
            "errorLog": "ENABLED",
            "accessLog": {
                "state": "DISABLED",
                "format": ""
            }
        }
    }
}
```

## Enable WAF for a Component Using Your Own NGINX App Protect WAF Policy

Instead of using NGINX Controller's default policy for WAF, you can [bring your own NGINX App Protect Policy]({{< ref "/controller/app-delivery/security/concepts/bring-your-own-policy.md" >}}) for use in a Security Strategy to protect your app components.

To do so, you first need to upload your NGINX App Protect WAF declarative JSON policy to the Security Policy endpoint and reference it in a Security Strategy. Then, you can reference the Security Strategy in the Component where you are enabling WAF.

### Upload your NGINX App Protect WAF Policy

To upload your NGINX App Protect declarative JSON Policy to NGINX Controller, use an HTTP client like cURL and send a `PUT` request to the [Security Policy REST API}(https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/)
The JSON object should be similar to the example below:

```json
{
  "metadata": {
    "name": "yourPolicyName",
    "displayName": "App Protect Policy",
    "description": "my special NAP policy",
    "tags": ["test1", "test2"]
  },
  "desiredState": {
    "content": {"policy": {"name": "/Common/yourPolicyName", "template": {"name": "POLICY_TEMPLATE_NGINX_BASE"}, "applicationLanguage": "utf-8", "enforcementMode": "blocking", "signatures": [{"signatureId": 123458888, "enabled": false}, {"signatureId": 200000098, "enabled": false}, {"signatureId": 200001475, "enabled": false}, {"signatureId": 200002595, "enabled": false}], "bot-defense": {"settings": {"isEnabled": false}}, "headers": [{"name": "*", "type": "wildcard", "decodeValueAsBase64": "disabled"}, {"name": "*-bin", "type": "wildcard", "decodeValueAsBase64": "required"}, {"name": "Referer", "type": "explicit", "decodeValueAsBase64": "disabled"}, {"name": "Authorization", "type": "explicit", "decodeValueAsBase64": "disabled"}, {"name": "Transfer-Encoding", "type": "explicit", "decodeValueAsBase64": "disabled"}], "cookies": [{"name": "*", "type": "wildcard", "decodeValueAsBase64": "disabled"}], "parameters": [{"name": "*", "type": "wildcard", "decodeValueAsBase64": "disabled"}]}}
  }
}
```

### Create or Update a Security Strategy with a BYO NGINX App Protect WAF Policy

You can create or update a Security Strategy that references a BYO NGINX App Protect WAF policy by sending a `PUT` request to the [Strategies REST API](https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/) endpoint.

The JSON object should be similar to the example below:

```json

{
    "metadata": {
        "name": "yourSecStrategyName",
        "displayName": "Security Strategy",
        "description": "my special security strategy",
        "tags": [
            "tag1",
            "tag2"
        ]
    },
    "desiredState": {
        "content": {
            "securityPolicyRef": "/security/policies/yourPolicyName"
        }
    }
}

```

### Add a BYO NGINX App Protect WAF policy to an App Component

To add your BYO NGINX App Protect Policy to your App(s), you need to add a reference to the Security Strategy that contains the policy to your App Component.

To do so, send a `PUT` request to the [Components REST API](https://docs.nginx.com/nginx-controller/api/ctlr-adc-api/#tag/Components) endpoint.

The JSON object should be similar to the example below:

```json

     "security": {
      "strategyRef": {
        "ref": "/security/strategies/<yourSecStrategyName>"
      },
      "waf": {
        "isEnabled": true,
      }
    }

```

{{< note >}}

The following WAF security parameters are not supported in App Components that reference a custom Security Strategy:

- `isMonitorOnly`
- `signatureOverrides`

These preceding parameters are supported by NGINX Controller's default policy for WAF.

{{< /note >}}

&nbsp;

## Verify that WAF is Enabled

Complete the tasks in this section to verify that the Web Application Firewall is active and processing traffic.

To verify that WAF has been enabled by NGINX Controller App Security to protect your app component,  send an HTTP GET request to the app component.

**Example using NGINX Controller's default policy**: GET: `https://[gateway FQDN]<app component path>/?a=<script>`.

- The WAF does not begin to emit security events immediately upon activation. We recommend that you wait a minute or two after enabling WAF for your Component to query the REST API for security events.
- The request should be blocked. You should be able to view the Security Violation event for the request using the **Analytics Events API**, as documented below, or via the **Security Events** in the user interface.
- The `[gateway FQDN]` is the URI specified in the ingress block of the Gateway referenced by the app component. The `<app component path>` is the URI specified in the ingress block of the app component.

Take the steps below to review the WAF Security Events that correspond to the simulated malicious request.

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Apps**.
4. On the Analytics sub-menu, select **Security Events**.
5. If you see a list of security violations and the outcome, this confirms that App Protect and WAF are running.

To view all events:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Analytics**.
3. On the **Analytics** menu, select **Events**.
4. Select **All Events** to view security violations and the status. Flagged and rejected status means that App Protect and WAF are running.

{{< note >}}

The WAF does not begin to emit security events immediately upon activation. We recommend that you wait a minute or two after enabling WAF for your Component to query the REST API for security events.

{{< /note >}}

{{< note >}}

If NGINX Controller isn't logging any Security Violation Events for your app component, check [Security Events Not Available]({{< ref "/controller/support/troubleshooting-controller.md#Security-Events-Not-Available" >}}) for troubleshooting instructions.

{{< /note >}}

## Disable WAF for Component

To disable WAF for App Security, send a POST or PUT request to the Components endpoint, with a JSON object similar to the following:

```json
        "security": {
            "waf": {
                "isEnabled": false
            }
        }
```

You can also delete the **WAF** block from the Components endpoint to disable WAF.

{{< versions "3.12" "latest" "ctrlvers" >}}
