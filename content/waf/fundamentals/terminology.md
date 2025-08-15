---
# We use sentence case and present imperative tone
title: "Terminology"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page defines terminology used when describing functionality of F5 WAF for NGINX.

It assumes you are familiar with various layer 7 (L7) hypertext transfer protocl (HTTP) concepts such as:

- Uniform Resource Identifier (URI)
- Uniform Resource Location (URL)
- HTTP methods and status codes
- HTTP headings, requests, responses, and parameters
- Cookies

## Terms and definitions

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
|Parameters | Parameters consist of "name=value" pairs, such as OrderID=10. The parameters appear in the query string and/or POST data of an HTTP request. Consequently, they are of particular interest to NGINX App Protect WAF because they represent inputs to the web application. |
|TPS/RPS | Transactions per second (TPS)/requests per second (RPS). In NGINX App Protect WAF, these terms are used interchangeably. |
|Tuning | Making manual changes to an existing security policy to reduce false positives and increase the policy’s security level. |
|URI/URL | The Uniform Resource Identifier (URI) specifies the name of a web object in a request. A Uniform Resource Locator (URL) specifies the location of an object on the Internet. For example, in the web address, `http://www.siterequest.com/index.html`, index.html is the URI, and the URL is `http://www.siterequest.com/index.html`. In NGINX App Protect WAF, the terms URI and URL are used interchangeably. |
|Violation | Violations occur when some aspect of a request or response does not comply with the security policy. You can configure the blocking settings for any violation in a security policy. When a violation occurs, the system can Alarm or Block a request (blocking is only available when the enforcement mode is set to Blocking). |