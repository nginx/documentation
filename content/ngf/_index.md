---
# The title is the product name
title: NGINX Gateway Fabric
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
url: /nginx-gateway-fabric/
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo: NGINX-Gateway-Fabric-product-icon.svg
  nd-banner:
    enabled: true
    type: deprecation
    start-date: 2025-05-30
    md: /_banners/ngf-2.0-release.md
# The subtitle displays directly underneath the heading of a given page
nd-subtitle: Implement the Gateway API across hybrid and multi-cloud Kubernetes environments with a secure, fast, and reliable NGINX data plane.
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGF
---

## About

NGINX Gateway Fabric provides an implementation of the [Gateway API](https://gateway-api.sigs.k8s.io/) using [NGINX](https://nginx.org/) as the data plane. The goal of the project is to implement the core Gateway APIs needed to configure an HTTP or TCP/UDP load balancer, reverse proxy, or API gateway for Kubernetes applications.

For a list of supported Gateway API resources and features, see the [Gateway API Compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) documentation.

## Featured content

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Get started" titleUrl="/nginx-gateway-fabric/get-started">}}
    Use kind to quickly deploy and test a NGINX Gateway Fabric cluster.
  {{</card>}}
  {{<card title="Deploy NGINX Gateway Fabric" titleUrl="/nginx-gateway-fabric/install">}}
    Choose how to deploy NGINX Gateway Fabric in production.
  {{</card>}}
  {{<card title="Changelog" titleUrl="/nginx-gateway-fabric/changelog">}}
    Review the changes from the latest releases.
  {{</card>}}
{{</card-section>}}

## Design

NGINX Gateway Fabric separates the control plane and data plane into distinct deployments. The control plane interacts with the Kubernetes API, watching for Gateway API resources. 

When a new Gateway resource is provisioned, it dynamically creates and manages a corresponding NGINX data plane Deployment and Service.

Each NGINX data plane pod consists of an NGINX container integrated with [NGINX Agent](https://github.com/nginx/agent). The control plane translates Gateway API resources into NGINX configurations and sends these configurations to the agent to ensure consistent traffic management.

This design enables centralized management of multiple Gateways while ensuring that each NGINX instance stays aligned with the cluster’s current configuration.

For more information, see the [Gateway architecture]({{< ref "/ngf/overview/gateway-architecture.md" >}}) topic.

## More information

{{<card-section showAsCards="true">}}
  {{<card title="Gateway API compatibility" titleUrl="/nginx-gateway-fabric/overview/gateway-api-compatibility/">}}
    View how much of the Gateway API NGINX Gateway Fabric supports.
  {{</card>}}
  {{<card title="Technical specifications" titleUrl="/nginx-gateway-fabric/reference/technical-specifications/">}}
    Check which versions of NGINX Gateway Fabric match the API.
  {{</card>}}
  {{<card title="Routing traffic to applications" titleUrl="/nginx-gateway-fabric/traffic-management/basic-routing/">}}
    Create simple rules for directing network traffic with HTTPRoute resources.
  {{</card>}}
  {{<card title="Secure traffic using Let's Encrypt and cert-manager" titleUrl="/nginx-gateway-fabric/traffic-security/integrate-cert-manager/">}}
    Implement HTTPS with Let's Encrypt to secure client-server communication.
  {{</card>}}
{{</card-section>}}