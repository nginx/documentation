---
docs: "DOCS-1519"
---

Security log for gRPC requests has unique fields: `uri`, `grpc_method`, and `grpc_service`. Also, since the content of gRPC requests is binary (Protocol Buffers), it is better transferred in Base64 encoding. Hence, it is recommended to use the `headers` and `request_body_base64` fields instead of the `request` field. A new predefined log format called `grpc` should be used in all gRPC locations that also use policies with gRPC Content Profiles.
The `grpc` format also contains the above new gRPC fields (`grpc_service` and `grpc_method`). See [Available Security Log Attributes]({{< relref "/nap-waf/v4/logging-overview/security-log#available-security-log-attributes" >}}).

NGINX App Protect WAF provides three security log configuration files for gRPC: `log_grpc_all.json`, `log_grpc_illegal.json` and `log_grpc_blocked.json` using the `grpc` format with three filters: all requests, illegal requests, and blocked requests respectively. Unless you have special logging format requirements, the best practice is to use one of these files in all gRPC locations with the `app_protect_security_log` directive. These log configuration files are located in: `/opt/app_protect/share/defaults`.

Here is a typical example:

```nginx
server {
    server_name my_grpc_service.com;
    location / {
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/policies/policy_with_grpc_profile.json";
        app_protect_security_log_enable on;
        app_protect_security_log "/opt/app_protect/share/defaults/log_grpc_all.json" stderr;
        grpc_pass grpcs://grpc_backend;
    }
}
```