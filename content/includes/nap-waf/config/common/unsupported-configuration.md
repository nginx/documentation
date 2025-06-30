---
nd-docs: "DOCS-1569"
---

There are some NGINX features that don't work well with NGINX App Protect WAF. Modules that use subrequest do not work when calling or being called from a scope that contains `app_protect_enable on`. Other modules that expect to receive the Range header (Slice for example) are also unsupported in the same scope as `app_protect_enable on`. For example, the following configuration is unsupported, but in the examples above you can find examples of work arounds for these features.

```nginx
load_module modules/ngx_http_app_protect_module.so;

http {
    server {
        listen 127.0.0.1:8080;
        server_name localhost;

        location / {
            app_protect_enable on;
            proxy_pass http://1.2.3.4$request_uri;
            slice 2;
            proxy_set_header Range $slice_range;
        }
    }
}
```