---
# We use sentence case and present imperative tone
title: "User-defined signatures"
# Weights are assigned in increments of 100: determines sorting order
weight: 2125
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
nd-product: F5WAFN
nd-docs: DOCS-1596
---

This page describes the user-defined signatures feature of F5 WAF for NGINX.

In addition to F5 WAF for NGINX's pre-defined signatures and signature sets, users can create their own signatures and signature sets.

## Signature sets

User-defined signature sets can be used to organise both pre-defined and user-defined signatures into logical groups based on policy usage.

When organising pre-defined signatures, you can group them into user-defined signature sets two ways:

- By adding signatures based on their unique ID
- By filtering signatures based on their properties, such as risk level, attack type or request/response detail

When organising user-defined signatures, they cannot be grouped with pre-defined signatures in the same set, and their IDs are automatically generated.

This means that they must be organised by filtering by their properties.

The following example shows a user-defined signature set based on filtered signatures that have "low" accuracy:

```json
{
    "name": "filtered_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-low-accuracy-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "filter-based",
                "filter": {
                    "attackType": {
                        "name": "Other Application Attacks"
                    },
                    "signatureType": "request",
                    "riskFilter": "eq",
                    "riskValue": "high",
                    "accuracyFilter": "le",
                    "accuracyValue": "high"
                }
            }
        }
    ]
}
```

The `riskFilter` parameter can have one of the following values:

- `eq` - Include values equal to.
- `le` - Include values less than or equal.
- `ge` - Include values greater than or equal.
- `all` - Use all items: don't filter anything.

The default value is `all`, and when used, there is no need to add the `riskValue` parameter.

The previous example's user-defined signature set (_my-low-accuracy-signatures_) includes all the signatures with risk equal to "high" and all signatures with accuracy equal to or less than medium. 

The resulting policy should include all low and medium accuracy signatures that have a high risk value.

The next example shows how signatures can be added to a user-defined signature set using their IDs:

```json
{
    "name": "manual_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-cherry-picked-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "manual",
                "signatures": [
                    {
                        "signatureId": 200003360
                    },
                    {
                        "signatureId": 200001234
                    }
                ]
            }
        }
    ]
}
```

If a new signature set name matches an existing signature set name, it will not overwrite the set name. It will instead create a new set, appending the name with an incremental number, such as "\_2".

For example, if an existing signature set ("_My_custom_signatures_") with three signatures has an extra signature attached, when the NGINX process is reloaded, a new signature set will be will be created ("_My_custom_signatures_2_"), containing the new list of four signatures. The previous signature set will remain. 

## Signatures

User-defined signatures can be configured similarly to pre-defined signatures and categorized in user-defined signature sets (With tags) for ease of management.

Creating and using policies containing user-defined signatures is possible with the following process:

- Create the user-defined signature definitions in separate JSON files.
- Add the relevant references (names, tags, signature sets) to the user-defined signatures in a policy JSON file.
- Compile apolicy bundle using [F5 WAF for NGINX Compiler]({{< ref "/waf/configure/compiler.md" >}})
- Reference the user-defined JSON files in [global settings]({{< ref "/waf/configure/compiler.md#global-settings" >}}).

User-defined signatures are managed with a JSON file, where each signature is defined with their properties and tags.

The format of the user-defined signature file is as follows:

```json
{
    "tag": "<tag-name>",
    "revisionDatetime": "2020-01-21T18:32:02Z",
    "signatures": []
}
```

Signatures can be uniquely identified with a combination of name and tag.

The _\<tag-name\>_ value is a placeholder for the tag name, which is assigned to all signatures in the file or group. The `revisionDatetime` value specifies the date or version of the signature file.

Tags are useful for organising user-defined signatures in a bundle, such as grouping signatures by author, shared purpose or set of applications they will be used to protect. They also create namespaces that avoid name conflicts with other user-defined signatures. 

As long as each user-defined signature has a unique name and tag across all files, you can create as many user-defined signature files as necessary.

To add user-defined signatures to a signatures list, each signature must have the following format:

```json
{
    "name": "unique_name",
    "description": "Add your description here",
    "rule": "content:\"string\"; nocase;",
    "signatureType": "request",
    "attackType": {
        "name": "Buffer Overflow"
    },
    "systems": [
        {
            "name": "Microsoft Windows"
        },
        {
            "name": "Unix/Linux"
        }
    ],
    "risk": "medium",
    "accuracy": "medium"
}
```

This table explains the parameters of the signature definition:

| Parameter       | Description |
| --------------- | ----------- |
|  `name`         | A unique name for the user-defined signature |
| `description`   | An optional description to describe the functionality or purpose of the signature | 
| `rule`          | The enforcement rule for the signatures, using [Snort Syntax](https://techdocs.f5.com/kb/en-us/products/big-ip_asm/manuals/product/asm-bot-and-attack-signatures-13-0-0/7.html#guid-797a0c69-a859-45cd-be11-fd0e1a975780): a keyword to look for in a certain context, such as URL, header, parameter, content, and optionally one or more regular expressions |
| `signatureType` | Defines if the signature should be detected as part of a request or response |
| `attackType`    | An indicator of the attack type the signature is intended to prevent: mostly useful for signature set enforcement and logging purposes |
| `systems`       | A list of systems (operating systems, programming languages, etc.) that the signature applies to. Has the same meaning and use as [server technologies]{{< ref "/waf/policies/server-technology-signatures.md" >}} | 
| `risk`          | The risk level associated with the signature, which can be low, medium, or high. |
| `accuracy`      | The accuracy level of the signature, which can be low, medium, or high.  The value of this field contributes to the [violation rating]({{< ref "/waf/policies/violations.md" >}}). |

The following is an example of a user-defined signature definition file, named `user_defined_signature_definitions.json`:

```json
{
    "softwareVersion": "15.1.0",
    "tag": "Fruits",
    "revisionDatetime": "2020-01-22T18:32:02Z",
    "signatures": [
        {
            "name": "Apple_medium_acc",
            "rule": "content:\"apple\"; nocase;",
            "signatureType": "request",
            "attackType": {
                "name": "Buffer Overflow"
            },
            "systems": [
                {
                    "name": "Microsoft Windows"
                },
                {
                    "name": "Unix/Linux"
                }
            ],
            "risk": "medium",
            "accuracy": "medium",
            "description": "Medium accuracy user defined signature with tag (Fruits)"
        }
    ]
}
```

## Policy usage

Once a user-defined signature has been defined in a file, they can be activated and configured in a policy.

To do this, they must be referedn in a policy file, configuring the action to take once matched.

The following policy shows a simplified policy file example called `user_defined_signatures_policy.json`:

```json
{
    "policy": {
        "name": "user_defined_single_signature",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-requirements": [
            {
                "tag": "Fruits",
                "minRevisionDatetime": "2020-01-20T18:32:02Z",
                "maxRevisionDatetime": "2020-01-23T18:32:02Z"
            }
        ],
        "signatures": [
            {
                "name": "Apple_medium_acc",
                "tag": "Fruits"
            }
        ],
        "signature-sets": [
            {
                "name": "Fruit_signature_set",
                "block": true,
                "alarm": true,
                "signatureSet": {
                    "filter": {
                        "tagValue": "Fruits",
                        "tagFilter": "eq"
                    }
                }
            }
        ]
    }
}
```

These are the policy parameters relevant to user-defined signatures:

- `signature-requirements` - Specifies which tags are being used in this policy, and which revision/version (`minRevisionDatetime` and `maxRevisionDatetime` are optional). The signature requirements serve as an indication of what tags and revisions are required for the proper operation of the policy. If the requirement is met and the tag exists, this means that the signature import was successful, and that the policy compilation process will pass. However, if the tag/revision requirement is specified and no such tag or revision exists, then the policy compilation process will fail. This could be caused by importing a wrong or missing definitions file, or a different revision than the one required.
- `signatures` - The list of signatures to add to the policy, using their unique names and tags. This section is only necessary if disabling specific signatures. Each signature should have the `enabled:` with `true` or `false` specified, though a better way to disable signatures is by removing them from the definitions file altogether.
- `signature-sets` - How the signatures are added to the policy enforcement. The set filters the signatures by tag and adds all the signatures matching this tag to the user-defined signature set. This is where the action when a signature is matched (whether to alarm, block, or both) is defined.

For more information on configuring policies, see the [Configure policies]({{< ref "/waf/policies/configuration.md" >}}) topic.