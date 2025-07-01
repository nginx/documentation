---
nd-docs: "DOCS-1570"
---

Each signature, factory or user-defined, and violation has an **Attack Type**, the attack vector it protects from. When you create a user-defined signature you associate it with the most appropriate attack type from the list below. If you do not find an Attack Type that matches the threat for which your signature was written, use `Other Application Activity` Attack Type. Attach Types are also useful as part of the filter in user-defined signature **sets**.

Following is the full list of Attack Types supported in App Protect. Use the **name** of the Attack Type to reference it within the signature or signature set filter.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Attack Type Name | Description |
| ---| --- |
|Abuse of Functionality | Abuse of Functionality is an attack technique that uses a web site's own features and functionality to consume, defraud, or circumvent access controls mechanisms. |
|Authentication/Authorization Attacks | Authentication/Authorization Attacks occur when a web site permits an attacker to access sensitive content or functionality without having to properly authenticate, or authorize, that resource. |
|Buffer Overflow | Buffer Overflow could be triggered when data written to memory exceeds the allocated size of the buffer for that data. This could lead to the Denial of Service or arbitrary code execution. |
|Cache Poisoning | Cache poisoning is an attack against the integrity of an intermediate Web cache repository, in which genuine content cached for an arbitrary URL is replaced with spoofed content. |
|Command Execution | Web applications can be tricked to execute operating system commands, injected from a remote machine, if user supplied input is not properly checked by the web application. |
|Cross-site Request Forgery | An attacker exploits the web application's assumption and trust that the authenticated user is purposely sending requests to perform actions or commands, while in fact the attacker is causing the user to send the commands without the user's knowledge or consent. |
|Cross Site Scripting (XSS) | Cross Site Scripting (XSS) occurs when a web application does not sanitize user-supplied input and places it directly into the page returned to the user. Usually, the attacker will submit malicious JavaScript, VBScript, ActiveX, HTML, or Flash code to the vulnerable web site. |
|Denial of Service | A denial-of-service (DoS) attack represents a family of attacks aimed to exhaust the application server resources up to a point that the application cannot respond to legitimate traffic, either because it has crashed, or because its slow response renders it effectively unavailable. |
|Detection Evasion | An attempt is made to evade detection of the attack on a web server, by obfuscating the attack using various methods such as encodings and path manipulation. |
|Directory Indexing | This is a directory listing attempt which can lead to information disclosure and possible exposure of sensitive system information. Directory Indexing attacks usually target web servers that are not correctly configured, or which have a vulnerable component that allows Directory Indexing. |
|Forceful Browsing | This attack occurs when an attacker is directly accessing a URL, which could grant access to a restricted part of the web site. |
|HTTP Parser Attack | HTTP parser attack targets the functionality of the HTTP parser in order to crash it or force the parser to work abnormally. |
|HTTP Request Smuggling Attack | Specially crafted HTTP messages can manipulate the web server or cache's standard behavior. This can lead to XSS, and cache poisoning. |
|HTTP Response Splitting | Specially crafted HTTP messages can manipulate the web server or cache's standard behavior. This can lead to XSS, and cache poisoning. |
|Information Leakage | Sensitive information may be present within HTML comments, error messages, source code, or simply left in files which are accessible by remote clients. In addition, attackers can manipulate the application to reveal classified information like credit card numbers. This can lead to the disclosure of sensitive system information which may be used by an attacker to further compromise the system. |
|Insecure Deserialization | This is an attack against an application that receives serialized objects. An application which does not restrict which objects might be deserialized could be exploited by attackers sending specific object called 'gadgets', that could trigger arbitrary code execution when deserialized. |
|Insecure File Upload | Many applications allow uploading files to the server, such as images or documents. An application that does not correctly restrict the type of the uploaded files or the upload folder path can be exploited by attackers to upload files, called 'WebShells', containing malicious code that later will be executed or override the server configuration. |
|JSON Parser Attack | This attack targets the functionality of the JSON parser in order to crash it or force the parser to work abnormally. |
|LDAP Injection | If user-supplied input is not correctly sanitized, the attacker could change the construction of LDAP statements. Successful exploitation results in information gathering, system integrity compromise, and possible modification of the LDAP tree. |
|Malicious File Upload | Malicious file upload occurs when a user tries to upload a malicious file to the web application. This could allow remote attackers to cause Server Infection, Network Infection, Buffer Overflow and Remote Comma Execution. |
|Non-browser Client | An attempt is made by a non-browser client to explore the site. |
|Other Application Attacks | This is an attack which targets the web application and does not fall in any predefined category. |
|Parameter Tampering | By changing certain parameters in a URL or web page form, attackers can successfully attack the web application business logic. |
|Path Traversal | Path traversal can be used to bypass the web server root and request various files, including system files or private directories and resources. This attack can lead to information disclosure, and possible exposure of sensitive system information. |
|Predictable Resource Location | By making educated guesses, the attacker could discover hidden web site content and functionality, such as configuration, temporary, backup, or sample files. This can lead to the disclosure of sensitive system information which may be used by an attacker to compromise the system. |
|Remote File Include | Remote File Inclusion attacks allow attackers to run arbitrary code on a vulnerable website. |
|Server Side Code Injection | An attacker can submit server-side code by invalidated input. The web server, when parsing malicious input, may execute operating system commands or access restricted files. |
|Server-Side Request Forgery (SSRF) | Some applications receive a URL as input and use it to exchange data with another service. An attacker could provide special URLs to read or update internal resources such as localhost services, cloud metadata servers, internal network web applications or HTTP enabled databases. |
|Server-Side Template Injection | Some applications use server-side templates for better modularity. This attack occurs when a non-sanitized input containing template directives is embedded into a server-side template which then leads to execution of the injected code when rendered. |
|Session Hijacking | An attacker can steal a valid web session from legitimate users in order to gain unauthorized access. |
|SQL-Injection | SQL-Injection occurs when a web application does not sanitize user-supplied input, and places it directly into the SQL statement. This attack allows remote attackers to run SQL statements on the internal database. |
|Trojan/Backdoor/Spyware | This is an attack initiated by some form of malicious code. |
|Vulnerability Scan | An attempt is made using an automatic tool to scan a web server, or an application running on a web server, for a possible vulnerability. |
|XML External Entities (XXE) | This is a type of attack against an application that parses XML input. This attack occurs when XML input containing a reference to an external entity is processed by a weakly configured XML parser. |
|XML Parser Attack | This attack targets the functionality of the XML parser in order to crash it or force the parser to work abnormally. |
|XPath Injection | XPath-Injection occurs when a web application does not sanitize user-supplied input but places it directly into the XML document query. Successful exploitation results in information gathering and system integrity compromise. |
{{</bootstrap-table>}}