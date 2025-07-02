---
nd-docs: "DOCS-1545"
---

#### XML and JSON Content Profiles

By default every request with a Content-Type header containing XML or JSON is expected to have an XML or JSON body, respectively. Consequently, a series of checks are performed to ensure that the body is indeed well-formed as XML or JSON, and certain restrictions are enforced on the size and content of that body. These restrictions are specified in **XML and JSON profiles**. These configuration structures are associated with URLs and optionally also with Parameters, in case parameters that are known to have XML or JSON values are defined. One of the most powerful restrictions in a JSON profile is enforcing a schema with which the content must comply. This will be detailed in the next section.

The default Base template comes with default JSON and XML profiles, both called "default". They are associated to the * URL based on the values of the Content-Type header as described above. You can use those profiles on other URLs or Parameters in your policies, and you can also create your own custom JSON and XML profiles to customize the checks that you want on your content.

Let's assume you have a JSON registration form under the URL `/register`. It is a small form, and it makes sense to limit its size to 1000 characters and its nesting depth to 2.  Here is a policy that enforces this:

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

The enforcement on the JSON payload is defined in the `reg_form_prof` JSON profile. This profile is attached to the `/register` URL. Note JSON content is always expected for this URL - it applies to all header name and value combinations, and no other content option exists for this URL. Also note that we limited the method to `POST` in this URL. A POST request to this URL with a body that is not well-formed JSON will trigger the `VIOL_JSON_MALFORMED` violation.

If the body of the request is legal JSON, but violates any of the restrictions in the `reg_form_prof` JSON profile, for example has a nesting depth of 3, then you should expect the `VIOL_JSON_FORMAT` violation with details on what exactly was wrong with the JSON payload.

Let's assume that in your JSON registration there is a specific field that should be Base64 encoded.
we can set the value of `handleJsonValuesAsParameters` to `true` on the profile level,
and set the value of `decodeValueAsBase64` to `required` on the parameter level.
Here is a policy that enforces this:

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

{{< note >}}
Defining a JSON or XML profile in a policy has no effect until you assign it to a URL or Parameter you defined in that policy. Profiles can be shared by more than one URL and/or Parameter.
{{< /note >}}

#### Applying a JSON Schema

If a schema for the JSON payload exists, it can be attached to the JSON profile and App Protect will enforce it along with the other restrictions.

Here is a sample JSON schema for a registration form. It contains personal details:

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

Embedding the schema into the `reg_form_prof` JSON profile should be done in the following way:
- Add an object containing the JSON schema to the `json-validation-files` array, which details all the available JSON schema validation files available in the profile. A unique `fileName` should be specified, and the escaped contents of the JSON schema added via the `contents` keyword.
- Associate the specific JSON schema to the `reg_form_prof` JSON profile by adding a `validationFiles` array object and set the `fileName` in the `jsonValidationFile` object to the JSON schema `fileName`.
- All JSON schema files including external references must be added in this way to both the `json-validation-files` array and associated with the JSON profile. The `isPrimary` should be set on the object containing the primary JSON schema.

This yields the following policy:

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

When a request to the `/register` URL is `POST`-ed with JSON content that does not comply with the above schema, the `VIOL_JSON_SCHEMA` violation is triggered. In the default base template, the `alarm` flag is turned on for this violation and if it is triggered, it affects Violation Rating. In addition, you can turn on the `block` flag so that this violation will also block when triggered.

**Notes:**
- The schema file is embedded as a quoted string; therefore you must escape the quotes inside the schema itself.
- We removed the nesting depth check in the JSON profile because it is enforced by the schema. It is not an error to leave the sizing checks together with the schema enforcement, but usually the schema has more accurate restrictions and leaving the profile restriction might be redundant in the best case or cause false positives in the worst.

#### Including an External JSON Schema File

Schema files are often developed as part of the application, independently from the App Protect Policy. It is often desirable to keep it in a separate file and reference it from the policy using a URL. Just as in all externally referenced policy sections, the JSON schema file can reside either in the NGINX file system (the default directory `/etc/app_protect/conf` is assumed if only the filename is specified in the `file:` URL, that is: `file:///my_schema.json` refers to the file located at `/etc/app_protect/conf/my_schema.json`), or on a remote Web server, typically, your source control system.

In this example the file is in the default directory:

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

The schema file is identified by the `filename` property. It is a good practice to keep the `filename` identical to the one on the URL path, but it is not an error to have different names for each.

if you want to reference the file externally, replace the content of the `link` property with an HTTP or HTTPS URL:

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