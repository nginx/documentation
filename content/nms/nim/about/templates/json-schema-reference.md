---
title: "JSON Schemas for Dynamic Web Forms"
date: 2024-03-20T09:07:22-07:00
# Change draft status to false to publish doc
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
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

## Overview

NGINX Instance Manager's dynamic web form builder uses JSON schemas to guide and validate user inputs for creating NGINX configurations. This approach simplifies the configuration process by providing a structured and intuitive input method, ensuring that the entered parameters adhere to NGINX configuration requirements. 

## JSON Schema

JSON Schema is a standard explained in detail at [json-schema.org](https://json-schema.org/).

In NGINX Instance Manager, we support a specific set of common features from the JSON Schema:

- **Type**: This defines the kind of data a field can hold. More information is available at [Type Definitions](https://json-schema.org/understanding-json-schema/reference/type.html). Currently, our support is for fields that can either be a `string` or an array with just one `string`. Exceptionally, we also handle fields defined with two types, where one is `null` (like `["object", "null"]`). Here, we ignore the `null` and focus on the other type. This approach matches the needs of our backend, which also uses JSON Schema. Supported types include:
  - [Boolean](#boolean-field): True or false values.
  - [String](#string-field): Text.
  - [Numeric](#numeric-field): Numbers, both whole and decimal.
  - [Object](#object-field): Structures with named properties.
  - [Array](#array-field): Lists of items.
- **Title**: A clear, friendly name for a form field, telling users what information is needed. For more on this, visit [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html).
- **Description**: Helps users understand what to enter into a field. See [Generic Keywords](https://json-schema.org/understanding-json-schema/reference/generic.html) for additional details.

This chosen set of JSON Schema features makes the dynamic form builder in NGINX Instance Manager straightforward to use while covering the usual needs for configuring NGINX. It helps make the configuration process clearer and reduces mistakes, allowing users to configure and manage NGINX instances with ease.

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
