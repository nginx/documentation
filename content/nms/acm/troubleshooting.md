---
description: This topic describes possible issues users might encounter when using
  API Connectivity Manager. When possible, suggested workarounds are provided.
docs: DOCS-1222
title: Troubleshooting
toc: true
weight: 1000
type:
- reference
---

## System returns `403 Forbidden` error for authorized resources

### Description

Users are unable to access API Connectivity Manager features that they've been granted permission for.

The system returns errors similar to the following examples:

- Web interface error: "ACM license not found."

- API error: "Error accessing resource: forbidden. Please contact the system administrator. User has not been granted `READ` permission."

### Resolution

New roles require a minimum of `READ` access for the **Licensing** feature. Without `READ` access for **Licensing**, users will be unable to access pages for which they have been granted permission; instead, the system will return `403 Forbidden` errors as licensing errors.

---

## API Connectivity Manager module doesn't show up in the web interface

### Description

After installing the API Connectivity Manager module, the module doesn't appear in the F5 NGINX Management Suite web interface.

### Resolution

- Force refresh the web page.
- Restart the API Connectivity Manager service:

  ```bash
  sudo systemctl restart nms-acm
  ```

---

## Routing traffic fails with `RangeError: Maximum call stack size exceeded` in the data plane error logs

### Description

After deploying an API Proxy using a large OpenAPI Specification or a large number of advanced routes, traffic fails to route to the backend service and instead returns a `404` error. Failed requests trigger `js exception: RangeError: Maximum call stack size exceeded` in the data plane logs.

The number API proxy advanced routes which can be deployed to a single API proxy is dependent on the complexity of the configuration, so it is not possible to give an exact limit; however, the table below illustrates some limits based on example configurations. For example, if all of your routes support a single method and have two non-enum query parameters, your configuration should be able to support up to 440 routes per API proxy. Enum parameters are not illustrated in the table below but will reduce the number of supported routes more significantly than a non-enum parameter.

{{< bootstrap-table "table table-striped table-bordered" >}}

| Path/Route methods | Query parameters | Supported number of Paths/Advanced Routes |
| ------------------ | ---------------- | ----------------------------------------- |
| 1                  | 0                | 1100                                      |
| 1                  | 1+               | 440                                       |
| 2                  | 0                | 550                                       |
| 2                  | 1+               | 220                                       |
| 3                  | 0                | 360                                       |
| 3                  | 1+               | 140                                       |
| 4                  | 0                | 270                                       |
| 4                  | 1+               | 110                                       |
|                    |                  |                                           |

{{< /bootstrap-table >}}

{{< note >}}
The numbers in the above table are provided only as an example. Other factors may impact the total supported number of routes.
{{< /note >}}

### Resolution

- The limitations are for a single API proxy. Splitting your configuration and deploying it across multiple API proxies may resolve the issue. For example:
  - Given an OpenAPI specification with contains 1500 routes with a single method and no parameters
  - 800 paths in the specification begin with `/v1`, and 700 begin with `/v2`
  - Splitting the definition into two definitions, with one containing all of the `/v1` paths and the other containing all of the `/v2` paths, should allow deployment of two API proxies which cover all of the paths defined, each one below the 1100 route limit
- Replacing enum parameters with non-enum parameters may increase the number of routes which can be deployed

---

## Can't delete API Connectivity Manager objects after upgrading NGINX instances

### Description

After upgrading NGINX Plus instances to R27, you may not be able to delete Environments, Proxies, or Dev Portals in the API Connectivity Manager module.

### Resolution

Try restarting the NGINX Agent after upgrading NGINX.

- To restart the NGINX Agent, run the following command:

  ``` bash
  sudo systemctl restart nginx-agent
  ```

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}

