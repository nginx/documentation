
The table below lists the NGINX Controller WAF enforcement areas and the specific checks included in each.

| Enforcement Area          | Specific Checks                                                                                                                   | Protects Against |
:---------------------------|:--------------------------------------------------------------------------------------------------------------------------------- |:-----------------|
| Attack Signatures         | Medium and High accuracy attack signatures: <br> - generic signatures that aren't tied to specific technologies <br>- signatures specific to the app's technology stack as described in **Technology Stacks** below.  | Injection, XSS, Unsafe deserialization, and many others |
| HTTP Protocol Compliance  | Severe violations of the protocol: <br>- unparsable request, <br>- illegal HTTP version, <br>- null in the request, <br>- missing or multiple host headers    | HTTP Parser attacks, evasion |
| Evasion Techniques        | Directory traversal                                                                                                               | Unauthorized access, evasion |
| General                   | - Malformed cookie, <br/>- illegal status code, <br/>- request size exceeds buffer size, <br/>- malformed JSON/XML, <br/>- bad escaping, <br/>- illegal file extensions (see list below)               | Known attackers, parser attacks, information disclosure |

**Illegal File Extensions**

|||||
|--- |--- |--- |--- |  
|bat|bck|bin|cfg|  
|cmd|com|config|dat|  
|dll|eml|exe|exe1|  
|exe_renamed|hta|htr|htw|  
|ida|idc|idq|ini|

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-506 -->