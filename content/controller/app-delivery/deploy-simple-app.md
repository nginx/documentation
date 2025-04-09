---
description: Overview of the steps required to deploy a simple App.
docs: DOCS-477
title: Deploy a Simple Application
toc: true
weight: 400
type:
- tutorial
---

## Overview

This topic provides an overview of the steps required to create a simple application by using F5 NGINX Controller's user interface. Use the links provided to learn more about each step.

## Create an Environment

First, you'll need to create an Environment.

- [About Environments]({{< ref "/controller/services/manage-environments.md#about-environments" >}})
- [Create an Environment]({{< ref "/controller/services/manage-environments.md#create-an-environment" >}})

## Create a Certificate

If you want to secure your application traffic, you'll need to add Certificates.

If you just want to deploy a simple HTTP application, skip ahead to [Gateways](#create-a-gateway).

{{< tip >}} Make sure that you add the new Cert to the Environment that you created in the previous step.{{< /tip >}}

- [About Certificates]({{< ref "/controller/services/manage-certs.md#about-certificates" >}})
- [Create a certificate]({{< ref "/controller/services/manage-certs.md#create-a-cert" >}})

## Create a Gateway

Next, you'll need to create a Gateway. Be sure to add the Gateway to your Environment.

- [About Gateways]({{< ref "/controller/services/manage-gateways.md#about-gateways" >}})
- [Create a Gateway]({{< ref "/controller/services/manage-gateways.md#create-a-gateway" >}})

## Create an Identity Provider

If you require authentication for any Component, you need to define an Identity Provider. The provider should be in the same environment as your component.
to be in the same environment as your components.

- [Identity Provider]({{< ref "/controller/services/manage-identity-providers.md" >}})

## Create an App

Create an App. The App needs to be in your Environment and needs to connect to your Gateway. If you created a Cert by following the instructions above and added the Cert to the Gateway, the App will access the Cert via the Gateway. If you didn't add the Cert to the Gateway, you can reference the Cert in the App's definition by choosing the Cert from the Certs list.

- [About Apps]({{< ref "/controller/app-delivery/about-app-delivery.md#apps" >}})
- [Create an App]({{< ref "/controller/app-delivery/manage-apps.md#create-an-app" >}})

## Create Components for your App

Finally, create Components for your App. Components let you partition an App into smaller, self-contained pieces that are each responsible for a particular function of the overall application. For example, a Component could correspond to a microservice that, together with several other microservices, comprises a complete application.

- [About Components]({{< ref "/controller/app-delivery/about-app-delivery.md#components" >}})
- [Create a Component]({{< ref "/controller/app-delivery/manage-apps.md#create-a-component" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
