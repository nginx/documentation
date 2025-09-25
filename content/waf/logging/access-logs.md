---
title: Access logs
toc: false
weight: 500
nd-content-type: reference
nd-product: NAP-WAF
---

Access logs are NGINX's mechanism for logging requests. 

It is controlled by two directives:

**log_format**

This directive determines the format of the log messages using predefined variables. 

F5 WAF for NGINX can extend this set of variables with several security log attributes available for inclusion in `log_format`.  

If `log_format` is not specified then the built-in format `combined` is used, which does not include the extended F5 WAF for NGINX variables.

`log_format` _must_ be used in order to add to add F5 WAF for NGINX information to the logs.

**access_log**

This directive determines the destination of the _access_log_ and the formatted name. 

The default configuration is the file `/etc/nginx/log/access.log` using the combined format. 

Use this directive in order to create a customized format which can include the F5 WAF for NGINX variables.


### F5 WAF for NGINX variables for access logs

These are the variables added to Access Log. They are a subset of the Security log attributes. The Security log names are prefixed with **$app_protect**.

|Name | Meaning | Comment |
| ---| ---| --- |
|$app_protect_support_id | Unique ID assigned to the request by F5 WAF for NGINX. | To be used to correlate the access log with the security log.<br>       Left empty in failure mode. |
|$app_protect_outcome | One of:<ul><li>**PASSED**: request was sent to origin server.</li><li>**REJECTED**: request was blocked.</li></ul> |  |
|$app_protect_outcome_reason | One of:<ul><li>**SECURITY_WAF_OK**: allowed with no violations (legal request).</li><li>**SECURITY_WAF_VIOLATION**: blocked due to security violations.</li><li>**SECURITY_WAF_FLAGGED**: allowed although it has violations (illegal).</li><li>**SECURITY_WAF_BYPASS**: WAF was supposed to inspect the request but it didn't (because of unavailability or resource shortage). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li><li>**SECURITY_WAF_REQUEST_IN_FILE_BYPASS**: WAF was supposed to inspect the request but it didn't (because request buffer was full and request was written to file). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li><li>**SECURITY_WAF_COMPRESSED_REQUEST_BYPASS**: WAF was supposed to inspect the request but it didn't (because request was compressed). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li></ul> |  |
|$app_protect_policy_name | The name of the policy that enforced the request. |  |
|$app_protect_version | The F5 WAF for NGINX version string: major.minor.build format. | Does not include the F5 NGINX plus version (e.g. R21). The latter is available in `$version` variable. |

Note that many of the other security log attributes that are not included here have exact or similar parallels among the NGINX variables also available for access log. 

For example, **$request** is parallel to the **request** security log attribute.

```nginx
http {
    log_format security_waf 'request_time=$request_time client_ip=$remote_addr,'
                             'request="$request", status=$status,'
                             'waf_policy=$app_protect_policy_name, waf_request_id=$app_protect_support_id'
                             'waf_action=$app_protect_outcome, waf_action_reason=$app_protect_outcome_reason';

    server {

        location / {
            access_log /etc/app_protect/logs/nginx-access.log security_waf;
            ...
        }
    }
}
```