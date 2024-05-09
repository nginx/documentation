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
          "description": "To configure each location, the 'Label' you enter below must correspond exactly to a 'Label' in the base template. This ensures the system can properly inject a reverse proxy directive targeting the specified upstream.",
          "items": {
            "type": "object",
            "properties": {
              "targetLabel": {
                "title": "Target Location Label",
                "type": "string",
                "description": "Enter the label for this configuration's target location. It must exactly match the 'Label' from a base template location to ensure the system correctly injects the augment inputs into the configuration.",
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
