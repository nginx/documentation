---
nd-docs: "DOCS-1576"
---

The following table specifies the HTTP Compliance sub-violation settings. All are supported in NGINX App Protect WAF, but not all are enabled in the default App Protect security template. The table specifies which. Some of the checks are enforced by NGINX Plus and App Protect only gets a notification. **Note:**  In this case, the request is **always** blocked regardless of the App Protect policy.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Sub-Violation | Default Template | Enforced by | Description |
| ---| ---| ---| --- |
|Unparsable request content | Enabled | NGINX | This violation is triggered when the system's parser cannot parse the message. |
|Several Content-Length headers | Enabled | NGINX | More than one content-length header is a non RFC violation. Indicates an HTTP response splitting attack. |
|POST request with Content-Length: 0 | Disabled | App Protect | POST request is usually sent with request body. This sub-violation is issued when a request has empty or no body at all. |
|Null in request | Enabled | Null in header - NGINX, null in body - App Protect | The system issues a violation for requests with a NULL character anywhere in the request (except for a NULL in the binary part of a multipart request). |
|No Host header in HTTP/1.1 request | Enabled | NGINX | Examines requests using HTTP/1.1 to see whether they contain a "Host" header. |
|Multiple host headers | Enabled | NGINX | Examines requests to ensure that they contain only a single "Host" header. |
|Host header contains IP address | Enabled | App Protect | The system verifies that the request's host header value is not an IP address to prevent non-standard requests. |
|High ASCII characters in headers | Enabled | App Protect | Checks for high ASCII characters in headers (greater than 127). |
|Header name with no header value | Disabled | App Protect | The system checks for a header name without a header value. |
|CRLF characters before request start | N/A | NGINX | **Note:** NGINX strips any CRLF characters before the request method. The system **DOES NOT** issue a violation.|
|Content length should be a positive number | Enabled | NGINX | The Content-Length header value should be greater than zero; only a numeric positive number value is accepted. |
|Chunked request with Content-Length header | Enabled | App Protect | The system checks for a Content-Length header within chunked requests. |
|Check maximum number of parameters | Enabled | App Protect | The system compares the number of parameters in the request to the maximum configured number of parameters. When enabled, the default value for number of maximum number of parameters is 500. |
|Check maximum number of headers | Enabled | App Protect | The system compares the request headers to the maximal configured number of headers. |
|Unescaped space in URL | Enabled | App Protect | The system checks that there is no unescaped space within the URL in the request line. Such spaces split URLs introducing ambiguity on picking the actual one. when enabled, the default value for number of unescaped space in URL is 50.|
|Body in GET or HEAD requests | Disabled | App Protect | Examines GET and HEAD requests which have a body. |
|Bad multipart/form-data request parsing | Enabled | App Protect | When the content type of a request header contains the substring "Multipart/form-data", the system checks whether each multipart request chunk contains the strings "Content-Disposition" and "Name". If they do not, the system issues a violation. |
|Bad multipart parameters parsing | Enabled | App Protect | The system checks the following:<ol><li>A boundary follows immediately after request headers.</li><li>The parameter value matches the format: 'name="param_key";\\r\\n.</li><li>A chunked body contains at least one CRLF.</li><li>A chunked body ends with CRLF.</li><li>Final boundary was found on multipart request.</li><li>There is no payload after final boundary.</li></ol><br><br> If one of these is false, the system issues a violation. |
|Bad HTTP version | Enabled | NGINX | Enforces legal HTTP version number (only 0.9 or higher allowed). |
|Bad host header value | Enabled | NGINX | Detected non RFC compliant header value. |
| Check maximum number of cookies | Enabled | App Protect | The system compares the request cookies to the maximal configured number of cookies. When enabled, the default value for number of maximum cookies if unmodified is 100. |
{{</bootstrap-table>}}