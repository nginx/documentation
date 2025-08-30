---
# The title is the product name
title: "F5 WAF for NGINX"
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
url: /waf/
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo: NGINX-App-Protect-WAF-product-icon.svg
# The subtitle displays directly underneath the heading of a given page
nd-subtitle: A lightweight, high-performance web application firewall for protecting APIs and applications
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

## About

Defend your applications and APIs with a software security solution that seamlessly integrates into DevOps environments as a lightweight web application firewall (WAF), layer 7 denial-of-service (DoS) protection, bot protection, API security, and threat intelligence services.

## Featured content

{{<card-layout>}}
  {{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Overview" titleUrl="/waf/fundamentals/overview">}}
      Learn about how F5 WAF for NGINX works and how it can be used to protect your applications
    {{</card>}}
    {{<card title="Install F5 WAF for NGINX" titleUrl="/waf/install" >}}
      Explore the methods available to deploy F5 WAF for NGINX in your environment
    {{</card>}}
    {{<card title="Changelog" titleUrl="/waf/changelog" icon="clock-alert">}}
      Review the latest changes and improvements to F5 WAF for NGINX
    {{</card>}}
  {{</card-section>}}
{{</card-layout>}}
