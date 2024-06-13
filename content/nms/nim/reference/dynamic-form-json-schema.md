---
title: "Dynamic Form JSON Schema"
date: 2024-03-12T13:40:03-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1507"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["reference"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

## JSON Schema

JSON Schema is a widely recognized standard, detailed at [json-schema.org](https://json-schema.org/).

We support a select range of common features:

- `type`: Specifies the field's type. For current support, see [Type-Specific Keywords](https://json-schema.org/understanding-json-schema/reference/type.html).
  - Presently, we only support single-type fields (`string` or an array containing a single `string` item).
    - As an exception, fields with two types, where one is `null` (for example, `["object", "null"]`), are also supported. Here, `null` is disregarded, and the second type is considered primary. This adjustment accommodates our backend's JSON Schema use.
  - Supported types include:
    - [Boolean](#boolean-field)
    - [String](#string-field)
    - [Numeric](#numeric-field)
    - [Object](#object-field)
    - [Array](#array-field)
- `title`: A user-friendly label for a form field. For more information, see [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).
- `description`: Provides helpful information on filling out the form field. For further details, see [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).

For specific features related to field types, please refer to the respective sections below.

### Boolean Field

Full specification: [<i class="fas fa-external-link-alt"></i>JSON-Schema: Boolean](https://json-schema.org/understanding-json-schema/reference/boolean.html)

Supported features:

- ...

**Example:**


```javascript
{
  "isDevelopment": {
    "type": "boolean"
  }
}
```

### String Field

Full specification: [<i class="fas fa-external-link-alt"></i>JSON-Schema: String](https://json-schema.org/understanding-json-schema/reference/string.html)

Supported features include:

- `pattern`: Validates the string using a RegExp.
- `minLength`: Specifies the minimum string length.
- `maxLength`: Defines the maximum string length.
- `examples`: Provides placeholder values. More details can be found [here](https://json-schema.org/understanding-json-schema/reference/generic.html).
- `enum`: Restricts the field to a set of predefined values. More information is available [here](https://json-schema.org/understanding-json-schema/reference/generic.html#enumerated-values).
  - Within an array, a String field with `enum` transforms into a MultiSelect component.

**Examples:**

```javascript
// Regular string field
{
  "test": {
    "type": "string",
    "pattern": "^[A-Za-z0-9\\s]*$",
    "minLength": 1,
    "maxLength": 140,
    "examples": ["value 1", "value 2"]
  }
}

// String Select field
{
  "method": {
    "type": "string",
    "enum": ["GET", "POST", "PUT", "DELETE"]
  }
}

// String MultiSelect field
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

### Numeric Field

Full specification: [<i class="fas fa-external-link-alt"></i>JSON-Schema: Numeric Types](https://json-schema.org/understanding-json-schema/reference/numeric.html)

Numeric fields can be either `integer` (integral numbers) or `number` (floating-point numbers).

Supported features:

- `multipleOf`: Ensures the field's value is a multiple of the specified number.
- `exclusiveMinimum` and `exclusiveMaximum`: Specify values must be strictly less than or greater than a certain number.
- `minimum` and `maximum`: Values must be less than or equal to, or greater than or equal to, specified numbers.
- `examples`: Suggest placeholder values. For more details, see [Examples](https://json-schema.org/understanding-json-schema/reference/generic.html).
- `enum`: Limits the field to a set of specified values. Additional information at [Enumerated Values](https://json-schema.org/understanding-json-schema/reference/generic.html#enumerated-values).
  - A Numeric field with `enum` within an array becomes a MultiSelect component.

**Examples:**

```javascript
// Regular numeric field
{
  "proxyTimeout": {
    "type": "number",
    "multipleOf": 10,
    "minimum": 10,
    "maximum": 1000,
    "examples": [50, 120, 870]
  }
}

// Numeric Select field
{
  "proxyTimeout": {
    "type": "number",
    "enum": [10, 20, 30, 40, 50]
  }
}

// Numeric MultiSelect field
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

### Object Field

Full specification: [<i class="fas fa-external-link-alt"></i>JSON-Schema: Object](https://json-schema.org/understanding-json-schema/reference/object.html)

Supported features:

- `properties`: An object consisting of key-value pairs, where the key is the field name (sent to the backend), and the value is one of the supported field types.
- `required`: An array listing the keys that must be provided.

**Example:**

```javascript
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

### Array Field

Full specification: [<i class="fas fa-external-link-alt"></i>JSON-Schema: Array](https://json-schema.org/understanding-json-schema/reference/array.html)

Supported features:

- `minItems` and `maxItems`: Define the minimum and maximum number of items in the array.
- `uniqueItems`: Specifies if the array should contain unique items.

**Example:**

```javascript
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
