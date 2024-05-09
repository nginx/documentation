---
docs:
---

``` json
{
 "$schema": "https://json-schema.org/draft/2020-12/schema",
 "title": "Locations",
 "type": "object",
 "properties": {
   "templateInput": {
     "type": [
       "object",
       "null"
     ],
     "properties": {
        "nameExpression": {
          "title": "Label",
          "type": "string",
          "description": "Enter a unique, case-sensitive alphanumeric label to identify the location. This label is displayed in the user interface and acts as a key for matching and applying augment input to the specific location.",
          "examples": [
            "Users Endpoint"
          ]
        },
       "locationMatchExpression": {
         "title": "Match Expression",
         "type": "string",
         "description": "The prefix to match request   paths by.",
         "examples": [
           "/users"
         ]
       }
     },
     "required": [
       "nameExpression",
       "locationMatchExpression"
     ]
   }
 },
 "required": []
}
```
