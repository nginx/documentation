---
docs:
---

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Servers",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "serverName": {
          "title": "Label",
          "type": "string",
          "description": "A name for the server that will be shown in the UI. Also used to connect augment input to a specific server.",
          "examples": [
            "Example Server"
          ]
        },
        "serverNameInConfig": {
          "title": "Name",
          "type": "string",
          "description": "The name of the HTTP server. This value is used when matching incoming requests to the correct server.",
          "examples": [
            "example.com"
          ]
        }
      },
      "required": [
        "serverName",
        "serverNameInConfig"
      ]
    }
  },
  "required": []
}
```
