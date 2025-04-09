---
description: Create, apply, and mange Certs to use with your environments.
docs: DOCS-371
title: Manage Certs
toc: true
weight: 120
type:
- tutorial
---

## Overview

Follow the steps in this topic to create and use Certs with an [Environment]({{< ref "/controller/services/manage-environments.md" >}}).

{{< tip >}}
If you prefer, you can use the F5 NGINX Controller API to create and manage certificates. Refer to the [NGINX Controller API reference guide]({{< ref "/controller/api/_index.md" >}}) (**Services > Certs API**) for details.
{{< /tip >}}

## Before You Begin

- [Create an environment]({{< ref "/controller/services/manage-environments.md#create-an-environment" >}})

## Objectives

- Create a Cert
- View, Edit, and Delete Certs

## About Certificates

**Certificates** can either be created by using the API or from references to **file system paths** on the NGINX instance.

Certificates created via the API -- and their associated **Certificate chains** and **private keys** -- can be defined in either **PKCS12 (binary)** or **PEM (ASCII)** formats. Once created via the API, these certs are stored in PEM format in an internal secret store. References to Certificates stored in the secret store can be associated with the ingress defined in a **gateway** or **component**. This means that the referenced Certificate and key are available to the NGINX instances referenced in the placements associated with gateways and, ultimately, used for decryption/encryption of requests/responses by these NGINX instances.

Certificates that reference file system paths on the NGINX instance let you use private key and certificate data stored directly on the file system of the NGINX instance.

## Create a Cert

To create a Cert:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Certs**.
4. On the **Certs** menu, select **Create Cert**.
5. On the **Create Cert** page, complete the fields to define your Cert.
6. Select **Submit**.

## View, Edit, and Delete Certs

To view, edit, and delete Certs:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Services**.
3. On the **Services** menu, select **Certs**.
4. On the **Certs** menu, select **Overview**. The **Certs Overview** page is displayed and shows a list of your certs.
5. To view the details for a Cert, select the name of the Cert from the list provided. This opens the Cert Overview in a side panel. There, you can see any linked objects, such as Components and Gateways, that are using the Cert. You can also view details about any other certificates in the chain.
6. To edit the Cert, select **Edit Config** on the **Quick Actions** menu.
7. To delete the Cert, select **Delete Config** on the **Quick Actions** menu.

## What's Next

- [Create an app]({{< ref "/controller/app-delivery/manage-apps.md" >}})
- [Create a gateway]({{< ref "/controller/services/manage-gateways.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
