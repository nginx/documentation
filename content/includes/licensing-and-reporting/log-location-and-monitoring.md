---
docs:
---

Monitor the [NGINX error log](https://nginx.org/en/docs/ngx_core_module.html#error_log), usually located at `/var/log/nginx/error.log`, to identify subscription issues early. The log records problems such as failed usage reports or licenses that are close to expiring. Checking regularly helps you avoid downtime and stay compliant.

<br>

Examples of log entries include:

- **Failed usage reports:**

  ``` text
  [error] 36387#36387: server returned 500 for <fqdn>:<port> during usage report
  [error] 36528#36528: <fqdn>:<port> could not be resolved (host not found) during usage report
  [error] 36619#36619: connect() failed (111: Connection refused) for <fqdn>:<port> during usage report
  [error] 38888#88: server returned 401 for <ip_address>:443 during usage report
  ```

- **License nearing expiration:**

  ``` text
  [warn] license will expire in 14 days
  ```

- **License expired:**

  ``` text
  [alert] license expiry; grace period will end in 89 days
  [emerg] license expired
  ```

  {{< call-out "important" "Important" >}}When a license expires, NGINX Plus stops processing traffic.{{< /call-out >}}