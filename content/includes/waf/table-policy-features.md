---
---

{{< table >}}

| Feature                             | Description |
| ----------------------------------- | ----------- |
| [Allowed methods]({{< ref "/waf/policies/allowed-methods.md" >}}) | Checks allowed HTTP methods. By default, all the standard HTTP methods are allowed. |
| [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}) | The default policy covers the OWASP top 10 attack patterns. Specific signature sets can be added or disabled. |
| [Brute force attack preventions]({{< ref "/waf/policies/brute-force-attacks.md" >}}) | Configure parameters to secure areas of a web application from brute force attacks. |
| [Cookie enforcement]({{< ref "/waf/policies/cookie-enforcement.md" >}}) | By default all cookies are allowed and not enforced for integrity. The user can add specific cookies, wildcards or explicit, that will be enforced for integrity. It is also possible to set the cookie attributes: HttpOnly, Secure and SameSite for cookies found in the response. |
| [Data guard]({{< ref "/waf/policies/data-guard.md" >}}) | Detects and masks Credit Card Number (CCN) and/or U.S. Social Security Number (SSN) and/or custom patterns in HTTP responses. Disabled by default. |
| [Deny and Allow IP lists]({{< ref "/waf/policies/deny-allow-ip.md" >}}) | Manually define denied & allowed IP addresses as well as IP addresses to never log. |
| [Disallowed file type extensions]({{< ref "/waf/policies/disallowed-extensions.md" >}}) | Support any file type, and includes a predefined list of file types by default |
| [Evasion techniques]({{< ref "/waf/policies/evasion-techniques.md" >}}) | All evasion techniques are enabled by default, and can be disabled individually. These include directory traversal, bad escaped characters and more. |
| [Geolocation]({{< ref "/waf/policies/geolocation.md" >}}) | | 
| [GraphQL protection]({{< ref "/waf/policies/graphql-protection.md" >}}) | | 
| [gRPC protection]({{< ref "/waf/policies/evasion-techniques.md" >}}) | gRPC protection detects malformed content, parses well-formed content, and extracts the text fields for detecting attack signatures and disallowed meta-characters. In addition, it enforces size restrictions and prohibition of unknown fields. The Interface Definition Language (IDL) files for the gRPC API must be attached to the profile. gRPC protection is available for unary or bidirectional traffic. |
| [HTTP compliance]({{< ref "/waf/policies/http-compliance.md" >}}) | All HTTP protocol compliance checks are enabled by default except for GET with body and POST without body. It is possible to enable any of these two. Some of the checks enabled by default can be disabled, but others, such as bad HTTP version and null in request are performed by the NGINX parser and NGINX App Protect WAF only reports them. These checks cannot be disabled. |
| [IP address lists]({{< ref "/waf/policies/ip-address-lists.md" >}}) | Organize lists of allowed and forbidden IP addresses across several lists with common attributes. |
| [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) | Configure the IP Intelligence feature to customize enforcement based on the source IP of the request, limiting access from IP addresses with questionable reputation. |
| [JWT protection]({{< ref "/waf/policies/jwt-protection.md" >}}) | | 
| [Server technology signatures]({{< ref "/waf/policies/server-technology-signatures.md" >}}) | Support adding signatures per added server technology. |
| [Time-based signature staging]({{< ref "/waf/policies/time-based-signature-staging.md" >}}) | Time-based signature staging allows you to stage signatures for a specific period of time. During the staging period, violations of staged signatures are logged but not enforced. After the staging period ends, violations of staged signatures are enforced according to the policy's enforcement mode. |
| [Threat campaigns]({{< ref "/waf/policies/threat-campaigns.md" >}}) | These are patterns that detect all the known attack campaigns. They are very accurate and have almost no false positives, but are very specific and do not detect malicious traffic that is not part of those campaigns. The default policy enables threat campaigns but it is possible to disable it through the respective violation. |
| [User-defined HTTP headers]({{< ref "/waf/policies/user-headers.md" >}}) | Handling headers as a special part of requests |
| [XFF trusted headers]({{< ref "/waf/policies/xff-headers.md" >}}) | Disabled by default, and can accept an optional list of custom XFF headers. |
| [XML and JSON content]({{< ref "/waf/policies/xml-json-content.md" >}}) | XML content and JSON content profiles detect malformed content and signatures in the element values. Default policy checks maximum structure depth. It is possible to enable more size restrictions: maximum total length of XML/JSON data, maximum number of elements are more. |
{{< /table >}}
