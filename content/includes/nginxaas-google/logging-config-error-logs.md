---
nd-docs: DOCS-000
---

NGINX error logs are disabled by default. You can enable error logs by adding **error_log** directives to your NGINX configuration to specify the location of the logs and formats. The log path should always be configured to be inside **/var/log/nginx**.

While you should configure log files in the **/var/log/nginx** directory, you can change the filename and severity level. For example, the following line in the NGINX configuration sends errors to the `nginx-error.log` file, and limits messages to a severity level of **emerg**:

```nginx
error_log /var/log/nginx/nginx-error.log emerg;
```

Alternatively, you can disable error logs completely with the following line:

```nginx
error_log /dev/null;
```

To learn more about how to specify `error_log` in different configuration levels, see the documentation of the [error_log](https://nginx.org/en/docs/ngx_core_module.html?#error_log) directive.
