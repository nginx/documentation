---
docs: "DOCS-1612"
---

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Protection Mechanism | Description |
| ---| --- |
|Attack Signatures | Default policy covers all the OWASP top 10 attack patterns enabling signature sets detailed in a section below. The user can disable any of them or add other sets. |
|Signature attack for Server Technologies | Support adding signatures per added server technology. |
|Threat Campaigns | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. |
|HTTP Compliance | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. |
|Evasion Techniques | All evasion techniques are enabled by default and each can be disabled. These include directory traversal, bad escaped character and more. |
|Data Guard | Detects and masks Credit Card Number (CCN) and/or U.S. Social Security Number (SSN) and/or custom patterns in HTTP responses. Disabled by default but can be enabled. |
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