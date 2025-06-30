---
description: Learn the types of logs available in F5 NGINX App Protect WAF v5.
nd-docs: DOCS-1374
title: NGINX App Protect WAF Logs Overview
toc: true
weight: 1010
type:
- concept
---

## Log Types

Logs in F5 NGINX App Protect WAF v5 can be accessed and configured similarly to NGINX App Protect WAF, though there are some differences in the process.

### NGINX Access Log

NGINX App Protect WAF v5 can be configured to add additional data to NGINX [Access log]({{< ref "/nap-waf/v5/logging-overview/access-log" >}}).

### Security Logs

A key change in configuring [Security logs]({{< ref "/nap-waf/v5/logging-overview/security-log" >}}) is the requirement to [compile JSON logging profiles]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#logging-profile-compilation" >}}) into a bundle file before applying them.

#### Default Logging Profile Bundles

There are several pre-compiled logging profile bundles available:

- log_default (equivalent to log_illegal)
- log_all
- log_illegal
- log_blocked
- log_grpc_all
- log_grpc_blocked
- log_grpc_illegal

These logging profiles can be referenced by their names, excluding the file path and the `tgz` extension.

For instance:

```nginx
    ...
    location / {

        # NGINX App Protect WAF
        app_protect_enable on;
        app_protect_security_log_enable on;
        app_protect_security_log log_blocked syslog:server=log-server:514;

        proxy_pass http://127.0.0.1:8080/;
    }
```

#### Security Log Destination

Please refer to [Security logs]({{< ref "/nap-waf/v5/logging-overview/security-log" >}}) page for details.

#### WAF Enforcer Container Logs

When `stderr` is set as the destination for security logs in the `app_protect_security_log` directive, these logs are accessible via the `waf-enforcer` container. To view them, use the following command:

```shell
docker logs waf-enforcer
```

Or in Kubernetes:

```shell
kubectl logs deployment.apps/nap5-deployment -c waf-enforcer
```

### Debug Logs

Logs for internal components of NGINX App Protect 5 can be accessed by executing `docker logs` or `kubectl logs` on one of the deployment containers. For example:

```shell
docker logs waf-config-mgr
```
