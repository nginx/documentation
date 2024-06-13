---
docs: DOCS-1291
---

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
