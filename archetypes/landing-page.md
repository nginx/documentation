---
# The title is the product name
title: 
# The URL is the base of the deployed path, becoming "docs.nginx.com/<url>/<other-pages>"
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

[//]: # "This initial section introduces the product to a reader: give a short 1-2 sentence summary of what the product does and its value to the reader."
[//]: # "Name specific functionality it provides: avoid ambiguous descriptions such as 'enables efficiency', focus on what makes it unique."

## Featured content
[//]: # "You can add a maximum of three cards: any extra will not display."
[//]: # "One card will take full width page: two will take half width each. Three will stack like an inverse pyramid."
[//]: # "Some examples of content could be the latest release note, the most common install path, and a popular new feature."

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="<some-title>">}}
    <!-- Each description should be roughly 10 words or less. -->
  {{</card>}}
  <!-- The titleURL and icon are both optional -->
  <!-- Lucide icon names can be found at https://lucide.dev/icons/ -->
  {{<card title="<some-title>" titleUrl="<some-url>" icon="<some-lucide-icon>">}}
    <!-- Each description should be roughly 10 words or less. -->
  {{</card>}}
{{</card-section>}}

## Other content 

[//]: # "You can add any extra content for the page here, such as additional cards, diagrams or text."