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
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the server. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific server.",
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
