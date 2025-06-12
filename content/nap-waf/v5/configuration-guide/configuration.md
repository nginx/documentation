---
description: This guide explains the F5 NGINX App Protect WAF security features and
  how to use them.
docs: DOCS-1368
title: NGINX App Protect WAF Configuration Guide
toc: true
weight: 200
type:
- how-to
---

## Overview

This guide explains the F5 NGINX App Protect WAF security features and how to use them. This guide also assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.

For more information on the NGINX App Protect WAF security features, see [NGINX App Protect WAF Terminology](#nginx-app-protect-waf-terminology).

## Supported Security Policy Features

|Protection Mechanism | Description |
| ---| --- |
|[Attack Signatures](#attack-signatures-overview) | Default policy covers all the OWASP top 10 attack patterns enabling signature sets detailed in a section below. The user can disable any of them or add other sets. |
|[Signature attack for Server Technologies](#server-technologies) | Support adding signatures per added server technology. |
|[Threat Campaigns](#threat-campaigns) | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. |
|[HTTP Compliance](#http-compliance)  | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. |
|[Evasion Techniques](#evasion-techniques) | All evasion techniques are enabled by default and each can be disabled. These include directory traversal, bad escaped character and more. |
|[Data Guard](#data-guard---blocking) | Detects and masks Credit Card Number (CCN) and/or U.S. Social Security Number (SSN) and/or [custom patterns](#partial-masking-of-data-using-data-guard) in HTTP responses. Disabled by default but can be enabled. |
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
|[Secure Traffic Between NGINX and App Protect Enforcer using mTLS](#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls) | Disabled by default. You can manually configure mTLS to secure the traffic between NGINX and App Protect Enforcer.|
|[Brute Force Attack Preventions](#brute-force-attack-preventions) | Configure brute-force-attack-preventions parameters to secured areas of a web application from brute force attacks.|
|[IP Groups](#ip-groups) | Configure IP Groups feature to organize lists of allowed and forbidden IP addresses across several lists with common attributes.|
|[IP Intelligence](#ip-intelligence-configuration) | Configure the IP Intelligence feature to customize enforcement based on the source IP of the request, limiting access from IP addresses with questionable reputation.|

### Disallowed File Types

{{< include "nap-waf/config/common/disallowed-file-types.md" >}}

## Additional Policy Features

{{< include "nap-waf/config/common/additional-policy-features.md" >}}

## Attack Signatures Overview

{{< include "/nap-waf/concept/attack-signatures.md" >}}

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

The NGINX App Protect WAF security policy configuration uses the declarative format based on a pre-defined base template. The policy is represented in a JSON file which you can edit to add, modify and remove security capabilities with respect to the base template. The JSON file then should be compiled to a bundle file (`.tgz`) using the [NGINX App Protect WAF Compiler]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}}). The way the policy is integrated into the NGINX configuration is via referencing the bundle file (using the full path) in the `nginx.conf` file.

Refer to the [admin guide]({{< ref "/nap-waf/v5/admin-guide/install.md#using-policy-and-logging-profile-bundles" >}}) for instructions on how to mount bundle files to your deployment.

NGINX App Protect WAF provides a [JSON Schema](https://json-schema.org/) which can be used to validate a JSON policy file to ensure file format compliance. The schema file can be generated using a script inside the NGINX App Protect WAF Compiler image:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 -w $(pwd) \
 --entrypoint=/opt/app_protect/bin/generate_json_schema.pl \
 private-registry.nginx.com/nap/waf-compiler:1.0.0
```

Replace the `1.0.0` with the version you use.

This script will output the schema to a file named `policy.json` into the current working directory. Once the schema file is generated, you can use validation tools such as [AJV](https://ajv.js.org/standalone.html) to validate a JSON policy file.

In the following example, the NGINX configuration file with App Protect enabled in the HTTP context and the policy `/policies/policy1.tgz` is used:

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
    app_protect_policy_file "/etc/app_protect/conf/policy1.tgz"; # This is a reference to the policy bundle file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_all.tgz" syslog:server=127.0.0.1:514; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://172.29.38.211/;
        }
    }
}
```

### Basic Configuration and the Default Policy

{{< include "/nap-waf/concept/basic-config-default-policy.md" >}}

### The Strict Policy

{{< include "/nap-waf/concept/strict-policy.md" >}}

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
This section assumes that you have built a [compiler image]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}}) named `waf-compiler-1.0.0:custom`.
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

When both `nginx.conf` file and App Protect configurations are modified, apreload enforces only the App Protect configurations but nginx reload enforces both. apreload is a script that you run remotely on the `nginx` container after you have modified the policy in the `nginx` container.  The result of the apreload script is viewable in the `waf-config-mgr` container log.

For apreload, use the following command:

```shell
kubectl -n [namespace] exec -it [podname] -c waf-nginx -- bash /opt/app_protect/bin/apreload
```

Output:

```shell
kubectl -n [namespace] logs [podname] -c config-mgr
sudo docker logs waf-config-mgr
```

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

To obtain an OpenAPI-ready policy template, execute the following command:

```shell
sudo docker run --rm --entrypoint='' private-registry.nginx.com/nap/waf-compiler:1.0.0 cat /etc/app_protect/conf/NginxApiSecurityPolicy.json
```

Ensure to substitute 1.0.0 with the specific version that you are using.

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

{{< note >}} For GraphQL profile default values and GraphQL violations reference, see NGINX App Protect WAF [Declarative Policy guide.]({{< ref "/nap-waf/v5/declarative-policy/policy.md" >}}) {{< /note >}}

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

For the full reference of Override Rules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< ref "/nap-waf/v5/declarative-policy/policy.md" >}}/#policy/override-rules).

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

## IP Groups

### Overview

{{< include "nap-waf/config/common/ip-groups-overview.md" >}}

### IP Groups in Policy Override Rules Conditions

{{< include "nap-waf/config/common/ip-groups-override-rules.md" >}}

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

{{< note >}} For access profile default values and their related field names, see NGINX App Protect WAF [Declarative Policy guide]({{< ref "/nap-waf/v5/declarative-policy/policy.md" >}}). {{< /note >}}

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
For the full reference of authorizationRules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< ref "nap-waf/v5/declarative-policy/policy.md" >}}/#policy/override-rules).
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

## Secure Traffic Between NGINX and App Protect Enforcer using mTLS

### Overview

NGINX App Protect WAF can be secured with mutual TLS (mTLS) connection to provide an extra layer of security where the mutual authentication is set up between both the NGINX (client) and App Protect Enforcer (server). This adds an extra layer of security, ensuring that both parties are who they claim to be.

### mTLS Configuration

To enable mTLS in NGINX, you need to perform the following steps:

1. Generate certificates and keys for both components - NGINX (client) and the App Protect Enforcer (server).

    Below are the steps for using self-signed certificates:

    {{< note >}} The below commands will generate a self-signed certificates in `/etc/ssl/certs/`  valid for the default period of 30 days. You can adjust the command to fit your needs. For instance, to specify a different validity period, add the `-days` option followed by the number of days you want the certificate to be valid (for example, `-days 90`).
	{{< /note >}}

    ```shell
	mkdir -p /etc/ssl/certs
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server_ca.key
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client_ca.key
	openssl req -x509 -new -key /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Server Root CA"
	openssl req -x509 -new -key /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Client Root CA"
	```

    Generate a certificate and key for the App Protect Enforcer (server):

    ```shell
    openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server.key
	openssl req -new -key /etc/ssl/certs/app_protect_server.key -out /etc/ssl/certs/app_protect_server_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
	openssl x509 -req -in /etc/ssl/certs/app_protect_server_csr.crt -CA /etc/ssl/certs/app_protect_server_ca.crt -CAkey /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server.crt -CAcreateserial
	```

    Generate a client certificate and key for the NGINX (client):

    ```shell
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client.key
	openssl req -new -key /etc/ssl/certs/app_protect_client.key -out /etc/ssl/certs/app_protect_client_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
	openssl x509 -req -in /etc/ssl/certs/app_protect_client_csr.crt -CA /etc/ssl/certs/app_protect_client_ca.crt -CAkey /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client.crt -CAcreateserial
	```

2. Open the NGINX configuration file `nginx.conf` and perform the following steps:

	Create a top‑level [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block or modify the existing one and add the following configuration:

	```nginx
	stream {
	    upstream enforcer {
	        # Replace with the actual App Protect Enforcer address and port if different
	        server 127.0.0.1:4431;
	    }

	    server {
	        listen 5000;
	        proxy_pass enforcer;
	        proxy_ssl_server_name on;
	        proxy_timeout 60m;
	        proxy_ssl on;
            proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
		    proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
		    proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
	    }
	```

	In the above configuration:

	- The `upstream enforcer` block specifies the App Protect Enforcer server listening on port `4431`
	- The `proxy_pass` is used to proxy requests to the enforcer upstream
	- `ssl_certificate` and `ssl_certificate_key` specify the NGINX (client) certificate and key
	- The `proxy_ssl_trusted_certificate` enables the enforcer (server) certificate verification.

	Use this stream server as the `app_protect_enforcer_address` value:

	```nginx
	app_protect_enforcer_address 127.0.0.1:5000;
	```

    Configuration Example:

    ```nginx
    user nginx;
    worker_processes auto;
    worker_shutdown_timeout 10s; # NGINX gives worker processes 10 seconds to gracefully terminate before it will actively close connections
    load_module modules/ngx_http_app_protect_module.so;
    error_log /var/log/nginx/error.log notice;

    events {
            worker_connections 65536;
        }

    stream {
    upstream enforcer {
        server 127.0.0.1:4431;
    }

    server {
        listen 5000;
        proxy_pass enforcer;
        proxy_ssl_server_name on;
        proxy_timeout 60m;
        proxy_ssl on;
        proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
	    proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
	    proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
    }

    http {
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        sendfile on;
        keepalive_timeout 65;

        app_protect_enforcer_address 127.0.0.1:5000;

        server {
            listen 80;
            server_name localhost;
            proxy_http_version 1.1;

            app_protect_enable on;
            app_protect_policy_file app_protect_default_policy;
            app_protect_security_log_enable on;
            app_protect_security_log log_all syslog:server=127.0.0.1:514;

            location / {
                client_max_body_size 0;
                default_type text/html;
                # Pass traffic to backend
                proxy_pass http://127.0.0.1:8080/;
            }
        }
    }
    ```

3. Add the following environment variables to the `waf-enforcer` container in your Docker Compose or Kubernetes deployment file:

    - ENFORCER_PORT
    - ENFORCER_SERVER_CERT
    - ENFORCER_SERVER_KEY
    - ENFORCER_CA_FILE

    Refer to the example for mTLS deployment in the admin guide, whether you're using [Docker]({{< ref "/nap-waf/v5/admin-guide/deploy-on-docker.md#docker-compose-file-with-mtls" >}}) or [Kubernetes]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md#mtls-deployment" >}}).

## Brute Force Attack Preventions

### Overview

Brute force attacks are attempts to break in to secured areas of a web application by trying exhaustive,
systematic, username/password combinations to discover legitimate authentication credentials.
To prevent brute force attacks, NGINX App Protect WAF monitors IP addresses, usernames, and the number of failed login attempts beyond a maximum threshold.
When brute force patterns are detected, the NGINX App Protect WAF policy either trigger an alarm or block the attack if the failed
login attempts reached a maximum threshold for a specific username or coming from a specific IP address.
In order to create a brute force configuration for a specific URL in Nginx App Protect you must first create a User-Defined URL, then a Login Page and finally define the URL element in the Brute Force configuration section.


---

### The User-Defined URL example

```json
"urls": [
      {
        "method": "*",
        "name": "/html_login",
        "protocol": "http",
        "type": "explicit"
      }
    ],
```

### Login pages example

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

{{< note >}} For further configuration details, see NGINX App Protect WAF Declarative Policy Guide [Declarative Policy guide]({{< ref "/nap-waf/v5/declarative-policy/policy/#policy/login-pages" >}}). {{< /note >}}

---

### Brute force prevention example

Example1: A single brute force configuration is applied universally to all login pages.
```json
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
```

Example2: Different brute force configurations can be defined for individual login pages,
          with each configuration referencing a specific login page.
```json
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
        ]
```

The following example adds all three of the pieces for a complete example policy.
```json
{
  "policy": {
    "name": "BruteForcePolicy",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
      {
        "method": "*",
        "name": "/html_login",
        "protocol": "http",
        "type": "explicit"
      }
    ],
    "login-pages": [
      {
        "accessValidation": {
          "responseContains": "Success"
        },
        "authenticationType": "form",
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http",
          "type": "explicit"
        },
        "usernameParameterName": "username",
        "passwordParameterName": "password"
      }
    ],
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": false,
        "loginAttemptsFromTheSameIp": {
          "action": "alarm",
          "enabled": true,
          "threshold": 20
        },
        "loginAttemptsFromTheSameUser": {
          "action": "alarm",
          "enabled": true,
          "threshold": 3
        },
        "reEnableLoginAfter": 3600,
        "sourceBasedProtectionDetectionPeriod": 3600,
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http"
        }
      }
    ]
  }
}
```

{{< note >}} For further configuration details, see NGINX App Protect WAF Declarative Policy Guide [Declarative Policy guide]({{< ref "/nap-waf/v5/declarative-policy/policy/#policy/brute-force-attack-preventions" >}}). {{< /note >}}

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

|Directive Name | Syntax | Functionality | nginx.conf Contexts | Example |
| ---| ---| ---| ---| --- |
|load_module | load_module <library_file_path> | NGINX directive to load the App Protect module. It must be invoked with the App Protect library path | Global | load_module modules/ngx_http_app_protect_module.so |
|app_protect_enforcer_address | <hostname/ip>:<port> | The Enforcer service address. | HTTP | app_protect_enforcer_address 127.0.0.1:50000; |
|app_protect_enable | app_protect_enable on &#124; off | Whether to enable App Protect at the respective context. If not present, inherits from the parent context | HTTP, Server, Location | app_protect_enable on |
|app_protect_policy_file | app_protect_policy_file <file_path> | Set a App Protect policy configuring behavior for the respective context. | HTTP, Server, Location | app_protect_policy_file /config/waf/strict_policy.tgz |
|app_protect_security_log_enable | app_protect_security_log_enable on &#124; off | Whether to enable the App Protect per-request log at the respective context. | HTTP, Server, Location | app_protect_security_log_enable on |
|app_protect_security_log | app_protect_security_log <file_path> <destination> | Specifies the per-request logging: what to log and where | HTTP, Server, Location | app_protect_security_log /config/waf/log_illegal.tgz syslog:localhost:522 |
|app_protect_custom_log_attribute | app_protect_custom_log_attribute <key_value> | Specifies the assigned location/server/http dimension of each request. | HTTP, Server, Location | app_protect_custom_log_attribute ‘environment' 'env1' |

#### Failure Mode

If the App Protect daemons are down or disconnected from the NGINX workers, there are two modes of operation until they are up and connected again:

- **Pass** the traffic without inspection. Use this when preferring availability over security. This mode is also known as "fail open".
- **Drop** the traffic. Use this when preferring security over availability. This mode is also known as "fail closed".

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

Now by default the enforcer will decompress all the HTTP compressed payload request and will apply the enforcement. The supported compression algorithms for this feature are "**gzip**" and "**deflate**". There will be no decompression, if the compression method is not supported.

The 'Content-Encoding' header must match the compression algorithm used while sending compressed payload in a HTTP request, else the enforcer will fail to decompress the payload.

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

---

## Converter tools

NGINX App Protect WAF includes a number of tools that can be used to facilitate the process of porting existing resources or configuration files from the BIG-IP for use in the NGINX App Protect WAF environment. Note that these tools are available in the compiler package, and do not require a full installation of NGINX App Protect WAF or NGINX Plus.

### Policy Converter

The NGINX App Protect WAF v5 Policy Converter tool `/opt/app_protect/bin/convert-policy` is used to convert XML policies to JSON format. The converted JSON policy is based on the NGINX App Protect WAF policy base template and contains the minimal differences to it in JSON declarative policy format.

The XML policy file can be obtained by exporting the policy from the BIG-IP system on which the policy is currently deployed.

Using the tool:

```shell
/opt/app_protect/bin/convert-policy
```

#### Convert Policy using Command Line Interface (CLI Usage)

The input policy can also be converted using convert-policy as a CLI tool from within NGINX App Protect WAF Converter container by using the following commands:

```docker
docker run -it --rm \
  -v $(pwd):/policies \
  --entrypoint="/opt/app_protect/bin/convert-policy" \
  waf-compiler-<version-tag>:custom -i test.json -o test.xml
  -i /policies/input_policy.plc \
  -o /policies/output_policy \
  --full-export
```

#### Command Line Options

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Field Name   | Notes |
| ------------| ------|
| -i | Filename of input WAF or ASM binary policy |
| -o | Filename of output declarative policy |
| --bot-profile  | Filename of JSON Bot Profile (pre-converted to JSON from tmsh syntax) |
| --logging-profile | Filename of JSON Logging Profile (pre-converted to JSON from tmsh syntax) |
| --dos-profile | Filename of JSON DoS Profile (pre-converted to JSON from tmsh syntax) |
| --full-export | If specified, the full policy with all entities will be exported. Otherwise, only entities that differ from the template will be included.<br> Default for the CLI is not specific (only differing entities). <br> Default for the REST endpoint above is "--full-export" (you can not override this).|{{</bootstrap-table>}}

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
docker run -v `pwd`:`pwd` -w `pwd` --entrypoint /opt/app_protect/bin/convert-signatures docker_img:latest -i /path/to/signatures.xml -o /path/to/signatures.json | jq
```

Output:
```json
{
    "filename": "/path/to/signatures.json",
    "file_size": 1602,
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "tag": "user-defined-signatures",
    "signatures": [
        {
            "accuracy": "high",
            "risk": "high",
            "systems": [],
            "rule": "content:\"header1\"; nocase;",
            "description": "",
            "signatureType": "request",
            "signatureId": "300000000",
            "revision": "1",
            "lastUpdateMicros": 1731425468000000,
            "name": "sig_1_header",
            "attackType": {
                "name": "Abuse of Functionality"
            }
        },
        {
            "signatureId": "300000002",
            "signatureType": "request",
            "attackType": {
                "name": "Cross Site Scripting (XSS)"
            },
            "name": "sig_3_uri",
            "lastUpdateMicros": 1731425631000000,
            "revision": "1",
            "risk": "high",
            "accuracy": "high",
            "description": "",
            "rule": "uricontent:\"<script>\"; nocase;",
            "systems": [
                {
                    "name": "Nginx"
                }
            ]
        },
        {
            "name": "sig_2_param",
            "attackType": {
                "name": "Abuse of Functionality"
            },
            "lastUpdateMicros": 1731425549000000,
            "revision": "1",
            "signatureId": "300000001",
            "signatureType": "request",
            "description": "",
            "rule": "valuecontent:!\"param\"; nocase; httponly; norm;",
            "systems": [],
            "accuracy": "high",
            "risk": "high"
        },
        {
            "systems": [
                {
                    "name": "Apache"
                },
                {
                    "name": "Unix/Linux"
                },
                {
                    "name": "Proxy Servers"
                },
                {
                    "name": "Django"
                }
            ],
            "description": "",
            "rule": "valuecontent:\"json123\"; nocase; jsononly; norm;",
            "risk": "high",
            "accuracy": "high",
            "lastUpdateMicros": 1731425782000000,
            "revision": "1",
            "attackType": {
                "name": "Server-Side Request Forgery (SSRF)"
            },
            "name": "sig_5_",
            "signatureType": "request",
            "signatureId": "300000004"
        },
        {
            "description": "",
            "rule": "uricontent:\"etc\"; nocase;",
            "systems": [
                {
                    "name": "Microsoft Windows"
                },
                {
                    "name": "Unix/Linux"
                }
            ],
            "accuracy": "high",
            "risk": "high",
            "name": "sig_4_",
            "attackType": {
                "name": "Path Traversal"
            },
            "lastUpdateMicros": 1731425708000000,
            "revision": "1",
            "signatureId": "300000003",
            "signatureType": "request"
        }
    ]
}
```

Example of generating a user defined signature JSON file (with custom tag):
```shell
docker run -v `pwd`:`pwd` -w `pwd` --entrypoint /opt/app_protect/bin/convert-signatures docker_img:latest -i /path/to/signatures.xml -o /path/to/signatures.json --tag "MyTag" | jq
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

---

## Security Logs

Refer to [Logging Overview]({{< ref "/nap-waf/v5/logging-overview/security-log.md" >}}) section for more details on Security Logs.

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
