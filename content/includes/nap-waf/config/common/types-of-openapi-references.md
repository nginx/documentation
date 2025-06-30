---
nd-docs: "DOCS-1636"
---

There are different ways of referencing OpenAPI Specification files. The configuration is similar to [External References](#external-references).

{{< note >}} Any update of an OpenAPI Specification file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration. {{< /note >}}

#### URL Reference

URL reference is the method of referencing an external source by providing its full URL.

Make sure to configure certificates prior to using the HTTPS protocol - see the [HTTPS References](#https-reference) under the External References section for more details.

{{< note >}} You need to make sure that the server where the resource files are located is always available when you are compiling your policy. {{< /note >}}

##### Example Configuration

In this example, we are adding an OpenAPI Specification file reference using the link `http://127.0.0.1:8088/myapi.yaml`. This will configure allowed data types for `query_int` and `query_str` parameters values.

**Policy configuration:**

```json
{
    "policy": {
        "name": "petstore_api_security_policy",
        "description": "NGINX App Protect WAF API Security Policy for the Petstore API",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "open-api-files": [
            {
                "link": "http://127.0.0.1:8088/myapi.yaml"
            }
        ],
        "blocking-settings": {
            "violations": [
                {
                    "block": true,
                    "description": "Disallowed file upload content detected in body",
                    "name": "VIOL_FILE_UPLOAD_IN_BODY"
                },
                {
                    "block": true,
                    "description": "Mandatory request body is missing",
                    "name": "VIOL_MANDATORY_REQUEST_BODY"
                },
                {
                    "block": true,
                    "description": "Illegal parameter location",
                    "name": "VIOL_PARAMETER_LOCATION"
                },
                {
                    "block": true,
                    "description": "Mandatory parameter is missing",
                    "name": "VIOL_MANDATORY_PARAMETER"
                },
                {
                    "block": true,
                    "description": "JSON data does not comply with JSON schema",
                    "name": "VIOL_JSON_SCHEMA"
                },
                {
                    "block": true,
                    "description": "Illegal parameter array value",
                    "name": "VIOL_PARAMETER_ARRAY_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal Base64 value",
                    "name": "VIOL_PARAMETER_VALUE_BASE64"
                },
                {
                    "block": true,
                    "description": "Disallowed file upload content detected",
                    "name": "VIOL_FILE_UPLOAD"
                },
                {
                    "block": true,
                    "description": "Illegal request content type",
                    "name": "VIOL_URL_CONTENT_TYPE"
                },
                {
                    "block": true,
                    "description": "Illegal static parameter value",
                    "name": "VIOL_PARAMETER_STATIC_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal parameter value length",
                    "name": "VIOL_PARAMETER_VALUE_LENGTH"
                },
                {
                    "block": true,
                    "description": "Illegal parameter data type",
                    "name": "VIOL_PARAMETER_DATA_TYPE"
                },
                {
                    "block": true,
                    "description": "Illegal parameter numeric value",
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE"
                },
                {
                    "block": true,
                    "description": "Parameter value does not comply with regular expression",
                    "name": "VIOL_PARAMETER_VALUE_REGEXP"
                },
                {
                    "block": true,
                    "description": "Illegal URL",
                    "name": "VIOL_URL"
                },
                {
                    "block": true,
                    "description": "Illegal parameter",
                    "name": "VIOL_PARAMETER"
                },
                {
                    "block": true,
                    "description": "Illegal empty parameter value",
                    "name": "VIOL_PARAMETER_EMPTY_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal repeated parameter name",
                    "name": "VIOL_PARAMETER_REPEATED"
                }
            ]
        }
    }
}
```

Content of the referenced file `myapi.yaml`:

```yaml
openapi: 3.0.1
info:
  title: 'Primitive data types'
  description: 'Primitive data types.'
  version: '2.5.0'
servers:
  - url: http://localhost
paths:
  /query:
    get:
      tags:
        - query_int_str
      description: query_int_str
      operationId: query_int_str
      parameters:
        - name: query_int
          in: query
          required: false
          allowEmptyValue: false
          schema:
            type: integer
        - name: query_str
          in: query
          required: false
          allowEmptyValue: true
          schema:
            type: string
      responses:
        200:
          description: OK
        404:
          description: NotFound
```

In this case the following request will trigger an `Illegal parameter data type` violation, as we expect to have an integer value in the `query_int` parameter:

```
http://localhost/query?query_int=abc
```

The request will be blocked.

The link option is also available in the `openApiFileReference` property and synonymous with the one above in `open-api-files`

**Note**: `openApiFileReference` is not an array.

##### Example Configuration

In this example, we reference the same OpenAPI Specification file as in the policy above using the `openApiFileReference` property.

**Policy configuration:**

```json
{
    "name": "openapifilereference-yaml",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "openApiFileReference": {
        "link": "http://127.0.0.1:8088/ref.txt"
    }
}
```

Content of the file `ref.txt`:

```json
[
    {
        "link": "http://127.0.0.1:8088/myapi.yaml"
    }
]
```

#### File Reference

File reference refers to accessing local resources on the same machine. See the [File References](#file-reference) under the External References section for more details.

##### Example Configuration

In this example, we would like to add an OpenAPI Specification file reference to the default policy.

**Policy Configuration:**

```json
{
    "name": "openapi-file-reference-json",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "open-api-files": [
        {
            "link": "file:///myapi2.json"
        }
    ]
}
```

Content of the referenced file `myapi2.json`:

```json
{
    "openapi": "3.0.1",
    "info": {
        "title": "Primitive data types2",
        "description": "Primitive data types.",
        "version": "2.5.1"
    },
    "servers": [
        {
            "url": "http://localhost"
        }
    ],
    "paths": {
        "/query": {
            "get": {
                "tags": [
                    "query_bool"
                ],
                "description": "query_bool",
                "operationId": "query_bool",
                "parameters": [
                    {
                        "name": "query_bool",
                        "in": "query",
                        "required": false,
                        "schema": {
                            "type": "boolean"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK"
                    },
                    "404": {
                        "description": "NotFound"
                    }
                }
            }
        }
    }
}
```

In this case the following request will trigger an `Illegal repeated parameter name` violation, as the OpenAPI Specification doesn't allow repeated parameters.

```
http://localhost/query?a=true&a=false
```

The request will not be blocked because this violation is set to alarm in the default policy.