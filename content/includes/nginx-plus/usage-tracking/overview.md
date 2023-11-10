---
docs:
---

You can easily keep track of your [NGINX Plus]({{< relref "nginx/" >}}) installations with [NGINX Management Suite Instance Manager]({{< relref "nms/nim/" >}}). If you’re part of a commercial program like the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program), you’ll need to report these numbers to F5.

Begin by installing NGINX Instance Manager on a dedicated host. Next, set up your NGINX Plus systems to report their status. Once your NGINX Plus systems are connected to Instance Manager, you'll be able to review and report on your inventory through the REST API or web interface. You can forward these reports to your F5 contact.

If you [add a JSON Web Token]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}) as a license in Instance Manager, you can choose to send these reports to F5 regularly or only when you need to.
