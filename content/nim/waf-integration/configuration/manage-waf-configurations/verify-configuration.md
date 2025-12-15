---
title: Verify WAF configuration
description: Confirm that F5 WAF for NGINX is active and running correctly on your instances.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIMNGR
---

After applying your configuration, verify that F5 WAF for NGINX is active and running as expected on your instances. You can confirm status and version details through the **F5 NGINX Instance Manager** web interface.

## Verify in NGINX Instance Manager

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left navigation menu, select **Instances**.
3. In the **F5 WAF** column, confirm that the correct version is listed for each instance.
4. Select an instance to open its details page.
5. Scroll to the **F5 WAF Details** section and confirm the following:
   - **Status** is **Active**.
   - **Build** matches the version installed on the instance.
   - **Policy** reflects the policy bundle you applied.
6. (Optional) If Security Monitoring is enabled, review the dashboard for recent traffic and violation data.

If WAF is not active or the version does not match, review your configuration and logs for errors. You may need to republish the configuration or verify file paths in the NGINX Agent settings.

## Next steps

- [Onboard custom security policies]({{< ref "onboard-custom-security-policies.md" >}}) to upload and prepare your own security bundles for use with NGINX Instance Manager.