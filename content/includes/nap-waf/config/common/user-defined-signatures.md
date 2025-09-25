---
nd-docs: "DOCS-1603"
---

Another useful expansion to the customization capabilities is the ability to create user-defined signatures. This capability allows the user to define new signatures, configure how they behave in terms of enforcement, and categorize them in user-defined signature sets (using tags) for ease of management.

The process of creating and implementing a user policy that contains user-defined signatures is a three-fold process:

- Creating the user-defined signature definitions in separate JSON files.
- Adding the relevant references (names, tags, signature sets) to the user-defined signatures in a policy JSON file.
- Referencing user-defined JSON files in a [global settings]({{< ref "/nap-waf/v5/admin-guide/compiler.md#global-settings" >}}) file.
- Compiling a policy bundle using [F5 WAF for NGINX Compiler]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}})

##### User-Defined Signature Definitions

The user-defined signature definition file is a JSON file where the signatures themselves are defined and given their properties and tags. The format of the user-defined signature definition is as follows:

```json
{
    "tag": "tag_name",
    "revisionDatetime": "2020-01-21T18:32:02Z",
    "signatures": []
}
```

Tags help organizing the user-defined signatures in bundles so that all signatures in that bundle are (usually) authored by the same person and share a common purpose or set of applications that will consume it. It also creates name spaces that avoid name conflicts among user-defined signatures. Signatures are uniquely identified by the combination of tag and name. The `tag_name` should be replaced with the tag name to be assigned to all signatures in this file or group. The `revisionDatetime` specifies the date or version of the signature file. Note that you can create as many user-defined signature definition files as you wish provided that you assign a unique tag for each file and that the user-defined signatures have unique names, both within the same file, or across different files.

To add user-defined signatures to the signatures list, each signature must have the following format:

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

Here is a brief explanation about each of the above items in the signature definition:

- `name` - is the unique name to be given to the user-defined signature.
- `description` - is an optional item where you can add a human-readable text to describe the functionality or purpose of the signature.
- `rule` - is the rule by which the enforcement will be done. The rule uses Snort syntax: a keyword to look for in a certain context, such as URL, header, parameter, content, and optionally one or more regular expressions. For full details on how to create a rule and the possible permutations, check the [Rule Syntax](https://techdocs.f5.com/kb/en-us/products/big-ip_asm/manuals/product/asm-bot-and-attack-signatures-13-0-0/7.html#guid-797a0c69-a859-45cd-be11-fd0e1a975780) page.
- `signatureType` - defines whether the signature is relevant to the request or the response.
- `attackType` - this field gives an indication of the attack type the signature is intended to prevent. This field is mostly useful for signature set enforcement and logging purposes. A full list of the available attack types can be found in the [Attack Types](#attack-types) section.
- `systems` - is a list of systems (operating systems, programming languages, etc.) that the signature should be applicable for. Note that `systems` have the same meaning and use as `server technologies` although the overlap between both terms is not perfect. This is explained in the above section [Server Technologies](#server-technologies).
- `risk` - defines the risk level associated with this signature. Possible values are: low, medium, high.
- `accuracy` - defines the accuracy level of the signature. Note that the value of this field contributes to the value of the [Violation Rating](#violations). Possible values are: low, medium, high.

The following is an example of a user-defined signature definition file called `user_defined_signature_definitions.json`:

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

##### Updating the Policy

Once all the user-defined signatures are added to definitions files, it is time to activate and use them in the policy. To achieve this, certain items need to be added to the policy file to enable these signatures, and to specify the action to take when they are matched. The following policy shows a simplified policy file example called `user_defined_signatures_policy.json`:

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

Following is an explanation of each of the items added to the bare policy that are relevant to user-defined signatures:

- `signature-requirements` - Specifies which tags are being used in this policy, and from which revision/version (`minRevisionDatetime` and `maxRevisionDatetime` are optional). The signature requirements serve as an indication of what tags and revisions are required for the proper operation of the policy. If the requirement is met and the tag exists, this means that the signature import was successful, and that the policy compilation process will pass. However, if the tag/revision requirement is specified and no such tag or revision exists, then the policy compilation process will fail. This could mean that the user imported the wrong definitions file, imported a different revision than the one we require, or even forgot to import the definitions file altogether.
- `signatures` - The list of signatures we want to add to the policy. Note that each signature should have its unique name added as well as its relevant tag. The signature will then be automatically enabled. This section is redundant if the user wants to enable all signatures. However, if they want to disable specific signature(s), this section becomes mandatory where each signature should have the `enabled:` with `true` or `false` specified. A better way to disable signatures is by removing them from the definitions file altogether and reloading the policy.
- `signature-sets` - How the signatures are added to the policy enforcement. The set filters the signatures by tag and adds all the signatures matching this tag to the user-defined signature set. Here we can specify the action taken when a signature match is made (whether to alarm, block, or both)
