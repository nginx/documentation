---
nd-docs: "DOCS-1575"
---

Anti Automation provides basic bot protection by detecting bot signatures and clients that falsely claim to be browsers or search engines. The `bot-defense` section in the policy is enabled by default. Anti Automation encompasses both Bot Signatures and Header Anomalies, each of which can be disabled separately.

As new bot signatures are identified, they will be accessible for [download and installation]({{< ref "/nap-waf/v4/admin-guide/install.md#updating-app-protect-bot-signatures" >}}) so that your system will always have the most up-to-date protection. You can update the bot signatures without updating the App Protect release. Similarly, you can update App Protect without altering the bot signature package, unless you upgrade to a new NGINX Plus release.

#### Bot Signatures

Bot Signatures provide basic bot protection by detecting bot signatures in the User-Agent header and URI.
Each bot signature belongs to a bot class. Search engine signatures such as `googlebot` are under the trusted_bots class, but App Protect performs additional checks of the trusted bot's authenticity. If these checks fail, it means that the respective client impersonated the search engine in the signature and it will be classified as class - `malicous_bot`, anomaly - `Search engine verification failed`, and the request will be blocked, irrespective of the class's mitigation actions configuration.
An action can be configured for each bot class, or may also be configured per each bot signature individually:
* `ignore`    - bot signature is ignored (disabled)
* `detect`    - only report without raising the violation - `VIOL_BOT_CLIENT`. The request is considered `legal` unless another violation is triggered.
* `alarm`     - report, raise the violation, but pass the request. The request is marked as `illegal`.
* `block`     - report, raise the violation, and block the request

In this example we show how to enable bot signatures using the default bot configuration:

```json

{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            }
        }
    }
}
```

The default actions for classes are: `detect` for `trusted-bot`, `alarm` for `untrusted-bot`, and `block` for `malicious-bot`. In this example, we enabled bot defense and specified that we want to raise a violation for `trusted-bot`, and block for `untrusted-bot`.

```json
{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            },
            "mitigations": {
                "classes": [
                    {
                        "name": "trusted-bot",
                        "action": "alarm"
                    },
                    {
                        "name": "untrusted-bot",
                        "action": "block"
                    },
                    {
                        "name": "malicious-bot",
                        "action": "block"
                    }
                ]
            }
        }
    }
}
```

In this example, we override the action for a specific signature (python-requests)

```json
{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            },
            "mitigations": {
                "signatures": [
                    {
                        "action": "ignore",
                        "name": "python-requests"
                    }
                ]
            }
        }
    }
}
```

#### Bot Signatures Update File

Starting with NGINX App Protect WAF release 4.7, the bot signature file `included_bot_signatures`, is located at the following path: `/opt/app-protect/var/update_files/bot_signatures/included_bot_signatures`. This will be part of the **app-protect-bot-signatures** package.

This file contains an up-to-date list of all bot signatures that have been updated with the new bot signature package. This list is automatically generated as a part of the **app-protect-bot-signatures** package and follows a format similar to the README-style text file found in the attack signature. This file contains essential information which includes:

- Bot name
- Bot type
- Bot classification/category


#### List of Trusted Bots

This is a list of the trusted bots that are currently part of the bot signatures. As the title suggests, these bot signatures belong to the `trusted-bot` class and currently all are search engines.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Bot Name | Description |
| ---| --- |
|Ask | [Ask.com engine](https://www.ask.com) |
|Baidu | [Baidu search engine](https://www.baidu.com/) |
|Baidu Image Spider | [Baidu search engine for images](https://image.baidu.com/) |
|Bing | [Microsoft Bing search engine](https://www.bing.com/) |
|BingPreview | [Microsoft Bing page snapshot generation engine](https://www.bing.com/) |
|Daum | [Daum search engine](https://www.daum.net/) |
|DuckDuckGo Bot | [DuckDuckGo search engine](https://duckduckgo.com/) |
|fastbot | [fastbot search engine](https://www.fastbot.de/) |
|Google | [Google search engine](https://www.google.com/) |
|MojeekBot | [Mojeek search engine](https://www.mojeek.com/) |
|Yahoo! Slurp | [Yahoo search engine](https://www.yahoo.com/) |
|Yandex | [Yandex search engine](https://yandex.com/) |
|YioopBot | Yioop search engine |
{{</bootstrap-table>}}


#### Header Anomalies

In addition to detecting Bot Signatures, by default NGINX App Protect WAF verifies that a client claiming to be a browser is indeed one by inspecting the HTTP headers.
Each request receives a score, is categorized by anomaly, and is enforced according to the default configured anomaly action:


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Range | Anomaly | Action | Class |
| ---| ---| ---| --- |
|0-49 | None | None | Browser |
|50-99 | Suspicious HTTP Headers Presence or Order | Alarm | Suspicious Browser |
|100 and above | Invalid HTTP Headers Presence or Order | Block | Malicious Bot |
| Non Applicable | SEARCH_ENGINE_VERIFICATION_FAILED | Block | Malicious Bot |
{{</bootstrap-table>}}


Notice that the default scores for each anomaly can be changed. In this example, we override the score and action of the default bot configuration:

```json

{
    "policy": {
        "name": "bot_anomalies_and_signatures",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "mitigations": {
                "anomalies": [
                    {
                        "name": "Suspicious HTTP Headers",
                        "action": "alarm",
                        "scoreThreshold": 50
                    },
                    {
                        "name": "Invalid HTTP Headers",
                        "action": "block",
                        "scoreThreshold": 99
                    }
                ]
            }
        }
    }
}

```