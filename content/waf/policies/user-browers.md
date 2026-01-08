---
nd-docs: DOCS-246
title: "User-defined browser control"
weight: 2050
toc: true
nd-content-type: reference
nd-product: F5WAFN
---

This page describes the User-defined browser control feature for F5 WAF for NGINX.

It allows a user to define new custom browsers, and create a list of allowed or disallowed browsers (User-defined or predefined) inspected by F5 WAF for NGINX.

There are two primary uses for this feature:

1. Verifying that non-predefined (Factory) browsers are actually browsers using F5 WAF for NGINX's anti-automation features
1. Blocking access to specific browsers and versions unsupported by an application protected by F5 WAF for NGINX

## Configure user-defined browsers

User-defined browsers can be configured in the `browser-definitions` section of a policy.

These are the properties that can be configured for each user-defined browser:

- `name`: Must be unique to both pre-defined browsers and user-defined browers
- `matchString`: A string that should be present in the `User-Agent` header to trigger enforcement.
- `matchRegex`: A regex pattern that should be matched in the `User-Agent` header to trigger enforcement.
- `description`: A description of the custom browser agent element.

Note that `matchString` and `matchRegex` are mutually exclusive: either can be used, but not at the same time.

You can define list of allowed or disallowed browsers in the `classes` or `browsers` subsections in the `bot-defense/mitigations` section.

1. classes
   * `name` - name of class (in this case only `browser` and `unknown` are relevant).
   * `action` - detect / alarm / block.
1. browsers
   * `name` - name of the browser (pre-defined or user-defined).
   * `action`  - detect / alarm / block.
   * `minVersion` (int) - minimum version of the browser for which the action is applicable (major browser version only).
   * `maxVersion` (int) - maximum version of the browser for which the action is applicable (major browser version only).

Note that:

- `browser` defines the default action for any browser that is not in the supported factory browsers list (the default action is `detect`).
- `unknown` defines the default action for unclassified clients that did not match any browser or bot type (the default action is `alarm`).
- `minVersion` and `maxVersion` are optional properties, and are available only for pre-defined browsers and refer to major browser version. Without them, it defaults to "any" version.

## List of predefined browsers

The following table specifies supported predefined (Factory) browsers:

| Declarative name | Description |
| ---------------- | ----------- |
| android | The native Android browser. |
| blackberry | The native Blackberry browser. |
| chrome | Chrome browser on Microsoft Windows. |
| chrome | Chrome browser on Android. |
| firefox | Firefox on Microsoft Windows. |
| firefox | Firefox on Android. |
| internet-explorer | Internet Explorer on Microsoft Windows. |
| internet-explorer | Internet Explorer on mobile devices. |
| opera | Opera Browser on Microsoft Windows. |
| opera | Opera Mini Browser. |
| opera | Opera on Mobile devices. |
| safari | Safari Browser on Microsoft Windows or Apple macOS. |
| safari | Safari Browser on Apple iOS and iPadOS devices. |
| edge | Microsoft Edge Browser. |
| uc | UC Browser. |
| puffin | Puffin Browser on Microsoft Windows. |
| puffin | Puffin Browser on Android devices. |
| puffin | Puffin Browser on iOS devices. |

## Enforcement flow

If the received request has no bot signatures, then the following enforcement sequence runs:

1. Parse the `User-Agent` header. If a known browser is identified, then enforce based on the action set in the `browser` subsection of the `classes` section.
1. If no pre-defined or user-defined browser is identified, then enforce based on the action set in the `unknown` subsection of the `classes` section.
1. If both predefined and user-defined browser is detected, then the user-defined one takes precedence and its action is executed according to point 1.
1. If more than one user-defined browser is detected, then the most severe action of the detected browsers is taken.

User-defined browser control is part of the `bot-defense` configuration in the policy, and can can take place only if `isEnabled` flag under `bot-defense` section is set to `true` (Enabled in the default policy).

## Configuration examples

In this first example, the policy is configured to:

- Include some user-defined browsers
- Detect (allow) all browsers except for browsers with action set to `block` in `browsers` section (Based on `minVersion`/`maxVersion` field values)
- Trigger an alarm if no browser was detected

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_1",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "browser-definitions": [
            {
                "name": "FunkyBrowserV3",
                "matchString": "FunkyBrowser/1.3.1",
            },
            {
                "name": "SmartBrowser4",
                "matchRegex": "smartbrowser/([\\d.]+)",
            }
        ],
        "bot-defense": {
            "settings" : {
                "isEnabled": true
            },
            "mitigations": {
                "classes": [
                    {
                        "name": "browser",
                        "action": "detect"
                    },
                    {
                        "name": "unknown",
                        "action": "alarm"
                    }
                ],
                "browsers": [
                    {
                        "name": "safari",
                        "action": "block"
                    },
                    {
                        "name": "chrome",
                        "minVersion": 77,
                        "action": "block"
                    },
                    {
                        "name": "firefox",
                        "minVersion": 45,
                        "maxVersion": 60,
                        "action": "block"
                    },
                    {
                        "name": "FunkyBrowserV3",
                        "action": "block"
                    }
                ]
            }
        }
    }
}
```

In this second example, the policy is configured to:

- Include some user-defined browsers
- Block all browsers except for browsers with action set to `detect` or `alarm` in `browsers` section (Based on `minVersion`/`maxVersion` field values).
- Block the request if no browser was detected.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_2",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "browser-definitions": [
            {
                "name": "FunkyBrowserV3",
                "matchString": "FunkyBrowser/1.3.1",
            },
            {
                "name": "SmartBrowser4",
                "matchRegex": "smartbrowser/([\\d.]+)",
            }
        ],
        "bot-defense": {
            "settings" : {
                "isEnabled": true
            },
            "mitigations": {
                "classes": [
                    {
                        "name": "browser",
                        "action": "block"
                    },
                    {
                        "name": "unknown",
                        "action": "block"
                    }
                ],
                "browsers": [
                    {
                        "name": "safari",
                        "action": "detect"
                    },
                    {
                        "name": "chrome",
                        "minVersion": 77,
                        "action": "alarm"
                    },
                    {
                        "name": "firefox",
                        "minVersion": 45,
                        "maxVersion": 60,
                        "action": "detect"
                    },
                    {
                        "name": "FunkyBrowserV3",
                        "action": "detect"
                    }
                ]
            }
        }
    }
}
```