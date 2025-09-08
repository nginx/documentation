---
# The title is the product name
title: F5 NGINX App Protect WAF
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
url: /nginx-app-protect-waf/
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo: NGINX-App-Protect-WAF-product-icon.svg
# The subtitle displays directly underneath the heading of a given page
nd-subtitle:  Secure, automate, and scale modern apps and APIs with a platform-agnostic WAF 
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

## About

Defend your applications and APIs with a software security solution that seamlessly integrates into DevOps environments as a lightweight web application firewall (WAF), layer 7 denial-of-service (DoS) protection, bot protection, API security, and threat intelligence services. F5 NGINX App Protect delivers consistent protection across distributed architectures and hybrid environments.

## Featured content
[//]: # "You can add a maximum of three cards: any extra will not display."
[//]: # "One card will take full width page: two will take half width each. Three will stack like an inverse pyramid."
[//]: # "Some examples of content could be the latest release note, the most common install path, and a popular new feature."


{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Administration Guide" titleUrl="/nginx-app-protect-waf/v5/admin-guide/overview/">}}
    Read the use cases and technical specifications for NGINX App Protect WAF
  {{</card>}}
  {{<card title="Installing NGINX App Protect WAF" titleUrl="/nginx-app-protect-waf/v5/admin-guide/install/">}}
    Install NGINX App Protect WAF in a virtual environment
  {{</card>}}
  {{<card title="Releases" titleUrl="/nginx-app-protect-waf/v5/releases/" icon="clock-alert">}}
    Review the latest changes to NGINX App Protect WAF
  {{</card>}}
{{</card-section>}}
