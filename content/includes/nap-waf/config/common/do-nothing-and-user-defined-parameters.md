---
nd-docs: "DOCS-1586"
---

The do-nothing in urlContentProfiles allows the user to avoid inspecting or parsing the content in a policy, and instead handle the request's header according to the specifications outlined in the security policy.

In this example, we configure do-nothing content types for a specific user-defined URL:

```json
{
    "policy" : {
        "name": "ignore_body",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "urls": [
            {
                "method": "*",
                "name": "*",
                "type": "wildcard",
                "urlContentProfiles": [
                    {
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "do-nothing"
                    }
                ]
            }
        ]
    }
}
```


#### User-Defined Parameters

So far, we have been managing the default parameter or * entity. What if we want to give specific attributes to specific parameters? This can be done by creating and configuring the user-defined parameters. This feature gives the user full control over what the parameter should include, where it should be located and allows for granularity in configuring each and every parameter. Here you can:

- Create unique parameters and specify attributes for each.
- Define what data type the parameter should contain.
- Define the allowed location where you expect to see a parameter.
- Define minimum/maximum values and minimum/maximum lengths for a parameter.
- Define whether a parameter is mandatory or not.
- Define whether the parameter can have empty values or not.
- Define whether to inspect a parameter for violations, attack signatures, or meta-characters.
- Decide whether to exclude certain violations, attack signatures, or meta-characters for a parameter.

In the following example, we configure two parameters. The first one, `text`, takes string values (here configured as alpha-numeric), and limits the length of the allowed string between 4 and 8 characters. Any string below or above these values will trigger the violation `VIOL_PARAMETER_VALUE_LENGTH`. Note that we enable this violation to *block* the violating request.

The second parameter, `query`, is added to the policy just to avoid a false positive condition due to a specific signature, `200002835`. Suppose you realized that whenever this signature detected on this parameter, it was false positive. You would like to disable this signature, but only in the context of this parameter. The signature will still be detected on values of other parameters.

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

In the next example, we configure a numeric parameter. This parameter accepts only integer values and allows values between 9 and 99 (non-inclusive). If the request includes anything other than an integer, it will trigger the `VIOL_PARAMETER_DATA_TYPE` violation. If the parameter value falls beyond or below the desired values, it will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation. Note that if you change the values of `exclusiveMin` and `exclusiveMax` to false, values equal to the boundary values will be accepted (namely 9 and 99).

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

For increased granularity, you can configure whether the parameter value is also a multiple of a specific number. This is useful when you wish to limit the input to specific values. The following example configures a parameter that accepts values in the range of 0 to 10 and are only multiples of 3. This means that the accepted values are 3, 6 and 9. Any other value will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation.

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

Another very useful example is when the user wants to limit the parameter to a single context, like in a header or a query string. If the same variable appears in a different location, it will trigger the `VIOL_PARAMETER_LOCATION` violation.

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

Another very useful example is the following configuration. It has:
- A sensitive parameter `mypass` that should be masked in the logs.
- A parameter `empty` that is allowed to be empty.
- A parameter `repeated` that can be repeated multiple times.
- A parameter `mandatory` that is mandatory for all requests.

Note that new violations were enabled so that the configuration becomes effective.

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