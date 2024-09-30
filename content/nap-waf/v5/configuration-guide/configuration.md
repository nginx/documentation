---
description: This guide explains the F5 NGINX App Protect WAF security features and how
  to use them.
docs: DOCS-1368
doctypes:
- task
title: NGINX App Protect WAF Configuration Guide
toc: true
weight: 200
---

## Overview

This guide explains the F5 NGINX App Protect WAF security features and how to use them. This guide also assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.

For more information on the NGINX App Protect WAF security features, see [NGINX App Protect WAF Terminology](#nginx-app-protect-waf-terminology).


## Supported Security Policy Features

{{< include "nap-waf/config/v5/supported-security-policy-features-v5.md" >}}

### Disallowed File Types

{{< include "nap-waf/config/common/disallowed-file-types.md" >}}

## Additional Policy Features

{{< include "nap-waf/config/common/additional-policy-features.md" >}}

## Attack Signatures Overview

{{< include "nap-waf/config/v5/attack-signatures-overview-v5.md" >}}

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

{{< include "nap-waf/config/v5/policy-configuration-overview-v5.md" >}}

### Basic Configuration and the Default Policy

{{< include "nap-waf/config/v5/basic-config-and-default-policy-v5.md" >}}

### The Strict Policy

{{< include "nap-waf/config/v5/strict-policy-v5.md" >}}

### Default Policy Bundles

NGINX App Protect WAF offers prebuilt bundles for security policies:

- app_protect_default_policy
- app_protect_strict_policy

{{< important >}}
You cannot mix these prebuilt bundles with custom policy bundles within the same `nginx.conf` file.
{{< /important >}}

Example:

```nginx
    ...
    location / {

        # NGINX App Protect WAF
        app_protect_enable on;
        app_protect_policy_file app_protect_strict_policy;
        app_protect_security_log_enable on;
        app_protect_security_log log_all stderr;

        proxy_pass http://127.0.0.1:8080/;
    }
```

### Updating Default Policy Bundles

{{< note >}}
This section assumes that you have built a [compiler image]({{< relref "/nap-waf/v5/admin-guide/compiler.md" >}}) named `waf-compiler-1.0.0:custom`.
{{< /note >}}

To generate versions of the default policies that include the latest security updates, use the `-factory-policy` option instead of a source policy file.

For instance, to create an updated version of the `app_protect_default_policy`, use the following command:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -factory-policy default -o $(pwd)/new_default_policy.tgz
```

To create an updated version of the `app_protect_strict_policy`, use:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -factory-policy strict -o $(pwd)/new_strict_policy.tgz
```

After creating the updated version of a policy, reference it in the `nginx.conf` file:

```nginx
app_protect_policy_file /policies_mount/new_default_policy.tgz;
```

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

#### User-Defined Signature Sets

{{< include "nap-waf/config/common/user-defined-signature-sets.md" >}}

#### User-Defined Browser Control

{{< include "nap-waf/config/common/user-defined-browser-control.md" >}}

#### Deny and Allow IP Lists

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

{{< include "nap-waf/config/v5/apreload.md" >}}

### apreload Events

{{< include "nap-waf/config/v5/apreload-events.md" >}}

### Modification to nginx.conf file and App Protect Configurations
{{< include "nap-waf/config/v5/modification-nginx-config.md" >}}




## External References

{{< include "nap-waf/config/v5/external-references-v5.md" >}}

### Types of References

{{< include "nap-waf/config/common/types-of-references.md" >}}

## OpenAPI Specification File Reference

{{< include "nap-waf/config/v5/openapi-specification-file-reference-v5.md" >}}

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

{{< include "nap-waf/config/v5/bidirectional-configuration-v5.md" >}}

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

{{< include "nap-waf/config/v5/grpc-logging-v5.md" >}}

## Securing GraphQL APIs with NGINX App protect WAF

### GraphQL Overview
{{< include "nap-waf/config/common/graphql-overview.md" >}}

### GraphQL Security
{{< include "nap-waf/config/common/graphql-security.md" >}}

## Enabling GraphQL with Basic Configuration

{{< include "nap-waf/config/v5/enabling-graphql-v5.md" >}}

## GraphQL Advanced Configuration

{{< include "nap-waf/config/common/graphql-advanced-config.md" >}}

### GraphQL Violations

{{< include "nap-waf/config/common/graphql-violations.md" >}}

### GraphQL Profile

{{< include "nap-waf/config/v5/graphql-profile-v5.md" >}}

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

{{< include "nap-waf/config/v5/condition-syntax-usage-v5.md" >}}

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

{{< include "nap-waf/config/v5/json-web-tokens-access-profile-v5.md" >}}

### Authorization Rules in URLs

{{< include "nap-waf/config/v5/json-web-tokens-auth-rules-urls-v5.md" >}}

### Attack Signatures

{{< include "nap-waf/config/common/json-web-tokens-attack-sigs.md" >}}

### JSON Web Token Violations

{{< include "nap-waf/config/common/json-web-tokens-violations.md" >}}

### Violation Rating Calculation

{{< include "nap-waf/config/common/json-web-tokens-violation-rating.md" >}}

### Other References

{{< include "nap-waf/config/common/json-web-tokens-other-references.md" >}}

## Secure Traffic Between NGINX and App Protect Enforcer using mTLS

### Overview

{{< include "nap-waf/config/v5/mtls-overview-v5.md" >}}

### mTLS Configuration

{{< include "nap-waf/config/v5/mtls-configuration-v5.md" >}}

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

{{< include "nap-waf/config/v5/global-directives-v5.md" >}}

### App Protect Specific Directives

{{< include "nap-waf/config/v5/app-protect-directives-v5.md" >}}

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

## Security Logs

{{< include "nap-waf/config/v5/security-logs-v5.md" >}}

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
