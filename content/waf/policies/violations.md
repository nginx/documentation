---
# We use sentence case and present imperative tone
title: "Violations"
# Weights are assigned in increments of 100: determines sorting order
weight: 150
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes the violations in F5 WAF for NGINX and how they are rated.

Violations are rated by the F5 WAF for NGINX algorithms to help distinguish between attacks and potential false positive alerts.

A violation rating is a numerical rating that our algorithms give to requests based on the presence of violation(s). Each violation type and severity contributes to the calculation of the final rating.

The final rating then defines the action taken for the specific request. 
 
Based on the default policy, any violation rating of 1, 2 and 3 will not cause the request to be blocked and only a log will be generated with **alerted** status. 

If the violation rating is 4 or 5, the request is blocked: a blocking page is displayed and a log generated for the transaction with **blocked** status. Violation ratings are displayed in the logs by default.

Violations can be enabled by turning on the **alarm** and/or **block** flags.

## Supported violations

{{< table >}}

| Name | Title | Default flags | Description | Comment |
| ---- | ----- | ------------- | ----------- | ------- |
| VIOL_ACCESS_INVALID| Access token does not comply with the profile requirements| Alarm | The system checks the access token in a request according to the access profile attached to the respective URL. The violation is raised when at least one of the enforced checks in the profile is not satisfied | This would trigger a Violation Rating of 5. |
| VIOL_ACCESS_MISSING| Missing Access Token | Alarm | The system checks that the request contains the access token for the respective URL according to the Access Profile. The violation is raised when that token is not found.| This would trigger a Violation Rating of 5. |
| VIOL_ACCESS_MALFORMED| Malformed Access Token | Alarm | The access token required for the URL in the request was malformed. | This would trigger a Violation Rating of 5. |
| VIOL_ACCESS_UNAUTHORIZED| Unauthorized access attempt | Alarm | The system checks that the access token complies with the authorization conditions defined per the accessed URL. The violation is raised at least one condition is not met.| This would trigger a Violation Rating of 5.   |
 VIOL_ASM_COOKIE_MODIFIED | Modified ASM cookie | Alarm & Block | The system checks that the request contains an ASM cookie that has not been modified or tampered with. Blocks modified requests. |  |
| VIOL_ATTACK_SIGNATURE | Attack signature detected | N/A | The system examines the HTTP message for known attacks by matching it against known attack patterns. | Determined per signature set. <br>Note: This violation cannot be configured by the user. Rather, the violation is determined by the combination of the signature sets on the policy.|
| VIOL_BLACKLISTED_IP | IP is in the deny list | Alarm | The violation is issued when a request comes from an IP address that falls in the range of an IP address exception marked for "always blocking", that is, the deny list of IPs. | Would trigger Violation Rating of 5. |
| VIOL_BOT_CLIENT | Bot Client Detected | Alarm & Block | The system detects automated clients, and classifies them to Bot types. |  |
| VIOL_COOKIE_EXPIRED | Expired timestamp | Alarm | The system checks that the timestamp in the HTTP cookie is not old. An old timestamp indicates that a client session has expired. Blocks expired requests. The timestamp is extracted and validated against the current time. If the timestamp is expired and it is not an entry point, the system issues the Expired Timestamp violation. |  |
| VIOL_COOKIE_LENGTH | Illegal cookie length | Alarm | The system checks that the request does not include a cookie header that exceeds the acceptable length specified in the security policy. | Determined by policy setting which is disabled in default template. |
|VIOL_COOKIE_MALFORMED | Cookie not RFC-compliant | Alarm & Block | This violation occurs when HTTP cookies contain at least one of the following components:<br><ul><li>Quotation marks in the cookie name.</li><li>A space in the cookie name.</li><li>An equal sign (=) in the cookie name.</li></ul><br>  Note: A space between the cookie name and the equal sign (=), and between the equal sign (=) and cookie value is allowed.<ul><li>An equal sign (=) before the cookie name.</li><li>A carriage return (hexadecimal value of 0xd) in the cookie name.</li></ul> |  |
| VIOL_COOKIE_MODIFIED | Modified domain cookie(s) | Alarm | The system checks that the web application cookies within the request have not been tampered, and the system checks that the request includes a web application cookie defined in the security policy. | Determined by cookie type: applied to "enforced" cookies. |
| VIOL_DATA_GUARD | Data Guard: Information leakage detected | Alarm | The system examines responses and searches for sensitive information. | Controlled by the DG enable flag which is disabled in default template. |
| VIOL_ENCODING | Failed to convert character | Alarm & Block | The system detects that one of the characters does not comply with the configured language encoding of the web application's security policy. | Enforced by NGINX core, reported by App Protect. |
| VIOL_EVASION | Evasion technique detected | Alarm | This category contains a list of evasion techniques that attackers use to bypass detection. |  |
| VIOL_FILETYPE | Illegal file type | Alarm | The system checks that the requested file type is configured as a valid file type, or not configured as an invalid file type, within the security policy. | Only for disallowed file types. |
| VIOL_FILE_UPLOAD | Disallowed file upload content detected | Alarm | The system checks that the file upload content is not a binary executable file format. | The check must be enabled for parameters of data type file upload |
| VIOL_FILE_UPLOAD_IN_BODY | Disallowed file upload content detected in body | Alarm | The system checks that the file upload content is not a binary executable file format. | The check must be enabled for URLs |
| VIOL_GEOLOCATION | Disallowed Geolocations | Alarm & Block | This violation will be triggered when an attempt is made to access the web application from a restricted location. | |
| VIOL_GRAPHQL_MALFORMED | Malformed GraphQL data | Alarm & Block | This violation will be issued when the traffic expected to be GraphQL doesn't comply to the GraphQL syntax. The specifics of the syntax that will be enforced in App Protect is detailed in the enforcing section. The violation details will note the error.| In case of tolerate parser warning turned on, missing closing bracket of the JSON should not issue a violation. |
| VIOL_GRAPHQL_FORMAT | GraphQL format data does not comply with format settings | Alarm & Block | This violation will be issued when the GraphQL profile settings are not satisfied, for example the length is too long, depth is too deep, a specific value is too long or too many batched queries. <br> The violation details will note what happened and the found length, depth or which value is too long and by what. <br> The depth violation is not learnable. The reason is that we don't know the actual depth of the query - we stop parsing at the max depth. <br> Note that the values will be used on the variables JSON part as well as the query. In a way, we can see these values as a JSON profile attributes just for the variables. | |
| VIOL_GRAPHQL_INTROSPECTION_QUERY| GraphQL introspection Query | Alarm & Block | This violation will be issued when an introspection query was seen. |  |
| VIOL_GRAPHQL_ERROR_RESPONSE | GraphQL Error Response | Alarm & Block | GraphQL disallowed pattern in response. | |
| VIOL_GRPC_FORMAT | gRPC data does not comply with format settings | Alarm | The system checks that the request contains gRPC content and complies with the various request limits within the defense configuration in the security policy's gRPC Content Profile. Enforces valid gRPC requests and protects the server from Protocol Buffers parser attacks. This violation is generated when a gRPC request does not meet restrictive conditions in the gRPC Content Profile, such as the message length or existence of unknown fields. |  |
| VIOL_GRPC_MALFORMED | Malformed gRPC data | Alarm & Block | The system checks that the request contains gRPC content that is well-formed. Enforces parsable gRPC requests. |  |
| VIOL_GRPC_METHOD | Illegal gRPC method | Alarm | The system checks that the gRPC service method invoked matches one of the methods defined in the IDL file. The violation is triggered if the method does not appear there. |  |
| VIOL_HEADER_LENGTH | Illegal header length | Alarm | The system checks that the request includes a total HTTP header length that does not exceed the length specified in the security policy. | The actual size in default policy is 4 KB |
| VIOL_HEADER_METACHAR | Illegal meta character in header | Alarm | The system checks that the values of all headers within the request only contain meta characters defined as allowed in the security policy. |  |
| VIOL_HTTP_PROTOCOL | HTTP protocol compliance failed | Alarm | This category contains a list of validation checks that the system performs on HTTP requests to ensure that the requests are formatted properly. |  |
| VIOL_HTTP_RESPONSE_STATUS | Illegal HTTP response status | Alarm | The server response contains an HTTP status code that is not defined as valid in the security policy. |  |
| VIOL_JSON_FORMAT | JSON data does not comply with format settings | Alarm | The system checks that the request contains JSON content and complies with the various request limits within the defense configuration in the security policy's JSON profile. Enforces valid JSON requests and protects the server from JSON parser attacks. This violation is generated when a problem is detected in a JSON request, generally checking the message according to boundaries such as the message's size and meta characters in parameter value. | Controlled from the default JSON profile. |
| VIOL_JSON_MALFORMED | Malformed JSON data | Alarm & Block | The system checks that the request contains JSON content that is well-formed. Enforces parsable JSON requests. |  |
| VIOL_JSON_SCHEMA | JSON data does not comply with JSON schema | Alarm | The system checks that the incoming request contains JSON data that matches the schema file that is part of a JSON profile configured in the security policy. Enforces proper JSON requests defined by the schema. |  |
| VIOL_MANDATORY_PARAMETER | Mandatory parameter is missing | Alarm | The system checks that parameter marked as mandatory exists in the request. |  |
| VIOL_MANDATORY_REQUEST_BODY | Mandatory request body is missing | Alarm | The system checks that the body exists in the request |  |
| VIOL_METHOD | Illegal method | Alarm | The system checks that the request references an HTTP request method that is found in the security policy. Enforces desired HTTP methods; GET and POST are always allowed. | These HTTP methods are supported:<br><ul><li>GET</li><li>HEAD</li><li>POST</li><li>PUT</li><li>PATCH</li><li>DELETE</li><li>OPTIONS</li></ul> |
| VIOL_PARAMETER | Illegal parameter | Alarm | The system checks that every parameter in the request is defined in the security policy. |  |
| VIOL_PARAMETER_ARRAY_VALUE | Illegal parameter array value | Alarm | The value of an item in an array parameter is not according to the defined data type. |  |
| VIOL_PARAMETER_DATA_TYPE | Illegal parameter data type | Alarm | The system checks that the request contains a parameter whose data type matches the data type defined in the security policy. The data types that this violation applies to are integer, email, and phone. |  |
| VIOL_PARAMETER_EMPTY_VALUE | Illegal empty parameter value | Alarm | The system checks that the request contains a parameter whose value is not empty when it must contain a value. |  |
| VIOL_PARAMETER_LOCATION | Illegal parameter location | Alarm | The parameter was found in a different location than it was configured in the policy. |  |
| VIOL_PARAMETER_MULTIPART_NULL_VALUE | Null in multi-part parameter value | Disabled | The system checks that the multi-part request has a parameter value that does not contain the NULL character (0x00). If a multipart parameter with binary content type contains NULL in its value, the Enforcer issues this violation. The exceptions to this are:<br><ul><li>If that parameter is configured in the policy as `Ignore value`.</li><li>If that parameter is configured in the security policy as `user-input file-upload`.</li><li>If the parameter has a content-type that contains the string 'XML' and the parameter value contains a valid UTF16 encoded XML document (the encoding is valid). In this case NULL is allowed as it is part of the UTF16 encoding.</li></ul> |  |
| VIOL_PARAMETER_NAME_METACHAR | Illegal meta character in parameter name | Alarm | The system checks that all parameter names within the incoming request only contain meta characters defined as allowed in the security policy. |  |
| VIOL_PARAMETER_NUMERIC_VALUE | Illegal parameter numeric value | Alarm | The system checks that the incoming request contains a parameter whose value is in the range of decimal or integer values defined in the security policy. |  |
| VIOL_PARAMETER_REPEATED | Illegal repeated parameter name | Alarm | Detected multiple parameters of the same name in a single HTTP request. |  |
| VIOL_PARAMETER_STATIC_VALUE | Illegal static parameter value | Alarm | The system checks that the request contains a static parameter whose value is defined in the security policy. Prevents static parameter change. F5 WAF for NGINX can be configured to block parameter values that are not in a predefined list. Parameters can be defined on each of the following levels: file type, URL, and flow. Each parameter can be one of the following types: explicit or wildcard. |  |
| VIOL_PARAMETER_VALUE_BASE64 | Illegal Base64 value | Alarm | The system checks that the value is a valid Base64 string. If the value is indeed Base64, the system decodes this value and continues with its security checks. |  |
| VIOL_PARAMETER_VALUE_LENGTH | Illegal parameter value length | Alarm | The system checks that the request contains a parameter whose value length (in bytes) matches the value length defined in the security policy. |  |
| VIOL_PARAMETER_VALUE_METACHAR | Illegal meta character in value | Alarm | The system checks that all parameter values, XML element/attribute values, or JSON values within the request only contain meta characters defined as allowed in the security policy. Enforces proper input values. In case of a violation, the reported value represents the decimal ASCII value (metachar_index), or, in case of using "json_log" the hexadecimal ASCII value (metachar) of the violating character. |  |
| VIOL_PARAMETER_VALUE_REGEXP | Parameter value does not comply with regular expression | Alarm | The system checks that the request contains an alphanumeric parameter value that matches the expected pattern specified by the regular-expression field for that parameter. Prevents HTTP requests which do not comply with a defined pattern. F5 WAF for NGINX lets you set up a regular expression to block requests where a parameter value does not match the regular expression. |  |
| VIOL_POST_DATA_LENGTH | Illegal POST data length | Alarm | The system checks that the request contains POST data whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. This check is disabled by default. |
| VIOL_QUERY_STRING_LENGTH | Illegal query string length | Alarm | The system checks that the request contains a query string whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. Actual size is 2 KB. |
| VIOL_RATING_THREAT | Request is likely a threat | Alarm & Block | The combination of violations in this request determined that the request is likely to be a threat. | For VR = 4 or 5 |
| VIOL_RATING_NEED_EXAMINATION | Request needs further examination | Disabled | The combination of violations could not determine whether the request is a threat or violations are false positives thus requiring more examination. | For VR = 3 |
| VIOL_REQUEST_LENGTH | Illegal request length | Alarm | The system checks that the request length does not exceed the  acceptable length specified in the security policy per the requested file type. | In * file type entity. This check is disabled by default. |
| VIOL_REQUEST_MAX_LENGTH | Request length exceeds defined buffer size | Alarm & Block| The system checks that the request length is not larger than the maximum memory buffer size. Note that this protects F5 WAF for NGINX from consuming too much memory across all security policies which are active on the device. | Default is 10MB |
| VIOL_RULE | Actionable override rule was triggered. | Disabled |A policy override rule with an action was triggered.| |
| VIOL_THREAT_CAMPAIGN | Threat Campaign detected | Alarm & Block | The system examines the HTTP message for known threat campaigns by matching it against known attack patterns. |  |
| VIOL_URL | Illegal URL | Alarm | The system checks that the requested URL is configured as a valid URL, or not configured as an invalid URL, within the security policy. |  |
| VIOL_URL_CONTENT_TYPE | Illegal request content type | Alarm | The URL in the security policy has a `Header-Based Content Profiles` setting that disallows the request because the specified HTTP header or the default is set to `disallow`. |  |
| VIOL_URL_LENGTH | Illegal URL length | Alarm | The system checks that the request is for a URL whose length does not exceed the acceptable length specified in the security policy. | In * file type entity. Actual size is 2 KB. |
| VIOL_URL_METACHAR | Illegal meta character in URL | Alarm | The system checks that the incoming request includes a URL that contains only meta characters defined as allowed in the security policy. Enforces a desired set of acceptable characters. |  |
| VIOL_XML_FORMAT | XML data does not comply with format settings | Alarm | The system checks that the request contains XML data that complies with the various document limits within the defense configuration in the security policy's XML profile. Enforces proper XML requests and the data failed format/defense settings such as the maximum document length.<br>       This violation is generated when a problem in an XML document is detected (for example, an XML bomb), generally checking the message according to boundaries such as the message's size, maximum depth, and maximum number of children. | Controlled by the default XML profile |
| VIOL_XML_MALFORMED | Malformed XML data | Alarm & Block | The system checks that the request contains XML data that is well-formed, according to W3C standards. Enforces proper XML requests. |  |

{{< /table >}}

## HTTP compliance sub-violations

The following table specifies the HTTP compliance sub-violation settings: not all are enabled in the default F5 WAF for NGINX security template. 

Some of the checks are enforced by NGINX Plus: F5 WAF for NGINX only gets a notification. In this case, the request is **always** blocked regardless of the F5 WAF for NGINX policy.

{{< table >}}

| Sub-violation | Default setting | Enforced by | Description |
| ------------- | --------------- | ----------- | ----------- |
| Unparsable request content | Enabled | NGINX | This violation is triggered when the system's parser cannot parse the message. |
| Several Content-Length headers | Enabled | NGINX | More than one content-length header is a non RFC violation. Indicates an HTTP response splitting attack. |
| POST request with Content-Length: 0 | Disabled | F5 WAF for NGINX | POST request is usually sent with request body. This sub-violation is issued when a request has empty or no body at all. |
| Null in request | Enabled | NGINX for null in header, F5 WAF for NGINX for null in body | The system issues a violation for requests with a NULL character anywhere in the request (except for a NULL in the binary part of a multipart request). |
| No Host header in HTTP/1.1 request | Enabled | NGINX | Examines requests using HTTP/1.1 to see whether they contain a "Host" header. |
| Multiple host headers | Enabled | NGINX | Examines requests to ensure that they contain only a single "Host" header. |
| Host header contains IP address | Enabled | F5 WAF for NGINX | The system verifies that the request's host header value is not an IP address to prevent non-standard requests. |
| High ASCII characters in headers | Enabled | F5 WAF for NGINX | Checks for high ASCII characters in headers (greater than 127). |
| Header name with no header value | Disabled | F5 WAF for NGINX | The system checks for a header name without a header value. |
| CRLF characters before request start | N/A | NGINX | **Note:** NGINX strips any CRLF characters before the request method. The system **DOES NOT** issue a violation.|
| Content length should be a positive number | Enabled | NGINX | The Content-Length header value should be greater than zero; only a numeric positive number value is accepted. |
| Chunked request with Content-Length header | Enabled | F5 WAF for NGINX | The system checks for a Content-Length header within chunked requests. |
| Check maximum number of parameters | Enabled | F5 WAF for NGINX | The system compares the number of parameters in the request to the maximum configured number of parameters. When enabled, the default value for number of maximum number of parameters is 500. |
| Check maximum number of headers | Enabled | F5 WAF for NGINX | The system compares the request headers to the maximal configured number of headers. |
| Unescaped space in URL | Enabled | F5 WAF for NGINX | The system checks that there is no unescaped space within the URL in the request line. Such spaces split URLs introducing ambiguity on picking the actual one. when enabled, the default value for number of unescaped space in URL is 50.|
| Body in GET or HEAD requests | Disabled | F5 WAF for NGINX | Examines GET and HEAD requests which have a body. |
| Bad multipart/form-data request parsing | Enabled | F5 WAF for NGINX | When the content type of a request header contains the substring "Multipart/form-data", the system checks whether each multipart request chunk contains the strings "Content-Disposition" and "Name". If they do not, the system issues a violation. |
| Bad multipart parameters parsing | Enabled | F5 WAF for NGINX | The system checks the following:<ol><li>A boundary follows immediately after request headers.</li><li>The parameter value matches the format: 'name="param_key";\\r\\n.</li><li>A chunked body contains at least one CRLF.</li><li>A chunked body ends with CRLF.</li><li>Final boundary was found on multipart request.</li><li>There is no payload after final boundary.</li></ol><br><br> If one of these is false, the system issues a violation. |
| Bad HTTP version | Enabled | NGINX | Enforces legal HTTP version number (only 0.9 or higher allowed). |
| Bad host header value | Enabled | NGINX | Detected non RFC compliant header value. |
| Check maximum number of cookies | Enabled | F5 WAF for NGINX | The system compares the request cookies to the maximal configured number of cookies. When enabled, the default value for number of maximum cookies if unmodified is 100. |

{{< /table >}}

## Evasion techniques sub-violations

All of these sub-violations are **enabled** by default.

{{< table >}}

| Sub-violation | Description |
| ------------- | ----------- |
| %u decoding | Performs Microsoft %u unicode decoding (%UXXXX where X is a hexadecimal digit). For example, the system turns a%u002fb to a/b. The system performs this action on URI and parameter input to evaluate if the request contains an attack. |
| Apache whitespace |The system detects the following characters in the URI: 9 (0x09), 11 (0x0B), 12 (0x0C), and 13 (0x0D). |
| Bad unescape | The system detects illegal HEX encoding. Reports unescaping errors (such as %RR). |
| Bare byte decoding | The system detects higher ASCII bytes (greater than 127). |
| Directory traversals |  Ensures that directory traversal commands like ../ are not part of the URL. While requests generated by a browser should not contain directory traversal instructions, sometimes requests generated by JavaScript have them. |
| IIS backslashes | Normalizes backslashes (\\) to slashes (/) for further processing. |
| IIS Unicode codepoints | Handles the mapping of IIS specific non-ASCII codepoints. Indicates that, when a character is greater than '0x00FF', the system decodes %u according to an ANSI Latin 1 (Windows 1252) code page mapping. For example, the system turns a%u2044b to a/b. The system performs this action on URI and parameter input. |
| Multiple decoding | |

{{< /table >}}