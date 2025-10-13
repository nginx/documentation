---
# We use sentence case and present imperative tone
title: "Bot signatures"
# Weights are assigned in increments of 100: determines sorting order
weight: 550
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

Bot signatures are a feature that protects applications by detecting signatures and clients that falsely claim to be browsers or search engines.

This feature is enabled by default with the `bot-defense` parameter, and includes both bot signatures and header anomalies, which can be disabled separately.

## Bot signatures

Bot signature detection works by inspecting the the User-Agent header and URI of a request.

Each detected bot signature belongs to a bot class: search engine signatures such as `googlebot` are under the trusted_bots class, but F5 WAF for NGINX performs additional checks to authenticate a trusted bot.

If these checks fail, it means the detected bot signature impersonated a search engine, and it will be given the class `malicous_bot`, anomaly `Search engine verification failed`.

The request will be blocked, regardless of the class's mitigation actions configuration.

This is a list of trusted bots, all of which are search engines.

| Name               | Description |
| ------------------ | ----------- |
| Ask                | [Ask.com engine](https://www.ask.com) |
| Baidu              | [Baidu search engine](https://www.baidu.com/) |
| Baidu Image Spider | [Baidu search engine for images](https://image.baidu.com/) |
| Bing               | [Microsoft Bing search engine](https://www.bing.com/) |
| BingPreview        | [Microsoft Bing page snapshot generation engine](https://www.bing.com/) |
| Daum               | [Daum search engine](https://www.daum.net/) |
| DuckDuckGo Bot     | [DuckDuckGo search engine](https://duckduckgo.com/) |
| fastbot            | [fastbot search engine](https://www.fastbot.de/) |
| Google             | [Google search engine](https://www.google.com/) |
| MojeekBot          | [Mojeek search engine](https://www.mojeek.com/) |
| Yahoo! Slurp       | [Yahoo search engine](https://www.yahoo.com/) |
| Yandex             | [Yandex search engine](https://yandex.com/) |
| YioopBot           | Yioop search engine |

An action can be configured for each bot class, or configured for each bot signature individually:

* `ignore`    - Bot signature is ignored (disabled)
* `detect`    - Only report without raising the violation - `VIOL_BOT_CLIENT`. The request is considered `legal` unless another violation is triggered.
* `alarm`     - Report, raise the violation, but pass the request. The request is marked as `illegal`.
* `block`     - Report, raise the violation, and block the request

This example enables bot signatures using the default bot configuration:

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

The default actions for classes are: `detect` for `trusted-bot`, `alarm` for `untrusted-bot`, and `block` for `malicious-bot`. 

The next example enables bot defense, configuring a violation for `trusted-bot`, and block for `untrusted-bot`.

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

The next example overrides the action for a specific signature (python-requests):

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

The bot signature file, `included_bot_signatures`, is located at the following path: `/opt/app-protect/var/update_files/bot_signatures/included_bot_signatures`.

This file is an up-to-date list of all bot signatures, following a format similar to the README-style text file found for [attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}).

It contains information such as:

- Bot name
- Bot type
- Bot classification/category

It is part of the _app-protect-bot-signatures_ package: for more information, see the [Update F5 WAF for NGINX signatures]({{< ref "/waf/install/update-signatures.md" >}}) topic.

## Header anomalies

In addition to detecting bot signatures, F5 WAF for NGINX verifies that a client is the browser it claims to be by inspecting the HTTP headers.

Each request receives a score and anomaly category, and is enforced according to the default anomaly action:

| Range          | Anomaly                                   | Action | Class              |
|--------------- | ----------------------------------------- | ------ | ------------------ |
| 0-49           | None                                      | None   | Browser            |
| 50-99          | Suspicious HTTP Headers Presence or Order | Alarm  | Suspicious Browser |
| 100 and above  | Invalid HTTP Headers Presence or Order    | Block  | Malicious Bot      |
| Non Applicable | SEARCH_ENGINE_VERIFICATION_FAILED         | Block  | Malicious Bot      |

The default scores for each anomaly can be changed. 

In this example, the score and action of the default bot configuration has been overrided:

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