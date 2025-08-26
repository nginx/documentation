---
title: NGINX Agent
url: /nginx-agent/
cascade:
  logo: NGINX-Agent-product-icon.svg
  nd-banner:
    enabled: true
    type: deprecation
    start-date: 2025-05-29
    end-date: 2025-09-09
    md: /_banners/agent-v3-release.md
# The subtitle displays directly underneath the heading of a given page
nd-subtitle:
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: Agent
---

## About

NGINX Agent is a companion daemon for your NGINX Open Source or NGINX Plus instance. It enables remote management of NGINX
configurations, collection and reporting of real-time NGINX performance and operating system metrics, and notifications of NGINX events.

[//]: # "This initial section introduces the product to a reader: give a short 1-2 sentence summary of what the product does and its value to the reader."
[//]: # "Name specific functionality it provides: avoid ambiguous descriptions such as 'enables efficiency', focus on what makes it unique."

## Featured content
[//]: # "You can add a maximum of three cards: any extra will not display."
[//]: # "One card will take full width page: two will take half width each. Three will stack like an inverse pyramid."
[//]: # "Some examples of content could be the latest release note, the most common install path, and a popular new feature."

{{<card-layout>}}
  {{<card-section showAsCards="true" isFeaturedSection="true">}}
    {{<card title="About" titleUrl="/nginx-agent/about" icon="info">}}
      Learn everything you need to know about NGINX Agent
    {{</card>}}
    <!-- The titleURL and icon are both optional -->
    <!-- Lucide icon names can be found at https://lucide.dev/icons/ -->
    {{<card title="Getting started" titleUrl="/nginx-agent/installation-upgrade/getting-started" icon="unplug">}}
      Install NGINX Agent and run a mock control plane
    {{</card>}}
  {{</card-section>}}
{{</card-layout>}}

{{<card-layout>}}
  {{<card-section showAsCards="true" isFeaturedSection="true">}}
    {{<card title="Upgrade" titleUrl="/nginx-agent/installation-upgrade/upgrade/" icon="circle-fading-arrow-up">}}
    {{</card>}}
    {{<card title="Configuration" titleUrl="/nginx-agent/configuration" icon="cog">}}
    {{</card>}}
    {{<card title="Support" titleUrl="/nginx-agent/support" icon="hand-helping">}}
    {{</card>}}
  {{</card-section>}}
{{</card-layout>}}