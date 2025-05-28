---
# We use sentence case and present imperative tone
title: Use the API to manage your Staged Configurations
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
# Intended for internal catalogue and search, case sensitive:
product: NGINX One
---

You can use F5 NGINX One Console API to manage your Staged Configurations. With our API, you can:

- [Create an NGINX Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/createStagedConfig" >}})
  - The details allow you to add existing configuration files.
- [Get a list of existing Staged Configurations]({{< ref "/nginx-one/api/api-reference-guide/#operation/listStagedConfigs" >}})
  - Be sure to record the `object_id` of your target Staged Configuration for your analysis report.
- [Get an analysis report for an existing Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/getStagedConfigReport" >}})
