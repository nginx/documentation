---
description: F5 NGINX Management Suite API Connectivity Manager lets you secure APIs
  with OpenAPI Spec (OAS) security schemes. This tutorial provides step-by-step instructions
  for setting up basic authentication and API key authentication security schemes
  to secure your APIs and control access to authorized users or applications.
docs: DOCS-1246
title: OAS Security Schemes
toc: true
weight: 200
type:
- tutorial
---

## Overview

The OpenAPI Specification (OAS) allows you to specify authentication and authorization requirements, or security schemes, for your APIs, ensuring that only authorized users or applications can access them. These security schemes are applied globally, meaning they are enforced for all APIs within the OAS.

{{<note>}}When configuring security schemes, keep in mind that path-level security requirements will not be applied and are ignored.{{</note>}}

Listed below are the OAS security schemes that API Connectivity Manager supports.


{{< bootstrap-table "table table-striped table-bordered" >}}

| OAS&nbsp;Authorization&nbsp;Schemes | ACM&nbsp;Supported&nbsp;Schemes |
|---|---|
| Basic Authentication | <i class="fa-solid fa-check" style="color: green"></i> Supported <br><br>APIs with this scheme expect credentials to be included in the HTTP Authorization request header. |
| API Key Authentication | <i class="fa-solid fa-check" style="color: green"></i> Supported <br><br>The API Key security scheme uses a unique API key to authenticate requests. With this scheme, the API expects the API key to be passed as a query parameter or header in the HTTP request. |
| OAuth2 JWT Assertion | <i class="fa-solid fa-ban" style="color: red"></i> Not supported|
| OAuth2 Token Introspection |<i class="fa-solid fa-ban" style="color: red"></i> Not supported |

{{< /bootstrap-table >}}



---

## Before You Begin

To complete the instructions in this guide, you need the following:

1. API Connectivity Manager is installed, licensed, and running
2. One or more Infra and Service workspaces
3. One or more Environments

---

## Basic Authentication Security Scheme

Basic Authentication is a security scheme that is commonly used to authenticate HTTP requests. The request contains a header field in the form of `Authorization: Basic <credentials>`, where `<credentials>` is the Base64-encoded username and password joined by a single colon.

With Basic Authentication, API owners can restrict access to their APIs by requiring usernames and passwords; API access is granted only after a username and password are validated.

{{<call-out "important" "Security Consideration" >}}We recommend using Basic Authentication only over encrypted channels such as HTTPS in order to minimize security risks.{{</call-out>}}

### Basic Authentication Scheme Definition


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `http` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for the security scheme. CommonMark syntax can be used for rich text representation.      | `N/A`    |
| `scheme`       | `string`   | True  | `basic` | The name of the HTTP Authorization scheme to be used in the Authorization header as defined in [RFC7235](https://datatracker.ietf.org/doc/html/rfc7235). | `N/A` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the basic authentication credential is proxy-forwarded to the backend service in the HTTP request Authorization header. | `false` |
| `x-errorReturnConditions.`<br>`notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `basicAuth` is not supplied. | `401` |
| `x-errorReturnConditions.`<br>`noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `basicAuth` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}



### Configure Basic Authentication Scheme

To configure a basic authentication scheme, take the following steps:

1. Create an API spec with the basic security scheme configured. In the following example, take a look at how `ExampleBasicAuth` is configured in `component.securitySchemes`.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Basic Authentication API Spec</summary>

   ```json
    {
      "openapi": "3.0.2",
      "info": {
        "title": "Swagger Petstore - OpenAPI 3.0",
        "description": "This is a sample Pet Store Server based on the OpenAPI 3.0 specification.  You can find out more about\nSwagger at [http://swagger.io](http://swagger.io). In the third iteration of the pet store, we've switched to the design first approach!\nYou can now help us improve the API whether it's by making changes to the definition itself or to the code.\nThat way, with time, we can improve the API in general, and expose some of the new features in OAS3.\n\nSome useful links:\n- [The Pet Store repository](https://github.com/swagger-api/swagger-petstore)\n- [The source API definition for the Pet Store](https://github.com/swagger-api/swagger-petstore/blob/master/src/main/resources/openapi.yaml)",
        "termsOfService": "http://swagger.io/terms/",
        "contact": {
          "email": "apiteam@swagger.io"
        },
        "license": {
          "name": "Apache 2.0",
          "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "version": "1.0.17"
      },
      "security": [
        {
          "ExampleBasicAuth": []
        }
      ],
      "externalDocs": {
        "description": "Find out more about Swagger",
        "url": "http://swagger.io"
      },
      "servers": [
        {
          "url": "https://petstore3.swagger.io/api/v3"
        }
      ],
      "tags": [
        {
          "name": "pet",
          "description": "Everything about your Pets",
          "externalDocs": {
            "description": "Find out more",
            "url": "http://swagger.io"
          }
        },
        {
          "name": "store",
          "description": "Access to Petstore orders",
          "externalDocs": {
            "description": "Find out more about our store",
            "url": "http://swagger.io"
          }
        },
        {
          "name": "user",
          "description": "Operations about user"
        }
      ],
      "paths": {
        "/pet": {
          "put": {
            "tags": [
              "pet"
            ],
            "summary": "Update an existing pet",
            "description": "Update an existing pet by Id",
            "operationId": "updatePet",
            "requestBody": {
              "description": "Update an existent pet in the store",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/xml": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/x-www-form-urlencoded": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "200": {
                "description": "Successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid ID supplied"
              },
              "404": {
                "description": "Pet not found"
              },
              "405": {
                "description": "Validation exception"
              }
            }
          },
          "post": {
            "tags": [
              "pet"
            ],
            "summary": "Add a new pet to the store",
            "description": "Add a new pet to the store",
            "operationId": "addPet",
            "requestBody": {
              "description": "Create a new pet in the store",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/xml": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/x-www-form-urlencoded": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "200": {
                "description": "Successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "405": {
                "description": "Invalid input"
              }
            }
          }
        },
        "/pet/findByStatus": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Finds Pets by status",
            "description": "Multiple status values can be provided with comma separated strings",
            "operationId": "findPetsByStatus",
            "parameters": [
              {
                "name": "status",
                "in": "query",
                "description": "Status values that need to be considered for filter",
                "required": false,
                "explode": true,
                "schema": {
                  "type": "string",
                  "default": "available",
                  "enum": [
                    "available",
                    "pending",
                    "sold"
                  ]
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  },
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid status value"
              }
            }
          }
        },
        "/pet/findByTags": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Finds Pets by tags",
            "description": "Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.",
            "operationId": "findPetsByTags",
            "parameters": [
              {
                "name": "tags",
                "in": "query",
                "description": "Tags to filter by",
                "required": false,
                "explode": true,
                "schema": {
                  "type": "array",
                  "items": {
                    "type": "string"
                  }
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  },
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid tag value"
              }
            }
          }
        },
        "/pet/{petId}": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Find pet by ID",
            "description": "Returns a single pet",
            "operationId": "getPetById",
            "parameters": [
              {
                "name": "petId",
                "in": "path",
                "description": "ID of pet to return",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid ID supplied"
              },
              "404": {
                "description": "Pet not found"
              }
            }
          },
          "post": {
            "tags": [
              "pet"
            ],
            "summary": "Updates a pet in the store with form data",
            "description": "",
            "operationId": "updatePetWithForm",
            "parameters": [
              {
                "name": "petId",
                "in": "path",
                "description": "ID of pet that needs to be updated",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              },
              {
                "name": "name",
                "in": "query",
                "description": "Name of pet that needs to be updated",
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "status",
                "in": "query",
                "description": "Status of pet that needs to be updated",
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "405": {
                "description": "Invalid input"
              }
            }
          },
          "delete": {
            "tags": [
              "pet"
            ],
            "summary": "Deletes a pet",
            "description": "",
            "operationId": "deletePet",
            "parameters": [
              {
                "name": "api_key",
                "in": "header",
                "description": "",
                "required": false,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "petId",
                "in": "path",
                "description": "Pet id to delete",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              }
            ],
            "responses": {
              "400": {
                "description": "Invalid pet value"
              }
            }
          }
        }
      },
      "components": {
        "securitySchemes": {
          "ExampleBasicAuth": {
            "type": "http",
            "description": "Basic Authentication Scheme",
            "scheme": "basic",
            "x-credentialForward": true,
            "x-errorReturnConditions": {
              "notSupplied": {
                "returnCode": 401
              },
              "noMatch": {
                "returnCode": 403
              }
            },
            "x-labels": {
              "targetPolicyName": "default"
            }
          }
        },
        "schemas": {
          "Category": {
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64",
                "example": 1
              },
              "name": {
                "type": "string",
                "example": "Dogs"
              }
            },
            "xml": {
              "name": "category"
            }
          },
          "Tag": {
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64"
              },
              "name": {
                "type": "string"
              }
            },
            "xml": {
              "name": "tag"
            }
          },
          "Pet": {
            "required": [
              "name",
              "photoUrls"
            ],
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64",
                "example": 10
              },
              "name": {
                "type": "string",
                "example": "doggie"
              },
              "category": {
                "$ref": "#/components/schemas/Category"
              },
              "photoUrls": {
                "type": "array",
                "xml": {
                  "wrapped": true
                },
                "items": {
                  "type": "string",
                  "xml": {
                    "name": "photoUrl"
                  }
                }
              },
              "tags": {
                "type": "array",
                "xml": {
                  "wrapped": true
                },
                "items": {
                  "$ref": "#/components/schemas/Tag"
                }
              },
              "status": {
                "type": "string",
                "description": "pet status in the store",
                "enum": [
                  "available",
                  "pending",
                  "sold"
                ]
              }
            },
            "xml": {
              "name": "pet"
            }
          },
          "ApiResponse": {
            "type": "object",
            "properties": {
              "code": {
                "type": "integer",
                "format": "int32"
              },
              "type": {
                "type": "string"
              },
              "message": {
                "type": "string"
              }
            },
            "xml": {
              "name": "##default"
            }
          }
        },
        "requestBodies": {
          "Pet": {
            "description": "Pet object that needs to be added to the store",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Pet"
                }
              },
              "application/xml": {
                "schema": {
                  "$ref": "#/components/schemas/Pet"
                }
              }
            }
          }
        }
      }
    }
    ```

   </details>


2. Create a proxy with `specRef` referencing the spec from step 1. Since the referenced spec uses Basic Authentication, you need to include the necessary basic authentication credentials within the body of the POST/PUT request.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Proxy referencing OAS spec with Basic Authentication scheme</summary>

   ```json
    {
      "name": "petstore-proxy",
      "version": "v1",
      "specRef": "swagger-petstore-openapi-3-0-1-0-17",
      "proxyConfig": {
        "hostname": "{{environmentHostname}}",
        "ingress": {
          "basePath": "/api/v3",
          "basePathVersionAppendRule": "NONE"
        },
        "backends": [
          {
            "serviceName": "petstore-svc",
            "serviceTargets": [
              {
                "hostname": "petstore3.swagger.io",
                "listener": {
                  "enableTLS": true,
                  "port": 443,
                  "transportProtocol": "HTTP"
                }
              }
            ]
          }
        ],
        "policies": {
          "proxy-request-headers": [
            {
              "action": {
                "proxyHeaders": {
                  "proxyDefaultHeadersToBackend": false,
                  "proxyCustomHeadersToBackend": [
                    {
                      "key": "Host",
                      "value": "stringValue.petstore3.swagger.io"
                    }
                  ]
                }
              }
            }
          ],
          "apikey-authn": [
            {
              "data": [
                {
                  "apiKey": "<API key>",
                  "clientID": "userA"
                }
              ]
            }
          ]
        }
      }
    }
    ```


   </details>

   Verify the GET request for the proxy. In the JSON response, you should see `policies.basic-authn` configured in the `proxyConfig` section.

   ```bash
   GET https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
   ```

   <details>
   <summary>Example GET JSON response: Proxy with basic-authn policy configured</summary>

   ```json
    {
      "configs": [
        {
          "configState": {
            "proxy": {
              "configState": {
                "action": "DEPLOY",
                "createTime": "2023-06-26T17:03:57Z",
                "instanceGroupRef": "test-ig",
                "jobID": "b777b4ed-579e-4070-af9c-aedeb78fb778",
                "jobLink": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy/jobs/b777b4ed-579e-4070-af9c-aedeb78fb778",
                "status": "SUCCESS",
                "updateTime": "2023-06-26T17:03:59Z"
              },
              "id": 1
            }
          },
          "metadata": {
            "kind": "proxy",
            "link": {
              "rel": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy"
            },
            "ref": "/api/acm/v1/services/workspaces/service-ws",
            "tags": []
          },
          "name": "petstore-proxy",
          "proxyConfig": {
            "backends": [
              {
                "enableSRVRecordLookUp": false,
                "label": {
                  "targetName": "default"
                },
                "serviceContextRoot": "/",
                "serviceName": "petstore-svc",
                "serviceTargets": [
                  {
                    "failTimeout": "10s",
                    "hostname": "petstore3.swagger.io",
                    "listener": {
                      "enableTLS": true,
                      "port": 443,
                      "transportProtocol": "HTTP"
                    },
                    "maxConnections": 0,
                    "maxFails": 1,
                    "serverDown": false
                  }
                ]
              }
            ],
            "hostname": "apim-devenv-agent",
            "ingress": {
              "basePath": "/api/v3",
              "basePathVersionAppendRule": "NONE",
              "matchRule": "PREFIX",
              "routes": [
                {
                  "description": "Update an existing pet by Id",
                  "httpMethod": "PUT",
                  "parameters": [],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet"
                },
                {
                  "description": "Add a new pet to the store",
                  "httpMethod": "POST",
                  "parameters": [],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet"
                },
                {
                  "description": "Multiple status values can be provided with comma separated strings",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "Status values that need to be considered for filter",
                      "in": "QUERY",
                      "name": "status",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/findByStatus"
                },
                {
                  "description": "Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "Tags to filter by",
                      "in": "QUERY",
                      "name": "tags",
                      "required": false,
                      "schema": {
                        "type": "ARRAY"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/findByTags"
                },
                {
                  "description": "",
                  "httpMethod": "DELETE",
                  "parameters": [
                    {
                      "description": "",
                      "in": "HEADER",
                      "name": "api_key",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    },
                    {
                      "description": "Pet id to delete",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                },
                {
                  "description": "Returns a single pet",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "ID of pet to return",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                },
                {
                  "description": "",
                  "httpMethod": "POST",
                  "parameters": [
                    {
                      "description": "ID of pet that needs to be updated",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    },
                    {
                      "description": "Name of pet that needs to be updated",
                      "in": "QUERY",
                      "name": "name",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    },
                    {
                      "description": "Status of pet that needs to be updated",
                      "in": "QUERY",
                      "name": "status",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                }
              ],
              "stripBasePathVersion": false
            },
            "policies": {
              "basic-authn": [
                {
                  "action": {
                    "credentialForward": true,
                    "errorReturnConditions": {
                      "notSupplied": {
                        "grpcStatusCode": 0,
                        "returnCode": 401
                      }
                    }
                  },
                  "data": [
                    {
                      "clientID": "user1-clientid",
                      "password": "secret",
                      "source": "ACM",
                      "username": "user1"
                    }
                  ],
                  "metadata": {
                    "labels": {
                      "targetPolicyName": "default"
                    }
                  },
                  "systemMetadata": {
                    "appliedOn": "inbound",
                    "context": "proxy"
                  }
                }
              ],
              "proxy-request-headers": [
                {
                  "action": {
                    "proxyHeaders": {
                      "proxyCustomHeadersToBackend": [
                        {
                          "isSensitive": false,
                          "key": "Host",
                          "value": "stringValue.petstore3.swagger.io"
                        }
                      ],
                      "proxyDefaultHeadersToBackend": false
                    }
                  },
                  "metadata": {
                    "labels": {
                      "targetPolicyName": "default"
                    }
                  },
                  "systemMetadata": {
                    "appliedOn": "backend"
                  }
                }
              ]
            }
          },
          "specRef": "swagger-petstore-openapi-3-0-1-0-17",
          "status": "LATEST",
          "version": "v1",
          "_links": [
            {
              "hostname": "apim-devenv-agent",
              "href": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy?hostname=apim-devenv-agent",
              "rel": "SELF",
              "runtime": "GATEWAY-PROXY",
              "type": "API-Proxy"
            }
          ]
        }
      ],
      "metadata": {
        "pagination": {
          "links": {
            "next": {},
            "prev": {}
          },
          "pageCount": 1,
          "pageToken": "1687856101",
          "totalItems": 1
        }
      }
    }
    ```

   </details>

3. Pass traffic to the endpoints. The following example sends a request through a proxy to the Pet Store server, using Basic Authentication. A successful request will return a `200` status response.

   ```bash
   curl -X GET -u user1:secret -H "Content-Type: application/json"  http://<ip address>/api/v3/pet/4

   {"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"<name>","photoUrls":["http://example.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
   ```

   In contrast, if the request lacks proper authentication, the response is "Unauthorized" with a status code of `401`

   ```bash
   curl -X GET -H "Content-Type: application/json" http://<ip address>/v1/pet

   {
       "message": "Unauthorized",
       "status": "401"
   }
   ```

---

## API Key Authentication Security Scheme

The API Key Authentication security scheme uses a unique API key to authenticate requests. The API key is usually a long, randomly generated string provided to the client by the API owner. To access the API, the client must include this key as a query parameter or in the request header. The API owner can use this key to identify the client and authorize access to the API.

### API Key Scheme Definition


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `apiKey` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for the security scheme. CommonMark syntax can be used for rich text representation.      | `N/A`    |
| `name`       | `string`   | False  | <p>Of type `string`, if `in` is set to `header`. <br><br> The `name` must not contain underscores. This is also enforced in API Connectivity Manager for the API key authentication policy.</p> | The name of the header or query parameter to be used. | `apiKey` |
| `in` | `string`  | False   | one of `["header", "query"]` | The location of the API key. | `header` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the `apiKey` credential is proxy-forwarded to the backend service in the HTTP request header. | `false` |
| `x-errorReturnConditions.`<br>`notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `apiKey` is not supplied. | `401` |
| `x-errorReturnConditions.`<br>`noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when an invalid `apiKey` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}


### Configure API Key Authentication Scheme

To configure the API Key Authentication security scheme, take the following steps:

1. Create an API spec with the `apiKey` security scheme configured. In the following example, take a look at how `ExampleApiKeyAuth` is configured in `component.securitySchemes`.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/api-docs
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create API Key Authentication API Spec</summary>

   ```json
    {
      "openapi": "3.0.2",
      "info": {
        "title": "Swagger Petstore - OpenAPI 3.0",
        "description": "This is a sample Pet Store Server based on the OpenAPI 3.0 specification.  You can find out more about\nSwagger at [http://swagger.io](http://swagger.io). In the third iteration of the pet store, we've switched to the design first approach!\nYou can now help us improve the API whether it's by making changes to the definition itself or to the code.\nThat way, with time, we can improve the API in general, and expose some of the new features in OAS3.\n\nSome useful links:\n- [The Pet Store repository](https://github.com/swagger-api/swagger-petstore)\n- [The source API definition for the Pet Store](https://github.com/swagger-api/swagger-petstore/blob/master/src/main/resources/openapi.yaml)",
        "termsOfService": "http://swagger.io/terms/",
        "contact": {
          "email": "apiteam@swagger.io"
        },
        "license": {
          "name": "Apache 2.0",
          "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "version": "1.0.17"
      },
      "security": [
        {
          "ExampleApiKeyAuth": []
        }
      ],
      "externalDocs": {
        "description": "Find out more about Swagger",
        "url": "http://swagger.io"
      },
      "servers": [
        {
          "url": "https://petstore3.swagger.io/api/v3"
        }
      ],
      "tags": [
        {
          "name": "pet",
          "description": "Everything about your Pets",
          "externalDocs": {
            "description": "Find out more",
            "url": "http://swagger.io"
          }
        },
        {
          "name": "store",
          "description": "Access to Petstore orders",
          "externalDocs": {
            "description": "Find out more about our store",
            "url": "http://swagger.io"
          }
        },
        {
          "name": "user",
          "description": "Operations about user"
        }
      ],
      "paths": {
        "/pet": {
          "put": {
            "tags": [
              "pet"
            ],
            "summary": "Update an existing pet",
            "description": "Update an existing pet by Id",
            "operationId": "updatePet",
            "requestBody": {
              "description": "Update an existent pet in the store",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/xml": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/x-www-form-urlencoded": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "200": {
                "description": "Successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid ID supplied"
              },
              "404": {
                "description": "Pet not found"
              },
              "405": {
                "description": "Validation exception"
              }
            }
          },
          "post": {
            "tags": [
              "pet"
            ],
            "summary": "Add a new pet to the store",
            "description": "Add a new pet to the store",
            "operationId": "addPet",
            "requestBody": {
              "description": "Create a new pet in the store",
              "content": {
                "application/json": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/xml": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                },
                "application/x-www-form-urlencoded": {
                  "schema": {
                    "$ref": "#/components/schemas/Pet"
                  }
                }
              },
              "required": true
            },
            "responses": {
              "200": {
                "description": "Successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "405": {
                "description": "Invalid input"
              }
            }
          }
        },
        "/pet/findByStatus": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Finds Pets by status",
            "description": "Multiple status values can be provided with comma separated strings",
            "operationId": "findPetsByStatus",
            "parameters": [
              {
                "name": "status",
                "in": "query",
                "description": "Status values that need to be considered for filter",
                "required": false,
                "explode": true,
                "schema": {
                  "type": "string",
                  "default": "available",
                  "enum": [
                    "available",
                    "pending",
                    "sold"
                  ]
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  },
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid status value"
              }
            }
          }
        },
        "/pet/findByTags": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Finds Pets by tags",
            "description": "Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.",
            "operationId": "findPetsByTags",
            "parameters": [
              {
                "name": "tags",
                "in": "query",
                "description": "Tags to filter by",
                "required": false,
                "explode": true,
                "schema": {
                  "type": "array",
                  "items": {
                    "type": "string"
                  }
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  },
                  "application/json": {
                    "schema": {
                      "type": "array",
                      "items": {
                        "$ref": "#/components/schemas/Pet"
                      }
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid tag value"
              }
            }
          }
        },
        "/pet/{petId}": {
          "get": {
            "tags": [
              "pet"
            ],
            "summary": "Find pet by ID",
            "description": "Returns a single pet",
            "operationId": "getPetById",
            "parameters": [
              {
                "name": "petId",
                "in": "path",
                "description": "ID of pet to return",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              }
            ],
            "responses": {
              "200": {
                "description": "successful operation",
                "content": {
                  "application/xml": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  },
                  "application/json": {
                    "schema": {
                      "$ref": "#/components/schemas/Pet"
                    }
                  }
                }
              },
              "400": {
                "description": "Invalid ID supplied"
              },
              "404": {
                "description": "Pet not found"
              }
            }
          },
          "post": {
            "tags": [
              "pet"
            ],
            "summary": "Updates a pet in the store with form data",
            "description": "",
            "operationId": "updatePetWithForm",
            "parameters": [
              {
                "name": "petId",
                "in": "path",
                "description": "ID of pet that needs to be updated",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              },
              {
                "name": "name",
                "in": "query",
                "description": "Name of pet that needs to be updated",
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "status",
                "in": "query",
                "description": "Status of pet that needs to be updated",
                "schema": {
                  "type": "string"
                }
              }
            ],
            "responses": {
              "405": {
                "description": "Invalid input"
              }
            }
          },
          "delete": {
            "tags": [
              "pet"
            ],
            "summary": "Deletes a pet",
            "description": "",
            "operationId": "deletePet",
            "parameters": [
              {
                "name": "api_key",
                "in": "header",
                "description": "",
                "required": false,
                "schema": {
                  "type": "string"
                }
              },
              {
                "name": "petId",
                "in": "path",
                "description": "Pet id to delete",
                "required": true,
                "schema": {
                  "type": "integer",
                  "format": "int64"
                }
              }
            ],
            "responses": {
              "400": {
                "description": "Invalid pet value"
              }
            }
          }
        }
      },
      "components": {
        "securitySchemes": {
          "ExampleApiKeyAuth": {
            "type": "apiKey",
            "description": "API Key Authn security scheme",
            "name": "X-API-Key",
            "in": "header",
            "x-credentialForward": true,
            "x-errorReturnConditions": {
              "notSupplied": {
                "returnCode": 401
              },
              "noMatch": {
                "returnCode": 403
              }
            },
            "x-labels": {
              "targetPolicyName": "default"
            }
          }
        },
        "schemas": {
          "Category": {
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64",
                "example": 1
              },
              "name": {
                "type": "string",
                "example": "Dogs"
              }
            },
            "xml": {
              "name": "category"
            }
          },
          "Tag": {
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64"
              },
              "name": {
                "type": "string"
              }
            },
            "xml": {
              "name": "tag"
            }
          },
          "Pet": {
            "required": [
              "name",
              "photoUrls"
            ],
            "type": "object",
            "properties": {
              "id": {
                "type": "integer",
                "format": "int64",
                "example": 10
              },
              "name": {
                "type": "string",
                "example": "doggie"
              },
              "category": {
                "$ref": "#/components/schemas/Category"
              },
              "photoUrls": {
                "type": "array",
                "xml": {
                  "wrapped": true
                },
                "items": {
                  "type": "string",
                  "xml": {
                    "name": "photoUrl"
                  }
                }
              },
              "tags": {
                "type": "array",
                "xml": {
                  "wrapped": true
                },
                "items": {
                  "$ref": "#/components/schemas/Tag"
                }
              },
              "status": {
                "type": "string",
                "description": "pet status in the store",
                "enum": [
                  "available",
                  "pending",
                  "sold"
                ]
              }
            },
            "xml": {
              "name": "pet"
            }
          },
          "ApiResponse": {
            "type": "object",
            "properties": {
              "code": {
                "type": "integer",
                "format": "int32"
              },
              "type": {
                "type": "string"
              },
              "message": {
                "type": "string"
              }
            },
            "xml": {
              "name": "##default"
            }
          }
        },
        "requestBodies": {
          "Pet": {
            "description": "Pet object that needs to be added to the store",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Pet"
                }
              },
              "application/xml": {
                "schema": {
                  "$ref": "#/components/schemas/Pet"
                }
              }
            }
          }
        }
      }
    }
    ```


   </details>

2. Create a proxy with `specRef` referencing the spec from step 1. See the following example for how your proxy request body should look with `apikey-authn` configured on the policy.

   Note, since the referenced spec uses the API Key Authentication security scheme, you need to include the required API key within the POST/PUT request body.

   ```bash
   POST https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies
   ```

   <details>
   <summary>Example POST/PUT JSON request: Create Proxy referencing OAS spec with API Key Authentication scheme</summary>

   ```json
    {
      "name": "petstore-proxy",
      "version": "v1",
      "specRef": "swagger-petstore-openapi-3-0-1-0-17",
      "proxyConfig": {
        "hostname": "{{environmentHostname}}",
        "ingress": {
          "basePath": "/api/v3",
          "basePathVersionAppendRule": "NONE"
        },
        "backends": [
          {
            "serviceName": "petstore-svc",
            "serviceTargets": [
              {
                "hostname": "petstore3.swagger.io",
                "listener": {
                  "enableTLS": true,
                  "port": 443,
                  "transportProtocol": "HTTP"
                }
              }
            ]
          }
        ],
        "policies": {
          "proxy-request-headers": [
            {
              "action": {
                "proxyHeaders": {
                  "proxyDefaultHeadersToBackend": false,
                  "proxyCustomHeadersToBackend": [
                    {
                      "key": "Host",
                      "value": "stringValue.petstore3.swagger.io"
                    }
                  ]
                }
              }
            }
          ],
          "apikey-authn": [
            {
              "data": [
                {
                  "apiKey": "<API key>",
                  "clientID": "userA"
                }
              ]
            }
          ]
        }
      }
    }
    ```

   </details>

   Verify the GET request for the proxy. In the JSON response, you should see `policies.apikey-authn` in the `proxyConfig` section.

   ```bash
   GET https://{{NMS-FQDN}}/api/acm/v1/services/workspaces/{{proxyworkspacename}}/proxies/petstore-proxy?hostname={{environmentHostname}}&version=v1&includes=sensitivedata
   ```

   <details>
   <summary>Example GET JSON response: Proxy with apikey-authn policy configured</summary>

   ```json
    {
      "configs": [
        {
          "configState": {
            "proxy": {
              "configState": {
                "action": "DEPLOY",
                "createTime": "2023-06-28T13:24:45Z",
                "instanceGroupRef": "acm-test",
                "jobID": "f7bc9bef-3969-4f73-97ef-ca498b7103d3",
                "jobLink": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy/jobs/f7bc9bef-3969-4f73-97ef-ca498b7103d3",
                "status": "SUCCESS",
                "updateTime": "2023-06-28T13:24:48Z"
              },
              "id": 1
            }
          },
          "metadata": {
            "kind": "proxy",
            "link": {
              "rel": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy"
            },
            "ref": "/api/acm/v1/services/workspaces/service-ws",
            "tags": []
          },
          "name": "petstore-proxy",
          "proxyConfig": {
            "backends": [
              {
                "enableSRVRecordLookUp": false,
                "label": {
                  "targetName": "default"
                },
                "serviceContextRoot": "/",
                "serviceName": "petstore-svc",
                "serviceTargets": [
                  {
                    "failTimeout": "10s",
                    "hostname": "petstore3.swagger.io",
                    "listener": {
                      "enableTLS": true,
                      "port": 443,
                      "transportProtocol": "HTTP"
                    },
                    "maxConnections": 0,
                    "maxFails": 1,
                    "serverDown": false
                  }
                ]
              }
            ],
            "hostname": "apim-devenv-agent",
            "ingress": {
              "basePath": "/api/v3",
              "basePathVersionAppendRule": "NONE",
              "matchRule": "PREFIX",
              "routes": [
                {
                  "description": "Add a new pet to the store",
                  "httpMethod": "POST",
                  "parameters": [],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet"
                },
                {
                  "description": "Update an existing pet by Id",
                  "httpMethod": "PUT",
                  "parameters": [],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet"
                },
                {
                  "description": "Multiple status values can be provided with comma separated strings",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "Status values that need to be considered for filter",
                      "in": "QUERY",
                      "name": "status",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/findByStatus"
                },
                {
                  "description": "Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "Tags to filter by",
                      "in": "QUERY",
                      "name": "tags",
                      "required": false,
                      "schema": {
                        "type": "ARRAY"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/findByTags"
                },
                {
                  "description": "",
                  "httpMethod": "POST",
                  "parameters": [
                    {
                      "description": "ID of pet that needs to be updated",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    },
                    {
                      "description": "Name of pet that needs to be updated",
                      "in": "QUERY",
                      "name": "name",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    },
                    {
                      "description": "Status of pet that needs to be updated",
                      "in": "QUERY",
                      "name": "status",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                },
                {
                  "description": "",
                  "httpMethod": "DELETE",
                  "parameters": [
                    {
                      "description": "",
                      "in": "HEADER",
                      "name": "api_key",
                      "required": false,
                      "schema": {
                        "type": "STRING"
                      }
                    },
                    {
                      "description": "Pet id to delete",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                },
                {
                  "description": "Returns a single pet",
                  "httpMethod": "GET",
                  "parameters": [
                    {
                      "description": "ID of pet to return",
                      "in": "PATH",
                      "name": "petId",
                      "required": true,
                      "schema": {
                        "type": "INTEGER"
                      }
                    }
                  ],
                  "targetBackendServiceLabel": "default",
                  "targetPolicyLabel": "default",
                  "uri": "/pet/{petId}"
                }
              ],
              "stripBasePathVersion": false
            },
            "policies": {
              "apikey-authn": [
                {
                  "action": {
                    "apiKeyName": "X-API-Key",
                    "credentialForward": true,
                    "errorReturnConditions": {
                      "noMatch": {
                        "grpcStatusCode": 0,
                        "returnCode": 403
                      },
                      "notSupplied": {
                        "grpcStatusCode": 0,
                        "returnCode": 401
                      }
                    },
                    "suppliedIn": "header"
                  },
                  "data": [
                    {
                      "apiKey": "<API Key>",
                      "clientID": "userA",
                      "source": "ACM"
                    }
                  ],
                  "systemMetadata": {
                    "appliedOn": "inbound",
                    "context": "proxy"
                  }
                }
              ],
              "proxy-request-headers": [
                {
                  "action": {
                    "proxyHeaders": {
                      "proxyCustomHeadersToBackend": [
                        {
                          "isSensitive": false,
                          "key": "Host",
                          "value": "stringValue.petstore3.swagger.io"
                        }
                      ],
                      "proxyDefaultHeadersToBackend": false
                    }
                  },
                  "systemMetadata": {
                    "appliedOn": "backend"
                  }
                }
              ]
            }
          },
          "specRef": "swagger-petstore-openapi-3-0-1-0-17",
          "status": "LATEST",
          "version": "v2",
          "_links": [
            {
              "hostname": "apim-devenv-agent",
              "href": "/api/acm/v1/services/workspaces/service-ws/proxies/petstore-proxy?hostname=apim-devenv-agent",
              "rel": "SELF",
              "runtime": "GATEWAY-PROXY",
              "type": "API-Proxy"
            }
          ]
        }
      ],
      "metadata": {
        "pagination": {
          "links": {
            "next": {},
            "prev": {}
          },
          "pageCount": 1,
          "pageToken": "1687958759",
          "totalItems": 1
        }
      }
    }
    ```


   </details>

   ```bash
   curl -X GET -H "apiKey:<API key>" -H "Content-Type: application/json"  http://<ip address>/api/v3/pet/4
   {"id":4,"category":{"id":1,"name":"{{$$randomFirstName}}"},"name":"<name>","photoUrls":["http://example.com/640/480/cats"],"tags":[{"id":0,"name":"string"}],"status":"available"}
   ```

   If the request lacks proper authentication, the response is "Unauthorized" with a status code of `401`

   ```bash
   curl -X GET -H "Content-Type: application/json" http://<ip address>/v1/pet
   {
       "message": "Unauthorized",
       "status": "401"
   }
   ```
