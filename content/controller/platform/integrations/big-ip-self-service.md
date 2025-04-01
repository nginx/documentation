---
description: Integrate F5 NGINX Controller with a BIG-IP cluster.
docs: DOCS-786
title: BIG-IP Integration
toc: true
weight: 20
type:
- tutorial
---

## Overview

You can use F5 NGINX Controller to configure a BIG-IP cluster to work with NGINX instances in your app delivery infrastructure. By using NGINX Controller, you can configure your NGINX instances as part of your BIG-IP device's virtual servers and server pools.

NGINX Controller uses the [F5 Application Services 3 Extension (AS3) package](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) to communicate with a BIG-IP cluster. This means NGINX Controller works with any BIG-IP version that supports AS3.

The following diagram shows how client traffic is routed through a BIG-IP cluster and load-balanced to the NGINX instances belonging to the BIG-IP server pools.

<div style="text-align: center">{{< img src="/ctlr/img/big-ip-integration.png" alt="NGINX integration for BIG-IP." width="600" >}}</div>

## Terminology

This topic uses the following terms:

- **VIP**: A Virtual IP address (VIP) is designed to route traffic to a group of backend pool members. A VIP is resilient in a BIG-IP cluster: if a cluster member fails or the cluster is manually failed over, all of the VIPs move to the active cluster.

- **Floating Self IP Address**: [A floating self IP address](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) is an IP address on the BIG-IP cluster that you associate with a VLAN, to access hosts in that VLAN, that two BIG-IP systems share. The floating self IP "floats" to the active BIG-IP instance in a cluster and is used by default for [SNAT automapping](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) traffic leaving the BIP-IP cluster to destination pool members of a VIP.

## Before You Begin

Follow the steps in [install the F5 Application Services 3 Extension (AS3) package](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html) to install AS3 on your BIG-IP system.

## Create a BIG-IP Integration

Create an integration to let NGINX Controller communicate with your BIG-IP cluster:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select **Create Integration**.
5. Give your integration a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the endpoint for your BIG-IP system, for example, `https://192.0.2.0:8443`. For clusters that comprise multiple BIG-IP instances, you can specify the [floating self IP address](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) for your BIG-IP cluster.
11. In the **Credential Type** list, select `USER_PASS`.
12. Add the username and password to use to log into your BIP-IP cluster. This account must have permission to create and delete partitions on BIG-IP.
13. Select **Submit**.

Continue to the next section to create a BIG-IP instance group.

## Add an Instance Group to BIG-IP

An instance group is a logically grouped set of instances that can be used as a placement for a gateway, rather than a single instance. This concept supports the ability to scale horizontally without having to update the gateway placement. As instances are added to a group, they receive an NGINX configuration identical to those instances in the group. Instances in an instance group can be stand-alone or clustered NGINX Plus instances.  Instances can also leave the group, with the remaining instances continuing to function as intended.

{{< important >}}
**Workload affinity with instance groups**: Similar to instances, instance groups are associated with a location. If a location is not explicitly specified, the unspecified location is assumed. Instances in an instance group should be configured to use the same location; however, this requirement is not currently enforced.

For the workload affinity feature, the location of the instance group must be specified using the optional `locationRef` field in the component's workload group API request. The locations of the instances in the instance group are ignored. The workload affinity feature uses this information and the workload groups to load balance traffic to the correct endpoints.
{{< /important >}}

{{< important >}}
Instance groups are supported on the following versions of NGINX Controller:

- NGINX Controller API Management module v3.18 and later
- NGINX Controller Application Delivery module v3.21 and later
{{< /important >}}

To add an NGINX instance group to a BIG-IP cluster, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instance Groups** > **Overview**.
1. On the **Instance Groups** overview page, select **Create Instance Group**.
1. Add a name for the instance group.
1. (Optional) Provide a display name.
1. (Optional) Provide a description.
1. In the **HA Type** list, select `BIG-IP`.
1. In the **Integration Reference** list, select the name of your BIG-IP integration.

   If you haven't created an integration already, refer to [Create a BIG-IP Integration]({{< ref "/controller/platform/integrations/big-ip-self-service.md#create-a-big-ip-integration" >}}) for instructions.

1. In the **Server Pool IP** box, specify the IP address or CIDR of the NGINX instances to add to the BIG-IP server pool; for example, `198.51.100.0/24`. If using a CIDR, the NGINX instance IP addresses that match the mask will be the member addresses in the BIG-IP server pool. Otherwise, absolute IP addresses are used as pool member addresses.
1. Select **Submit** to create the instance group.

{{< important >}}
If you edit an instance group after you've used the group for a gateway placement, you'll need to update the placement as well.
{{< /important >}}

Continue to the next section to add your BIG-IP instance group to a gateway.

## Deploy a Gateway with BIG-IP for a Placement

Take the following steps to deploy a gateway with your BIG-IP instance group for the placement.

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

Once the gateway is deployed, NGINX Controller knows which BIG-IPs to contact and for each BIG-IP, which VIP to deploy and which NGINX instance IPs to direct traffic to.

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

{{< versions "3.21" "latest" "adcvers" >}}
