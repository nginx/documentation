---
title: NGINXaaS Managed Identity on dataplane
weight: 700
toc: true
url: /nginxaas/azure/quickstart/dataplane-mi/
type:
- how-to
---

## Overview

F5 NGINX as a Service for Azure (NGINXaaS) supports using the Managed Identity(MI) assigned to the NGINXaaS deployment to access other Azure resources in the same virtual network or those that are accessable publically.

NGINX+ instances that are part of the NGINXaaS deployment now have access to query the identity endpoint in [Instance Metadata Service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) to fetch access tokens.

{{<important>}}Exposing the IMDS endpoint externally can lead to the unintended leakage of access tokens associated with the managed identities assigned to the deployment. To mitigate this risk, ensure the endpoint is restricted to internal access or apply appropriate access controls. {{</important>}}

## Configuration

The example below contains a sample NGINX config that uses [njs](https://nginx.org/en/docs/njs/) and the NGINXaaS MI to query a blob storage container. You can also use the standard MSAL libraries to query IMDS.

1. Assign a system assigned or user assigned [identity]({{< ref "nginxaas-azure/getting-started/managed-identity-portal/">}}) to the NGINXaaS deployment and grant the identity access to blob storage.

2. Create an NGINX config named `nginx.conf` with the following content:

```nginx
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;
error_log /var/log/nginx/error.log info;
load_module modules/ngx_http_js_module.so;
http {
    js_import /etc/nginx/query_blob.js;
    error_log /var/log/nginx/error.log info;
    resolver 168.63.129.16 valid=30s;
    server {
        listen 80;
        location /queryBlob {
            js_content query_blob.queryBlob;
        }
    }
}
```

3. Create a javascript file named `query_blob.js` with the following content:

```javascript
async function fetchAccessToken(r) {
    const resource = "https://storage.azure.com/";
    const apiVersion = "2019-08-01";
    const imdsEndpoint = `http://169.254.169.254/metadata/identity/oauth2/token?resource=${resource}&api-version=${apiVersion}`;
    try {
        const imdsResponse = await ngx.fetch(imdsEndpoint, {
            headers: { "Metadata": "true" }
        });

        if (imdsResponse.status !== 200) {
            let resp = JSON.stringify(imdsResponse);
            r.error(`ERROR: Failed to fetch access token. IMDS returned status: ${resp}`);
            return null;
        }
        let body = await imdsResponse.text();
        const imdsResponseBody = JSON.parse(body);

        let token = imdsResponseBody.access_token;
        return token;
    } catch (err) {
        r.error(`ERROR: Exception occurred while querying IMDS. Details: ${err}`);
        return null;
    }
}

async function queryBlob(r) {
    const storageAccountName = "test-storage";
    const containerName = "test-container";
    const apiEndpoint = `https://${storageAccountName}.blob.core.windows.net/${containerName}?restype=container&comp=list`;

    r.log("fetching access token...");
    const accessToken = await fetchAccessToken(r);

    if (!accessToken) {
        r.return(401, "Failed to fetch access token.");
        return;
    }

    r.log(`INFO: querying blob storage... ${apiEndpoint}`);
    try {
        const reply = await ngx.fetch(apiEndpoint, {
            method: "GET",
            headers: {
                "Authorization": `Bearer ${accessToken}`,
                "x-ms-version": "2019-12-12"
            },
            verify: false
        });

        const body = await reply.text();
        r.return(reply.status, body);
    } catch (err) {
        r.error(`ERROR: Exception occurred while querying Blob Storage. Details: ${err}`);
        r.return(500, "Failed to query Blob Storage.");
    }
}

export default { queryBlob };
```

Sending a http request to the queryBlob endpoint will invoke njs which will query IMDS to get access tokens and use the tokens to query blob storage.

{{<note>}} IMDS enforces a rate limit of 5 requests per second. To optimize performance, cache the access token in NGINX instead of retrieving it for every request.{{</note>}}
