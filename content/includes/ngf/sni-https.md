---
nd-product: FABRIC
---

## HTTPS Traffic without SNI (Server Name Indication)

Some frontend load balancers strip out SNI information before the traffic reaches the NGINX gateway. In order for NGINX to still process and forward this traffic properly, you must define your HTTPS Listener without a hostname. This instructs NGINX Gateway Fabric to configure a default HTTPS virtual server to handle non-SNI traffic. The TLS configuration on this Listener will be used to verify and terminate TLS for this traffic, before the Host header is then used to forward to the proper virtual server to handle the request. You can attach your HTTPRoutes to this empty Listener.

By default, NGINX Gateway Fabric verifies that the Listener hostname matches both the SNI and Host header on an incoming client request. This does not require the SNI and Host header to be the same. This is to avoid misdirected requests, and returns a 421 response code. If you run into issues and want to disable this SNI/Host verification, you can update the [NginxProxy CRD]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) with the following field in the spec:

```yaml
spec:
  disableSNIHostValidation: true
```
