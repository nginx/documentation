---
title: JSON Schemas for Dynamic Web Forms
draft: false
description: ''
weight: 300
toc: true
docs: DOCS-1504
personas:
- devops
- netops
- secops
- support
type:
- reference
---

## Overview

The F5 NGINX Instance Manager’s web form builder uses JSON schemas to guide and validate user inputs when creating NGINX configurations from templates. This structured input method simplifies the configuration process and ensures adherence to NGINX configuration requirements.

## JSON Schema

JSON Schema is a standard explained in detail at [json-schema.org](https://json-schema.org/).

In NGINX Instance Manager, we support a specific set of common features from the JSON Schema:

- **Type**: This defines the kind of data a field can hold. More information is available at [Type Definitions](https://json-schema.org/understanding-json-schema/reference/type.html).

  Supported types include:
  - [Boolean](#boolean-field): True or false values.
  - [String](#string-field): Text.
  - [Numeric](#numeric-field): Numbers, both whole and decimal.
  - [Object](#object-field): Structures with named properties.
  - [Array](#array-field): Lists of items.

- **Title**: A descriptive, user-friendly name for each form field that lets users know what's required. For further details, refer to [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).

- **Description**: Text to help guide users on what to enter in the form fields. For details, see [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).

- **Examples**: Examples show what valid data looks like so anyone filling out the form knows what to enter. You should give at least one example so users understand the schema's purpose and requirements. More information can be found at [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).

{{< call-out "tip" "Writing effective JSON schema titles and descriptions" >}}<i class="fa-regular fa-pen-to-square"></i> The **title** and **description** fields are a key part of the user experience for templates. We recommend making sure that your title and description fields are predictably formatted and provide clear, concise guidance to the user.{{</call-out>}}

<br>

**Example http-server.json**

``` json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HTTP Server Inputs",
  "type": "object",
  "properties": {
    "templateInput": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "serverName": {
          "title": "Server name",
          "type": "string",
          "description": "Specifies the HTTP server name.",
          "examples": [
            "foo.com"
          ]
        },
        "id": {
			  "title": "Server ID",
			  "type": "string",
			  "description": "Case-sensitive, alphanumeric ID used for specifying augment placement.",
			  "examples": [
				"main_server"
			  ]
			}
      },
      "required": ["serverName", "id"]
    }
  },
  "required": []
}
```

<br>

## Type-Specific Features

Each data type in a JSON schema comes with its own set of features that define how the data can be structured and validated. Understanding these features is important for building robust and user-friendly web forms in NGINX Instance Manager. This section explains the characteristics and functionality of each data type so you can use the schema's capabilities for accurate data representation and validation.

### Boolean field

- **Supported**: Basic support without specific features detailed as of now.
- **Usage**: Toggles or binary choices in configurations.
- **Full spec**: https://json-schema.org/understanding-json-schema/reference/boolean.html
- **Example**:

  ```json
  {
    "isDevelopment": {
      "type": "boolean"
    }
  }
  ```

### String field

- **Supported Features**: Regular expression patterns, minimum and maximum length constraints, placeholders through examples, and enum for restricted value sets.
- **Usage**: Text inputs with validation criteria.
- **Full spec**: https://json-schema.org/understanding-json-schema/reference/string.html

#### Examples

- Regular string field with pattern and length constraints:

  ```json
  {
    "test": {
      "type": "string",
      "pattern": "^[A-Za-z0-9\\s]*$",
      "minLength": 1,
      "maxLength": 140,
      "examples": ["value 1", "value 2"]
    }
  }
  ```

- String Select field with enumerated values:

  ```json
  {
    "method": {
      "type": "string",
      "enum": ["GET", "POST", "PUT", "DELETE"]
    }
  }
  ```

- String MultiSelect field within an array:

  ```json
  {
    "method": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["GET", "POST", "PUT", "DELETE"]
      }
    }
  }
  ```

### Numeric field

- **Supported Features**: Multiple validation constraints including `multipleOf`, range specifications through `minimum` and `maximum`, and enum for restricted numerical values.
- **Usage**: Numeric inputs within specified ranges or fixed values.
- **Full spec**: https://json-schema.org/understanding-json-schema/reference/numeric.html

#### Examples

- Regular numeric field with validation criteria:

  ```json
  {
    "proxyTimeout": {
      "type": "number",
      "multipleOf": 10,
      "minimum": 10,
      "maximum": 1000,
      "examples": [50, 120, 870]
    }
  }
  ```

- Numeric Select field for predefined numerical values:

  ```json
  {
    "proxyTimeout": {
      "type": "number",
      "enum": [10, 20, 30, 40, 50]
    }
  }
  ```

- Numeric MultiSelect field within an array:

  ```json
  {
    "proxyTimeout": {
      "type": "array",
      "items": {
        "type": "number",
        "enum": [10, 20, 30, 40, 50]
      }
    }
  }
  ```

### Object field

- **Supported Features**: Nested object structures with required fields.
- **Usage**: Complex configurations involving nested parameters.
- **Full spec**: https://json-schema.org/understanding-json-schema/reference/object.html
- **Example**:

  ```json
  {
    "server": {
      "type": "object",
      "properties": {
        "isBackup": { "type": "boolean" },
        "weight": { "type": "integer" },
        "service": { "type": "string" }
      },
      "required": ["service"]
    }
  }
  ```

### Array field

- **Supported Features**: Minimum and maximum item counts, uniqueness constraints.
- **Usage**: Lists or collections of configuration items.
- **Full spec**: https://json-schema.org/understanding-json-schema/reference/array.html
- **Example**:

  ```json
  {
    "headers": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "value": { "type": "string" }
        },
        "required": []
      }
    }
  }
  ```

---

## Additional Templating Resources

{{< include "nim/templates/additional-templating-resources.md" >}}
