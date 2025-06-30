---
nd-docs: "DOCS-1618"
---

When configuring handling of parameters, it is a bit different from other configurations we have dealt with earlier, where we enable a violation and configure its details. With parameters, there are a number of independent violations that need to be enabled on their own, as well as a parameter section to define further customization. The full list of parameter violations can be extracted from the above violation list.


```json
{
    "policy": {
        "name": "parameters_blocking",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "checkMetachars": true,
                "parameterLocation": "any",
                "valueType": "auto-detect",
                "metacharsOnParameterValueCheck": true,
                "name": "*",
                "type": "wildcard",
            }
        ]
    }
}
```

In this example we configure allowed meta-characters in parameter name and value.

```json
{
    "policy": {
        "name": "parameters_allowed_metachars",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "checkMetachars": true,
                "sensitiveParameter": false,
                "parameterLocation": "any",
                "valueType": "auto-detect",
                "nameMetacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": true,
                        "metachar": "0x3e"
                    }
                ],
                "metacharsOnParameterValueCheck": true,
                "allowEmptyValue": true,
                "checkMaxValueLength": false,
                "valueMetacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": true,
                        "metachar": "0x3e"
                    }
                ],
                "name": "*",
                "level": "global",
                "allowRepeatedParameterName": true,
                "attackSignaturesCheck": true,
                "signatureOverrides": [],
                "type": "wildcard",
            }
        ]
    }
}
```


In this example, we define a sensitive parameter `mypass` configuration.

```json
{
    "policy": {
        "name": "parameters_sensitive",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": false
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": false
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "sensitive-parameters": [
            {
                "name": "mypass"
            }
        ]
    }
}
```

#### User-Defined URLs

The user-defined URL feature allows the user to configure the URL while supporting the following options:
- Define a protected URL configuration both explicitly and by wildcards.
- Define a per-URL list of allowed/disallowed methods that will override the list defined in the policy level.
- Define a content-type: json/xml/form-data on a user-defined URL.
- Define an Allowed/Disallowed user-defined URL.
- Add a user-defined URL to the Signature/Metacharacters override list.

For `urlContentProfiles` default values, see NGINX App Protect WAF [Declarative Policy guide.]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}})

In this example we configure allowed meta-characters in a user-defined URL:

```json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_URL_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/meta*",
                "protocol": "http",
                "type": "wildcard",
                "metacharsOnUrlCheck": true,
                "metacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": false,
                        "metachar": "0x28"
                    }
                ],
                "wildcardOrder": 2
            }
        ]
    }
}
```

In this example, we disable the detection of a specific signature, `200010093` and enable another one, `200010008`, both in a user-defined URL `/Common/user_defined_URL`. These signature settings take effect only in requests to that URL. In other requests, the signature behavior is determined by the signature sets these signatures belong to. See [Signature Sets](#signature-sets) for more details.

```json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/test*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1,
                "attackSignaturesCheck": true,
                "signatureOverrides": [
                    {
                        "enabled": true,
                        "signatureId": 200010008
                    },
                    {
                        "enabled": false,
                        "signatureId": 200010093
                    }
                ]
            }
        ]
    }
}
```

In this example, we configure Wildcard/Explicit URLs, where the first URL is permitted for all methods, and the second is permitted only for GET:

```json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/test*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1
            },
            {
                "method": "GET",
                "name": "/index.html",
                "protocol": "http",
                "type": "explicit"
            }
        ]
    }
}
```

In this example, we configure json/xml/form-data content types for a specific user-defined URL:

```json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_METHOD",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_JSON_MALFORMED",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_JSON_FORMAT",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_XML_FORMAT",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "json-profiles": [
            {
                "name": "Default",
                "handleJsonValuesAsParameters": false,
                "defenseAttributes": {
                    "maximumTotalLengthOfJSONData": "any",
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumValueLength": "any"
                }
            }
        ],
        "xml-profiles": [
            {
                "name": "Default",
                "defenseAttributes": {
                    "maximumAttributesPerElement": "any",
                    "maximumDocumentDepth": "any",
                    "maximumAttributeValueLength": "any",
                    "maximumChildrenPerElement": "any",
                    "maximumDocumentSize": "any",
                    "maximumElements": "any",
                    "maximumNameLength": "any",
                    "maximumNSDeclarations": "any",
                    "maximumNamespaceLength": "any",
                    "tolerateLeadingWhiteSpace": true,
                    "tolerateCloseTagShorthand": true,
                    "allowCDATA": true,
                    "allowExternalReferences": true,
                    "allowProcessingInstructions": true
                }
            }
        ],
        "urls": [
            {
                "method": "*",
                "name": "/first*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1,
                "urlContentProfiles": [
                    {
                        "headerValue": "*",
                        "headerName": "*",
                        "headerOrder": "3",
                        "type": "form-data"
                    },
                    {
                        "contentProfile": {
                            "name": "Default"
                        },
                        "headerValue": "*xml*",
                        "headerName": "Content-Type",
                        "headerOrder": "2",
                        "type": "xml"
                    },
                    {
                        "contentProfile": {
                            "name": "Default"
                        },
                        "headerValue": "*json*",
                        "headerName": "Content-Type",
                        "headerOrder": "1",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
```