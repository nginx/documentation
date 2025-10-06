---
# We use sentence case and present imperative tone
title: "User-defined URLs and parameters"
# Weights are assigned in increments of 100: determines sorting order
weight: 2150
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes the user-defined URLs and parameters feature of F5 WAF for NGINX.

## URLs

User-defined URLs allows you to configure a URL with the following options:
- Define a protected URL configuration with an explicitly path or implicit wildcard
- Define a list of allowed/disallowed methods per URL that will override the list defined in the policy level.
- Define the content-types `json/xml/form-data` for a user-defined URL.
- Define an Allowed/Disallowed for user-defined URL.
- Add user-defined URLs to the Signature/Metacharacters override list.

For `urlContentProfiles` default values, see F5 WAF for NGINX [Declarative Policy guide.]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}})

This example configures allowed meta-characters for a user-defined URL:

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

This next example disables the detection of a specific signature (`200010093`) and enables another (`200010008`) for the user-defined URL `/Common/user_defined_URL`. 

These signature settings take effect only in requests to that URL. 

For other requests, the signature behavior is determined by the signature sets these signatures belong to. View [signature sets]({{< ref "/waf/policies/attack-signatures.md#signature-sets" >}}) for more details.

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

This example shows wildcard and explicit URL configuration, where the first URL is permitted for all methods, and the second is permitted only for GET:

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

This final example shows how to configure json/xml/form-data content types for a specific user-defined URL:

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

## Parameters

User-defined parameters allow you to give specific attributes to specific parameters.

This feature gives you full control over what the parameter should include and where it should be located, allowing for granularity to configure every parameter. 

With user-defined parameters you can::

- Create unique parameters and specify attributes for each
- Define what data type the parameter should contain
- Define the allowed location where you expect to see a parameter
- Define minimum/maximum values and minimum/maximum lengths for a parameter
- Define whether a parameter is mandatory or not
- Define whether the parameter can have empty values or not
- Define whether to inspect a parameter for violations, attack signatures, or meta-characters
- Decide whether to exclude certain violations, attack signatures, or meta-characters for a parameter

The following example has two user-defined parameters. 

The first one, `text`, takes string values (here configured as alpha-numeric), and limits the length of the allowed string between 4 and 8 characters. Any string below or above these values will trigger the violation `VIOL_PARAMETER_VALUE_LENGTH`. Note that we enable this violation to *block* the violating request.

The second parameter, `query`, is added to the policy just to avoid a false positive condition due to a specific signature, `200002835`.

This allows you to create exceptions on known false positives _only_ within the context of a specific parameter. The signature will still be detected on values of other parameters.

```json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "text",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "checkMinValueLength": true,
                "checkMaxValueLength": true,
                "minimumLength": 4,
                "maximumLength": 8
            },
            {
                "name": "query",
                "type": "explicit",
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "signatureOverrides": [
                    {
                        "enabled": false,
                        "signatureId": 200002835
                    }
                ]
            }
        ]
    }
}
```

This next example uses a  numeric parameter which accepts only integer values and allows values between 9 and 99 (non-inclusive). 

If the request includes anything other than an integer, it will trigger the `VIOL_PARAMETER_DATA_TYPE` violation. 

If the parameter value falls beyond or below the desired values, it will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation. 

If you change the values of `exclusiveMin` and `exclusiveMax` to false, values equal to the boundary values will be accepted (namely 9 and 99).

```json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "number",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "integer",
                "checkMinValue": true,
                "checkMaxValue": true,
                "minimumValue": 9,
                "maximumValue": 99,
                "exclusiveMin": true,
                "exclusiveMax": true
            }
        ]
    }
}
```

For increased granularity, you can configure whether the parameter value is also a multiple of a specific number. 

This is useful when you wish to limit the input to specific values. 

The following example configures a parameter that accepts values in the range of 0 to 10 and are only multiples of 3. 

This means that the accepted values are 3, 6 and 9. Any other value will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation.

```json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "multiples",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "integer",
                "checkMinValue": true,
                "checkMaxValue": true,
                "minimumValue": 0,
                "maximumValue": 10,
                "checkMultipleOfValue": true,
                "multipleOf": 3
            }
        ]
    }
}
```

Another useful example is limiting the parameter to a single context, such as in a header or a query string. 

If the same variable appears in a different location, it will trigger the `VIOL_PARAMETER_LOCATION` violation.

```json
{
    "policy": {
        "name": "user_defined_parameters_misc_test",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_LOCATION",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "headerparam",
                "type": "explicit",
                "parameterLocation": "header",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "checkMinValueLength": false,
                "checkMaxValueLength": false
            }
        ]
    }
}
```

This final example configures:

- A sensitive parameter `mypass` that should be masked in the logs
- A parameter `empty` that is allowed to be empty
- A parameter `repeated` that can be repeated multiple times
- A parameter `mandatory` that is mandatory for all requests

New violations are enabled so that the configuration becomes effective.

```json
{
    "policy": {
        "name": "user_defined_parameters_misc_test",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_EMPTY_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_REPEATED",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_MANDATORY_PARAMETER",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "mypass",
                "type": "explicit",
                "parameterLocation": "any",
                "sensitiveParameter": true,
                "valueType": "auto-detect"
            },
            {
                "name": "empty",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": true,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            },
            {
                "name": "repeated",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": true,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            },
            {
                "name": "mandatory",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": true,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            }
        ]
    }
}
```