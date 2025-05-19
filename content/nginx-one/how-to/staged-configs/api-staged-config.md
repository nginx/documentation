---
# We use sentence case and present imperative tone
title: Use the API to manage your Staged Configurations
# Weights are assigned in increments of 100: determines sorting order
weight: 500
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: how-to
# Intended for internal catalogue and search, case sensitive:
product: NGINX One
---

You can use F5 NGINX One Console API to manage your Staged Configurations. With our API, you can:

- [Create an NGINX Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/createStagedConfig" >}})
  - Use details to add existing configuration files.
- [Get a list of existing Staged Configurations]({{< ref "/nginx-one/api/api-reference-guide/#operation/listStagedConfigs" >}})
  - Record the `object_id` of your target Staged Configuration for your analysis report.
- [Get an analysis report for an existing Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/getStagedConfigReport" >}})
  - Review the same recommendations found in the UI.
- [Export a Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/exportStagedConfig" >}})
  - Exports an existing Staged Configuration from the console. It sends you an archive of that configuration in `tar.gz` format.
- [Import a Staged Configuration]({{< ref "/nginx-one/api/api-reference-guide/#operation/importStagedConfig" >}})
  - Imports an existing Staged Configuration from your system and sends it to the console. This REST call assumes that your configuration is archived in `tar.gz` format.
- [Bulk manage multiple Staged Configurations]({{< ref "/nginx-one/api/api-reference-guide/#operation/bulkStagedConfigs" >}})
  - Allows you to delete multiple Staged Configurations. Requires each `object_id`.
  
  For several API endpoints, we ask for a `conf_path`. Make sure to set an absolute file path. If you make a REST call without an absolute file path, you'll see a 400 error message.
