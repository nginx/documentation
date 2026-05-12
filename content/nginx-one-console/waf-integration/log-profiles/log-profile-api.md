---
title: "Set log profiles through the API"
weight: 810
toc: true
f5-content-type: reference
f5-product: NONECO
f5-summary: NGINX One Console API enables full CRUD management of WAF log profiles, plus listing deployments (target, time, status) and compiling profiles into .tgz bundles for specific WAF compiler versions with optional download.
---

You can use F5 NGINX One Console API to manage log profiles. With our API, you can:

- [List log profiles]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listWafLogProfiles" >}})
  - Returns WAF log profiles.
- [Create a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/createWafLogProfile" >}})
  - Creates WAF log profile.
- [Get log profile details]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getWafLogProfile" >}})
  - Returns WAF log profile details, including the JSON configuration contents.
- [Update log profile details]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateWafLogProfile" >}})
  - Updates WAF log profile details.
- [Delete a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteWafLogProfile" >}})
  - Deletes WAF log profile.
- [List log profile deployments]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listWafLogProfileDeployments" >}})
  - Returns WAF log profile deployments, providing details such as:
    - Target of the deployment, either an instance or CSG
    - Time of deployment
    - Deployment status
- [Compile a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/compileWafLogProfile" >}})
  - Compiles the log profile into a bundle (.tgz) for a specific WAF compiler version. Use `download=true` to download the compiled bundle, or `download=false` to retrieve the compilation status (whether the bundle is already compiled or compilation is pending).
