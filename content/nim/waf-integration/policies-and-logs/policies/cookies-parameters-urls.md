---
title: Add cookies, parameters, and URLs
description: Configure cookie, parameter, and URL protections in your F5 WAF for NGINX policies using NGINX Instance Manager.
toc: true
weight: 500
nd-content-type: how-to
nd-product: NIM
nd-docs: 
---

## Add cookies

Cookie protections can be configured and managed directly in the policy editor by selecting **Cookies** in the web interface.

### Cookie properties and types

Each cookie configuration includes:

- `Cookie Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see [Matching Types: Explicit vs Wildcard]({{< ref "/nim/waf-integration/policies-and-logs/policies/waf-policy-matching-types.md" >}}).
- `Cookie Name`: The name of the cookie to monitor or protect.
- `Enforcement Type`:
  - **Allow**: The cookie can be changed by the client and is not protected from modification.
  - **Enforce**: The cookie cannot be changed by the client.
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable.
- `Mask value in logs`: When enabled, the cookie's value is masked in the request log for improved security and privacy.

For a complete list of configurable cookie properties and options, see the [Cookie Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `cookies` section.

### Cookie violations

Select **Edit configuration** to configure cookie violations. The following violations can be configured for cookies:

- `VIOL_COOKIE_EXPIRED`: Triggered when a cookie's timestamp is expired.
- `VIOL_COOKIE_LENGTH`: Triggered when a cookie length exceeds the configured limit.
- `VIOL_COOKIE_MALFORMED`: Triggered when cookies are not RFC-compliant.
- `VIOL_COOKIE_MODIFIED`: Triggered when domain cookies have been tampered with.

For each violation type, you can:

- Set the enforcement action.
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings.

See [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

### Add a cookie to your policy

1. Choose a **Cookie Type**:
   - Select either `Explicit` for exact cookie matching or `Wildcard` for pattern-based matching.
2. Configure basic properties:
   - Enter the `Cookie Name`.
   - Choose whether to mask the cookie value in logs.
3. Set an **Enforcement Type**:
   - Choose either `Allow` or `Enforce`.
4. (Optional) Configure attack signatures:
   - If enabled, you can override attack signatures for this cookie.
   - For details on signature configuration, see [Add Signature Sets]({{< ref "/nim/waf-integration/policies-and-logs/policies/add-signature-sets.md" >}}).
5. Select **Add cookie** to save your configuration.

## Add parameters

Parameter protections can be configured and managed directly in the policy editor by selecting **Parameters** in the web interface.

### Parameter properties and types

Each parameter configuration includes:

- `Parameter Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see [Matching Types: Explicit vs Wildcard]({{< ref "/nim/waf-integration/policies-and-logs/policies/waf-policy-matching-types.md" >}}).
- `Parameter Name`: The name of the parameter.
- `Location`: Where the parameter is expected (URL query string, POST data, etc.).
- `Value Type`: The expected type of the parameter value (for example, alphanumeric, integer, or email).
- `Attack Signatures`: Whether attack signature checking is enabled for this parameter.
- `Mask value in logs`: When enabled, the parameter's value is masked in the request log for enhanced security and privacy. This sets the `sensitiveParameter` property of the parameter item.

For a complete list of configurable parameter properties and options, see the [Parameter Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `parameters` section.

### Parameter violations

Select **Edit configuration** to configure parameter violations. The following violations can be configured for parameters:

- `VIOL_PARAMETER`: Triggered when an illegal parameter is detected.
- `VIOL_PARAMETER_ARRAY_VALUE`: Triggered when an array parameter value is illegal.
- `VIOL_PARAMETER_DATA_TYPE`: Triggered when a parameter’s data type doesn’t match the configured policy.
- `VIOL_PARAMETER_EMPTY_VALUE`: Triggered when a parameter value is empty but shouldn’t be.
- `VIOL_PARAMETER_LOCATION`: Triggered when a parameter is found in the wrong location.
- `VIOL_PARAMETER_MULTIPART_NULL_VALUE`: Triggered when the multi-part request has a parameter value that contains a null character (`0x00`).
- `VIOL_PARAMETER_NAME_METACHAR`: Triggered when illegal meta characters are found in a parameter name.
- `VIOL_PARAMETER_NUMERIC_VALUE`: Triggered when a numeric parameter value is outside the allowed range.
- `VIOL_PARAMETER_REPEATED`: Triggered when a parameter name is repeated illegally.
- `VIOL_PARAMETER_STATIC_VALUE`: Triggered when a static parameter value doesn’t match the configured security policy.
- `VIOL_PARAMETER_VALUE_BASE64`: Triggered when the value isn’t a valid Base64 string.
- `VIOL_PARAMETER_VALUE_LENGTH`: Triggered when a parameter value length exceeds limits.
- `VIOL_PARAMETER_VALUE_METACHAR`: Triggered when illegal meta characters are found in a parameter value.
- `VIOL_PARAMETER_VALUE_REGEXP`: Triggered when a parameter value doesn’t match the required pattern.

For each violation type, you can:

- Set the enforcement action.
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings.

See [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

### Add a parameter to your policy

1. Choose a **Parameter Type**:
   - Select either `Explicit` for exact parameter matching or `Wildcard` for pattern-based matching.
2. Configure basic properties:
   - Enter the `Parameter Name`.
   - Select the `Location` where the parameter is expected.
   - Choose the `Value Type` (alphanumeric, integer, email, etc.).
   - Set the `Data Type` if applicable.
3. Set security options:
   - Choose whether to enable attack signatures.

   {{< call-out "important" >}}
   Attack signatures are only applicable when the Value Type is `User Input` or `Array`, and the Data Type is either `Alphanumeric` or `Binary`.
   {{< /call-out >}}

   - Decide if parameter values should be masked in logs. This sets the `sensitiveParameter` property.
4. (Optional) Configure attack signatures:
   - If enabled, you can override attack signatures for this parameter.
   - For details on signature configuration, see [Add Signature Sets]({{< ref "/nim/waf-integration/policies-and-logs/policies/add-signature-sets.md" >}}).
5. Select **Add parameter** to save your configuration.

## Add URLs

URL protections can be configured and managed directly in the policy editor by selecting **URLs** in the web interface.

### URL properties and types

Each URL configuration includes:

- `URL Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see [Matching Types: Explicit vs Wildcard]({{< ref "/nim/waf-integration/policies-and-logs/policies/waf-policy-matching-types.md" >}}).
- `Method`: Specifies the HTTP method(s) for the URL (`GET`, `POST`, `PUT`, etc.).
- `Protocol`: The protocol for the URL (`HTTP` or `HTTPS`).
- `Enforcement Type`:
  - **Allow**: Permits access to the URL with optional attack signature checks.
  - **Disallow**: Blocks access to the URL entirely.
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable.

{{< call-out "important" >}}
Attack signatures are automatically shown as “Not applicable” when the Enforcement Type is set to `Disallow`, since the URL is explicitly blocked and signature checking is unnecessary.
{{< /call-out >}}

For a complete list of configurable URL properties and options, see the [URL Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `urls` section.

### URL violations

Select **Edit configuration** to configure URL violations. The following violations can be configured for URLs:

- `VIOL_URL`: Triggered when an illegal URL is accessed.
- `VIOL_URL_CONTENT_TYPE`: Triggered when there’s an illegal request content type.
- `VIOL_URL_LENGTH`: Triggered when the URL length exceeds the configured limit.
- `VIOL_URL_METACHAR`: Triggered when illegal meta characters are found in the URL.

For each violation type, you can:

- Set the enforcement action.
- Toggle `Alarm`, `Alarm and Block`, or `Disabled` settings.

See [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

### Add a URL to your policy

1. Choose a **URL Type**:
   - Select either `Explicit` for exact URL matching or `Wildcard` for pattern-based matching.
2. Configure basic properties:
   - Enter the `URL` path (for example, `/index.html`, `/api/data`).
   - The URL path must start with `/`.
   - Select the HTTP `Method(s)` (for example, `GET`, `POST`, `*`).
   - Choose the `Protocol` (`HTTP` or `HTTPS`).
3. Set enforcement:
   - Choose whether to allow or disallow the URL.
   - If **Allow** is selected, you can optionally enable attack signatures.

   {{< call-out "important" >}}
   Attack signatures cannot be enabled for disallowed URLs.
   {{< /call-out >}}

4. (Optional) Configure attack signatures:
   - If enabled, you can override attack signatures for this specific URL.
   - For details on signature configuration, see [Add Signature Sets]({{< ref "/nim/waf-integration/policies-and-logs/policies/add-signature-sets.md" >}}).
5. Select **Add URL** to save your configuration.