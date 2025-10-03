---
title: "Advanced configuration for NAP policies"
weight: 350
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

# Advanced Configuration for NAP Policies

This document consolidates advanced configuration options for parameters, URLs, and cookies in NGINX App Protect (NAP) policies. These configurations allow for fine-tuning security settings to meet specific application requirements. By centralizing these options, this guide provides a unified reference for creating granular and robust security policies.

## Shared Advanced Configuration Options

The following advanced configuration options are common to parameters, URLs, and cookies:

- **Length Restrictions**: Define maximum allowable lengths to prevent excessively long inputs that could indicate malicious activity.
- **Meta Character Overrides**: Specify allowed or disallowed meta characters to ensure compliance with application-specific requirements.
- **Custom Signature Sets**: Apply custom signature sets to tailor attack detection mechanisms for specific use cases.

## Parameter-Specific Configuration Options

In addition to the shared options, parameters support the following advanced configurations:

- **Regular Expression Patterns**: Use regex patterns to validate parameter values against expected formats, enhancing security and reducing false positives.
- **Static Value Constraints**: Set fixed values for parameters to enforce strict compliance with predefined rules.
- **Numeric Value Ranges**: Define acceptable numeric ranges for parameters to prevent out-of-bound values.

## URL-Specific Configuration Options

In addition to the shared options, URLs support the following advanced configurations:

- **Content Type Profiles**: Configure content type profiles (e.g., JSON, XML, form-data) to validate request payloads.

## Cookie-Specific Configuration Options

In addition to the shared options, cookies support the following advanced configurations:

- **Mask Value in Logs**: Enable masking of cookie values in logs for enhanced security and privacy.

These configurations help create a more granular and specific security policy for your application. For detailed instructions on implementing these options, refer to the [Policy Parameter Reference]({{< ref "/waf/policies/parameter-reference.md" >}}).
