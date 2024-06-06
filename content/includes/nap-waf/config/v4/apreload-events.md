---
docs: "DOCS-1535"
---

apreload events use the same format as the current operation log events written in the NGINX error log, namely: `configuration_load_success` or `configuration_load_failure` with the details in JSON format. Refer to the [Operation logs]({{< relref "/nap-waf/v4/logging-overview/operation-logs.md" >}}) for more details.

{{< note >}}
Note that if any of the configuration files are invalid, apreload will discover that and return the proper error message in the `configuration_load_failure` event. The Enforcer continues to run with the previous configuration.{{< /note >}}