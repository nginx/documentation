---
docs:
---

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Upstreams",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "name": {
          "title": "Label",
          "type": "string",
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the upstream. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific upstream.",
          "examples": [
            "Users Service"
          ]
        },
        "nameInConfig": {
          "title": "Name",
          "type": "string",
            
          "examples": [
            "users_backend"
          ]
        },
        "servers": {
          "type": "array",
          "title": "Servers",
          "items": {
            "type": "object",
            "properties": {
              "address": {
                "title": "Upstream server address",
                "type": "string",
                "description": "Specifies the address for the upstream server.",
                "examples": [
                  "users1.example.com",
                  "192.0.0.1"
                ]
              },
              "port": {
                "type": "integer",
                "title": "Port",
                "description": "Specifies the port for the upstream server.",
                "minimum": 1,
                "maximum": 65535,
                "examples": [
                  80
                ]
              }
            },
            "required": [
              "address"
            ]
          }
        }
      },
      "required": [
        "name",
        "servers",
        "nameInConfig"
      ]
    }
  },
  "required": []
}
```
