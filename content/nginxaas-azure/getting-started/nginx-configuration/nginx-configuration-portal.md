---
title: Upload using the Azure portal
weight: 100
toc: true
nd-docs: DOCS-873
url: /nginxaas/azure/getting-started/nginx-configuration/nginx-configuration-portal/
type:
- how-to
---

An NGINX configuration can be applied to the deployment using the Azure portal in two different ways:

- Create a new NGINX configuration from scratch or by pasting it in the Azure portal editor.
- Upload a gzip compressed tar archive containing your NGINX configuration.

As part of applying your NGINX configuration, the service validates the configuration for syntax and compatibility with F5 NGINX as a Service for Azure (NGINXaaS). The use of certain directives and parameters is not allowed to ensure the NGINX configuration’s compatibility with IaaS deployment model in Azure. Validation errors are reported in the editor for you to correct. For more information, check the [NGINX Configuration Validation]({{< ref "nginx-configuration.md#nginx-configuration-validation" >}}) section.

{{< call-out "note" >}}
NGINXaaS supports Layer 7 HTTP loadbalancing. To configure .com and .net servers, refer to the server name in the server block within the HTTP context. To learn more, and see examples, follow the instructions in the [NGINX configuration validtion]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#nginx-configuration-validation" >}}) section.{{< /call-out >}}

## Prerequisites

- If the NGINX configuration requires SSL/TLS certificates, then a managed identity and integration with Azure Key Vault is required.

- A contributor role is required to apply the configuration to the deployment.

## Add an NGINX configuration

1. Go to your NGINXaaS for Azure deployment.

1. Select **NGINX configuration** in the left menu and you will see the default configuration that NGINXaaS provides.

   {{< call-out "note" >}}If you don't see the default configuration, it's likely the deployment was created through a client tool other than the portal (For example, Terraform), or the "Apply default NGINX configuration" was unchecked during the deployment creation process in the portal. You can still proceed with the steps below to provide your own NGINX configuration for the deployment.{{< /call-out >}}

1. Select {{< icon "fa fa-plus">}}**New File** to add a file path, then **Confirm**.

   {{<bootstrap-table "table table-striped table-bordered">}}
   | Property | Description |
   | -------- | ----------- |
   | File path | Each NGINX configuration file can be uniquely identified by a file path (for example, nginx.conf or /etc/nginx/nginx.conf) to align with the intended NGINX configuration file structure. |
   | Root file | The root file is the main NGINX configuration file.<ul><li>The first file created will be the root file by default. You can designate a different root file if you have more than a single configuration file in your deployment.</li><li>The root file is designated with a {{< golden-star >}} icon on the portal.</li></ul> |
   | Protected File | Indicates that the file may contain sensitive data such as passwords or represent an ssl/tls certificate.<ul><li>To protect a file, enable the **Protected** {{< icon "solid fa-toggle-on">}} toggle button.</li><li>You cannot access the file contents of a protected file saved to the NGINX configuration, but you can view its metadata, such as the SHA-256 hash of the file contents.</li><li>You can provide new contents for an existing protected file using the <u>**Overwrite**</u> link or resubmit it without having to provide the file contents again.</li><li>To modify the file path of a protected file or convert it to a regular file, delete the original file and create a new one.</li><li>A protected file is designated with a {{< icon "solid fa-lock">}} icon on the portal.</li></ul> |
   {{</bootstrap-table>}}

   {{< call-out "note" >}}If specifying an absolute file path, see the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to.{{< /call-out >}}

1. Provide your NGINX configuration in the configuration file.

1. Files like SSL/TLS certificates can be added as well. However, we reccommend using Azure Key Vault to store your certificates. See [Add SSL/TLS certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/overview.md#add-ssltls-certificates">}}) for more information.

1. Select **Submit** to apply the new configuration.

### NGINX configuration validation

NGINX configuration is validated real-time to check for syntax and compatibility with the service. Validation errors are reported in the editor for you to correct.

For example, if you create/update an NGINX config with a particular directive that is not allowed, the service will analyse your NGINX config and provide real-time feedback.

{{< img src="nginxaas-azure/validation-error.png" alt="NGINX Configuration validation error" >}}


The editing experience consists of a single view for both editing and validation

- If the config is invalid, then any errors are highlighted in-place in the config editor. Hover over the highlighted errors to learn more about them or check the problems section at the bottom. Corrections can be made in the same panel.

- If the config is valid, then a green check mark appears next to NGINXaaS Analyzer at the bottom indicating that you can submit the config to deploy it.

## Upload a GZIP NGINX configuration

Given the example gzipped archive,

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

where `nginx` is a directory with the following structure,

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

`nginx.tar.gz` can be uploaded using the following portal workflow.

Before continuing, ensure the file paths in the archive match the includes in the NGINX config.
For example,

```nginx
http {
   include nginx/servers/server1.conf;
   js_import nginx/njs.js;
   # ...
}
```

1. Go to your NGINXaaS for Azure deployment.

1. Select **NGINX configuration** from the left menu.

1. Select **Upload config package**.

1. Drag and drop or browse for the new gzip compressed archive file to upload.

1. Specify the root file.

   {{< call-out "warning" >}}Uploading a new file will replace all existing NGINX configuration files in your deployment.  You must acknowledge this step before you proceed to upload.{{< /call-out >}}

1. Select **Upload**.

## Update an NGINX configuration

1. Go to your NGINXaaS for Azure deployment.

1. Select **NGINX configuration** in the left menu.

1. Select the configuration file you want to update from the File path list.

1. Make the necessary updates to the configuration.

   - You can also update the file path and/or assign the file as root.

1. (Optional) Select any other configuration files to make additional updates.

1. Submit your changes.

## Delete NGINX configuration Files

1. Go to your NGINXaaS for Azure deployment.

1. Select **NGINX configuration** in the left menu.

1. Select the configuration file you want to delete from the File path list.

1. Select the delete icon {{< icon "fa fa-trash">}}.

1. Confirm your action to delete the configuration file.

   {{< call-out "note" >}}Only non-root configuration files can be deleted.{{< /call-out >}}

{{< call-out "tip" >}}

See the [NGINX connfiguration overview]({{< ref "overview.md" >}}) topic
to learn more about:

- [NGINX configuration automation workflows]({{< ref "overview.md#nginx-configuration-automation-workflows" >}})
- [NGINX filesystem restrictions]({{< ref "overview.md#nginx-filesystem-restrictions" >}})
- [Disallowed configuration directives]({{< ref "overview.md#disallowed-configuration-directives" >}})
- [Directives that cannot be overridden]({{< ref "overview.md#directives-that-cannot-be-overridden" >}})
- [Configuration directives list]({{< ref "overview.md#configuration-directives-list" >}})

{{< /call-out >}}
