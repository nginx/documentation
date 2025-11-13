---
title: Upload using Terraform
weight: 300
toc: true
url: /nginxaas/azure/getting-started/nginx-configuration/nginx-configurations-terraform/
type:
- how-to
---

## Overview

F5 NGINXaaS for Azure (NGINXaaS) configurations can be managed using Terraform. This document outlines common Terraform workflows for NGINXaaS.

## Prerequisites

{{< include "/nginxaas-azure/terraform-prerequisites.md" >}}

## Upload an NGINX configuration

You can find examples of Terraform configurations in the [NGINXaaS for Azure Snippets GitHub repository](https://github.com/nginxinc/nginxaas-for-azure-snippets/tree/main/terraform/configurations)

To create a deployment and add a configuration, run the following commands:

   ```shell
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

## Manage an NGINX configuration

NGINX configuration files are uploaded and returned as base64 encoded data. We recommend using git or other version control systems to view human-readable differences between configuration files during `terraform plan`. Alternatively, you can decode the file contents to view the whole file. For example,

```shell
$ terraform plan
...
- config_file {
    - content      = "aHR0cCB7CiAgICBzZXJ2ZXIgewogICAgICAgIGxvY2F0aW9uIC8gewogICAgICAgICAgICByZXR1cm4gMjAwICJIZWxsbyI7CiAgICAgICAgfQogICAgfQoK" -> null
    - virtual_path = "nginx.conf" -> null
  }
+ config_file {
    + content      = "aHR0cCB7CiAgICBzZXJ2ZXIgewogICAgICAgIGxvY2F0aW9uIC8gewogICAgICAgICAgICByZXR1cm4gMjAwICJIZWxsbyBXb3JsZCEiOwogICAgICAgIH0KICAgIH0KfQoK"
    + virtual_path = "nginx.conf"
  }
...
```

```
$ echo aHR0cCB7CiAgICBzZXJ2ZXIgewogICAgICAgIGxvY2F0aW9uIC8gewogICAgICAgICAgICByZXR1cm4gMjAwICJIZWxsbyBXb3JsZCEiOwogICAgICAgIH0KICAgIH0KfQoK | base64 --decode
http {
    server {
        location / {
            return 200 "Hello World!";
        }
    }
}
```

## Delete a deployment

Once the deployment is no longer needed, run the following to clean up the deployment and related resources:

   ```shell
   terraform destroy --auto-approve
   ```

## Additional resources

- [Terraform NGINX configuration documentation](https://registry.terraform.io/providers/hashicorp/azurerm/3.97.0/docs/resources/nginx_configuration)

{{< include "/nginxaas-azure/terraform-resources.md" >}}

{{< call-out "tip" >}}

See the [NGINX connfiguration overview]({{< ref "overview.md" >}}) topic
to learn more about:

- [NGINX configuration automation workflows]({{< ref "overview.md#nginx-configuration-automation-workflows" >}})
- [NGINX filesystem restrictions]({{< ref "overview.md#nginx-filesystem-restrictions" >}})
- [Disallowed configuration directives]({{< ref "overview.md#disallowed-configuration-directives" >}})
- [Directives that cannot be overridden]({{< ref "overview.md#directives-that-cannot-be-overridden" >}})
- [Configuration directives list]({{< ref "overview.md#configuration-directives-list" >}})

{{< /call-out >}}
