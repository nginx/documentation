---
docs: DOCS-1289
---

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
