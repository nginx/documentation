---
title: Proxy Buffer Configuration Auto-Adjustment
toc: true
weight: 850
nd-docs: DOCS-590
---

This document explains how the `--with-directive-autoadjust` option prevents NGINX configuration errors by automatically adjusting HTTP proxy buffer directives.

---
## What it does

The `--with-directive-autoadjust` feature automatically fixes common proxy buffer configuration mistakes that would otherwise cause NGINX to fail with errors like:

```text
[emerg] "proxy_busy_buffers_size" must be less than the size of all "proxy_buffers" minus one buffer
```

**What gets fixed:**
- If you don't specify `proxy_buffers`, it sets a sensible default of `8 4k`
- If your `proxy_busy_buffers_size` is too large, it reduces it to a safe value
- If the number of proxy buffers is outside the valid range (minimum 2, maximum 1024), it gets clamped to those limits
- Empty or invalid buffer settings get corrected automatically

**Works with:**
- [ConfigMap settings]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#general-customization" >}})
- [Ingress annotations]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-annotations/#general-customization" >}})
- [VirtualServer upstream buffer configurations]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources/#upstream" >}})
---

## How to enable auto-adjustment
{{<tabs name="enable-auto-adjustment">}}
{{% tab name="Manifests" %}}
Add the flag to the controller container:
```yaml
    args:
      - --with-directive-autoadjust=true
```
{{% /tab %}}
{{% tab name="Helm" %}}
Enable via the Helm chart values file:
```yaml
controller:
    directiveAutoAdjust: "true"
```
{{% /tab %}}
{{</tabs>}}

---
## Examples

### Example 1

**Input:**
```yaml
data:
    proxy-buffer-size: "5m"
    proxy-buffers: "8 1m"  
```

{{<tabs name="example1-result">}}

{{% tab name="Before (Error)" %}}

Before enabling `--with-directive-autoadjust`, NGINX fails to start with configuration validation errors.

```shell
stderr: "2025/08/26 14:29:49 [emerg] 196#196: "proxy_busy_buffers_size" must be less than the size of all "proxy_buffers" minus one buffer in /etc/nginx/nginx.conf:121"
```

{{% /tab %}}

{{% tab name="After (Fixed)" %}}

With `--with-directive-autoadjust`, the configuration is automatically adjusted:

```nginx
		proxy_buffers 8 1m;
		proxy_buffer_size 5m;
		proxy_busy_buffers_size 5m;       
```

Logs:
```text
I20250826 14:31:54.515490   1 configmaps.go:380] Changes made to proxy values: adjusted proxy_busy_buffers_size from  to 5m because it was too small
```

{{% /tab %}}

{{</tabs>}}

### Example 2

**Input:**
```yaml
data:
  proxy-buffers: "1000000 1m"   # Extremely high buffer count
  proxy-buffer-size: "999m"     # Very large buffer size
  proxy-busy-buffers-size: "500m"
```

{{<tabs name="example2-result">}}

{{% tab name="Before (Error)" %}}

```shell
stderr: "2025/08/26 14:34:46 [emerg] 47#47: "proxy_busy_buffers_size" must be equal to or greater than the maximum of the value of "proxy_buffer_size" and one of the "proxy_buffers" in /etc/nginx/nginx.conf:121\n"
```

{{% /tab %}}

{{% tab name="After (Fixed)" %}}

With `--with-directive-autoadjust`, sensible defaults are applied:

```shell
		proxy_buffers 1024 1m;
		proxy_buffer_size 999m;
		proxy_busy_buffers_size 999m;
```

Logs:
```shell
I20250826 14:36:47.864375   1 configmaps.go:380] Changes made to proxy values: adjusted proxy_buffers number from 1000000 to 1024
I20250826 14:36:47.864389   1 configmaps.go:380] Changes made to proxy values: adjusted proxy_busy_buffers_size from 500m to 999m because it was too small
```

{{% /tab %}}

{{</tabs>}}

---
## Monitoring and logging

The controller outputs a log message whenever any of the proxy buffer directives are changed. Examples:

```text
I20250826 14:06:43.734757   1 annotations.go:341] Changes made to proxy values: adjusted proxy_buffer_size from 512k to 64k because it was too big for proxy_buffers (2 64k)
I20250826 14:06:43.734842   1 annotations.go:341] Changes made to proxy values: adjusted proxy_busy_buffers_size from  to 64k because it was too small
```

View adjustment logs:
```bash
kubectl logs <pod-name> -n <namespace> | grep "Changes made to proxy values"
```