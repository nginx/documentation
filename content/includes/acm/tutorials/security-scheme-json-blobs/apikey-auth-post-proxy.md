---
docs: DOCS-1290
---

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
              "apiKey": "testapikey1234",
              "clientID": "userA"
            }
          ]
        }
      ]
    }
  }
}
```
