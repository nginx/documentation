---
title: "Module Changelog"
weight: 950
toc: true
url: /nginxaas/azure/module-changelog/
---

Learn about the modules supported by the latest versions of F5 NGINXaaS for Azure.


## Access module versions using data plane API:

To access available module versions from the data plane API, follow these steps:
- View Your API Endpoints and Create an API Key
  - Follow the [NGINXaaS data plane API endpoint]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#nginxaas-data-plane-api-endpoint" >}}) and [Create an NGINXaaS data plane API key]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#create-an-nginxaas-data-plane-api-key" >}}) to locate your dataplane API endpoint and create an API key.

- Construct the Request URL
    - Add `/packages` to your data plane API endpoint, for example `https://<your-endpoint>/packages`.

- Authenticate API requests
   - Encode your API key to Base64 and add the prefix `ApiKey` to the encoded string.
   - Set the `Authorization` HTTP header to:  
     `ApiKey <your_hashed_api_key>`


```shell
   curl -H "Authorization: ApiKey <your_hashed_api_key>" https://<your-endpoint>/packages
```

Response Example:
```json
{
  "packages": [
    {
      "name": "nginx-plus-module-headers-more",
      "version":"35+0.37-1~jammy"
    },
    {
      "name": "nginx-plus-module-otel",
      "version": "35+0.1.2-1~jammy"
    },
    ...
  ]
}
```


## July 03, 2025 

### Stable

 {{< table >}}

| Name                                     | Version                  | Description                                                            |
|------------------------------------------|--------------------------|------------------------------------------------------------------------|
| nginx-plus                               | 1.27.2 (nginx-plus-r33-p2)    | NGINX Plus, provided by Nginx, Inc.                          |
| nginx-agent                              | 1.19.15-1795423089  | NGINX Agent - Management for NGINXaaS                                  |
| Operating System                         | Ubuntu 22.04.5      | Jammy Jellyfish, provided by Canonical Ltd.                            |
| nginx-plus-module-geoip2                 | 33+3.4-1            | NGINX Plus 3rd-party GeoIP2 dynamic modules                            |
| nginx-plus-module-headers-more           | 33+0.37-1           | NGINX Plus 3rd-party headers-more dynamic module                       |
| nginx-plus-module-image-filter           | 33-1                | NGINX Plus image filter dynamic module                                 |
| nginx-plus-module-lua                    | 33+0.10.27-1        | NGINX Plus 3rd-party Lua dynamic modules                               |
| nginx-plus-module-ndk                    | 33+0.3.3-1          | NGINX Plus 3rd-party NDK dynamic module                                |
| nginx-plus-module-njs                    | 33+0.8.9-1          | NGINX Plus njs dynamic modules                                         |
| nginx-plus-module-otel                   | 33+0.1.0-1          | NGINX Plus OpenTelemetry dynamic module                                |
| nginx-plus-module-xslt                   | 33-1                | NGINX Plus xslt dynamic module                                         |
| nginx-plus-module-appprotect             | 33+5.264.0-1        | NGINX Plus app protect dynamic module version 5.264.0                  |
| app-protect-module-plus                  | 33+5.264.0-1        | App-Protect package for Nginx Plus, includes all of the default files and examples. NGINX App Protect provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10 attacks. |
| app-protect-plugin                       | 6.9.0-1             | NGINX App Protect plugin |
{{< /table >}}



### Preview

 {{< table >}}

| Name                                     | Version                  | Description                                                            |
|------------------------------------------|--------------------------|------------------------------------------------------------------------|
| nginx-plus                               | 1.27.2 (nginx-plus-r33-p2)    | NGINX Plus, provided by Nginx, Inc.                          |
| nginx-agent                              | 1.19.15-1795423089  | NGINX Agent - Management for NGINXaaS                                  |
| Operating System                         | Ubuntu 22.04.5      | Jammy Jellyfish, provided by Canonical Ltd.                            |
| nginx-plus-module-geoip2                 | 33+3.4-1            | NGINX Plus 3rd-party GeoIP2 dynamic modules                            |
| nginx-plus-module-headers-more           | 33+0.37-1           | NGINX Plus 3rd-party headers-more dynamic module                       |
| nginx-plus-module-image-filter           | 33-1                | NGINX Plus image filter dynamic module                                 |
| nginx-plus-module-lua                    | 33+0.10.27-1        | NGINX Plus 3rd-party Lua dynamic modules                               |
| nginx-plus-module-ndk                    | 33+0.3.3-1          | NGINX Plus 3rd-party NDK dynamic module                                |
| nginx-plus-module-njs                    | 33+0.8.9-1          | NGINX Plus njs dynamic modules                                         |
| nginx-plus-module-otel                   | 33+0.1.0-1          | NGINX Plus OpenTelemetry dynamic module                                |
| nginx-plus-module-xslt                   | 33-1                | NGINX Plus xslt dynamic module                                         |
| nginx-plus-module-appprotect             | 33+5.264.0-1        | NGINX Plus app protect dynamic module version 5.264.0                  |
| app-protect-module-plus                  | 33+5.264.0-1        | App-Protect package for Nginx Plus, includes all of the default files and examples. NGINX App Protect provides web application firewall (WAF) security protection for your web applications, including OWASP Top 10 attacks. |
| app-protect-plugin                       | 6.9.0-1             | NGINX App Protect plugin |
{{< /table >}}
