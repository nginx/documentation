---
nd-docs: DOCS-000
nd-files:
- content/ngf/install/helm.md
- content/ngf/install/manifests.md
- content/ngf/install/nginx-plus.md
---

1. Log in to [MyF5](https://my.f5.com/manage/s/).
2. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
3. Find your NGINX products or services subscription, and select the **Subscription ID** for details.
4. Download the **JSON Web Token (JWT)** from the subscription page.

{{< call-out "note" >}} The Connectivity Stack for Kubernetes JWT does not work with NGINX Plus reporting. A regular NGINX Plus instance JWT must be used. {{< /call-out >}}
