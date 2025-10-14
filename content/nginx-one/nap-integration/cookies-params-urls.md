---
title: "Add cookies, parameters and URLs"
weight: 400
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

# Add cookies

Cookie protections can be configured and managed directly within the policy editor by selecting the **Cookies** option.

## Cookie properties and types

Each cookie configuration includes:
- `Cookie Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/nap-integration/waf-policy-matching-types.md" >}}) section.
- `Cookie Name`: The name of the cookie to be monitored or protected
- `Enforcement Type`: 
  - **Allow**: Specifies that this cookie may be changed by the client. The cookie is not protected from modification
  - **Enforce**: Specifies that this cookie may not be changed by the client
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable
- `Mask value in logs`: When enabled, the cookie's value will be masked in the request log for enhanced security and privacy

For a complete list of configurable cookie properties and options, see the [Cookie Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `cookies` section.

## Cookie violations

Select **Edit Configuration** to configure cookie violations. The following violations can be configured for cookies:

- `VIOL_COOKIE_EXPIRED`: Triggered when a cookie's timestamp is expired
- `VIOL_COOKIE_LENGTH`: Triggered when cookie length exceeds the configured limit
- `VIOL_COOKIE_MALFORMED`: Triggered when cookies are not RFC-compliant
- `VIOL_COOKIE_MODIFIED`: Triggered when domain cookies have been tampered with

For each violation type, you can:
- Set the enforcement action
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

## Add a cookie to your policy

1. Choose Cookie Type:
   - Select either `Explicit` for exact cookie matching or `Wildcard` for pattern-based matching

1. Configure Basic Properties:
   - Enter the `Cookie Name`
   - Choose whether to mask the cookie value in logs

1. Set Enforcement Type:
   - Choose either `Allow` or `Enforce`

1. Optional: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific cookie
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

1. Select **Add Cookie** to save your configuration

# Add parameters

Parameter protections can be configured and managed directly within the policy editor by selecting the **Parameters** option.

## Parameter properties and types

Each parameter configuration includes:
- `Parameter Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/nap-integration/waf-policy-matching-types.md" >}}) section.
- `Parameter Name`: The name of the parameter
- `Location`: Where the parameter is expected (URL query string, POST data, etc.)
- `Value Type`: The expected type of the parameter value (e.g., alpha-numeric, integer, email)
- `Attack Signatures`: Whether attack signature checking is enabled for this parameter
- `Mask value in logs`: When enabled, the parameter's value will be masked in the request log for enhanced security and privacy. This sets `sensitiveParameter` property of the parameter item.

For a complete list of configurable parameter properties and options, see the [Parameter Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `parameters` section.

## Parameter violations

Select **Edit Configuration** to configure parameter violations. The following violations can be configured for parameters:

- `VIOL_PARAMETER`: Triggered when an illegal parameter is detected
- `VIOL_PARAMETER_ARRAY_VALUE`: Triggered when an array parameter value is illegal
- `VIOL_PARAMETER_DATA_TYPE`: Triggered when parameter data type doesn't match configured security policy
- `VIOL_PARAMETER_EMPTY_VALUE`: Triggered when a parameter value is empty but shouldn't be
- `VIOL_PARAMETER_LOCATION`: Triggered when a parameter is found in wrong location
- `VIOL_PARAMETER_MULTIPART_NULL_VALUE`: Triggered when the multi-part request has a parameter value that contains the NULL character (0x00)
- `VIOL_PARAMETER_NAME_METACHAR`: Triggered when illegal meta characters are found in parameter name
- `VIOL_PARAMETER_NUMERIC_VALUE`: Triggered when numeric parameter value is outside allowed range
- `VIOL_PARAMETER_REPEATED`: Triggered when a parameter name is repeated illegally
- `VIOL_PARAMETER_STATIC_VALUE`: Triggered when a static parameter value doesn't match configured security policy
- `VIOL_PARAMETER_VALUE_BASE64`: Triggered when the value is not a valid Base64 string
- `VIOL_PARAMETER_VALUE_LENGTH`: Triggered when parameter value length exceeds limits
- `VIOL_PARAMETER_VALUE_METACHAR`: Triggered when illegal meta characters are found in parameter value
- `VIOL_PARAMETER_VALUE_REGEXP`: Triggered when parameter value doesn't match required pattern

For each violation type, you can:
- Set the enforcement action
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

## Add a parameter to your policy

1. Choose Parameter Type:
   - Select either `Explicit` for exact parameter matching or `Wildcard` for pattern-based matching

1. Configure Basic Properties:
   - Enter the parameter `Parameter Name`
   - Select the `Location` where the parameter is expected
   - Choose the `Value Type` (alpha-numeric, integer, email, etc.)
   - Set the `Data Type` if applicable

1. Set Security Options:
   - Choose whether to enable attack signatures
   
   {{< call-out "important" >}}

   Attack Signatures are only applicable when the Value Type is `User Input` or `Array` **and** the Data Type is either `Alphanumeric` or `Binary`

   {{< /call-out >}}

   - Decide if parameter value should be masked in logs which sets `sensitiveParameter` in [Parameter Configuration Reference]({{< ref "/waf/policies/parameter-reference.md" >}})

1. Optional: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific parameter
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

1. Select **Add Parameter** to save your configuration

# Add URLs

URL protections can be configured and managed directly within the policy editor by selecting the **URLs** option.

## URL properties and types

Each URL configuration includes:
- `URL Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/nap-integration/waf-policy-matching-types.md" >}}) section.
- `Method`: Specifies the HTTP method(s) for the URL (`GET`, `POST`, `PUT`, etc.)
- `Protocol`: The protocol for the URL (`HTTP`/`HTTPS`)
- `Enforcement Type`: 
  - **Allow**: Permits access to the URL with optional attack signature checks
  - **Disallow**: Blocks access to the URL entirely
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable

{{< call-out "important" >}}

**⚠️ Important:** Attack Signatures are automatically shown as "Not Applicable" when Enforcement Type is set to `Disallow` since the URL is explicitly blocked and signature checking is unnecessary.

{{< /call-out >}}

For a complete list of configurable URL properties and options, see the [URL Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `urls` section.

## URL violations

Select **Edit Configuration** to configure URL violations. The following violations can be configured for URLs:

- `VIOL_URL`: Triggered when an illegal URL is accessed
- `VIOL_URL_CONTENT_TYPE`: Triggered when there's an illegal request content type
- `VIOL_URL_LENGTH`: Triggered when URL length exceeds the configured limit
- `VIOL_URL_METACHAR`: Triggered when illegal meta characters are found in the URL

For each violation type, you can:
- Set the enforcement action
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

## Add a URL to your policy

1. Choose URL Type:
   - Select either `Explicit` for exact URL matching or `Wildcard` for pattern-based matching

1. Configure Basic Properties:
   - Enter the `URL` path (e.g., `/index.html`, `/api/data`)
      - The URL path must start with `/`
   - Select HTTP `Method(s)` (e.g., `GET`, `POST`, *)
   - Choose the `Protocol` (`HTTP`/`HTTPS`)

1. Set Enforcement:
   - Choose whether to allow or disallow the URL
   - If `Allow URL` is selected, you can optionally enable attack signatures

   {{< call-out "important" >}}

   **⚠️ Important:** Attack signatures cannot be enabled for disallowed URLs.

   {{< /call-out >}}

1. **Optional**: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific URL
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

1. Select **Add URL** to save your configuration
