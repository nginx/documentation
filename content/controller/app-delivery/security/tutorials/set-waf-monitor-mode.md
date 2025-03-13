---
description: How to use F5 NGINX Controller App Security to monitor or block security
  violations.
docs: DOCS-485
title: Set Up App Security Monitor Mode
toc: true
weight: 200
type:
- how-to
---

## Overview

You can use the [F5 NGINX Controller REST API]({{< relref "/controller/api/_index.md" >}}) to enable or disable monitor-only mode for the App Security WAF policy.

## Enable Monitor-Only Mode for App Security WAF

When monitor-only mode is enabled, traffic is allowed to pass without being rejected. However, security events are still generated and metrics are still collected. See [About App Security Analytics]({{< relref "view-app-security-analytics.md#overview" >}}) for more information.

To enable monitor-only mode for App Security WAF, send a POST or PUT request to the **Components** endpoint, with a JSON object similar to the following:

```json
{
  "metadata": {...},
  "desiredState": {
    "ingress": {...},
    "security": {
       "strategyRef": {
         "ref": "/security/strategies/policyName"
       },
       "waf": {
            "isEnabled": true,
            "isMonitorOnly": true
        }
    },
    "backend": {...},
    "logging": {...}
  }
}
```

## Block Traffic Violations with App Security WAF

When monitor-only mode is disabled, traffic is blocked based on the [Violation Rating]({{< relref "/controller/app-delivery/security/concepts/app-sec-default-policy-original.md#use-of-violation-ratings-in-default-policy" >}}) score for the default policy.

To block traffic violations with App Security WAF, send a POST or PUT request to the `/services/apps/components` [REST API]({{< relref "/controller/api/_index.md" >}}) endpoint, with a JSON object similar to the following:

```json
{
  "metadata": {...},
  "desiredState": {
    "ingress": {...},
    "security": {
       "strategyRef": {
         "ref": "/security/strategies/policyName"
       },
        "waf": {
            "isEnabled": true,
            "isMonitorOnly": false
        }
    },
    "backend": {...},
    "logging": {...}
  }
}
```

{{< versions "3.12" "latest" "ctrlvers" >}}
