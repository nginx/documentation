---
docs: "DOCS-1612"
---

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
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
{{</bootstrap-table>}}
