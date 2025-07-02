---
description: Learn about the F5 NGINX Controller Application Security metrics and
  events.
nd-docs: DOCS-480
title: App Security Metrics
toc: true
weight: 400
type:
- reference
---

## Overview

This topic provides reference information for the metrics and events that F5 NGINX Controller reports for Application Security.

## Security Metrics and Event Dimensions

The following table shows the attributes and dimensions you can view and filter by for WAF violation events.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Attribute** | **Possible Values** | **Description and Additional Information** |
|-------------|-----------|------|
| category | security violation | |
| timestamp | Timestamp of the request | UTC |
| message | | Provides summary info about if a request was rejected or flagged, from what source, and due to what attack types.|
| level | `DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL` | Security violation events are only `INFO` for now|
| hostname | |Hostname used in the request|
| environment | | |
| app | | |
| component | | |
| gateway | | |
| corelationId | | |
| http.request_endpoint | | Request URI |
| http.request_method | | Method used for the request|
| request_outcome |`REJECTED`, `PASSED`| The outcome of the request after Controller App Security processed the request.|
| request_outcome_reason | `SECURITY_WAF_OK`, `SECURITY_WAF_VIOLATION`, `SECURITY_WAF_FLAGGED`, `SECURITY_WAF_BYPASS`, `SECURITY_NGINX_VIOLATION`, `SECURITY_WAF_FLAGGED` | request_outcome_reason provides the reason why App Security rejected or flagged a request to be reviewed. Outcome reasons for `SECURITY_WAF_BYPASSED` and `SECURITY_NGINX_VIOLATION` have not been implemented.<br />{{< note >}} App Security Events are not created for requests that don't trigger any violations. This means you should not see Events with `outcome_reason = SECURITY_WAF_OK`.{{< /note >}}|
| http.response_code | | Response code returned to App Security. A `0` code is returned if App Security did not block the request.|
| http.hostname | | Hostname of request|
| http.remote_addr | | Client IP of the request|
| http.remote_port | | Port of the client initiating the request|
| http.server_addr | | Server IP address that NGINX is listening on|
| http.server_port | | Server IP port that NGINX is listening on|
| waf.http_request | | Request including header, body, etc.|
| waf.support_id | | ID seen on the App Security rejection page|
| waf.signature_ids | | ID list of signatures triggered with the request. It usually does not go above three signature IDs.|
| waf.signature_names | | Names of signatures triggered with the request. It usually does not go above three signature names.|
|waf.attack_types | | Attack types triggered by the request.  It can be based on any of the above signature or other protection mechanisms used in the WAF policy. It usually does not go above three attack types.|
| violations ||Comma-separated list of logical violation names|
| sub_violation ||More specific violations within ‘HTTP protocol compliance failed’ (violation = `VIOL_HTTP_PROTOCOL`) and/or ‘Evasion technique detected’ violations (violation = `VIOL_EVASION`) |
| sig_cves||Signature CVEs value of the matched signatures.|
| is_truncated||A flag that returns true if a request is truncated in the security events, or false if it is not. |
| x_forwarded_for_header_value||X-Forwarded-For header information. This option is commonly used when proxies are involved to track the originator of the request.|

{{< /bootstrap-table >}}

### Attack Types and Description

Each signature and violation has an Attack Type which is the attack vector WAF protects from. The list of Attack Types and descriptions are listed here. You may see these attack types and violations in Security Events and Metrics.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Attack Type** | **Description** |
|-----------------|-----------------|
| Server-Side Template Injection | Some applications use server-side templates for better modularity. This attack occurs when a non-sanitized input containing template directives is embedded into a server-side template which then leads to the execution of the injected code when rendered. |
|Insecure File Upload | Many applications allow uploading files to the server, such as images or documents. An application that does not correctly restrict the type of the uploaded files or the upload folder path can be exploited by attackers to upload files, called ‘WebShells’, containing malicious code that later will be executed or override the server configuration.|
|NoSQL Injection|NoSQL databases are non-relational databases, and even though they do not use the SQL syntax, non-sanitized input might let attackers control the original query via a database-specific programming language.|
|Insecure Deserialization | This is an attack against an application that receives serialized objects. An application which does not restrict which objects might be deserialized could be exploited by attackers sending specific object called ‘gadgets’, that could trigger arbitrary code execution when deserialized.|
|XML External Entities (XXE)| This is a type of attack against an application that parses XML input. This attack occurs when XML input containing a reference to an external entity is processed by a weakly configured XML parser.|
|Server-Side Request Forgery (SSRF) | Some applications receive a URL as an input and use it to exchange data with another service. An attacker could provide special URLs to read or update internal resources such as localhost services, cloud metadata servers, internal network web applications or HTTP enabled databases.|
|Cache Poisoning| Cache poisoning is an attack against the integrity of an intermediate Web cache repository, in which genuine content cached for an arbitrary URL is replaced with spoofed content.|
|WebSocket Parser Attack | WebSocket parser attack targets the functionality of the WebSocket parser to crash it or force the parser to work abnormally.|
|GWT Parser Attack | This attack targets the functionality of the GWT parser to crash it or force the parser to work abnormally.|
|Cross-site Request Forgery | An attacker exploits the web application’s assumption and trust that the authenticated user is purposely sending requests to perform actions or commands, while the attacker is causing the user to send the commands without the user’s knowledge or consent.|
|JSON Parser Attack |This attack targets the functionality of the JSON parser to crash it or force the parser to work abnormally.|
|Malicious File Upload|Malicious file upload occurs when a user tries to upload a malicious file to the web application. This could allow remote attackers to cause Server Infection, Network Infection, Buffer Overflow, and Remote Comma Execution.|
|HTTP Response Splitting|Specially crafted HTTP messages can manipulate the webserver or cache’s standard behavior. This can lead to XSS, and cache poisoning.|
|Session Hijacking|An attacker can steal a valid web session from legitimate users to gain unauthorized access.|
|XML Parser Attack|This attack targets the functionality of the XML parser to crash it or force the parser to work abnormally.|
|Parameter Tampering|By changing certain parameters in a URL or web page form, attackers can successfully attack the web application business logic.|
|Injection Attempt|This is an attack where an attacker injects OS commands, active script commands (in JavaScript or any other scripting language), or SQL commands into various parts of an HTTP request, for the injected content to run on remote systems. The two most common injection attacks are SQL injection and Cross-Site Scripting.|
|Brute Force Attack|Brute-force attacks are mainly used for guessing passwords and bypassing access control of an application by executing many different attempts.|
|Forceful Browsing|This attack occurs when an attacker is directly accessing a URL, which could grant access to a restricted part of the web site.|
|HTTP Request Smuggling Attack|Specially crafted HTTP messages can manipulate the webserver or cache’s standard behavior. This can lead to XSS, and cache poisoning.|
|HTTP Parser Attack|HTTP parser attack targets the functionality of the HTTP parser to crash it or force the parser to work abnormally.|
|Other Application Activity|This attack does not belong to any specific attack category, however, it is a violation of the user-defined security policy.|
|Denial of Service|A denial-of-service (DoS) attack represents a family of attacks aimed to exhaust the application server resources up to a point that the application cannot respond to legitimate traffic, either because it has crashed, or because its slow response renders it effectively unavailable.|
|Cross-Site Scripting (XSS)|Cross-Site Scripting (XSS) occurs when a web application does not sanitize user-supplied input and places it directly into the page returned to the user. Usually, the attacker will submit malicious JavaScript, VBScript, ActiveX, HTML, or Flash code to the vulnerable website.|
|SQL-Injection|SQL-Injection occurs when a web application does not sanitize user-supplied input and places it directly into the SQL statement. This attack allows remote attackers to run SQL statements on the internal database.|
|Command Execution|Web applications can be tricked to execute operating system commands, injected from a remote machine if user-supplied input is not properly checked by the web application.|
|Server Side Code Injection|An attacker can submit server-side code by invalidated input. The webserver, when parsing malicious input, may execute operating system commands or access restricted files.|
|LDAP Injection|If user-supplied input is not correctly sanitized, the attacker could change the construction of LDAP statements. Successful exploitation results in information gathering, system integrity compromise, and possible modification of the LDAP tree.|
|XPath Injection|XPath-Injection occurs when a web application does not sanitize user-supplied input but places it directly into the XML document query. Successful exploitation results in information gathering and system integrity compromise.|
|Path Traversal|Path traversal can be used to bypass the webserver root and request various files, including system files or private directories and resources. This attack can lead to information disclosure and possible exposure of sensitive system information.|
|Directory Indexing|This is a directory listing attempt which can lead to information disclosure and possible exposure of sensitive system information. Directory Indexing attacks usually target webservers that are not correctly configured, or which have a vulnerable component that allows Directory Indexing.|
|Information Leakage|Sensitive information may be present within HTML comments, error messages, source code, or simply left in files that are accessible by remote clients. Besides, attackers can manipulate the application to reveal classified information like credit card numbers. This can lead to the disclosure of sensitive system information which may be used by an attacker to further compromise the system.|
|Predictable Resource Location|By making educated guesses, the attacker could discover hidden web site content and functionality, such as configuration, temporary, backup, or sample files. This can lead to the disclosure of sensitive system information which may be used by an attacker to compromise the system.|
|Buffer Overflow|Buffer Overflow could be triggered when data written to memory exceeds the allocated size of the buffer for that data. This could lead to the Denial of Service or arbitrary code execution.|
|Authentication/Authorization Attacks|Authentication/Authorization Attacks occur when a web site permits an attacker to access sensitive content or functionality without having to properly authenticate, or authorize, that resource.|
|Abuse of Functionality|Abuse of Functionality is an attack technique that uses a website’s features and functionality to consume, defraud, or circumvent access control mechanisms.|
|Vulnerability Scan|An attempt is made using an automatic tool to scan a webserver, or an application running on a webserver, for a possible vulnerability.|
|Detection Evasion|An attempt is made to evade detection of the attack on a webserver, by obfuscating the attack using various methods such as encodings and path manipulation.|
|Trojan/Backdoor/Spyware|This is an attack initiated by some form of malicious code.|
|Other Application Attacks|This is an attack which targets the web application and does not fall in any predefined category|
|Non-browser Client|An attempt is made by a non-browser client to explore the site.|
|Remote File Include|Remote File Inclusion attacks allow attackers to run arbitrary code on a vulnerable website.|

{{< /bootstrap-table >}}

### Violations and Descriptions

Each violation consists of one or more security checks (for example, attack signatures, HTTP RFC compliance, and evasion techniques).  Each security check could be a specific attack signature, a specific HTTP Compliance check, or a specific evasion technique that is triggered within WAF.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Violation Value** | **Name** | **Description** |
|-----------------|-----------------|--------------------|
|`VIOL_ASM_COOKIE_MODIFIED` | Modified ASM cookie |The system checks that the request contains an ASM cookie that has not been modified or tampered with. Blocks modified requests.|
|`VIOL_ATTACK_SIGNATURE`|Attack signature detected|The system examines the HTTP message for known attacks by matching it against known attack patterns. See signature_ids and signature_names attributes for specific signatures matched.|
|`VIOL_COOKIE_EXPIRED`|Expired timestamp|The system checks that the timestamp in the HTTP cookie is not old. An old timestamp indicates that a client session has expired. Blocks expired requests. The timestamp is extracted and validated against the current time. If the timestamp is expired and it is not an entry point, the system issues the Expired Timestamp violation.|
|`VIOL_COOKIE_LENGTH`|Illegal cookie length|The system checks that the request does not include a cookie header that exceeds the acceptable length specified in the security policy.|
|`VIOL_COOKIE_MALFORMED`|Cookie not RFC-compliant|This violation occurs when HTTP cookies contain at least one of the following components:<ul><li>Quotation marks in the cookie name</li><li>A space in the cookie name.</li><li>An equal sign (=) in the cookie name. Note: A space between the cookie name and the equal sign (=), and between the equal sign (=) and cookie value is allowed.</li><li>An equal sign (=) before the cookie name.</li><li>A carriage return (hexadecimal value of 0xd) in the cookie name.</li>|
|`VIOL_ENCODING`|Failed to convert character|The system detects that one of the characters does not comply with the configured language encoding of the web application’s security policy.|
|`VIOL_EVASION`|Evasion technique detected|This category contains a list of evasion techniques that attackers use to bypass detection.|
|`VIOL_FILETYPE`|Illegal file type|The system checks that the requested file type is configured as a valid file type, or not configured as an invalid file type, within the security policy. Only for disallowed file types.|
|`VIOL_HEADER_LENGTH`|Illegal header length|The system checks that the request includes a total HTTP header length that does not exceed the length specified in the security policy. The actual size in the default policy is 4 KB.|
|`VIOL_HEADER_METACHAR`|Illegal meta character in header|The system checks that the values of all headers within the request only contain meta characters defined as allowed in the security policy.|
|`VIOL_HTTP_PROTOCOL`|HTTP protocol compliance failed|This category contains a list of validation checks that the system performs on HTTP requests to ensure that the requests are formatted properly.|
|`VIOL_HTTP_RESPONSE_STATUS`|Illegal HTTP response status|The server response contains an HTTP status code that is not defined as valid in the security policy.|
|`VIOL_JSON_MALFORMED`|Malformed JSON data|The system checks that the request contains JSON content that is well-formed. Enforces parsable JSON requests.|
|`VIOL_METHOD`|Illegal method|The system checks that the request references an HTTP request method that is found in the security policy. Enforces desired HTTP methods; GET and POST are always allowed. These HTTP methods are supported: GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS.|
|`VIOL_QUERY_STRING_LENGTH`|Illegal query string length|The system checks that the request contains a query string whose length does not exceed the acceptable length specified in the security policy. In * file type entity. The actual size is 2 KB.|
|`VIOL_REQUEST_MAX_LENGTH`|Request length exceeds defined buffer size|The system checks that the request length is not larger than the maximum memory buffer size of the ASM. Note that this is a BIG-IP unit parameter that protects the ASM from consuming too much memory across all security policies which are active on the device. Default is 10MB.|
|`VIOL_URL_LENGTH`|Illegal URL length|The system checks that the request is for a URL whose length does not exceed the acceptable length specified in the security policy.  In * file type entity. The actual size is 2 KB.|
|`VIOL_URL_METACHAR`|Illegal meta character in URL|The system checks that the incoming request includes a URL that contains only meta characters defined as allowed in the security policy. Enforces the desired set of acceptable characters.|
|`VIOL_XML_FORMAT`|XML data does not comply with format settings|The system checks that the request contains XML data that complies with the various document limits within the defense configuration in the security policy’s XML profile. Enforces proper XML requests and the data failed format/defense settings such as the maximum document length. This violation is generated when a problem in an XML document is detected (for example, an XML bomb), generally checking the message according to boundaries such as the message’s size, maximum depth, and the maximum number of children.|
|`VIOL_XML_MALFORMED`|Malformed XML data|The system checks that the request contains XML data that is well-formed, according to W3C standards. Enforces proper XML requests.|
|`VIOL_RATING_THREAT`|Request is likely a threat|The combination of violations in this request determined that the request is likely to be a threat.|
|`VIOL_PARAMETER_NAME_METACHAR`|Illegal meta character in parameter name|The system checks that all parameter names within the incoming request only contain meta characters defined as allowed in the security policy.|
|`VIOL_PARAMETER_VALUE_METACHAR`|Illegal meta character in value|The system checks that all parameter values, XML element/attribute values, or JSON values within the request only contain meta characters defined as allowed in the security policy. Enforces proper input values.|

{{< /bootstrap-table >}}

### HTTP RFC Sub-violations and Descriptions

The following table specifies the HTTP Compliance sub-violation settings. All are supported in NGINX, but not all are enabled in the default App Protect security template. The table specifies which. Some of the checks are enforced by NGINX Plus and App Protect only gets a notification. Note: In this case, the request is always blocked regardless of the App Protect policy.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Sub-violation** | **Description** |
|-----------------|-----------------|
|Null in request (null in body, null in the header is done by NGINX Plus)|The system issues a violation for requests with a NULL character anywhere in the request (except for a NULL in the binary part of a multipart request).|
|Multiple host headers|Examines requests to ensure that they contain only a single “Host” header.|
|The host header contains IP address|The system verifies that the request’s host header value is not an IP address to prevent non-standard requests.|
|CRLF characters before request start|Examines whether there is a CRLF character before the request method. If there is, the system issues a violation.|
|Chunked request with Content-Length header|The system checks for a Content-Length header within chunked requests.|
|Check the maximum number of parameters|The system compares the number of parameters in the request to the maximum configured number of parameters. Maximum is set to 500.|
|Check the maximum number of headers|The system compares the request headers to the maximal configured number of headers. Maximum is set to 50.|
|Unescaped space in URL|The system checks that there is no unescaped space within the URL in the request line. Such spaces split URLs introducing ambiguity on picking the actual one.|
|Bad multipart/form-data request parsing|When the content type of a request header contains the substring “Multipart/form-data”, the system checks whether each multipart request chunk contains the strings “Content-Disposition” and “Name”. If they do not, the system issues a violation.|
|Bad multipart parameters parsing|The system checks the following: <ul><li> A boundary follows immediately after request headers.</li><li>The parameter value matches the format: ‘name=”param_key”;rn.</li><li>A chunked body contains at least one CRLF.</li><li>A chunked body ends with CRLF.</li><li>Final boundary was found on multipart request.</li><li>There is no payload after final boundary.</li><li>If one of these is false, the system issues a violation.</li>|

{{< /bootstrap-table >}}

### Evasion Techniques and Description

The following table specifies the Evasion Techniques sub-violation values and descriptions.

{{<bootstrap-table "table table-striped table-bordered">}}

| **Sub-violation** | **Description** |
|-----------------|-----------------|
|%u decoding|The system performs Microsoft %u Unicode decoding (%UXXXX where X is a hexadecimal digit). For example, the system turns a%u002fb to a/b. The system performs this action on URI and parameter input to evaluate if the request contains an attack.|
|Apache whitespace|The system detects the following characters in the URI: 9 (0x09), 11 (0x0B), 12 (0x0C), and 13 (0x0D).|
|Bad unescape|The system detects illegal HEX encoding. Reports unescaping errors (such as %RR).|
|Bare byte decoding|The system detects higher ASCII bytes (greater than 127).|
|Directory traversals|The system ensures that directory traversal commands like ../ are not part of the URL. While requests generated by a browser should not contain directory traversal instructions, sometimes requests generated by JavaScript have them.|
|IIS backslashes|The system normalizes backslashes (`\`) to slashes (`/`) for further processing.|
|IIS Unicode codepoints|The system handles the mapping of IIS specific non-ASCII codepoints. Indicates that, when a character is greater than ‘0x00FF’, the system decodes %u according to an ANSI Latin 1 (Windows 1252) code page mapping. For example, the system turns a%u2044b to a/b. The system performs this action on URI and parameter input.|
|Multiple decoding|The system decodes URI and parameter values multiple times according to the number specified before the request is considered an evasion.  The maximum decoding is 3.|

{{< /bootstrap-table >}}

{{< versions "3.12" "latest" "ctrlvers" >}}
