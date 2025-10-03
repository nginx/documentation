---
title: "Add urls"
weight: 350
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

# Managing URLs in F5 WAF Policy
URLs can be configured and managed directly within the policy editor by selecting the **URLs** option.

## URL Properties and Types
Each URL configuration includes:
- `URL Type`: `Explicit` or `Wildcard`. For details on explicit and wildcard matching, see the [Matching Types: Explicit vs Wildcard]({{< ref "/nginx-one/waf-policy-matching-types.md" >}}) section
- `Method`: Specifies which HTTP methods are allowed (`GET`, `POST`, `PUT`, etc.)
- `Protocol`: The protocol for the URL (`HTTP`/`HTTPS`)
- `Enforcement Type`: 
  - **Allow**: Permits access to the URL with optional attack signature checks
  - **Disallow**: Blocks access to the URL entirely
- `Attack Signatures`: Indicates whether attack signatures and threat campaigns are enabled, disabled, or not applicable

**⚠️ Important:** Attack Signatures are automatically set to "Not Applicable" when Enforcement Type is set to `Disallow` since the URL is explicitly blocked and signature checking is unnecessary.

For a complete list of configurable URL properties and options, see the [URL Configuration Parameters]({{< ref "/waf/policies/parameter-reference.md" >}}) documentation under the `urls` section.

## URL Violations
Click on **Edit Configuration** to configure URL violations. The following violations can be configured for URLs:

- `VIOL_URL`: Triggered when an illegal URL is accessed
- `VIOL_URL_CONTENT_TYPE`: Triggered when there's an illegal request content type
- `VIOL_URL_LENGTH`: Triggered when URL length exceeds the configured limit
- `VIOL_URL_METACHAR`: Triggered when illegal meta characters are found in the URL

For each violation type, you can:
- Set the enforcement action
- Toggle `alarm` and `block` settings

For more details about enforcement modes, see the [Glossary]({{< ref "/nginx-one/glossary.md#nginx-app-protect-waf-terminology" >}}), specifically the entry: **Enforcement mode**.

See the [Supported Violations]({{< ref "/waf/policies/violations.md#supported-violations" >}}) for additional details.

# Adding a URL to Your Policy

1. Choose URL Type:
   - Select either `Explicit` for exact URL matching or `Wildcard` for pattern-based matching

1. Configure Basic Properties:
   - Enter the `URL` path
   - Select allowed `Method(s)` (e.g., `GET`, `POST`, *)
   - Choose the `Protocol` (`HTTP`/`HTTPS`)

1. Set Enforcement:
   - Choose whether to allow or disallow the URL
   - If `Allow URL` is selected, you can optionally enable attack signatures
   - **⚠️ Important:** Attack signatures cannot be enabled for disallowed URLs.

1. **Optional**: Configure Attack Signatures
   - If enabled, you can overwrite attack signatures for this specific URL
   - For details on signature configuration, refer to the documentation on [Add Signature Sets]({{< ref "/nginx-one/nap-integration/add-signature-sets.md/" >}})

1. Click **Add URL** to save your configuration
