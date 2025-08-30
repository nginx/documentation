---
title: Access logs
toc: false
weight: 200
nd-content-type: reference
nd-product: NAP-WAF
---

## Access Logs

Access log is NGINX's request log mechanism. It is controlled by two directives.

### log_format

This directive determines the format of the log messages using predefined variables. App Protect will enrich this set of variables with several security log attributes that are available to be included in the **log_format**.  If **log_format** is not specified then the built-in format **combined** is used but, because that format does not include the extended App Protect variables, this directive must be used when the user wants to add App Protect information to the log.

### access_log
This directive determines the destination of the **access_log** and the name of the format. The default is the file `/etc/nginx/log/access.log` using the combined format. In order to use the custom format that includes the NAP variables, use this directive with the name of the desired format.

### App Protect Variables for Access Log

These are the variables added to Access Log. They are a subset of the Security log attributes. The Security log names are prefixed with **$app_protect**.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Name | Meaning | Comment |
| ---| ---| --- |
|$app_protect_support_id | Unique ID assigned to the request by App Protect. | To be used to correlate the access log with the security log.<br>       Left empty in failure mode. |
|$app_protect_outcome | One of:<ul><li>**PASSED**: request was sent to origin server.</li><li>**REJECTED**: request was blocked.</li></ul> |  |
|$app_protect_outcome_reason | One of:<ul><li>**SECURITY_WAF_OK**: allowed with no violations (legal request).</li><li>**SECURITY_WAF_VIOLATION**: blocked due to security violations.</li><li>**SECURITY_WAF_FLAGGED**: allowed although it has violations (illegal).</li><li>**SECURITY_WAF_BYPASS**: WAF was supposed to inspect the request but it didn't (because of unavailability or resource shortage). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li><li>**SECURITY_WAF_REQUEST_IN_FILE_BYPASS**: WAF was supposed to inspect the request but it didn't (because request buffer was full and request was written to file). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li><li>**SECURITY_WAF_COMPRESSED_REQUEST_BYPASS**: WAF was supposed to inspect the request but it didn't (because request was compressed). The request was PASSED or REJECTED according to the failure mode action determined by the user.</li></ul> |  |
|$app_protect_policy_name | The name of the policy that enforced the request. |  |
|$app_protect_version | The App Protect version string: major.minor.build format. | Does not include the F5 NGINX plus version (e.g. R21). The latter is available in `$version` variable. |
{{</bootstrap-table>}}


Note that many of the other Security log attributes that are not included here have exact or similar parallels among the NGINX variables also available for access log. For example, **$request** is parallel to the **request** security log attribute. See the full list of NGINX variables.

### Example

~~~nginx
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
~~~