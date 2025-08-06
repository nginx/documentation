---
docs:
---

Download the SSL certificate, private key, and the JWT license file associated with your NGINX Plus subscription from the MyF5 Customer Portal:

- Log in to [MyF5](https://my.f5.com/manage/s/).
- Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
- Find your NGINX products or services subscription, and select the **Subscription ID** for details.
- Download the **nginx-repo.crt** and **nginx-repo.key** from the subscription page.
- Download the **JSON Web Token** (JWT) from the subscription page.

{{< call-out "note" >}} Starting from [NGINX Plus Release 33]({{< ref "nginx/releases.md#r33" >}}), a JWT file is required for each NGINX Plus instance. For more information, see [About Subscription Licenses]({{< ref "/solutions/about-subscription-licenses.md">}}). {{< /call-out >}}