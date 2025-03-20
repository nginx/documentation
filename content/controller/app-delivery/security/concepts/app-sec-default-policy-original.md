---
description: Learn about the default protections provided by F5 NGINX Controller App
  Security.
docs: DOCS-479
title: Default WAF Policy
toc: true
weight: 200
type:
- concept
- reference
---

## Overview

You can use the F5 NGINX Controller App Security module to configure and manage a web application firewall (WAF). The App Security WAF protects your applications from HTTP and web-based threats, including the [OWASP Top 10](https://owasp.org/www-project-top-ten/).

NGINX Controller App Security provides out-of-the-box analytics events and metrics, which are reported through the NGINX Controller API and user interface. App Security works with [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect), running NGINX Plus as the WAF in the data path.

## Default Policy

The default policy for App Security WAF in NGINX Controller focuses on [OWASP Top 10](https://owasp.org/www-project-top-ten/) protection. This policy is the same default policy that is used by NGINX App Protect.

The default policy for NGINX Controller App Security WAF includes these security checks:

<style>table, th, td {  border: 1px solid #CCC;  border-collapse: collapse;}th, td {  padding: 5px;}th {  text-align: center;}</style>

<a name="security-checks"></a>

| **Security Checks** | **Description** |
|---------------------------|-----------------|
| HTTP RFC compliance enforcement | Validation of HTTP requests to prevent the use of the HTTP protocol as an entry point for malicious requests to applications. |
| URL normalization | Decoding of requests for encoded request that contain different types of encoded escapes |
| Evasion techniques | Protection for techniques commonly used by hackers to access resources or evade what would otherwise be identified as an attack. The checks performed are: <ul><li>Bad unescape (bad escaping)</li><li>Directory traversal</li><li>Bare byte decoding</li><li>Apache whitespace</li><li>Multiple % decoding</li><li>IIS Unicode codepoint</li><li>IIS backslashes</li><li>%u decoding</li></ul> |
| Malformed cookie | Validates that the cookie format is RFC compliant. |
| Illegal status code | Responses in the 400–500 range -- except for `400`, `401`, `404`, `407`, `417`, `503` -- are rejected. |
| Request size exceeds the buffer | Requests that exceed the buffer size |
| Maximum length for URL, header, query string, cookie, and POST data | URL length: 2048<br>Header length: 4096<br>Query string length: 2048<br>Cookie length: 4096<br>Post data length: 4096<br><br>{{< note >}} The whole request length is not checked. The entire request cannot exceed the maximum buffer size of 10 MB.{{< /note >}} |
| Disallowed file type extension | These file types are disallowed: <ul><li>bak, bat, bck, bkp, cfg, conf, config, ini, log, old, sav, save, temp, tmp</li><li>bin, cgi, cmd, com, dll, exe, msi, sys, shtm, shtml, stm</li><li>cer, crt, der, key, p12, p7b, p7c, pem, pfx</li><li>dat, eml, hta, htr, htw, ida, idc, idq, nws, pol, printer, reg, wmz</li></ul> |
| Allowed methods | Only these HTTP methods are allowed:<ul><li>GET</li><li>HEAD</li><li>POST</li><li>PUT</li><li>PATCH</li><li>DELETE</li><li>OPTIONS</li></ul> |
| Character/Metacharacter validation in URL and header | Metacharacters are checked in the URL and header. |
| Parameter parsing | NGINX Controller App Security auto-detects the payload type for JSON and XML. App Security then applies the signature that matches the correct format.|
| JSON format | If the content is JSON, then App Security checks that the JSON payload body is well-formed. The max structure depth and max array length may not exceed 25. The max structure depth and max array length may not exceed 25.<br><br>No JSON schema enforcement. |
| DTD XML format | If the content is XML, then App Security checks that an XML payload body is well-formed.<br><br>No XML schema enforcement. No SOAP and Web Services Security format enforcement. |

## Attack Types Used In Default Policy

The following signature attack types are included with the default NGINX Controller App Security WAF policy. These attack types protect against [OWASP Top 10](https://owasp.org/www-project-top-ten/) vulnerabilities and [CVEs](https://cve.mitre.org/). Low, medium, and high accuracy signatures generate events as part of assessing the [Violation Rating](#use-of-violation-ratings-in-default-policy).

- Command Execution Signatures
- Cross-Site Scripting Signatures
- Directory Indexing Signatures
- Information Leakage Signatures
- OS Command Injection Signatures
- Path Traversal Signatures
- Predictable Resource Location Signatures
- Remote File Include Signatures
- SQL Injection Signatures
- Authentication/Authorization Attacks Signatures
- XML External Entity (XXE) Signatures
- XPath Injection Signatures
- Buffer Overflow Signatures
- Denial of Service Signatures
- Vulnerability Scanner Signatures

## Use of Violation Ratings in Default Policy

The default policy for App Security assesses violations and provides a Violation Rating. This rating is an NGINX App Protect computed assessment of the risk of the request and its likelihood of an attack based on the triggered violations.

NGINX App Protect violations are rated to distinguish between attacks and potential false-positive alerts. A rating is assigned to requests based on the presence of one or more violations. Each violation type and severity contribute to the calculation of the Violation Rating assigned to a request.

The possible Violation Ratings are:

- 0: No violation (no event available)
- 1: Possible False Positive (no event available)
- 2: Most Likely False positive (no event available)
- 3: Needs examination
- 4: Possible Attack
- 5: Most Likely Attack

The Violation Rating is a dimension in Security Violation Events. NGINX App Protect rejects requests that have a Violation Rating of `4 (Possible Attack)` or `5 (Most Likely an Attack)`. However, the following violations and signature sets have a low chance of being false positives and are, therefore, configured by default to reject the request regardless of its Violation Rating:

- High accuracy attack signatures
- Threat campaigns
- Malformed request: unparsable header, malformed cookie, and malformed body (JSON or XML).

{{< note >}}

With the default policy, all requests rejected by NGINX App Protect generate a Security Event in NGINX Controller. Requests with Violation Rating of `3 (Needs examination)` also generate a Security Event in NGINX Controller. All other requests do not generate a Security Event in NGINX Controller.

{{< /note >}}

## Additional Information

### HTTP RFC Compliance Already Rejected By NGINX

Note the following events are blocked by NGINX Plus and not by the NGINX Controller App Security policy. These events are not reported in NGINX Controller as security violation events.

| **HTTP RFC Compliance Checks** | **Description** |
|--------------------------------|-----------------|
| Unparsable request content | This violation is triggered when the system's parser cannot parse the message. |
| Several Content-Length headers | More than one content-length header is a non-RFC violation. Indicates an HTTP response splitting attack. |
| NULL in header | The system issues a violation for requests with a NULL character in the header. |
| No Host header in HTTP/1.1 request | Check to see if HTTP/1/1 requests contain a "Host" header. |
| High ASCII characters in headers| Check for high ASCII characters (greater than 127) in headers. |
| Content length should be a positive number | The Content-Length header value should be greater than zero; only a numeric positive number value is accepted. |
| Bad HTTP version | Enforces legal HTTP version number (only 0.9 or higher allowed). |

{{< versions "3.12" "latest" "ctrlvers" >}}
