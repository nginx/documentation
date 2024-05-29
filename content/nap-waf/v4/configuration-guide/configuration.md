---
description: This guide explains the NGINX App Protect WAF security features and how
  to use them.
docs: DOCS-647
doctypes:
- task
title: NGINX App Protect WAF Configuration Guide
toc: true
weight: 200
---

## Overview

This guide explains the NGINX App Protect WAF security features and how to use them. This guide also assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.

For more information on the NGINX App Protect WAF security features, see [NGINX App Protect WAF Terminology](#nginx-app-protect-waf-terminology).

{{< important >}}
When configuring NGINX App Protect WAF, `app_protect_enable` should always be enabled in a `proxy_pass` location. If configuration returns static content, the user must add a location which enables App Protect, and proxies the request via `proxy_pass` to the internal static content location. An example can be found in [Configure Static Location](#configure-static-location).
{{< /important >}}

## Supported Security Policy Features
{{< include "nap-waf/config/common/supported-security-policy-features.md" >}}

### Disallowed File Types
{{< include "nap-waf/config/common/disallowed-file-types.md" >}}

## Additional Policy Features
{{< include "nap-waf/config/common/additional-policy-features.md" >}}


## Attack Signatures Overview

{{< include "nap-waf/config/v4/attack-signatures-overview-v4.md" >}}


### Signature Settings

{{< include "nap-waf/config/common/signature-settings.md" >}}


### Signature Sets in Default Policy

{{< include "nap-waf/config/common/signature-sets-in-default-policy.md" >}}


### Basic Signature Sets Included in App Protect

{{< include "nap-waf/config/common/basic-signature-sets-included-in-app-protect.md" >}}

See [signature sets](#signature-sets) for configuring the signature sets included in your policy.

## Policy Configuration

{{< include "nap-waf/config/common/policy-configuration.md" >}}

### Policy Configuration Overview

{{< include "nap-waf/config/v4/policy-configuration-overview-v4.md" >}}

### Basic Configuration and the Default Policy

{{< include "nap-waf/config/v4/basic-config-and-default-policy-v4.md" >}}

### The Strict Policy

{{< include "nap-waf/config/v4/strict-policy-v4.md" >}}

### Policy Authoring and Tuning

{{< include "nap-waf/config/common/policy-authoring-and-tuning.md" >}}

### Anti Automation (Bot Mitigation)

{{< include "nap-waf/config/common/anti-automation.md" >}}

### Signature Sets

{{< include "nap-waf/config/common/signature-sets.md" >}}

### Partial Masking of Data using Data Guard
{{< include "nap-waf/config/common/partial-masking-of-data.md" >}}

#### File Types

{{< include "nap-waf/config/common/filetypes-and-responses.md" >}}

#### Parameters

{{< include "nap-waf/config/common/parameters-and-user-defined-urls.md" >}}

#### Do-Nothing

{{< include "nap-waf/config/common/do-nothing-and-user-defined-parameters.md" >}}


#### User-Defined Signatures

{{< include "nap-waf/config/common/user-defined-signatures.md" >}}
##### Updating nginx.conf
{{< include "nap-waf/config/v4/updating-nginx-conf-v4.md" >}}


#### User-Defined Signature Sets

{{< include "nap-waf/config/common/user-defined-signature-sets.md" >}}


#### User-Defined Browser Control

{{< include "nap-waf/config/common/user-defined-browser-control.md" >}}


#### Deny, Allow and Never Log Lists

{{< include "nap-waf/config/common/deny-allow-never-log-lists.md" >}}


#### CSRF Protection Using Origin Validation

{{< include "nap-waf/config/common/csrf-protection.md" >}}


#### Clickjacking Protection

{{< include "nap-waf/config/common/clickjacking-protection.md" >}}


### Detect Base64

{{< include "nap-waf/config/common/detect-base64.md" >}}

### Handling XML and JSON Content

{{< include "nap-waf/config/common/handling-xml-and-json-content.md" >}}

### Enforcer Cookie Settings

{{< include "nap-waf/config/common/enforcer-cookie-settings.md" >}}

### Additional Configuration Options


{{< include "nap-waf/config/common/additional-config-options.md" >}}

### Modifying Configurations

{{< include "nap-waf/config/common/modifying-configurations.md" >}}


## NGINX App Protect WAF Standalone Configuration

### apreload

{{< include "nap-waf/config/v4/apreload.md" >}}

### apreload Events

{{< include "nap-waf/config/v4/apreload-events.md" >}}

### Modification to nginx.conf file and App Protect Configurations
{{< include "nap-waf/config/v4/modification-to-nginx-conf.md" >}}

### Handling Concurrent Invocations of Apreload
{{< include "nap-waf/config/v4/handling-concurrent-invocations.md" >}}

### Limitation on HTTP Header and XFF Modification

{{< include "nap-waf/config/v4/limitation-on-http-header.md" >}}

## External References

{{< include "nap-waf/config/v4/external-references-v4.md" >}}

### Types of References

{{< include "nap-waf/config/common/types-of-references.md" >}}

## OpenAPI Specification File Reference

{{< include "nap-waf/config/v4/openapi-specification-file-reference-v4.md" >}}

### Types of OpenAPI References

{{< include "nap-waf/config/common/types-of-openapi-references.md" >}}

## gRPC Protection for Unary Traffic

{{< include "nap-waf/config/common/grpc-protection-unary-traffic.md" >}}

### gRPC Content Profiles

{{< include "nap-waf/config/common/grpc-content-profiles.md" >}}

### Associating Profiles with URLs

{{< include "nap-waf/config/common/associating-profiles-urls.md" >}}

### gRPC Response Pages

{{< include "nap-waf/config/common/grpc-response-pages.md" >}}

### Detect Base64 in String Values

{{< include "nap-waf/config/common/detect-base64-string-values.md" >}}

### Protocol Buffers Supported Version

{{< include "nap-waf/config/common/protocol-buffers-supported-version.md" >}}

### gRPC Server Reflection

{{< include "nap-waf/config/common/grpc-server-reflection.md" >}}

## gRPC Protection for Bidirectional Streaming

### Bidirectional Streaming Overview

{{< include "nap-waf/config/common/bidirectional-streaming-overview.md" >}}

### Configuration

{{< include "nap-waf/config/v4/bidirectional-configuration-v4.md" >}}

### gRPC Bidirectional Streaming Enforcement

{{< include "nap-waf/config/common/grpc-bidirectional-stream-enforcement.md" >}}

### Size Limits
{{< include "nap-waf/config/common/grpc-size-limits.md" >}}

### Message Compression

{{< include "nap-waf/config/common/grpc-message-compression.md" >}}

### Slow POST Attacks
{{< include "nap-waf/config/common/grpc-slow-post-attacks.md" >}}

### Handling Slow POST Attacks

{{< include "nap-waf/config/common/grpc-handling-slow-post-attacks.md" >}}

## Other gRPC References

### gRPC Violations

{{< include "nap-waf/config/common/grpc-violations.md" >}}

### gRPC Logging

{{< include "nap-waf/config/v4/grpc-logging-v4.md" >}}

## Securing GraphQL APIs with NGINX App protect WAF

### GraphQL Overview
{{< include "nap-waf/config/common/graphql-overview.md" >}}

### GraphQL Security
{{< include "nap-waf/config/common/graphql-security.md" >}}


## Enabling GraphQL with Basic Configuration

{{< include "nap-waf/config/v4/enabling-graphql-v4.md" >}}

## GraphQL Advanced Configuration
{{< include "nap-waf/config/common/graphql-advanced-config.md" >}}

### GraphQL Violations
{{< include "nap-waf/config/common/graphql-violations.md" >}}
### GraphQL Profile

{{< include "nap-waf/config/v4/graphql-profile-v4.md" >}}

### Define URL settings
{{< include "nap-waf/config/common/graphql-define-url-settings.md" >}}

### Associating GraphQL Profiles with URL
{{< include "nap-waf/config/common/associating-graphql-profiles.md" >}}

### GraphQL Response Pages

{{< include "nap-waf/config/common/graphql-response-pages.md" >}}

## Override Rules

### Override Rules Overview

{{< include "nap-waf/config/common/override-rules-overview.md" >}}

### Condition Syntax Usage

{{< include "nap-waf/config/v4/condition-syntax-usage-v4.md" >}}

### First Match Principle

{{< include "nap-waf/config/common/first-match-principle.md" >}}

### Important Things to Remember About Override Rules

{{< include "nap-waf/config/common/important-things-override-rules.md" >}}


### Override Rules Logging & Reporting

{{< include "nap-waf/config/common/override-rules-logging-reporting.md" >}}

### Errors and Warnings

{{< include "nap-waf/config/common/override-rules-errors-warnings.md" >}}

## Geolocation

### Overview

{{< include "nap-waf/config/common/geolocation-overview.md" >}}

### Disallowing Application Use in Certain Geolocations

{{< include "nap-waf/config/common/disallow-application-use-geolocation.md" >}}

### Geolocation in Policy Override Rules Conditions

{{< include "nap-waf/config/common/geolocation-override-rules.md" >}}


## JSON Web Token Protection

### Overview
{{< include "nap-waf/config/common/json-web-token-overview.md" >}}

### Configuring NGINX App Protect WAF to Authenticate JSON Web Token

#### Access Profile

{{< include "nap-waf/config/v4/json-web-tokens-access-profile-v4.md" >}}

### Authorization Rules in URLs

{{< include "nap-waf/config/v4/json-web-tokens-auth-rules-urls.md" >}}

### Attack Signatures

{{< include "nap-waf/config/common/json-web-tokens-attack-sigs.md" >}}


### JSON Web Token Violations

{{< include "nap-waf/config/common/json-web-tokens-violations.md" >}}

### Violation Rating Calculation
{{< include "nap-waf/config/common/json-web-tokens-violation-rating.md" >}}

### Other References
{{< include "nap-waf/config/common/json-web-tokens-other-references.md" >}}


## Custom Dimensions Log Entries

### Overview

{{< include "nap-waf/config/common/custom-log-overview.md" >}}

### Configuration

{{< include "nap-waf/config/common/custom-log-configuration.md" >}}

### Things to Remember While Configuring the Custom Dimensions Log Entries

{{< include "nap-waf/config/common/custom-log-things-to-remember.md" >}}

### Errors and Warnings

{{< include "nap-waf/config/common/custom-log-errors-warnings.md" >}}

### Logging and Reporting

{{< include "nap-waf/config/common/custom-log-logging-reporting.md" >}}


## Time-Based Signature Staging

{{< include "nap-waf/config/common/time-based-sig-overview.md" >}}


### Latest Signature Certification Time

{{< include "nap-waf/config/common/time-based-sig-latest-cert-time.md" >}}


### New Policy

{{< include "nap-waf/config/common/time-based-sig-new-policy.md" >}}


### Signature Update

{{< include "nap-waf/config/common/time-based-sig-update-sig.md" >}}


### Configuration

#### Staging Certification Date-Time

{{< include "nap-waf/config/common/time-based-sig-config.md" >}}


### Enforcing the Modified Signatures After Testing Them

{{< include "nap-waf/config/common/time-based-sig-enforce-mod-sig.md" >}}


### Logging and Reporting

{{< include "nap-waf/config/common/time-based-sig-log-report.md" >}}



## Directives

### Global Directives

{{< include "nap-waf/config/v4/global-directives-v4.md" >}}


### App Protect Specific Directives

{{< include "nap-waf/config/v4/app-protect-directives-v4.md" >}}

## Violations

{{< include "nap-waf/config/common/violations.md" >}}


### Supported Violations

 {{< include "nap-waf/config/common/supported-violations.md" >}}


### HTTP Compliance Sub-Violations

{{< include "nap-waf/config/common/http-compliance-subviolations.md" >}}


### Evasion Techniques Sub-Violations

{{< include "nap-waf/config/common/evasion-techniques-subviolations.md" >}}


## Attack Types

{{< include "nap-waf/config/common/attack-types.md" >}}


## Converter Tools

{{< include "nap-waf/config/common/converter-tools.md" >}}

### Policy Converter
{{< include "nap-waf/config/v4/policy-converter-v4.md" >}}

### User Defined Signatures Converter

{{< include "nap-waf/config/v4/user-defined-sigs-converter-v4.md" >}}

## Attack Signature Report Tool

{{< include "nap-waf/config/v4/attack-sig-reporter-tool-v4.md" >}}


## Security Logs

{{< include "nap-waf/config/v4/security-logs-v4.md" >}}

## NGINX App Protect WAF Terminology

{{< include "nap-waf/config/common/nginx-app-protect-waf-terminology.md" >}}


## Interaction with NGINX Features

Below are examples of how to configure various NGINX features with NGINX App Protect WAF.

### Configure Static Location

{{< include "nap-waf/config/common/configure-static-location.md" >}}

### Configure Ranges

{{< include "nap-waf/config/common/configure-ranges.md" >}}

### Configure Slice

{{< include "nap-waf/config/common/configure-slice.md" >}}

### Configure NGINX mirror

{{< include "nap-waf/config/common/configure-nginx-mirror.md" >}}

### Configure njs

{{< include "nap-waf/config/common/configure-njs.md" >}}

### Configure Client Authorization

{{< include "nap-waf/config/common/configure-client-authorization.md" >}}


### Unsupported Configuration

{{< include "nap-waf/config/common/unsupported-configuration.md" >}}
