---
title: Install NGINX Agent
description: Install NGINX Agent on each F5 WAF for NGINX instance to connect it to NGINX Instance Manager.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
---

To onboard your F5 WAF for NGINX instances to NGINX Instance Manager, install and configure NGINX Agent on each instance.

1. Use SSH to connect to an F5 WAF for NGINX instance.
   Repeat these steps for each instance you want to onboard.

1. Download the NGINX Agent package from your NGINX Instance Manager host and run the installation script.

   You can group instances that use the same version of F5 WAF for NGINX by including the optional `--instance-group` flag in the install command.

   {{< include "agent/installation/install-agent-api.md" >}}

{{< call-out "note" "Next steps" >}}
- [Configure NGINX Agent]({{< ref "/nim/waf-integration/configuration/onboard-instances/configure-nginx-agent.md" >}})
{{< /call-out >}}