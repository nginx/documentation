---
date: "2021-09-01T10:36:03-07:00"
description: Integrate NGINX Controller with a BIG-IP cluster.
docs: DOCS-786
doctypes:
- tutorial
draft: false
journeys:
- using
personas:
- devops
roles:
- admin
tags:
- docs
title: BIG-IP Integration
toc: true
weight: 20
---

## Overview

You can use NGINX Controller to configure a BIG-IP cluster to work with NGINX instances in your app delivery infrastructure. By using NGINX Controller, you can configure your NGINX instances as part of your BIG-IP device's virtual servers and server pools. 

NGINX Controller uses the [F5 Application Services 3 Extension (AS3) package](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/) to communicate with a BIG-IP cluster. This means NGINX Controller works with any BIG-IP version that supports AS3.

The following diagram shows how client traffic is routed through a BIG-IP cluster and load-balanced to the NGINX instances belonging to the BIG-IP server pools.

<div style="text-align: center">{{< img src="/platform/integrations/assets/big-ip-integration.png" alt="NGINX integration for BIG-IP." width="600" >}}</div>

## Terminology

This topic uses the following terms:

- **VIP**: A Virtual IP address (VIP) is designed to route traffic to a group of backend pool members. A VIP is resilient in a BIG-IP cluster: if a cluster member fails or the cluster is manually failed over, all of the VIPs move to the active cluster.

- **Floating Self IP Address**: [A floating self IP address](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) is an IP address on the BIG-IP cluster that you associate with a VLAN, to access hosts in that VLAN, that two BIG-IP systems share. The floating self IP "floats" to the active BIG-IP instance in a cluster and is used by default for [SNAT automapping](https://techdocs.f5.com/en-us/bigip-14-1-0/big-ip-tmos-routing-administration-14-1-0/self-ip-addresses.html) traffic leaving the BIP-IP cluster to destination pool members of a VIP.

## Before You Begin

Follow the steps in [install the F5 Application Services 3 Extension (AS3) package](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html) to install AS3 on your BIG-IP system.

## Create a BIG-IP Integration

{{< include "integrations/big-ip-integration.md" >}}

Continue to the next section to create a BIG-IP instance group.

## Add an Instance Group to BIG-IP

{{< include "instance-groups/about-instance-groups.md" >}}

{{< include "instance-groups/add-big-ip-instance-group.md" >}}

Continue to the next section to add your BIG-IP instance group to a gateway.

## Deploy a Gateway with BIG-IP for a Placement

Take the following steps to deploy a gateway with your BIG-IP instance group for the placement.

{{< include "gateways/add-gateway.md" >}}

### General Configuration

{{< include "gateways/gateway-general.md" >}}

### Add Placements

{{< include "gateways/gateway-placements.md" >}}

### Set Hostnames

{{< include "gateways/gateway-hostnames.md" >}}

Once the gateway is deployed, NGINX Controller knows which BIG-IPs to contact and for each BIG-IP, which VIP to deploy and which NGINX instance IPs to direct traffic to.

### Additional Settings

{{< include "gateways/gateway-advanced.md" >}}

{{< versions "3.21" "latest" "adcvers" >}}
