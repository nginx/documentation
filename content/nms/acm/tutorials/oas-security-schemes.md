---
title: "OAS Security Schemes"
date: 2023-06-22T18:20:41+01:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to configure security schemes in OAS for NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{<custom-styles>}}

## Overview

This tutorial walks you through setting up the security schemes in OpenAPI Specification using NGINX Management Suite API Connectivity Manager.

---

## What is a Security Scheme?

The security scheme in OAS is a way to specify how an API should be secured, including how requests are authenticated and authorized. It allows API owners to define the security requirements for their API and communicate them to API consumers. There are several API Gateway authentication/authorization schemes types that can be confired in the OAS : API key authentication, basic authentication, OAuth2 JWT assertion, and OAuth2 token introspection.

## ACM Supported Scheme Types & Requirements

Currently, in Application Connectivity Manager (ACM) security schemes are available at the global level i.e. the security scheme will be applied to all the APIs in the OAS. There are two types of supported schemes user can configure: HTTP-Basic and the API Key.

In the following section we will go through both of them.

Basic: With this scheme, the API expects credentials to be included in the Authorization header of the HTTP request.

API Key: The API Key security scheme is used to authenticate requests using a unique API key. With this scheme, the API expects the API key to be included as a query parameter or header in the HTTP request.

By specifying the appropriate security scheme and its properties in the OAS, ACM API owners can ensure that their API is secure and only accessible to authorized users or applications.

If a user configures path level security requirements, they will be ignored and not applied (until supported in ACM).

## Before You Begin

To complete the instructions in this guide, you need the following:

1. API Connectivity Manager is installed, licensed, and running
2. One or more Infra and Service workspaces
3. One or more Environments

## API Key Authentication Security Scheme

The API Key security scheme is used to authenticate requests using a unique API key. The API key is usually a long, randomly generated string that is provided to the client by the API owner. The client must include the API key as a query parameter or header in the HTTP request. The API owner can use this key to identify the client and authorize access to the API.
In the following section let's see step by step to configure the API Key Authentication Security Scheme


Below table illustrates the Scheme Definition

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `apiKey` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for security scheme. CommonMark syntax MAY be used for rich text representation.      | `N/A`    |
| `name`       | `string`   | False  | <p>Of type `string`, if `in` is set to `header`, name must not contain underscores. This is also enforced in ACM for API key authentication policy.</p> | The name of the header or query parameter to be used. | `apiKey` |
| `in` | `string`  | False   | one of `["header", "query"]` | The location of the API key. | `header` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the `apiKey` credential is going to be proxy forwarded to backend service - in the HTTP header. | `false` |
| `x-errorReturnConditions.notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `apiKey` is not supplied. | `401` |
| `x-errorReturnConditions.noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `apiKey` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}



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
  "servers": [{
    "url": "https://petstore3.swagger.io/api/v3"
  }],
  "tags": [{
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
        "parameters": [{
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
        }],
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
        "parameters": [{
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
        }],
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
        "parameters": [{
          "name": "petId",
          "in": "path",
          "description": "ID of pet to return",
          "required": true,
          "schema": {
            "type": "integer",
            "format": "int64"
          }
        }],
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
        "parameters": [{
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
        "parameters": [{
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
In the `component securitySchemes` section `ExampleApiKeyAuth` is configured

## Example Proxy Request Body with Security data[]

When an API Key security scheme is provided in an OAS that is referenced in a proxy POST/PUT request if the user wants to set up valid API keys they need to provide these in the proxy POST/PUT request body. Below is an example to supplement the example OAS scheme above.

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
            "proxy-request-headers" : [{
            "action":{
              "proxyHeaders" : {
                "proxyDefaultHeadersToBackend": false,
                "proxyCustomHeadersToBackend" : [
                      {
                      "key"   : "Host",
                      "value" : "stringValue.petstore3.swagger.io"
                      }
                ]
   }}
          }
          ],
               "basic-authn": [
                {
                    "data": [
                        {
                            "clientID": "user1-clientid",
                            "password": "secret",
                            "username": "user1"
                        }
                    ]
                }
            ]
          }
    }
}
```
Below is the example of what proxy config looks like after GET request when OAS has been applied with security scheme

```bash
curl -X GET -H "Authorization: Bearer testapikey1234" -H "Content-Type: application/json" https://<<data_server>>/api/v3/pet/2
```


Basic Authentication Security Scheme
Basic Authentication is a security scheme that is commonly used to authenticate HTTP requests. The request contains a header field in the form of Authorization: Basic <credentials>, where credentials is the Base64 encoding of username and password joined by a single colon.

ACM API owners can restrict access to their APIs with usernames and passwords. This scheme can be configured to grant access to APIs only after verifying that the username and password are valid.

To mitigate any security risks, it is recommended to use Basic Authentication only over encrypted channels such as HTTPS.

Security Scheme Definition

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< bootstrap-table "table table-striped table-bordered" >}}
| Field                                           | Type | Required      | Valid Value(s)                                                                                                                                                                           | Description | Default |
|-------------------------------------------------|----------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|
| `type`                  | `string`  | True   | `http` | The type of the security scheme.       | `N/A`  |
| `description`         | `string`   | False | Of type `string` | A short description for security scheme. CommonMark syntax MAY be used for rich text representation.      | `N/A`    |
| `scheme`       | `string`   | True  | `basic` | The name of the HTTP Authorization scheme to be used in the Authorization header as defined in RFC7235. | `N/A` |
| `x-credentialForward`| `bool` | False | one of `[true, false]` | This field defines whether the basic auth credential is going to be proxy forwarded to backend service in the HTTP request Authorization header. | `false` |
| `x-errorReturnConditions.notSupplied.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when `basicAuth` is not supplied. | `401` |
| `x-errorReturnConditions.noMatch.returnCode` | `int` | False | In range `400-599` | The error code that needs to be used by the NGINX data plane when invalid `basicAuth` is supplied . | `403` |
| `x-labels.targetPolicyName` | `string` | False | Of type `string` | The required target policy name set in policy `metadata.labels.targetPolicyName`. | `default` |


{{< /bootstrap-table >}}
{{< raw-html>}}</div>{{</raw-html>}}

##Scheme Example Usage

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
  "servers": [{
    "url": "https://petstore3.swagger.io/api/v3"
  }],
  "tags": [{
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
        "parameters": [{
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
        }],
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
        "parameters": [{
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
        }],
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
        "parameters": [{
          "name": "petId",
          "in": "path",
          "description": "ID of pet to return",
          "required": true,
          "schema": {
            "type": "integer",
            "format": "int64"
          }
        }],
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
        "parameters": [{
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
        "parameters": [{
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

##Example Proxy Request Body with Security data[]
When a http basic security scheme is provided in an OAS that is referenced in a proxy POST/PUT request if the user wants to set up valid basic auth credentials they need to provide these in the proxy POST/PUT request body. Below is an example to supplement the example OAS scheme above.

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
            "proxy-request-headers" : [{
            "action":{
              "proxyHeaders" : {
                "proxyDefaultHeadersToBackend": false,
                "proxyCustomHeadersToBackend" : [
                      {
                      "key"   : "Host",
                      "value" : "stringValue.petstore3.swagger.io"
                      }
                ]
   }}
          }
          ],
               "basic-authn": [
                {
                    "data": [
                        {
                            "clientID": "user1-clientid",
                            "password": "secret",
                            "username": "user1"
                        }
                    ]
                }
            ]
          }
    }
}
```
Below is the example of what proxy config looks like after GET request when OAS has been applied with security scheme

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
Below is the cURL example of request to proxy with basic auth to the Pet Store server

curl -X POST -u user1:secret -H "Content-Type: application/json" \ -d '{"id": 12345, "name": "woofy"}' \ https://<<data_server>>/v1/pet

It would result in a successful operation with the 200 status {"id": 12345, "name": "woofy"}

curl -X POST -H "Content-Type: application/json" \ -d '{"id": 12345, "name": "woofy"}' \ https://<<data_server>>/v1/pet






