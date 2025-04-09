---
title: "2023"
weight: 200
toc: true
url: /nginxaas/azure/changelog-archive/changelog-2023/
---

Learn about the updates, new features, and resolved bugs in F5 NGINX as a Service for Azure during the year 2023.

To see the latest changes, visit the [Changelog]({{< ref "/nginxaas-azure/changelog" >}}) page.

To see a list of currently active issues, visit the [Known issues]({{< ref "/nginxaas-azure/known-issues.md" >}}) page.

## December 19, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports new metrics**

   NGINXaaS now supports the following metrics derived from NGINX Plus statistics introduced in

   API version 8:
   - SSL statistics for each HTTP upstream and stream upstream
   - SSL statistics for each HTTP server zone and stream server zone
   - Extended statistics for SSL endpoint

   API version 9:
   - Per-worker connection statistics including accepted, dropped, active and idle connections, total and current requests

   For a complete catalog of metrics, see the [Metrics Catalog]({{< ref "/nginxaas-azure/monitoring/metrics-catalog.md">}}).

## December 6, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports NGINX config dry-run**

   NGINXaaS now supports the NGINX config dry-run. See the [Config Validation]({{< ref "/nginxaas-azure/getting-started/nginx-configuration#nginx-configuration-validation" >}}) documentation for instructions on how to use it.


## November 2, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports the Image-Filter dynamic module**

   NGINXaaS now supports the [Image-Filter](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html) dynamic module. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

   NGINXaaS for Azure is now available in Japan East.

   See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## October 31, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports HTTP/3 and QUIC.**

   NGINXaaS can now serve client requests through HTTP/3 connections. NGINX only supports HTTP/3 on the client side and does not support HTTP/3 to upstreams. NGINXaaS utilizes the [OpenSSL](https://openssl.org/) library; however, the OpenSSL compatibility layer it uses does not support [early data](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_early_data).


   ```nginx
   http {
      server {
         # for better compatibility it's recommended
         # to use the same port for http/3 and https
         listen 443 quic reuseport;
         listen 443 ssl;
         ssl_certificate /etc/nginx/foo.pem;
         ssl_certificate_key /etc/nginx/foo.key;
         # ...
      }
   }
   ```

   To get started using HTTP/3 and NGINXaaS:

   - Update the [network security group](https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-filter-network-traffic#create-security-rules) associated with the NGINXaaS deployment’s subnet to allow inbound traffic for HTTP/3 UDP ports in the NGINX configuration.
   See our [FAQ]({{< ref "/nginxaas-azure/faq" >}}), for limits on how many unique ports may be specified in a configuration and a list of restricted ports.

   - Additionally, add a [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) to your deployment and create [SSL/TLS Certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/" >}}). For more information on using NGINX with HTTP/3, see the [HTTP/3 module](https://nginx.org/en/docs/http/ngx_http_v3_module.html).

## October 25, 2023

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

   NGINXaaS for Azure is now available in North Europe.

   See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of regions where NGINXaaS for Azure is available.

## October 15, 2023

- {{% icon-feature %}} **NGINXaaS for Azure supports new dynamic modules**

   NGINXaaS now supports the [OpenTelemetry](https://nginx.org/en/docs/ngx_otel_module.html) and [XSLT](https://nginx.org/en/docs/http/ngx_http_xslt_module.html) modules.

## October 11, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports smaller deployments**

   You can now create or scale deployments to a capacity of 10 NCUs, ideal for small workloads.

## October 9, 2023

- {{% icon-feature %}} **NGINXaaS for Azure maximum capacity increased**

   The maximum capacity of NGINXaaS for Azure has been increased from 160 NCUs to **500 NCUs** under the **Standard** plan. Existing deployments can also benefit from this new limit if users choose to scale up.

   To adjust capacity, refer to [Adjusting Capacity]({{< ref "/nginxaas-azure/quickstart/scaling.md#adjusting-capacity" >}}).

   To learn more about capacity restrictions, refer to [Capacity Restrictions]({{< ref "/nginxaas-azure/quickstart/scaling.md#capacity-restrictions" >}}).

## September 13, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports serving static content**

   An NGINXaaS deployment can now serve static content. See [Hosting Static Content]({{< ref "/nginxaas-azure/quickstart/hosting-static-content.md" >}}) for details.

## August 23, 2023

- {{% icon-resolved %}} **NGINXaaS for Azure now supports attaching a Public IP from a Public IP prefix**

   In the Microsoft Azure portal, you can [create a static public IP address from an IP prefix](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-prefix-portal?tabs=create-default#create-a-static-public-ip-address-from-a-prefix). This release of NGINXaaS introduces support for attaching public IP addresses associated with a public IP prefix to your NGINXaaS deployments.

## Aug 7, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now deploys with a default configuration**

   NGINXaaS new deployments will now include a default configuration, providing a smoother setup experience compared to the previous empty configuration.

   To learn more about configuration, refer to [Upload an NGINX Configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}).

   - {{% icon-feature %}} **NGINXaaS for Azure now supports more directives**

   NGINXaaS now supports new directives. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## July 27, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports higher capacity**

   NGINXaaS for Azure allowed users to create deployments with a maximum capacity of 80 NCUs under the **Standard** plan. A recent change now allows users to deploy up to **160 NCUs**. Existing NGINXaaS deployments should also scale up to 160 NCUs.

   To adjust capacity, refer [Adjusting Capacity]({{< ref "/nginxaas-azure/quickstart/scaling.md#adjusting-capacity" >}}).

   To learn more about capacity restrictions, refer to [Capacity Restrictions]({{< ref "/nginxaas-azure/quickstart/scaling.md#capacity-restrictions" >}}).

## July 13, 2023

- {{% icon-feature %}} **NGINXaaS for Azure automatically rotates SSL/TLS certificates**

   NGINXaaS for Azure now automatically retrieves renewed certificates from Azure Key Vault and applies them to your NGINX deployment. To learn more about this new feature, refer to [Certificate Rotation]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/overview.md#certificate-rotation" >}}).

## July 7, 2023

- {{% icon-feature %}} **Improve compatibility with Azure Key Vault certificates generated through merging from an external provider** (e.g. [keyvault-acmebot](https://github.com/shibayan/keyvault-acmebot))

   Key Vault's certificate merge command puts the server certificate as the last certificate in the generated PFX but NGINX requires that it be the first one in the generated PEM. NGINXaaS will dynamically reorder the certificates to be in chain order with the server certificate first.

- {{% icon-feature %}} **Support NGINX `log_not_found` directive ([docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#log_not_found))**

## June 29, 2023

- {{% icon-feature %}} **NGINXaaS can now proxy and load balance UDP traffic.**

   To configure NGINX to handle UDP traffic, specify the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) directive in your NGINX configuration.

   ```nginx
   stream {
      server {
         listen 53 udp;
         # ...
      }
      # ...
   }
   ```

   To learn more about load balancing UDP traffic with NGINX, see [TCP and UDP Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/).

## June 21, 2023

- {{% icon-resolved %}} **NGINXaaS for Azure accepts configurations larger than 60kB**

   An NGINXaaS deployment can now accept configurations larger than 60kB.

## June 6, 2023

- {{% icon-feature %}} **NGINXaaS for Azure supports new directives**

   NGINXaaS now allows the `ssl_preread` directive and most directives from the `ngx_http_fastcgi_module` module. For a complete list of allowed directives, see the [Configuration Directives List]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#configuration-directives-list" >}}).

## May 31, 2023

- {{% icon-feature %}} **NGINXaaS for Azure is now generally available in more regions**

   NGINXaaS for Azure is now available in the following additional regions:

   - West US 3

   See the [Supported Regions]({{< ref "/nginxaas-azure/overview/overview.md#supported-regions" >}}) documentation for the full list of supported regions.

## May 17, 2023

- {{% icon-feature %}} **NGINXaaS can now proxy and load balance TCP traffic.**

   To configure NGINX to handle TCP traffic, specify the [`stream`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) directive in your NGINX configuration.

   ```nginx
   stream {
      server {
         listen 12345;
         # ...
      }
      # ...
   }
   ```

   To learn more about load balancing TCP traffic with NGINX, see [TCP and UDP Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/).

## May 1, 2023

- {{% icon-feature %}} **NGINXaaS for Azure supports passing traffic to gRPC servers.**

   NGINXaaS can now be configured as a gateway for gRPC services. Refer to NGINX's [gRPC module](https://nginx.org/en/docs/http/ngx_http_grpc_module.html) for more information.

## April 26, 2023

- {{% icon-feature %}} **NGINXaaS for Azure now supports HTTP/2.**

   NGINXaaS can now serve client requests through HTTP/2 connections. NGINX only supports HTTP/2 on the client side and does not support HTTP/2 to upstreams.

   ```nginx
   http {
      server {
         listen 443 ssl http2;

         ssl_certificate server.crt;
         ssl_certificate_key server.key;
         # ...
      }
   }
   ```

   To get started using HTTP/2 and NGINXaaS, add a [Managed Identity]({{< ref "/nginxaas-azure/getting-started/managed-identity-portal.md" >}}) to your deployment and create [SSL/TLS Certificates]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/" >}}). For more information on using NGINX with HTTP/2, see the [HTTP/2 module](https://nginx.org/en/docs/http/ngx_http_v2_module.html).

- {{% icon-resolved %}} NGINXaaS can now serve static files with the `error_page` directive.

## April 17, 2023

- {{% icon-feature %}} **NGINXaaS can now support NGINX configurations to secure HTTP traffic between NGINX and upstreams**

   NGINXaaS now accepts NGINX directives to secure traffic between NGINX and upstream using SSL/TLS certificates.

   Refer to [Securing Upstream Traffic]({{< ref "/nginxaas-azure/quickstart/security-controls/securing-upstream-traffic.md">}}) for more details on how to configure NGINXaaS with these directives.

## April 7, 2023

- {{% icon-feature %}} **NGINX configurations may now listen on ports other than 80 and 443.**

   NGINXaaS now accepts requests on ports in addition to 80 and 443. Inbound ports are specified in the NGINX configuration using the [`listen`](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive.

   NGINXaas can be configured to accept requests on up to 5 unique ports.

   ```nginx
   http {
      server {
         listen 8080;
         # ...
      }
   }
   ```

   Update the [network security group's inbound security rules](https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-filter-network-traffic#create-security-rules) associated with the NGINXaaS deployment's subnet to allow inbound traffic for all listen ports in the NGINX configuration.

   See our [FAQ]({{< ref "/nginxaas-azure/faq" >}}), for limits on how many unique ports may be specified in a configuration and a list of restricted ports.


## March 16, 2023

- {{% icon-resolved %}} Deployment configuration now succeeds after adding a managed identity.

   After adding a managed identity to a deployment, the deployment transitions from an **Accepted** state to a **Succeeded** state only after the operation to add the managed identity succeeds. The user can then proceed to configure the deployment.


## February 21, 2023

- {{% icon-feature %}} **Directives `auth_jwt_key_file` and `auth_jwt_require` are now supported.**

   Refer to the [`auth_jwt_key_file`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file) and [`auth_jwt_require`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require) documentation for more information on using these directives.

   - {{% icon-resolved %}} **PKCS12 certificates may now be added to your NGINXaaS deployment.**

   Previously, NGINXaaS only accepted PEM formatted certificates. Now, both PEM and PKCS12 certificates are supported.

   - {{% icon-resolved %}} **State files may now be used with the `keyval_zone` directive.**

   For information on storing the state of a key-value database with a state file, see [`keyval_zone`](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone)'s documentation.


## January 11, 2023

- {{% icon-feature %}} **NGINXaaS is generally available**

   We are pleased to announce the general availability of NGINX as a Service (NGINXaaS), a first-party-like experience as a service co-developed by Microsoft and NGINX and tightly integrated into the [Azure](https://azure.microsoft.com/) ecosystem.

   NGINXaaS, powered by [NGINX Plus](https://www.nginx.com/products/nginx/), is a fully managed service that removes the burden of deploying your own NGINX Plus cluster, installing libraries, upgrading, and managing it.

   NGINXaaS simplifies the process of moving your [existing NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration#add-nginx-configuration" >}}) to the Azure cloud. Once your configurations are moved to Azure, [securely manage SSL/TLS certificates and keys stored in Azure Key Vault and reference them within your NGINX configurations]({{< ref "/nginxaas-azure/getting-started/ssl-tls-certificates/ssl-tls-certificates-portal.md" >}}). You can [watch your application's traffic in real time]({{< ref "/nginxaas-azure/monitoring/enable-monitoring" >}}) with Azure monitoring and alerts, and scale your deployment to fit your needs, maximizing cost efficiency.
   You can create, update, and delete your NGINXaaS deployment using the [Azure Resource Manager]({{< ref "/nginxaas-azure/client-tools/templates.md" >}}), the [Azure SDK]({{< ref "/nginxaas-azure/client-tools/sdk" >}}), [CLI]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-azure-cli.md" >}}), and [Terraform]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-terraform.md" >}}) in addition to the [Azure portal]({{< ref "/nginxaas-azure/getting-started/create-deployment/" >}}).

   Our new "Standard" plan is ready for production workloads.

   To learn more, refer to the following NGINXaaS documentation:

   - [NGINXaaS for Azure overview]({{< ref "/nginxaas-azure/overview/overview.md" >}})
   - [NGINXaaS, NGINX Plus, and NGINX Open Source feature comparison]({{< ref "/nginxaas-azure/overview/feature-comparison.md" >}})
   - [NGINXaaS billing details]({{< ref "/nginxaas-azure/billing/overview.md" >}})

## January 10, 2023

- {{% icon-resolved %}} **Special parameters in `map` and `geo` directives are now supported.**

- {{% icon-resolved %}} **The `match` directive is now supported.**