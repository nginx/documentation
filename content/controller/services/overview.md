---
authors: []
categories:
- services
date: "2020-10-26T15:32:41-06:00"
description: Learn about the common tasks and resources that are required to deploy
  and manage Services using NGINX Controller.
docs: DOCS-374
doctypes:
- tutorial
journeys:
- using
personas:
- devops
- secops
roles:
- admin
tags:
- docs
title: Set Up NGINX Controller Services
toc: true
weight: 10
---

## Introduction

As noted in the NGINX Controller [API Overview]({{< relref "/api/overview.md" >}}), NGINX Controller is organized into four top-level areas:

{{< include "general/controller-ia.md" >}}

{{< img src="/ctlr/img/services-object-model-example.png" width="600" alt="Diagram showing the relationship of objects in an Environment within the Services area." >}}
{{< img src="/ctlr/img/traffic-flow-example-1.png" width="600" alt="Example traffic flow through a gateway to app components that represent a back-end application. Certs can be configured at the gateway or at the app component level." >}}

## Common Resources

Just like in the NGINX Controller architecture, the **Services** section of these docs contains information you need to use NGINX Controller to deploy and manage Applications and APIs.
But, before any teams can deploy an App or publish an API, an NGINX Controller Administrator needs to create the common resources that make both possible.

The following are the basic building blocks of any NGINX Controller Service:

1. [Environments]({{< relref "/services/manage-environments.md" >}}) logically group all other Service objects. You can use [Access Management]({{< ref "platform/access-management/" >}}) to grant Users or User Groups permission to access resources in a specific Environment.
1. [Certs]({{< relref "/services/manage-certs.md" >}}) can be used to secure traffic to and from APIs and Applications.
1. [Gateways]({{< relref "/services/manage-gateways.md" >}}) define how to process incoming (ingress) and outgoing (egress) traffic.

Once these shared resources are in place, the teams in your organization can create the resources they need to manage Apps or publish APIs.

{{< tip >}}Refer to the [App Delivery]({{< relref "/app-delivery/" >}}) section for more information about how to use each module.{{< /tip >}}

Finally, to support automation efforts, all of the above and more can be done by using the NGINX Controller REST API. Refer to the [API Reference guide]({{< relref "api/_index.md" >}}) for more information and examples.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
