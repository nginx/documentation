---
description: Learn about F5 NGINX Controller Application Delivery concepts.
docs: DOCS-474
title: About Application Delivery
toc: true
weight: 100
---

## Apps

In F5 NGINX Controller, an App serves as a container for one or more Components. Components represent the backend services that comprise your application. Together, an App and its Components represent the logical partitioning of your application into its composite parts. For example, a Component might correspond to a particular microservice within your application. Each Component you add to an App represents one or more paths via which traffic can reach that microservice.

All Apps and Components live within an [Environment]({{< ref "/controller/services/manage-environments.md" >}}). This means that in order to have access to a particular App, a User needs to have permission to access its Environment. If you need access to an Environment or App, contact your administrator.

## Components

A Component is a child object of an App. Components let you partition an App into smaller, self-contained pieces that are each responsible for a particular function of the overall application. For example, a Component could correspond to a microservice that, together with several other microservices, comprises a complete application.

Each Component contains an ingress definition that includes the fully-qualified domain names (FQDNs) and URIs from clients. These ingress definitions associate incoming requests with a particular path; the certificates that are used for decryption/encryption of HTTPS requests and responses that traverse that path; the backend servers that host the App to which the path delivers the requests; and the rewrites, redirects, and modifications on the requests/responses that occur along the path.

Components can be instantiated on multiple paths corresponding to the placements associated with the Component; these placements are defined within the [Gateway(s)]({{< ref "/controller/services/manage-gateways.md" >}}) referenced in the Component.

## Inherited or Independent Resources

When you configure a Component, you can choose to:

- inherit resources and configurations from the Gateway;
- create and define new resources and configurations specific to the Component; or
- use a combination of inherited and Component-specific configurations.

For example, a Gateway's ingress definition might include the URIs for a Service's FQDN(s) and the associated TLS [certificates]({{< ref "/controller/services/manage-certs.md" >}}), while the Component's ingress definition would contain relative URIs for the FQDN defined in the Gateway:

- Gateway Ingress URIs: `www.example.com`
- Component Ingress URIs: `/about/`, `/docs/`, `/contact/`

Together, the Component's relative paths and the Gateway's FQDN results form the absolute URI for each path (`www.example.com/about/`, `www.example.com/docs/`, and `www.example.com/contact/`).

Likewise, you can configure a Component with its own FQDN and paths, but inherit the TLS certificates from the Gateway. Or, you can configure a Component that doesn't inherit any resources or configurations from the Gateway and uses its own set of definitions.

{{< note >}}The ability to add resources, like Certificates, is determined by your account permissions. If you don't have the ability to add new Certs, contact your administrator. {{< /note >}}

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
