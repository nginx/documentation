---
f5-docs: DOCS-000
f5-files:
- content/nginxaas/google/deploy/create-deployment/deploy-terraform.md
- content/nginxaas/google/deploy/nginx-configuration/nginx-configurations-terraform.md
---

- Confirm that you meet the [NGINXaaS Prerequisites]({{< ref "/nginxaas/google/deploy/prerequisites.md" >}}).
- Access to a Google Cloud project to manage your network resources.
- Access to the F5 NGINXaaS console to create client credentials. See [Programmatic authentication with client credentials]({{< ref "/nginxaas/overview/client-credentials.md" >}}).
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install).

{{< call-out class="important" >}}
The `F5Networks/f5ads` provider is in alpha (`0.1.0-alpha.1`). Pin this exact version in your `required_providers` block, since breaking changes can occur between alpha releases.
{{< /call-out >}}
