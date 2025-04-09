---
title: Upload using the Azure CLI
weight: 200
toc: true
url: /nginxaas/azure/getting-started/nginx-configuration/nginx-configuration-azure-cli/
type:
- how-to
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) configurations can be managed using the Azure CLI. This document outlines common Azure CLI workflows to validate, create, and update NGINX configurations.

## Prerequisites

- Install [Azure CLI with NGINXaaS extension]({{< ref "/nginxaas-azure/client-tools/cli.md" >}})

- If the NGINX configuration requires SSL/TLS certificates, then a managed identity and integration with Azure Key Vault is required.

- A contributor role is required to apply the configuration to the deployment.

## Create a configuration

To create a new NGINX configuration, use the `az nginx deployment configuration create` command:

```bash
az nginx deployment configuration create --configuration-name
                                         --deployment-name
                                         --resource-group
                                         [--files]
                                         [--location]
                                         [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                                         [--package]
                                         [--protected-files]
                                         [--root-file]
```

### Validate your configuration

You can use the `analyze` command to validate your configuration before submitting it to the deployment:

```bash
az nginx deployment configuration analyze --deployment-name $DEPLOYMENT_NAME \
   --resource-group $RESOURCE_GROUP --root-file /etc/nginx/nginx.conf \
   --name default --files "$FILES_CONTENT"
````

### Examples

- Create a single file configuration:

   ```bash
   az nginx deployment configuration create --name default \
      --deployment-name myDeployment --resource-group myResourceGroup \
      --root-file /etc/nginx/nginx.conf \
      --files "[{content:'aHR0cCB7CiAgICB1cHN0cmVhbSBhcHAgewogICAgICAgIHpvbmUgYXBw \
      IDY0azsKICAgICAgICBsZWFzdF9jb25uOwogICAgICAgIHNlcnZlciAxMC4wLjEuNDo4 \
      MDAwOwogICAgfQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIDgwOwogICAgICAg \
      IHNlcnZlcl9uYW1lICouZXhhbXBsZS5jb207CgogICAgICAgIGxvY2F0aW9uIC8gewog \
      ICAgICAgICAgICBwcm94eV9zZXRfaGVhZGVyIEhvc3QgJGhvc3Q7CiAgICAgICAgICAg \
      IHByb3h5X3NldF9oZWFkZXIgWC1SZWFsLUlQICRyZW1vdGVfYWRkcjsKICAgICAgICAg \
      ICAgcHJveHlfc2V0X2hlYWRlciBYLVByb3h5LUFwcCBhcHA7CiAgICAgICAgICAgIHBy \
      b3h5X3NldF9oZWFkZXIgR2l0aHViLVJ1bi1JZCAwMDAwMDA7CiAgICAgICAgICAgIHBy \
      b3h5X2J1ZmZlcmluZyBvbjsKICAgICAgICAgICAgcHJveHlfYnVmZmVyX3NpemUgNGs7 \
      CiAgICAgICAgICAgIHByb3h5X2J1ZmZlcnMgOCA4azsKICAgICAgICAgICAgcHJveHlf \
      cmVhZF90aW1lb3V0IDYwczsKICAgICAgICAgICAgcHJveHlfcGFzcyBodHRwOi8vYXBw \
      OwogICAgICAgICAgICBoZWFsdGhfY2hlY2s7CiAgICAgICAgfQogICAgICAgIAogICAg \
      fQp9',virtual-path:'/etc/nginx/nginx.conf'}]"
   ```

- Create a multiple file configuration:

   ```bash
   az nginx deployment configuration create --name default \
      --deployment-name myDeployment --resource-group myResourceGroup \
      --root-file /etc/nginx/nginx.conf \
      --files "[{'content':'aHR0cCB7CiAgICB1cHN0cmVhbSBhcHAgewogICAgICAgIHpvbmUg \
      YXBwIDY0azsKICAgICAgICBsZWFzdF9jb25uOwogICAgICAgIHNlcnZlciAxMC4wLjEu \
      NDo4MDAwOwogICAgfQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIDgwOwogICAg \
      ICAgIHNlcnZlcl9uYW1lICouZXhhbXBsZS5jb207CgogICAgICAgIGxvY2F0aW9uIC8g \
      ewogICAgICAgICAgICBpbmNsdWRlIC9ldGMvbmdpbngvY29uZi5kL3Byb3h5LmNvbmY7 \
      CiAgICAgICAgICAgIHByb3h5X3Bhc3MgaHR0cDovL2FwcDsKICAgICAgICAgICAgaGVh \
      bHRoX2NoZWNrOwogICAgICAgIH0KICAgICAgICAKICAgIH0KfQ==', \
      'virtual-path':'/etc/nginx/nginx.conf'}, \
      {'content':'cHJveHlfc2V0X2hlYWRlciBIb3N0ICRob3N0Owpwcm94eV9zZXRfaGVhZGVy \
      IFgtUmVhbC1JUCAkcmVtb3RlX2FkZHI7CnByb3h5X3NldF9oZWFkZXIgWC1Qcm94eS1B \
      cHAgYXBwOwpwcm94eV9zZXRfaGVhZGVyIEdpdGh1Yi1SdW4tSWQgMDAwMDAwOwpwcm94 \
      eV9idWZmZXJpbmcgb247CnByb3h5X2J1ZmZlcl9zaXplIDRrOwpwcm94eV9idWZmZXJz \
      IDggOGs7CnByb3h5X3JlYWRfdGltZW91dCA2MHM7', \
      'virtual-path':'/etc/nginx/conf.d/proxy.conf'}]"
   ```

- Upload package with config files:

   ```bash
   $ tar -czf nginx.tar.gz nginx
   $ tar -tzf nginx.tar.gz
   nginx/
   nginx/nginx.conf
   nginx/njs.js
   nginx/servers
   nginx/servers/
   nginx/servers/server1.conf
   nginx/servers/server2.conf
   ```

   Where `nginx` is a directory with the following structure:

   ```bash
   $ tree nginx
   nginx
   ├── nginx.conf
   ├── njs.js
   └── servers
       ├── server1.conf
       └── server2.conf

   1 directory, 4 files
   ```

   Encode your tar.gz file and create your NGINXaaS configuration

   ```bash
   TAR_DATA=$(base64 -i nginx.tar.gz)
   az nginx deployment configuration create --deployment-name myDeployment \
      --resource-group myResourceGroup --root-file nginx.conf --name default \
      --package data="$TAR_DATA"
   ```

- Multiple file configuration with protected files:

   ```bash
   az nginx deployment configuration create --name default \
      --deployment-name 0102242023test --resource-group azclitest-geo \
      --root-file /etc/nginx/nginx.conf \
      --files "[{'content':'aHR0cCB7CiAgICB1cHN0cmVhbSBhcHAgewogICAgICAgIHpvbmUg \
      YXBwIDY0azsKICAgICAgICBsZWFzdF9jb25uOwogICAgICAgIHNlcnZlciAxMC4wLjEu \
      NDo4MDAwOwogICAgfQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIDgwOwogICAg \
      ICAgIHNlcnZlcl9uYW1lICouZXhhbXBsZS5jb207CgogICAgICAgIGxvY2F0aW9uIC8g \
      ewogICAgICAgICAgICBpbmNsdWRlIC9ldGMvbmdpbngvY29uZi5kL3Byb3h5LmNvbmY7 \
      CiAgICAgICAgICAgIHByb3h5X3Bhc3MgaHR0cDovL2FwcDsKICAgICAgICAgICAgaGVh \
      bHRoX2NoZWNrOwogICAgICAgIH0KICAgICAgICAKICAgIH0KfQ==', \
      'virtual-path':'/etc/nginx/nginx.conf'}, \
      {'content':'cHJveHlfc2V0X2hlYWRlciBIb3N0ICRob3N0Owpwcm94eV9zZXRfaGVhZGVy \
      IFgtUmVhbC1JUCAkcmVtb3RlX2FkZHI7CnByb3h5X3NldF9oZWFkZXIgWC1Qcm94eS1B \
      cHAgYXBwOwpwcm94eV9zZXRfaGVhZGVyIEdpdGh1Yi1SdW4tSWQgMDAwMDAwOwpwcm94 \
      eV9idWZmZXJpbmcgb247CnByb3h5X2J1ZmZlcl9zaXplIDRrOwpwcm94eV9idWZmZXJz \
      IDggOGs7CnByb3h5X3JlYWRfdGltZW91dCA2MHM7', \
      'virtual-path':'/etc/nginx/conf.d/proxy.conf'}]" \
      --protected-files "[{'content':'aHR0cCB7CiAgICB1cHN0cmVhbSBhcHAgewogICAgICAgIHpvbmUg \
      YXBwIDY0azsKICAgICAgICBsZWFzdF9jb25uOwogICAgICAgIHNlcnZlciAxMC4wLjEu \
      NDo4MDAwOwogICAgfQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIDgwOwogICAg \
      ICAgIHNlcnZlcl9uYW1lICouZXhhbXBsZS5jb207CgogICAgICAgIGxvY2F0aW9uIC8g \
      ewogICAgICAgICAgICBpbmNsdWRlIC9ldGMvbmdpbngvY29uZi5kL3Byb3h5LmNvbmY7 \
      CiAgICAgICAgICAgIHByb3h5X3Bhc3MgaHR0cDovL2FwcDsKICAgICAgICAgICAgaGVh \
      bHRoX2NoZWNrOwogICAgICAgIH0KICAgICAgICAKICAgIH0KfQ==', \
      'virtual-path':'/etc/nginx/nginxprot.conf'}, \
      {'content':'cHJveHlfc2V0X2hlYWRlciBIb3N0ICRob3N0Owpwcm94eV9zZXRfaGVhZGVy \
      IFgtUmVhbC1JUCAkcmVtb3RlX2FkZHI7CnByb3h5X3NldF9oZWFkZXIgWC1Qcm94eS1B \
      cHAgYXBwOwpwcm94eV9zZXRfaGVhZGVyIEdpdGh1Yi1SdW4tSWQgMDAwMDAwOwpwcm94 \
      eV9idWZmZXJpbmcgb247CnByb3h5X2J1ZmZlcl9zaXplIDRrOwpwcm94eV9idWZmZXJz \
      IDggOGs7CnByb3h5X3JlYWRfdGltZW91dCA2MHM7', \
      'virtual-path':'/etc/nginx/conf.d/proxyprot.conf'}]"
   ```

See the [Azure CLI Configuration Create Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment/configuration?view=azure-cli-latest#az-nginx-deployment-configuration-create) for more details on the available parameters.



## Update a configuration

Update a configuration for a deployment using a gzipped archive.

Use the `az nginx deployment configuration update` command to update an existing NGINX configuration:

```bash
az nginx deployment configuration update [--add]
                                         [--configuration-name]
                                         [--deployment-name]
                                         [--files]
                                         [--force-string {0, 1, f, false, n, no, t, true, y, yes}]
                                         [--ids]
                                         [--location]
                                         [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                                         [--remove]
                                         [--resource-group]
                                         [--root-file]
                                         [--set]
                                         [--subscription]
```

### Example

- Update content of the first file in a configuration:

   ```bash
   az nginx deployment configuration update --name default \
      --deployment-name myDeployment --resource-group myResourceGroup \
      --files [0].content="aHR0cCB7CiAgICB1cHN0cmVhbSBhcHAgewogICAgICAgIHpvbmUg \
      YXBwIDY0azsKICAgICAgICBsZWFzdF9jb25uOwogICAgICAgIHNlcnZlciAxMC4wLjEu \
      NDo4MDAwOwogICAgfQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIDgwOwogICAg \
      ICAgIHNlcnZlcl9uYW1lICouZXhhbXBsZS5jb207CgogICAgICAgIGxvY2F0aW9uIC8g \
      ewogICAgICAgICAgICBwcm94eV9zZXRfaGVhZGVyIEhvc3QgJGhvc3Q7CiAgICAgICAg \
      ICAgIHByb3h5X3NldF9oZWFkZXIgWC1SZWFsLUlQICRyZW1vdGVfYWRkcjsKICAgICAg \
      ICAgICAgcHJveHlfc2V0X2hlYWRlciBYLVByb3h5LUFwcCBhcHA7CiAgICAgICAgICAg \
      IHByb3h5X3NldF9oZWFkZXIgR2l0aHViLVJ1bi1JZCAwMDAwMDA7CiAgICAgICAgICAg \
      IHByb3h5X2J1ZmZlcmluZyBvbjsKICAgICAgICAgICAgcHJveHlfYnVmZmVyX3NpemUg \
      NGs7CiAgICAgICAgICAgIHByb3h5X2J1ZmZlcnMgOCA4azsKICAgICAgICAgICAgcHJv \
      eHlfcmVhZF90aW1lb3V0IDYwczsKICAgICAgICAgICAgcHJveHlfcGFzcyBodHRwOi8v \
      YXBwOwogICAgICAgICAgICBoZWFsdGhfY2hlY2s7CiAgICAgICAgfQogICAgICAgIAog \
      ICAgfQp9"
   ```

See the [Azure CLI Configuration Update Documentation](https://learn.microsoft.com/en-us/cli/azure/nginx/deployment/configuration?view=azure-cli-latest#az-nginx-deployment-configuration-update) for more details on the available parameters.


{{< tip >}}

See the [NGINX connfiguration overview]({{< ref "overview.md" >}}) topic
to learn more about:

- [NGINX configuration automation workflows]({{< ref "overview.md#nginx-configuration-automation-workflows" >}})
- [NGINX filesystem restrictions]({{< ref "overview.md#nginx-filesystem-restrictions" >}})
- [Disallowed configuration directives]({{< ref "overview.md#disallowed-configuration-directives" >}})
- [Directives that cannot be overridden]({{< ref "overview.md#directives-that-cannot-be-overridden" >}})
- [Configuration directives list]({{< ref "overview.md#configuration-directives-list" >}})

{{< /tip >}}
