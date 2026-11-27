---
f5-files:
- content/nginxaas/google/deploy/create-deployment/deploy-terraform.md
- content/nginxaas/google/deploy/nginx-configuration/nginx-configurations-terraform.md
---

- Confirm that you meet the [NGINXaaS Prerequisites]({{< ref "/nginxaas/google/deploy/prerequisites.md" >}}).
- Access to a Google Cloud project to manage your network resources.
- Access to the F5 NGINXaaS console to create client credentials. See [Programmatic authentication with client credentials]({{< ref "/nginxaas/overview/client-credentials.md" >}}).
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install).

{{< call-out class="important" >}}
This guide uses the [latest version](https://registry.terraform.io/providers/F5Networks/f5ads/latest) of the `F5Networks/f5ads` provider.
{{< /call-out >}}
