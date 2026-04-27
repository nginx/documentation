---
docs:
nd-files:
- content/solutions/about-subscription-licenses/getting-started.md
- content/solutions/about-subscription-licenses/nginx-plus-licensing-workflows.md
---

{{< call-out "caution" "FCP subscription renewals require a manual JWT update" >}}
If your subscription uses the Flex Consumption Program (FCP), automatic JWT renewal isn't supported. When F5 renews an FCP subscription, it creates a new subscription ID. NGINX Plus doesn't recognize this as a renewal, so the JWT license won't update automatically. If you don't update the license before it expires, NGINX Plus will stop processing traffic.

Check your subscription type in [MyF5](https://my.f5.com) and plan to [update the JWT license manually]({{< ref "/solutions/about-subscription-licenses/getting-started.md#manually-update-license" >}}) at each renewal.

For details and steps, see [K000160880: JWT license auto-renewal may fail in NGINX Plus](https://my.f5.com/manage/s/article/K000160880).
{{< /call-out >}}
