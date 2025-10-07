---
title: "XML and JSON content"
weight: 2300
toc: true
nd-content-type: reference
nd-product: NAP-WAF
---

This guide explains how to configure XML and JSON content profiles in an F5 WAF for NGINX policy. The examples below use JSON for illustration, but the same concepts apply to XML profiles unless noted otherwise.

### XML and JSON content profiles

By default, any request that includes a `Content-Type` header specifying XML or JSON is expected to carry a corresponding XML or JSON body. The system automatically performs validation to ensure the body is well-formed and applies restrictions on its size and content. These restrictions are defined in **XML and JSON profiles**.

Profiles can be linked to URLs and, optionally, to Parameters when those parameters are known to contain XML or JSON data. JSON profiles in particular offer powerful validation options, such as enforcing compliance with a defined schema; this capability will be covered in the next section.

The **Base template** includes built-in XML and JSON profiles, both named `default`. These profiles are automatically applied to all (`*`) URLs based on the `Content-Type` header. You can reuse these profiles for other URLs or Parameters in your policies, or create **custom profiles** to apply more specific validation rules tailored to your content.

For example, let’s assume you have a JSON registration form under the URL `/register`. It is a small form, and it makes sense to limit its size to 1000 characters and its nesting depth to 2. Here is a policy that enforces this:

```json
{
    "policy": {
        "name": "json_form_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": 2,
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                }
            }
        ],
        "urls": [
            {
                "name": "/register",
                "method": "POST",
                "type": "explicit",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "headerName": "*",
                        "headerValue": "*",
                        "headerOrder": "default",
                        "type": "json",
                        "contentProfile": {
                            "name": "reg_form_prof"
                        }
                    }
                ]
            }
        ]
    }
}
```

In this example, the JSON enforcement is defined in the `reg_form_prof` profile, which is attached to the `/register` URL. JSON content is always expected for this URL—it applies to all header name and value combinations, and no other content type is permitted. The URL is restricted to the `POST` method only.

If a `POST` request to `/register` includes a body that is not well-formed JSON, it triggers the **VIOL_JSON_MALFORMED** violation.

If the body is valid JSON but violates profile restrictions (for example, nesting depth of 3), it triggers the **VIOL_JSON_FORMAT** violation with details about the specific issue.

Now, let’s assume that your JSON registration form contains a specific field that must be Base64-encoded. In that case, you can set the `handleJsonValuesAsParameters` option to `true` at the profile level and configure the parameter with `decodeValueAsBase64` set to `required`. This enforces that the parameter value must always be valid Base64.

```json
{
    "policy": {
        "name": "json_parse_param_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_BASE64",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "*",
                "type": "wildcard",
                "parameterLocation": "any",
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "decodeValueAsBase64": "required"
            }
        ],
        "json-profiles": [
            {
                "name": "Default",
                "defenseAttributes": {
                    "tolerateJSONParsingWarnings": true
                },
                "handleJsonValuesAsParameters": true,
                "validationFiles": []
            }
        ]
    }
}
```

{{< call-out "note" >}}
Defining a JSON or XML profile in a policy has no effect until you assign it to a URL or Parameter you defined in that policy. Profiles can be shared by more than one URL and/or Parameter.
{{< /call-out >}}

### Applying a JSON schema

If a schema for the JSON payload exists, you can attach it to the JSON profile. F5 WAF for NGINX will then enforce the schema rules in addition to the other restrictions defined in the profile.

Here is an example JSON schema for a registration form, which includes basic personal details:

```json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "Person",
    "type": "object",
    "additionalProperties": false,
    "properties": {
        "firstName": {
            "type": "string",
            "description": "The person's first name."
        },
        "lastName": {
            "type": "string",
            "description": "The person's last name."
        },
        "age": {
            "description": "Age in years which must be equal to or greater than zero.",
            "type": "integer",
            "minimum": 0
        }
    }
}
```

Embedding the schema into the `reg_form_prof` JSON profile should be done as follows:

- Add an object containing the JSON schema to the `json-validation-files` array. This array lists all JSON schema validation files available in the profile. A unique `fileName` must be specified, and the escaped contents of the JSON schema provided using the `contents` keyword.
- Associate the JSON schema with the `reg_form_prof` profile by adding a `validationFiles` array object, setting the `fileName` in the `jsonValidationFile` object to match the schema fileName.
- All JSON schema files, including external references, must be added to the `json-validation-files` array and linked to the JSON profile. The `isPrimary` flag should be set on the object containing the primary JSON schema.

This produces the following policy:

```json
{
    "policy": {
        "name": "json_form_policy_inline_schema",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-validation-files": [
            {
                "fileName": "person_schema.json",
                "contents": "{\r\n \"$schema\": \"http://json-schema.org/draft-07/schema#\",\r\n \"title\": \"Person\",\r\n \"type\": \"object\",\r\n \"properties\": {\r\n \"firstName\": {\r\n \"type\": \"string\",\r\n \"description\": \"The person's first name.\"\r\n },\r\n \"lastName\": {\r\n \"type\": \"string\",\r\n \"description\": \"The person's last name.\"\r\n },\r\n \"age\": {\r\n \"description\": \"Age in years which must be equal to or greater than zero.\",\r\n \"type\": \"integer\",\r\n \"minimum\": 0\r\n }\r\n }\r\n}"
            }
        ],
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                },
                "validationFiles": [
                    {
                        "isPrimary": true,
                        "jsonValidationFile": {
                            "fileName": "person_schema.json"
                        }
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/register",
                "type": "explicit",
                "method": "POST",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "reg_form_prof"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
```

When a request to the `/register` URL is sent with JSON content that does not comply with the schema, the **VIOL_JSON_SCHEMA** violation is triggered. In the default base template, the `alarm` flag is enabled for this violation, meaning it contributes to the Violation Rating when triggered. You can also enable the `block` flag so that the request is blocked whenever this violation occurs.

{{< call-out "note" >}}
- The schema file is embedded as a quoted string, so all quotes inside the schema itself must be escaped.
- The nesting depth check was removed from the JSON profile because it is already enforced by the schema. Keeping both checks is not technically incorrect, but in practice the schema usually provides more precise restrictions. Leaving the profile restriction may be redundant at best or cause false positives at worst.
{{< /call-out >}}

### Including an external JSON schema file

Schema files are often developed as part of the application, independently from the F5 WAF for NGINX policy. It is usually preferable to keep them in separate files and reference them from the policy using a URL. As with all externally referenced policy sections, the JSON schema file can either reside in the NGINX file system (by default, `/etc/app_protect/conf` is assumed if only the filename is specified in the `file:` URL, for example `file:///my_schema.json` refers to `/etc/app_protect/conf/my_schema.json`), or on a remote web server such as your source control system.

In this example, the file is located in the default directory:

```json
{
    "policy": {
        "name": "json_form_policy_external_schema",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-validation-files": [
            {
                "fileName": "person_schema.json",
                "link": "file://person_schema.json"
            }
        ],
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                },
                "validationFiles": [
                    {
                        "isPrimary": true,
                        "jsonValidationFile": {
                            "fileName": "person_schema.json"
                        }
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/register",
                "type": "explicit",
                "method": "POST",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "reg_form_prof"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
```

The schema file is identified by the `filename` property. It is good practice to keep the filename identical to the one in the URL path, but it is not an error if they differ.

If you want to reference the file externally, replace the content of the `link` property with an HTTP or HTTPS URL:

```json
{
    "json-validation-files": [
        {
            "fileName": "person_schema.json",
            "link": "https://git.mydomain.com/my_app/person_schema.json"
        }
    ]
}
```