---
description: Create, view, and edit Gateways.
nd-docs: DOCS-373
title: Manage Gateways
toc: true
weight: 120
type:
- tutorial
---

## Overview



A **Gateway** represents the initial network entry point of application and/or API traffic into an F5 NGINX instance in the traffic data path. You can share the same gateway for both application and API traffic.

In a gateway, you define a group of **Ingress URIs** and **Certificates** that can then be used by [Application Components]({{< ref "/controller/app-delivery/about-app-delivery.md#components" >}}). Adding these definitions at the gateway level means you don't have to define the URIs and certificates for each component. Instead, you can inherit these settings from the gateway and only configure each component's relative path(s). Alternatively, you can fully define the URI in the component; doing so will override any settings defined for the gateway.

### Supported Component Types

Gateways support both **HTTP/HTTPS** (commonly referred to as "web") components and **TCP/UDP** components.

There are settings in the gateway, like web URIs, that apply only to web components. Likewise, there are settings in the gateway that apply only to TCP/UDP components, like TCP/UDP URIs.

Gateways also have common settings -- that is, neither web- nor TCP/UDP-specific -- that can apply to either type of component. Components of either type inherit these settings unless they are overridden in the component definition. Component settings can only inherit or override gateway settings if they are of the same type or common setting. (In other words, a TCP/UDP component's settings won't override or inherit a web URI configured in the gateway.)

### TLS

For HTTPS URIs in a gateway, you can add custom TLS Settings associated with a specific URI (and its associated hostname) or add **Shared TLS Settings**. Web components can also have their own custom TLS Settings and Shared TLS Settings.

Web components that do not have any custom TLS Settings or shared TLS settings can inherit the custom TLS settings or the shared TLS settings from the gateway.

For TCP/UDP URIs in a gateway, you can add custom TLS settings associated with a specific URI (IP address and port range) or add **Shared TLS Settings**. TCP/UDP components that do not have any custom TLS Settings or shared TLS settings can inherit the custom TLS settings or shared TLS settings from the gateway.

Web components that do not have any custom TLS settings can inherit TLS settings from the following sources in this order:

- Shared TLS settings for the component
- Custom TLS settings for the gateway (the URI host and port for the component and gateway must match)
- Shared TLS settings for the gateway

TCP/UDP components that do not have any custom TLS settings can inherit TLS settings from the following sources in this order:

- Shared TLS settings for the component
- Custom TLS settings for the gateway (the IP address in the component URI must match or be contained in the IP address in the gateway URI, and the port/port range in the component URI must match or be contained in the port/port range in the gateway URI)
- Shared TLS settings for the gateway

#### Examples

Let's say we created a gateway with an **Ingress URI** definition that contains our application's **FQDN** and the associated **TLS Settings** needed to secure traffic.

In the app component's ingress settings, we define a **Web URI** that uses a relative path. Together, the gateway URI -- "app.acme.com" -- and the component URIs -- "/widgets" -- form the absolute URI for our application: "app.acme.com/widgets". The component uses the certificate configured at the gateway level to secure traffic.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Object | Name | URIs | TLS Setting |
|---|---|---|---|
|Gateway|acme-app-gw|`https://app.acme.com`| `acme-cert-1` <br/> (custom TLS setting for this URI) |
|Web component|acme-app-widgets|`/widgets`| `acme-cert-1` <br/> (inherited from acme-app-gw) |

{{</bootstrap-table>}}

Next, we will add some **TCP/UDP** settings.

In the gateway, we add the TCP/UDP URI noted earlier: `tcp+tls://192.168.1.5:100-104` and a custom TLS setting of `acme-cert-2` for this URI. Then, we add a new TCP/UDP component with the URI `tcp+tls://192.168.1.5:100`.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Object | Name | URIs | TLS Setting |
|---|---|---|---|
|Gateway|acme-app-gw|`https://app.acme.com`, <br/> `tcp+tls://192.168.1.5:100-104`| `acme-cert-1` <br/> `acme-cert-2`|
|Web component|acme-app-widgets|`/widgets`| `acme-cert-1` <br/> (inherited from acme-app-gw) |
|TCP/UDP component|acme-app-tcp-udp|`tcp+tls://192.168.1.5:100`| `acme-cert-2` <br/> (inherited from acme-app-gw) |

{{</bootstrap-table>}}

In this configuration:

- The web component continues to inherit the web URI and certificate from the gateway.
- The TCP/UDP component **will** inherit the TLS setting from the gateway URI.
- The TCP/UDP component **will not** inherit the web URI setting from the gateway.

### Placements

Gateways include **placements** that reference physical NGINX **instances** or **instance groups** (for example, an AWS cloud autoscale group).

Placements define the **physical machines** that are used to manifest a particular path associated with a component.

When multiple placements are defined within a gateway, each placement represents a **resilient path** for any component that references that gateway.



## Before You Begin

- [Create an Environment for your Gateway]({{< ref "/controller/services/manage-environments.md#create-an-environment" >}})

## Create a Gateway



To create a gateway:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services** > **Gateways**.
1. Select **Create Gateway**.
1. Complete each of the configuration sections:

    - [General Configuration]({{< ref "#general-configuration" >}})
    - [Add Placements]({{< ref "#add-placements" >}})
    - [Set Hostnames]({{< ref "#set-hostnames" >}})
    - [Additional Settings]({{< ref "#additional-settings" >}})

1. When ready, review the API Spec and then select **Submit** to create the Gateway.

### General Configuration

On the **Gateways** > **Create Gateway** > **Configuration** page:

1. Provide a name for the gateway.
1. (Optional) Add a friendly display name for the gateway.
1. (Optional) Add a description for the gateway.
1. (Optional) Add any desired tags.
1. (Optional) Select the error response format.
1. Select the environment that will contain the Gateway resource.
1. Select **Next**.

### Add Placements

[Gateways]({{< ref "/controller/services/manage-gateways.md#overview" >}}) include placements that reference NGINX instances or instance groups. Gateway placements can be for multiple instances or instance groups, allowing a gateway to deliver services in multiple data centers and/or clouds. Placements define the physical machines that are used to manifest a particular path associated with an [application component]({{< ref "/controller/app-delivery/about-app-delivery.md#components" >}}).

On the **Gateways > Create Gateway > Placements** page:

1. Select the **Placement Type**:

    - `Instances`
    - `Instance Groups`

1. In the **Instance Refs/Instance Groups Refs** box, select the NGINX instance(s) or instance group(s) on which you want to deploy the gateway.

   {{< note >}}
   If you're enabling **High Availability Mode**, select the [high-availability instances that you prepared]({{< ref "/controller/infrastructure/instances/ha-data-plane.md#prepare-the-high-availability-instances" >}}). NGINX Controller supports up to two high-availability instances.
   {{< /note >}}

1. In the **Listen IPs** box, add the IP address(es) on which the server listens for and accepts requests. If you're creating a placement for a BIG-IP Integration, add the virtual IP (VIP) address for the BIG-IP cluster.

   You can add multiple placements with different Listen IPs. When multiple placements are defined within a gateway, each placement represents a resilient path for any app component that references that gateway.

   {{< note >}}
   - To use non-local **Listen IPs**, you must enable `net.ipv4.ip_nonlocal_bind` on the instance.
   - When **High Availability Mode** is enabled, Virtual Router Redundancy Protocol ([VRRP](https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol#:~:text=The%20Virtual%20Router%20Redundancy%20Protocol,selections%20on%20an%20IP%20subnetwork.)) is configured for the Listen IP address(es).
   {{< /note >}}

1. To enable high-availability mode for your data paths, select **Use High Availability Mode**.

### Set Hostnames

On the **Gateways** > **Create Gateway** > **Hostnames** page:

1. Specify the hostname of the gateway using the following URI format. Include the protocol and port (if non-standard):

   - `http://<fqdn>`
   - `https//<fqdn>`
   - `http://<fqdn>:<port>`
   - `https://<fqdn>:<port>`
   - `tcp[+tls]://<fqdn>:<port>`
   - `udp://<fqdn>:<port>`

1. (Optional) Select a name match method. The default is `EXACT`.
1. (Optional) In the **Cert Reference** list, select a certificate that you want the Gateway to reference or select **Create New** to add a certificate.

### Additional Settings

On the **Gateways** > **Create Gateway** > **Additional** page:

1. (Optional) In the **Methods** list, select one or more of the supported HTTP methods to use.
1. (Optional) In the **Receive Buffer Size** box, set the buffer size to use for reading client requests. The default buffer size is 16k.
1. (Optional) In the **Send Buffer Size** box, set the buffer size to use for reading a response from a disk. The default buffer size is 32k.
1. (Optional) In the **Client Max Body Size** box, set the maximum size allowed for the client request body, specified in the `Content-Length` request header field. The default max body size is 1 MB.
1. (Optional) Select the **Allow Underscores in Headers** toggle to allow underscores in client request header fields. When set to disabled (the default setting), request headers with names that contain underscores are considered invalid and are ignored.
1. (Optional) Select a **TCP Keep Alive** mode to use for the idle, interval, and count settings for keep alive probes.

   - `Use OS defaults` - use the OS default settings.
   - `Explicitly Enable` - set specific values to use for the keep alive probes.
   - `Explicitly Disable` - disable keep alive.

1. (Optional) Add [**Config Snippets**]({{< ref "/controller/app-delivery/about-snippets.md" >}}) to customize your NGINX configuration.

   {{< caution >}}
   When you use Snippets to customize your NGINX configuration, your changes are applied to the `nginx.conf` file *as is*. NGINX Controller does not verify that your configuration is valid before applying the snippet.

   We strongly recommend verifying Snippets in a lab environment before making any changes in production.
   {{< /caution >}}


## View, Edit, and Delete Gateways

To view, edit, and delete Gateways:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Gateways**.
4. On the **Gateways** menu, select **Overview**. The **Gateways Overview** page is displayed and shows a list of your Gateways.
5. To view the details for a Gateway, choose the Gateway from the list. This opens a side panel where you can view the Gateway's linked Components, Certs, and Placements.
6. To edit a Gateway, choose the Gateway from the list, then select **Edit** (pencil icon).
7. To delete a Gateway, choose the Gateway from the list, then select **Delete** (trash icon).

   {{< note >}}If your Gateway has external references, such as Components that reference the Gateway, you'll need to delete or reconfigure the external references before removing the Gateway. Refer to [Manage Apps & Components]({{< ref "/controller/app-delivery/manage-apps.md#edit-or-delete-apps-and-components" >}}) to learn how to edit and delete Components.{{< /note >}}

## Troubleshooting

### Timeouts

Timeouts are commonly reported when an instance doesn't report back to NGINX Controller within 60 seconds. A timeout can occur if one or more instances are under load or lose connectivity to NGINX Controller. If you experience timeouts when configuring a gateway, check your network connection and the status of the instance on which you're deploying the gateway.

## What's Next

- [Set Up Data Plane High Availability]({{< ref "/controller/infrastructure/instances/ha-data-plane.md" >}})
- [Create an App and App Component]({{< ref "/controller/app-delivery/manage-apps.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
