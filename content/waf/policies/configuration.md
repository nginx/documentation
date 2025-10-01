---
# We use sentence case and present imperative tone
title: "Configure policies"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes the security features available with F5 WAF for NGINX and how to configure policies. 

To convert policies from an existing F5 WAF solution, read the [Build and use the converter tools]({{< ref "/waf/configure/converters.md" >}}).

The [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}) topic explains how to transform policy files into a format parseable by F5 WAF for NGINX.

## Supported security policy features

{{< include "waf/table-policy-features.md" >}}

## Additional policy features

{{< table >}}

| Feature        | Description |
| -------------- | ----------- |
| Blocking pages | The user can customize all blocking pages. By default the AJAX response pages are disabled, but the user can enable them. |
| Enforcement by violation rating | By default block requests that are declared as threats, which are rated 4 or 5. It is possible to change this behavior: either disable enforcement by Violation Rating or block also request with Violation Rating 3 - needs examination. |
| Large request blocking | To increase the protection of resources at both the NGINX Plus and upstream application tiers, all requests that are larger than 10 MB in size are blocked.  When these requests are blocked, a `VIOL_REQUEST_MAX_LENGTH` violation will be logged.|
| Malformed cookie | Requests with cookies that are not RFC compliant are blocked by default. This can be disabled. |
| Parameter parsing | Support only auto-detect parameter value type and acts according to the result: plain alphanumeric string, XML or JSON. |
| Request size checks | Upper limit of request size as dictated by the maximum buffer size of 10 MB;  Size checks for: URL, header, Query String, whole request (when smaller than the maximum buffer), cookie, POST data. By default all the checks are enabled with the exception of POST data and whole request. The user can enable or disable every check and customize the size limits. |
| Status code restriction | Illegal status code in the range of 4xx and 5xx. By default only these are allowed: 400, 401, 404, 407, 417, 503. The user can modify this list or disable the check altogether. |
| Sensitive parameters | The default policy masks the “password” parameter in the security log, and can be customized for more |

{{< / table >}}

## General configuration

F5 WAF for NGINX ships with two reference policies, both with a default enforcement mode set to Blocking:

- The **default** policy which is identical to the base template and provides OWASP Top 10 and Bot security protection out of the box.
- The **strict** policy contains more restrictive criteria for blocking traffic than the default policy. It is meant to be used for protecting sensitive applications that require more security but with higher risk of false positives.

You can use these policies as-is, but they are often the starting points for customizations according to the needs of the applications F5 WAF NGINX protects.

### Configuration overview

The F5 WAF for NGINX security policy configuration uses a declarative format based on a pre-defined base template. 

The policy is represented in a JSON file which you can edit to add, modify and remove security capabilities in reference to the base template. 

The way the policy is integrated into the NGINX configuration is through referencing the JSON file (Using the full path) in the `nginx.conf` file.

{{< call-out "note" >}}

F5 WAF for NGINX provides a [JSON Schema](https://json-schema.org/) which can be used to validate a JSON policy file for format compliance. 

The schema file can be generated using a script once F5 WAF for NGINX is installed: `sudo /opt/app_protect/bin/generate_json_schema.pl`. 

This script will output the schema to a file named `policy.json` into the current working directory. Once the schema file is generated, you can use validation tools such as [AJV](https://ajv.js.org/standalone.html) to validate a JSON policy file.

This schema is used for the [Policy parameter reference]({{< ref "/waf/policies/parameter-reference.md" >}}).

{{< /call-out >}}

In the following example, the NGINX configuration file with F5 WAF for NGINX is enabled in the HTTP context and the policy _/etc/app_protect/conf/NginxDefaultPolicy.json_ is used:

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

    app_protect_enable on; # This is how you enable F5 WAF for NGINX in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/NginxDefaultPolicy.json"; # This refers to which policy file to use, which falls back to the default policy
    app_protect_security_log_enable on; # This section enables logging
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

### Base template

The base template is the common starting point for any policy you write.

The default policy reflects the base template without any further modifications, so the terms _base template_ and _default policy_ are used interchangeably. 

The default policy appears as follows:

```json
{
    "policy" : {
        "name": "app_protect_default_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" }
    }
}
```

The default policy enforces violations by **Violation Rating**, the F5 WAF for NGINX computed assessment of the risk of the request based on the triggered violations.

- 0: No violation
- 1-2: False positive
- 3: Needs examination
- 4-5: Threat

The default policy enables most of the violations and signature sets with Alarm turned **ON**, but not **Block**. 

These violations and signatures, when detected in a request, affect the violation rating. By default, if the violation rating is calculated to be malicious (4-5) the request will be blocked by the `VIOL_RATING_THREAT` violation. 

This is true even if the other violations and signatures detected in that request have the Block flag turned OFF. It is the `VIOL_RATING_THREAT` violation having the Block flag turned ON that caused the blocking, but indirectly the combination of all the other violations and signatures in Alarm caused the request to be blocked. 

By default, other requests which have a lower violation rating are not blocked, except for some specific violations described below. This is to minimize false positives. However, you can change the default behavior. 

For example, if you want to add blocking on a violation rating of 3 as well, enable blocking for the `VIOL_RATING_NEED_EXAMINATION` violation.

The following violations and signature sets have a low chance of being false positives and are, therefore, configured by default to block the request regardless of its Violation Rating:
- High accuracy attack signatures
- Threat campaigns
- Malformed request: unparsable header, malformed cookie and malformed body (JSON or XML).

### Default policy

F5 WAF for NGINX offers prebuilt bundles for security policies:

- _app_protect_default_policy_
- _app_protect_strict_policy_

{{< call-out "important" >}}

You cannot mix these prebuilt bundles with custom policy bundles within the same `nginx.conf` file.

{{< /call-out >}}

Example:

```nginx
    ...
    location / {

        # F5 WAF for NGINX
        app_protect_enable on;
        app_protect_policy_file app_protect_strict_policy;
        app_protect_security_log_enable on;
        app_protect_security_log log_all stderr;

        proxy_pass http://127.0.0.1:8080/;
    }
```

#### Updating default policy bundles

{{< call-out "note" >}}

This section assumes that you have built a [compiler image]({{< ref "/waf/configure/compiler.md" >}}) named `waf-compiler-1.0.0:custom`.

{{< /call-out >}}

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

### Strict policy

The strict policy is recommended as a starting point for applications requiring a higher level of security. 

Similar to policies, it is customized from the base template, so it detects and blocks everything the default policy does.

To obtain the strict policy, execute the following command:

```shell
sudo docker run --rm -v $(pwd):$(pwd) --entrypoint='' private-registry.nginx.com/nap/waf-compiler:1.0.0 cat /etc/app_protect/conf/NginxStrictPolicy.json
```

Replace the `1.0.0` with the actual release version.

In addition the strict policy also **blocks** the following:

- Requests that have a Violation Rating of 3, "Needs examination". This occurs because the `VIOL_RATING_NEED_EXAMINATION` violation's block flag is enabled in the strict policy.
- Requests with the `VIOL_EVASION` violation (evasion techniques).
- Requests with violations that restrict options in the request and response: HTTP method, response status code and disallowed file types.

{{< call-out "note" >}} 

Other violations, specifically attack signatures and metacharacters, which are more prone to false positives, still have only Alarm turned on, without blocking, contributing to the Violation Rating as in the Default policy.

{{< /call-out >}}

In addition, the Strict policy also enables the following features in **alarm only** mode:

- **Data Guard**: masking Credit Card Number (CCN), US Social Security Number (SSN) and custom patterns found in HTTP responses.
- **HTTP response data leakage signatures**: preventing exfiltration of sensitive information from the servers.
- **More restrictive limitations**: mainly sizing and parsing of JSON and XML payloads.
- **Cookie attribute insertion**: the Strict policy adds the **Secure** and **SameSite=lax** attributes to every cookie set by the application server. These attributes are enforced by the browsers and protect against session hijacking and CSRF attacks respectively.

## Policy authoring and tuning

The policy JSON file specifies the settings that are different from the base template, such as enabling more signatures, disabling some violations, adding server technologies, etc. These will be shown in the next sections.

There are two ways to tune those settings:
- Within the `policy` structure property, the organic structure of the policy.
- Within the `modifications` structure property that contains a list of changes expressed in a generic manner.

Both options are equivalent in their semantic expression power, but different syntactically and are designated for different use cases. But before that, let's look at an example - disabling a specific attack signature.

Signature 200001834 disabled in the `policy` property:

```json
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
```

As you can see, this is expressed using the `signatures` property that contains configuration of individual signatures in a policy. If you want to modify other parts of the policy, you would use different JSON properties.

The same configuration in the `modifications` array looks like this:

```json
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
```

Note the generic schema that can express manipulation in any policy element: `entity`, `entityType`, `action` etc. The `modifications` array is a flat list of individual changes applied to the policy after evaluating the `policy` block.

So when to use `policy` and when to use `modifications`? There are some recommended practice guidelines for that:
- Use `policy` to express the security policy as you intended it to be: the features you want to enable, disable, the signature sets, server technologies and other related configuration attributes. This part of the policy is usually determined when the application is deployed and changes at a relatively slow pace.
- Use `modifications` to express **exceptions** to the intended policy. These exceptions are usually the result of fixing false positive incidents and failures in tests applied to those policies. Usually these are granular modifications, typically disabling checks of individual signatures, metacharacters and sub-violations. These changes are more frequent.
- Use `modifications` also for **removing** individual collection elements from the base template, for example disallowed file types.

It is a good practice to separate the `modifications` to a different file and have the main policy file reference the former, as the two parts have different lifecycles.

The sections just below review the common policy feature configurations using examples. For the full reference of the `policy` JSON properties see the Declarative Policy guide.

### Policy enforcement modes

A policy's enforcement mode can be:

- **Blocking:** Any illegal or suspicious requests are logged and blocked.  This is the default enforcement mode for the default policy and any added policy unless changed to Transparent.
- **Transparent:** Any illegal or suspicious requests are logged but not blocked.

Individual security features can be defined as blocked or transparent in the policy. Here are examples of both:

{{< tabs name="enforcement-modes">}}

{{% tab name="Blocking" %}}

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    }
}
```

{{% /tab %}}

{{% tab name="Transparent" %}}

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "transparent"
    }
}
```

{{% /tab %}}

{{< /tabs >}}

### Enabling violations

Adding and enabling additional security features to the policy can be done by specifying the violation name and the `alarm` block state to `true`.

To set different states for sub-violations within the violation, enable the violation first, then specifying and configure the sub-violations.

A violation may have its own section that provides additional configuration granularity for a specific violation/sub-violation.

{{< call-out "note" >}}

The attack signature violation `VIOL_ATTACK_SIGNATURE` cannot be configured.

It is determined by the combination of the [signature sets]({{< ref "/waf/policies/attack-signatures.md#signature-sets ">}}) on the policy.

{{< /call-out >}}

In this example, we enable a violation and a sub-violation: `VIOL_JSON_FORMAT` and `VIOL_PARAMETER_VALUE_METACHAR`.

The example defines the blocking and alarm setting for each violation.  These settings override the default configuration set above in the `enforcementMode` directive.

Be aware, however, that in a transparent policy no violations are blocked, even if specific violations are set to `block: true` in the configuration.

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
```