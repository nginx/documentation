---
title: "Module Changelog"
weight: 300
toc: true
url: /nginxaas/azure/module-changelog/
---

Learn about the modules supported by the latest versions of F5 NGINXaaS for Azure.

## Access module versions using data plane API:

To view the version of the NGINX Plus modules that are part of your deployment, follow these steps:
- Retrieve your [data plane API endpoint]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#nginxaas-data-plane-api-endpoint" >}}).

- Create an [API key]({{< ref "/nginxaas-azure/loadbalancer-kubernetes.md#create-an-nginxaas-data-plane-api-key" >}}) if you do not already have one.

- Construct the package request URL.
    - Add **/packages** to your data plane API endpoint.
    - For example: `https://my-deployment-b7e43dfb7e26.eastus.nginxaas.net/packages`

- Authenticate the API requests using the **Authorization** HTTP header.
   - Encode your API key to **base64** and add the prefix **ApiKey** to the encoded string.
   - For example: 
      - Authorization: ApiKey ZjkzY2ZlYWItZjAxNS01MDAwLTgyM2UtNjBmNjY5ZTUwOWF2

Request Example:
```shell
   curl -H "Authorization: ApiKey <your_base64_api_key>" https://<your-dataplane-api-endpoint>/packages
```

Response Example:
```json
{
  "packages": [
    {
      "name": "nginx-plus",
      "version": "33-4~jammy"
    },
    {
      "name": "nginx-agent",
      "version": "1.20.15-2010533110"
    },
    {
      "name": "nginx-plus-module-appprotect",
      "version": "33+5.264.0-1~jammy"
    },
    {
      "name": "nginx-plus-module-ndk",
      "version": "33+0.3.3-1~jammy"
    },
    {
      "name": "nginx-plus-module-njs",
      "version": "33+0.8.9-1~jammy"
    },
    ...
  ]
}
```
