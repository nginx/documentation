---
title: Add certificates using the Azure CLI
weight: 200
toc: true
url: /nginxaas/azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-azure-cli/
type:
- how-to
---

You can use Azure Key Vault (AKV) to store SSL/TLS certificates and keys to use in your F5 NGINXaaS for Azure (NGINXaaS) configuration.

### Prerequisites

{{< include "/nginxaas-azure/ssl-tls-prerequisites.md" >}}

- Install [Azure CLI with NGINXaaS extension]({{< ref "/nginxaas-azure/client-tools/cli.md" >}})

## Create a certificate

Create a certificate under a deployment. This references an existing certificate in an Azure Key Vault and makes it available to NGINX configuration

To create a certificate, use the `az nginx deployment certificate create` command:

```shell
az nginx deployment certificate create --certificate-name
                                       --deployment-name
                                       --resource-group
                                       [--certificate-path]
                                       [--key-path]
                                       [--key-vault-secret-id]
                                       [--location]
                                       [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
```

### Example

- Create a certificate with a certificate path, key path, and key vault secret ID:

   ```shell
   az nginx deployment certificate create --certificate-name myCertificate \
      --deployment-name myDeployment --resource-group myResourceGroup \
      --certificate-path /etc/nginx/test.cert --key-path /etc/nginx/test.key \
      --key-vault-secret-id keyVaultSecretId
   ```

See [Azure CLI Certificate Create Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment/certificate#az-nginx-deployment-certificate-create) for more details on the available parameters.

## Update a certificate

To update a certificate, use the `az nginx deployment certificate update` command:

```shell
az nginx deployment certificate update [--add]
                                       [--certificate-name]
                                       [--certificate-path]
                                       [--deployment-name]
                                       [--force-string {0, 1, f, false, n, no, t, true, y, yes}]
                                       [--ids]
                                       [--key-path]
                                       [--key-vault-secret-id]
                                       [--location]
                                       [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                                       [--remove]
                                       [--resource-group]
                                       [--set]
                                       [--subscription]
```

### Example

- Update the certificate virtual path, key virtual path and certificate:

   ```shell
   az nginx deployment certificate update --certificate-name myCertificate \
      --deployment-name myDeployment --resource-group myResourceGroup \
      --certificate-path /etc/nginx/testupdated.cert \
      --key-path /etc/nginx/testupdated.key \
      --key-vault-secret-id newKeyVaultSecretId
   ```

See [Azure CLI Certificate Create Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment/certificate#az-nginx-deployment-certificate-update) for more details on the available parameters.

## Delete a certificate

To delete a certificate, use the `az nginx deployment certificate delete` command:

```shell
az nginx deployment certificate delete [--certificate-name]
                                       [--deployment-name]
                                       [--ids]
                                       [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                                       [--resource-group]
                                       [--subscription]
                                       [--yes]
```

### Example

- Delete a certificate:

   ```shell
   az nginx deployment certificate delete --certificate-name myCertificate \
      --deployment-name myDeployment --resource-group myResourceGroup
   ```

See [Azure CLI Certificate Delete Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment/certificate#az-nginx-deployment-certificate-delete) for more details on the available parameters.
