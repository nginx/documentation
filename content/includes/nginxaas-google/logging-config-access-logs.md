---
nd-docs: DOCS-000
---

NGINX access logs are disabled by default. You can enable access logs by adding **access_log** directives to your NGINX configuration to specify the location of the logs and formats. The log path should always be configured to be inside **/var/log/nginx**.

```nginx
http {
	log_format myfmt '$remote_addr - $remote_user [$time_local] '
						   '"$request" $status $body_bytes_sent '
						   '"$http_referer" "$http_user_agent" "$gzip_ratio"';

	access_log /var/log/nginx/nginx-access.log myfmt;
	# ...
}
```

{{< call-out "note" >}} The **$time_local** variable includes the date and time for each log. It helps with ordering logs after export. {{< /call-out >}}

To explicitly disable access logs, apply the following config:

```nginx
http {
	access_log off;
}
```

or

```nginx
http {
	access_log /dev/null;
}
```

To learn more about how to specify `access_log` in different configuration levels and their effect, see [access_log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)

{{< call-out "warning" >}}Keep NGINX logs in the **/var/log/nginx** directory. Otherwise, you may lose data from your logs.
{{< /call-out >}}
