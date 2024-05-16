---
description: This topic describes possible issues users might encounter when using
  the NGINX Management Suite platform. When possible, suggested workarounds are provided.
docs: DOCS-1221
doctypes:
- reference
tags:
- docs
title: Troubleshooting
toc: true
weight: 1000
---

## System returns "502 Upstream Unavailable" after installation</summary>

### Description

After installing NGINX Management Suite, when accessing the web interface, the system returns the error "502 Upstream Unavailable."

### Resolution

If you have SELinux installed, you need to load the SELinux policy module that's included with NGINX Management Suite. For instructions, refer to the [Configure SELinux]({{< relref "/nms/admin-guides/configuration/configure-selinux.md" >}}) topic.

---

## NGINX proxy gateway warns "1024 worker_connections are not enough"</summary>

### Description

If the NGINX proxy gateway for NGINX Management Suite alerts you that there are not enough worker connections, you may need to modify the NGINX configuration (`/etc/nginx/nginx.conf` on the NGINX Management Suite host) to allow more worker connections and increase the number of file descriptors for worker processes.

### Resolution

- For guidance on increasing the number of worker connections and file descriptors for the NGINX proxy gateway for NGINX Management Suite, refer to the guide [Optimize NGINX Proxy Gateway for Large Data Planes]({{< relref "/nms/admin-guides/configuration/configure-gateway.md" >}}).

---

## Unable to retrieve entitlements

If you are using a JWT license, make sure to allow inbound and outbound access on port 443 to the following URLs:

- <https://product.apis.f5.com>
- <https://product-s.apis.f5.com/ee>

---

## How to Get Support

{{< include "support/how-to-get-support.md" >}}
