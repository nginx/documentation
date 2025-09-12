---
title: Use the njs Scripting language
weight: 400
toc: true
nd-docs: DOCS-874
url: /nginxaas/azure/quickstart/njs-support/
type:
- how-to
---

F5 NGINXaaS for Azure (NGINXaaS) supports the open-source [njs module](https://nginx.org/en/docs/http/ngx_http_js_module.html), allowing the extension of NGINX functionality with a subset of the Javascript language.

## Upload NGINX configuration with njs

Create an njs script file by uploading a gzipped tar file or create the script file in the editor. See [NGINX Configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}) for a step-by-step guide.

{{< call-out "note" >}}If specifying an absolute file path as your njs script's `File path`, see the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to.{{< /call-out >}}

Switch between the language options to see syntax highlighting for NGINX configs or JavaScript.

To use njs, enable the `ngx_http_js_module` module and specify the `js_import` directive with your njs file.

```nginx
load_module modules/ngx_http_js_module.so;

http {
    js_import http.js;

    server {
        location / {
            js_content http.hello;
        }
    }
}
```

## njs validation

NGINXaaS will not parse, evaluate, or run any provided njs scripts when validating the NGINX configuration. [Enable logging]({{< ref "/nginxaas-azure/monitoring/enable-logging/" >}}) to monitor errors caused by njs scripts.

## "fs" module

The njs [File System module](http://nginx.org/en/docs/njs/reference.html#njs_api_fs) provides operations with files. NGINXaaS only allows reading and writing from [specified directories]({{< ref "/nginxaas-azure/getting-started/nginx-configuration.md#nginx-process-restrictions" >}}).
