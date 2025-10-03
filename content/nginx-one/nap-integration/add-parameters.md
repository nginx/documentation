---
title: "Add parameters"
weight: 400
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

Parameters can be configured and managed directly within the policy editor by selecting the **Parameters** option.

## Parameter Properties and Types
Each parameter configuration includes:
- `Parameter Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/nap-integration/waf-policy-matching-types.md" >}}) section.
- `Name`: The name of the parameter
- `Location`: Where the parameter is expected (URL query string, POST data, etc.)
- `Value Type`: The expected type of the parameter value (e.g., alpha-numeric, integer, email)
- `Attack Signatures`: Whether attack signature checking is enabled for this parameter
- `Mask Value in Logs`: When enabled, the parameter's value will be masked in the request log for enhanced security and privacy


For a complete list of configurable cookie properties and options, see the [Parameter Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `parameters` section.

## Parameter Violations
Click on **Edit Configuration** to configure parameter violations. The following violations can be configured for parameters:

- `VIOL_PARAMETER`: Triggered when an illegal parameter is detected
- `VIOL_PARAMETER_ARRAY_VALUE`: Triggered when an array parameter value is illegal
- `VIOL_PARAMETER_DATA_TYPE`: Triggered when parameter data type doesn't match configuration
- `VIOL_PARAMETER_EMPTY_VALUE`: Triggered when a parameter value is empty but shouldn't be
- `VIOL_PARAMETER_LOCATION`: Triggered when a parameter is found in wrong location
- `VIOL_PARAMETER_NAME_METACHAR`: Triggered when illegal meta characters are found in parameter name
- `VIOL_PARAMETER_NUMERIC_VALUE`: Triggered when numeric parameter value is outside allowed range
- `VIOL_PARAMETER_REPEATED`: Triggered when a parameter name is repeated illegally
- `VIOL_PARAMETER_STATIC_VALUE`: Triggered when a static parameter value doesn't match configuration
- `VIOL_PARAMETER_VALUE_LENGTH`: Triggered when parameter value length exceeds limits
- `VIOL_PARAMETER_VALUE_METACHAR`: Triggered when illegal meta characters are found in parameter value
- `VIOL_PARAMETER_VALUE_REGEXP`: Triggered when parameter value doesn't match required pattern

For each violation type, you can:
- Set the enforcement action
- Toggle `alarm` and `block` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

# Adding a Parameter to Your Policy

1. Choose Parameter Type:
   - Select either `Explicit` for exact parameter matching or `Wildcard` for pattern-based matching

1. Configure Basic Properties:
   - Enter the parameter `Name`
   - Select the `Location` where the parameter is expected
   - Choose the `Value Type` (alpha-numeric, integer, email, etc.)
   - Set the `Data Type` if applicable

1. Set Security Options:
   - Choose whether to enable attack signatures
   - Decide if parameter value should be masked in logs which sets `sensitiveParameter` in [Parameter Configuration Reference]({{< ref "/waf/policies/parameter-reference.md" >}})

1. Optional: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific parameter
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

1. Click **Add Parameter** to save your configuration
