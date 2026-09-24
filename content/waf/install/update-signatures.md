---
title: "Update F5 WAF for NGINX signatures"
weight: 600
toc: false
f5-content-type: how-to
f5-product: F5 WAF for NGINX
---

This topic describes how to update F5 WAF for NGINX signatures in a [virtual machine or bare-metal environment]({{< ref "/waf/install/virtual-environment.md" >}}).

For deployments that use compiled policy bundles, including compiler-image workflows, read [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}). In those deployments, update the security packages in the compiler image, recompile the policy bundles, then apply the updated bundle to the running deployment.

Signatures are divided into three groups:

- [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}})
- [Bot signatures]({{< ref "/waf/policies/bot-signatures.md" >}})
- [Threat campaigns]({{< ref "/waf/policies/threat-campaigns.md" >}})

F5 WAF for NGINX signature updates are released at a higher frequency than F5 WAF for NGINX itself, and are subsequently available in their own packages.

A new installation will have the latest signatures available, but F5 WAF for NGINX and the signature packages can be updated independently afterwards.

## Identify and update packages

During installation, the [Platform-specific instructions]({{< ref "/waf/install/virtual-environment.md#platform-specific-instructions" >}}) were used to add the F5 WAF for NGINX repositories to your chosen operating system.

Installing these packages also installed their dependencies, which includes the signature packages. You can use your environment's package manager to update these packages.

They will be named something in the following list:

- `app-protect-attack-signatures`
- `app-protect-bot-signatures`
- `app-protect-threat-campaigns`

You can update these packages independently of the core F5 WAF for NGINX packages, ensuring you always have the latest signatures.

## Apply the updated signatures

This section applies to virtual machine and bare-metal installations where the signature packages are updated on the same host that runs F5 WAF for NGINX.

Updated signatures take effect after you reload NGINX. Until then, F5 WAF for NGINX keeps running the previous signatures.

A reload is enough. You don't need to restart NGINX.

To apply the updated signatures, run the following command:

- `nginx -s reload`