---
docs:
---

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Upstream",
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
          "description": "A label for the upstream that will be shown in the UI. Also used to connect augment input to a specific upstream.",
          "examples": [
            "Users Service"
          ]
        },
        "nameInConfig": {
          "title": "Name",
          "type": "string",
          "description": "The name of the upstream that will be used in the configuration file. This is the value that should be referenced when setting up proxying.",
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
