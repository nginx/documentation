---
# The title is the product name
title: NGINX Ingress Controller
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
url: /nginx-ingress-controller/
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo: NGINX-Ingress-Controller-product-icon.svg
# The subtitle displays directly underneath the heading of a given page
nd-subtitle: 
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NIC
---

## About

NGINX Ingress Controller is an [Ingress Controller]({{< ref "/nic/glossary.md#ingress-controller">}}) implementation for NGINX that can load balance Websocket, gRPC, TCP and UDP applications. 

It supports standard [Ingress]({{< ref "/nic/glossary.md#ingress">}}) features such as content-based routing and TLS/SSL termination. Several NGINX and NGINX Plus features are available as extensions to Ingress resources through [Annotations]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-annotations">}}) and the [ConfigMap]({{< ref "/nic/configuration/global-configuration/configmap-resource">}}) resource.

## Featured content

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Install NGINX Ingress Controller with Helm" titleUrl="/nginx-ingress-controller/installation/installing-nic/installation-with-helm">}}
    Use Helm to deploy and configure a NGINX Ingress Controller cluster
  {{</card>}}
  {{<card title="Migrate from Ingress-NGINX Controller" titleUrl="/nginx-ingress-controller/installation/ingress-nginx">}}
    Replace an Ingress-NGINX cluster with NGINX Ingress Controller
  {{</card>}}
  {{<card title="Releases" titleUrl="/nginx-ingress-controller/releases">}}
    Review the changes from the latest NGINX Ingress Controller releases
  {{</card>}}
{{</card-section>}}