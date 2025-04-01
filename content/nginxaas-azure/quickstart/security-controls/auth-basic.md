---
title: Restricting access with HTTP basic authentication
weight: 100
toc: true
docs: DOCS-990
url: /nginxaas/azure/security-controls/auth-basic/
type:
- how-to
---

You can restrict access to resources by implementing username/password authentication using the "HTTP Basic Authentication" protocol.

For more information on configuring HTTP Basic Authentication please refer to the [NGINX Plus Restricting Access with HTTP Basic Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/) documentation.

## Uploading a password file

F5 NGINX as a Service for Azure (NGINXaaS) accepts a file containing usernames and passwords using any of the password types specified in the [NGINX documentation](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file). The password file can be uploaded as a "protected file" when creating or updating your NGINX configuration to protect the file's contents from being read. The password file can alternatively be uploaded as a regular file.

{{< img src="nginxaas-azure/auth-basic-htpasswd.png" alt="Screenshot of the Azure portal showing the password file upload" >}}

## Configuring NGINX Plus for HTTP basic authentication

Inside the location or server you are protecting, specify the [`auth_basic`](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic) directive giving a name to the password-protected area. Specify the [`auth_basic_user_file`](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file) directive referencing the password file.

```nginx
location /protected {
    auth_basic           "Protected Area";
    auth_basic_user_file /opt/.htpasswd;
}
```

Submit the NGINX configuration to apply it. You should be prompted to log in when you access the protected location or server.

{{<note>}}The NGINX worker processes will open the password file. You must place the password file in a [directory the worker processes are allowed to read]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#nginx-filesystem-restrictions" >}}) or else all authenticated requests will fail.{{</note>}}

- `/opt`
- `/srv`
- `/var/www`
