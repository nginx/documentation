---
nd-docs: "DOCS-1543"
---

The User-Defined Browser Control feature allows a user to define new custom browsers, and create a list of allowed or disallowed browsers (both user-defined and factory preset browsers) used by the client application. It mainly provides the opportunity:
1. To detect browsers that are not among the factory supported ones so that they can be verified they are indeed browsers using the anti-automation feature.
2. To be able to block access to specific browsers types and versions that the application does not support. This is not a security feature but rather a means to provide a smooth user experience.

##### User-Defined Browser Control Configuration

User-defined browsers can be configured in the `browser-definitions` section in the policy. There are a number of properties that can be configured per user-defined browser element:

- `name` - must be unique and not conflict with factory names.
- `matchString` - string that should be present in the `User-Agent` header to trigger enforcement.
- `matchRegex` - regex that should be matched in the `User-Agent` header to trigger enforcement.
- `description` - description of the custom browser agent element.

Please note that:
- `matchString` and `matchRegex` are mutually exclusive (either can appear but never both at the same time).

Defining a list of allowed or disallowed browsers can be done in `classes` and `browsers` sections under `bot-defense/mitigations` section.
1. classes
   * `name` - name of class (in this case only `browser` and `unknown` are relevant).
   * `action` - detect / alarm / block.
2. browsers
   * `name` - name of the browser (factory or user-defined).
   * `action`  - detect / alarm / block.
   * `minVersion` (int) - minimum version of the browser for which the action is applicable (major browser version only).
   * `maxVersion` (int) - maximum version of the browser for which the action is applicable (major browser version only).

Please note that:
- `browser` class defines the default action for any browser that is not in the supported factory browsers list (the default action is `detect`).
- `unknown` class defines the default action for unclassified clients that did not match any browser or bot type (the default action is `alarm`).
- `minVersion` and `maxVersion` properties are available only for factory browsers and refer to major browser version. These fields are optional - when not present (either one) then it means "any" version.

##### List of Supported Factory Browsers

The following table specifies supported built-in (factory) browsers:

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Declarative Name | Description |
| ---| --- |
|android | The native Android browser. |
|blackberry | The native Blackberry browser. |
|chrome | Chrome browser on Microsoft Windows. |
|chrome | Chrome browser on Android. |
|firefox | Firefox on Microsoft Windows. |
|firefox | Firefox on Android. |
|internet-explorer | Internet Explorer on Microsoft Windows. |
|internet-explorer | Internet Explorer on mobile devices. |
|opera | Opera Browser on Microsoft Windows. |
|opera | Opera Mini Browser. |
|opera | Opera on Mobile devices. |
|safari | Safari Browser on Microsoft Windows or Apple macOS. |
|safari | Safari Browser on Apple iOS and iPadOS devices. |
|edge | Microsoft Edge Browser. |
|uc | UC Browser. |
|puffin | Puffin Browser on Microsoft Windows. |
|puffin | Puffin Browser on Android devices. |
|puffin | Puffin Browser on iOS devices. |
{{</bootstrap-table>}}


##### User-Defined Browser Control Enforcement

If the received request has no bot signatures, then the following actions are enforced:
1. Parse the `User-Agent` header. If a known browser is identified, then enforce based on the action set in the `browser` subsection of the `classes` section.
2. If no factory or user-defined browser is identified, then enforce based on the action set in the `unknown` subsection of the `classes` section.
3. If both factory and user-defined browser were detected, then the user-defined one takes precedence and its action is executed according to point 1.
4. If more than one user-defined browser was detected, then the most severe action of the detected browsers is taken.

Please note that:
- User-Defined Browser Control configuration is part of the `bot-defense` configuration in the policy, therefore enforcement can take place only if `isEnabled` flag under `bot-defense` section is set to `true` (it is set to true in the default policy).

##### User-Defined Browser Control Configuration Examples

In the following example, the policy is configured with these items:
- Define some user-defined browsers.
- Detect (allow) all browsers except for browsers with action set to `block` in `browsers` section (according to `minVersion`/`maxVersion` fields values).
- Alarm if no browser was detected.

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

In the next example, the policy is configured with the following items:
- Define some user-defined browsers.
- Block all browsers except for browsers with action set to `detect` or `alarm` in `browsers` section (according to `minVersion`/`maxVersion` fields values).
- Block request if no browser was detected.

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