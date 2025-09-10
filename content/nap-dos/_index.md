---
# The title is the product name
title: F5 NGINX App Protect DoS
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
url: /nginx-app-protect-dos/
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo: NGINX-App-Protect-DoS-product-icon.svg
# The subtitle displays directly underneath the heading of a given page
nd-subtitle: Enhance Security, Automate Defense, and Accelerate Protection with NGINX
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-DOS
---

## About
Achieve comprehensive protection against DoS and DDoS attacks for your apps and APIs with a multi-layered, adaptive, automated mitigation strategy for DevOps environments. 

Running natively on NGINX Plus and NGINX Ingress Controller, NGINX App Protect DoS is platform-agnostic and supports deployment options ranging from edge load balancers to individual pods in Kubernetes clusters.

## Featured content
[//]: # "You can add a maximum of three cards: any extra will not display."
[//]: # "One card will take full width page: two will take half width each. Three will stack like an inverse pyramid."
[//]: # "Some examples of content could be the latest release note, the most common install path, and a popular new feature."


{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Deployment" titleUrl="/nginx-app-protect-dos/deployment-guide/learn-about-deployment/">}}
    Read how to install and upgrade NGINX App Protect DoS
  {{</card>}}
  <!-- The titleURL and icon are both optional -->
  <!-- Lucide icon names can be found at https://lucide.dev/icons/ -->
  {{<card title="Troubleshooting" titleUrl="/nginx-app-protect-dos/troubleshooting-guide/how-to-troubleshoot/">}}
    Learn how to debug NGINX App Protect DoS
  {{</card>}}
  {{<card title="Releases" titleUrl="/nginx-app-protect-dos/releases/" icon="clock-alert">}}
    Review changelogs for NGINX App Protect DoS
  {{</card>}}
{{</card-section>}}
