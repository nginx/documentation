---
nd-product: NIMNGR
nd-files:
- content/nim/waf-integration/configuration/_index.md
- content/nim/waf-integration/configuration/install-waf-compiler/install-disconnected.md
- content/nim/waf-integration/configuration/install-waf-compiler/install.md
---

Make sure you’ve completed the following tasks:

- You have one or more [F5 WAF for NGINX]({{< ref "/waf/" >}}) instances running.  
  For supported versions, see [Support for F5 WAF for NGINX]({{< ref "/nim/fundamentals/tech-specs.md#f5-waf" >}}).

  {{< call-out "note" >}}
  If you plan to use configuration management and Security Monitoring, follow the steps in the [setup guide]({{< ref "/nim/security-monitoring/set-up-app-protect-instances.md" >}}) before continuing.
  {{< /call-out >}}

- NGINX Instance Manager is [installed]({{< ref "/nim/deploy/vm-bare-metal/_index.md" >}}), licensed, and running.  
  
  The latest version of NGINX Instance Manager is recommended to ensure full compatibility and access to the newest features.

  If you have a subscription for F5 WAF for NGINX, you can find your license in the subscription details section of [MyF5](https://my.f5.com).