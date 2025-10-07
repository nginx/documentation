---
title: "Set security policies through the API"
weight: 800
toc: true
type: reference
product: NGINX One
docs: DOCS-000
---

You can use F5 NGINX One Console API to manage security policies. With our API, you can:

- [List existing policies]({{< ref "/nginx-one/api/api-reference-guide/#operation/listNapPolicies" >}})
  - You can set parameters to sort policies by type.
- [Create a new policy]({{< ref "/nginx-one/api/api-reference-guide/#operation/createNapPolicy" >}})
  - You need to translate the desired policy.json file to base64 format.
- [Get policy details]({{< ref "/nginx-one/api/api-reference-guide/#operation/getNapPolicy" >}})
  - Returns details of the policy you identified with the policy `object_id`.
- [List NGINX App Protect Deployments]({{< ref "/nginx-one/api/api-reference-guide/#operation/listNapPolicyDeployments" >}})
  - The output includes:
    - Target of the deployment
    - Time of deployment
    - Enforcement mode
    - Policy version
    - Threat campaign
    - Attack signature
    - Bot signature
