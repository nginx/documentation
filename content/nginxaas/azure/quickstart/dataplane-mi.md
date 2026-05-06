---
title: NGINXaaS Managed Identity on dataplane
weight: 700
toc: true
url: /nginxaas/azure/quickstart/dataplane-mi/
f5-content-type: how-to
f5-product: NAZURE
f5-description: NGINXaaS for Azure deployments can use a system-assigned Managed Identity to authenticate against Azure resources by fetching OAuth2 tokens from IMDS via an njs script.
f5-summary: >
   NGINXaaS for Azure supports using a system-assigned Managed Identity to access other Azure resources by querying the Instance Metadata Service (IMDS) to fetch OAuth2 access tokens.
   An njs script handles token retrieval and downstream API calls, with the example demonstrating blob storage queries using Bearer token authentication.
   IMDS enforces a 5 requests/second rate limit, so tokens should be cached in NGINX rather than fetched per request, and the IMDS endpoint should be restricted to internal access to prevent token exposure.
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) supports using the Managed Identity (MI) assigned to the NGINXaaS deployment to access other Azure resources in the same virtual network or those that are publicly accessible.

NGINX Plus instances that are part of the NGINXaaS deployment now have access to query the identity endpoint in [Instance Metadata Service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) to fetch access tokens.

{{< call-out "important" >}}Exposing the IMDS endpoint externally can allow unintended third parties to retrieve the access tokens associated with the managed identities assigned to the deployment. To mitigate this risk, ensure the endpoint is restricted to internal access or apply appropriate access controls. {{< /call-out >}}

## Configuration

The example below contains a sample NGINX config that uses [njs](https://nginx.org/en/docs/njs/) and the NGINXaaS MI to query a blob storage container. You can also use the standard MSAL libraries to query IMDS.

1. Assign a system-assigned [identity]({{< ref "/nginxaas/azure/getting-started/managed-identity-portal.md" >}}) to the NGINXaaS deployment and grant the identity access to blob storage. Dataplane managed identity access only works with system-assigned managed identities.

2. Create an NGINX config named `nginx.conf` with the following content:



3. Create a javascript file named `query_blob.js` with the following content:



Sending an HTTP request to the `queryBlob` endpoint triggers njs, which fetches an access token from IMDS and uses it to query blob storage.

{{< call-out "note" >}} IMDS enforces a rate limit of 5 requests per second. To optimize performance, cache the access token in NGINX instead of retrieving it for every request. {{< /call-out >}}
