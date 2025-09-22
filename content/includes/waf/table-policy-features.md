---
---

{{< table >}}

| Feature                             | Description |
| ----------------------------------- | ----------- |
| [Allowed methods]()                 | Checks allowed HTTP methods. By default, all the standard HTTP methods are allowed. |
| [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}) | The default policy covers the OWASP top 10 attack patterns. Specific signature sets can be added or disabled. |
| [Brute force attack preventions]()  | Configure parameters to secure areas of a web application from brute force attacks. |
| [Cooke enforcement]()               | By default all cookies are allowed and not enforced for integrity. The user can add specific cookies, wildcards or explicit, that will be enforced for integrity. It is also possible to set the cookie attributes: HttpOnly, Secure and SameSite for cookies found in the response. |
| [Data guard]()                      | Detects and masks Credit Card Number (CCN) and/or U.S. Social Security Number (SSN) and/or custom patterns in HTTP responses. Disabled by default. |
| [Deny and Allow IP lists]()         | Manually define denied & allowed IP addresses as well as IP addresses to never log. |
| [Disallowed file type extensions]() | Support any file type, and includes a predefined list of file types by default |
| [Evasion techniques]()              | All evasion techniques are enabled by default can be disabled individually. These include directory traversal, bad escaped characters and more. |
| [gRPC protection]()                 | gRPC protection detects malformed content, parses well-formed content, and extracts the text fields for detecting attack signatures and disallowed meta-characters. In addition, it enforces size restrictions and prohibition of unknown fields. The Interface Definition Language (IDL) files for the gRPC API must be attached to the profile. gRPC protection can be on unary or bidirectional traffic. |
| [HTTP compliance]()                 | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. |
| [IP address lists]()                | Organize lists of allowed and forbidden IP addresses across several lists with common attributes. |
| [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) | Configure the IP Intelligence feature to customize enforcement based on the source IP of the request, limiting access from IP addresses with questionable reputation. |
| [JSON content]()                    | JSON content detects malformed content and detects signatures and metacharacters in the property values. Default policy checks maximum structure depth. It is possible to enforce a provided JSON schema and/or enable more size restrictions: maximum total length Of JSON data; maximum value length; maximum array length; tolerate JSON parsing errors. |
| [Parameter parsing]()               | Support only auto-detect parameter value type and acts according to the result: plain alphanumeric string, XML or JSON. |
| [Sensitive parameters]()            | The default policy masks the “password” parameter in the security log, and can be customized for more | 
| [Server technology signatures]()    | Support adding signatures per added server technology. |
| [Threat campaigns]()                | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. |
| [User-defined HTTP headers]({{< ref "/waf/policies/user-headers.md" >}}) | Handling headers as a special part of requests |
| [XFF trusted headers]({{< ref "/waf/policies/xff-headers.md" >}}) | Disabled by default, and can accept an optional list of custom XFF headers. |
| [XML content]()                     | XML content detects malformed content and detects signatures in the element values. Default policy checks maximum structure depth. It is possible to enable more size restrictions: maximum total length of XML data, maximum number of elements are more. SOAP, Web Services and XML schema features are not supported. |

{{< /table >}}