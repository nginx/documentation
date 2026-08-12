---
f5-content-type: landing-page
f5-docs: DOCS-000
f5-product: {PRODUCT_NAME}
title: {Product name}
description: "{One-sentence summary of what the product does and its core value, under 160 characters.}"
f5-subtitle: {Short value-proposition phrase, displayed directly under the page title}
url: /{product-url-slug}/
weight: 100
f5-landing-page: true
cascade:
  logo: "{Product-Name-product-icon.svg}"
f5-keywords: "{product name}, {feature1}, {feature2}, {common search term}"
f5-summary: >
  {Sentence 1: what the product is and the core value it provides.}
  {Sentence 2: what it's part of, or the problem it solves. Mention a parent product family if applicable.}
f5-audience: {developer | operator | admin | architect | any}
---

> If you need more information about how to fill in this template, read the accompanying [guide](./guide-landing-page.md).

> This template includes writing instructions and boilerplate text that you can customize, use as-is, or completely replace with your own text. This text is indicated in {curly brackets}. Make sure you replace the placeholders with your own text.

{Optional: a single-line callout above the About section — for example a trial link or an included-content shortcode. Remove if not needed.}

## About

[//]: # "This section introduces the product to a reader: give a short 1-2 sentence summary of what the product does and its value to the reader."
[//]: # "Name specific functionality it provides: avoid ambiguous descriptions such as 'enables efficiency' — focus on what makes it unique."
[//]: # "Use underscores for _italics_, and double asterisks for **bold**."
[//]: # "Backticks are for `monospace`, used sparingly and reserved mostly for executable names - they can cause formatting problems. Avoid them in tables: use italics instead."

{2-4 sentences describing the product: what it does, who it's for, and the specific capabilities that make it useful. If this product is part of a larger family, mention that here and link to the [components](#{product-family-slug}-components) section.}

## Featured content

[//]: # "You can add a maximum of three cards in this section: any extra will not display."
[//]: # "One card takes full page width; two take half width each; three stack in an inverse pyramid."
[//]: # "Good candidates: the most common first task (get started/install), the most-read guide, or a popular new feature."

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Get started" titleUrl="getting-started/" icon="unplug" isFullSize="true">}}
    {One sentence, 10 words or fewer, stating the outcome.}
  {{</card >}}
{{</card-section>}}

{{<card-section showAsCards="true" >}}
  {{<card title="{Task-oriented title}" titleUrl="{relative-or-absolute-url}/" >}}
    {One sentence, 10 words or fewer, stating the outcome.}
  {{</card>}}
  {{<card title="{Task-oriented title}" titleUrl="{relative-or-absolute-url}/" >}}
    {One sentence, 10 words or fewer, stating the outcome.}
  {{</ card >}}
  {{<card title="{Task-oriented title}" titleUrl="{relative-or-absolute-url}/">}}
    {One sentence, 10 words or fewer, stating the outcome.}
  {{</card>}}
{{</card-section>}}

## {Optional: named topic section — for example "Workshops"}

[//]: # "Add a named H2 or H3 section when you have a distinct group of content worth calling out on its own, such as workshops, tutorials, or a major feature area. Remove if not needed."

{{<card-section showAsCards="true">}}
  {{<card title="{Title}" titleUrl="{url}/" icon="{lucide-icon-name}" >}}
    {One sentence, 10 words or fewer.}
  {{</card>}}
{{</card-section>}}

## More information

[//]: # "Use this section for secondary content: reference material, RBAC, APIs, glossary, changelog, or release notes. This is typically the last card section on the page."

{{<card-section showAsCards="true" >}}
  {{<card title="{Title}" titleUrl="{url}/" >}}
    {One sentence, 10 words or fewer.}
  {{</card>}}
  {{<card title="{Title}" titleUrl="{url}/" >}}
    {One sentence, 10 words or fewer.}
  {{</card>}}
  {{<card title="View release notes and updates" titleUrl="{url}/releases/" icon="clock-alert">}}
    Get details on new features, bug fixes, and known issues.
  {{</card>}}
{{</card-section>}}

## {Optional: Product family} components

[//]: # "Include this section only if the product is part of a bundle or family of related products, such as a platform console. Group related products under a title-only card-section and use brandIcon (not icon) to display each product's logo. Remove this whole section if the product stands alone."

{{< card-section title="{Category name, for example 'Kubernetes solutions'}">}}
  {{< card title="{Related product name}" titleUrl="/{related-product-slug}/" brandIcon="{Related-Product-product-icon.svg}">}}
    {One sentence describing the related product.}
  {{</ card >}}
{{</ card-section >}}
