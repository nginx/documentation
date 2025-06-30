---
nd-docs: "DOCS-1592"
---

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Feature | Description |
| ---| --- |
|Enforcement by Violation Rating | By default block requests that are declared as threats, that is, their Violation Rating is 4 or 5. It is possible to change this behavior: either disable enforcement by Violation Rating or block also request with Violation Rating 3 - needs examination. See section on [basic configuration](#policy-configuration) below. |
|Large Request Blocking | To increase the protection of resources at both the NGINX Plus and upstream application tiers, all requests that are larger than 10 MB in size are blocked.  When these requests are blocked, a `VIOL_REQUEST_MAX_LENGTH` violation will be logged.|
|Request size checks | Upper limit of request size as dictated by the maximum buffer size of 10 MB;  Size checks for: URL, header, Query String, whole request (when smaller than the maximum buffer), cookie, POST data. By default all the checks are enabled with the exception of POST data and whole request. The user can enable or disable every check and customize the size limits. |
|Malformed cookie | Requests with cookies that are not RFC compliant are blocked by default. This can be disabled. |
|Status code restriction | Illegal status code in the range of 4xx and 5xx. By default only these are allowed: 400, 401, 404, 407, 417, 503. The user can modify this list or disable the check altogether. |
|Blocking pages | The user can customize all blocking pages. By default the AJAX response pages are disabled, but the user can enable them. |
{{</bootstrap-table>}}