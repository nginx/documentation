---
title: "Add cookies"
weight: 350
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

# Managing Cookies in NAP Policy
Cookies can be configured and managed directly within the policy editor by selecting the **Cookies** option.

## Cookie Properties and Types
Each cookie configuration includes:
- `Cookie Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/nap-policy-matching-types.md" >}}) section.
- `Cookie Name`: The name of the cookie to be monitored or protected
- `Enforcement Type`: 
  - **Allow**: Permits the cookie with optional attack signature checks
  - **Disallow**: Blocks the use of the cookie entirely
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable
- `Mask Value in Logs`: When enabled, the cookie's value will be masked in the request log for enhanced security and privacy

**⚠️ Important:** Attack Signatures are automatically set to "Not Applicable" when Enforcement Type is set to `Disallow` since the URL is explicitly blocked and signature checking is unnecessary.

For a complete list of configurable cookie properties and options, see the [Cookie Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `cookies` section.

## Cookie Violations
Click on **Edit Configuration** to configure cookie violations. The following violations can be configured for cookies:

- `VIOL_COOKIE_EXPIRED`: Triggered when a cookie's timestamp is expired
- `VIOL_COOKIE_LENGTH`: Triggered when cookie length exceeds the configured limit
- `VIOL_COOKIE_MALFORMED`: Triggered when cookies are not RFC-compliant
- `VIOL_COOKIE_MODIFIED`: Triggered when domain cookies have been tampered with

For each violation type, you can:
- Set the enforcement action
- Toggle `alarm` and `block` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

# Adding a Cookie to Your Policy

1. Choose Cookie Type:
   - Select either `Explicit` for exact cookie matching or `Wildcard` for pattern-based matching

2. Configure Basic Properties:
   - Enter the `Cookie Name`
   - Choose whether to mask the cookie value in logs

3. Set Enforcement:
   - Choose whether to allow or disallow the cookie
   - If `Allow Cookie` is selected, you can optionally enable attack signatures

**⚠️ Important:** Attack signatures cannot be enabled for disallowed cookies.

4. Optional: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific cookie
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

5. Click **Add Cookie** to save your configuration
