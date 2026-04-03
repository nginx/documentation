---
nd-content-type: tech-specs
nd-docs: DOCS-000
nd-product: {PRODUCT_CODE}
title: {Product or component name} technical specifications
description: "{One-sentence summary of what component or system this page covers, under 160 characters.}"
weight: 100
toc: true
nd-keywords: "{component name}, {spec1}, {spec2}, technical specifications, requirements, limits, performance, compatibility"
nd-summary: >
  {Sentence 1: what product, component, or system this page covers.}
  {Sentence 2: what types of specifications the reader can look up here, for example: hardware requirements, performance limits, or compatibility matrices.}
  {Sentence 3 (optional): version scope or platform constraints this page applies to.}
nd-audience: {developer | operator | admin | architect | any}
---

> If you need more information about how to fill in this template, read the accompanying [guide](./guide-tech-specs.md).

> This template includes writing instructions and boilerplate text that you can customize, use as-is, or completely replace with your own text. This text is indicated in {curly brackets}. Make sure you replace the placeholders with your own text.

{Optional introduction — one to two sentences that state which product or component this page covers and what the reader can verify here. Lead with the subject. Do not start with "This page describes". Skip this paragraph if the title is self-explanatory.}

## Overview

{State what product or component these specifications cover. Write two to four sentences covering: what the specifications apply to, what the reader can verify or confirm using this page, and any scope limits such as version range or deployment type. The Overview is the paragraph most likely to be surfaced verbatim by AI assistants — make every sentence independently meaningful.}

---

## Architecture diagram

{Include an architecture diagram for every tech specs page. Place it here, directly after the Overview, so readers build a mental model of the system before they encounter specifications tables. A reader who can visualize the system maps each requirement and limit to a component they have already seen; the diagram makes the rest of the page easier to read and retain.}

{The diagram must show the major components of the product or system, the relationships and data flows between them, and how the system connects to external dependencies such as integrations, data stores, or networks. Use numbered callouts for complex diagrams and provide a legend below the image.}

![{Descriptive alt text: describe what the diagram shows and what it communicates — for example: "Architecture diagram of the {product} showing (1) the controller node, (2) connected worker nodes, and (3) the external API gateway." AI assistants index alt text. Screen readers read it aloud.}]({architecture-diagram-filename.png})

{Optional: legend for diagrams with numbered callouts.}

| Number | Component | Description |
|:--- |:--- |:--- |
| 1 | {Component name} | {One sentence describing what this component does.} |
| 2 | {Component name} | {One sentence describing what this component does.} |
| 3 | {Component name} | {One sentence describing what this component does.} |

---

## System requirements

{Include this section when the product or component requires specific hardware or software to run. Remove if not applicable.}

### Minimum requirements

{Describe the lowest hardware and software configuration on which the product is supported.}

| Component | Minimum |
|:--- |:--- |
| {Component, for example: CPU} | {Minimum value, for example: 2 cores} |
| {Component, for example: RAM} | {Minimum value, for example: 4 GB} |
| {Component, for example: Disk} | {Minimum value, for example: 20 GB} |
| {Component, for example: Operating system} | {Minimum value, for example: Ubuntu 22.04 LTS} |

### Recommended requirements

{Describe the hardware and software configuration that delivers reliable production performance.}

| Component | Recommended |
|:--- |:--- |
| {Component} | {Recommended value} |
| {Component} | {Recommended value} |
| {Component} | {Recommended value} |

---

## Performance limits

{Include this section when the product has measurable throughput, capacity, or rate limits. State each limit as its own row. Do not bury multiple limits in a single cell. Remove if not applicable.}

| Metric | Limit | Notes |
|:--- |:--- |:--- |
| `{metric_name}` | {Value and unit, for example: 10,000 requests per second} | {One sentence on conditions that affect this limit, or None.} |
| `{metric_name}` | {Value and unit} | {Notes or None.} |
| `{metric_name}` | {Value and unit} | {Notes or None.} |

---

## Compatibility

{Include this section when the product integrates with or depends on other systems, platforms, libraries, or protocols. Use a separate subsection for each category of compatibility. Remove if not applicable.}

### Supported platforms

| Platform | Supported versions | Notes |
|:--- |:--- |:--- |
| {Platform name} | {Version range, for example: 20.04, 22.04, 24.04} | {Any exceptions or conditions, or None.} |
| {Platform name} | {Version range} | {Notes or None.} |

### Supported integrations

| Integration | Supported versions | Notes |
|:--- |:--- |:--- |
| {Integration name} | {Version range} | {Notes or None.} |
| {Integration name} | {Version range} | {Notes or None.} |

---

## Networking specifications

{Include this section when the product has network requirements such as ports, protocols, or bandwidth. Remove if not applicable.}

| Property | Value | Notes |
|:--- |:--- |:--- |
| `{property_name}` | {Value, for example: TCP 443} | {One sentence on when this applies, or None.} |
| `{property_name}` | {Value} | {Notes or None.} |

---

## {Optional: Additional specification section}

{Add a section for any specification category not covered above, for example: security certifications, data formats, API rate limits, or storage formats. Name each section after the specification category, using a noun phrase.}

| Property | Value | Notes |
|:--- |:--- |:--- |
| `{property_name}` | {Value} | {Notes or None.} |
| `{property_name}` | {Value} | {Notes or None.} |

---

## Known limits and constraints

{Include this section to document hard limits, unsupported configurations, or behaviors the reader must not exceed. State each limit as an independent sentence. Remove if not applicable.}

- {Limit or constraint. State the exact value and what happens when it is exceeded. For example: "The maximum number of concurrent connections is 1,000. Requests above this limit are rejected with HTTP 503."}
- {Limit or constraint.}
- {Limit or constraint.}

---

## References

For more information, see:

- [{Related how-to guide title}]({link})
- [{Related installation guide title}]({link})
- [{Related reference article title}]({link})
- [{Release notes or changelog title}]({link})