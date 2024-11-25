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

    Refer to the example for mTLS deployment in the admin guide, whether you're using [Docker]({{< relref "/nap-waf/v5/admin-guide/deploy-on-docker.md#docker-compose-file-with-mtls" >}}) or [Kubernetes]({{< relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md#mtls-deployment" >}}).
    
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

---

## Policy Converter

The NGINX App Protect WAF v5 Policy Converter tool `/opt/app_protect/bin/convert-policy` is used to convert XML policies to JSON format. The converted JSON policy is based on the NGINX App Protect WAF policy base template and contains the minimal differences to it in JSON declarative policy format.

The XML policy file can be obtained by exporting the policy from the BIG-IP system on which the policy is currently deployed.

Using the tool:

```shell
/opt/app_protect/bin/convert-policy 
```

### Convert Policy using Command Line Interface (CLI Usage)

The input policy can also be converted using convert-policy as a CLI tool from within NGINX App Protect WAF Converter container by using the following commands:

```docker
docker run -it --rm \
  -v $(pwd):/policies \
  --entrypoint="/opt/app_protect/bin/convert-policy" \
  artifactory.f5net.com/f5-waf-docker/nap-x-compiler-image:latest -i test.json -o test.xml
  -i /policies/input_policy.plc \
  -o /policies/output_policy \
  --full-export
```

### Command Line Options

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Field Name   | Notes | 
| ------------| ------| 
| -i | Filename of input WAF or ASM binary policy |
| -o | Filename of output declarative policy |
| --bot-profile  | Filename of JSON Bot Profile (pre-converted to JSON from tmsh syntax) |
| --logging-profile | Filename of JSON Logging Profile (pre-converted to JSON from tmsh syntax) |
| --dos-profile | Filename of JSON DoS Profile (pre-converted to JSON from tmsh syntax) |
| --full-export | If specified, the full policy with all entities will be exported. Otherwise, only entities that differ from the template will be included.<br> Default for the CLI is not specific (only differing entities). <br> Default for the REST endpoint above is "--full-export" (you can not override this).|{{</bootstrap-table>}}

---

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
