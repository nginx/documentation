---
docs:
---

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Reverse Proxy Augment",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "locations": {
          "type": "array",
          "title": "Locations",
          "description": "For each location below, the input will be matched via the 'Label' to a location in the base template to inject a reverse proxy directive targeting the specified upstream.",
          "items": {
            "type": "object",
            "properties": {
              "targetLabel": {
                "title": "Target Location Label",
                "type": "string",
                "description": "The label of the target location for this configuration. Must be exactly the same as the 'label' field from a location in the base template.",
                "examples": [
                  "Main Location"
                ]
              },
              "upstreamName": {
                "type": "string",
                "title": "Upstream Name",
                "description": "Name of the target upstream. Must match exactly.",
                "examples": [
                  "upstream_1"
                ]                
              }
            },
            "required": ["targetId", "upstreamName"]
          }
        }
      },
      "required": ["locations"]
    }
  },
  "required": []
}
```
