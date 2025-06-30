---
description: How to download the F5 NGINX Plus nginx.crt and nginx.key files using
  the NGINX Controller API.
nd-docs: DOCS-252
title: Download the NGINX Plus Cert and Key Bundle
toc: true
weight: 105
type:
- how-to
---

## Overview

This topic explains how to use the [F5 NGINX Controller REST API](https://docs.nginx.com/nginx-controller/api/ctlr-platform-api/) to download your NGINX Plus `nginx.crt` and `nginx.key` files. You'll need these files if you're [installing NGINX Plus as part of an NGINX Controller trial]({{< ref "/controller/admin-guides/install/try-nginx-controller.md" >}}).

&nbsp;

## Authenticate with the NGINX Controller API

The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:

  ```curl
  curl -c cookie.txt -X POST --url 'https://<ip address>/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "<username>","password": "<password>"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://<ip address>/api/v1/platform/login'
  ```


&nbsp;

---

## Download the NGINX Plus Certificate and Key Bundle

To use the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to download your NGINX Plus certificate and key bundle as a gzip or JSON file, send a GET request to the `/platform/licenses/nginx-plus-licenses/controller-provided` endpoint.

For example:

- Download JSON file:

  ```bash
  curl -b cookie.txt -c cookie.txt --header 'Content-Type: application/json' -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided'  --output nginx-plus-certs.json
  ```

- Download GZIP file:

  ```bash
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided' --output nginx-plus-certs.gz
  ```

{{< note >}}
If you are using a self-signed certificate you will need to add `-k` (allow insecure connections) to your curl command to be able to download your NGINX Plus certificate and key bundle.
{{< /note >}}


Once you have downloaded your certificate and key bundle you will need to expand the `.gz` file to get your certificate and key pair.

For example:

```bash
gunzip nginx-plus-certs.gz
```

---

## What's Next

- [Trial NGINX Controller with NGINX Plus]({{< ref "/controller/admin-guides/install/try-nginx-controller.md" >}})

&nbsp;

{{< versions "3.10" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
