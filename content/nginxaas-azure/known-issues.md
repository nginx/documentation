---
title: "Known issues"
weight: 1000
toc: true
docs: "DOCS-871"
url: /nginxaas/azure/known-issues/

---

List of known issues in the latest release of F5 NGINX as a Service for Azure (NGINXaaS).

### {{% icon-bug %}} Custom and precompiled security policies cannot both be referenced in an NGINX configuration 

When using NGINX App Protect WAF, you can only reference default or custom security policies in your NGINX configuration, not both.

**Workaround**: Make a copy of the default policy you want to use, then add it as a custom policy with a different name.  

### {{% icon-bug %}} Terraform fails to apply due to validation errors, but creates "Failed" resources in Azure (ID-4424)

Some validation errors are caught later in the creation process, and can leave behind "Failed" resources in Azure. An example initial failure might look like:

```shell
$ terraform apply
<output omitted for brevity>
│ Error: creating Nginx Deployment (Subscription: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
│ Resource Group Name: "XXXXXXXX"
│ Nginx Deployment Name: "XXXXXXXX"): polling after DeploymentsCreateOrUpdate: polling failed: the Azure API returned the following
│ error:
│
│ Status: "Failed"
│ Code: "NginxSaaSError"
│ Message: "{\"Content\":\"{\\\"error\\\":{\\\"code\\\":\\\"CapacityOutOfRange\\\",\\\"message\\\":\\\"The deployment's capacity must
│ be between 10 and 500 inclusive for marketplace plan standard. For more information about setting capacity see
│ https://docs.nginx.com/nginxaas/azure/quickstart/scaling/.\\\"}}\\n\",\"StatusCode\":400}"
```

The error message describes how to fix the vailidation problem. In the Azure portal, you'll be able to see your NGINXaaS, but it will have a "Failed" status. Future **terraform apply** will fail with **Error: A resource with the ID "..." already exists**.


**Workaround**: manually delete the "Failed" resource in Azure portal before re-running **terraform apply**. **terraform import** will not work.

### {{% icon-bug %}} Changing IP addresses in `listen` directives fails with "cannot reload nginx: timed out waiting for config to reload" (ID-4366)

NGINXaaS uses NGINX's ["change configuration" feature](https://nginx.org/en/docs/control.html#reconfiguration) to update the configuration gracefully without dropping traffic. This starts new workers on the new configuration before shutting down the old workers on the old config. Some kinds of `listen` changes can block new workers from starting up. If you're changing from listening on all IPs to one (for example `listen 1234` -> `listen 127.0.0.1:1234` or vice versa), the config will fail to apply because the old workers and the new workers have an IP conflict.

**Workaround**: Change the port as well as the IP address to avoid the conflict, and then make a second config change back to the desired port.

### {{% icon-bug %}} Deploying NGINXaaS and Diagnostic Settings for NGINXaaS using a ARM Bicep or JSON template shows an error (ID-4326)

While using a single template deployment to deploy both, a NGINXaaS instance and a diagnostic setting for the NGINXaaS instance,
you will see a validation error similar to:

```
{"code": "InvalidTemplateDeployment", "message": "The template deployment 'example' is not valid according to the validation procedure. The tracking id is '650afc1e-50d6-476c-bf94-9fc35ffeedd6'. See inner errors for details."}

Inner Errors:
{"code": "OpenAPISpecValidationFailedForTemplateDeploymentResources", "message": "One or more resources in template deployment preflight validation request failed during OpenApi spec (swagger) validation. Please check error details for the resource identifiers."}

Inner Errors:
{"code": "HttpPayloadAPISpecValidationFailed", "target": "/subscriptions/ee920d60-90f3-4a92-b5e7-bb284c3a6ce2/resourceGroups/testenv-1b791f58-workload/providers/NGINX.NGINXPLUS/nginxDeployments/myDeployment/providers/Microsoft.Insights/diagnosticSettings/myLoggingSetting", "message": "Failed during request payload validation against the API specification"}

```

**Workaround**: Deploy your NGINXaaS instance and your diagnostic setting in separate templates.

### {{% icon-bug %}} Not all NGINX Plus directives and use-cases are supported in NGINXaaS (ID-4331)

NGINXaaS currently does not support all NGINX Plus directives and use-cases. We are continually adding new NGINX Plus capabilities into NGINXaaS to close the gap in functionality. You can follow the updates to the supported use-cases by visiting the [Changelog]({{< relref "./changelog.md" >}}). For a comprehensive list of currently allowed directives, please see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

### {{% icon-bug %}} Terraform errors using `package_data` (ID-2752)

Specifying a configuration using a `tar.gz` file and the `package_data` directive fails.

```text
│ Error: Insufficient config_file blocks
│
│   on main.tf line 105, in resource "azurerm_nginx_configuration" "example":
│  105: resource "azurerm_nginx_configuration" "example" {
│
│ At least 1 "config_file" blocks are required.
```

**Workaround:** Extract the files from your `tar.gz` and use the `config_file` directive instead of `package_data`

### {{% icon-bug %}} Deployment responsiveness takes approximately 5-10 seconds. (ID-872)

When creating a new deployment or exposing a new port for traffic, there might be a lag time of 5-10 seconds, during which the Azure Load Balancer does not recognize the new ports, thus preventing making new connections to the NGINX deployment.

**Workaround:** Wait 10 seconds to make requests or make multiple requests to the instance with low connect timeout times after creating a new deployment or exposing a new port to the deployment for the first 10 seconds after the deployment reaches the Completed state.

### {{% icon-bug %}} NGINXaaS for Azure charges do not render correctly in the Azure Portal cost center. (ID-1660)

NGINXaaS for Azure resources appear with a random suffix, and clicking the link does not lead to the NGINXaaS for Azure resource overview page. The charge details show "Unassigned" for all fields, but the charge amount is accurate.

### {{% icon-bug %}} Configuration update will not succeed with a failed certificate. (ID-1545)

If a configuration update request uses a certificate that is in failed `provisioningState`, the configuration update is rejected.

**Workaround:** Update the referenced certificate before updating the configuration. Make sure the certificate provisioning is successful and retry the configuration update.

### {{% icon-bug %}} Known networking limitations (ID-625)

- NGINXaaS deployments cannot access [Private Endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) behind network security groups for private links. Attempts to do so will fail silently.
- NGINXaaS deployments cannot access [Private Endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) in a globally peered VNET. Attempts to do so will fail silently.
- The resource group which contains the public IP resource attached to NGINXaaS deployment cannot be moved across subscriptions. Attempts to do so will result in a validation error.
- Creating an NGINXaaS deployment in a dual-stack subnet is not supported. Attempts to do so will result in a validation error.
- NGINXaaS deployments cannot be created with an IPv6 Public IP address. Attempts to do so will result in a validation error.
- [Network security group](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) (NSG) flow logs will not be available for IP traffic flowing through an NGINXaaS deployment attached to a customer delegated subnet. Flow logs for other resources on the same subnet will be available as normal.

### {{% icon-bug %}} Deployment locked when updating mutliple certificates at once. (ID-767)

Attaching multiple certificates to a deployment quickly will result in a deployment conflict and error with a "409" status code. Certificates are a sub-resource of the deployment, and a user cannot attach multiple certificates to a deployment simultaneously. This issue is more likely to occur when attempting to configure multiple certificates using client tools such as Terraform and ARM templates.

**Workaround:** If you want to add multiple certificates to a deployment, configure resource dependencies between the certificate resources, which will cause them to be added to the deployment one at a time.

**Terraform:**

Use [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) to add a dependency between certificate resources:

{{< highlight hcl "linenos=false,hl_lines=16" >}}
resource "azurerm_nginx_certificate" "cert1" {
  name                     = "examplecert"
  nginx_deployment_id      = azurerm_nginx_deployment.test.id
  key_virtual_path         = "/src/cert/soservermekey.key"
  certificate_virtual_path = "/src/cert/server.cert"
  key_vault_secret_id      = azurerm_key_vault_certificate.test.secret_id
}

resource "azurerm_nginx_certificate" "cert2" {
  name                     = "examplecert"
  nginx_deployment_id      = azurerm_nginx_deployment.test.id
  key_virtual_path         = "/src/cert/soservermekey.key"
  certificate_virtual_path = "/src/cert/server.cert"
  key_vault_secret_id      = azurerm_key_vault_certificate.test.secret_id

  depends_on               = [azurerm_nginx_certificate.cert1]
}
{{< / highlight >}}

**ARM Template**

Use [dependsOn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-dependency) to add a dependency between certificate resources:

{{< highlight json "linenos=false,hl_lines=21" >}}
{
    "type": "NGINX.NGINXPLUS/nginxDeployments/certificates",
    "apiVersion": "2021-05-01-preview",
    "name": "[concat(parameters('nginxDeploymentName'), '/', 'cert1')]",
    "properties": {
        "certificateVirtualPath": "[parameters('certificateVirtualPath')]",
        "keyVirtualPath": "[parameters('keyVirtualPath')]",
        "keyVaultSecretId": "[parameters('keyVaultSecretId')]"
     }
}

{
    "type": "NGINX.NGINXPLUS/nginxDeployments/certificates",
    "apiVersion": "2021-05-01-preview",
    "name": "[concat(parameters('nginxDeploymentName'), '/', 'cert2')]",
    "properties": {
        "certificateVirtualPath": "[parameters('certificateVirtualPath')]",
        "keyVirtualPath": "[parameters('keyVirtualPath')]",
        "keyVaultSecretId": "[parameters('keyVaultSecretId')]"
     }
    "dependsOn": ["cert1"]
}
{{< / highlight >}}

**Bicep Template**

Use [dependsOn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-dependencies) to add a dependency between certificate resources:

{{< highlight bicep "linenos=false,hl_lines=17" >}}
resource cert1 'NGINX.NGINXPLUS/nginxDeployments/certificates@2021-05-01-preview' = {
  name: '${nginxDeploymentName}/cert1'
  properties: {
    certificateVirtualPath: certificateVirtualPath
    keyVirtualPath: keyVirtualPath
    keyVaultSecretId: keyVaultSecretId
  }
}

resource cert2 'NGINX.NGINXPLUS/nginxDeployments/certificates@2021-05-01-preview' = {
  name: '${nginxDeploymentName}/cert2'
  properties: {
    certificateVirtualPath: certificateVirtualPath
    keyVirtualPath: keyVirtualPath
    keyVaultSecretId: keyVaultSecretId
  }
  dependsOn: [cert1]
}
{{< / highlight >}}

### {{% icon-bug %}} Terraform errors around capacity for Basic plan deployments (ID-4880)

Basic plans have no capacity, but older versions of [`azurerm`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) do not handle that well. You may see errors like:

- `azurerm_nginx_deployment` falsely detecting capacity changes from 0 to 20
- `UnsupportedOnBasicPlan: The Basic plan does not support scaling.` errors when running `terraform apply`

**Solution** Upgrade `azurerm` to version v3.116.0 or higher.
