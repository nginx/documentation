---
title: Install the AS3 extension on BIG-IP
description: Install the F5 Application Services 3 extension, which F5 Container Ingress Services uses to configure BIG-IP.
weight: 50
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-0000
f5-audience: operator
f5-keywords: BIG-IP, AS3, Application Services 3, iApps, Package Management LX, F5 CIS, Container Ingress Services
f5-summary: F5 Container Ingress Services configures BIG-IP by posting AS3 declarations, so the AS3 extension must be installed before either GatewayLink guide. This page covers checking whether AS3 is already present and installing it if it is not.
---

Learn how to install the F5 Application Services 3 extension on BIG-IP.

## Overview

F5 Container Ingress Services configures BIG-IP by posting AS3 declarations, so BIG-IP needs the AS3 extension installed before you follow either GatewayLink guide.

## Before you begin

You need:

- An F5 BIG-IP system running version {{< version-bigip >}} or later, with administrator privileges.
- Network access to the BIG-IP management address.

Replace `<BIGIP_ADDRESS>` with the BIG-IP management address including the port, for example `192.0.2.10:8443`. Replace `<BIGIP_USERNAME>` and `<BIGIP_PASSWORD>` with your BIG-IP credentials.

## Install AS3

Download the AS3 package from the [F5 Application Services 3 Extension releases](https://github.com/F5Networks/f5-appsvcs-extension/releases) page. This guide uses version {{< version-as3 >}}.

Install the package through the BIG-IP web interface. Sign in to BIG-IP, go to **iApps > Package Management LX**, select **Import**, choose the RPM file, and select **Upload**.

Confirm AS3 is serving:

```shell
curl -sku '<BIGIP_USERNAME>:<BIGIP_PASSWORD>' "https://<BIGIP_ADDRESS>/mgmt/shared/appsvcs/info" | python3 -m json.tool
```

The response contains the installed AS3 version:

```json
{
    "version": "3.56.0",
    "release": "10",
    "schemaCurrent": "3.56.0",
    "schemaMinimum": "3.0.0"
}
```

A `404` response means AS3 is installed but not serving. See [The endpoint returns 404 after installing](#the-endpoint-returns-404-after-installing).

## Troubleshooting

### The endpoint returns 404 after installing

The package is installed but the BIG-IP iApp LX subsystem is not serving requests. The BIG-IP web interface reports the same state under **iApps > Package Management LX**.

Restart the two REST daemons over SSH on BIG-IP:

```shell
bigstart restart restjavad
bigstart restart restnoded
```

The restart does not interrupt traffic. BIG-IP keeps serving traffic on the existing configuration and only configuration modifications are blocked.

## References

- [F5 Application Services 3 Extension releases](https://github.com/F5Networks/f5-appsvcs-extension/releases): RPM downloads.
