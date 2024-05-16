---
description: Reference for using the NGINX Instance Manager API
docs: DOCS-636
title: API Reference
toc: true
weight: 300
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help people use the NGINX Instance Manager API.

## Prerequisites {#prerequisites}

Install NGINX Instance Manager and know what port the API and web interface are listening on (`11000` by default).

## Usage {#usage}

Use curl, postman, or another tool to call the API. The API will be in the format `https://nginx-manager.example.com:11000/api/v0/`. You might be using HTTP if you didn't set SSL certificates on the proxy or in the config).

For example, to call the instances in a GET call, you can run a curl command similar to the following:

```bash
curl -X GET "https://nginx-manager.example.com/api/v0/instances" -H  "accept: application/json"
```

## Swagger-UI {#swaggerui}

You can also find examples of all the calls available through the swagger-ui page, installed by default with nginx-manager. Point your browser to the Instance Manager web interface URL and append `/swagger-ui` to the end to access this page. For example, `https://nginx-manager.example.com:11000/swagger-ui`.

You can select the "Try it out" button and run the calls directly against your server. For example, a GET of instances is shown below.

### Swagger-UI JSON {#swaggerui-json}

To download the swagger-ui JSON, point to the above address and append `/lightning.swagger.json` to the end. For example, `https://nginx-manager.example.com:11000/swagger-ui/lightning.swagger.json`.
