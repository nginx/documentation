---
nd-docs: "DOCS-1564"
---

The policy JSON file specifies the settings that are different from the base template, such as enabling more signatures, disabling some violations, adding server technologies, etc. These will be shown in the next sections.

There are two ways to tune those settings:
- Within the `policy` structure property, the organic structure of the policy.
- Within the `modifications` structure property that contains a list of changes expressed in a generic manner.

Both options are equivalent in their semantic expression power, but different syntactically and are designated for different use cases. But before that, let's look at an example - disabling a specific attack signature.

Signature 200001834 disabled in the `policy` property:

```json
{
    "policy": {
        "name": "signature_exclude_1",
        "signatures": [
            {
                "signatureId": 200001834,
                "enabled": false
            }
        ]
    }
}
```

As you can see, this is expressed using the `signatures` property that contains configuration of individual signatures in a policy. If you want to modify other parts of the policy, you would use different JSON properties.

The same configuration in the `modifications` array looks like this:

```json
{
    "policy": {
        "name": "signature_exclude_2"
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

Note the generic schema that can express manipulation in any policy element: `entity`, `entityType`, `action` etc. The `modifications` array is a flat list of individual changes applied to the policy after evaluating the `policy` block.

So when to use `policy` and when to use `modifications`? There are some recommended practice guidelines for that:
- Use `policy` to express the security policy as you intended it to be: the features you want to enable, disable, the signature sets, server technologies and other related configuration attributes. This part of the policy is usually determined when the application is deployed and changes at a relatively slow pace.
- Use `modifications` to express **exceptions** to the intended policy. These exceptions are usually the result of fixing false positive incidents and failures in tests applied to those policies. Usually these are granular modifications, typically disabling checks of individual signatures, metacharacters and sub-violations. These changes are more frequent.
- Use `modifications` also for **removing** individual collection elements from the base template, for example disallowed file types.

It is a good practice to separate the `modifications` to a different file and have the main policy file reference the former, as the two parts have different lifecycles.

The sections just below review the common policy feature configurations using examples. For the full reference of the `policy` JSON properties see the Declarative Policy guide.

#### Policy Enforcement Modes

A policy's enforcement mode can be:

- **Blocking:** Any illegal or suspicious requests are logged and blocked.  This is the default enforcement mode for the default policy and any added policy unless changed to Transparent.
- **Transparent:** Any illegal or suspicious requests are logged but not blocked.

Specific security features can be defined as blocked or transparent in the policy.

Blocking Mode example:

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    }
}
```

Transparent Mode example:

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "transparent"
    }
}
```

#### Enabling Violations

 Adding and enabling additional security features to the policy can be done by specifying the violation name and the `alarm` block state to "true". To set different states to sub-violations within the violation, enable the violation first, then specifying and enable the sub-violations. Also, a violation may have its own section that provides additional configuration granularity for a specific violation/sub-violation.

{{< note >}}
The attack signature violation `VIOL_ATTACK_SIGNATURE` cannot be configured by the user. Rather, the violation is determined by the combination of the [signature sets](#signature-sets) on the policy.
{{< /note >}}

 The examples below show how to enable a violation and sub-violation in a declarative format.

##### Configuration Details Example

 In this example, we enable 2 violations: `VIOL_JSON_FORMAT` and `VIOL_PARAMETER_VALUE_METACHAR`.

Note that the example defines the blocking and alarm setting for each violation. These settings override the default configuration set above in the `enforcementMode` directive.  Be aware, however, that in a transparent policy no violations are blocked, even if specific violations are set to **block: true** in the configuration.

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_JSON_FORMAT",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": false,
                    "block": false
                }
            ]
        }
    }
}
```

#### HTTP Compliance

HTTP compliance is one of the basic application security violations. It validates the request itself and also prevents the use of the HTTP protocol as an entry point to the application.

In this example, we enable the HTTP compliance violation with the blocking as true. We also configure (enabled or disabled) all of its sub-violations in the relevant HTTP section.  Note that you can add/remove sub-violations to match your desired configurations. However, not listing a violation does not mean it will be disabled.  Rather, it would actually mean that the default configuration would not be overridden for that specific sub-violation.

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_PROTOCOL",
                    "alarm": true,
                    "block": true
                }
            ],
            "http-protocols": [
                {
                    "description": "Header name with no header value",
                    "enabled": true
                },
                {
                    "description": "Chunked request with Content-Length header",
                    "enabled": true
                },
                {
                    "description": "Check maximum number of parameters",
                    "enabled": true,
                    "maxParams": 5
                },
                {
                    "description": "Check maximum number of headers",
                    "enabled": true,
                    "maxHeaders": 20
                },
                {
                    "description": "Body in GET or HEAD requests",
                    "enabled": true
                },
                {
                    "description": "Bad multipart/form-data request parsing",
                    "enabled": true
                },
                {
                    "description": "Bad multipart parameters parsing",
                    "enabled": true
                },
                {
                    "description": "Unescaped space in URL",
                    "enabled": true
                }
            ]
        }
    }
}
```

#### RFC Checks on the Referer Header

This feature introduces RFC checks on the URL referer header.

If a request contains a referer header with a URL that doesn't comply with RFC standards as per RFC-3986, it will trigger the `VIOL_HTTP_PROTOCOL` violation along with its associated sub-violations. If this violation is reported, the user should inspect both the request and referer URLs to identify and address the underlying issue.

For example, in the below URL in Referer header in "Example 1" there is NULL used in Referer value and in "Example 2" unescaped space is used. Since these requests are non-RFC compliant, it will trigger the `VIOL_HTTP_PROTOCOL` violation.

```
Example 1
...  Referer: http://example.com/hello%2500world\r\n
```

```
Example 2
...  Referer: http://example.com/hello world\r\n
```

#### Evasion Techniques

Evasion techniques refers to techniques usually used by hackers to attempt to access resources or evade what would otherwise be identified as an attack. Like HTTP compliance, evasion techniques have a list of sub-violations that can be configured for additional granularity and to reduce false positives.

In this example, we enable the evasion technique violation with the blocking as true. We also configure (enabled or disabled) all of its sub-violations in the relevant section. Note that you can add/remove sub-violations to match your desired configurations. However, not listing a violation does not mean it will be disabled.  Rather, it would actually mean that the default configuration would not be overridden for that specific sub-violation.

```json
{
    "policy": {
        "name": "evasions_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_EVASION",
                    "alarm": true,
                    "block": true
                }
            ],
            "evasions": [
                {
                    "description": "Bad unescape",
                    "enabled": true
                },
                {
                    "description": "Directory traversals",
                    "enabled": true
                },
                {
                    "description": "Bare byte decoding",
                    "enabled": true
                },
                {
                    "description": "Apache whitespace",
                    "enabled": true
                },
                {
                    "description": "Multiple decoding",
                    "enabled": true,
                    "maxDecodingPasses": 2
                },
                {
                    "description": "IIS Unicode codepoints",
                    "enabled": true
                },
                {
                    "description": "IIS backslashes",
                    "enabled": true
                },
                {
                    "description": "%u decoding",
                    "enabled": true
                }
            ]
        }
    }
}
```

#### User-defined HTTP Headers

HTTP header enforcement refers to the handling of the headers section as a special part of the request. These header elements are parsed and enforced based on header specific criteria. However, it is important to distinguish between 2 distinct types of enforcement for HTTP headers:

* The first type of header enforcement is global enforcement for all header content, regardless of the header field name or value. This type of enforcement enables/disables violations that are effective for all contents of the header section of the request. Examples of this are `VIOL_HEADER_LENGTH` and `VIOL_HEADER_METACHAR`. These violations can be configured in the `blocking-settings` section under the `violations` list in the declarative policy.
* The second type of header enforcement is the ability to configure certain violations that are relevant only to specific header fields. Examples of this are allowing repeated instances of the same header field and enabling/disabling Attack Signature checks for an HTTP header field. These violations are configured in the `headers` section where we configure each HTTP header element separately as an object in the list. Additionally, the corresponding violations need to be enabled in the `blocking-settings` section under the `violations` list for them to be enforced.

As far as the header field enforcement is concerned, the following violations are enabled by default:
* `VIOL_HEADER_REPEATED` (in Block mode)
* `VIOL_MANDATORY_HEADER` (in Alarm mode)

There are 3 additional violations that are part of the header enforcement but are specific to the Cookie header alone:
* `VIOL_COOKIE_LENGTH` (in Alarm mode)
* `VIOL_COOKIE_MALFORMED` (in Block mode)
* `VIOL_COOKIE_MODIFIED` (in Alarm mode)

In the base template, there are 4 header objects configured by default:
* `* (wildcard)` - This entity represents the default action taken for all the header fields that have not been explicitly defined in the headers section.
* `Cookie` - This entity handles the `Cookie` header field; this object is just a placeholder and does not affect configuration (See the cookie note below).
* `Referer` - This entity handles the `Referer` header field.
* `Authorization` - This entity handles the `Authorization` header field.
* `Transfer-Encoding` - This entity handles the `Transfer-Encoding` header field.

It is important to emphasize that the Cookie header field is a special case because its behavior is determined by and configured in the `cookie` policy entity rather than the `header` entity. The `Cookie` HTTP header entity is only a placeholder in that it is read-only and does not affect the way cookies are enforced. To modify the configuration of the cookie header field behavior, modify the respective `cookie` entity in the declarative policy.

It is possible to customize the policy configuration using different enforcement modes of the above two violations, as well as configuring custom header elements. For example, we can add a new header `Myheader` and exclude this header from attack signature checks. Alternatively, we can specify a mandatory header that should be present in all requests being sent to our application.

Following is an example configuration where we enable Header violations in blocking mode, create a custom header `MyHeader`, and configure this custom header to allow multiple occurrences of the same header, disable checking attack signatures for the header, and mark it as optional (not mandatory):

```json
{
    "policy": {
        "name": "user_headers_blocking_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MANDATORY_HEADER",
                    "block": true
                }
            ]
        },
        "headers": [
            {
                "name": "MyHeader",
                "type": "explicit",
                "decodeValueAsBase64": "disabled",
                "htmlNormalization": false,
                "mandatory": false,
                "allowRepeatedOccurrences": true,
                "checkSignatures": false
            }
        ]
    }
}
```