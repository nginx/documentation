---
aliases:
- /configuration/
authors: []
categories:
- configuration guide
date: "2021-04-14T13:32:41+00:00"
description: This guide explains the NGINX App Protect WAF security features and how
  to use them.
docs: DOCS-647
doctypes:
- task
draft: false
journeys:
- researching
- getting started
- using
- self service
menu:
  docs:
    parent: NGINX App Protect WAF
    weight: 45
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
title: NGINX App Protect WAF Configuration Guide
toc: true
versions:
- "4.4"
weight: 200
---

## Overview

This guide explains the NGINX App Protect WAF security features and how to use them. This guide also assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.

For more information on the NGINX App Protect WAF security features, see [NGINX App Protect WAF Terminology](#nginx-app-protect-waf-terminology).

{{% important %}} 
When configuring NGINX App Protect WAF, `app_protect_enable` should always be enabled in a `proxy_pass` location. If configuration returns static content, the user must add a location which enables App Protect, and proxies the request via `proxy_pass` to the internal static content location. An example can be found in [Configure Static Location](#configure-static-location).
{{% /important %}} 

## Supported Security Policy Features

The following security features are supported in NGINX App Protect WAF. We show what is enabled in the default policy and the changes that the user can do on top of this policy.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Protection Mechanism | Description | 
| ---| --- | 
|Attack Signatures | Default policy covers all the OWASP top 10 attack patterns enabling signature sets detailed in a section below. The user can disable any of them or add other sets. | 
|Signature attack for Server Technologies | Support adding signatures per added server technology. | 
|Threat Campaigns | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. | 
|HTTP Compliance | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. | 
|Evasion Techniques | All evasion techniques are enabled by default and each can be disabled. These include directory traversal, bad escaped character and more. | 
|Data Guard | Detects and masks credit card and/or US social security numbers in responses. Disabled by default but can be enabled. | 
|Parameter parsing | Support only auto-detect parameter value type and acts according to the result: plain alphanumeric string, XML or JSON. | 
|Disallowed meta characters | Detected in parameter names, parameter values, URLs, headers and in JSON and XML content. Metacharacters indicate suspicious traffic, but not necessarily an actual threat. It is the combination of meta characters, attack signatures and other violations that indicates an actual threat that should be blocked and this is determined by Violation Rating. See section below. | 
|Disallowed file type extension | Support any file type. Default includes a predefined list of file types.  See Disallowed File Types list below. | 
|Cookie enforcement | By default all cookies are allowed and not enforced for integrity. The user can add specific cookies, wildcards or explicit, that will be enforced for integrity. It is also possible to set the cookie attributes: HttpOnly, Secure and SameSite for cookies found in the response. | 
|Sensitive Parameters | Default policy masks the "password" parameter in the security log. It is possible to add more such parameters. | 
|JSON Content | JSON content profile detects malformed content and detects signatures and metacharacters in the property values. Default policy checks maximum structure depth. It is possible to enforce a provided JSON schema and/or enable more size restrictions: maximum total length Of JSON data;  maximum value length; maximum array length; tolerate JSON parsing errors.  JSON parameterization is not supported. | 
|XML Content | XML content profile detects malformed content and detects signatures in the element values. Default policy checks maximum structure depth. It is possible to enable more size restrictions: maximum total length of XML data, maximum number of elements are more. SOAP, Web Services and XML schema features are not supported. | 
|Allowed methods | Check HTTP allowed methods. By default all the standard HTTP methods are allowed. | 
|Deny & Allow IP listing | Manually define denied & allowed IP addresses. | 
|Trust XFF header | Disabled by default. User can enable it and optionally add a list of custom XFF headers. | 
|gRPC Content | gRPC content profile detects malformed content, parses well-formed content, and extracts the text fields for detecting attack signatures and disallowed meta-characters. In addition, it enforces size restrictions and prohibition of unknown fields. The Interface Definition Language (IDL) files for the gRPC API must be attached to the profile. | 
|Large Request Blocking | To increase the protection of resources at both the NGINX Plus and upstream application tiers, NGINX App Protect WAF 3.7 contains a change in the default policy behavior that will block requests that are larger than 10 MB in size even if the Violation Rating is less than 4. In previous versions, requests greater than 10 MB would be allowed. When these requests are blocked, a `VIOL_REQUEST_MAX_LENGTH` violation will be logged.|
{{</bootstrap-table>}}


### Disallowed File Types

The following file types are disallowed by default:

* bak, bat, bck, bkp, cfg, conf, config, ini, log, old, sav, save, temp, tmp
* bin, cgi, cmd, com, dll, exe, msi, sys, shtm, shtml, stm
* cer, crt, der, key, p12, p7b, p7c, pem, pfx
* dat, eml, hta, htr, htw, ida, idc, idq, nws, pol, printer, reg, wmz


### Additional Policy Features


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Feature | Description | 
| ---| --- | 
|Enforcement by Violation Rating | By default block requests that are declared as threats, that is, their Violation Rating is 4 or 5. It is possible to change this behavior: either disable enforcement by Violation Rating or block also request with Violation Rating 3 - needs examination. See section on [basic configuration](#policy-configuration) below. | 
|Request size checks | Upper limit of request size as dictated by the maximum buffer size of 10 MB;  Size checks for: URL, header, Query String, whole request (when smaller than the maximum buffer), cookie, POST data. By default all the checks are enabled with the exception of POST data and whole request. The user can enable or disable every check and customize the size limits. | 
|Malformed cookie | Requests with cookies that are not RFC compliant are blocked by default. This can be disabled. | 
|Status code restriction | Illegal status code in the range of 4xx and 5xx. By default only these are allowed: 400, 401, 404, 407, 417, 503. The user can modify this list or disable the check altogether. | 
|Blocking pages | The user can customize all blocking pages. By default the AJAX response pages are disabled, but the user can enable them. | 
{{</bootstrap-table>}} 


## Attack Signatures Overview

Attack signatures are rules or patterns that identify attack sequences or classes of attacks on a web application and its components. You can apply attack signatures to both requests and responses. App Protect includes predefined attack signatures to protect your application against all attack types identified by the system.

As new attack signatures are identified, they will become available for [download and installation]({{< ref "/nap-waf/admin-guide/install.md#updating-app-protect-attack-signatures" >}}) so that your system will always have the most up-to-date protection. You can update the attack signatures without updating the App Protect release, and conversely, you can update App Protect without changing the attack signature package, unless you upgrade to a new NGINX Plus release.


### Signature Settings

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Setting | JSON Property in Policy | Support in NGINX App Protect WAF | Value in Default Profile | 
| ---| ---| ---| --- | 
|Signature Sets | signature-sets | All available sets. | See signature set list below | 
|Signatures | signatures | "Enabled" flag can be modified. | All signatures in the included sets are enabled. | 
|Auto-Added signature accuracy | minimumAccuracyForAutoAddedSignatures | Editable | Medium | 
{{</bootstrap-table>}} 


### Signature Sets in Default Policy

The following signature sets are included in the default policy. Most of the sets are defined by the Attack Type they protect from. In all sets the **Alarm** flag is enabled and **Block** disabled except High Accuracy Signatures, which are set to **blocked** (`block` parameter is enabled).

- Command Execution Signatures
- Cross Site Scripting Signatures
- Directory Indexing Signatures
- Information Leakage Signatures
- OS Command Injection Signatures
- Path Traversal Signatures
- Predictable Resource Location Signatures
- Remote File Include Signatures
- SQL Injection Signatures
- Authentication/Authorization Attack Signatures
- XML External Entities (XXE) Signatures
- XPath Injection Signatures
- Buffer Overflow Signatures
- Denial of Service Signatures
- Vulnerability Scan Signatures
- High Accuracy Signatures
- Server Side Code Injection Signatures
- CVE Signatures


### Basic Signature Sets Included in App Protect

These signatures sets are included but are not part of the default template.

-   All Response Signatures
-   All Signatures
-   Generic Detection Signatures
-   Generic Detection Signatures (High Accuracy)
-   Generic Detection Signatures (High/Medium Accuracy)
-   High Accuracy Signatures
-   Low Accuracy Signatures
-   Medium Accuracy Signatures
-   OWA Signatures
-   WebSphere signatures
-   HTTP Response Splitting Signatures
-   Other Application Attacks Signatures
-   High Accuracy Detection Evasion Signatures

See [signature sets](#signature-sets) for configuring the signature sets included in your policy.

## Policy Configuration

The NGINX App Protect WAF ships with two reference policies:
- The **default** policy which is identical to the base template and provides OWASP Top 10 and Bot security protection out of the box.
- The **strict** policy contains more restrictive criteria for blocking traffic than the default policy. It is meant to be used for protecting sensitive applications that require more security but with higher risk of false positives.
You can use those policies as is, but usually you will use them as starting points and further customize them to the needs of the applications they protect.

### Policy Configuration Overview

The NGINX App Protect WAF security policy configuration uses the declarative format based on a pre-defined base template. The policy is represented in a JSON file which you can edit to add, modify and remove security capabilities with respect to the base template. The way the policy is integrated into the NGINX configuration is via referencing the JSON file (using the full path) in the `nginx.conf` file.

{{< note >}}NGINX App Protect WAF provides a [JSON Schema](https://json-schema.org/) which can be used to validate a JSON policy file to ensure file format compliance. The schema file can be generated using a script once NGINX App Protect WAF is installed: `sudo /opt/app_protect/bin/generate_json_schema.pl`. This script will output the schema to a file named `policy.json` into the current working directory. Once the schema file is generated, you can use validation tools such as [AJV](https://ajv.js.org/standalone.html) to validate a JSON policy file.{{< /note >}}

In the following example, the NGINX configuration file with App Protect enabled in the HTTP context and the policy /etc/app_protect/conf/NginxDefaultPolicy.json is used:

~~~nginx
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
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:515; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port

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
~~~

### Basic Configuration and the Default Policy

The base template is the common starting point to any policy you write. The default policy just reflects that template without any further modifications, thus we use the terms **base template** and **default policy** interchangeably. The default policy can be found in: `/etc/app_protect/conf/NginxDefaultPolicy.json`.

The default policy enforces violations by **Violation Rating**, the App Protect computed assessment of the risk of the request based on the triggered violations.

- 0: No violation
- 1-2: False positive
- 3: Needs examination
- 4-5: Threat

The default policy enables most of the violations and signature sets with Alarm turned ON, but not Block. These violations and signatures, when detected in a request, affect the violation rating. By default, if the violation rating is calculated to be malicious (4-5) the request will be blocked by the `VIOL_RATING_THREAT` violation. This is true even if the other violations and signatures detected in that request had the Block flag turned OFF. It is the `VIOL_RATING_THREAT` violation having the Block flag turned ON that caused the blocking, but indirectly the combination of all the other violations and signatures in Alarm caused the request to be blocked. By default, other requests which have a lower violation rating are not blocked, except for some specific violations described below. This is to minimize false positives. However, you can change the default behavior. For example, if you want to add blocking on a violation rating of 3 as well, enable blocking for the `VIOL_RATING_NEED_EXAMINATION` violation. 

The following violations and signature sets have a low chance of being false positives and are, therefore, configured by default to block the request regardless of its Violation Rating:
- High accuracy attack signatures
- Threat campaigns
- Malformed request: unparsable header, malformed cookie and malformed body (JSON or XML).

### The Strict Policy

The Strict Policy is recommended as a starting point for applications requiring a higher level of security. Just like all other policies it is based on the base template, so it detects and blocks everything the default policy does. It can be found in: `/etc/app_protect/conf/NginxStrictPolicy.json`.

In addition the Strict Policy also **blocks** the following:
- Requests that have a Violation Rating of 3, "Needs examination". This occurs because the `VIOL_RATING_NEED_EXAMINATION` violation's block flag is enabled in the strict policy.
- Requests with the `VIOL_EVASION` violation (evasion techniques).
- Requests with violations that restrict options in the request and response: HTTP method, response status code and disallowed file types.

{{< note >}} Other violations, specifically attack signatures and metacharacters, which are more prone to false positives, still have only Alarm turned on, without blocking, contributing to the Violation Rating as in the Default policy.{{< /note >}}

In addition, the Strict policy also enables the following features in **alarm only** mode:
- **Data Guard**: masking Credit Card and US Social Security numbers found in HTTP responses.
- **HTTP response data leakage signatures**: preventing exfiltration of sensitive information from the servers.
- **More restrictive limitations**: mainly sizing and parsing of JSON and XML payloads.
- **Cookie attribute insertion**: the Strict policy adds the **Secure** and **SameSite=lax** attributes to every cookie set by the application server. These attributes are enforced by the browsers and protect against session hijacking and CSRF attacks respectively.

### Policy Authoring and Tuning

The policy JSON file specifies the settings that are different from the base template, such as enabling more signatures, disabling some violations, adding server technologies, etc. These will be shown in the next sections.

There are two ways to tune those settings:
- Within the `policy` structure property, the organic structure of the policy.
- Within the `modifications` structure property that contains a list of changes expressed in a generic manner.

Both options are equivalent in their semantic expression power, but different syntactically and are designated for different use cases. But before that, let's look at an example - disabling a specific attack signature.

Signature 200001834 disabled in the `policy` property:

~~~json
{
    "policy": {
        "name": "signature_exclude_1",
        "signatures": [
            {
                "signatureId": 200001834,
                "enabled": false
            }
        ]
    }
}
~~~

As you can see, this is expressed using the `signatures` property that contains configuration of individual signatures in a policy. If you want to modify other parts of the policy, you would use different JSON properties.

The same configuration in the `modifications` array looks like this:

~~~json
{
    "policy": {
        "name": "signature_exclude_2"
    },
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
~~~

Note the generic schema that can express manipulation in any policy element: `entity`, `entityType`, `action` etc. The `modifications` array is a flat list of individual changes applied to the policy after evaluating the `policy` block.

So when to use `policy` and when to use `modifications`? There are some recommended practice guidelines for that:
- Use `policy` to express the security policy as you intended it to be: the features you want to enable, disable, the signature sets, server technologies and other related configuration attributes. This part of the policy is usually determined when the application is deployed and changes at a relatively slow pace.
- Use `modifications` to express **exceptions** to the intended policy. These exceptions are usually the result of fixing false positive incidents and failures in tests applied to those policies. Usually these are granular modifications, typically disabling checks of individual signatures, metacharacters and sub-violations. These changes are more frequent.
- Use `modifications` also for **removing** individual collection elements from the base template, for example disallowed file types.

It is a good practice to separate the `modifications` to a different file and have the main policy file reference the former, as the two parts have different lifecycles.

The sections just below review the common policy feature configurations using examples. For the full reference of the `policy` JSON properties see the Declarative Policy guide.

#### Policy Enforcement Modes

A policy's enforcement mode can be:

- **Blocking:** Any illegal or suspicious requests are logged and blocked.
- **Transparent:** Any illegal or suspicious requests are logged but not blocked.

Specific security features can be defined as blocked or transparent in the policy.

Blocking Mode example:

~~~json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    }
}
~~~

Transparent Mode example:

~~~json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "transparent"
    }
}
~~~

#### Enabling Violations

 Adding and enabling additional security features to the policy can be done by specifying the violation name and the `alarm` block state to "true". To set different states to sub-violations within the violation, enable the violation first, then specifying and enable the sub-violations. Also, a violation may have its own section that provides additional configuration granularity for a specific violation/sub-violation.

{{< note >}}
The attack signature violation `VIOL_ATTACK_SIGNATURE` cannot be configured by the user. Rather, the violation is determined by the combination of the [signature sets](#signature-sets) on the policy.
{{< /note >}}

 The examples below show how to enable a violation and sub-violation in a declarative format.

##### Configuration Details Example

 In this example, we enable 2 violations: `VIOL_JSON_FORMAT` and `VIOL_PARAMETER_VALUE_METACHAR`.

Note that the example defines the blocking and alarm setting for each violation. These settings override the default configuration set above in the `enforcementMode` directive.  Be aware, however, that in a transparent policy no violations are blocked, even if specific violations are set to **block: true** in the configuration.

~~~json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_JSON_FORMAT",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": false,
                    "block": false
                }
            ]
        }
    }
}
~~~

#### HTTP Compliance

HTTP compliance is one of the basic application security violations. It validates the request itself and also prevents the use of the HTTP protocol as an entry point to the application.

In this example, we enable the HTTP compliance violation with the blocking as true. We also configure (enabled or disabled) all of its sub-violations in the relevant HTTP section.  Note that you can add/remove sub-violations to match your desired configurations. However, not listing a violation does not mean it will be disabled.  Rather, it would actually mean that the default configuration would not be overridden for that specific sub-violation.

~~~json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_PROTOCOL",
                    "alarm": true,
                    "block": true
                }
            ],
            "http-protocols": [
                {
                    "description": "Header name with no header value",
                    "enabled": true
                },
                {
                    "description": "Chunked request with Content-Length header",
                    "enabled": true
                },
                {
                    "description": "Check maximum number of parameters",
                    "enabled": true,
                    "maxParams": 5
                },
                {
                    "description": "Check maximum number of headers",
                    "enabled": true,
                    "maxHeaders": 20
                },
                {
                    "description": "Body in GET or HEAD requests",
                    "enabled": true
                },
                {
                    "description": "Bad multipart/form-data request parsing",
                    "enabled": true
                },
                {
                    "description": "Bad multipart parameters parsing",
                    "enabled": true
                },
                {
                    "description": "Unescaped space in URL",
                    "enabled": true
                }
            ]
        }
    }
}
~~~


#### Evasion Techniques

Evasion techniques refers to techniques usually used by hackers to attempt to access resources or evade what would otherwise be identified as an attack. Like HTTP compliance, evasion techniques have a list of sub-violations that can be configured for additional granularity and to reduce false positives.

In this example, we enable the evasion technique violation with the blocking as true. We also configure (enabled or disabled) all of its sub-violations in the relevant section. Note that you can add/remove sub-violations to match your desired configurations. However, not listing a violation does not mean it will be disabled.  Rather, it would actually mean that the default configuration would not be overridden for that specific sub-violation.

~~~json
{
    "policy": {
        "name": "evasions_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_EVASION",
                    "alarm": true,
                    "block": true
                }
            ],
            "evasions": [
                {
                    "description": "Bad unescape",
                    "enabled": true
                },
                {
                    "description": "Directory traversals",
                    "enabled": true
                },
                {
                    "description": "Bare byte decoding",
                    "enabled": true
                },
                {
                    "description": "Apache whitespace",
                    "enabled": true
                },
                {
                    "description": "Multiple decoding",
                    "enabled": true,
                    "maxDecodingPasses": 2
                },
                {
                    "description": "IIS Unicode codepoints",
                    "enabled": true
                },
                {
                    "description": "IIS backslashes",
                    "enabled": true
                },
                {
                    "description": "%u decoding",
                    "enabled": true
                }
            ]
        }
    }
}
~~~

#### User-defined HTTP Headers

HTTP header enforcement refers to the handling of the headers section as a special part of the request. These header elements are parsed and enforced based on header specific criteria. However, it is important to distinguish between 2 distinct types of enforcement for HTTP headers:

* The first type of header enforcement is global enforcement for all header content, regardless of the header field name or value. This type of enforcement enables/disables violations that are effective for all contents of the header section of the request. Examples of this are `VIOL_HEADER_LENGTH` and `VIOL_HEADER_METACHAR`. These violations can be configured in the `blocking-settings` section under the `violations` list in the declarative policy.
* The second type of header enforcement is the ability to configure certain violations that are relevant only to specific header fields. Examples of this are allowing repeated instances of the same header field and enabling/disabling Attack Signature checks for an HTTP header field. These violations are configured in the `headers` section where we configure each HTTP header element separately as an object in the list. Additionally, the corresponding violations need to be enabled in the `blocking-settings` section under the `violations` list for them to be enforced.

As far as the header field enforcement is concerned, the following violations are enabled by default:
* `VIOL_HEADER_REPEATED` (in Block mode)
* `VIOL_MANDATORY_HEADER` (in Alarm mode)

There are 3 additional violations that are part of the header enforcement but are specific to the Cookie header alone:
* `VIOL_COOKIE_LENGTH` (in Alarm mode)
* `VIOL_COOKIE_MALFORMED` (in Block mode)
* `VIOL_COOKIE_MODIFIED` (in Alarm mode)

In the base template, there are 4 header objects configured by default:
* `* (wildcard)` - This entity represents the default action taken for all the header fields that have not been explicitly defined in the headers section.
* `Cookie` - This entity handles the `Cookie` header field; this object is just a placeholder and does not affect configuration (See the cookie note below).
* `Referer` - This entity handles the `Referer` header field.
* `Authorization` - This entity handles the `Authorization` header field.
* `Transfer-Encoding` - This entity handles the `Transfer-Encoding` header field.

It is important to emphasize that the Cookie header field is a special case because its behavior is determined by and configured in the `cookie` policy entity rather than the `header` entity. The `Cookie` HTTP header entity is only a placeholder in that it is read-only and does not affect the way cookies are enforced. To modify the configuration of the cookie header field behavior, modify the respective `cookie` entity in the declarative policy.

It is possible to customize the policy configuration using different enforcement modes of the above two violations, as well as configuring custom header elements. For example, we can add a new header `Myheader` and exclude this header from attack signature checks. Alternatively, we can specify a mandatory header that should be present in all requests being sent to our application.

Following is an example configuration where we enable Header violations in blocking mode, create a custom header `MyHeader`, and configure this custom header to allow multiple occurrences of the same header, disable checking attack signatures for the header, and mark it as optional (not mandatory):

~~~json
{
    "policy": {
        "name": "user_headers_blocking_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MANDATORY_HEADER",
                    "block": true
                }
            ]
        },
        "headers": [
            {
                "name": "MyHeader",
                "type": "explicit",
                "decodeValueAsBase64": "disabled",
                "htmlNormalization": false,
                "mandatory": false,
                "allowRepeatedOccurrences": true,
                "checkSignatures": false
            }
        ]
    }
}
~~~

### Anti Automation (Bot Mitigation)

Anti Automation provides basic bot protection by detecting bot signatures and clients that falsely claim to be browsers or search engines. The `bot-defense` section in the policy is enabled by default. Anti Automation encompasses both Bot Signatures and Header Anomalies, each of which can be disabled separately.


#### Bot Signatures

Bot Signatures provide basic bot protection by detecting bot signatures in the User-Agent header and URI. 
Each bot signature belongs to a bot class. Search engine signatures such as `googlebot` are under the trusted_bots class, but App Protect performs additional checks of the trusted bot's authenticity. If these checks fail, it means that the respective client impersonated the search engine in the signature and it will be classified as class - `malicous_bot`, anomaly - `Search engine verification failed`, and the request will be blocked, irrespective of the class's mitigation actions configuration.
An action can be configured for each bot class, or may also be configured per each bot signature individually:
* `ignore`    - bot signature is ignored (disabled)
* `detect`    - only report without raising the violation - `VIOL_BOT_CLIENT`. The request is considered `legal` unless another violation is triggered.
* `alarm`     - report, raise the violation, but pass the request. The request is marked as `illegal`.
* `block`     - report, raise the violation, and block the request

In this example we show how to enable bot signatures using the default bot configuration:

~~~json

{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            }
        }
    }
}
~~~

The default actions for classes are: `detect` for `trusted-bot`, `alarm` for `untrusted-bot`, and `block` for `malicious-bot`. In this example, we enabled bot defense and specified that we want to raise a violation for `trusted-bot`, and block for `untrusted-bot`.


~~~json
{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            },
            "mitigations": {
                "classes": [
                    {
                        "name": "trusted-bot",
                        "action": "alarm"
                    },
                    {
                        "name": "untrusted-bot",
                        "action": "block"
                    },
                    {
                        "name": "malicious-bot",
                        "action": "block"
                    }
                ]
            }
        }
    }
}
~~~

In this example, we override the action for a specific signature (python-requests)

~~~json
{
    "policy": {
        "name": "bot_defense_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "settings": {
                "isEnabled": true
            },
            "mitigations": {
                "signatures": [
                    {
                        "action": "ignore",
                        "name": "python-requests"
                    }
                ]
            }
        }
    }
}
~~~

#### List of Trusted Bots

This is a list of the trusted bots that are currently part of the bot signatures. As the title suggests, these bot signatures belong to the `trusted-bot` class and currently all are search engines.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Bot Name | Description | 
| ---| --- | 
|Ask | [Ask.com engine](https://www.ask.com) | 
|Baidu | [Baidu search engine](https://www.baidu.com/) | 
|Baidu Image Spider | [Baidu search engine for images](https://image.baidu.com/) | 
|Bing | [Microsoft Bing search engine](https://www.bing.com/) | 
|BingPreview | [Microsoft Bing page snapshot generation engine](https://www.bing.com/) | 
|Daum | [Daum search engine](https://www.daum.net/) | 
|DuckDuckGo Bot | [DuckDuckGo search engine](https://duckduckgo.com/) | 
|fastbot | [fastbot search engine](https://www.fastbot.de/) | 
|Google | [Google search engine](https://www.google.com/) | 
|MojeekBot | [Mojeek search engine](https://www.mojeek.com/) | 
|Yahoo! Slurp | [Yahoo search engine](https://www.yahoo.com/) | 
|Yandex | [Yandex search engine](https://yandex.com/) | 
|YioopBot | [Yioop search engine](https://www.yioop.com/) | 
{{</bootstrap-table>}} 


#### Header Anomalies

In addition to detecting Bot Signatures, by default NGINX App Protect WAF verifies that a client claiming to be a browser is indeed one by inspecting the HTTP headers.
Each request receives a score, is categorized by anomaly, and is enforced according to the default configured anomaly action:


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Range | Anomaly | Action | Class | 
| ---| ---| ---| --- | 
|0-49 | None | None | Browser | 
|50-99 | Suspicious HTTP Headers Presence or Order | Alarm | Suspicious Browser | 
|100 and above | Invalid HTTP Headers Presence or Order | Block | Malicious Bot | 
| Non Applicable | SEARCH_ENGINE_VERIFICATION_FAILED | Block | Malicious Bot | 
{{</bootstrap-table>}} 


Notice that the default scores for each anomaly can be changed. In this example, we override the score and action of the default bot configuration:

~~~json

{
    "policy": {
        "name": "bot_anomalies_and_signatures",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "bot-defense": {
            "mitigations": {
                "anomalies": [
                    {
                        "name": "Suspicious HTTP Headers",
                        "action": "alarm",
                        "scoreThreshold": 50
                    },
                    {
                        "name": "Invalid HTTP Headers",
                        "action": "block",
                        "scoreThreshold": 99
                    }
                ]
            }
        }
    }
}

~~~

### Signature Sets

The default and strict policies include and enable common signature sets, which are categorized groups of [signatures](#attack-signatures-overview) applied to the policy. However, you may wish to modify the list of signature sets and their logging and enforcement settings via the `signature-sets` array property. There are several ways to configure the enforced signature sets.

One way is by use of the `All Signatures` signature set, which is simply a predefined signature set that includes all signatures known to NGINX App Protect WAF.

In this example, the `All Signatures` set (and therefore the signatures included within) are configured to be enforced and logged respectively, by setting their `block` and `alarm` properties:

~~~json
{
    "policy": {
        "name": "attack_sigs",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    }
}
~~~

In this example, only high accuracy signatures are configured to be enforced, but SQL Injection signatures are detected and reported:

~~~json
{
    "policy": {
        "name": "attack_sigs",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "High Accuracy Signatures",
                "block": true,
                "alarm": true
            },
            {
                "name": "SQL Injection Signatures",
                "block": false,
                "alarm": true
            }
        ]
    }
}
~~~

Since the “All Signatures” set is not included in the default policy, turning OFF both alarm and block has no effect because all the other sets with alarm turned ON (and high accuracy signatures with block enabled) are still in place and a signature that is a member of multiple sets behaves in accordance with the strict settings of all sets it belongs to. The only way to remove signature sets is to remove or disable sets that are part of the [default policy](#signature-sets-in-default-policy).

For example, in the below default policy, even though All Signature's Alarm/Block settings are set to false, we cannot ignore all attack signatures enforcement as some of the signature sets will be enabled in their strict policy. If the end users want to remove a specific signature set then they must explicitly mention it under the [strict policy](#the-strict-policy).

~~~json
{
    "policy": {
        "name": "signatures_block",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "Generic Detection Signatures (High/Medium Accuracy)",
                "block": false,
                "alarm": false
            },
            {
                "name": "All Signatures",
                "block": false,
                "alarm": false
            }
        ]
    }
}
~~~

A signature may belong to more than one set in the policy. Its behavior is determined by the most severe action across all the sets that contain it. In the above example, a high accuracy SQL injection signature will both alarm and block, because the `High Accuracy Signatures` set is blocking and both sets trigger alarm.

The default policy already includes many signature sets, most of which are determined by the attack type these signatures protect from, for example `Cross-Site Scripting Signatures` or `SQL Injection Signatures`. See [the full list](#signature-sets-in-default-policy) above. In some cases you may want to exclude individual signatures.

In this example, signature ID 200001834 is excluded from enforcement:

~~~json
{
    "policy": {
        "name": "signature_exclude",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ],
        "signatures": [
            {
                 "signatureId": 200001834,
                 "enabled": false
            }
        ]
    }
}
~~~

Another way to exclude signature ID 200001834 is by using the `modifications` section instead of the `signatures` section used in the example above:

~~~json
{
    "policy": {
        "name": "signature_modification_entitytype",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    },
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
~~~

To exclude multiple attack signatures, each signature ID needs to be added as a separate entity under the `modifications` list:

~~~json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        },
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200004461
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
~~~

In the above examples, the signatures were disabled for all the requests that are inspected by the respective policy. You can also exclude signatures for specific URLs or parameters, while still enable them for the other URLs and parameters. See the sections on [User-Defined URLs](#user-defined-urls) and [User-Defined Parameters](#user-defined-parameters) for details.

In some cases, you may want to remove a whole signature set that was included in the default policy. For example, suppose your protected application does not use XML and hence is not exposed to XPath injection. You would like to remove the set `XPath Injection Signatures`. There are two ways to do that. The first is to set the `alarm` and `block` flags to `false` for this signature set overriding the settings in the base template:

~~~json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "block": false,
                 "alarm": false
            }
        ]
    }
}   
~~~

The second way is to remove this set totally from the policy using the `$action` meta-property.

~~~json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "$action": "delete"
            }
        ]
    }
}   
~~~

Although the two methods are functionally equivalent, the second one is preferable for performance reasons. 


#### Server Technologies

Another way to configure attack signature sets is by applying server technologies. Server technologies applies sets of signatures that would be relevant to attacks targeted to a specific OS, application, or server type. The Server technologies are represented in attack signatures as `systems` using the same name, for example `SharePoint`. Note, however, that the overlap between Server technologies and signature systems is not complete: there are server technologies that cannot be represented as signature systems, and also a few generic signature systems that are not represented as server technologies. The exact details will follow in the sections just below. Server technologies that are not signature systems will not bring in new signatures when added to the policy. However, associating them with the policy still has declarational value, and in one of the future signature updates they may be associated with new signatures.

In this example, we enable the attack signature violation, and enabled the **Apache/NCSA HTTP Server** server technology, which in turn enables attack signatures specific to this type of technology. We also enabled signatures with minimum accuracy of low. This would include low, medium, and high accuracy attack signatures.

~~~json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-settings": {
            "minimumAccuracyForAutoAddedSignatures": "low"
        },
        "server-technologies": [
            { "serverTechnologyName": "Apache/NCSA HTTP Server" }
        ]
    }
}
~~~


##### Available Server Technologies

The table below lists all the available Server Technologies. Some of them are built on top others on the stack and including them implies the inclusion of the latter. For example: ASP.NET implies both IIS and Microsoft Windows. This is indicated in the "implied technologies" column when applicable. We also denote the server technologies that currently have a signature system counterpart.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Server Technology Name | Description | Implied Technologies | Signature System? | 
| ---| ---| ---| --- | 
|Jenkins | Jenkins is an open source automation server written in Java. Jenkins helps to automate the non-human part of the software development process, with continuous integration and facilitating technical aspects of continuous delivery. It is a server-based system that runs in servlet containers such as Apache Tomcat. |  | Yes | 
|SharePoint | SharePoint is a web-based collaborative platform that integrates with Microsoft Office. Launched in 2001, SharePoint is primarily sold as a document management and storage system, but the product is highly configurable and usage varies substantially among organizations. |  | Yes | 
|Oracle Application Server | Oracle Internet Application Server provides a single integrated packaged solution of for middleware infrastructure including Oracle Containers for J2EE, Oracle Web Cache, Oracle HTTP Server, Oracle Forms, Oracle Reports, Oracle Portal and Oracle Discoverer. |  | Yes | 
|Python | Python is an interpreted, high-level, general-purpose programming language. Created by Guido van Rossum and first released in 1991, Python has a design philosophy that emphasizes code readability, notably using significant whitespace. It provides constructs that enable clear programming on both small and large scales. |  | Yes | 
|Oracle Identity Manager | Oracle Identity Manager (OIM) enables enterprises to manage the entire user lifecycle across all enterprise resources both within and beyond a firewall. Within Oracle Identity Management it provides a mechanism for implementing the user-management aspects of a corporate policy. |  | Yes | 
|Spring Boot | Spring Boot makes it easy to create Spring-powered, production-grade applications and services with absolute minimum fuss. It takes an opinionated view of the Spring platform so that new and existing users can quickly get to the bits they need. |  | Yes | 
|CouchDB | Apache CouchDB is open source database software that focuses on ease of use and having a scalable architecture. |  | Yes | 
|SQLite | SQLite is a relational database management system contained in a C programming library. In contrast to many other database management systems, SQLite is not a client-server database engine. Rather, it is embedded into the end program. |  | Yes | 
|Handlebars | Handlebars provides the power necessary to let you build semantic templates effectively with no frustration. |  | No | 
|Mustache | Mustache is a simple web template system. |  | No | 
|Prototype | Prototype takes the complexity out of client-side web programming. Built to solve real-world problems, it adds useful extensions to the browser scripting environment and provides elegant APIs around the clumsy interfaces of Ajax and the Document Object Model. |  | No | 
|Zend | Zend Server is a complete and certified PHP distribution stack fully maintained and supported by Zend Technologies. It ships with an updated set of advanced value-add features designed to optimize productivity, performance, scalability and reliability. |  | No | 
|Redis | Redis is an open source in-memory data structure project implementing a distributed, in-memory key-value database with optional durability. Redis supports different kinds of abstract data structures, such as strings, lists, maps, sets, sorted sets, hyperloglogs, bitmaps, streams and spatial indexes. |  | Yes | 
|Underscore.js | Underscore.js is a JavaScript library which provides utility functions for common programming tasks. It is comparable to features provided by Prototype.js and the Ruby language, but opts for a functional programming design instead of extending object prototypes |  | No | 
|Ember.js | Ember.js is an open source JavaScript web framework, based on the Model-view-viewmodel pattern. It allows developers to create scalable single-page web applications by incorporating common idioms and best practices into the framework. |  | No | 
|ZURB Foundation | Foundation is a responsive front-end framework. Foundation provides a responsive grid and HTML and CSS UI components, templates, and code snippets, including typography, forms, buttons, navigation and other interface elements, as well as optional functionality provided by JavaScript extensions. Foundation is maintained by ZURB and is an open source project. |  | No | 
|ef.js | ef.js is an elegant HTML template engine & basic framework. |  | No | 
|Vue.js | Vue.js is an open source JavaScript framework for building user interfaces and single-page applications. |  | No | 
|UIKit | UIkit is a lightweight and modular front-end framework for developing fast and powerful web interfaces. |  | No | 
|TYPO3 CMS | TYPO3 is a free and open source web content management system written in PHP. It is released under the GNU General Public License. It can run on several web servers, such as Apache or IIS, on top of many operating systems, among them Linux, Microsoft Windows, FreeBSD, macOS and OS/2. |  | No | 
|RequireJS | RequireJS is a JavaScript library and file loader which manages the dependencies between JavaScript files and in modular programming. It also helps to improve the speed and quality of the code. |  | No | 
|React | React is a JavaScript library for building user interfaces. It is maintained by Facebook and a community of individual developers and companies. React can be used as a base in the development of single-page or mobile applications. |  | Yes | 
|MooTools | MooTools is a lightweight, object-oriented JavaScript framework. It is released under the free, open source MIT License. |  | No | 
|Laravel | Laravel is a free, open source PHP web framework, created by Taylor Otwell and intended for the development of web applications following the model-view-controller architectural pattern and based on Symfony. |  | No | 
|Google Web Toolkit | Google Web Toolkit, or GWT Web Toolkit, is an open source set of tools that allows web developers to create and maintain complex JavaScript front-end applications in Java. Other than a few native libraries, everything is Java source that can be built on any supported platform with the included GWT Ant build files. |  | No | 
|Express.js | Express.js, or simply Express, is a web application framework for Node.js, released as free and open source software under the MIT License. It is designed for building web applications and APIs. It has been called the de facto standard server framework for Node.js. |  | No | 
|CodeIgniter | CodeIgniter is an open source software rapid development web framework, for use in building dynamic web sites with PHP. |  | No | 
|Backbone.js | Backbone.js is a JavaScript library with a RESTful JSON interface and is based on the Model-view-presenter application design paradigm. Backbone is known for being lightweight, as its only hard dependency is on one JavaScript library, Underscore.js, plus jQuery for use of the full library. |  | No | 
|AngularJS | AngularJS is a JavaScript-based open source front-end web application framework mainly maintained by Google and by a community of individuals and corporations to address many of the challenges encountered in developing single-page applications. |  | Yes | 
|JavaScript | JavaScript, often abbreviated as JS, is a high-level, interpreted programming language that conforms to the ECMAScript specification. It is a language which is also characterized as dynamic, weakly typed, prototype-based and multi-paradigm. |  | Yes | 
|NGINX | NGINX is a web server which can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache. |  | Yes | 
|Jetty | Jetty is a Java HTTP (Web) server and Java Servlet container | Java Servlets/JSP | Yes | 
|Joomla | Joomla is a free and open source content management system (CMS) for publishing web content. | PHP | Yes | 
|JavaServer Faces (JSF) | JavaServer Faces (JSF) is a Java specification for building component-based user interfaces for web applications. | Java Servlets/JSP | Yes | 
|Ruby | Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. |  | Yes | 
|MongoDB | MongoDB is a free and open source cross-platform document-oriented database program. |  | Yes | 
|Django | Django is a free and open source web framework, written in Python, which follows the model-view-template (MVT) architectural pattern. |  | Yes | 
|Node.js | Node.js is an open source, cross-platform JavaScript runtime environment for developing a diverse variety of tools and applications. |  | Yes | 
|Citrix | Citrix Systems, Inc. is an American multinational software company that provides server, application and desktop virtualization, networking, software as a service (SaaS), and cloud computing technologies. |  | Yes | 
|JBoss | The JBoss Enterprise Application Platform (or JBoss EAP) is a subscription-based/open source Java EE-based application server runtime platform used for building, deploying, and hosting highly-transactional Java applications and services. | Java Servlets/JSP | Yes | 
|Elasticsearch | Elasticsearch is a search engine based on Lucene. |  | Yes | 
|Apache Struts | Apache Struts is an open source web application framework for developing Java EE web applications. | Java Servlets/JSP | Yes | 
|XML | Extensible Markup Language (XML) is a markup language that defines a set of rules for encoding documents in a format that is both human-readable and machine-readable. |  | Yes | 
|PostgreSQL | PostgreSQL, often simply Postgres, is an object-relational database (ORDBMS) - i.e., an RDBMS, with additional (optional use) \"object\" features - with an emphasis on extensibility and standards-compliance. |  | Yes | 
|IBM DB2 | IBM DB2 contains database server products developed by IBM. |  | Yes | 
|Sybase/ASE | SAP ASE (Adaptive Server Enterprise), originally known as Sybase SQL Server, and also commonly known as Sybase DB or ASE, is a relational model database server product for businesses developed by Sybase Corporation which became part of SAP AG. |  | Yes | 
|CGI | Common Gateway Interface (CGI) offers a standard protocol for web servers to interface with executable programs running on a server that generate web pages dynamically. |  | Yes | 
|Proxy Servers | A proxy server is a server (a computer system or an application) that acts as an intermediary for requests from clients seeking resources from other servers. |  | Yes | 
|SSI (Server Side Includes) | Server Side Includes (SSI) is a simple interpreted server-side scripting language used almost exclusively for the Web. |  | Yes | 
|Cisco | Cisco Systems, Inc. is an American multinational corporation technology company headquartered in San Jose, California, that designs, manufactures and sells networking equipment worldwide. |  | Yes | 
|Novell | Novell Directory Services (NDS) is a popular software product for managing access to computer resources and keeping track of the users of a network, such as a company's intranet, from a single point of administration. |  | Yes | 
|Macromedia JRun | JRun is a J2EE application server, originally developed in 1997 as a Java Servlet engine by Live Software and subsequently purchased by Allaire, who brought out the first J2EE compliant version. |  | Yes | 
|BEA Systems WebLogic Server | Oracle WebLogic Server is a Java EE application server currently developed by Oracle Corporation. | Java Servlets/JSP | Yes | 
|Lotus Domino | IBM Notes and IBM Domino are the client and server, respectively, of a collaborative client-server software platform sold by IBM. |  | Yes | 
|MySQL | MySQL is an open source relational database management system (RDBMS). |  | Yes | 
|Oracle | Oracle Database (commonly referred to as Oracle RDBMS or simply as Oracle) is an object-relational database management system produced and marketed by Oracle Corporation. |  | Yes | 
|Microsoft SQL Server | Microsoft SQL Server is a relational database management system developed by Microsoft. |  | Yes | 
|PHP | PHP is a server-side scripting language designed primarily for web development but is also used as a general-purpose programming language. |  | Yes | 
|Outlook Web Access | Outlook on the web (previously called Exchange Web Connect, Outlook Web Access, and Outlook Web App in Office 365 and Exchange Server 2013) is a personal information manager web app from Microsoft. | ASP.NET, IIS, Microsoft Windows | Yes | 
|Apache/NCSA HTTP Server | The Apache HTTP Server, colloquially called Apache, is the world's most used web server software. |  | Yes | 
|Apache Tomcat | Apache Tomcat, often referred to as Tomcat, is an open source Java Servlet Container developed by the Apache Software Foundation (ASF). | Java Servlets/JSP | Yes | 
|WordPress | WordPress is a free and open source content management system (CMS) based on PHP and MySQL. | XML, PHP | Yes | 
|Macromedia ColdFusion | Adobe ColdFusion is a commercial rapid web application development platform created by JJ Allaire in 1995. |  | Yes | 
|Unix/Linux | Unix is a family of multitasking, multiuser computer operating systems that derive from the original AT&T Unix, developed in the 1970s at the Bell Labs research center by Ken Thompson, Dennis Ritchie, and others. |  | Yes | 
|Microsoft Windows | Microsoft Windows (or simply Windows) is a meta-family of graphical operating systems developed, marketed, and sold by Microsoft. |  | Yes | 
|ASP.NET | ASP.NET is an open source server-side web application framework designed for web development to produce dynamic web pages. | IIS, Microsoft Windows | Yes | 
|Front Page Server Extensions (FPSE) | FrontPage Server Extensions are a software technology that allows Microsoft FrontPage clients to communicate with web servers, and provide additional functionality intended for websites. |  | Yes | 
|IIS | Internet Information Services (IIS, formerly Internet Information Server) is an extensible web server created by Microsoft for use with Windows NT family. | Microsoft Windows | Yes | 
|WebDAV | Web Distributed Authoring and Versioning (WebDAV) is an extension of the Hypertext Transfer Protocol (HTTP) that allows clients to perform remote Web content authoring operations. |  | Yes | 
|ASP | Active Server Pages (ASP), later known as Classic ASP or ASP Classic, is Microsoft's first server-side script engine for dynamically generated web pages. | IIS, Microsoft Windows | Yes | 
|Java Servlets/JSP | A Java servlet is a Java program that extends the capabilities of a server. |  | Yes | 
|jQuery | jQuery is a cross-platform JavaScript library designed to simplify the client-side scripting of HTML. |  | Yes | 
{{</bootstrap-table>}} 

##### Generic Signature Systems

These signature systems are generic and do not represent a particular technology, therefore do not have a server technology counterpart. Yet, there are signatures associated with them. The `Generic Detection Signatures` factory signature set includes most of these signatures. You can define your own signature sets using one or more of those systems.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|System Name | Description | 
| ---| --- | 
|Other Web Server | Web Servers that are not covered by any of the specific server technologies | 
|System Independent | Used to denote signatures that apply to any server technology | 
|Various Systems | Server-side systems not covered by any of the existing server technologies or the other systems here | 
|Generic Database | Database systems that are not covered by any of the specific server technologies | 
{{</bootstrap-table>}} 


#### Threat Campaigns

Threat Campaigns is a threat intelligence feature included in an NGINX App Protect WAF subscription. The feature includes frequent update feeds containing contextual information about active attack campaigns currently being observed by F5 Threat Labs that NGINX App Protect WAF can provide protection against. As an example, without threat campaign updates NGINX App Protect WAF (and any WAF in general) may detect an attack pattern in a web application form parameter, but it cannot correlate the singular attack incident as part of a more extensive and sophisticated threat campaign. Threat Campaigns' contextual information is very specific to current attack campaigns, allowing false positives to be virtually non-existent.

Just like attack signatures, the Threat Campaign patterns are updated regularly. Unlike attack signatures, the NGINX App Protect WAF installation does not include any Threat Campaigns and you need to install them in order for the protection to take effect. Due to the highly dynamic nature of those campaigns the updates are issued far more frequently than the attack signatures. You need to install those updates close to the time they are issued in order to get the most effective protection.

The default policy enables the mechanism with all available Threat Campaigns and blocks when detecting one. Since the risk of false positive is very low, you do not need to enable or disable specific Threat Campaigns. Rather, you can disable the whole mechanism or decide to only alarm rather than block. You can do that by modifying the properties of the Threat Campaign Violation - `VIOL_THREAT_CAMPAIGN`.

In this example we disable both alarm and blocking.

 ```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_THREAT_CAMPAIGN",
                    "alarm": false,
                    "block": false
                }
            ]
        }
    }
}

```

#### Data Guard - Blocking

Data Guard is a security feature that can be used to prevent the leakage of sensitive information from an application. This could be credit card numbers or Social Security numbers (CCN, SSN, etc.). Once this feature is enabled, sensitive data is either blocked or masked, depending on the configuration.

In this example, we enable the data guard violation in blocking mode. In the detailed configuration, we enable enforcement of data guard and specify which items are being protected against information leakage. Note that if blocking is enabled, data masking will have no effect in this case.

~~~json
{
    "policy": {
        "name": "dataguard_blocking",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
~~~

#### Data Guard - Masking

Masking is used when we do not want to block the page entirely but want to mask all sensitive data in the response.

In this example, we enable data guard in alarm mode. In the detailed configuration, we enable enforcement of data guard and specify which items are being protected against information leakage.

~~~json
{
    "policy": {
        "name": "nginx_default_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
~~~

#### File Types

A user can enable/disable specific file types in the policy.

In this example, we enable the file type violation in blocking mode. In the detailed configuration, we allow the \* wildcard entity which would allow all file types by default. In the last section, we explicitly disable the `bat` file type. This is an example of allowing all, but specifically blocking (via deny list) certain items.  You may add as many file types as you wish, each declared in its own curly brackets, along with the `"allowed": false` directive.

~~~json
{
    "policy": {
        "name": "policy1",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_FILETYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "filetypes": [
            {
                "name": "*",
                "type": "wildcard",
                "allowed": true,
                "checkPostDataLength": false,
                "postDataLength": 4096,
                "checkRequestLength": false,
                "requestLength": 8192,
                "checkUrlLength": true,
                "urlLength": 2048,
                "checkQueryStringLength": true,
                "queryStringLength": 2048,
                "responseCheck": false
            },
            {
                "name": "bat",
                "allowed": false
            }
        ]
    }
}
~~~


#### Allowed Methods

  In the policy, you can specify what methods to allow or disallow.

  In this example, we enable the illegal method violation in blocking mode. In the methods configuration, we define which of the methods are allowed. If a method is allowed by default, it can be disallowed via `"$action": "delete"`. In the following example we disallow the default allowed method `PUT` by removing it from the default enforcement. For illustrative purposes this example also has all the other methods that are allowed by default defined in the configuration, but in practicality they do not actually need to be included explicitly to be allowed:


~~~json
{
    "policy": {
        "name": "blocking_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_METHOD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "methods": [
            {
                "name": "GET"
            },
            {
                "name": "POST"
            },
            {
                "name": "HEAD"
            },
            {
                "name": "PUT",
                "$action": "delete"
            },
            {
                "name": "PATCH"
            },
            {
                "name": "DELETE"
            },
            {
                "name": "OPTIONS"
            }
        ]
    }
}
~~~

#### Custom Method Enforcement

To enable any custom method other than the above mentioned HTTP standard methods, the user must configure the specific modules that allow those methods. NGINX will reject any custom method other than the standard allowed HTTP methods GET, POST, PUT, DELETE, HEAD, and OPTIONS.

For example, see currently supported [WebDAV Methods](https://nginx.org/en/docs/http/ngx_http_dav_module.html).

#### Response Codes

Response codes are a general setting that defines which response codes are acceptable, while all others will be blocked.

In this example, we enable the response status codes violation in blocking mode. In the general configuration, we define which of the response codes are allowed. This would mean that all others will be considered as illegal response codes and will be blocked. In this configuration, you specify a list of comma-separated response codes that are allowed.


~~~json
{
    "policy": {
        "name": "allowed_response",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_RESPONSE_STATUS",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "general": {
            "allowedResponseCodes": [
                400,
                401,
                403,
                404,
                502,
                499
            ]
        }
    }
}
~~~

#### Parameters

When configuring handling of parameters, it is a bit different from other configurations we have dealt with earlier, where we enable a violation and configure its details. With parameters, there are a number of independent violations that need to be enabled on their own, as well as a parameter section to define further customization. The full list of parameter violations can be extracted from the above violation list.


~~~json
{
    "policy": {
        "name": "parameters_blocking",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "checkMetachars": true,
                "parameterLocation": "any",
                "valueType": "auto-detect",
                "metacharsOnParameterValueCheck": true,
                "name": "*",
                "type": "wildcard",
            }
        ]
    }
}
~~~

In this example we configure allowed meta-characters in parameter name and value.

~~~json
{
    "policy": {
        "name": "parameters_allowed_metachars",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "checkMetachars": true,
                "sensitiveParameter": false,
                "parameterLocation": "any",
                "valueType": "auto-detect",
                "nameMetacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": true,
                        "metachar": "0x3e"
                    }
                ],
                "metacharsOnParameterValueCheck": true,
                "allowEmptyValue": true,
                "checkMaxValueLength": false,
                "valueMetacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": true,
                        "metachar": "0x3e"
                    }
                ],
                "name": "*",
                "level": "global",
                "allowRepeatedParameterName": true,
                "attackSignaturesCheck": true,
                "signatureOverrides": [],
                "type": "wildcard",
            }
        ]
    }
}
~~~


In this example, we define a sensitive parameter `mypass` configuration.

~~~json
{
    "policy": {
        "name": "parameters_sensitive",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_MULTIPART_NULL_VALUE",
                    "alarm": true,
                    "block": false
                },
                {
                    "name": "VIOL_PARAMETER_NAME_METACHAR",
                    "alarm": true,
                    "block": false
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_METACHAR",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "sensitive-parameters": [
            {
                "name": "mypass"
            }
        ]
    }
}
~~~

#### User-Defined URLs

The user-defined URL feature allows the user to configure the URL while supporting the following options:
- Define a protected URL configuration both explicitly and by wildcards.
- Define a per-URL list of allowed/disallowed methods that will override the list defined in the policy level.
- Define a content-type: json/xml/form-data on a user-defined URL.
- Define an Allowed/Disallowed user-defined URL.
- Add a user-defined URL to the Signature/Metacharacters override list.

In this example we configure allowed meta-characters in a user-defined URL:

~~~json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_URL_METACHAR",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/meta*",
                "protocol": "http",
                "type": "wildcard",
                "metacharsOnUrlCheck": true,
                "metacharOverrides": [
                    {
                        "isAllowed": true,
                        "metachar": "0x3c"
                    },
                    {
                        "isAllowed": false,
                        "metachar": "0x28"
                    }
                ],
                "wildcardOrder": 2
            }
        ]
    }
}
~~~

In this example, we disable the detection of a specific signature, `200010093` and enable another one, `200010008`, both in a user-defined URL `/Common/user_defined_URL`. These signature settings take effect only in requests to that URL. In other requests, the signature behavior is determined by the signature sets these signatures belong to. See [Signature Sets](#signature-sets) for more details.

~~~json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/test*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1,
                "attackSignaturesCheck": true,
                "signatureOverrides": [
                    {
                        "enabled": true,
                        "signatureId": 200010008
                    },
                    {
                        "enabled": false,
                        "signatureId": 200010093
                    }		    
                ]
            }
        ]
    }
}
~~~

In this example, we configure Wildcard/Explicit URLs, where the first URL is permitted for all methods, and the second is permitted only for GET:

~~~json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "urls": [
            {
                "method": "*",
                "name": "/test*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1
            },
            {
                "method": "GET",
                "name": "/index.html",
                "protocol": "http",
                "type": "explicit"
            }
        ]
    }
}
~~~

In this example, we configure json/xml/form-data content types for a specific user-defined URL:

~~~json
{
    "policy": {
        "name": "/Common/user_defined_URL",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_URL",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_METHOD",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_JSON_MALFORMED",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_JSON_FORMAT",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_XML_FORMAT",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "json-profiles": [
            {
                "name": "Default",
                "handleJsonValuesAsParameters": false,
                "defenseAttributes": {
                    "maximumTotalLengthOfJSONData": "any",
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumValueLength": "any"
                }
            }
        ],
        "xml-profiles": [
            {
                "name": "Default",
                "defenseAttributes": {
                    "maximumAttributesPerElement": "any",
                    "maximumDocumentDepth": "any",
                    "maximumAttributeValueLength": "any",
                    "maximumChildrenPerElement": "any",
                    "maximumDocumentSize": "any",
                    "maximumElements": "any",
                    "maximumNameLength": "any",
                    "maximumNSDeclarations": "any",
                    "maximumNamespaceLength": "any",
                    "tolerateLeadingWhiteSpace": true,
                    "tolerateCloseTagShorthand": true,
                    "allowCDATA": true,
                    "allowExternalReferences": true,
                    "allowProcessingInstructions": true
                }
            }
        ],
        "urls": [
            {
                "method": "*",
                "name": "/first*",
                "protocol": "http",
                "type": "wildcard",
                "wildcardOrder": 1,
                "urlContentProfiles": [
                    {
                        "headerValue": "*",
                        "headerName": "*",
                        "headerOrder": "3",
                        "type": "form-data"
                    },
                    {
                        "contentProfile": {
                            "name": "Default"
                        },
                        "headerValue": "*xml*",
                        "headerName": "Content-Type",
                        "headerOrder": "2",
                        "type": "xml"
                    },
                    {
                        "contentProfile": {
                            "name": "Default"
                        },
                        "headerValue": "*json*",
                        "headerName": "Content-Type",
                        "headerOrder": "1",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
~~~

#### User-Defined Parameters

So far, we have been managing the default parameter or * entity. What if we want to give specific attributes to specific parameters? This can be done by creating and configuring the user-defined parameters. This feature gives the user full control over what the parameter should include, where it should be located and allows for granularity in configuring each and every parameter. Here you can:

- Create unique parameters and specify attributes for each.
- Define what data type the parameter should contain.
- Define the allowed location where you expect to see a parameter.
- Define minimum/maximum values and minimum/maximum lengths for a parameter.
- Define whether a parameter is mandatory or not.
- Define whether the parameter can have empty values or not.
- Define whether to inspect a parameter for violations, attack signatures, or meta-characters.
- Decide whether to exclude certain violations, attack signatures, or meta-characters for a parameter.

In the following example, we configure two parameters. The first one, `text`, takes string values (here configured as alpha-numeric), and limits the length of the allowed string between 4 and 8 characters. Any string below or above these values will trigger the violation `VIOL_PARAMETER_VALUE_LENGTH`. Note that we enable this violation to *block* the violating request.

The second parameter, `query`, is added to the policy just to avoid a false positive condition due to a specific signature, `200002835`. Suppose you realized that whenever this signature detected on this parameter, it was false positive. You would like to disable this signature, but only in the context of this parameter. The signature will still be detected on values of other parameters.

~~~json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "text",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "checkMinValueLength": true,
                "checkMaxValueLength": true,
                "minimumLength": 4,
                "maximumLength": 8
            },
            {
                "name": "query",
                "type": "explicit",
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "signatureOverrides": [		
                    {
                        "enabled": false,
                        "signatureId": 200002835
                    }
                ]
            }	    
        ]
    }
}
~~~

In the next example, we configure a numeric parameter. This parameter accepts only integer values and allows values between 9 and 99 (non-inclusive). If the request includes anything other than an integer, it will trigger the `VIOL_PARAMETER_DATA_TYPE` violation. If the parameter value falls beyond or below the desired values, it will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation. Note that if you change the values of `exclusiveMin` and `exclusiveMax` to false, values equal to the boundary values will be accepted (namely 9 and 99).

~~~json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "number",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "integer",
                "checkMinValue": true,
                "checkMaxValue": true,
                "minimumValue": 9,
                "maximumValue": 99,
                "exclusiveMin": true,
                "exclusiveMax": true
            }
        ]
    }
}
~~~

For increased granularity, you can configure whether the parameter value is also a multiple of a specific number. This is useful when you wish to limit the input to specific values. The following example configures a parameter that accepts values in the range of 0 to 10 and are only multiples of 3. This means that the accepted values are 3, 6 and 9. Any other value will trigger the `VIOL_PARAMETER_NUMERIC_VALUE` violation.

~~~json
{
    "policy": {
        "name": "user_defined_parameters_data_types",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "multiples",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "integer",
                "checkMinValue": true,
                "checkMaxValue": true,
                "minimumValue": 0,
                "maximumValue": 10,
                "checkMultipleOfValue": true,
                "multipleOf": 3
            }
        ]
    }
}
~~~

Another very useful example is when the user wants to limit the parameter to a single context, like in a header or a query string. If the same variable appears in a different location, it will trigger the `VIOL_PARAMETER_LOCATION` violation.

~~~json
{
    "policy": {
        "name": "user_defined_parameters_misc_test",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_VALUE_LENGTH",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_STATIC_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_DATA_TYPE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_LOCATION",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "headerparam",
                "type": "explicit",
                "parameterLocation": "header",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "checkMinValueLength": false,
                "checkMaxValueLength": false
            }
        ]
    }
}
~~~

Another very useful example is the following configuration. It has:
- A sensitive parameter `mypass` that should be masked in the logs.
- A parameter `empty` that is allowed to be empty.
- A parameter `repeated` that can be repeated multiple times.
- A parameter `mandatory` that is mandatory for all requests.

Note that new violations were enabled so that the configuration becomes effective.

~~~json
{
    "policy": {
        "name": "user_defined_parameters_misc_test",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_EMPTY_VALUE",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER_REPEATED",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_MANDATORY_PARAMETER",
                    "alarm": true,
                    "block": true
                },
                {
                    "name": "VIOL_PARAMETER",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "mypass",
                "type": "explicit",
                "parameterLocation": "any",
                "sensitiveParameter": true,
                "valueType": "auto-detect"
            },
            {
                "name": "empty",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": true,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            },
            {
                "name": "repeated",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": false,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": true,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            },
            {
                "name": "mandatory",
                "type": "explicit",
                "parameterLocation": "any",
                "mandatory": true,
                "allowEmptyValue": false,
                "allowRepeatedParameterName": false,
                "sensitiveParameter": false,
                "valueType": "auto-detect"
            }
        ]
    }
}
~~~


#### User-Defined Signatures

Another useful expansion to the customization capabilities is the ability to create user-defined signatures. This capability allows the user to define new signatures, configure how they behave in terms of enforcement, and categorize them in user-defined signature sets (using tags) for ease of management.

The process of creating and implementing a user policy that contains user-defined signatures is a three-fold process:

- Creating the user-defined signature definitions in separate JSON files.
- Adding the relevant references (names, tags, signature sets) to the user-defined signatures in the policy file.
- Adding the definitions and referencing the relevant policy file in the nginx.conf file.

##### User-Defined Signature Definitions

The user-defined signature definition file is a JSON file where the signatures themselves are defined and given their properties and tags. The format of the user-defined signature definition is as follows:

~~~json
{
    "tag": "tag_name",
    "revisionDatetime": "2020-01-21T18:32:02Z",
    "signatures": []
}
~~~

Tags help organizing the user-defined signatures in bundles so that all signatures in that bundle are (usually) authored by the same person and share a common purpose or set of applications that will consume it. It also creates name spaces that avoid name conflicts among user-defined signatures. Signatures are uniquely identified by the combination of tag and name. The `tag_name` should be replaced with the tag name to be assigned to all signatures in this file or group. The `revisionDatetime` specifies the date or version of the signature file. Note that you can create as many user-defined signature definition files as you wish provided that you assign a unique tag for each file and that the user-defined signatures have unique names, both within the same file, or across different files.

To add user-defined signatures to the signatures list, each signature must have the following format:

~~~json
{
    "name": "unique_name",
    "description": "Add your description here",
    "rule": "content:\"string\"; nocase;",
    "signatureType": "request",
    "attackType": {
        "name": "Buffer Overflow"
    },
    "systems": [
        {
            "name": "Microsoft Windows"
        },
        {
            "name": "Unix/Linux"
        }
    ],
    "risk": "medium",
    "accuracy": "medium"
}
~~~

Here is a brief explanation about each of the above items in the signature definition:

- `name` - is the unique name to be given to the user-defined signature.
- `description` - is an optional item where you can add a human-readable text to describe the functionality or purpose of the signature.
- `rule` - is the rule by which the enforcement will be done. The rule uses Snort syntax: a keyword to look for in a certain context, such as URL, header, parameter, content, and optionally one or more regular expressions. For full details on how to create a rule and the possible permutations, check the [Rule Syntax](https://techdocs.f5.com/kb/en-us/products/big-ip_asm/manuals/product/asm-bot-and-attack-signatures-13-0-0/7.html#guid-797a0c69-a859-45cd-be11-fd0e1a975780) page.
- `signatureType` - defines whether the signature is relevant to the request or the response.
- `attackType` - this field gives an indication of the attack type the signature is intended to prevent. This field is mostly useful for signature set enforcement and logging purposes. A full list of the available attack types can be found in the [Attack Types](#attack-types) section.
- `systems` - is a list of systems (operating systems, programming languages, etc.) that the signature should be applicable for. Note that `systems` have the same meaning and use as `server technologies` although the overlap between both terms is not perfect. This is explained in the above section [Server Technologies](#server-technologies).
- `risk` - defines the risk level associated with this signature. Possible values are: low, medium, high.
- `accuracy` - defines the accuracy level of the signature. Note that the value of this field contributes to the value of the [Violation Rating](#violations). Possible values are: low, medium, high.

The following is an example of a user-defined signature definition file called `user_defined_signature_definitions.json`:

~~~json
{
    "softwareVersion": "15.1.0",
    "tag": "Fruits",
    "revisionDatetime": "2020-01-22T18:32:02Z",
    "signatures": [
        {
            "name": "Apple_medium_acc",
            "rule": "content:\"apple\"; nocase;",
            "signatureType": "request",
            "attackType": {
                "name": "Buffer Overflow"
            },
            "systems": [
                {
                    "name": "Microsoft Windows"
                },
                {
                    "name": "Unix/Linux"
                }
            ],
            "risk": "medium",
            "accuracy": "medium",
            "description": "Medium accuracy user defined signature with tag (Fruits)"
        }
    ]
}
~~~

##### Updating the Policy

Once all the user-defined signatures are added to definitions files, it is time to activate and use them in the policy. To achieve this, certain items need to be added to the policy file to enable these signatures, and to specify the action to take when they are matched. The following policy shows a simplified policy file example called `user_defined_signatures_policy.json`:

~~~json
{
    "policy": {
        "name": "user_defined_single_signature",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-requirements": [
            {
                "tag": "Fruits",
                "minRevisionDatetime": "2020-01-20T18:32:02Z",
                "maxRevisionDatetime": "2020-01-23T18:32:02Z"
            }
        ],
        "signatures": [
            {
                "name": "Apple_medium_acc",
                "tag": "Fruits"
            }
        ],
        "signature-sets": [
            {
                "name": "Fruit_signature_set",
                "block": true,
                "alarm": true,
                "signatureSet": {
                    "filter": {
                        "tagValue": "Fruits",
                        "tagFilter": "eq"
                    }
                }
            }
        ]
    }
}
~~~

Following is an explanation of each of the items added to the bare policy that are relevant to user-defined signatures:

- `signature-requirements` - Specifies which tags are being used in this policy, and from which revision/version (`minRevisionDatetime` and `maxRevisionDatetime` are optional). The signature requirements serve as an indication of what tags and revisions are required for the proper operation of the policy. If the requirement is met and the tag exists, this means that the signature import was successful, and that the policy compilation process will pass. However, if the tag/revision requirement is specified and no such tag or revision exists, then the policy compilation process will fail. This could mean that the user imported the wrong definitions file, imported a different revision than the one we require, or even forgot to import the definitions file altogether.
- `signatures` - The list of signatures we want to add to the policy. Note that each signature should have its unique name added as well as its relevant tag. The signature will then be automatically enabled. This section is redundant if the user wants to enable all signatures. However, if they want to disable specific signature(s), this section becomes mandatory where each signature should have the `enabled:` with `true` or `false` specified. A better way to disable signatures is by removing them from the definitions file altogether and reloading the policy.
- `signature-sets` - How the signatures are added to the policy enforcement. The set filters the signatures by tag and adds all the signatures matching this tag to the user-defined signature set. Here we can specify the action taken when a signature match is made (whether to alarm, block, or both)

##### Updating nginx.conf

In order for NGINX App Protect WAF to load the new user-defined signatures, the user needs to add the directive: `app_protect_user_defined_signatures`. This directive can only be used (multiple times, if needed) in the http context in the nginx.conf file and cannot be used under the server or location contexts. This directive accepts the path of the user-defined signature definition file as an argument. To add multiple definition files, the user will need to add a directive per file. Note that if the file or directory is not accessible by the nginx user, an error message will be displayed, and the policy will fail to compile.

An example configuration file is listed below:

~~~nginx
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
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:515;

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
~~~


#### User-Defined Signature Sets

NGINX App Protect WAF comes with pre-defined signatures and signature sets. Also, the user can create their own user-defined signatures (as we have seen above) as well as user-defined signature sets. User-defined Signature sets are suitable for organizing the sheer number of pre-defined and user-defined signatures into logical sets for better use in the policy. For pre-defined signatures, there are two ways of managing signature sets: manual addition of signatures using the signature unique IDs, or filtering signatures based on specific criteria, like request/response, risk level, accuracy level, attack type, systems, etc. For the user-defined signatures, signature IDs are automatically generated, and they cannot be used in manual addition of signatures. Therefore, only one way is possible: filtering based on tag, request/response, risk level, accuracy level, attack type, systems, etc.

The following example shows the creation of a new signature set based on filtering all signatures that have accuracy equals to "low":

~~~json
{
    "name": "filtered_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-low-accuracy-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "filter-based",
                "filter": {
                    "attackType": {
                        "name": "Other Application Attacks"
                    },
                    "signatureType": "request",
                    "riskFilter": "eq",
                    "riskValue": "high",
                    "accuracyFilter": "le",
                    "accuracyValue": "high"
                }
            }
        }
    ]
}
~~~

Note that the filter can have one of the following values:

- `eq` - Include values equal to.
- `le` - Include values less than or equal.
- `ge` - Include values greater than or equal.
- `all` - Do not filter, use all items. Note that `all` is the default value so if the user does not specify a filter, it will be considered as `all`. Also, if the user specifies the `all` filter, there is no need to specify the corresponding value element.

Therefore, the above example can be interpreted as: include all the signatures with risk equal to "high" and all signatures with accuracy equal to or less than medium. The result should include all low and medium accuracy signatures that have a high risk value.

In the following example, we demonstrate how to add signatures manually to a signature set by specifying the signature ID of each of the signatures:

~~~json
{
    "name": "manual_signature_sets",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "signature-sets": [
        {
            "name": "my-cherry-picked-signatures",
            "block": true,
            "alarm": true,
            "signatureSet": {
                "type": "manual",
                "signatures": [
                    {
                        "signatureId": 200003360
                    },
                    {
                        "signatureId": 200001234
                    }
                ]
            }
        }
    ]
}
~~~

It is worthy to note that if a newly added signature set name matches an existing signature set name, it will not overwrite the existing set. Instead, a new set will be created with "\_2" appended to the signature set name. For example, if we create a signature set with the name "My_custom_signatures" with 3 signatures, then add a new signature to the set and reload the `nginx` process, a new signature set will be created with the name "My_custom_signatures_2" containing the new list of 4 signatures. The older list "My_custom_signatures" with 3 signatures will remain intact.


#### User-Defined Browser Control

The User-Defined Browser Control feature allows a user to define new custom browsers, and create a list of allowed or disallowed browsers (both user-defined and factory preset browsers) used by the client application. It mainly provides the opportunity:
1. To detect browsers that are not among the factory supported ones so that they can be verified they are indeed browsers using the anti-automation feature.
2. To be able to block access to specific browsers types and versions that the application does not support. This is not a security feature but rather a means to provide a smooth user experience.

##### User-Defined Browser Control Configuration

User-defined browsers can be configured in the `browser-definitions` section in the policy. There are a number of properties that can be configured per user-defined browser element:

- `name` - must be unique and not conflict with factory names.
- `matchString` - string that should be present in the `User-Agent` header to trigger enforcement.
- `matchRegex` - regex that should be matched in the `User-Agent` header to trigger enforcement.
- `description` - description of the custom browser agent element.

Please note that:
- `matchString` and `matchRegex` are mutually exclusive (either can appear but never both at the same time).

Defining a list of allowed or disallowed browsers can be done in `classes` and `browsers` sections under `bot-defense/mitigations` section.
1. classes
   * `name` - name of class (in this case only `browser` and `unknown` are relevant).
   * `action` - detect / alarm / block.
2. browsers
   * `name` - name of the browser (factory or user-defined).
   * `action`  - detect / alarm / block.
   * `minVersion` (int) - minimum version of the browser for which the action is applicable (major browser version only).
   * `maxVersion` (int) - maximum version of the browser for which the action is applicable (major browser version only).

Please note that:
- `browser` class defines the default action for any browser that is not in the supported factory browsers list (the default action is `detect`).
- `unknown` class defines the default action for unclassified clients that did not match any browser or bot type (the default action is `alarm`).
- `minVersion` and `maxVersion` properties are available only for factory browsers and refer to major browser version. These fields are optional - when not present (either one) then it means "any" version.

##### List of Supported Factory Browsers

The following table specifies supported built-in (factory) browsers:

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Declarative Name | Description | 
| ---| --- | 
|android | The native Android browser. | 
|blackberry | The native Blackberry browser. | 
|chrome | Chrome browser on Microsoft Windows. | 
|chrome | Chrome browser on Android. | 
|firefox | Firefox on Microsoft Windows. | 
|firefox | Firefox on Android. | 
|internet-explorer | Internet Explorer on Microsoft Windows. | 
|internet-explorer | Internet Explorer on mobile devices. | 
|opera | Opera Browser on Microsoft Windows. | 
|opera | Opera Mini Browser. | 
|opera | Opera on Mobile devices. | 
|safari | Safari Browser on Microsoft Windows or Apple macOS. | 
|safari | Safari Browser on Apple iOS and iPadOS devices. | 
|edge | Microsoft Edge Browser. | 
|uc | UC Browser. | 
|puffin | Puffin Browser on Microsoft Windows. | 
|puffin | Puffin Browser on Android devices. | 
|puffin | Puffin Browser on iOS devices. | 
{{</bootstrap-table>}} 


##### User-Defined Browser Control Enforcement

If the received request has no bot signatures, then the following actions are enforced:
1. Parse the `User-Agent` header. If a known browser is identified, then enforce based on the action set in the `browser` subsection of the `classes` section.
2. If no factory or user-defined browser is identified, then enforce based on the action set in the `unknown` subsection of the `classes` section.
3. If both factory and user-defined browser were detected, then the user-defined one takes precedence and its action is executed according to point 1.
4. If more than one user-defined browser was detected, then the most severe action of the detected browsers is taken.

Please note that:
- User-Defined Browser Control configuration is part of the `bot-defense` configuration in the policy, therefore enforcement can take place only if `isEnabled` flag under `bot-defense` section is set to `true` (it is set to true in the default policy).

##### User-Defined Browser Control Configuration Examples

In the following example, the policy is configured with these items:
- Define some user-defined browsers.
- Detect (allow) all browsers except for browsers with action set to `block` in `browsers` section (according to `minVersion`/`maxVersion` fields values).
- Alarm if no browser was detected.

~~~json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_1",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "browser-definitions": [
            {
                "name": "FunkyBrowserV3",
                "matchString": "FunkyBrowser/1.3.1",
            },
            {
                "name": "SmartBrowser4",
                "matchRegex": "smartbrowser/([\\d.]+)",
            }
        ],
        "bot-defense": {
            "settings" : {
                "isEnabled": true
            },
            "mitigations": {
                "classes": [
                    {
                        "name": "browser",
                        "action": "detect"
                    },
                    {
                        "name": "unknown",
                        "action": "alarm"
                    }
                ],
                "browsers": [
                    {
                        "name": "safari",
                        "action": "block"
                    },
                    {
                        "name": "chrome",
                        "minVersion": 77,
                        "action": "block"
                    },
                    {
                        "name": "firefox",
                        "minVersion": 45,
                        "maxVersion": 60,
                        "action": "block"
                    },
                    {
                        "name": "FunkyBrowserV3",
                        "action": "block"
                    }
                ]
            }
        }
    }
}
~~~

In the next example, the policy is configured with the following items:
- Define some user-defined browsers.
- Block all browsers except for browsers with action set to `detect` or `alarm` in `browsers` section (according to `minVersion`/`maxVersion` fields values).
- Block request if no browser was detected.

~~~json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_2",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "browser-definitions": [
            {
                "name": "FunkyBrowserV3",
                "matchString": "FunkyBrowser/1.3.1",
            },
            {
                "name": "SmartBrowser4",
                "matchRegex": "smartbrowser/([\\d.]+)",
            }
        ],
        "bot-defense": {
            "settings" : {
                "isEnabled": true
            },   
            "mitigations": {
                "classes": [
                    {
                        "name": "browser",
                        "action": "block"
                    },
                    {
                        "name": "unknown",
                        "action": "block"
                    }
                ],
                "browsers": [
                    {
                        "name": "safari",
                        "action": "detect"
                    },
                    {
                        "name": "chrome",
                        "minVersion": 77,
                        "action": "alarm"
                    },
                    {
                        "name": "firefox",
                        "minVersion": 45,
                        "maxVersion": 60,
                        "action": "detect"
                    },
                    {
                        "name": "FunkyBrowserV3",
                        "action": "detect"
                    }
                ]
            }
        }
    }
}
~~~


#### Deny, Allow and Never Log Lists

It is possible to define IP addresses or ranges for which the traffic will always be allowed or denied or never logged despite the rest of the configuration settings in the policy.

1. **Always Allowed** (`"blockRequests": "never"`) - requests from this IP range will be passed even if they have blocking violations.
2. **Always Denied** (`"blockRequests": "always"`) - requests from this IP range will be always blocked even if they have no other blocking violations. The `VIOL_BLACKLISTED_IP` violation will be triggered in this case and its block flag must be set to `true` in order for the request to be actually blocked.
3. **Never Log** (`"neverLogRequests": true`) - requests from this IP range will not be logged even if they were supposed to be in the logging configuration. Note this is independent of the other setting, so the same IP range can be both denied (or allowed) and yet never logged.

In this IPv4 example, we use the default configuration while enabling the deny list violation. In the configuration section, we define:

- An always allowed IP 1.1.1.1
- An always denied IP 2.2.2.2
- An always allowed range of IPs 3.3.3.0/24
- An allowed range of IPs 4.4.4.0/24 which should never log

~~~json
{
    "policy": {
        "name": "allow_deny",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_BLACKLISTED_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "whitelist-ips": [
            {
                "blockRequests": "never",
                "neverLogRequests": false,
                "ipAddress": "1.1.1.1",
                "ipMask": "255.255.255.255"
            },
            {
                "blockRequests": "always",
                "ipAddress": "2.2.2.2",
                "ipMask": "255.255.255.255"
            },
            {
                "blockRequests": "never",
                "neverLogRequests": false,
                "ipAddress": "3.3.3.0",
                "ipMask": "255.255.255.0"
            },
            {
                "blockRequests": "never",
                "neverLogRequests": true,
                "ipAddress": "4.4.4.0",
                "ipMask": "255.255.255.0"
            }
        ]
    }
}
~~~

{{< note >}}
The above configuration assumes the IP address represents the original requestor. However, it is also common that the client address may instead represent a downstream proxy device as opposed to the original requestor's IP address. In this case, you may need to configure NGINX App Protect WAF to prefer the use of an `X-Forwarded-For` (or similar) header injected to the request by a downstream proxy in order to more accurately identify the *actual* originator of the request. [See the XFF Headers and Trust](#xff-headers-and-trust) for information regarding the additional settings required for this configuration.
{{< /note >}}


Here's an example of IPv6 notation with a single address and an IP subnet with a 120-bit prefix:

The first address is a single IP address, because the mask is all f's. Since this is a default value, there is no need to specify the mask in this case. The second address is a subnet of 120 bits (out of the 128 of an IPv6 address). The trailing 8 bits (128-120) must be **zero** in both the mask and the address itself. 

~~~json
{
    "policy": {
        "name": "allow_deny",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_BLACKLISTED_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "whitelist-ips": [
            {
                "ipAddress": "2023::4ef3",
                "ipMask": "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
                "blockRequests": "never"
            },
            {
                "ipAddress": "2034::2300",
                "ipMask": "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff00",
                "blockRequests": "never"
            },
        ]
    }
}
~~~


#### CSRF Protection Using Origin Validation

CSRF (Cross-Site Request Forgery) is an attack vector in which the victim user that visits a sensitive site such as a bank account, is lured to click on a malicious link attempting a fraudulent operation on that sensitive site. The link may be sent over email or in a hidden frame in another site. NGINX App Protect WAF provides protection against CSRF attacks by validating the Origin header for AJAX POST requests (default configuration).

##### CSRF Configuration

There are several settings that can be configured to enable CSRF protection, some are global while others are specific. Following is a list of all the settings that can be configured to enable or customize the CSRF settings:
1. In the `csrf-protection` section, enable CSRF protection. This is a global configuration option and applies to all policy elements.
2. Enable the CSRF violation `VIOL_CSRF` in the violations section (the violation is already enabled in `Alarm` mode in the base template). This is a global configuration option and applies to all policy elements.
3. In the `csrf-urls` section, the user can define method and URL configurations. By default, the wildcard URL `*` with the `POST` method is configured to enforce Origin validation. The default configuration can be deleted to allow for customized configuration for specific methods and URLs.
4. In the `urls` section, you can enable CSRF protection for specific URLs, and define a list of acceptable origins. If the wildcard URL `*` is selected, the configuration becomes global for all URLs. Otherwise, the configuration is applicable only to the specified URL.
5. In the `host-names` section, you can add a list of the domains that are to be accepted when comparing the origin to the hostnames. The user can enable or disable the inclusion of subdomains. This is a global configuration option and applies to all policy elements.

Please note that:
- Both `VIOL_CSRF` and `csrf-protection` settings need to be enabled for CSRF protection to be active. Disabling either setting will disable CSRF protection altogether.
- Configuring `urls` is required only if there are external origins that have to be allowed.
- `host-names` are internal, owned by the application and used by clients to reach it. The `crossDomainAllowedOrigin` in the `urls` are external domains, from other applications, that we wish to allow as origins.
 
##### CSRF Enforcement

If CSRF is enabled in the violation section and in the `csrf-protection` settings, when receiving a request to a URL that matches one of the `csrf-urls` and all its conditions: method and parameters (if applicable there), then the following conditions must be met:

1. Origin header must exist in the request.
2. The domain name from the Origin header must match any of the following criteria:
   * The Host header in the same request.
   * One of the hostnames in the policy.
   * One of the allowed origins in the matching URL entity in the policy.

If the first condition is not met, the validation will fail with the message "Origin header validation failed: Origin is absent". If the second condition fails to match any of the items, the validation will fail with the message "Origin header validation failed: Origin is not allowed".

##### CSRF Configuration Examples

In the following example, CSRF Protection is enabled globally (in `Block` mode) with no customization:

~~~json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "csrf_default",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_CSRF",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "csrf-protection": {
            "enabled": true
        }
    }
}
~~~

In the following example, the policy is configured with the following items:
- Enable CSRF Protection globally (in `Block` mode).
- Delete the default wildcard CSRF URL and define a new custom one.
- Define a policy-wide hostname domain without its subdomains.

~~~json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_2",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_CSRF",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "csrf-protection": {
            "enabled": "true"
        },
        "csrf-urls": [
            {
                "$action": "delete",
                "method": "POST",
                "url": "*"
            },
            {
                "enforcementAction": "verify-origin",
                "method": "POST",
                "url": "/operation.aspx"
            }
        ],
        "host-names": [
            {
                "name": "example.com",
                "includeSubdomains": false
            }
        ]
    }
}
~~~

In the following example, the policy is configured with the following items:
- Enable CSRF Protection globally (violation already in `Alarm` mode in the default policy).
- Delete the default wildcard CSRF URL and define a new custom one.
- Define a policy-wide hostname domain with subdomains.
- Add a custom URL "myurl" where CSRF enforcement is enabled, and define a custom origin for this URL.

~~~json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "example_3",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "csrf-protection": {
            "enabled": "true"
        },
        "csrf-urls": [
            {
                "$action": "delete",
                "method": "POST",
                "url": "*"
            },
            {
                "enforcementAction": "verify-origin",
                "method": "POST",
                "url": "/csrfurl"
            }
        ],
        "host-names": [
            {
                "name": "example.com",
                "includeSubdomains": true
            }
        ],
        "urls": [
            {
                "name": "/myurl",
                "html5CrossOriginRequestsEnforcement": {
                    "enforcementMode": "enforce",
                    "crossDomainAllowedOrigin": [
                        {
                            "includeSubDomains": false,
                            "originName": "foo.com",
                            "originPort": "all",
                            "originProtocol": "http/https"
                        }
                    ]
                }
            }
        ]
    }
}
~~~


#### Clickjacking Protection

Clickjacking refers to a technique used by malicious actors to embed remote website content into their malicious websites, tricking the end users to click on the embedded frames triggering actions the users were not aware of, such as liking a certain Facebook page or giving a restaurant a 5 star rating. To protect against such attacks, NGINX App Protect WAF uses the `X-Frame-Options` header capabilities. The `X-Frame-Options` header is injected by NGINX App Protect WAF to indicate to the browser whether it should embed  the content or not. Please note that this additional layer of security is available only in browsers that support the `X-Frame-Options` headers.

##### Configuration

`X-Frame-Options` can be configured as follows:
- X-Frame-Options: `deny` - This option will prevent the browser from displaying the content in a frame, regardless of the website trying to do so.
- X-Frame-Options: `only-same` - This option allows the browser to display the content in a frame only if it comes from the same website.

Please note that a third configuration option was available but it was deprecated by RFC and is not supported by NGINX App Protect WAF.

To enable this protection in NGINX App Protect WAF, we enable the feature for a URL (or for all URLs, via the wildcard URL), and then set the value to be assigned to the `X-Frame-Options` header. Following is an example of a policy enabling the feature for the URL `/clickme`, and using `only-same` as the value for the `X-Frame-Options` header:

~~~json
{
    "name": "x_frame_options",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
        {
            "name": "/clickme",
            "type": "explicit",
            "method": "*",
            "isAllowed": true,
            "clickjackingProtection": true,
            "allowRenderingInFrames": "only-same"
        }
    ]
}
~~~

In the following example, a policy is created with Clickjacking enabled for the URL `/clickme`, and using `DENY` as the value for the `X-Frame-Options` header:

~~~json
{
    "name": "x_frame_options",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
        {
            "name": "/clickme",
            "type": "explicit",
            "method": "*",
            "isAllowed": true,
            "clickjackingProtection": true,
            "allowRenderingInFrames": "never"
        }
    ]
}
~~~


### Detect Base64

The Detect Base64 feature allows NGINX App Protect WAF to detect whether values in headers, cookies, and parameters are Base64 encoded. When an entity is detected as Base64 encoded NGINX App Protect WAF will enforce the configured signatures on the decoded value, instead of on the original value.

This feature is disabled by default or by setting the `decodeValueAsBase64` to `disabled`.

There is a small risk that the system will wrongly detect a field value as Base64 decodable, when it's actually not. In that case signatures will not be detected properly. To mitigate this, set `decodeValueAsBase64` to `disabled` on known non Base64 entities.

~~~json
{
    "policy": {
        "name": "detect_base64",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "cookies": [
            {
                "name": "username",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ],
        "parameters": [
            {
                "name": "catchPhrase",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ],
        "headers": [
            {
                "name": "Catch-Phrase",
                "type": "explicit",
                "decodeValueAsBase64": "disabled"
            }
        ]
    }
}
~~~

If `decodeValueAsBase64` is set to `required`, then a violation is raised if the value is not Base64 decodable.

In this example we already know which specific entity values are Base64 decodable, so we set the value of `decodeValueAsBase64` to `required` to raise a violation if the value is not Base64 decodable:
~~~json
{
    "policy": {
        "name": "detect_base64",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_BASE64",
                    "alarm": true,
                    "block": true
                }
            ]
        },

        "cookies": [
            {
                "name": "mySession",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ],
        "parameters": [
            {
                "name": "myId",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ],
        "headers": [
            {
                "name": "My-Header",
                "type": "explicit",
                "decodeValueAsBase64": "required"
            }
        ]
    }
}
~~~

### Handling XML and JSON Content

#### XML and JSON Content Profiles

By default every request with a Content-Type header containing XML or JSON is expected to have an XML or JSON body, respectively. Consequently, a series of checks are performed to ensure that the body is indeed well-formed as XML or JSON, and certain restrictions are enforced on the size and content of that body. These restrictions are specified in **XML and JSON profiles**. These configuration structures are associated with URLs and optionally also with Parameters, in case parameters that are known to have XML or JSON values are defined. One of the most powerful restrictions in a JSON profile is enforcing a schema with which the content must comply. This will be detailed in the next section.

The default Base template comes with default JSON and XML profiles, both called "default". They are associated to the * URL based on the values of the Content-Type header as described above. You can use those profiles on other URLs or Parameters in your policies, and you can also create your own custom JSON and XML profiles to customize the checks that you want on your content.

Let's assume you have a JSON registration form under the URL `/register`. It is a small form, and it makes sense to limit its size to 1000 characters and its nesting depth to 2.  Here is a policy that enforces this:

~~~json
{
    "policy": {
        "name": "json_form_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": 2,
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                }
            }
        ],
        "urls": [
            {
                "name": "/register",
                "method": "POST",
                "type": "explicit",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "headerName": "*",
                        "headerValue": "*",
                        "headerOrder": "default",
                        "type": "json",
                        "contentProfile": {
                            "name": "reg_form_prof"
                        }
                    }
                ]
            }
        ]
    }
}
~~~

The enforcement on the JSON payload is defined in the `reg_form_prof` JSON profile. This profile is attached to the `/register` URL. Note JSON content is always expected for this URL - it applies to all header name and value combinations, and no other content option exists for this URL. Also note that we limited the method to `POST` in this URL. A POST request to this URL with a body that is not well-formed JSON will trigger the `VIOL_JSON_MALFORMED` violation.

If the body of the request is legal JSON, but violates any of the restrictions in the `reg_form_prof` JSON profile, for example has a nesting depth of 3, then you should expect the `VIOL_JSON_FORMAT` violation with details on what exactly was wrong with the JSON payload.

Let's assume that in your JSON registration there is a specific field that should be Base64 encoded.
we can set the value of `handleJsonValuesAsParameters` to `true` on the profile level,
and set the value of `decodeValueAsBase64` to `required` on the parameter level.
Here is a policy that enforces this:

~~~json
{
    "policy": {
        "name": "json_parse_param_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_PARAMETER_VALUE_BASE64",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "parameters": [
            {
                "name": "*",
                "type": "wildcard",
                "parameterLocation": "any",
                "valueType": "user-input",
                "dataType": "alpha-numeric",
                "decodeValueAsBase64": "required"
            }
        ],
        "json-profiles": [
            {
                "name": "Default",
                "defenseAttributes": {
                    "tolerateJSONParsingWarnings": true
                },
                "handleJsonValuesAsParameters": true,
                "validationFiles": []
            }
        ]
    }
}
~~~

{{< note >}}
Defining a JSON or XML profile in a policy has no effect until you assign it to a URL or Parameter you defined in that policy. Profiles can be shared by more than one URL and/or Parameter.
{{< /note >}}

#### Applying a JSON Schema

If a schema for the JSON payload exists, it can be attached to the JSON profile and App Protect will enforce it along with the other restrictions.

Here is a sample JSON schema for a registration form. It contains personal details:

~~~json
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "Person",
    "type": "object",
    "additionalProperties": false,
    "properties": {
        "firstName": {
            "type": "string",
            "description": "The person's first name."
        },
        "lastName": {
            "type": "string",
            "description": "The person's last name."
        },
        "age": {
            "description": "Age in years which must be equal to or greater than zero.",
            "type": "integer",
            "minimum": 0
        }
    }
}
~~~

Embedding the schema into the `reg_form_prof` JSON profile should be done in the following way:
- Add an object containing the JSON schema to the `json-validation-files` array, which details all the available JSON schema validation files available in the profile. A unique `fileName` should be specified, and the escaped contents of the JSON schema added via the `contents` keyword.
- Associate the specific JSON schema to the `reg_form_prof` JSON profile by adding a `validationFiles` array object and set the `fileName` in the `jsonValidationFile` object to the JSON schema `fileName`.
- All JSON schema files including external references must be added in this way to both the `json-validation-files` array and associated with the JSON profile. The `isPrimary` should be set on the object containing the primary JSON schema.

This yields the following policy:

~~~json
{
    "policy": {
        "name": "json_form_policy_inline_schema",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-validation-files": [
            {
                "fileName": "person_schema.json",
                "contents": "{\r\n \"$schema\": \"http://json-schema.org/draft-07/schema#\",\r\n \"title\": \"Person\",\r\n \"type\": \"object\",\r\n \"properties\": {\r\n \"firstName\": {\r\n \"type\": \"string\",\r\n \"description\": \"The person's first name.\"\r\n },\r\n \"lastName\": {\r\n \"type\": \"string\",\r\n \"description\": \"The person's last name.\"\r\n },\r\n \"age\": {\r\n \"description\": \"Age in years which must be equal to or greater than zero.\",\r\n \"type\": \"integer\",\r\n \"minimum\": 0\r\n }\r\n }\r\n}"
            }
        ],
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                },
                "validationFiles": [
                    {
                        "isPrimary": true,
                        "jsonValidationFile": {
                            "fileName": "person_schema.json"
                        }
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/register",
                "type": "explicit",
                "method": "POST",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "reg_form_prof"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
~~~

When a request to the `/register` URL is `POST`-ed with JSON content that does not comply with the above schema, the `VIOL_JSON_SCHEMA` violation is triggered. In the default base template, the `alarm` flag is turned on for this violation and if it is triggered, it affects Violation Rating. In addition, you can turn on the `block` flag so that this violation will also block when triggered.

**Notes:**
- The schema file is embedded as a quoted string; therefore you must escape the quotes inside the schema itself.
- We removed the nesting depth check in the JSON profile because it is enforced by the schema. It is not an error to leave the sizing checks together with the schema enforcement, but usually the schema has more accurate restrictions and leaving the profile restriction might be redundant in the best case or cause false positives in the worst.

#### Including an External JSON Schema File

Schema files are often developed as part of the application, independently from the App Protect Policy. It is often desirable to keep it in a separate file and reference it from the policy using a URL. Just as in all externally referenced policy sections, the JSON schema file can reside either in the NGINX file system (the default directory `/etc/app_protect/conf` is assumed if only the filename is specified in the `file:` URL, that is: `file:///my_schema.json` refers to the file located at `/etc/app_protect/conf/my_schema.json`), or on a remote Web server, typically, your source control system.

In this example the file is in the default directory:

~~~json
{
    "policy": {
        "name": "json_form_policy_external_schema",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "json-validation-files": [
            {
                "fileName": "person_schema.json",
                "link": "file://person_schema.json"
            }
        ],
        "json-profiles": [
            {
                "name": "reg_form_prof",
                "defenseAttributes": {
                    "maximumArrayLength": "any",
                    "maximumStructureDepth": "any",
                    "maximumTotalLengthOfJSONData": 1000,
                    "maximumValueLength": "any",
                    "tolerateJSONParsingWarnings": false
                },
                "validationFiles": [
                    {
                        "isPrimary": true,
                        "jsonValidationFile": {
                            "fileName": "person_schema.json"
                        }
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/register",
                "type": "explicit",
                "method": "POST",
                "attackSignaturesCheck": true,
                "clickjackingProtection": false,
                "disallowFileUploadOfExecutables": false,
                "isAllowed": true,
                "mandatoryBody": false,
                "methodsOverrideOnUrlCheck": false,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "reg_form_prof"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "json"
                    }
                ]
            }
        ]
    }
}
~~~

The schema file is identified by the `filename` property. It is a good practice to keep the `filename` identical to the one on the URL path, but it is not an error to have different names for each.

if you want to reference the file externally, replace the content of the `link` property with an HTTP or HTTPS URL:

~~~json
{
    "json-validation-files": [
        {
            "fileName": "person_schema.json",
            "link": "https://git.mydomain.com/my_app/person_schema.json"
        }
    ]
}
~~~

### Enforcer Cookie Settings

NGINX App Protect WAF generates its own cookies and adds them on top of the application cookies. 

These are called Enforcer Cookies. 

You can control the attributes within these cookies:

* `httpOnlyAttribute`: Whether or not to add HttpOnly attribute, value is either `true` or `false`, default is **true**.
* `secureAttribute`: Whether or not to add Secure attribute, value is either `always` or `never`, default is **always**.
* `sameSiteAttribute`: In which mode to add SameSite attribute, value is one of: `none-value`, `lax`, `strict` or `none`, default is **strict**. Use `none` in order to not add this attribute to the cookie at all.

In this example, we configure HttpOnly to be `true`, Secure to be `never`, and SameSite to be `strict`.

~~~json
{
    "policy": {
        "name": "cookie_attrs_configured",
        "template": { "name":"POLICY_TEMPLATE_NGINX_BASE" },
        "enforcer-settings": {
            "enforcerStateCookies": {
                "httpOnlyAttribute": true,
                "secureAttribute": "never",
                "sameSiteAttribute": "strict"
            }
        }
    }
}
~~~
**Note**: The default values were changed in release 3.2 to the ones mentioned above. In the previous release the default values were different per policy for the following attributes:

* `httpOnlyAttribute`: Default value was `true` for all policies.
* `secureAttribute`: Default value was `never` in the default policy, and `always` in the strict and API policies.
* `sameSiteAttribute`: Default value was `lax` in the default and API policies, and `strict` in the strict policy.

### Additional Configuration Options


#### XFF Headers and Trust

XFF trust is disabled by default but can be enabled.

In this example, we use the default configuration but enable the trust of XFF header.

~~~json
{
    "policy": {
        "name": "xff_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [],
            "trustXff": true
        }
    }
}
~~~


In this example, we configure a policy with a custom-defined XFF header.

~~~json
{
    "policy": {
        "name": "xff_custom_headers",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [
                "xff"
            ],
            "trustXff": true
        }
    }
}
~~~

#### Blocking Page Customization

You can customize the blocking page text and formatting to suit your particular design requirements.

In this example, we use the default configuration but modify the response page that is displayed to the customer.

~~~json
 {
    "policy": {
        "name": "blocking_page",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "response-pages": [
            {
                "responseContent": "<html><head><title>Custom Reject Page</title></head><body>This is a custom response page; it is supposed to overwrite the default page with custom text.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
                "responseHeader": "HTTP/1.1 200 OK\r\nCache-Control: no-cache\r\nPragma: no-cache\r\nConnection: close",
                "responseActionType": "custom",
                "responsePageType": "default"
            }
        ]
    }
}
~~~


#### AJAX Response Page for Single Page Applications (SPAs)

There is a special scenario where default or regular custom response pages cannot be used. SPAs (Single Page Applications) are applications that provide application functionality within the boundaries of a single HTML page. Once a SPA application has been loaded in the browser, it typically makes REST API calls to remote resources expecting JSON response bodies rather than HTML markup. If this SPA application were to receive a default HTML-formatted block page, it would not be able to interpret this, likely causing an application error.

A way to handle such a situation is via configuring an AJAX response page. The AJAX response page will cause a pop-up to appear on the client browser, informing them that the request has been blocked.

In this example, we set up an AJAX response page.

~~~json
{
    "policy": {
        "name": "NGINX-SPA",
        "description": "Policy with AJAX response page enabled for blocking AJAX requests",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "enforcementMode": "blocking",
        "response-pages": [
            {
                "responsePageType": "ajax",
                "ajaxEnabled": true,
                "ajaxPopupMessage": "My customized popup message! Your support ID is: <%TS.request.ID()%>"
            }
        ]
    }
}
~~~

### Modifying Configurations

What we have been seeing so far has been related to making changes by actually overriding specific configuration values. What would happen in the case we wanted to remove a specific configuration entity from the policy. For example, let's say we have added file types "aaa", "bbb", and "ccc", and now we wish to remove "bbb" from the list of disallowed file types. Deleting this entity from the declarative configuration file will simply mean that this entity will be left intact when the policy is rebuilt, meaning that the entity is still in the disallowed file types list. To resolve such situations, we have a `modifications` section where we can force modification where otherwise it is not possible using direct declarative configuration.

There is a specific section named `modifications` where we can configure items to be removed/deleted or forcefully modified in the policy.

In this example, we specify that we wish to remove the file type **log** from the disallowed file types list.

~~~json
{
    "policy": {
        "name": "modifying_disallowed_file_types",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    },
    "modifications": [
        {
            "entityChanges": {
                "type": "explicit"
            },
            "entity": {
                "name": "log"
            },
            "action": "delete",
            "entityType": "filetype"
        }
    ]
}
~~~

#### entityType List

The below list provides information about the `entityType` which can be used in the `modifications` section of the App Protect policy:

- blocking-settings/evasion
- blocking-settings-general
- blocking-settings/http-protocol
- blocking-settings/violation
- bot-defense/mitigations/anomaly
- bot-defense/mitigations/browser
- bot-defense/mitigations/class
- bot-defense/mitigations/signature
- bot-defense/settings
- browser-definition
- character-set
- cookie
- cookie-settings
- csrf-protection
- csrf-url
- data-guard
- enforcer-settings
- filetype
- general
- graphql-profile
- grpc-profile
- header
- header-settings
- host-name
- json-profile
- method
- parameter
- response-page
- signature
- sensitive-parameter
- signature-setting
- url
- whitelist-ip
- xml-profile


## NGINX App Protect WAF Standalone Configuration

### Apreload

Apreload is a new configuration tool where the NGINX App Protect WAF can be configured without having to reload NGINX if only the App Protect configuration is changed and the `nginx.conf` file remains unchanged. Apreload does not affect the existing NGINX reload process and it functions in the same manner as before.

#### Some Conditions Required for Apreload to Work:

- For apreload to work, NGINX must be started first.
- Apreload may be used if the app protect configuration (policies, log configuration files, global settings etc) have been modified, but the NGINX configuration hasn't changed.<br>

    Whenever `nginx.conf` file or any of its included files are modified, nginx reload must be used, rather than apreload. This will also update any changes in the App Protect configuration (policies, logging profiles, global settings). This applies also if only the App Protect directives have been modified in the `nginx.conf` file.
- Apreload should be executed with the same user that executes NGINX to avoid any access error. 
- Apreload calls for changes in the content of the policy, with the exception of the name of the policy.<br>

### Apreload Events

Apreload events use the same format as the current operation log events written in the NGINX error log, namely: `configuration_load_success` or `configuration_load_failure` with the details in JSON format. Refer to the [Operation logs]({{< relref "/nap-waf/logging-overview/operation-logs.md" >}}) for more details.

{{< note >}}
Note that if any of the configuration files are invalid, apreload will discover that and return the proper error message in the `configuration_load_failure` event. The Enforcer continues to run with the previous configuration.{{< /note >}}

### Modification to nginx.conf file and App Protect Configurations
When both `nginx.conf` file and App Protect configurations are modified, apreload enforces only the App Protect configurations but nginx reload enforces both.

For apreload, use the following command:
```shell
/opt/app_protect/bin/apreload
```

Output:

```shell
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

Apreload will not take into effect these Policy modifications:

- New user defined HTTP headers, refer to [User-defined HTTP Headers](#user-defined-http-headers) section. Note that modifications to existing user-defined headers will take effect in apreload.
- XFF trust modifications, refer to [XFF Headers and Trust](#xff-headers-and-trust) section for more details. <br>

If you want to apply any of the above modifications, reload NGINX rather invoking apreload, even if NGINX configuration has not been modified.

## External References

External references in policy are defined as any code blocks that can be used as part of the policy without being explicitly pasted within the policy file. This means that you can have a set of pre-defined configurations for parts of the policy, and you can incorporate them as part of the policy by simply referencing them. This would save a lot of overhead having to concentrate everything into a single policy file.

A perfect use case for external references is when you wish to build a dynamic policy that depends on moving parts. You can have code create and populate specific files with the configuration relevant to your policy, and then compile the policy to include the latest version of these files, ensuring that your policy is always up to date when it comes to a constantly changing environment.


**Note**: Any update of a single file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration. 

To use the external references capability, in the policy file the direct property is replaced by "xxxReference" property, where xxx defines the replacement text for the property changed to singular (if originally plural) and notation converted from snake case to camelCase. For example, `modifications` section is replaced by `modificationsReference` and `data-guard` is replaced by `dataGuardReference`.

### Types of References

There are different implementations based on the type of references that are being made.

#### URL Reference

URL reference is the method of referencing an external source by providing its full URL. This is a very useful method when trying to combine or consolidate parts of the policy that are present on different server machines.

{{< note >}} You need to make sure that the server where the resource files are located is always available when you are compiling your policy. 
{{< /note >}}

##### Example Configuration

In this example, we are creating a skeleton policy, then enabling the file type violation. However, we do not wish to specify the file types as these file types depend on an app that defines these types. We therefore wish to have this section populated from an external reference. Note that the `filetypes` section is replaced by the `filetypeReference` section. For a list of all the available reference options, consult the documentation (declarative section). In the `filetypeReference` section, we define a **key/value** pair, where the key defines what type of reference we are making, while the value defines the actual URL to use to reach that reference item.

For the content of the file itself, it is an extension of the original JSON format for the policy, as if this section was cut from the policy and pasted into the file.

**Policy configuration:**

~~~json
{
    "name": "external_resources_file_types",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "blocking-settings": {
        "violations": [
            {
                "name": "VIOL_FILETYPE",
                "alarm": true,
                "block": true
            }
        ]
    },
    "filetypeReference": {
        "link": "http://domain.com:8081/file-types.txt"
    }
}
~~~

Content of the referenced file `file-types.txt`:

~~~json
[
    {
        "name": "*",
        "type": "wildcard",
        "allowed": true,
        "checkPostDataLength": false,
        "postDataLength": 4096,
        "checkRequestLength": false,
        "requestLength": 8192,
        "checkUrlLength": true,
        "urlLength": 2048,
        "checkQueryStringLength": true,
        "queryStringLength": 2048,
        "responseCheck": false
    },
    {
        "name": "pat",
        "allowed": false
    },
    {
        "name": "mat",
        "allowed": false
    }
]
~~~

#### HTTPS Reference

HTTPS references are a special case of URL references. It uses the HTTPS protocol instead of the HTTP protocol. Make sure that the webserver you are downloading the resources from does also support HTTPS protocol and has certificates setup properly.

- Certificates must be valid in date (not expired) during the policy compilation.
- Certificates must be signed by a trusted CA.
- For Self-signed certificates, you need to make sure to add your certificates to the trusted CA of the machine where App Protect is installed.
- Certificates must use the exact domain name that the certificate was issued for. For example, SSL will differentiate between domain.com and www.domain.com, considering each a different domain name.

##### Example Configuration

In this configuration, we are completely satisfied with the basic default policy, and we wish to use it as is. However, we wish to define a custom response page using an external file located on an HTTPS web server. The external reference file contains our custom response page configuration.

**Policy configuration:**

```json
{
    "name": "external_references_custom_respsonse",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "responsePageReference": {
        "link": "https://securedomain.com:8081/response-pages.txt"
    }
}
```

Content of the referenced file `response-pages.txt`:

```json
[
    {
        "responseContent": "<html><head><title>Custom Reject Page</title></head><body>This is a custom response page, it is supposed to overwrite the default page with custom text.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
        "responseHeader": "HTTP/1.1 200 OK\r\nCache-Control: no-cache\r\nPragma: no-cache\r\nConnection: close",
        "responseActionType": "custom",
        "responsePageType": "default"
    }
]
```

##### Example Configuration

In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced.

**Policy configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "All Signatures",
                "block": true,
                "alarm": true
            }
        ]
    },
    "modificationsReference": {
        "link": "http://my-domain.com:8081/modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

#### File Reference

File references refers to accessing local resources on the same machine, as opposed to accessing a remote resource on another server/machine. The user can specify any location that is accessible by App Protect except for the root folder ("/"). If no full path is provided, the default path `/etc/app_protect/conf` will be assumed. Note that file references can only be on the local machine: you cannot use remote hosts!

Here are some examples of the typical cases:

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Link URL Format (examples) | File Path | Comment | 
| ---| ---| --- | 
|<file:///foo.json> | /etc/app_protect/conf/foo.json | Default directory assumed | 
|<file://foo.json> | /etc/app_protect/conf/foo.json | Formally illegal, but tolerated as long as there is no trailing slash. | 
|<file:///etc/app_protect/conf/foo.json> | /etc/app_protect/conf/foo.json | Full path, but still the default one | 
|<file:///bar/foo.json> | /bar/foo.json | Non-default path | 
|<file://etc/app_protect/conf/foo.json> | **Not accepted** | "etc" is interpreted as remote host name | 
{{</bootstrap-table>}} 


##### Example Configuration

In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced. To do this, we reference a local file on the machine.

**Policy Configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "All Signatures",
                "block": true,
                "alarm": true
            }
        ]
    },
    "modificationsReference": {
        "link": "file:///modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

#### Configuration Errors

If, for any reason, the configuration was done incorrectly, the policy compilation process will fail with the following error:
```shell
APP_PROTECT { "event": "configuration_load_failure" ...
```

The error details that follow will depend on the exact situation causing the policy compilation to fail.  If the policy compilation process fails, the compiler will revert to the last working policy and all the changes for the last policy compilation attempt will be lost.

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

There are different ways of referencing OpenAPI Specification files. The configuration is similar to [External References](#external-references).

{{< note >}} Any update of an OpenAPI Specification file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration. {{< /note >}}

#### URL Reference

URL reference is the method of referencing an external source by providing its full URL.

Make sure to configure certificates prior to using the HTTPS protocol - see the [HTTPS References](#https-reference) under the External References section for more details.

{{< note >}} You need to make sure that the server where the resource files are located is always available when you are compiling your policy. {{< /note >}}

##### Example Configuration

In this example, we are adding an OpenAPI Specification file reference to `/etc/app_protect/conf/NginxApiSecurityPolicy.json` using the link `http://127.0.0.1:8088/myapi.yaml`. This will configure allowed data types for `query_int` and `query_str` parameters values.

**Policy configuration:**

~~~json
{
    "policy": {
        "name": "petstore_api_security_policy",
        "description": "NGINX App Protect WAF API Security Policy for the Petstore API",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "open-api-files": [
            {
                "link": "http://127.0.0.1:8088/myapi.yaml"
            }
        ],
        "blocking-settings": {
            "violations": [
                {
                    "block": true,
                    "description": "Disallowed file upload content detected in body",
                    "name": "VIOL_FILE_UPLOAD_IN_BODY"
                },
                {
                    "block": true,
                    "description": "Mandatory request body is missing",
                    "name": "VIOL_MANDATORY_REQUEST_BODY"
                },
                {
                    "block": true,
                    "description": "Illegal parameter location",
                    "name": "VIOL_PARAMETER_LOCATION"
                },
                {
                    "block": true,
                    "description": "Mandatory parameter is missing",
                    "name": "VIOL_MANDATORY_PARAMETER"
                },
                {
                    "block": true,
                    "description": "JSON data does not comply with JSON schema",
                    "name": "VIOL_JSON_SCHEMA"
                },
                {
                    "block": true,
                    "description": "Illegal parameter array value",
                    "name": "VIOL_PARAMETER_ARRAY_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal Base64 value",
                    "name": "VIOL_PARAMETER_VALUE_BASE64"
                },
                {
                    "block": true,
                    "description": "Disallowed file upload content detected",
                    "name": "VIOL_FILE_UPLOAD"
                },
                {
                    "block": true,
                    "description": "Illegal request content type",
                    "name": "VIOL_URL_CONTENT_TYPE"
                },
                {
                    "block": true,
                    "description": "Illegal static parameter value",
                    "name": "VIOL_PARAMETER_STATIC_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal parameter value length",
                    "name": "VIOL_PARAMETER_VALUE_LENGTH"
                },
                {
                    "block": true,
                    "description": "Illegal parameter data type",
                    "name": "VIOL_PARAMETER_DATA_TYPE"
                },
                {
                    "block": true,
                    "description": "Illegal parameter numeric value",
                    "name": "VIOL_PARAMETER_NUMERIC_VALUE"
                },
                {
                    "block": true,
                    "description": "Parameter value does not comply with regular expression",
                    "name": "VIOL_PARAMETER_VALUE_REGEXP"
                },
                {
                    "block": true,
                    "description": "Illegal URL",
                    "name": "VIOL_URL"
                },
                {
                    "block": true,
                    "description": "Illegal parameter",
                    "name": "VIOL_PARAMETER"
                },
                {
                    "block": true,
                    "description": "Illegal empty parameter value",
                    "name": "VIOL_PARAMETER_EMPTY_VALUE"
                },
                {
                    "block": true,
                    "description": "Illegal repeated parameter name",
                    "name": "VIOL_PARAMETER_REPEATED"
                }
            ]
        }
    }
}
~~~

Content of the referenced file `myapi.yaml`:

~~~yaml
openapi: 3.0.1
info:
  title: 'Primitive data types'
  description: 'Primitive data types.'
  version: '2.5.0'
servers:
  - url: http://localhost
paths:
  /query:
    get:
      tags:
        - query_int_str
      description: query_int_str
      operationId: query_int_str
      parameters:
        - name: query_int
          in: query
          required: false
          allowEmptyValue: false
          schema:
            type: integer
        - name: query_str
          in: query
          required: false
          allowEmptyValue: true
          schema:
            type: string           
      responses:
        200:
          description: OK
        404:
          description: NotFound
~~~

In this case the following request will trigger an `Illegal parameter data type` violation, as we expect to have an integer value in the `query_int` parameter:

```
http://localhost/query?query_int=abc
```

The request will be blocked.

The link option is also available in the `openApiFileReference` property and synonymous with the one above in `open-api-files`

**Note**: `openApiFileReference` is not an array.

##### Example Configuration

In this example, we reference the same OpenAPI Specification file as in the policy above using the `openApiFileReference` property.

**Policy configuration:**

~~~json
{
    "name": "openapifilereference-yaml",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "openApiFileReference": {
        "link": "http://127.0.0.1:8088/ref.txt"
    }
}
~~~

Content of the file `ref.txt`:

```json
[
    {
        "link": "http://127.0.0.1:8088/myapi.yaml"
    }
]
```

#### File Reference

File reference refers to accessing local resources on the same machine. See the [File References](#file-reference) under the External References section for more details.

##### Example Configuration
     
In this example, we would like to add an OpenAPI Specification file reference to the default policy.
     
**Policy Configuration:**
     
```json
{
    "name": "openapi-file-reference-json",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "open-api-files": [
        {
            "link": "file:///myapi2.json"
        }
    ]
}
```

Content of the referenced file `myapi2.json`:

~~~json
{
    "openapi": "3.0.1",
    "info": {
        "title": "Primitive data types2",
        "description": "Primitive data types.",
        "version": "2.5.1"
    },
    "servers": [
        {
            "url": "http://localhost"
        }
    ],
    "paths": {
        "/query": {
            "get": {
                "tags": [
                    "query_bool"
                ],
                "description": "query_bool",
                "operationId": "query_bool",
                "parameters": [
                    {
                        "name": "query_bool",
                        "in": "query",
                        "required": false,
                        "schema": {
                            "type": "boolean"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK"
                    },
                    "404": {
                        "description": "NotFound"
                    }
                }
            }
        }
    }
}
~~~

In this case the following request will trigger an `Illegal repeated parameter name` violation, as the OpenAPI Specification doesn't allow repeated parameters. 

```
http://localhost/query?a=true&a=false
```

The request will not be blocked because this violation is set to alarm in the default policy.

## gRPC Protection for Unary Traffic

gRPC is a remote API standard and is an alternative to OpenAPI. If your applications expose gRPC APIs, NGINX App Protect WAF can protect them by parsing the messages; making sure they comply with the API definition; and enforcing security restrictions - such as size limits, detecting attack signatures, threat campaigns, and suspicious metacharacters in message string field values.
In the following sections, you will learn how to configure gRPC protection in the policy using gRPC Content Profiles.

### gRPC Content Profiles

The gRPC Content Profile contains all the definitions for protecting a gRPC service. It is similar in nature to the **JSON and XML profiles** handling JSON and XML traffic respectively. Roughly it includes:
- **The IDL files** of the protected gRPC service. This is essential for App Protect to be able to parse the API messages and determine whether they are legal and what needs to be inspected for security. [For more info regarding including an external file]({{< relref "#including-an-external-json-schema-file" >}}).
- **Security enforcement**: whether to detect signatures and/or metacharacters and optionally an exception (a.k.a override) list of signatures that need to be disabled in the context of this profile.
- **Defense attributes**: special restrictions applied to the gRPC traffic. This includes a size limit for the gRPC messages in the request, and whether to tolerate fields that are not defined in the definition of the Protocol Buffer messages.

Let's look at an example:

Assume you have a service with this IDL:

```proto
syntax = "proto3";

package myorg.services;

import "common/messages.proto";

service photo_album {
  rpc upload_photo (Photo) returns (OperationResult) {};
  rpc get_photos (Condition) returns (PhotoResult) {};
}

message Photo {
  string name = 1;
  bytes image = 2;
}

message PhotoResult {
  repeated Photo photos = 1;
  OperationResult res = 2;
}
```

The definitions of `OperationResult` and `Condition` messages are in the imported file found in `common/messages.proto` which we will not list here. The two files need to be referenced in the gRPC Content Profile. Here is the policy with the profile example:

#### Policy with the profile example:

```json
{
    "policy": {
        "name": "my-grpc-service-policy",
        "grpc-profiles": [
            {
                "name": "photo_service_profile",
                "associateUrls": true,
                "defenseAttributes": {
                    "maximumDataLength": 100000,
                    "allowUnknownFields": false
                },
                "attackSignaturesCheck": true,
                "signatureOverrides": [
                    {
                        "signatureId": 200001213,
                        "enabled": false
                    },
                    {
                        "signatureId": 200089779,
                        "enabled": false
                    }
                ],
                "metacharCheck": true,
                "idlFiles": [
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/album.proto"
                        },
                        "isPrimary": true
                    },
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/common/messages.proto"
                        },
                        "importUrl": "common"
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "*",
                "type": "wildcard",
                "method": "*",
                "$action": "delete"
            }
        ]
    }
}
```

The profile in this example enables checking of attack signatures and disallowed metacharacters in the string-typed fields within the service messages. Two signatures are disabled. The profile also limits the size of the messages to 100KB and disallows fields that are not defined in the IDL files.

The main IDL file, `album.proto` is marked as `primary`. The file it imports, `messages.proto`, is marked as secondary, i.e., `isPrimary` is `false` and so should be any imported file. In order for App Protect to be able to match it to the import statement, the file location should be specified as done in the example above using the `importUrl` property.

An alternative and probably more convenient way to specify all the IDL files, the primary and all its imports, direct and indirect, is to bundle them into a single tar file in the same directory structure as they are expected by the import statements. In this case, you will have to specify which of the files in the tarball is the primary one. The supported formats are `tar` and `tgz`. App Protect will identify the file type automatically (tar, gzipped tar, or JSON) and handle it accordingly. Following the above example:

```json
"idlFiles": [{
    "idlFile": {
        "$ref": "file:///grpc_files/album_service_files.tgz"
    },
    "primaryIdlFilename": "album_service.proto"
}]
```

Note the deletion of the `*` URL in the above policy. This is required if you want to accept only requests pertaining to the gRPC services exposed by your apps. If you decide to leave this catch-all URL, App Protect will accept other traffic including gRPC requests, applying policy checks such as signature detection. However, it will not apply to any gRPC-specific protection on them.

### Associating Profiles with URLs

As with JSON and XML profiles, in order for a gRPC Content Profile to become effective, it has to be associated with a URL that represents the service. However, in the sample policy above, the profile was apparently not associated with any URL and yet the profile is active. How did this happen? By setting `associateUrls` with `true`, App Protect **implicitly** creates the URL based on the package and service name as defined in the IDL file and associates the profile with that URL. In this example, the URL is `/myorg.services.photo_album/*`. Note it is a wildcard URL so that all methods in this service match it in its suffix; for example `/myorg.services.photo_album/get_photos` represents the `get_photos` RPC method.

Automatic association with URLs (`associateUrls` is `true`) is the recommended method of configuring gRPC protection, but if your gRPC services are mapped to URLs in a different manner, you can always explicitly associate a gRPC Content Profile with a different or an additional URL than the one implied by the service name, as in this example:

```json
{
    "policy": {
        "name": "my-special-grpc-service-policy",
        "grpc-profiles": [
            {
                "name": "special_service_profile",
                "associateUrls": false,
                "defenseAttributes": {
                    "maximumDataLength": "any",
                    "allowUnknownFields": true
                },
                "attackSignaturesCheck": true,
                "idlFiles": [
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/special_service.proto"
                        },
                        "isPrimary": true
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/services/unique/special/*",
                "method": "POST",
                "type": "wildcard",
                "isAllowed": true,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "special_service_profile"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "grpc"
                    }
                ]
            },
            {
                "name": "*",
                "type": "wildcard",
                "method": "*",
                "$action": "delete"
            }
        ]
    }
}
```

You can always override the properties of the URL with the gRPC Content Profile even if you use `associateUrls` to `true`. For example, you can turn off meta character checks by adding `"metacharsOnUrlCheck": false` within the respective URL entry.

### gRPC Response Pages

A gRPC error response page is returned when a request is blocked. The default page returns gRPC status code `UNKNOWN` (numeric value of 2) and a short textual message that includes the support ID. You can customize any of these two by configuring a custom gRPC response page in your policy.

```json
{
    "policy": {
        "name": "my-special-grpc-service-policy",
        "response-pages": [
            {
                "responsePageType": "grpc",
                "grpcStatusCode": "INVALID_ARGUMENT",
                "grpcStatusMessage": "Operation does not comply with the service requirements. Please contact your administrator with the following number: <%TS.request.ID()%>"
            }
        ]
    }
}
```

The `grpcStatusCode` expects one of the [standard gRPC status code values](https://grpc.github.io/grpc/core/md_doc_statuscodes.html).

### Detect Base64 in String Values

The Detect Base64 feature allows NGINX App Protect WAF to detect whether values in string fields in gRPC payload are Base64 encoded. When a value is detected as Base64 encoded NGINX App Protect WAF will enforce the configured signatures on the decoded value __and__ on the original value.

This feature is disabled by default and can be enabled by setting `decodeStringValuesAsBase64` to `enabled`.

This has to be used with care because Protocol Buffer protocol is supposed to carry binary fields of "bytes" type and, thus, trying to decode strings as Base64 may lead to false positives. Using Base64-encoded strings for binary data is usually not a good practice but, if the protected app still does that, then enable Base64 detection.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "valid_string_encoding_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "idl-files": [
            {
                "fileName": "valid_string.proto",
                "link": "file:///tmp/grpc/valid_string.proto"
            }
        ],
        "grpc-profiles": [
            {
                "name": "base64_decode_strings",
                "description": "My first profile",
                "idlFiles": [
                    {
                        "idlFile": {
                            "fileName": "valid_string.proto"
                        }
                    }],
                "decodeStringValuesAsBase64": "enabled"
            }
        ]
    }
}
```

### Protocol Buffers Supported Version

The supported Protocol Buffer version is 3 i.e. only proto3 is supported. Version 2 is not supported. Hence any obsolete feature of version 2, such as message extensions in the IDL files, will be rejected. IDL files that have the `syntax = "proto2";` statement is also rejected.

### gRPC Server Reflection

[gRPC Server Reflection](https://grpc.github.io/grpc/core/md_doc_server_reflection_tutorial.html) provides information about publicly-accessible gRPC services on a server, and assists clients at runtime to construct RPC requests and responses without precompiled service information. gRPC Server reflection is not currently supported in App Protect. If Server Reflection support is required, App Protect must be disabled on the reflection URIs by adding a location block such as this:

~~~nginx
server {
    location /grpc.reflection {
        app_protect_enable off;
        grpc_pass grpc://grpc_backend;
    }
}
~~~

## gRPC Protection for Bidirectional Streaming

### Bidirectional Streaming Overview

A gRPC service can have a stream of messages on each side: client, server, or both. Bidirectional Streaming leverages HTTP/2 streaming capability, namely the ability to send multiple gRPC messages from either side ended by the message having the `END_STREAM` flag set to 1. 

The Bidirectional Streaming will:

1. Accept streaming services on either or both sides (client or server) and send a sequence of messages using a read-write stream.
2. Inspect the client messages in the stream and log them one by one.
3. In case of blocking action:
    - Send the blocking response.
    - Close the stream on both directions.
4. Pass the server messages through without inspection.

<br> The below image demonstrates bidirectional streaming (client-side and server-side streaming):

{{< img src="/grpc/grpc_streaming.png" alt="gRPC Streaming" >}}
<br>

### Configuration

The only configuration related to streaming is the IDL file or more specifically the `rpc` declaration. The keyword `stream` indicates that the message on the respective side is streaming. <br> <br>For example:

#### Client Stream

Where the client writes a sequence of messages and sends them to the server, again using a provided stream. Once the client has finished writing the messages, it waits for the server to read them and return its response. Again gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```
#### Server Stream

Where the client sends a request to the server and gets a stream to read a sequence of messages back. The client reads from the returned stream until there are no more messages. gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```
#### Bidirectional Streams

Where both sides send a sequence of messages using a read-write stream. The two streams operate independently, so clients and servers can read and write in whatever order they like: for example, the server could wait to receive all the client messages before writing its responses, or it could alternately read a message and then write a message, or some other combination of reads and writes. The order of messages in each stream is preserved.

```shell
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

#### Bidirectional IDL File Example:

```proto
syntax = "proto3";
package streaming;
service Greeter {
  rpc BothUnary (HelloRequest) returns (HelloReply) {}
  rpc ClientStreaming (stream HelloRequest) returns (HelloReply) {}
  rpc ServerStreaming (HelloRequest) returns (stream HelloReply) {}
  rpc BidirectionalStreaming (stream HelloRequest) returns (stream HelloReply) {}
}
message HelloRequest {
  string message = 1;
}
message HelloReply {
  string message = 1;
}
```

#### Enabling the gRPC Protection for Bidirectional Streaming

For enabling the gRPC capability, an HTTP/2 server definition needs to be applied with the `grpc_pass` location in the `nginx.conf` file. In addition, the `app_protect_policy_file` directive points to a policy specific to gRPC. All the gRPC messages will be logged in Security Log under the `log_grpc_all.json` file. For more details on how these requests are handled in gRPC, refer to the [gRPC Logging](#grpc-logging) section.

```nginx 
user nginx;
worker_processes auto;
 
load_module modules/ngx_http_app_protect_module.so;
 
error_log /var/log/nginx/error.log debug;
working_directory /tmp/cores;
worker_rlimit_core 1000M;
 
events {
    worker_connections  1024;
}
 
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    keepalive_timeout  30m;
    client_body_timeout 30m;
    client_max_body_size 0;
    send_timeout 30m;

    proxy_connect_timeout  30m;
    proxy_send_timeout  30m;
    proxy_read_timeout  30m;
    proxy_socket_keepalive on;

    server {
        listen       80 default_server http2;
        server_name  localhost;
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/grpc_policy.json";
        app_protect_security_log_enable on;
        app_protect_security_log "/opt/app_protect/share/defaults/log_grpc_all.json" /tmp/grpc.log;

        grpc_socket_keepalive on;
        grpc_read_timeout 30m;
        grpc_send_timeout 30m;

        location / {
            default_type text/html;
            grpc_pass grpc://<GRPC_BACKEND_SERVER_IP>:<PORT>;
        }
    }
}
```

#### Policy with the profile example:

Refer to the above section for more details on [policy with the profile example](#policy-with-the-profile-example).

### gRPC Bidirectional Streaming Enforcement 

#### Client Request Flow

Bidirectional Enforcement is per message; each message is buffered and processed (doing all the inspection actions according to the policy: signatures, metacharacters, and other violations) on its own. The following section provides more details on receiving a client event:

- The request header and each of the messages in the client stream is enforced **separately**.
- The Enforcer issues a separate security log message per each message containing the violations found on it (if any). Refer to the [gRPC Violations](#grpc-violations) section for more details on gRPC violations. There is also a separate log message per request headers opening the stream.
- Then the Enforcer decides on the action that results from the violations just as it does for a regular HTTP request, but in gRPC it is done **per message** rather than the per whole stream. So if a message needs to be blocked, a blocking response is sent to the client and the stream is closed, but all the messages that preceded the blocked message have already been sent to the server.
- A special case is when the request headers message had blocking violations. In that case, the blocking response is sent right away, ignoring any messages the client may have sent afterward. The security log will just reflect the headers in this case. See more details in the [Sending Blocking Response in Bidirectional Streaming](#sending-blocking-response-in-bidirectional-streaming) section below.

#### Server Response Flow

gRPC server messages are not processed. All gRPC messages (unary or streaming) including the headers and trailer messages, are sent directly to the client (without sending them to the Enforcer).

#### Sending Blocking Response in Bidirectional Streaming

The blocking response comes as the **trailers** message is sent to the client on behalf of the server. At the same time, the server gets the `END_STREAM` frame to ensure streams on both sides are closed.

### Size Limits
The maximum total request size is applied to each message on its own, rather than to the total stream messages. By default, the maximum gRPC message size is 4MB.
You can configure different sizes in the declarative policy, like the 100K in the [Policy Example File](#policy-with-the-profile-example). If a message is sent with a size larger than that value, a `GRPC_FORMAT` violation is raised. If a message is sent with a size larger than 10MB, a `GRPC_MALFORMED` and `REQUEST_MAX_LENGTH` violation is raised.

There is no limit to the number of messages in a stream.

### Message Compression

Currently, Message Compression is not supported. Therefore, a violation `VIOL_GRPC_MALFORMED` will be raised and the connection will be blocked if a compressed message is sent.

### Slow POST Attacks
A Slow POST attack or Slow HTTP POST attack is a type of denial of service attack. The attacker sends a legitimate HTTP POST request with the header Content-Length specified. The attacker then proceeds to send this content slowly. The server establishes a connection to the client and keeps it open to receive the request that it thinks is legitimate.

The attacker sends several such requests and effectively occupies the server’s entire connection pool. As a result, it blocks the service for other legitimate users and results in a denial of service.

### Handling Slow POST Attacks 

Slow POST attack mitigation - A client sending messages very slowly for a long time may be cut off by resetting the connection.

In gRPC, a connection is considered "slow" if a message takes more than 10 seconds to process. In other words, the slow connection timer will be reset when a message ends and not when the whole request ends. This way, a limit is applied on the number of concurrent messages rather than the number of concurrent gRPC connections (streams), as many of them may be idle.

The number of slow connections is limited to 25. Once another connection becomes slow it is reset.

## Other gRPC References

### gRPC Violations

There are three violations that are specific to gRPC. They are all enabled in the default policy. See also the [Violations](#violations) section. 

- `VIOL_GRPC_MALFORMED`: This violation is issued when a gRPC message cannot be parsed according to its expected definition. This violation **blocks** in the default policy.
- `VIOL_GRPC_FORMAT`: This violation is issued when any of the definitions in the `defenseAttributes` of the profile are violated; for example, the maximum total size is exceeded. 
- `VIOL_GRPC_METHOD`: This violation is issued when the gRPC method is unrecognized in the configured IDL.

The violation `VIOL_METHOD` (not to be confused with the above `VIOL_GRPC_METHOD`) is not unique to gRPC, but in the context of a gRPC Content Profile, it is issued in special circumstances. Since gRPC mandates using the `POST` method on any gRPC request over HTTP, any other HTTP method on a request to URL with gRPC Content Profile will trigger this violation, even if the respective HTTP method is allowed in the policy. So, in our first example above, the request `GET /myorg.services.photo_album/get_photos` will trigger `VIOL_METHOD` even though `GET` is among the allowed HTTP methods in the policy (by the base template).

### gRPC Logging

Security log for gRPC requests has unique fields: `uri`, `grpc_method`, and `grpc_service`. Also, since the content of gRPC requests is binary (Protocol Buffers), it is better transferred in Base64 encoding. Hence, it is recommended to use the `headers` and `request_body_base64` fields instead of the `request` field. A new predefined log format called `grpc` should be used in all gRPC locations that also use policies with gRPC Content Profiles.
The `grpc` format also contains the above new gRPC fields (`grpc_service` and `grpc_method`). See [Available Security Log Attributes]({{< relref "/nap-waf/logging-overview/security-log#available-security-log-attributes" >}}).

NGINX App Protect WAF provides three security log configuration files for gRPC: `log_grpc_all.json`, `log_grpc_illegal.json` and `log_grpc_blocked.json` using the `grpc` format with three filters: all requests, illegal requests, and blocked requests respectively. Unless you have special logging format requirements, the best practice is to use one of these files in all gRPC locations with the `app_protect_security_log` directive. These log configuration files are located in: `/opt/app_protect/share/defaults`.

Here is a typical example:

~~~nginx
server {
    server_name my_grpc_service.com;
    location / {
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/policies/policy_with_grpc_profile.json";
	app_protect_security_log_enable on;
        app_protect_security_log "/opt/app_protect/share/defaults/log_grpc_all.json" stderr;
        grpc_pass grpcs://grpc_backend;
    }
}
~~~

## Securing GraphQL APIs with NGINX App protect WAF

### GraphQL Overview
GraphQL is an API technology that has grown rapidly in recent years and is continuing to gain traction. GraphQL is a query language designed for APIs to use in the development of client applications that access large data sets with intricate relations among themselves. It provides an intuitive application and flexible syntax for describing data requirements. <br>

GraphQL provides a more efficient, powerful and flexible alternative to REST APIs. This makes it easier to retrieve the data you require in a single request and helps in overcoming challenges which include under-fetching and over-fetching of data. GraphQL also enables faster front-end development without the need for new API endpoints (GraphQL works on a single endpoint), great backend analytics using GraphQL queries and a structured schema and type system.

GraphQL also allows the client to specify exactly what data it needs, reducing the amount of data transferred over the network and improving the overall performance of the application.  

In the following sections, you will learn more about enabling GraphQL configuration (using basic and advanced configuration) plus GraphQL security, GraphQL profile and URL settings.

### GraphQL Security
Securing GraphQL APIs with NGINX App Protect WAF involves using WAF to monitor and protect against security threats and attacks. GraphQL, like REST, is usually [served over HTTP](http://graphql.org/learn/serving-over-http/), using GET and POST requests and a proprietary [query language](https://graphql.org/learn/schema/#the-query-and-mutation-types). It is prone to the typical Web APIs security vulnerabilities, such as injection attacks, Denial of Service (DoS) attacks and abuse of flawed authorization.

Unlike REST, where Web resources are identified by multiple URLs, GraphQL server operates on a single URL/endpoint, usually **/graphql**. All GraphQL requests for a given service should be directed to this endpoint.


## Enabling GraphQL with Basic Configuration

This section describes how to configure GraphQL with minimal configuration. Refer to the following sections for GraphQL elements definitions and details about advanced configuration options.

{{< note >}} GraphQL is supported on NGINX App Protect WAF version starting 4.2. Make sure you're running NGINX App Protect WAF version 4.2 or later to get GraphQL to work properly.{{< /note >}}

GraphQL policy consists of three basic elements: GraphQL Profile, GraphQL Violations and GraphQL URL.

You can enable GraphQL on app protect by following these steps: 

1. Create a GraphQL policy that includes the policy name. Note that GraphQL profile and GraphQL violation will be enabled by default in the default policy.
You can enable GraphQL on app protect with minimum effort by using the following GraphQL policy example.
2. Add the GraphQL URL to the policy and associate the GraphQL defeault profile with it.
3. Optionally, if the app that uses this policy serves only GraphQL traffic, then delete the wildcard URL "*" from the policy so that requests to any URL other than **/graphql** will trigger a violation. In the example below we assume this is the case.
4. Update the `nginx.conf` file. To enforce GraphQL settings, update the `app_protect_policy_file` field with the GraphQL policy name in `nginx.conf` file. Perform nginx reload once `nginx.conf` file is updated to enforce the GraphQL settings.

In the following policy example, the GraphQL “policy name” i.e. “graphql_policy”, and graphql “urls” settings are defined.

```shell
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "urls": [
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "type": "wildcard"
        },
        {
            "name": "/graphql",
            "type": "explicit",
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "Default"
                    },
                    "headerValue": "*",
                    "headerName": "*",
                    "headerOrder": "default",
                    "type": "graphql"
                }
            ]
        }
    ]
}
```

As described in point 4 above, here is an example `nginx.conf` file: 

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

    app_protect_enable on;  # This is how you enable NGINX App Protect WAF in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This is a reference to the policy file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=127.0.0.1:515; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port
   

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://172.29.38.211:80$request_uri;
        }

        location /graphql {
            client_max_body_size 0;
            default_type text/html;
            app_protect_policy_file "/etc/app_protect/conf/graphQL_policy.json"; # This location will invoke the custom GraphQL policy 
            proxy_pass http://172.29.38.211:80$request_uri;
        }
    }
}
```

## GraphQL Advanced Configuration
The below sections provides details about enabling GraphQL with advanced configuration.

In advanced configuration, GraphQL policy consists of GraphQL Violations, GraphQL Profile and the URL section.

### GraphQL Violations
NGINX App Protect WAF introduces four new violations specific to GraphQL: `VIOL_GRAPHQL_FORMAT`, `VIOL_GRAPHQL_MALFORMED`, `VIOL_GRAPHQL_INTROSPECTION_QUERY` and `VIOL_GRAPHQL_ERROR_RESPONSE`. <br>

Under the "blocking-settings," user can either enable or disable these violations. Note that these violations will be enabled by default. Any changes to these violation settings here will override the default settings. The details regarding logs will be recorded in the security log. <br>

See also the [Violations](#violations) section for more details.

While configuring GraphQL, since the GraphQL violations are enabled by default, you can change the GraphQL violations settings i.e. alarm: `true` and block: `false` under the "blocking settings". In this manner, the GraphQL profile detects violations but does not block the request. They may contribute to the Violation Rating, which, if raised above 3, will automatically block the request. 

However, setting the alarm and block to `true` will enforce block settings and app protect will block any violating requests.

See below example for more details:

```shell
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "blocking-settings": {
        "violations": [
            {
                "name": "VIOL_GRAPHQL_FORMAT",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_MALFORMED",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_INTROSPECTION_QUERY",
                "alarm": true,
                "block": false
            },
            {
                "name": "VIOL_GRAPHQL_ERROR_RESPONSE",
                "alarm": true,
                "block": false
            }
        ]
    } 
}    
```
### GraphQL Profile

The GraphQL Profile defines the GraphQL properties that are enforced by the security policy. 

The profile can be added by the security engineers to make sure that GraphQL apps are bound to the same security settings defined in the profile. Different GraphQL apps can have different profiles based on the security needs.

The GraphQL Profile includes:

- **Security enforcement**: whether to detect signatures and/or metacharacters and optionally an exception (a.k.a override) list of signatures that need to be disabled in the context of this profile.
- **Defense attributes**: special restrictions applied to the GraphQL traffic. The below example shows the customized GraphQL properties.
- **responseEnforcement**: whether to block Disallowed patterns and provide the list of patterns against the `disallowedPatterns` property.

GraphQL profile example:
 
In the GraphQL profile example below, we changed the "defenseAttributes" to custom values. You can customize these values under the "defenseAttributes" property. Add a list of disallowed patterns to the "disallowedPatterns" field (for example, here we've added pattern1 and pattern2).

```shell
"graphql-profiles" : [
         {
            "attackSignaturesCheck" : true,
            "defenseAttributes" : {
            "allowIntrospectionQueries" : false,
               "maximumBatchedQueries" : 10,
               "maximumQueryCost" : "any",
               "maximumStructureDepth" : 10,
               "maximumTotalLength" : 100000,
               "maximumValueLength" : 100000,
               "tolerateParsingWarnings" : false
            },
            "description" : "",
            "metacharElementCheck" : false,
            "name" : "response_block",
            "responseEnforcement" : {
               "blockDisallowedPatterns" : true,
               "disallowedPatterns":["pattern1","pattern2"]
            }
         }
     ]
```

{{< note >}}For GraphQL profile default values and GraphQL violations reference, see NGINX App Protect WAF [Declarative Policy guide.]({{< relref "/nap-waf/declarative-policy/policy.md" >}}) {{< /note >}}

### Define URL settings
The second step to configure GraphQL is to define the URL settings. Set the values for "isAllowed": **true**, "name": **/graphql** in the URLs section, which means URLs with **/graphql** name are permitted. This path will be used for all GraphQL API requests.

Under the "urlContentProfiles" settings define the GraphQL profile name, headerValue: `*` (wildcard), headerName: `*` (wildcard), headerOrder: `default` (allowing any GraphQL URL request with any headerValue, headerName and type should be `graphql`.

There are no restrictions on the number of GraphQL profiles that can be added by the user.   

GraphQL URL example:

```shell
  "urls": [ 
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "protocol": "http",
            "type": "wildcard"
        },
        {
            "isAllowed": true,
            "name": "/graphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "Default"
                    },
                    "headerValue": "*",
                    "headerName": "*",
                    "headerOrder": "default",
                    "type": "graphql"
                }
            ]
        }    
    ]
```

### Associating GraphQL Profiles with URL 
The last step is to associate the GraphQL profiles with the URLs. As with JSON and XML profiles, in order for a GraphQL Profile to become effective, it has to be associated with a URL that represents the service. Add the GraphQL profile name which you defined previously under the GraphQL profiles in the name field. For example, here we have defined two GraphQL profiles with the "name": "Default" and "My Custom Profile" under the urlContentProfiles. Later we also associated these profiles in "graphql-profiles".

GraphQL configuration example:

In this example we define a custom GraphQL profile and use it on one URL, while assigning the default profile to another one.

```shell
{
    "name": "graphql_policy",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
   
    "graphql-profiles": [
        {
            "attackSignaturesCheck": true,
            "defenseAttributes": {
                "allowIntrospectionQueries": true,
                "maximumBatchedQueries": "any",
                "maximumQueryCost": "any",
                "maximumStructureDepth": "any",
                "maximumTotalLength": "any",
                "maximumValueLength": "any",
                "tolerateParsingWarnings": true
            },
            "description": "Default GraphQL Profile",
            "metacharElementCheck": true,
            "name": "Default",
            "responseEnforcement": {
                "blockDisallowedPatterns": false
            }
        },
        {
            "attackSignaturesCheck": true,
            "defenseAttributes": {
                "allowIntrospectionQueries": true,
                "maximumBatchedQueries": "any",
                "maximumQueryCost": "any",
                "maximumStructureDepth": "any",
                "maximumTotalLength": "400",
                "maximumValueLength": "any",
                "tolerateParsingWarnings": false
            },
            "description": "my custom Profile",
            "metacharElementCheck": true,
            "name": "My Custom Profile",
            "responseEnforcement": {
                "blockDisallowedPatterns": true,
                "disallowedPatterns": ["pattern1", "pattern2"]
            }
        }
    ],
    "urls": [
        {
            "$action": "delete",
            "method": "*",
            "name": "*",
            "protocol": "http",
            "type": "wildcard"
        },
        {
            "isAllowed": true,
            "name": "/graphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "Default"
                    },
                    "headerValue": "*",
                    "headerName": "*",
                    "headerOrder": "default",
                    "type": "graphql"
                }
            ]
        },
        {
            "isAllowed": true,
            "name": "/mygraphql",
            "protocol": "http",
            "type": "explicit",
            "performStaging": false,
            "urlContentProfiles": [
                {
                    "contentProfile": {
                        "name": "My Custom Profile"
                    },
                    "headerValue": "*",
                    "headerName": "*",
                    "headerOrder": "default",
                    "type": "graphql"
                }
            ]
        }
    ]
}
```

### GraphQL Response Pages

A GraphQL error response page is returned when a request is blocked. This GraphQL response page, like other blocking response pages, can be customized, but the GraphQL JSON syntax must be preserved for them to be displayed correctly. The default page returns the GraphQL status code Blocking Response Page (BRP) and a short JSON error message which includes the support ID. 

For example: 

```shell
"response-pages": [
        {
            "responsePageType": "graphql",
            "responseActionType": "default",
            "responseContent": "{\"errors\": [{\"message\": \"This is a custom GraphQL blocking response page. Code: BRP. Your support ID is: <%TS.request.ID()%>\"}]}"
        }
    ]
```

## Override Rules

### Override Rules Overview

The **Override Rules** feature allows overriding of the **default policy** settings. Each override rule consists of a condition followed by changes to the original policy applied to requests that meet the respective condition. This feature provides the ability to include the override rules within a declarative policy such that all incoming requests are verified against those rules.

With this enhancement, users now have more control over how a unique policy setting is applied to incoming requests with a specific method, source IP address, header or URI value through one or multiple unique override rules. Each override rule possesses a unique name and specific conditions that are matched against incoming traffic from a specific client side. The structure of these override rules adheres to the JSON schema defined by the declarative policy.

Here is an example of a declarative policy using an override rules entity:

```shell
{
  "policy": {
    "name": "override_rules_example",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "override-rules": [
      {
        "name": "localhost-log-only",
        "condition": "host.contains('localhost') and clientIp == '127.0.0.1' and userAgent.lower().startsWith('curl')",
        "override": {
          "policy": {
            "enforcementMode": "transparent"
          }
        }
      },
      {
        "name": "login_page",
        "condition": "method == 'POST' and uri.contains('/login/')",
        "extendsPolicy": false,
        "override": {
          "policy": {
            "name": "login_page_block_redirect",
            "template": {
              "name": "POLICY_TEMPLATE_NGINX_BASE"
            },
            "signature-sets": [
              {
                "name": "All Signatures",
                "block": true,
                "alarm": true
              }
            ],
            "response-pages": [
              {
                "responseRedirectUrl": "https://example.com/rejected?id=<%TS.request.ID()%>",
                "responseActionType": "redirect",
                "responsePageType": "default"
              }
            ]
          }
        }
      },
      {
        "name": "api-strict",
        "condition": "uri.contains('api4') and not clientIp.matches('fd00:1::/48') and not userAgent.lower().startsWith('Mozilla')",
        "extendsPolicy": false,
        "override": {
          "$ref": "file:///NginxStrictPolicy.json"
        }
      }
    ]
  }
}
```

The above "override_rules_example" policy contains three override rules:

1. The **"localhost-log-only"** rule applies to the requests with a user agent header starting with "curl", a host header containing "localhost", and a client IP address set to 127.0.0.1. It switches the enforcement mode to "transparent" without blocking the request. The remaining policy settings remain unchanged. This type of override rule is an example of an **Inline Policy Reference**.
2. The **"login_page"** rule is triggered by POST requests to URIs containing "/login/". Since the "extendsPolicy" field is set to false, it overrides the policy with a new one named "login_page_block_redirect". This new policy is independent of the "override_rules_example" policy. It enables all signature sets and redirects the user to a rejection page. This is another example of an **Inline Policy Reference** with a different condition.
3. The **"api-strict"** rule is applied for requests with "api4" in the URI, except for client IP addresses matching the "fd00:1::/48" range and user agents starting with "Mozilla". It references an external policy file named "NginxStrictPolicy.json" located at "/etc/app_protect/conf/" to override the current policy. The extendsPolicy is set to false and the external policy can be specified using a reference to its file using **$ref**. The file is the JSON policy source of that policy. This type of policy switching is known as **External Policy Reference**.

These three rules demonstrate how the override rules feature allows for customization and the ability to modify specific aspects of the original policy based on predefined conditions.


{{< note >}}
- By default, the extendsPolicy field is configured to true.
- External references are supported regardless of whether the extendsPolicy field is set to true or false.
{{< /note >}}

### First Match Principle 

The policy enforcement operates on the **first match** principle. This principle is applied when multiple conditions match or are similar, indicating that any incoming requests that match the first condition will be processed. In the following example, the "override_rules_example2" policy uses two override rules: "this_rule_will_match" and "non_matching_rule". Since both conditions match, the first match principle will be applied, and requests with "api" in the URI will be processed. It will reference an external policy file named "NginxStrictPolicy.json" to override the current policy. .

For example:

```shell
{
  "policy": {
    "name": "override_rules_example2",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "override-rules": [
      {
        "name": "this_rule_will_match",
        "condition": "uri.contains('api')",
        "extendsPolicy": false,
        "override": {
          "$ref": "file:///NginxStrictPolicy.json"
        }
      },
      {
        "name": "non_matching_rule",
        "condition": "uri.contains('api') and not clientIp == '192.168.0.10'",
        "extendsPolicy": true,
        "override": {
          "policy": {
            "enforcementMode": "transparent"
          }
        }
      }
    ]
  }
}
```

### Important Things to Remember About Override Rules

Here are some key points to remember regarding the Override Rules feature:

- To ensure efficient compilation time and optimal resource allocation for policies, there are limitations in place. Currently, policies have a maximum limit of 10 rules and a maximum of 5 clauses in a condition. These limitations help maintain better performance and manageability. A compilation error will not occur if a policy file contains more than 5 clauses or 10 overrides.
- The replacement policy should not include any override rules. Override rules should be used to extend or switch to a different policy, rather than being part of the replacement policy itself.
- Each override rule will be compiled as a separate policy, whether extending the main policy or switching to a new one. The enforcer will switch to the policy that corresponds to the matched rule, but the main policy name will be reported along with the override rule property.
- The URI, host, and user-agent strings in the request will be treated as plain ASCII characters and won't undergo language decoding. If any of these strings contain non-ASCII characters, they may be misinterpreted and may not comply with rules that expect specific values in the conditions.

### Override Rules Logging & Reporting

If a request matches an override rule, the `json_log` field will include a new block named 'overrideRule'. However, if no rules match the request, the log will not contain any related information. When the 'extendsPolicy' flag is set to false, the 'originalPolicyName' field in the log will reflect the name of the original policy name (the one that contains override rules), and the `policy_name` field will reflect the policy that was enforced.

For example, if the matching override rule is called "login_page":

```shell

...
policy_name="login_page_block_redirect"
...
 
json_log will have:
 
{
    ...
    "overrideRule": {
        "name": "login_page",
        "originalPolicyName": "override_rule_example" 
}
    ...
 
```

### Errors and Warnings

#### Missing Policy Name

Every policy must have a name, including a policy used for overriding in case extendsPolicy is false. If the policy 'name' is not provided in the override section, an error message will be displayed indicating the missing policy 'name' within that specific override rule. For instance, in the override rule below, the policy name is not specified.


Example of Missing policy 'name':

```shell
"override-rules": [
    {
        "name": "example-rule",
        "condition": "uri.contains('127')",
        "extendsPolicy": false,
        "override": {
            "policy": {
                "name": "policy_name",  <--- the missing part
                "enforcementMode": "transparent"
            }
        }
    }
]
```

Example of Missing policy 'name' error:

```shell
"error_message": "Failed to import Policy 'policy1' from '/etc/app_protect/conf/test.json': Missing policy 'name' in the override rule 'example-rule'."
```

#### Cyclic Override Rule Error

If an inline or externally referenced policy contains an override rule, a Cyclic Override Rule error will be issued.

Example of Cyclic Override Rule error:

```shell
"error_message": "Failed to import an override policy: Cyclic override-rules detected."
```


## Directives

### Global Directives

Global configuration consists of a series of `nginx.conf` directives at the `http` context controlling aspects that are not specific to a specific application.

When applied to a cluster, all cluster members will get the same globals as expected.

{{< note >}} Whether an incoming request is inspected by NGINX App Protect WAF may be determined by the URL in the request. This happens if you configure `app_protect_enable` and `app_protect_policy_file` directives in the `location` scope. In the case where the URL itself has violations such as *bad unescape* or *illegal metacharacter* then the request might be assigned to a location in which NGINX App Protect WAF is disabled or has a relaxed policy that does not detect these violations. Such malicious requests will be allowed without inspection. In order to avoid this, it is recommended to have a basic policy enabled at the `http` scope or at least at the `server` scope to process malicious requests in a more complete manner.{{< /note >}}

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Directive Name | Syntax | Description | Default | 
| ---| ---| ---| --- | 
|app_protect_physical_memory_util_thresholds | app_protect_physical_memory_util_thresholds high=<number_0-100> low=<number_0-100> | Sets the physical memory utilization thresholds for entering (high) and exiting (low) failure mode. When the high threshold is exceeded the system enters failure mode until memory drops below the low threshold. Setting the value of 100 disables this feature. | high=low=100 (disabled) | 
|app_protect_cpu_thresholds | app_protect_cpu_thresholds high=<number_0-100> low=<number_0-100> | Sets the CPU utilization thresholds for entering and exiting failure mode respectively: when the high threshold is exceeded the system enters failure mode until CPU drops below the low threshold. Setting the value of 100 disables this feature.<br>         **Note**:  The system does not enter failure mode during policy compilation after reload even if the threshold is exceeded. | high=low=100 (disabled) | 
|app_protect_failure_mode_action | app_protect_failure_mode_action pass &#124; drop | How to handle requests when the App Protect Enforcer cannot process them, either because it is down, disconnected or because of excessive CPU or memory utilization. There are two values:<ul><li>**pass**: Pass the request without App Protect Enforcer inspection, a.k.a. "fail-open".</li><li>**drop**: Drop the request by returning the response "503 Service Unavailable", a.k.a. "fail-close".</li></ul> | pass | 
|app_protect_cookie_seed | app_protect_cookie_seed <string> | A long randomized string that serves to generate the encryption key for the cookies generated by App Protect. The string should contain only alphanumeric characters and be no longer than 1000 characters. | Auto-generated random string | 
|app_protect_compressed_requests_action | app_protect_compressed_requests_action pass &#124; drop | Determines how to handle compressed requests. There are two values:<ul><li>**pass**: Pass the request without App Protect Enforcer inspection, a.k.a. "fail-open".</li><li>**drop**: Drop the request by returning the response "501 Not Implemented", a.k.a. "fail-close".</li></ul> | drop | 
|app_protect_request_buffer_overflow_action | app_protect_request_buffer_overflow_action pass &#124; drop | Determines how to handle requests in case the NGINX request buffer is full and requests cannot be buffered anymore. There are two values:<ul><li>**pass**: Pass the request without App Protect Enforcer inspection, a.k.a. "fail-open".</li><li>**drop**: Drop the request by resetting connection. No response page is returned, a.k.a. "fail-close".</li></ul> | pass | 
|app_protect_user_defined_signatures | app_protect_user_defined_signatures <path> | Imports the user-defined tagged signature file with the respective tag name from the provided path. Multiple instances of this directive are supported. In order to import multiple signatures files, each file must have a different tag. | N/A | 
|app_protect_reconnect_period_seconds| app_protect_reconnect_period_seconds <value> <br> **Value type**: number with decimal fraction <br> **Value Range**:  0-60. 0 is illegal | Determines the period of time between reconnect retries of the module to the web application firewall (WAF) engine. The time unit is seconds.| 5 |
{{</bootstrap-table>}} 


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
{{</bootstrap-table>}} 


#### Horizontal Scaling

NGINX App Protect WAF can be deployed in multiple instances that share the traffic to the same applications. In that case all the instances must share the same configuration files. It is your responsibility to synchronize the files on all instances. You also have to provide a load balancing solution in front of those instances such as another NGINX instance.

When deploying multiple scalability instances you have to add the `app_protect_cookie_seed` directive to nginx.conf in the `http` block:

~~~nginx
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
~~~

As the argument of this directive, put a random alphanumeric string of at least 20 characters length (but not more than 1000 characters). That seed is used by NGINX App Protect WAF to generate the encryption key for the cookies it creates. These cookies are used for various purposes such as validating the integrity of the cookies generated by the application.

In the absence of this directive, App Protect generates a random string by itself. In that case, each instance will have a different seed. A cookie created and encrypted on one instance of App Protect will fail to be decrypted when sent by the same client to another App Protect instance having a different encryption key.


#### Failure Mode

If the App Protect daemons are down or disconnected from the NGINX workers, there are two modes of operation until they are up and connected again:

-   **Pass** the traffic without inspection. Use this when preferring availability over security. This mode is also known as "fail open".
-   **Drop** the traffic. Use this when preferring security over availability. This mode is also known as "fail closed".

The default is to **pass**, fail open, but you can control this using the `app_protect_failure_mode_action` directive with one argument with two possible values: "pass" or "fail" for the two above options.

This directive is also placed in the `http` block of the nginx.conf file.

~~~nginx
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
~~~

#### Handling Compressed Requests

Requests with compressed body encoding are rarely used and NGINX App Protect WAF does not support them. Similar to failure mode, you can decide what to do with those requests. Either:

-   **Pass** the traffic without inspection, or
-   **Drop** the traffic. This is the preferred option as passing would create a security breach.

The default is to **Drop**, fail open, but you can control this using the `app_protect_compressed_requests_action` directive with one argument with two possible values: "pass" or "fail" for the two above options.

This directive is also placed in the `http` block of the nginx.conf file.

~~~nginx
...
http {
    ...
    app_protect_compressed_requests_action drop;
    ...
    server {
        listen       80;
...
    }
...
~~~

## Violations

App Protect violations are rated by the App Protect algorithms to help distinguish between attacks and potential false positive alerts.  A violation rating is a numerical rating that our algorithms give to requests based on the presence of violation(s). Each violation type and severity contributes to the calculation of the final rating. The final rating then defines the action taken for the specific request. As per the default policy, any violation rating of 1, 2 and 3 will not cause the request to be blocked and only a log will be generated with **alerted** status. If the violation rating is 4 or 5, the request is blocked: a blocking page is displayed and a log generated for the transaction with **blocked** status. Violation ratings are displayed in the logs by default.


### Supported Violations

The following violations are supported and can be enabled by turning on the **alarm** and/or **block** flags.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Violation Name | Title | Enabled Flags in Default Template | Description | Comment | 
| ---| ---| ---| ---| --- | 
|VIOL_ASM_COOKIE_MODIFIED | Modified ASM cookie | Alarm & Block | The system checks that the request contains an ASM cookie that has not been modified or tampered with. Blocks modified requests. |  |
|VIOL_ATTACK_SIGNATURE | Attack signature detected | N/A | The system examines the HTTP message for known attacks by matching it against known attack patterns. | Determined per signature set. <br>Note: This violation cannot be configured by the user. Rather, the violation is determined by the combination of the signature sets on the policy.| 
|VIOL_BLACKLISTED_IP | IP is in the deny list | Alarm | The violation is issued when a request comes from an IP address that falls in the range of an IP address exception marked for "always blocking", that is, the deny list of IPs. | Would trigger Violation Rating of 5. | 
|VIOL_BOT_CLIENT | Bot Client Detected | Alarm & Block | The system detects automated clients, and classifies them to Bot types. |  | 
|VIOL_COOKIE_EXPIRED | Expired timestamp | Alarm | The system checks that the timestamp in the HTTP cookie is not old. An old timestamp indicates that a client session has expired. Blocks expired requests. The timestamp is extracted and validated against the current time. If the timestamp is expired and it is not an entry point, the system issues the Expired Timestamp violation. |  | 
|VIOL_COOKIE_LENGTH | Illegal cookie length | Alarm | The system checks that the request does not include a cookie header that exceeds the acceptable length specified in the security policy. | Determined by policy setting which is disabled in default template. | 
|VIOL_COOKIE_MALFORMED | Cookie not RFC-compliant | Alarm & Block | This violation occurs when HTTP cookies contain at least one of the following components:<br><ul><li>Quotation marks in the cookie name.</li><li>A space in the cookie name.</li><li>An equal sign (=) in the cookie name.</li></ul><br>  Note: A space between the cookie name and the equal sign (=), and between the equal sign (=) and cookie value is allowed.<ul><li>An equal sign (=) before the cookie name.</li><li>A carriage return (hexadecimal value of 0xd) in the cookie name.</li></ul> |  | 
|VIOL_COOKIE_MODIFIED | Modified domain cookie(s) | Alarm | The system checks that the web application cookies within the request have not been tampered, and the system checks that the request includes a web application cookie defined in the security policy. | Determined by cookie type: applied to "enforced" cookies. | 
|VIOL_DATA_GUARD | Data Guard: Information leakage detected | Alarm | The system examines responses and searches for sensitive information. | Controlled by the DG enable flag which is disabled in default template. | 
|VIOL_ENCODING | Failed to convert character | Alarm & Block | The system detects that one of the characters does not comply with the configured language encoding of the web application's security policy. | Enforced by NGINX core, reported by App Protect. | 
|VIOL_EVASION | Evasion technique detected | Alarm | This category contains a list of evasion techniques that attackers use to bypass detection. |  | 
|VIOL_FILETYPE | Illegal file type | Alarm | The system checks that the requested file type is configured as a valid file type, or not configured as an invalid file type, within the security policy. | Only for disallowed file types. | 
|VIOL_FILE_UPLOAD | Disallowed file upload content detected | Alarm | The system checks that the file upload content is not a binary executable file format. | The check must be enabled for parameters of data type file upload | 
|VIOL_FILE_UPLOAD_IN_BODY | Disallowed file upload content detected in body | Alarm | The system checks that the file upload content is not a binary executable file format. | The check must be enabled for URLs | 
|VIOL_GRAPHQL_MALFORMED | Malformed GraphQL data | Alarm & Block | This violation will be issued when the traffic expected to be GraphQL doesn't comply to the GraphQL syntax. The specifics of the syntax that will be enforced in app protect is detailed in the enforcing section. The violation details will note the error.| In case of tolerate parser warning turned on, missing closing bracket of the JSON should not issue a violation. | 
|VIOL_GRAPHQL_FORMAT | GraphQL format data does not comply with format settings | Alarm & Block | This violation will be issued when the GraphQL profile settings are not satisfied, for example the length is too long, depth is too deep, a specific value is too long or too many batched queries. <br> The violation details will note what happened and the found length, depth or which value is too long and by what. <br> The depth violation is not learnable. The reason is that we don't know the actual depth of the query - we stop parsing at the max depth. <br> Note that the values will be used on the variables JSON part as well as the query. In a way, we can see these values as a JSON profile attributes just for the variables. | |
|VIOL_GRAPHQL_INTROSPECTION_QUERY| GraphQL introspection Query | Alarm & Block | This violation will be issued when an introspection query was seen. |  |
|VIOL_GRAPHQL_ERROR_RESPONSE | GraphQL Error Response | Alarm & Block | GraphQL disallowed pattern in response. | |
|VIOL_GRPC_FORMAT | gRPC data does not comply with format settings | Alarm | The system checks that the request contains gRPC content and complies with the various request limits within the defense configuration in the security policy's gRPC Content Profile. Enforces valid gRPC requests and protects the server from Protocol Buffers parser attacks. This violation is generated when a gRPC request does not meet restrictive conditions in the gRPC Content Profile, such as the message length or existence of unknown fields. |  | 
|VIOL_GRPC_MALFORMED | Malformed gRPC data | Alarm & Block | The system checks that the request contains gRPC content that is well-formed. Enforces parsable gRPC requests. |  | 
|VIOL_GRPC_METHOD | Illegal gRPC method | Alarm | The system checks that the gRPC service method invoked matches one of the methods defined in the IDL file. The violation is triggered if the method does not appear there. |  | 
|VIOL_HEADER_LENGTH | Illegal header length | Alarm | The system checks that the request includes a total HTTP header length that does not exceed the length specified in the security policy. | The actual size in default policy is 4 KB | 
|VIOL_HEADER_METACHAR | Illegal meta character in header | Alarm | The system checks that the values of all headers within the request only contain meta characters defined as allowed in the security policy. |  | 
|VIOL_HTTP_PROTOCOL | HTTP protocol compliance failed | Alarm | This category contains a list of validation checks that the system performs on HTTP requests to ensure that the requests are formatted properly. |  | 
|VIOL_HTTP_RESPONSE_STATUS | Illegal HTTP response status | Alarm | The server response contains an HTTP status code that is not defined as valid in the security policy. |  | 
|VIOL_JSON_FORMAT | JSON data does not comply with format settings | Alarm | The system checks that the request contains JSON content and complies with the various request limits within the defense configuration in the security policy's JSON profile. Enforces valid JSON requests and protects the server from JSON parser attacks. This violation is generated when a problem is detected in a JSON request, generally checking the message according to boundaries such as the message's size and meta characters in parameter value. | Controlled from the default JSON profile. | 
|VIOL_JSON_MALFORMED | Malformed JSON data | Alarm & Block | The system checks that the request contains JSON content that is well-formed. Enforces parsable JSON requests. |  | 
|VIOL_JSON_SCHEMA | JSON data does not comply with JSON schema | Alarm | The system checks that the incoming request contains JSON data that matches the schema file that is part of a JSON profile configured in the security policy. Enforces proper JSON requests defined by the schema. |  | 
|VIOL_MANDATORY_PARAMETER | Mandatory parameter is missing | Alarm | The system checks that parameter marked as mandatory exists in the request. |  | 
|VIOL_MANDATORY_REQUEST_BODY | Mandatory request body is missing | Alarm | The system checks that the body exists in the request |  | 
|VIOL_METHOD | Illegal method | Alarm | The system checks that the request references an HTTP request method that is found in the security policy. Enforces desired HTTP methods; GET and POST are always allowed. | These HTTP methods are supported:<br><ul><li>GET</li><li>HEAD</li><li>POST</li><li>PUT</li><li>PATCH</li><li>DELETE</li><li>OPTIONS</li></ul> | 
|VIOL_PARAMETER | Illegal parameter | Alarm | The system checks that every parameter in the request is defined in the security policy. |  | 
|VIOL_PARAMETER_ARRAY_VALUE | Illegal parameter array value | Alarm | The value of an item in an array parameter is not according to the defined data type. |  | 
|VIOL_PARAMETER_DATA_TYPE | Illegal parameter data type | Alarm | The system checks that the request contains a parameter whose data type matches the data type defined in the security policy. The data types that this violation applies to are integer, email, and phone. |  | 
|VIOL_PARAMETER_EMPTY_VALUE | Illegal empty parameter value | Alarm | The system checks that the request contains a parameter whose value is not empty when it must contain a value. |  | 
|VIOL_PARAMETER_LOCATION | Illegal parameter location | Alarm | The parameter was found in a different location than it was configured in the policy. |  | 
|VIOL_PARAMETER_MULTIPART_NULL_VALUE | Null in multi-part parameter value | Disabled | The system checks that the multi-part request has a parameter value that does not contain the NULL character (0x00). If a multipart parameter with binary content type contains NULL in its value, the Enforcer issues this violation. The exceptions to this are:<br><ul><li>If that parameter is configured in the policy as `Ignore value`.</li><li>If that parameter is configured in the security policy as `user-input file-upload`.</li><li>If the parameter has a content-type that contains the string 'XML' and the parameter value contains a valid UTF16 encoded XML document (the encoding is valid). In this case NULL is allowed as it is part of the UTF16 encoding.</li></ul> |  | 
|VIOL_PARAMETER_NAME_METACHAR | Illegal meta character in parameter name | Alarm | The system checks that all parameter names within the incoming request only contain meta characters defined as allowed in the security policy. |  | 
|VIOL_PARAMETER_NUMERIC_VALUE | Illegal parameter numeric value | Alarm | The system checks that the incoming request contains a parameter whose value is in the range of decimal or integer values defined in the security policy. |  | 
|VIOL_PARAMETER_REPEATED | Illegal repeated parameter name | Alarm | Detected multiple parameters of the same name in a single HTTP request. |  | 
|VIOL_PARAMETER_STATIC_VALUE | Illegal static parameter value | Alarm | The system checks that the request contains a static parameter whose value is defined in the security policy. Prevents static parameter change. NGINX App Protect WAF can be configured to block parameter values that are not in a predefined list. Parameters can be defined on each of the following levels: file type, URL, and flow. Each parameter can be one of the following types: explicit or wildcard. |  | 
|VIOL_PARAMETER_VALUE_BASE64 | Illegal Base64 value | Alarm | The system checks that the value is a valid Base64 string. If the value is indeed Base64, the system decodes this value and continues with its security checks. |  | 
|VIOL_PARAMETER_VALUE_LENGTH | Illegal parameter value length | Alarm | The system checks that the request contains a parameter whose value length (in bytes) matches the value length defined in the security policy. |  | 
|VIOL_PARAMETER_VALUE_METACHAR | Illegal meta character in value | Alarm | The system checks that all parameter values, XML element/attribute values, or JSON values within the request only contain meta characters defined as allowed in the security policy. Enforces proper input values. In case of a violation, the reported value represents the decimal ASCII value (metachar_index), or, in case of using "json_log" the hexadecimal ASCII value (metachar) of the violating character. |  | 
|VIOL_PARAMETER_VALUE_REGEXP | Parameter value does not comply with regular expression | Alarm | The system checks that the request contains an alphanumeric parameter value that matches the expected pattern specified by the regular-expression field for that parameter. Prevents HTTP requests which do not comply with a defined pattern. NGINX App Protect WAF lets you set up a regular expression to block requests where a parameter value does not match the regular expression. |  | 
|VIOL_POST_DATA_LENGTH | Illegal POST data length | Alarm | The system checks that the request contains POST data whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. This check is disabled by default. | 
|VIOL_QUERY_STRING_LENGTH | Illegal query string length | Alarm | The system checks that the request contains a query string whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. Actual size is 2 KB. | 
|VIOL_RATING_THREAT | Request is likely a threat | Alarm & Block | The combination of violations in this request determined that the request is likely to be a threat. | For VR = 4 or 5 | 
|VIOL_RATING_NEED_EXAMINATION | Request needs further examination | Disabled | The combination of violations could not determine whether the request is a threat or violations are false positives thus requiring more examination. | For VR = 3 | 
|VIOL_REQUEST_LENGTH | Illegal request length | Alarm | The system checks that the request length does not exceed the  acceptable length specified in the security policy per the requested file type. | In * file type entity. This check is disabled by default. | 
|VIOL_REQUEST_MAX_LENGTH | Request length exceeds defined buffer size | Alarm & Block| The system checks that the request length is not larger than the maximum memory buffer size. Note that this protects NGINX App Protect WAF from consuming too much memory across all security policies which are active on the device. | Default is 10MB | 
|VIOL_THREAT_CAMPAIGN | Threat Campaign detected | Alarm & Block | The system examines the HTTP message for known threat campaigns by matching it against known attack patterns. |  | 
|VIOL_URL | Illegal URL | Alarm | The system checks that the requested URL is configured as a valid URL, or not configured as an invalid URL, within the security policy. |  | 
|VIOL_URL_CONTENT_TYPE | Illegal request content type | Alarm | The URL in the security policy has a `Header-Based Content Profiles` setting that disallows the request because the specified HTTP header or the default is set to `disallow`. |  | 
|VIOL_URL_LENGTH | Illegal URL length | Alarm | The system checks that the request is for a URL whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. Actual size is 2 KB. | 
|VIOL_URL_METACHAR | Illegal meta character in URL | Alarm | The system checks that the incoming request includes a URL that contains only meta characters defined as allowed in the security policy. Enforces a desired set of acceptable characters. |  | 
|VIOL_XML_FORMAT | XML data does not comply with format settings | Alarm | The system checks that the request contains XML data that complies with the various document limits within the defense configuration in the security policy's XML profile. Enforces proper XML requests and the data failed format/defense settings such as the maximum document length.<br>       This violation is generated when a problem in an XML document is detected (for example, an XML bomb), generally checking the message according to boundaries such as the message's size, maximum depth, and maximum number of children. | Controlled by the default XML profile | 
|VIOL_XML_MALFORMED | Malformed XML data | Alarm & Block | The system checks that the request contains XML data that is well-formed, according to W3C standards. Enforces proper XML requests. |  | 
{{</bootstrap-table>}} 


### HTTP Compliance Sub-Violations

The following table specifies the HTTP Compliance sub-violation settings. All are supported in NGINX App Protect WAF, but not all are enabled in the default App Protect security template. The table specifies which. Some of the checks are enforced by NGINX Plus and App Protect only gets a notification. **Note:**  In this case, the request is **always** blocked regardless of the App Protect policy.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Sub-Violation | Default Template | Enforced by | Description | 
| ---| ---| ---| --- | 
|Unparsable request content | Enabled | NGINX | This violation is triggered when the system's parser cannot parse the message. | 
|Several Content-Length headers | Enabled | NGINX | More than one content-length header is a non RFC violation. Indicates an HTTP response splitting attack. | 
|POST request with Content-Length: 0 | Disabled | App Protect | POST request is usually sent with request body. This sub-violation is issued when a request has empty or no body at all. | 
|Null in request | Enabled | Null in header - NGINX, null in body - App Protect | The system issues a violation for requests with a NULL character anywhere in the request (except for a NULL in the binary part of a multipart request). | 
|No Host header in HTTP/1.1 request | Enabled | NGINX | Examines requests using HTTP/1.1 to see whether they contain a "Host" header. | 
|Multiple host headers | Enabled | NGINX | Examines requests to ensure that they contain only a single "Host" header. | 
|Host header contains IP address | Enabled | App Protect | The system verifies that the request's host header value is not an IP address to prevent non-standard requests. | 
|High ASCII characters in headers | Enabled | App Protect | Checks for high ASCII characters in headers (greater than 127). | 
|Header name with no header value | Disabled | App Protect | The system checks for a header name without a header value. | 
|CRLF characters before request start | N/A | NGINX | **Note:** NGINX strips any CRLF characters before the request method. The system **DOES NOT** issue a violation.| 
|Content length should be a positive number | Enabled | NGINX | The Content-Length header value should be greater than zero; only a numeric positive number value is accepted. | 
|Chunked request with Content-Length header | Enabled | App Protect | The system checks for a Content-Length header within chunked requests. | 
|Check maximum number of parameters | Enabled | App Protect | The system compares the number of parameters in the request to the maximum configured number of parameters. When enabled, the default value for number of maximum number of parameters is 500. | 
|Check maximum number of headers | Enabled | App Protect | The system compares the request headers to the maximal configured number of headers. | 
|Unescaped space in URL | Enabled | App Protect | The system checks that there is no unescaped space within the URL in the request line. Such spaces split URLs introducing ambiguity on picking the actual one. when enabled, the default value for number of unescaped space in URL is 50.| 
|Body in GET or HEAD requests | Disabled | App Protect | Examines GET and HEAD requests which have a body. | 
|Bad multipart/form-data request parsing | Enabled | App Protect | When the content type of a request header contains the substring "Multipart/form-data", the system checks whether each multipart request chunk contains the strings "Content-Disposition" and "Name". If they do not, the system issues a violation. | 
|Bad multipart parameters parsing | Enabled | App Protect | The system checks the following:<ol><li>A boundary follows immediately after request headers.</li><li>The parameter value matches the format: 'name="param_key";\\r\\n.</li><li>A chunked body contains at least one CRLF.</li><li>A chunked body ends with CRLF.</li><li>Final boundary was found on multipart request.</li><li>There is no payload after final boundary.</li></ol><br><br> If one of these is false, the system issues a violation. | 
|Bad HTTP version | Enabled | NGINX | Enforces legal HTTP version number (only 0.9 or higher allowed). | 
|Bad host header value | Enabled | NGINX | Detected non RFC compliant header value. | 
| Check maximum number of cookies | Enabled | App Protect | The system compares the request cookies to the maximal configured number of cookies. When enabled, the default value for number of maximum cookies if unmodified is 100. |
{{</bootstrap-table>}} 


### Evasion Techniques Sub-Violations

The following table specifies the Evasion Techniques sub-violation settings. All are supported in NGINX App Protect WAF.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Sub-Violation | Default Template | Description | 
| ---| ---| --- | 
|%u decoding | Enabled | Performs Microsoft %u unicode decoding (%UXXXX where X is a hexadecimal digit). For example, the system turns a%u002fb to a/b. The system performs this action on URI and parameter input to evaluate if the request contains an attack. | 
|Apache whitespace | Enabled | The system detects the following characters in the URI: 9 (0x09), 11 (0x0B), 12 (0x0C), and 13 (0x0D). | 
|Bad unescape | Enabled | The system detects illegal HEX encoding. Reports unescaping errors (such as %RR). | 
|Bare byte decoding | Enabled | The system detects higher ASCII bytes (greater than 127). | 
|Directory traversals | Enabled | Ensures that directory traversal commands like ../ are not part of the URL. While requests generated by a browser should not contain directory traversal instructions, sometimes requests generated by JavaScript have them. | 
|IIS backslashes | Enabled | Normalizes backslashes (\\) to slashes (/) for further processing. | 
|IIS Unicode codepoints | Enabled | Handles the mapping of IIS specific non-ASCII codepoints. Indicates that, when a character is greater than '0x00FF', the system decodes %u according to an ANSI Latin 1 (Windows 1252) code page mapping. For example, the system turns a%u2044b to a/b. The system performs this action on URI and parameter input. | 
|Multiple decoding | Enabled: 3 | The system decodes URI and parameter values multiple times according to the number specified before the request is considered an evasion. | 
{{</bootstrap-table>}} 


## Attack Types

Each signature, factory or user-defined, and violation has an **Attack Type**, the attack vector it protects from. When you create a user-defined signature you associate it with the most appropriate attack type from the list below. If you do not find an Attack Type that matches the threat for which your signature was written, use `Other Application Activity` Attack Type. Attach Types are also useful as part of the filter in user-defined signature **sets**. 

Following is the full list of Attack Types supported in App Protect. Use the **name** of the Attack Type to reference it within the signature or signature set filter.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Attack Type Name | Description | 
| ---| --- | 
|Abuse of Functionality | Abuse of Functionality is an attack technique that uses a web site's own features and functionality to consume, defraud, or circumvent access controls mechanisms. | 
|Authentication/Authorization Attacks | Authentication/Authorization Attacks occur when a web site permits an attacker to access sensitive content or functionality without having to properly authenticate, or authorize, that resource. | 
|Buffer Overflow | Buffer Overflow could be triggered when data written to memory exceeds the allocated size of the buffer for that data. This could lead to the Denial of Service or arbitrary code execution. | 
|Cache Poisoning | Cache poisoning is an attack against the integrity of an intermediate Web cache repository, in which genuine content cached for an arbitrary URL is replaced with spoofed content. | 
|Command Execution | Web applications can be tricked to execute operating system commands, injected from a remote machine, if user supplied input is not properly checked by the web application. | 
|Cross-site Request Forgery | An attacker exploits the web application's assumption and trust that the authenticated user is purposely sending requests to perform actions or commands, while in fact the attacker is causing the user to send the commands without the user's knowledge or consent. | 
|Cross Site Scripting (XSS) | Cross Site Scripting (XSS) occurs when a web application does not sanitize user-supplied input and places it directly into the page returned to the user. Usually, the attacker will submit malicious JavaScript, VBScript, ActiveX, HTML, or Flash code to the vulnerable web site. | 
|Denial of Service | A denial-of-service (DoS) attack represents a family of attacks aimed to exhaust the application server resources up to a point that the application cannot respond to legitimate traffic, either because it has crashed, or because its slow response renders it effectively unavailable. | 
|Detection Evasion | An attempt is made to evade detection of the attack on a web server, by obfuscating the attack using various methods such as encodings and path manipulation. | 
|Directory Indexing | This is a directory listing attempt which can lead to information disclosure and possible exposure of sensitive system information. Directory Indexing attacks usually target web servers that are not correctly configured, or which have a vulnerable component that allows Directory Indexing. | 
|Forceful Browsing | This attack occurs when an attacker is directly accessing a URL, which could grant access to a restricted part of the web site. |  
|HTTP Parser Attack | HTTP parser attack targets the functionality of the HTTP parser in order to crash it or force the parser to work abnormally. | 
|HTTP Request Smuggling Attack | Specially crafted HTTP messages can manipulate the web server or cache's standard behavior. This can lead to XSS, and cache poisoning. | 
|HTTP Response Splitting | Specially crafted HTTP messages can manipulate the web server or cache's standard behavior. This can lead to XSS, and cache poisoning. | 
|Information Leakage | Sensitive information may be present within HTML comments, error messages, source code, or simply left in files which are accessible by remote clients. In addition, attackers can manipulate the application to reveal classified information like credit card numbers. This can lead to the disclosure of sensitive system information which may be used by an attacker to further compromise the system. | 
|Insecure Deserialization | This is an attack against an application that receives serialized objects. An application which does not restrict which objects might be deserialized could be exploited by attackers sending specific object called 'gadgets', that could trigger arbitrary code execution when deserialized. | 
|Insecure File Upload | Many applications allow uploading files to the server, such as images or documents. An application that does not correctly restrict the type of the uploaded files or the upload folder path can be exploited by attackers to upload files, called 'WebShells', containing malicious code that later will be executed or override the server configuration. | 
|JSON Parser Attack | This attack targets the functionality of the JSON parser in order to crash it or force the parser to work abnormally. | 
|LDAP Injection | If user-supplied input is not correctly sanitized, the attacker could change the construction of LDAP statements. Successful exploitation results in information gathering, system integrity compromise, and possible modification of the LDAP tree. | 
|Malicious File Upload | Malicious file upload occurs when a user tries to upload a malicious file to the web application. This could allow remote attackers to cause Server Infection, Network Infection, Buffer Overflow and Remote Comma Execution. | 
|Non-browser Client | An attempt is made by a non-browser client to explore the site. | 
|Other Application Attacks | This is an attack which targets the web application and does not fall in any predefined category. | 
|Parameter Tampering | By changing certain parameters in a URL or web page form, attackers can successfully attack the web application business logic. | 
|Path Traversal | Path traversal can be used to bypass the web server root and request various files, including system files or private directories and resources. This attack can lead to information disclosure, and possible exposure of sensitive system information. | 
|Predictable Resource Location | By making educated guesses, the attacker could discover hidden web site content and functionality, such as configuration, temporary, backup, or sample files. This can lead to the disclosure of sensitive system information which may be used by an attacker to compromise the system. | 
|Remote File Include | Remote File Inclusion attacks allow attackers to run arbitrary code on a vulnerable website. | 
|Server Side Code Injection | An attacker can submit server-side code by invalidated input. The web server, when parsing malicious input, may execute operating system commands or access restricted files. | 
|Server-Side Request Forgery (SSRF) | Some applications receive a URL as input and use it to exchange data with another service. An attacker could provide special URLs to read or update internal resources such as localhost services, cloud metadata servers, internal network web applications or HTTP enabled databases. | 
|Server-Side Template Injection | Some applications use server-side templates for better modularity. This attack occurs when a non-sanitized input containing template directives is embedded into a server-side template which then leads to execution of the injected code when rendered. | 
|Session Hijacking | An attacker can steal a valid web session from legitimate users in order to gain unauthorized access. | 
|SQL-Injection | SQL-Injection occurs when a web application does not sanitize user-supplied input, and places it directly into the SQL statement. This attack allows remote attackers to run SQL statements on the internal database. | 
|Trojan/Backdoor/Spyware | This is an attack initiated by some form of malicious code. | 
|Vulnerability Scan | An attempt is made using an automatic tool to scan a web server, or an application running on a web server, for a possible vulnerability. | 
|XML External Entities (XXE) | This is a type of attack against an application that parses XML input. This attack occurs when XML input containing a reference to an external entity is processed by a weakly configured XML parser. | 
|XML Parser Attack | This attack targets the functionality of the XML parser in order to crash it or force the parser to work abnormally. | 
|XPath Injection | XPath-Injection occurs when a web application does not sanitize user-supplied input but places it directly into the XML document query. Successful exploitation results in information gathering and system integrity compromise. | 
{{</bootstrap-table>}} 


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

This tool can be deployed and used independently of the NGINX App Protect WAF deployment, by [installing the compiler package as a standalone]({{< relref "/nap-waf/admin-guide/install#converter-tool-docker-image" >}}), in order to generate a report about either the default signatures included in the package, or signatures included in a signature update package. The latter can be obtained by running the tool on a standalone compiler deployment, after installing a new signature update package on top of the compiler package. These reports can then be compared for greater clarity regarding signature updates.

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

Refer to [Logging Overview]({{< relref "/nap-waf/logging-overview/security-log.md" >}}) section for more details on Security Logs.

## NGINX App Protect WAF Terminology

This guide assumes that you have some familiarity with various Layer 7 (L7) Hypertext Transfer Protocol (HTTP) concepts, such as Uniform Resource Identifier (URI)/Uniform Resource Locator (URL), method, header, cookie, status code, request, response, and parameters.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}} 
|Term | Definition | 
| ---| --- | 
|Alarm | If selected, the NGINX App Protect WAF system records requests that trigger the violation in the remote log (depending on the settings of the logging profile). | 
|Attack signature | Textual patterns which can be applied to HTTP requests and/or responses by NGINX App Protect WAF to determine if traffic is malicious. For example, the string `<script>` inside an HTTP request triggers an attack signature violation. | 
|Attack signature set | A collection of attack signatures designed for a specific purpose (such as Apache). | 
|Bot signatures | Textual patterns which can be applied to an HTTP request's User Agent or URI by NGINX App Protect WAF to determine if traffic is coming from a browser or a bot (trusted, untrusted or malicious). For example, the string `googlebot` inside the User-Agent header will be classified as `trusted bot`, and the string `Bichoo Spider` will be classified as `malicious bot`. | 
|Block | To prevent a request from reaching a protected web application. If selected (and enforcement mode is set to Blocking), NGINX App Protect WAF blocks requests that trigger the violation. | 
|Blocking response page | A blocking response page is displayed to a client when a request from that client has been blocked. Also called blocking page and response page. | 
|Enforcement mode | Security policies can be in one of two enforcement modes:<ul><li>**Transparent mode** In Transparent mode, Blocking is disabled for the security policy. Traffic is not blocked even if a violation is triggered with block flag enabled. You can use this mode when you first put a security policy into effect to make sure that no false positives occur that would stop legitimate traffic.</li><li>**Blocking mode** In Blocking mode, Blocking is enabled for the security policy, and you can enable or disable the Block setting for individual violations. Traffic is blocked when a violation occurs if you configure the system to block that type of violation. You can use this mode when you are ready to enforce the security policy. You can change the enforcement mode for a security policy in the security policy JSON file.</li></ul> | 
|Entities | The elements of a security policy, such as HTTP methods, as well as file types, URLs, and/or parameters, which have attributes such as byte length. Also refers to elements of a security policy for which enforcement can be turned on or off, such as an attack signature. | 
|False positive | An instance when NGINX App Protect WAF treats a legitimate request as a violation. | 
|File types | Examples of file types are .php, .asp, .gif, and .txt. They are the extensions for many objects that make up a web application. File Types are one type of entity a NGINX App Protect WAF policy contains. | 
|Illegal request | A request which violates a security policy | 
|Legal request | A request which has not violated the security policy. | 
|Loosening | The process of adapting a security policy to allow specific entities such as File Types, URLs, and Parameters. The term also applies to attack signatures, which can be manually disabled — effectively removing the signature from triggering any violations. | 
|Parameters | Parameters consist of “name=value” pairs, such as OrderID=10. The parameters appear in the query string and/or POST data of an HTTP request. Consequently, they are of particular interest to NGINX App Protect WAF because they represent inputs to the web application. | 
|TPS/RPS | Transactions per second (TPS)/requests per second (RPS). In NGINX App Protect WAF, these terms are used interchangeably. | 
|Tuning | Making manual changes to an existing security policy to reduce false positives and increase the policy’s security level. | 
|URI/URL | The Uniform Resource Identifier (URI) specifies the name of a web object in a request. A Uniform Resource Locator (URL) specifies the location of an object on the Internet. For example, in the web address, `http://www.siterequest.com/index.html`, index.html is the URI, and the URL is `http://www.siterequest.com/index.html`. In NGINX App Protect WAF, the terms URI and URL are used interchangeably. | 
|Violation | Violations occur when some aspect of a request or response does not comply with the security policy. You can configure the blocking settings for any violation in a security policy. When a violation occurs, the system can Alarm or Block a request (blocking is only available when the enforcement mode is set to Blocking). | 
{{</bootstrap-table>}} 


## Interaction with NGINX Features

Below are examples of how to configure various NGINX features with NGINX App Protect WAF.

### Configure Static Location

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8080/proxy/$request_uri;
        }

        location /proxy {
            default_type text/html;
            return 200 "Hello! I got your URI request - $request_uri\n";
        }
    }
}
~~~

### Configure Ranges

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location / {
            proxy_pass http://1.2.3.4$request_uri;
            proxy_force_ranges on;
        }
    }
}
~~~

### Configure Slice

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen 127.0.0.1:8080;
        server_name localhost;

        location / {
            app_protect_enable on;
            proxy_pass http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen 127.0.0.1:8081;
        server_name localhost;

        location / {
            proxy_pass http://1.2.3.4$request_uri;
            slice 2;
            proxy_set_header Range $slice_range;
        }
    }
}
~~~

### Configure NGINX mirror

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    log_format test $uri;

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            mirror /mirror;
        }

        location /mirror {
            log_subrequest on;
            access_log test$args.log test;
        }
    }
}

~~~

### Configure NJS

~~~nginx
load_module modules/ngx_http_app_protect_module.so;
load_module modules/ngx_http_js_module.so;

http {
    js_include service.js

    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            app_protect_enable on;
            proxy_pass    http://127.0.0.1:8081$request_uri;
        }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location / {
            js_content foo;
        }
    }
}
~~~

### Configure Client Authorization

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen       127.0.0.1:8080;
        server_name  localhost;

        location / {
            auth_request /scan;
            proxy_pass http://localhost:8888;
        }
        location /scan {
            proxy_pass http://localhost:8081$request_uri;
       }
    }

    server {
        listen       127.0.0.1:8081;
        server_name  localhost;

        location /scan {
            app_protect_enable on;
            proxy_pass http://localhost:8888;
        }
    }
}
~~~


### Unsupported Configuration

There are some NGINX features that don't work well with NGINX App Protect WAF. Modules that use subrequest do not work when calling or being called from a scope that contains `app_protect_enable on`. Other modules that expect to receive the Range header (Slice for example) are also unsupported in the same scope as `app_protect_enable on`. For example, the following configuration is unsupported, but in the examples above you can find examples of work arounds for these features.

~~~nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen 127.0.0.1:8080;
        server_name localhost;

        location / {
            app_protect_enable on;
            proxy_pass http://1.2.3.4$request_uri;
            slice 2;
            proxy_set_header Range $slice_range;
        }
    }
}
~~~
