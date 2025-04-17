---
description: Learn about the common tasks and resources that are required to deploy
  and manage Services using F5 NGINX Controller.
docs: DOCS-374
title: Set Up NGINX Controller Services
toc: true
weight: 10
type:
- tutorial
---

## Introduction

As noted in the F5 NGINX Controller [API Overview]({{< ref "/controller/api/overview.md" >}}), NGINX Controller is organized into four top-level areas:

- **Analytics**: Enables data visualization for NGINX Controller.
- **Infrastructure**: Lets you manage your NGINX Plus instances and certain aspects of the host machines on which NGINX Controller and NGINX Plus instances run.
- **Platform**: Lets you manage NGINX Controller options and configurations, including Users, Roles, Licenses, and Global Settings.
- **Services**: Lets you manage your applications and APIs.

The diagrams below demonstrate how the different objects at the Service level relate to each other:

1. All Service objects are part of an Environment.
1. Gateways and Certs can be defined at the Environment level --or-- at the Component Level. The diagram below shows an example of how traffic flows through a Gateway to an App.
1. Components are child objects that represent the back-end server(s) that host your App or API.
    {{<note>}}A Component can represent an application **or** an API. The same Component cannot be used for both App Delivery and API Management.{{</note>}}
1. Certs can be added to a Gateway or to an individual Component.

{{< img src="/ctlr/img/services-object-model-example.png" width="600" alt="Diagram showing the relationship of objects in an Environment within the Services area." >}}
{{< img src="/ctlr/img/traffic-flow-example-1.png" width="600" alt="Example traffic flow through a gateway to app components that represent a back-end application. Certs can be configured at the gateway or at the app component level." >}}

## Common Resources

Just like in the NGINX Controller architecture, the **Services** section of these docs contains information you need to use NGINX Controller to deploy and manage Applications and APIs.
But, before any teams can deploy an App or publish an API, an NGINX Controller Administrator needs to create the common resources that make both possible.

The following are the basic building blocks of any NGINX Controller Service:

1. [Environments]({{< ref "/controller/services/manage-environments.md" >}}) logically group all other Service objects. You can use [Access Management]({{< ref "/controller/platform/access-management/" >}}) to grant Users or User Groups permission to access resources in a specific Environment.
1. [Certs]({{< ref "/controller/services/manage-certs.md" >}}) can be used to secure traffic to and from APIs and Applications.
1. [Gateways]({{< ref "/controller/services/manage-gateways.md" >}}) define how to process incoming (ingress) and outgoing (egress) traffic.

Once these shared resources are in place, the teams in your organization can create the resources they need to manage Apps or publish APIs.

{{< tip >}}Refer to the [App Delivery]({{< ref "/controller/app-delivery/" >}}) section for more information about how to use each module.{{< /tip >}}

Finally, to support automation efforts, all of the above and more can be done by using the NGINX Controller REST API. Refer to the [API Reference guide]({{< ref "/controller/api/_index.md" >}}) for more information and examples.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
