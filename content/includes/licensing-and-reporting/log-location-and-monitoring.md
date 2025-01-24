---
docs:
---

Monitor the [NGINX error log](https://nginx.org/en/docs/ngx_core_module.html#error_log), typically located at `/var/log/nginx/error.log`, for subscription-related issues — such as failed usage reports or approaching license expirations — to catch problems early and keep your subscription compliant.

<br>

Examples of subscription-related log entries include:

- **Failure to upload usage reports**:

  ``` text
  [error] 36387#36387: server returned 500 for <fqdn>:<port> during usage report
  [error] 36528#36528: <fqdn>:<port> could not be resolved (host not found) during usage report
  [error] 36619#36619: connect() failed (111: Connection refused) for <fqdn>:<port> during usage report
  [error] 38888#88: server returned 401 for <ip_address>:443 during usage report
  ```

- **License approaching expiration**:

  ``` text
  [warn] license will expire in 14 days
  ```

- **License expiration**:

  ``` text
  [alert] license expiry; grace period will end in 89 days
  [emerg] license expired
  ```

  {{<important>}}When a license expires, NGINX Plus stops processing traffic.{{</important>}}