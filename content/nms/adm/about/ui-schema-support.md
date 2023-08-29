---
title: "Web Interface JSON Schema Support "
description: "Overview of what parts of JSON schema are supported by the NGINX Management Suite App Delivery Manager web interface."
weight: 500
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-1258"
---

{{< custom-styles>}}

## Overview

The web interface has limited support for [JSON schema](https://json-schema.org/understanding-json-schema/reference/). This document describes what is supported. The web interface will not render properly if JSON schema features outside this document are used. 

- `type`
  - [Boolean](#boolean-field)
  - [String](#string-field)
  - [Numeric](#numeric-field)
  - [Object](#object-field)
  - [Array](#array-field)
- `title`
- `description`

## Boolean field support

Example:

```javascript
{
  "boolField1": {
    "type": "boolean"
  }
}
```

Exception: `required` boolean fields are not supported.

Reference: [boolean](https://json-schema.org/understanding-json-schema/reference/boolean.html)

## String field

Supported features:
- `pattern` 
- `minLength`
- `maxLength`
- `examples` 
- `enum`

Example:

```javascript
// Regular string field
{
  "test": {
    "type": "string",
    "pattern": "^[A-Za-z0-9\s]*$",
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

Reference: [string](https://json-schema.org/understanding-json-schema/reference/string.html)

### Numeric field

Supported types:

- `integer` (integral numbers) 
- `number` (float).

Supported features:
- `multipleOf`
- `exclusiveMinimum`
- `exclusiveMaximum`
- `minimum`
- `maximum`
- `examples`
- `enum`

Example:

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

Reference: [numeric](https://json-schema.org/understanding-json-schema/reference/numeric.html).

### Object field

Supported features:
- `properties`
- `required`

Example:

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

Reference: [object](https://json-schema.org/understanding-json-schema/reference/object.html).

### Array field

Supported features:

- `minItems` – minimum number of items in array
- `maxItems` – maximum number of items in array
- `uniqueItems` – if array should cosist of unique items or not

Example:

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

Reference: [array](https://json-schema.org/understanding-json-schema/reference/array.html).



