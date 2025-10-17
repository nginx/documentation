---
title: Overview
url: /nginxaas/azure/getting-started/ssl-tls-certificates/overview/
toc: true
weight: 50
nd-content-type: how-to
nd-product: N4Azure
---

F5 NGINXaaS for Azure (NGINXaaS) enables customers to secure traffic by adding SSL/TLS certificates to a deployment. NGINXaaS can fetch certificates directly from Azure Key Vault, rotate certificates, and provide observability on the status of your certificates.

This document provides details about using SSL/TLS certificates with your F5 NGINXaaS for Azure deployment.

## Supported certificate types and formats

NGINXaaS supports **up to 100** TLS/SSL certificates of the following types:

- Self-signed certificates, Domain Validated (DV) certificates, Organization Validated (OV) certificates, and Extended Validation (EV) certificates.

NGINX supports the following certificate formats:

- PEM and PKCS12 format certificates.

## Add SSL/TLS certificates

Add a certificate from an Azure Key Vault to your NGINXaaS deployment using your preferred client tool:

* [Add certificates using the Azure portal]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md">}})
* [Add certificates using the Azure CLI]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-azure-cli.md">}})
* [Add certificates using Terraform]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-terraform.md">}})

{{< call-out "note" >}}- You can overwrite the NGINX default protocol to configure the desired TLS/SSL policy. Read more about the procedure in the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) documentation.

- You can associate multiple certificates for the same domain; the "ssl_certificate" directive can be specified multiple times to load certificates of different types. To learn more, see the [Module ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) documentation.{{< /call-out >}}

### Add SSL/TLS certificates bundled with NGINXaaS configuration

You can also add your certificate as a file to your NGINX configuration filesystem; refer to [Upload an NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview.md">}}) to learn about the different options. Although this is a quick method for adding SSL/TLS certificates to your NGINXaaS deployment, we recommend adding certificates through Azure Key Vault (AKV) for enhanced security, certificate rotation, and monitoring.

Once a certificate has been added, update your NGINX configuration to reference your SSL/TLS certificate and key file paths.

```nginx
http {
   server {
      listen 443 ssl;
      ssl_certificate /etc/nginx/certs/mycert.cert;
      ssl_certificate_key /etc/nginx/certs/mycert.key;
      # ...
   }
}
```

## Certificate rotation

NGINXaaS for Azure regularly polls the AKV to check if the certificate has been updated. If an updated certificate is found, it is automatically rotated on the deployment within 4 hours. Any change to the NGINX configuration will trigger all SSL/TLS certificates to be rotated immediately.

For Azure client tools, such as the Azure CLI or Azure Resource Manager, the certificate is referenced from AKV using its Key Vault secret identifier. If the secret identifier specifies a version, NGINXaaS will not rotate the certificate. To enable certificate rotation, ensure the secret id does not contain a version, for example, `https://myvault.vault.azure.net/secrets/mysecret`. Certificates added using the Azure Portal will automatically be rotated.

{{< call-out "warning" >}}If any of your SSL/TLS certificates or your NGINX configuration has issues, the certificates will not be rotated.{{< /call-out >}}

## Monitor certificates

To view the status of your SSL/TLS certificates, [enable monitoring]({{< ref "/nginxaas-azure/monitoring/enable-monitoring.md" >}}) for your NGINXaaS deployment and navigate to the **Metrics** tab in the Azure portal. View the `nginxaas.certificates` metric under the `nginxaas statistics` metric namespace. The `nginxaas.certificates` metric allows you to filter by certificate name and the status of the certificate. The status dimension reports the health of your certificates through the following values:

{{< table >}}

| Status        | Description   |
| ------------- | ------------- |
| `active`      | The certificate was successfully fetched from AKV. |
| `unauthorized`| Azure returned a 401/403 error when fetching the certificate from AKV, which usually indicates an issue with the deployment's [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}). |
| `not found`   | Azure returned a 404 error when fetching the certificate from AKV. |
| `incompatible`| An error occurred while fetching or processing the certificate from AKV. <br><br>The possible reasons include: <br> <br><ul><li>Error while downloading certificate and key</li><li>Missing content type in certificate</li><li>Missing content in certificate</li><li>Unrecognized content type, certificate not in PEM or PKCS12 format</li></ul> |

{{< /table >}}

{{< img src="nginxaas-azure/azure-metrics-nginxaas.certificates.png" alt="Interface screenshot showing the Azure metric nginxaas.certificates" >}}

## Common certificate errors

The following section describes common errors you might encounter while adding SSL/TLS certificates to your NGINXaaS deployment and how to resolve them.

{{< details summary="Common certificate errors" >}}

#### Error code: `ForbiddenByRbac`

**Description:** The [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) associated with the NGINXaaS deployment does not have permissions to fetch certificates from key vault. This error is returned when the key vault's permission model is set to [Azure role-based access control](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview?WT.mc_id=Portal-Microsoft_Azure_KeyVault).

**Resolution:** Assign the [Key Vault Secrets User](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-user) role to the managed identity associated with your NGINXaaS deployment.

{{< details summary="Create a role assignment using the CLI" >}}

1. Get the principal ID of the user or system assigned managed identity.

   - **User assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `MI_NAME`: the name of the managed identity
      - `MI_RESOURCE_GROUP`: the name of the resource group the managed identity is in
      ```shell
      mi_principal_id=$(az identity show --name $MI_NAME \
         --resource-group $MI_RESOURCE_GROUP \
         --query principalId --output tsv)
      ```

   - **System assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `DEP_NAME`: the name of the NGINXaaS deployment
      - `DEP_RESOURCE_GROUP`: the name of the resource group the NGINXaaS deployment is in
      ```shell
      mi_principal_id=$(az nginx deployment show --name $DEP_NAME \
         --resource-group $DEP_RESOURCE_GROUP \
         --query identity.principalId --output tsv)
      ```
1. Get the resource ID of the key vault.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of the resource group the key vault is in
   ```shell
   key_vault_id=$(az keyvault show --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --query id --output tsv)
   ```
1. Create the role assignment.
   ```shell
   az role assignment create --assignee $mi_principal_id \
      --role "Key Vault Secrets User" \
      --scope $key_vault_id
   ```

{{< /details >}}

#### Error code: `AccessDenied`

**Description:**  The [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) associated with the NGINXaaS deployment has not been assigned to an access policy on the key vault. This error is returned when the key vault's permission model is set to [Vault access policy](https://learn.microsoft.com/en-us/azure/key-vault/general/assign-access-policy?WT.mc_id=Portal-Microsoft_Azure_KeyVault&tabs=azure-portal).

**Resolution:** Assign an access policy to the managed identity associated with your NGINXaaS deployment with *Get secrets* permissions or higher. If you are using the Azure portal, assign an additional access policy to your user with *List certificates* permissions or higher.

{{< details summary="Create an access policy using the CLI" >}}

1. Get the principal ID of the user or system assigned managed identity.

   - **User assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `MI_NAME`: the name of the managed identity
      - `MI_RESOURCE_GROUP`: the name of the resource group the managed identity is in
      ```shell
      mi_principal_id=$(az identity show --name $MI_NAME \
         --resource-group $MI_RESOURCE_GROUP \
         --query principalId --output tsv)
      ```

   - **System assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `DEP_NAME`: the name of the NGINXaaS deployment
      - `DEP_RESOURCE_GROUP`: the name of the resource group the NGINXaaS deployment is in
      ```shell
      mi_principal_id=$(az nginx deployment show --name $DEP_NAME \
         --resource-group $DEP_RESOURCE_GROUP \
         --query identity.principalId --output tsv)
      ```

1. Create the access policy.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of the resource group the key vault is in
   ```shell
   az keyvault set-policy --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --object-id $mi_principal_id \
      --secret-permissions get
   ```

{{< /details >}}

#### Error code: `ForbiddenByFirewall` or `ForbiddenByConnection`

**Description:** The key vault's firewall is enabled and NGINXaaS is not authorized to fetch certificates.

**Resolution:**

Allow NGINXaaS to access the key vault through one of these mechanisms:

1. [Configure Network Security Perimeter]({{< ref "/nginxaas-azure/quickstart/security-controls/certificates.md#configure-network-security-perimeter-nsp" >}}) to allow the subscription of the NGINXaaS deployment to access the key vault.

{{< details summary="Create a network security perimeter using the CLI" >}}

1. Create a network security perimeter.

   Set the following environment variables before copying the below Azure CLI command.
   - `NSP_NAME`: the name of the network security perimeter
   - `NSP_RESOURCE_GROUP`: the name of the resource group the network security perimeter will be in
   ```shell
   az network perimeter create --name $NSP_NAME --resource-group $NSP_RESOURCE_GROUP
   ```
1. Create a profile for the network security perimeter.

   Set the following environment variable is set before copying the below Azure CLI command.
   - `PROFILE_NAME`: the name of the network security perimeter profile
   ```shell
   az network perimeter profile create --name $PROFILE_NAME \
      --resource-group $NSP_RESOURCE_GROUP \
      --perimeter-name $NSP_NAME
   ```
1. Get the resource ID of the key vault.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of the resource group the key vault is in
   ```shell
   key_vault_id=$(az keyvault show --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --query id --output tsv)
   ```
1. Get the resource ID of the network security profile.
   ```shell
   nsp_profile_id=$(az network perimeter profile show --name $PROFILE_NAME \
      --resource-group $NSP_RESOURCE_GROUP \
      --perimeter-name $NSP_NAME --query id --output tsv)
   ```
1. Associate the key vault with the network security perimeter
   ```shell
   az network perimeter association create --name key-vault-association \
      --perimeter-name $NSP_NAME \
      --resource-group $NSP_RESOURCE_GROUP \
      --private-link-resource "{id:$key_vault_id}" \
      --profile "{id:$nsp_profile_id}"
   ```
1. Add an inbound access rule to allow the NGINXaaS deployment's subscription.

   Set the following environment variables before copying the below Azure CLI command.
   - `RULE_NAME`: the name of the access rule
   - `DEP_SUBSCRIPTION_ID`: the subscription ID of the NGINXaaS deployment
   ```shell
   az network perimeter profile access-rule create --name $RULE_NAME \
      --profile-name $PROFILE_NAME \
      --perimeter-name $NSP_NAME \
      --resource-group $NSP_RESOURCE_GROUP \
      --subscriptions [0].id="/subscriptions/$DEP_SUBSCRIPTION_ID"
   ```

{{< /details >}}

2. Integrate with a Private Endpoint to allow NGINXaaS to fetch certificates via Azure Private Link.

{{< details summary="Create a private link using the CLI" >}}

1. Get the resource ID of the key vault.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of tshe resource group the key vault is in
   ```shell
   key_vault_id=$(az keyvault show --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --query id --output tsv)
   ```

1. Create a private endpoint.

   Set the following environment variables before copying the below Azure CLI command.
   - `PE_NAME`: the name of the private endpoint
   - `PE_RESOURCE_GROUP`: the name of the resource group the private endpoint will be in
   - `VNET_NAME`: the name of the virtual network that is delegated to NGINXaaS
   - `VNET_RESOURCE_GROUP`: the name of the resource group the virtual network is in
   - `SUBNET_NAME`: the name of the subnet for private endpoints
   - `PE_CONNECTION_NAME`: the name of the private endpoint connection
   - `LOCATION`: the location of the virtual network
   ```shell
   az network private-endpoint create --name $PE_NAME \
      --resource-group $PE_RESOURCE_GROUP \
      --vnet-name $VNET_NAME \
      --subnet $SUBNET_NAME \
      --private-connection-resource-id $key_vault_id \
      --group-id vault \
      --connection-name $PE_CONNECTION_NAME \
      --location $LOCATION
   ```

1. Create a private DNS zone and link VNet.

   Set the following environment variables before copying the below Azure CLI command.
   - `ZONE_RESOURCE_GROUP`: the name of the resource group for the DNS zone
   - `ZONE_NAME`: the name of the DNS zone
   - `DNS_LINK_NAME`: the name of the DNS zone link
   ```shell
   vnet_id=$(az network vnet show --name $VNET_NAME \
      --resource-group $VNET_RESOURCE_GROUP \
      --query id --output tsv)
   ```
   ```shell
   az network private-dns zone create --resource-group $ZONE_RESOURCE_GROUP \
      --name $ZONE_NAME
   az network private-dns link vnet create --resource-group $ZONE_RESOURCE_GROUP \
      --zone-name $ZONE_NAME \
      --name $DNS_LINK_NAME \
      --virtual-network $vnet_id \
      --registration-enabled false
   ```

1. Add DNS zone group to the private endpoint.

   Set the following environment variables before copying the below Azure CLI command.
   - `DNS_ZONE_GROUP_NAME`: the name of the resource group for the DNS zone
   ```shell
   az network private-endpoint dns-zone-group create \
      --resource-group $PE_RESOURCE_GROUP \
      --endpoint-name $PE_NAME \
      --name $DNS_ZONE_GROUP_NAME \
      --private-dns-zone $ZONE_NAME \
      --zone-name $ZONE_NAME
   ```

{{< /details >}}

3. Allow access from Virtual Network delegated to NGINXaaS.

{{< details summary="Allow Virtual Network access using the CLI" >}}

1. Get the resource ID of the virtual network.

   Set the following environment variables before copying the below Azure CLI command.
   - `VNET_NAME`: the name of the virtual network that is delegated to NGINXaaS
   - `VNET_RESOURCE_GROUP`: the name of the resource group the virtual network is in
   ```shell
   vnet_id=$(az network vnet show --name $VNET_NAME \
      --resource-group $VNET_RESOURCE_GROUP \
      --query id --output tsv)
   ```

1. Get the resource ID of the subnet.

   Set the following environment variable before copying the below Azure CLI command.
   - `SUBNET_NAME`: the name of the subnet that is delegated to NGINXaaS
   ```shell
   subnet_id=$(az network vnet subnet show --name $SUBNET_NAME \
      --vnet-name $VNET_NAME \
      --resource-group $VNET_RESOURCE_GROUP \
      --query id --output tsv)
   ```

1. Add the virtual network rule to the key vault.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of the resource group the key vault is in
   ```shell
   az keyvault network-rule add --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --subnet $subnet_id
   ```

{{< call-out "note" >}} Ensure that the Network Security Group on the subnet delegated to the NGINXaaS deployment allows outbound traffic to the internet{{< /call-out >}}

{{< /details >}}

#### Error code: `AnotherOperationInProgress`

**Description:** Another operation on this, or a dependent resource, is in progress.

**Resolution:** Retry the operation after the current operation reaches a terminal state.

#### Error code: `SecretNotFound`

**Description:** The certificate's key vault secret ID was not found in the key vault.

**Resolution:** Ensure the specified key vault secret ID exists and has the correct format, for example, `https://myvault.vault.azure.net/secrets/abcd/v1`.

#### Error code: `CertificateInUse`

**Description:** The certificate being deleted or modified is referenced in the NGINX configuration. The attempted modification would prevent the NGINX config from being applied.

**Resolution:** Remove references to the certificate in the NGINX config, or add a new certificate resource to the NGINXaaS deployment with the modified certificate and key paths.

#### Error code: `ForbiddenByPolicy`

**Description:** The [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) associated with the NGINXaaS deployment does not have permissions to fetch certificates from key vault. This error is returned when the key vault's permission model is set to [Vault access policy](https://learn.microsoft.com/en-us/azure/key-vault/general/assign-access-policy?WT.mc_id=Portal-Microsoft_Azure_KeyVault&tabs=azure-portal).

**Resolution:** Assign an access policy to the managed identity associated with your NGINXaaS deployment with *Get secrets* permissions or higher. If you are using the Azure portal, assign an additional access policy to your user with *List certificates* permissions or higher.

{{< details summary="Create an access policy using the CLI" >}}

1. Get the principal ID of the user or system assigned managed identity.

   - **User assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `MI_NAME`: the name of the managed identity
      - `MI_RESOURCE_GROUP`: the name of the resource group the managed identity is in
      ```shell
      mi_principal_id=$(az identity show --name $MI_NAME \
         --resource-group $MI_RESOURCE_GROUP \
         --query principalId --output tsv)
      ```

   - **System assigned managed identity**

      Set the following environment variables before copying the below Azure CLI command.
      - `DEP_NAME`: the name of the NGINXaaS deployment
      - `DEP_RESOURCE_GROUP`: the name of the resource group the NGINXaaS deployment is in
      ```shell
      mi_principal_id=$(az nginx deployment show --name $DEP_NAME \
         --resource-group $DEP_RESOURCE_GROUP \
         --query identity.principalId --output tsv)
      ```

1. Create the access policy.

   Set the following environment variables before copying the below Azure CLI command.
   - `KV_NAME`: the name of the key vault
   - `KV_RESOURCE_GROUP`: the name of the resource group the key vault is in
   ```shell
   az keyvault set-policy --name $KV_NAME \
      --resource-group $KV_RESOURCE_GROUP \
      --object-id $mi_principal_id \
      --secret-permissions get
   ```

{{< /details >}}

#### Error code: `DuplicateFilePathError`

**Description:** A file already exists on the instance's filesystem with the certificate or key's file path.

**Resolution:** Rename the certificate or key path, so there are no collisions with existing certificate and NGINX config file paths.

#### Error code: `SecretDisabled`

**Description:** The certificate is set to disabled in the key vault.

**Resolution:** Enable the certificate in the key vault.

{{< details summary="Enable a certificate in the key vault using the CLI" >}}

1. Get the resource ID of the certificate.

   Set the following environment variables before copying the below Azure CLI command.
   - `CERT_NAME`: the name of the certificate
   - `KV_NAME`: the name of the key vault
   ```shell
   certificate_id=$(az keyvault certificate show --name $CERT_NAME \
      --vault-name $KV_NAME \
      --query id --output tsv)
   ```

1. Enable the certificate.
   ```shell
   az keyvault certificate set-attributes --enabled true --id $certificate_id
   ```

{{< /details >}}

#### Error code: `NoCertificateContent`

**Description:** No certificate was found when parsing the file.

**Resolution:** Ensure the file is not empty and contains properly formatted PEM or PKCS12 certificate data.

#### Error code: `MissingContentType`

**Description:** The retrieved secret is missing the *contentType* field.

**Resolution:** When creating an [Azure certificate](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates) in key vault, the *contentType* field will be properly set to either *application/x-pem-file* or *application/x-pkcs12*. If a certificate is added as a generic [Azure secret](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets) the *contentType* field must be manually set to help with interpreting the secret data when it is retrieved. We recommend creating a certificate object, instead of a secret object containing certificate data, to ensure proprer formatting and *contentType*.

#### Error code: `UnrecognizedContentType`

**Description:** The retrieved secret's content type, as interpreted from the *contentType* field, is of an unsupported type.

**Resolution:** When creating an [Azure certificate](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates) in key vault, the *contentType* field will be properly set to either *application/x-pem-file* or *application/x-pkcs12*. NGINXaaS does not support other content types added as generic [Azure secrets](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets). Ensure the provided certificate is either a PEM or PKCS12 [Azure certificate](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates).

#### Error code: `PKCS12ParseFailure`

**Description:** The PKCS12 certificate could not be parsed.

**Resolution:** Ensure the file is not empty and contains properly formatted PKCS12 certificate data.

#### Error code: `PEMParseFailure`

**Description:** The PEM certificate could not be parsed.

**Resolution:** Ensure the file is not empty and contains properly formatted PEM certificate data.

{{< /details >}}