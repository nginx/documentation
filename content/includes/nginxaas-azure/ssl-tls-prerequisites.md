---
docs: "DOCS-000"
---

- AKV to store certificates that you want to add to the deployment.

- A user or system assigned identity associated with your NGINXaaS deployment. Ensure that your managed identity (MI) has read access to secrets stored in AKV:

  - If using Azure RBAC for AKV, ensure that your MI has [Key Vault Secrets User](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-user) or higher permissions.

  - If using Access Policies for AKV, ensure that your MI has *GET secrets* or higher permissions.

- In addition to the MI permissions, if using the Azure portal to manage certificates, ensure that you have read access to list certificates inside the Key Vault:

  - If using Azure RBAC for AKV, ensure that you have [Key Vault Reader](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-reader) or higher permissions.

  - If using Access Policies for AKV, ensure that you have *LIST certificates* or higher permissions.

  - If public access is disabled on your key vault, [configure Network Security Perimeter]({{< ref "/nginxaas-azure/quickstart/security-controls/certificates.md#configure-network-security-perimeter-nsp" >}}) and add an inbound access rule to allow your client IP address.

- If you're unfamiliar with Azure Key Vault, check out the [Azure Key Vault concepts](https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts) documentation from Microsoft.