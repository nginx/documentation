---
---

{{<bootstrap-table "table table-striped table-bordered">}}
| Variable | Category | Description |
|----------|----------|-------------|
| **ENABLE_METRICS** | General | Enables or disables metrics collection and storage. Set to `false` to run in lightweight mode without ClickHouse. Defaults to `true`. |
| **NIM_MAINTENANCE** | General | Enables maintenance mode for backup, restore, and troubleshooting (`true` or `false`). |
| **NIM_LICENSE_MODE_OF_OPERATION** | General | Sets the license mode to either `connected` (default) or `disconnected`. |
| **NIM_LOG_LEVEL** | General | Sets the logging level for NGINX Instance Manager. |
| **NIM_METRICS_TTL** | General | Specifies the number of days to retain metrics. |
| **NIM_EVENTS_TTL** | General | Specifies the number of days to retain event logs. |
| **NIM_SECURITY_TTL** | General | Specifies the number of days to retain security violation logs. |
| **NIM_WATCHDOG_TIMEOUT** | General | Sets the timeout (in seconds) for the Data Plane Monitoring (DPM) watchdog. |
| **PROXY_ENABLE** | Forward Proxy | Enables or disables the use of a forward proxy (`true` or `false`). |
| **PROXY_HOST** | Forward Proxy | The IP address or hostname of the proxy server. |
| **PROXY_PORT** | Forward Proxy | The port number of the proxy server. |
| **PROXY_PROTOCOL** | Forward Proxy | The proxy protocol (`http` or `https`). |
| **PROXY_AUTH_REQUIRED** | Forward Proxy | Specifies whether authentication is required for the proxy (`true` or `false`). |
| **PROXY_USERNAME** | Forward Proxy | (Required if `PROXY_AUTH_REQUIRED=true`) The username for proxy authentication. |
| **PROXY_PASSWORD** | Forward Proxy | (Required if `PROXY_AUTH_REQUIRED=true`) The password for proxy authentication. |
| **PROXY_SSL_VERIFY** | Forward Proxy | Enables or disables SSL verification when `PROXY_PROTOCOL=https`. Default is `true`, meaning the proxy must have a valid certificate issued by a trusted Certificate Authority (CA). Set to `false` to allow self-signed or untrusted certificates (not recommended). |
{{</bootstrap-table>}}


