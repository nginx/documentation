---
description: F5 NGINX App Protect WAF security features.
docs: DOCS-647
title: NGINX App Protect WAF Configuration Guide
toc: true
weight: 200
type:
- how-to
---

## Overview

This guide explains the F5 NGINX App Protect WAF security features and how to use them. This guide also assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.

For more information on the NGINX App Protect WAF security features, see [NGINX App Protect WAF Terminology](#nginx-app-protect-waf-terminology).

{{< important >}}
When configuring NGINX App Protect WAF, `app_protect_enable` should always be enabled in a `proxy_pass` location. If configuration returns static content, the user must add a location which enables App Protect, and proxies the request via `proxy_pass` to the internal static content location. An example can be found in [Configure Static Location](#configure-static-location).
{{< /important >}}

## Supported Security Policy Features

|Protection Mechanism | Description |
| ---| --- |
|[Attack Signatures](#attack-signatures-overview) | Default policy covers all the OWASP top 10 attack patterns enabling signature sets detailed in a section below. The user can disable any of them or add other sets. |
|[Signature attack for Server Technologies](#server-technologies) | Support adding signatures per added server technology. |
|[Threat Campaigns](#threat-campaigns) | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. |
|[HTTP Compliance](#http-compliance)  | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. |
|[Evasion Techniques](#evasion-techniques) | All evasion techniques are enabled by default and each can be disabled. These include directory traversal, bad escaped character and more. |
|Data Guard | [Detects](#data-guard---blocking) and [masks](#data-guard---masking) Credit Card Number (CCN) and/or U.S. Social Security Number (SSN) and/or [custom patterns](#partial-masking-of-data-using-data-guard) in HTTP responses. Disabled by default but can be enabled. |
|[Parameter parsing](#http-compliance) | Support only auto-detect parameter value type and acts according to the result: plain alphanumeric string, XML or JSON. |
|[Disallowed file type extension](#disallowed-file-types) | Support any file type. Default includes a predefined list of file types. |
|[Cookie enforcement](##enforcer-cookie-settings) | By default all cookies are allowed and not enforced for integrity. The user can add [specific cookies](##user---defined-http-headers), wildcards or explicit, that will be enforced for integrity. It is also possible to set the cookie attributes: HttpOnly, Secure and SameSite for cookies found in the response.|
|[Sensitive Parameters](#Parameters) | Default policy masks the "password" parameter in the security log. It is possible to add more such parameters. See also Data Guard [detecting](#data-guard---blocking), [partial blocking](#partial-masking-of-data-using-data-guard) and [masking](#data-guard---masking).|
|[JSON Content](#handling-xml-and-json-content) | JSON content profile detects malformed content and detects signatures and metacharacters in the property values. Default policy checks maximum structure depth. It is possible to enforce a provided JSON schema and/or enable more size restrictions: maximum total length Of JSON data;  maximum value length; maximum array length; tolerate JSON parsing errors. |
|[XML Content](#handling-xml-and-json-content) | XML content profile detects malformed content and detects signatures in the element values. Default policy checks maximum structure depth. It is possible to enable more size restrictions: maximum total length of XML data, maximum number of elements are more. SOAP, Web Services and XML schema features are not supported. |
|[Allowed methods](#allowed-methods) | Check HTTP allowed methods. By default all the standard HTTP methods are allowed. |
|[Deny and Allow IP lists](#deny-and-allow-ip-lists) | Manually define denied & allowed IP addresses as well as IP addresses to never log. |
|[XFF headers & trust](#xff-headers-and-trust) | Disabled by default. User can enable it and optionally add a list of custom XFF headers. |
|[gRPC Protection](#grpc-protection-for-unary-traffic) | gRPC content profile detects malformed content, parses well-formed content, and extracts the text fields for detecting attack signatures and disallowed meta-characters. In addition, it enforces size restrictions and prohibition of unknown fields. The Interface Definition Language (IDL) files for the gRPC API must be attached to the profile. gRPC protection can be on [unary](#grpc-protection-for-unary-traffic) or [bidirectional](#grpc-protection-for-bidirectional-streaming) traffic.|
|[Brute Force Attack Preventions](#brute-force-attack-preventions) | Configure brute-force-attack-preventions parameters to secured areas of a web application from brute force attacks.|}

### Disallowed File Types
{{< include "nap-waf/config/common/disallowed-file-types.md" >}}

## Additional Policy Features
{{< include "nap-waf/config/common/additional-policy-features.md" >}}


## Attack Signatures Overview

{{< include "/nap-waf/concept/attack-signatures.md" >}}

As new attack signatures are identified, they will become available for [download and installation]({{< ref "/nap-waf/v4/admin-guide/install.md#updating-app-protect-attack-signatures" >}}) so that your system will always have the most up-to-date protection. You can update the attack signatures without updating the App Protect release, and conversely, you can update App Protect without changing the attack signature package, unless you upgrade to a new NGINX Plus release.

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

The NGINX App Protect WAF security policy configuration uses the declarative format based on a pre-defined base template. The policy is represented in a JSON file which you can edit to add, modify and remove security capabilities with respect to the base template. The way the policy is integrated into the NGINX configuration is via referencing the JSON file (using the full path) in the `nginx.conf` file.

{{< note >}}NGINX App Protect WAF provides a [JSON Schema](https://json-schema.org/) which can be used to validate a JSON policy file to ensure file format compliance. The schema file can be generated using a script once NGINX App Protect WAF is installed: `sudo /opt/app_protect/bin/generate_json_schema.pl`. This script will output the schema to a file named `policy.json` into the current working directory. Once the schema file is generated, you can use validation tools such as [AJV](https://ajv.js.org/standalone.html) to validate a JSON policy file.{{< /note >}}

In the following example, the NGINX configuration file with App Protect enabled in the HTTP context and the policy /etc/app_protect/conf/NginxDefaultPolicy.json is used:

```nginx
user nginx;
worker_processes  4;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections  65536;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    app_protect_enable on; # This is how you enable NGINX App Protect WAF in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This is a reference to the policy file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:514; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://172.29.38.211:80$request_uri;
        }
    }
}
```

### Basic Configuration and the Default Policy

{{< include "/nap-waf/concept/basic-config-default-policy.md" >}}

### The Strict Policy

{{< include "/nap-waf/concept/strict-policy.md" >}}

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

In order for NGINX App Protect WAF to load the new user-defined signatures, the user needs to add the directive: `app_protect_user_defined_signatures`. This directive can only be used (multiple times, if needed) in the http context in the nginx.conf file and cannot be used under the server or location contexts. This directive accepts the path of the user-defined signature definition file as an argument. To add multiple definition files, the user will need to add a directive per file. Note that if the file or directory is not accessible by the nginx user, an error message will be displayed, and the policy will fail to compile.

An example configuration file is listed below:

```nginx
user nginx;
worker_processes  4;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections  65536;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    app_protect_enable on;
    app_protect_policy_file "/etc/nginx/user_defined_signatures_policy.json";
    app_protect_user_defined_signatures "/etc/nginx/user_defined_signature_definitions.json";

    app_protect_security_log_enable on;
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:514;

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://127.0.0.1:8080$request_uri;
        }
    }
}
```

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

### IP Intelligence Configuration

{{< include "nap-waf/config/common/ip-intelligence-conf.md" >}}

### Additional Configuration Options


{{< include "nap-waf/config/common/additional-config-options.md" >}}

### Modifying Configurations

{{< include "nap-waf/config/common/modifying-configurations.md" >}}


## NGINX App Protect WAF Standalone Configuration

### apreload

{{< include "/nap-waf/concept/apreload.md" >}}

### apreload Events

apreload events use the same format as the current operation log events written in the NGINX error log, namely: `configuration_load_success` or `configuration_load_failure` with the details in JSON format. Refer to the [Operation logs]({{< ref "/nap-waf/v4/logging-overview/operation-logs.md" >}}) for more details.

{{< note >}}
Note that if any of the configuration files are invalid, apreload will discover that and return the proper error message in the `configuration_load_failure` event. The Enforcer continues to run with the previous configuration.{{< /note >}}

### Modification to nginx.conf file and App Protect Configurations

When both `nginx.conf` file and App Protect configurations are modified, apreload enforces only the App Protect configurations but nginx reload enforces both.

For apreload, use the following command:

```shell
/opt/app_protect/bin/apreload
```
```text
USAGE:
    /opt/app_protect/bin/apreload:

Optional arguments with default values:
  -apply
        Apply new configuration in enforcer (default true)
  -i string
        Path to the config set. Ex. /opt/app_protect/config/config_set.json (default "/opt/app_protect/config/config_set.json")
  -policy-map-location string
        Path to policy map location (default "/opt/app_protect/bd_config/policy_path.map")
  -t    Test and prepare configuration without updating enforcement
  -wait-for-enforcer
        Wait until updated config is loaded (default true)

Optionally, using --help will issue this help message.
```

### Handling Concurrent Invocations of Apreload

Concurrent NGINX reloads are enqueued and so are the entailed invocations to apreload by the NGINX App Protect WAF module.

However, when invoking apreload directly, it is possible to invoke it while the previous invocation is still in progress. In this case, apreload will wait until the current invocation completes. The new invocation will bring a new configuration and the most recent configuration will only happen when the previous one is loaded.

In a special scenario, when the first invocation comes from the NGINX reload followed immediately by a direct call to apreload. The NGINX workers with the new `nginx.conf` will be launched as soon as the Enforcer finishes the first configuration. Later, the most recent NGINX App Protect WAF configuration will be loaded (using with the same NGINX worker instances).

### Limitation on HTTP Header and XFF Modification

apreload will not take into effect these Policy modifications:

- New user defined HTTP headers, refer to [User-defined HTTP Headers](#user-defined-http-headers) section. Note that modifications to existing user-defined headers will take effect in apreload.
- XFF trust modifications, refer to [XFF Headers and Trust](#xff-headers-and-trust) section for more details. <br>

If you want to apply any of the above modifications, reload NGINX rather invoking apreload, even if NGINX configuration has not been modified.

## External References

{{< include "/nap-waf/concept/external-references.md" >}}

### Types of References

{{< include "nap-waf/config/common/types-of-references.md" >}}

## OpenAPI Specification File Reference

The OpenAPI Specification defines the spec file format needed to describe RESTful APIs. The spec file can be written either in JSON or YAML. Using a spec file simplifies the work of implementing API protection. Refer to the OpenAPI Specification (formerly called Swagger) for details.

The simplest way to create an API protection policy is using an OpenAPI Specification file to import the details of the APIs. If you use an OpenAPI Specification file, NGINX App Protect WAF will automatically create a policy for the following properties (depending on what's included in the spec file):
* Methods
* URLs
* Parameters
* JSON profiles

An OpenAPI-ready policy template is provided with the NGINX App Protect WAF packages and is located in: `/etc/app_protect/conf/NginxApiSecurityPolicy.json`

It contains violations related to OpenAPI set to blocking (enforced).

{{< note >}} NGINX App Protect WAF supports only one OpenAPI Specification file reference per policy.{{< /note >}}

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

{{< include "/nap-waf/how-to/bidirectional-configuration.md" >}}

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

{{< include "/nap-waf/concept/grpc-logging.md" >}}

## Securing GraphQL APIs with NGINX App protect WAF

### GraphQL Overview
{{< include "nap-waf/config/common/graphql-overview.md" >}}

### GraphQL Security
{{< include "nap-waf/config/common/graphql-security.md" >}}


## Enabling GraphQL with Basic Configuration

{{< include "/nap-waf/how-to/enable-graphql.md" >}}

## GraphQL Advanced Configuration
{{< include "nap-waf/config/common/graphql-advanced-config.md" >}}

### GraphQL Violations

{{< include "nap-waf/config/common/graphql-violations.md" >}}

### GraphQL Profile

{{< include "/nap-waf/concept/graphql-profile.md" >}}

{{< note >}} For GraphQL profile default values and GraphQL violations reference, see NGINX App Protect WAF [Declarative Policy guide.]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}})  {{< /note >}}

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

For the full reference of Override Rules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}}/#policy/override-rules).

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

NGINX App Protect WAF introduces a new policy entity known as "**access profile**" to authenticate JSON Web Token. Access Profile is added to the app protect policy to enforce JWT settings. JSON Web Token needs to be applied to the URLs for enforcement and includes the actions to be taken with respect to access tokens. It is specifically associated with HTTP URLs and does not have any predefined default profiles.

{{< note >}}At present, only one access profile is supported within the App Protect policy. However, the JSON schema for the policy will be designed to accommodate multiple profiles in the future.{{< /note >}}

The access profile includes:

- **Enforcement Settings**: here you can configure the "enforceMaximumLength," "enforceValidityPeriod," and "keyFiles" settings within the scope of this profile, allowing you to enable or disable them as needed.
- **Location**: here you can modify the location settings, choosing between "header" or "query," as well as specifying the "name" for the header or parameter.
- **Access Profile Settings**: here you can set the "maximumLength" as well as specify the "name" and "type" for the access profile, with "jwt" representing JSON Web Token.

Access Profile example:

Refer to the following example where all access profile properties are configured to enforce specific settings within the App Protect policy. In this instance, we have established an access profile named "**access_profile_jwt**" located in the **authorization header**. The "maximumLength" for the token is defined as **2000**, and "verifyDigitalSignature" is set to **true**.

```shell
{
    "policy": {
        "name": "jwt_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "access-profiles": [
         {
            "description": "",
            "enforceMaximumLength": true,
            "enforceValidityPeriod": false,
            "keyFiles": [
               {
                  "contents": "{\r\n  \"keys\": [\r\n    {\r\n      \"alg\": \"RS256\",\r\n      \"e\": \"AQAB\",\r\n      \"kid\": \"1234\",\r\n      \"kty\": \"RSA\",\r\n      \"n\": \"tSbi8WYTScbuM4fe5qe4l60A2SG5oo3u5JDBtH_dPJTeQICRkrgLD6oyyHJc9BCe9abX4FEq_Qd1SYHBdl838g48FWblISBpn9--B4D9O5TPh90zAYP65VnViKun__XHGrfGT65S9HFykvo2KxhtxOFAFw0rE6s5nnKPwhYbV7omVS71KeT3B_u7wHsfyBXujr_cxzFYmyg165Yx9Z5vI1D-pg4EJLXIo5qZDxr82jlIB6EdLCL2s5vtmDhHzwQSdSOMWEp706UgjPl_NFMideiPXsEzdcx2y1cS97gyElhmWcODl4q3RgcGTlWIPFhrnobhoRtiCZzvlphu8Nqn6Q\",\r\n      \"use\": \"sig\",\r\n      \"x5c\": [\r\n        \"MIID1zCCAr+gAwIBAgIJAJ/bOlwBpErqMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJpbDEPMA0GA1UECAwGaXNyYWVsMRAwDgYDVQQHDAd0ZWxhdml2MRMwEQYDVQQKDApmNW5ldHdvcmtzMQwwCgYDVQQLDANkZXYxDDAKBgNVBAMMA21heDEdMBsGCSqGSIb3DQEJARYOaG93ZHlAbWF0ZS5jb20wIBcNMjIxMTA3MTM0ODQzWhgPMjA1MDAzMjUxMzQ4NDNaMIGAMQswCQYDVQQGEwJpbDEPMA0GA1UECAwGaXNyYWVsMRAwDgYDVQQHDAd0ZWxhdml2MRMwEQYDVQQKDApmNW5ldHdvcmtzMQwwCgYDVQQLDANkZXYxDDAKBgNVBAMMA21heDEdMBsGCSqGSIb3DQEJARYOaG93ZHlAbWF0ZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC1JuLxZhNJxu4zh97mp7iXrQDZIbmije7kkMG0f908lN5AgJGSuAsPqjLIclz0EJ71ptfgUSr9B3VJgcF2XzfyDjwVZuUhIGmf374HgP07lM+H3TMBg/rlWdWIq6f/9ccat8ZPrlL0cXKS+jYrGG3E4UAXDSsTqzmeco/CFhtXuiZVLvUp5PcH+7vAex/IFe6Ov9zHMVibKDXrljH1nm8jUP6mDgQktcijmpkPGvzaOUgHoR0sIvazm+2YOEfPBBJ1I4xYSnvTpSCM+X80UyJ16I9ewTN1zHbLVxL3uDISWGZZw4OXirdGBwZOVYg8WGuehuGhG2IJnO+WmG7w2qfpAgMBAAGjUDBOMB0GA1UdDgQWBBSHykVOY3Q1bWmwFmJbzBkQdyGtkTAfBgNVHSMEGDAWgBSHykVOY3Q1bWmwFmJbzBkQdyGtkTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCgcgp72Xw6qzbGLHyNMaCm9A6smtquKTdFCXLWVSOBix6WAJGPv1iKOvvMNF8ZV2RU44vS4Qa+o1ViBN8DXuddmRbShtvxcJzRKy1I73szZBMlZL6euRB1KN4m8tBtDj+rfKtPpheMtwIPbiukRjJrzRzSz3LXAAlxEIEgYSifKpL/okYZYRY6JF5PwSR0cvrfe/qa/G2iYF6Ps7knxy424RK6gpMbnhxb2gdhLPqDE50uxkr6dVHXbc85AuwAi983tOMhTyzDh3XTBEt2hr26F7jSeniC7TTIxmMgDdtYzRMwdb1XbubdtzUPnB/SW7jemK9I45kpKlUBDZD/QwER\"\r\n      ]\r\n    }\r\n  ]\r\n}",  # there can be more only one JWKs file (contents) in the policy JSON schema, however, the total amount of JWK in the JWKs is limited to 10.
                  "fileName": "JWKSFile.json"
               }
            ],
            "location": {
               "in": "header",  # the other option is: "query"
               "name": "authorization"  # the name of the header or parameter (according to "part")
            },
            "maximumLength": 2000,
            "name": "access_profile_jwt",
            "type": "jwt",
            "usernameExtraction": {
               "claimPropertyName": "sub",
               "enabled": true,
               "isMandatory": false
            },
            "verifyDigitalSignature": true
        }
      ],
      "urls": [
         {
            "name": "/jwt",
            "accessProfile": {
               "name": "access_profile_jwt"
            },
            "attackSignaturesCheck": true,
            "isAllowed": true,
            "mandatoryBody": false,
            "method": "*",
            "methodsOverrideOnUrlCheck": false,
            "name": "/jwt",
            "performStaging": false,
            "protocol": "http",
            "type": "explicit"
         }
      ]
    }
}
```

{{< note >}} For access profile default values and their related field names, see NGINX App Protect WAF [Declarative Policy guide]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}}). {{< /note >}}

#### Access Profile in URL Settings

The next step to configure JWT is to define the URL settings. Add the access profile name that you defined previously under the access profiles in the "name" field. From the previous example, we associate the access profile "**access_profile_jwt**" with the "name": **/jwt** in the URLs section to become effective, which means URLs with /jwt name are permitted for this feature and will be used for all JWT API requests.

Please note that the access profile cannot be deleted if it is in use in any URL.

### Authorization Rules in URLs

A new entity named as `authorizationRules` is introduced under the URL. This entity encompasses an authorization condition essential for "Claims" validation, enabling access to a specific URL based on claims of a JWT.
The `authorizationRules` entity consists of the following two mandatory fields:

- `name`: a unique descriptive name for the condition predicate
- `condition`: a boolean expression that defines the conditions for granting access to the URL

Here is an example of declarative policy using an `authorizationRules` entity under the access profile:
```json
{
    "urls": [
        {
            "name": "/api/v3/shops/items/*",
            "accessProfile": {
                "name": "my_jwt"
            },
            "authorizationRules": [
                {
                    "condition": "claims['scope'].contains('pet:read') and claims['scope'].contains('pet:write')",
                    "name": "auth_scope"
                },
                {
                    "condition": "claims['roles'].contains('admin') or claims['roles'].contains('inventory-manager')",
                    "name": "auth_roles"
                },
                {
                    "condition": "claims['email'].endsWith('petshop.com')",
                    "name": "auth_email"
                }
            ]
        }
    ]
}
```

#### AuthorizationRules Condition Syntax Usage

The `authorizationRules` use a Boolean expression to articulate the conditions for granting access to the URL. The conditions use the same syntax as in [Policy Override Rules](#override-rules) with one additional attribute **"claims"**.
#### Claims Attribute
The newly introduced attribute "claims" is a mapping of JSON paths for claims from the JWT to their respective values. Only structure nesting is supported using the "." notation.
A few points to remember regarding JWT claims:
- Please note that at the moment, accessing individual cells within JSON arrays isn't possible. Instead, the entire array gets serialized as a string, and its elements can be evaluated using string operators like "contains".
- While it's technically feasible to consolidate all conditions into one with "and" between them, it's not recommended. Dividing them into multiple conditions enhances the readability and clarity of the policy, particularly when explaining the reasons for authorization failure.
For the full reference of authorizationRules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< ref "nap-waf/v4/declarative-policy/policy.md" >}}/#policy/override-rules).
See below example for JWT claims:

```json
{
    "scope": "top-level:read",
    "roles": [
        "inventory-manager",
        "price-editor"
    ],
    "sub": "joe@doe.com"
    "address": {
        "country": "US",
        "state": "NY",
        "city": "New York",
        "street": "888 38th W"
    }
}
```
then the claims can be:
```
claims['scope'] = "top-level:read"
claims['roles'] = "["inventory-manager", "price-editor]" # the whole array is presented as a string
claims['address.country'] = "US"
claims['company'] = null # does not exist
claims['address'] = "{ \"address\": { .... } }" # JSON structs can be accessed using the dot "." notation
```

### Attack Signatures

{{< include "nap-waf/config/common/json-web-tokens-attack-sigs.md" >}}


### JSON Web Token Violations

{{< include "nap-waf/config/common/json-web-tokens-violations.md" >}}


### Violation Rating Calculation
{{< include "nap-waf/config/common/json-web-tokens-violation-rating.md" >}}

### Other References
{{< include "nap-waf/config/common/json-web-tokens-other-references.md" >}}

## Brute Force Attack Preventions

### Overview

Brute force attacks are attempts to break in to secured areas of a web application by trying exhaustive,
systematic, username/password combinations to discover legitimate authentication credentials.
To prevent brute force attacks, NGINX App Protect WAF monitors IP addresses, usernames, and the number of failed login attempts beyond a maximum threshold.
When brute force patterns are detected, the NGINX App Protect WAF policy either trigger an alarm or block the attack if the failed
login attempts reached a maximum threshold for a specific username or coming from a specific IP address.
To enable brute force protection, at least one login page must be created.
The login page entity is created separately and is not included in the brute force configuration block.

---

### Login page policy example

A login page specifies the login URL that users must pass through to get authenticated. The configuration of a login URL includes the URL itself, the username and passwords parameters and the validation criteria (how we know that a login was successful or failed)
```json
	    "login-pages": [
            {
               "accessValidation" : {
                  "responseContains": "Success"
               },
               "authenticationType": "form",
               "url" : {
                  "method" : "*",
                  "name" : "/html_login",
                  "protocol" : "http",
                  "type" : "explicit"
               },
               "usernameParameterName": "username",
               "passwordParameterName": "password"
            }
        ]
```

{{< note >}} For further configuration details, see NGINX App Protect WAF Declarative Policy Guide [Declarative Policy guide]({{< ref "/nap-waf/v4/declarative-policy/policy/#policy/login-pages" >}}). {{< /note >}}

---
### Brute force policy example

Example1: A single brute force configuration is applied universally to all login pages.
```json
{
    "policy": {
        "name": "BruteForcePolicy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "brute-force-attack-preventions" : [
            {
               "bruteForceProtectionForAllLoginPages" : true,
               "loginAttemptsFromTheSameIp" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 20
               },
               "loginAttemptsFromTheSameUser" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 3
               },
               "reEnableLoginAfter" : 3600,
               "sourceBasedProtectionDetectionPeriod" : 3600
            }
        ]
    }
}
```

Example2: Different brute force configurations can be defined for individual login pages,
          with each configuration referencing a specific login page.
```json
{
    "policy": {
        "name": "BruteForcePolicySpec",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "brute-force-attack-preventions" : [
            {
               "bruteForceProtectionForAllLoginPages" : false,
               "loginAttemptsFromTheSameIp" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 20
               },
               "loginAttemptsFromTheSameUser" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 3
               },
               "reEnableLoginAfter" : 3600,
               "sourceBasedProtectionDetectionPeriod" : 3600,
               "url": {
                 "method": "*",
                 "name": "/html_login",
                 "protocol": "http"
		       }
            }
        ],

    }
}
```
{{< note >}} For further configuration details, see NGINX App Protect WAF Declarative Policy Guide [Declarative Policy guide]({{< ref "/nap-waf/v4/declarative-policy/policy/#policy/brute-force-attack-preventions" >}}). {{< /note >}}

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

{{< include "/nap-waf/concept/global-directives.md" >}}

### App Protect Specific Directives

This table summarizes the nginx.conf directives for NGINX App Protect WAF functionality.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Directive Name | Syntax | Functionality | nginx.conf Contexts | Example |
| ---| ---| ---| ---| --- |
|load_module | load_module <library_file_path> | NGINX directive to load the App Protect module. It must be invoked with the App Protect library path | Global | load_module modules/ngx_http_app_protect_module.so |
|app_protect_enable | app_protect_enable on &#124; off | Whether to enable App Protect at the respective context. If not present, inherits from the parent context | HTTP, Server, Location | app_protect_enable on |
|app_protect_policy_file | app_protect_policy_file <file_path> | Set a App Protect policy configuring behavior for the respective context. | HTTP, Server, Location | app_protect_policy_file /config/waf/strict_policy.json |
|app_protect_security_log_enable | app_protect_security_log_enable on &#124; off | Whether to enable the App Protect per-request log at the respective context. | HTTP, Server, Location | app_protect_security_log_enable on |
|app_protect_security_log | app_protect_security_log <file_path> <destination> | Specifies the per-request logging: what to log and where | HTTP, Server, Location | app_protect_security_log /config/waf/log_illegal.json syslog:localhost:522 |
|app_protect_custom_log_attribute | app_protect_custom_log_attribute <key_value> | Specifies the assigned location/server/http dimension of each request. | HTTP, Server, Location | app_protect_custom_log_attribute ‘environment' 'env1' |
{{</bootstrap-table>}}

#### Horizontal Scaling

NGINX App Protect WAF can be deployed in multiple instances that share the traffic to the same applications. In that case all the instances must share the same configuration files. It is your responsibility to synchronize the files on all instances. You also have to provide a load balancing solution in front of those instances such as another NGINX instance.

When deploying multiple scalability instances you have to add the `app_protect_cookie_seed` directive to nginx.conf in the `http` block:

```nginx
...
http {
    ...
    app_protect_cookie_seed jkldsf90upiokasdj120;
    ...
    server {
        listen       80;
...
}
...
```

As the argument of this directive, put a random alphanumeric string of at least 20 characters length (but not more than 1000 characters). That seed is used by NGINX App Protect WAF to generate the encryption key for the cookies it creates. These cookies are used for various purposes such as validating the integrity of the cookies generated by the application.

In the absence of this directive, App Protect generates a random string by itself. In that case, each instance will have a different seed. A cookie created and encrypted on one instance of App Protect will fail to be decrypted when sent by the same client to another App Protect instance having a different encryption key.


#### Failure Mode

If the App Protect daemons are down or disconnected from the NGINX workers, there are two modes of operation until they are up and connected again:

-   **Pass** the traffic without inspection. Use this when preferring availability over security. This mode is also known as "fail open".
-   **Drop** the traffic. Use this when preferring security over availability. This mode is also known as "fail closed".

The default is to **pass**, fail open, but you can control this using the `app_protect_failure_mode_action` directive with one argument with two possible values: "pass" or "fail" for the two above options.

This directive is also placed in the `http` block of the nginx.conf file.

```nginx
...
http {
    ...
    app_protect_failure_mode_action drop;
    ...
    server {
        listen       80;
...
    }
...
```

#### Handling Compressed Requests

Starting with NGINX App Protect WAF release version 4.6, the [`app_protect_compressed_requests_action`](#global-directives) directive has been deprecated from the nginx configuration. When configuring this directive in the `nginx.conf` file, App Protect will disregard any previously used values ("pass" or "drop") and issue a warning.

#### Handling Decompression

Now by default the enforcer will decompress all the HTTP compressed payload request and will apply the enforcment. The supported compression algorithms for this feature are "**gzip**" and "**deflate**". There will be no decompression, if the compression method is not supported.

The 'Content-Encoding' header must match the compression algorithm used while sending compressed payload in a HTTP request, else the enfocer will fail to decompress the payload.

The decompressed request must not exceed the size limit of 10 MB. If it does exceed this limit, NGINX App Protect WAF will only decompress the first 10 KB, ignoring the remainder, and trigger the `VIOL_REQUEST_MAX_LENGTH` violation, just as it would for an uncompressed request that exceeds 10 MB.

In the cases where decompression fails,  NGINX App Protect WAF will continue with the scan in the same manner as it does for uncompressed requests.

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

NGINX App Protect WAF includes a number of tools that can be used to facilitate the process of porting existing resources or configuration files from the BIG-IP for use in the NGINX App Protect WAF environment. Note that these tools are available in the compiler package, and do not require a full installation of NGINX App Protect WAF or NGINX Plus.

### Policy Converter

The Policy Converter tool `/opt/app_protect/bin/convert-policy` is used for converting XML formatted ASM and Advanced WAF policies to JSON. The converted JSON policy is based on the NGINX App Protect WAF policy base template and contains the minimal diff to it in JSON declarative policy format.

Elements in the XML policy that are not supported in the NGINX App Protect WAF environment will generate warnings. Note that any configuration that is invalid or irrelevant to the NGINX App Protect WAF environment is removed from the exported declarative policy.

{{< note >}} All NGINX App Protect WAF versions support converting XML policies exported from BIG-IP regardless of any version. If the source XML policy has not changed from when it was in use on BIG-IP, then it's always a good idea to convert it with the Policy Converter tool included with the version of NGINX App Protect WAF you are using. This way, as more configuration items from BIG-IP become supported in NGINX App Protect WAF, they will be included in the converted policy. A policy that was converted will work on the same or greater NGINX App Protect WAF version it originally came from.{{< /note >}}

The Policy Converter tool has options to include the following elements in a full export:
- Elements that are the same as the default template policy. (Invalid elements are removed, but no warnings reported.)
- Elements that are not supported in the NGINX App Protect WAF environment. (No elements removed and no warnings reported.)

The XML policy file can be obtained by exporting the policy from the BIG-IP device on which the policy is currently deployed.

Using the tool:
```shell
/opt/app_protect/bin/convert-policy
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/convert-policy

Required arguments:
    --outfile|o='/path/to/policy.json'
        File name for where to write exported policy.
        Can also be set via an environment variable: EXPORT_FILE
    --infile|i='/path/to/policy.xml'
        Advanced WAF/ASM Security Policy file to convert
        Can also be set via an environment variable: IMPORT_FILE

Optional arguments:
    --format|f='json'
        Desired output format for signature file. Default 'json'
        Supported formats: 'json'
    --keep-full-configuration
        By default the exported policy will only contain elements that are valid for the environment in which this tool is run.
        If keep-full-configuration is enabled then the full configuration is retained, including elements that are not supported in NGINX App Protect WAF.
    --full-export
        By default the exported policy will only contain elements that are different from the default policy template.
        If full-export is enabled then all policy elements are included in the export file.
        When this option is selected, no warnings are generated when removing unsupported elements from the exported policy.

Optionally, using --help will issue this help message.
```

Example of generating a JSON policy suitable for NGINX App Protect WAF usage:
```shell
/opt/app_protect/bin/convert-policy -i /path/to/policy.xml -o /path/to/policy.json | jq
```

Output:
```json
{
    "warnings": [
        "Traffic Learning, Policy Building, and staging are unsupported",
        "Element '/plain-text-profiles' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_ASM_COOKIE_HIJACKING' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_BLOCKING_CONDITION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_BRUTE_FORCE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CONVICTION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CROSS_ORIGIN_REQUEST' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CSRF' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CSRF_EXPIRED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_DYNAMIC_SESSION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_DISALLOWED_INPUT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_ENTRY_POINT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_MANDATORY_PARAMS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GEOLOCATION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GRPC_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GRPC_METHOD' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GWT_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GWT_MALFORMED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_HOSTNAME_MISMATCH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_BYPASSED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_EXPIRED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_MALICIOUS_DEVICE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_MALICIOUS_IP' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_PARAMETER_DYNAMIC_VALUE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_PLAINTEXT_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_REDIRECT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_SESSION_AWARENESS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_VIRUS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BAD_REQUEST' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_LENGTH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_NOT_ALLOWED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_EXTENSION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMES_PER_MESSAGE_COUNT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_LENGTH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_MASKING' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMING_PROTOCOL' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_MESSAGE_NOT_ALLOWED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_NULL_VALUE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SCHEMA' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SOAP_ATTACHMENT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SOAP_METHOD' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_WEB_SERVICES_SECURITY' is unsupported.",
        "/blocking-settings/http-protocols/description value 'Unparsable request content' is unsupported.",
        "/general/enableEventCorrelation must be 'false' (was 'true').",
        "Element '/websocket-urls' is unsupported.",
        "/protocolIndependent must be 'true' (was 'false').",
        "Element '/redirection-protection' is unsupported.",
        "Element '/gwt-profiles' is unsupported.",
        "/signature-sets/learn value true is unsupported"
    ],
    "file_size": 24227,
    "completed_successfully": true,
    "filename": "/path/to/policy.json"
}
```

In the above example we piped the output to `jq` utility (which needs to be installed separately) to get the output with proper indentation.

Example of generating an unmodified JSON policy (may cause warnings/errors when used in NGINX App Protect WAF):
```shell
/opt/app_protect/bin/convert-policy -i /path/to/policy.xml -o /path/to/policy.json --keep-full-configuration
```

Example of translating a valid NGINX App Protect WAF JSON policy into a full JSON policy including elements from the defaults:
```shell
/opt/app_protect/bin/convert-policy -i /path/to/policy.json -o /path/to/full_policy.json --full-export
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

### User Defined Signatures Converter

The User Defined Signatures Converter tool `/opt/app_protect/bin/convert-signatures` takes a User Defined Signatures XML file as input and exports the content as a JSON file suitable for use in an NGINX App Protect WAF environment.

The tool can optionally accept a tag argument as an input. Otherwise, the default tag value `user-defined-signatures` is assigned to the exported JSON file.

Note that the User Defined signatures XML file can be obtained by exporting the signatures from a BIG-IP device.

Using the tool:
```shell
/opt/app_protect/bin/convert-signatures
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/convert-signatures

Required arguments:
    --outfile|o='/path/to/signatures.json'
        File name to write JSON format export
        Can also be set via an environment variable: EXPORT_FILE
    --infile|i='/path/to/signatures.xml'
        Advanced WAF/ASM User Defined Signatures file to Convert
        Can also be set via an environment variable: IMPORT_FILE

Optional arguments:
    --tag|t='mytag'
        Signature Tag to associate with User Defined Signatures.
        If no tag is specified in the XML file, a default tag of 'user-defined-signatures' will be assigned.
        Can also be set via an environment variable: TAG
    --format|f='json'
        Desired output format for signature file. Default 'json'
        Supported formats: 'json'

Optionally, using --help will issue this help message.
```

Example of generating a user defined signature JSON file (with default tag):
```shell
/opt/app_protect/bin/convert-signatures -i /path/to/signatures.xml -o /path/to/signatures.json | jq
```

Output:
```json
{
    "file_size": 1003,
    "filename": "/path/to/signatures.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "signatures": [
        {
            "attackType": {
                "name": "Buffer Overflow"
            },
            "name": "my_first_sig",
            "lastUpdateMicros": 1606014750000000,
            "rule": "content:\"first_sig\"; nocase;",
            "description": "This is the first user defined signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Microsoft Windows"
                }
            ],
            "accuracy": "low",
            "signatureId": "300000002",
            "signatureType": "request",
            "risk": "low"
        },
        {
            "attackType": {
                "name": "Command Execution"
            },
            "name": "my_second_sig",
            "lastUpdateMicros": 1606014818000000,
            "rule": "uricontent:\"second_sig\"; nocase; objonly;",
            "description": "Short description of the signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Unix/Linux"
                }
            ],
            "accuracy": "medium",
            "signatureId": "300000003",
            "signatureType": "request",
            "risk": "medium"
        }
    ],
    "tag": "user-defined-signatures"
}
```

Example of generating a user defined signature JSON file (with custom tag):
```shell
/opt/app_protect/bin/convert-signatures -i /path/to/signatures.xml -o /path/to/signatures.json --tag "MyTag"
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

## Attack Signature Report Tool

The Attack Signature Report tool `/opt/app_protect/bin/get-signatures` scans the system for attack signatures and generates a JSON report file that includes information about these signatures.

This tool can be deployed and used independently of the NGINX App Protect WAF deployment, by [installing the compiler package as a standalone]({{< ref "/nap-waf/v4/admin-guide/install#converter-tool-docker-image" >}}), in order to generate a report about either the default signatures included in the package, or signatures included in a signature update package. The latter can be obtained by running the tool on a standalone compiler deployment, after installing a new signature update package on top of the compiler package. These reports can then be compared for greater clarity regarding signature updates.

In addition, this report can be used for reporting or troubleshooting purposes or for auditing/tracking changes for signature updates on the NGINX App Protect WAF deployment itself.

Using the script:
```shell
/opt/app_protect/bin/get-signatures
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/get-signatures <arguments>

  Required arguments:
    --outfile|o='/path/to/report-file.json'
      File name to write signature report.

  Optional arguments:
    --fields|f='list,of,fields'
      Comma separated list of desired fields.
      Available fields:
      name,signatureId,signatureType,attackType,accuracy,tag,risk,systems,hasCve,references,isUserDefined,description,lastUpdateMicros

Optionally, using --help will issue this help message.
```

Example of generating a signature report (with all signature details):
```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json | jq
```

Output:
```json
{
    "file_size": 1868596,
    "filename": "/path/to/signature-report.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "signatures": [
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Detection Evasion"
            },
            "name": "Unicode Fullwidth ASCII variant",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "infosecauditor.wordpress.com/2013/05/27/bypassing-asp-net-validaterequest-for-script-injection-attacks/",
                    "type": "url"
                }
            ],
            "signatureId": 299999999,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "low"
        },
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "name": "IIS Web Server log dir access (/W3SVC..)",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                }
            ],
            "signatureId": 200000001,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "high"
        },
        {
            "isUserDefined": false,
            "name": "WEB-INF dir access (/WEB-INF/)",
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "hasCve": true,
            "systems": [
                {
                    "name": "Java Servlets/JSP"
                },
                {
                    "name": "Macromedia JRun"
                },
                {
                    "name": "Jetty"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                },
                {
                    "value": "CVE-2016-4800",
                    "type": "cve"
                },
                {
                    "value": "CVE-2007-6672",
                    "type": "cve"
                }
            ],
            "signatureType": "request",
            "risk": "low",
            "signatureId": 200000018
        }
    ],
    "revisionDatetime": "2019-07-16T12:21:31Z"
}
```

Example of generating signature report (with a preset set of fields):
```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json --fields=name,signatureId
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

## Security Logs

Refer to [Logging Overview]({{< ref "/nap-waf/v4/logging-overview/security-log.md" >}}) section for more details on Security Logs.

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
