---
# We use sentence case and present imperative tone
title: "Attack signatures"
# Weights are assigned in increments of 100: determines sorting order
weight: 500
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

Attack signatures are rules or patterns that identify attack sequences or classes of attacks on a web application and its components. You can apply attack signatures to both requests and responses. 

F5 WAF for NGINX includes predefined attack signatures to protect your application against all attack types identified by the system.

## Signature settings

| Setting | JSON property | F5 WAF for NGINX support | Default value |
| --------| ------------- | ------------------------ | ------------- |
| Signature sets | signature-sets | All available sets. | See signature set list below |
| Signatures | signatures | "Enabled" flag can be modified. | All signatures in the included sets are enabled. |
| Auto-Added signature accuracy | minimumAccuracyForAutoAddedSignatures | Editable | Medium |

## Signature sets

The default and strict policies include and enable common signature sets, which are categorized groups of signatures applied to the policy. However, you may wish to modify the list of signature sets and their logging and enforcement settings via the `signature-sets` array property. There are several ways to configure the enforced signature sets.

One way is by use of the `All Signatures` signature set, which is simply a predefined signature set that includes all signatures known to F5 WAF for NGINX.

In this example, the `All Signatures` set (and therefore the signatures included within) are configured to be enforced and logged respectively, by setting their `block` and `alarm` properties:

```json
{
    "policy": {
        "name": "attack_sigs",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    }
}
```

In this example, only high accuracy signatures are configured to be enforced, but SQL Injection signatures are detected and reported:

```json
{
    "policy": {
        "name": "attack_sigs",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "High Accuracy Signatures",
                "block": true,
                "alarm": true
            },
            {
                "name": "SQL Injection Signatures",
                "block": false,
                "alarm": true
            }
        ]
    }
}
```

Since the "All Signatures" set is not included in the default policy, turning OFF for both alarm and block has no effect because all the other sets with alarm turned ON (and high accuracy signatures with block enabled) are still in place, and a signature that is a member of multiple sets behaves in accordance with the strict settings of all sets it belongs to. 

The only way to remove signature sets is to remove or disable sets that are part of the [default policy]({{< ref "/waf/policies/configuration.md#default-policy" >}}).

For example, in the below default policy, even though all signature alarm and block settings are set to false, attack signatures enforcement cannot be ignored as some of the signature sets will be enabled in their strict policy. 

If you want to remove a specific signature set, you must explicitly mention it under the [strict policy]({{< ref "/waf/policies/configuration.md#strict-policy" >}}).

```json
{
    "policy": {
        "name": "signatures_block",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "Generic Detection Signatures (High/Medium Accuracy)",
                "block": false,
                "alarm": false
            }
        ]
    }
}
```

A signature may belong to more than one set in the policy: tts behavior is determined by the most severe action across all the sets that contain it. 

In the above example, a high accuracy SQL injection signature will both alarm and block, because the `High Accuracy Signatures` set is blocking and both sets trigger alarm.

The default policy already includes many signature sets, most of which are determined by the attack type these signatures protect from, for example `Cross-Site Scripting Signatures` or `SQL Injection Signatures`.

You can view the [full list](#default-signature-sets) at the bottom of this page. In some cases, you may want to exclude individual signatures.

In the following example, signature ID 200001834 is excluded from enforcement:

```json
{
    "policy": {
        "name": "signature_exclude",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ],
        "signatures": [
            {
                 "signatureId": 200001834,
                 "enabled": false
            }
        ]
    }
}
```

Another way to exclude a signature would be the `modifications` section instead of the `signatures` section:

```json
{
    "policy": {
        "name": "signature_modification_entitytype",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    },
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

To exclude multiple attack signatures, each signature ID needs to be added as a separate entity under the `modifications` list:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        },
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200004461
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

In the previous examples, the signatures were disabled for all the requests that are inspected by the respective policy. You can also exclude signatures for specific URLs or parameters, while still enable them for the other URLs and parameters. 

The topic [User-defined URLs and parameters]({{< ref "/waf/policies/user-urls-parameters.md" >}}) has more details.

In some cases, you may want to remove a whole signature set that was included in the default policy. For example, a protected application may not use XML and is not vulnerable to XPath injection. 

If you wanted to remove `XPath Injection Signatures`, there are two methods. 

The first is to set the `alarm` and `block` flags to `false` for this signature set, overriding the base template:

```json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "block": false,
                 "alarm": false
            }
        ]
    }
}
```

The second method is to completely remove this set from the policy using the `$action` meta-property.

```json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "$action": "delete"
            }
        ]
    }
}
```

Although the two methods are functionally equivalent, the second one is preferable for performance reasons.

## Default signature sets

The following signature sets are included in the default policy. 

Most sets are defined by the attack type they protect from. 

In all sets the **Alarm** flag is enabled and **Block** disabled except High Accuracy Signatures, which are set to **blocked** (`block` parameter is enabled).

- Command Execution Signatures
- Cross Site Scripting Signatures
- Directory Indexing Signatures
- Information Leakage Signatures
- OS Command Injection Signatures
- Path Traversal Signatures
- Predictable Resource Location Signatures
- Remote File Include Signatures
- SQL Injection Signatures
- Authentication/Authorization Attack Signatures
- XML External Entities (XXE) Signatures
- XPath Injection Signatures
- Buffer Overflow Signatures
- Denial of Service Signatures
- Vulnerability Scan Signatures
- High Accuracy Signatures
- Server Side Code Injection Signatures
- CVE Signatures

These signatures sets are included but are not part of the default template.

-   All Response Signatures
-   All Signatures
-   Generic Detection Signatures
-   Generic Detection Signatures (High Accuracy)
-   Generic Detection Signatures (High/Medium Accuracy)
-   High Accuracy Signatures
-   Low Accuracy Signatures
-   Medium Accuracy Signatures
-   OWA Signatures
-   WebSphere signatures
-   HTTP Response Splitting Signatures
-   Other Application Attacks Signatures
-   High Accuracy Detection Evasion Signatures