---
title: "Set log profiles through the API"
weight: 810
toc: true
nd-content-type: reference
nd-product: NONECO
---

You can use F5 NGINX One Console API to manage log profiles. With our API, you can:

- [List log profiles]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listNapLogProfiles" >}})
  - Returns NGINX App Protect log profiles.
- [Create a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/createNapLogProfile" >}})
  - Creates NGINX App Protect log profile.
- [Get log profile details]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/getNapLogProfile" >}})
  - Returns NGINX App Protect log profile details.
- [Update log profile details]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/updateNapLogProfile" >}})
  - Updates NGINX App Protect log profile details.
- [Delete a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/deleteNapLogProfile" >}})
  - Deletes NGINX App Protect log profile.
- [List log profile deployments]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/listNapLogProfileDeployments" >}})
  - Returns NGINX App Protect log profile deployments, providing details such as:
    - Target of the deployment, either an instance or CSG
    - Time of deployment
    - Deployment status
- [Compile a log profile]({{< ref "/nginx-one-console/api/api-reference-guide/#operation/compileNapLogProfile" >}})
  - Issues a compilation request for NGINX App Protect log profile and returns request status or the compiled bundle.
