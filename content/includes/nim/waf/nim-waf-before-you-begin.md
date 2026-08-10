---
f5-product: NGINX Instance Manager
f5-files:
- content/nim/waf-integration/configuration/_index.md
- content/nim/waf-integration/configuration/install-waf-compiler/install-disconnected.md
- content/nim/waf-integration/configuration/install-waf-compiler/install.md
---

Make sure you’ve completed the following tasks:

- You have one or more [F5 WAF for NGINX]({{< ref "/waf/" >}}) instances running.  
  For supported versions, see [Support for F5 WAF for NGINX]({{< ref "/nim/fundamentals/tech-specs.md#f5-waf" >}}).

  {{< call-out class="note" >}}
  If you plan to use configuration management and Security Monitoring, follow the steps in the [setup guide]({{< ref "/nim/security-monitoring/set-up-app-protect-instances.md" >}}) before continuing.
  {{< /call-out >}}

- NGINX Instance Manager is [installed]({{< ref "/nim/deploy/vm-bare-metal/_index.md" >}}), licensed, and running.  
  
  The latest version of NGINX Instance Manager is recommended to ensure full compatibility and access to the newest features.

  If you have a subscription for F5 WAF for NGINX, you can find your license in the subscription details section of [MyF5](https://my.f5.com).

- If you're installing WAF compiler 5.690.0 or later, verify that the `/opt/app_protect` directory does not already exist before installation. After installation, confirm that `/opt/app_protect` is a symbolic link that points to the latest WAF compiler directory.

```shell
$ ls -l /opt/app_protect
lrwxrwxrwx 1 root root 41 Aug  6 06:18 /opt/app_protect -> /opt/nms-nap-compiler/app_protect-5.690.0
```