---
description: Learn about the F5 NGINX App Protect DoS Request Log Mechanism.
nd-docs: DOCS-668
title: NGINX App Protect DoS Access Log Request Mechanism
toc: true
weight: 160
type:
- how-to
---

## Access Logs
Access Log is NGINX’s request log mechanism. It is controlled by the following two directives.<br>

### log_format
This directive determines the format of the log messages using predefined variables. App Protect DoS will enrich this set of variables with several security log attributes that are available to be included in the `log_format`. If `log_format` is not specified then the built-in format `combined` is used but, because that format does not include the extended App Protect DoS variables, this directive must be used when the user wants to add App Protect DoS information to the log.

### access_log
This directive determines the destination of the `access_log` and the name of the format according to the official [F5 NGINX documentation](https://docs.nginx.com).

For example: `access_log /var/log/nginx/access.log log_dos`; (`log_dos` is predefined in the log_format directive).

## App Protect Variables for Access Log
These are the variables added to Access Log. They are a subset of the Security log attributes. The Security log names are prefixed with `$app_protect_dos`.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Name| Meaning                                                                                                                                                                                                                                                                                                                                                                                                                                              |Comment|
|--- |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------ |
|`$app_protect_dos_outcome`| One of: <br> **Allow**: request was sent to origin server <br> **Redirect**: http redirection <br> **Challenge**: JS challenge <br> **Block**: blocked request                                                                                                                                                                                                                                                                                       ||
|`$app_protect_dos_outcome reason`| One of: <br> **Allow**: Request not mitigated, passed DoS flow successfully. <br> **Allowlist**: Request not mitigated because it is on the allowlist. <br> **Bypass**: Request not mitigated due to internal failure. <br> **Bad_Actor:**: Request mitigated as a bad actor. <br> **Signature**: Request mitigated as a matched DoS attack signature. <br> **Global_Rate**: Request mitigated as exceeding the calculated global request rate. <br> **Slow_Body**: Request mitigated due to being a slow request. |Combine `MITIGATED_BY_GLOBAL_RATE` with global rate value (in RPS) for example `Global_Rate, value=152,`  |
|`$app_protect_dos_tls_fp`| TLS Fingerprint - a value which identifies the sender                                                                                                                                                                                                                                                                                                                                                                                                |Applicable only in TLS (SSL) traffic|
|`$app_protect_dos_policy_name`| The name of the policy that enforced the request                                                                                                                                                                                                                                                                                                                                                                                                     ||
|`$app_protect_dos_vs_name`| The name of the protected object                                                                                                                                                                                                                                                                                                                                                                                                                     ||
|`$app_protect_dos_version`| The App Protect DoS version string: <br> major.minor.build format.                                                                                                                                                                                                                                                                                                                                                                                   |Does not include the F5 NGINX plus version (e.g. R21). The latter is available in `$version` variable.|

{{</bootstrap-table>}}

   {{< note >}}
Many of the other Security log attributes that are not included here have exact or similar parallels among the NGINX variables also available for access log. For example, `$request` is parallel to the `request` security log attribute. See the full list of [NGINX variables](https://nginx.org/en/docs/http/ngx_http_log_module.html).
   {{< /note >}}


## Logging Rate Limit - mandatory configuration

During a DoS attack, there is a large quantity of incoming requests which can flood the Access Log.
The rate of the access log's entries can be limited in order to avoid this flood.

NGINX logs all the requests during peacetime and logs up to 10 entries per second for each outcome reason during attack time. In worst case it can be 50 requests per second under attack.

Two things should be configured in the `nginx conf` file:

1. Create a variable called `loggable` using NGINX's `set` directive and give it any value (string or numerical). <br>
    Note that the scope of the `set` directive is **server** or **location** block. <br>
    For example: **set $loggable '1'**;

2. Add the string **"if=$loggable"** to the **access_log** directive's argument.
    For example: access_log /var/log/nginx/access.log custom **if=$loggable**;

## Example

```nginx
http {
    log_format security_dos 'request_time=$request_time client_ip=$remote_addr,'
                            'request="$request", status=$status,'
                            'dos_policy=$app_protect_dos_policy_name, dos_protected_object=app_protect_dos_vs_name'
                            'dos_action=$app_protect_dos_outcome, dos_action_reason=$app_protect_dos_outcome_reason';

    server {
        location / {
            set $loggable 1;
            access_log /var/log/nginx/access.log security_dos if=$loggable;;
            ...
        }
    }
}
```
