---
# We use sentence case and present imperative tone
title: "External references"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes the external references feature for F5 WAF for NGINX.

External references in policy are code blocks that can be used as part of a policy without being part of the policy file.  This means that you can have a set of pre-defined configurations for parts of the policy, and you can incorporate them as part of the policy by simply referencing them. 

It allows you to separate policy information into smaller files, which can be easier to maintain for a large, complex policy. Another use case for external references is to build a dynamic policy that requires replaceable files. 

You can create and populate specific files with the configuration relevant to your policy, and then compile the policy to include the latest version of these files, ensuring that your policy is always up to date when it comes to a constantly changing environment.

{{< call-out "note" >}}

Updating a single file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration.

{{< /call-out >}}

To use external references, replaced the direct property in the policy file with the _\<ext-ref\>Reference_ property, where _\<ext-ref\>_ defines the replacement text for the property changed to singular (if originally plural) and notation converted from snake case to camelCase. 

For example, a `modifications` section could be replaced by `modificationsReference` and `data-guard` would could be replaced by `dataGuardReference`.

## External reference types

There are different implementations based on the type of references that are being made.

### External URL reference

URL reference is the method of referencing an external source by providing its full URL. 

This is a useful method when trying to combine or consolidate parts of the policy that are present on different host machines.

{{< call-out "note" >}} 

You need to make sure that the server where the resource files are located is always available when you are compiling your policy.
{{< /call-out >}}

This example creates a skeleton policy, enabling the file type violation. 

It does not specify the file types as these file types depend on a separate application that defines these types. It populates this section from an external reference instead.

Note that the `filetypes` section is replaced by the `filetypeReference` section. In the `filetypeReference` section, there is  **key/value** pair defining the type of reference and actual URL to use to reach that reference item.

For the content of the file itself, it is an extension of the original JSON format for the policy.

```json
{
    "name": "external_resources_file_types",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "blocking-settings": {
        "violations": [
            {
                "name": "VIOL_FILETYPE",
                "alarm": true,
                "block": true
            }
        ]
    },
    "filetypeReference": {
        "link": "http://domain.com:8081/file-types.txt"
    }
}
```

The referenced `file-types.txt` file contains the following code:

```json
[
    {
        "name": "*",
        "type": "wildcard",
        "allowed": true,
        "checkPostDataLength": false,
        "postDataLength": 4096,
        "checkRequestLength": false,
        "requestLength": 8192,
        "checkUrlLength": true,
        "urlLength": 2048,
        "checkQueryStringLength": true,
        "queryStringLength": 2048,
        "responseCheck": false
    },
    {
        "name": "pat",
        "allowed": false
    },
    {
        "name": "mat",
        "allowed": false
    }
]
```

### HTTPS references

HTTPS references are a special case of URL references. It uses the HTTPS protocol instead of the HTTP protocol. Make sure that the webserver you are downloading the resources from does also support HTTPS protocol and has certificates setup properly.

- Certificates must be valid in date (not expired) during the policy compilation.
- Certificates must be signed by a trusted CA.
- For Self-signed certificates, you need to make sure to add your certificates to the trusted CA of the machine where App Protect is installed.
- Certificates must use the exact domain name that the certificate was issued for. For example, SSL will differentiate between domain.com and www.domain.com, considering each a different domain name.

In this configuration, we are completely satisfied with the basic default policy, and we wish to use it as is. However, we wish to define a custom response page using an external file located on an HTTPS web server. The external reference file contains our custom response page configuration.

**Policy configuration:**

```json
{
    "name": "external_references_custom_respsonse",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "responsePageReference": {
        "link": "https://securedomain.com:8081/response-pages.txt"
    }
}
```

Content of the referenced file `response-pages.txt`:

```json
[
    {
        "responseContent": "<html><head><title>Custom Reject Page</title></head><body>This is a custom response page, it is supposed to overwrite the default page with custom text.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
        "responseHeader": "HTTP/1.1 200 OK\r\nCache-Control: no-cache\r\nPragma: no-cache\r\nConnection: close",
        "responseActionType": "custom",
        "responsePageType": "default"
    }
]
```

In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced.

**Policy configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
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
    "modificationsReference": {
        "link": "http://my-domain.com:8081/modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

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
        }
    ]
}
```

### File references

File references refers to accessing local resources on the same machine, as opposed to accessing a remote resource on another server/machine. The user can specify any location that is accessible by App Protect except for the root folder ("/"). If no full path is provided, the default path `/etc/app_protect/conf` will be assumed. Note that file references can only be on the local machine: you cannot use remote hosts!

Here are some examples of the typical cases:

| Examples | File path | Notes |
| -------- | --------- | ----- |
|<file:///foo.json> | /etc/app_protect/conf/foo.json | Default directory assumed |
|<file://foo.json> | /etc/app_protect/conf/foo.json | Formally illegal, but tolerated as long as there is no trailing slash. |
|<file:///etc/app_protect/conf/foo.json> | /etc/app_protect/conf/foo.json | Full path, but still the default one |
|<file:///bar/foo.json> | /bar/foo.json | Non-default path |
|<file://etc/app_protect/conf/foo.json> | **Not accepted** | "etc" is interpreted as remote host name |


In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced. To do this, we reference a local file on the machine.

**Policy Configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
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
    "modificationsReference": {
        "link": "file:///modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

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
        }
    ]
}
```

If, for any reason, the configuration was done incorrectly, the policy compilation process will fail with the following error:
```shell
APP_PROTECT { "event": "configuration_load_failure" ...
```

The error details that follow will depend on the exact situation causing the policy compilation to fail.  If the policy compilation process fails, the compiler will revert to the last working policy and all the changes for the last policy compilation attempt will be lost.

## OpenAPI specification file reference

The OpenAPI Specification defines the spec file format needed to describe RESTful APIs. The spec file can be written either in JSON or YAML. Using a spec file simplifies the work of implementing API protection. Refer to the OpenAPI Specification (formerly called Swagger) for details.

The simplest way to create an API protection policy is using an OpenAPI Specification file to import the details of the APIs. If you use an OpenAPI Specification file, F5 WAF for NGINX will automatically create a policy for the following properties (depending on what's included in the spec file):
* Methods
* URLs
* Parameters
* JSON profiles

An OpenAPI-ready policy template is provided with the F5 WAF for NGINX packages and is located in: `/etc/app_protect/conf/NginxApiSecurityPolicy.json`

It contains violations related to OpenAPI set to blocking (enforced).

{{< call-out "note" >}} F5 WAF for NGINX supports only one OpenAPI Specification file reference per policy.{{< /call-out >}}

### Types of OpenAPI References

There are different ways of referencing OpenAPI Specification files. The configuration is similar to [External References](#external-references).

{{< call-out "note" >}} Any update of an OpenAPI Specification file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration. {{< /call-out >}}

#### URL Reference

URL reference is the method of referencing an external source by providing its full URL.

Make sure to configure certificates prior to using the HTTPS protocol - see the [HTTPS References](#https-reference) under the External References section for more details.

{{< call-out "note" >}} You need to make sure that the server where the resource files are located is always available when you are compiling your policy. {{< /call-out >}}

##### Example Configuration

In this example, we are adding an OpenAPI Specification file reference using the link `http://127.0.0.1:8088/myapi.yaml`. This will configure allowed data types for `query_int` and `query_str` parameters values.

**Policy configuration:**

```json
{
    "policy": {
        "name": "petstore_api_security_policy",
        "description": "F5 WAF for NGINX API Security Policy for the Petstore API",
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