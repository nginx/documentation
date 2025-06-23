---
# The title is the product name
title: 
# The URL is the base of the deployed path, becoming "docs.nginx/<url>/<other-pages>"
url: 
# The cascade directive applies its nested parameters down the page tree until overwritten
cascade:
  # The logo file is resolved from the theme, in the folder /static/images/icons/
  logo:
# The subtitle displays directly underneath the heading of a given page
nd-subtitle: 
# Indicates that this is a custom landing page
nd-landing-page: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: landing-page
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product:
---

## About

[//]: # "These are Markdown comments to guide you through document structure. Remove them as you go, as well as any unnecessary sections."
[//]: # "Use underscores for _italics_, and double asterisks for **bold**."
[//]: # "Backticks are for `monospace`, used sparingly and reserved mostly for executable names - they can cause formatting problems. Avoid them in tables: use italics instead."

[//]: # "Give a short 1-2 sentence summary of what the product does and its value to a customer."
This is a short description about a product highlighting key values, mission, or purpose.

## Featured content

[//]: # "Maximum of three cards available to display."
[//]: # "Each card should be less than 10 words for a description."
[//]: # "If more than three cards are placed here, they are not displayed."
[//]: # "If there is one card, it will take full width and be the only card in the row."
[//]: # "If there is two cards, one card will take half width and there will be two cards in a row."
[//]: # "If there is three cards, there will be two rows, where first row has two equal-sized cards, and second row will have a full width card. Can we inversed in order to feature content."
{{<card-layout>}}
  {{<card-section showAsCards="true" isFeaturedSection="true">}}
    {{<card title="<some-title>">}}
      some-description
    {{</card>}}
    {{<card title="<some-title>" titleUrl="<some-url>" icon="<some-lucide-icon>">}}
      some-description
    {{</card>}}
  {{</card-section>}}
{{</card-layout>}}

## Other content 

[//]: # "Provide any sort of additional supporting content you may want customers to see as well (e.g. more cards, diagrams, changelogs, etc.)"