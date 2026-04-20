---
nd-content-type: how-to
nd-docs: DOCS-000
nd-product: NIMNGR
title: Compile log profiles (REST API)
description: "Compile an F5 WAF for NGINX security log profile into a deployment bundle using the NGINX Instance Manager REST API."
weight: 300
toc: true
nd-keywords: "compile log profile, security log profile, WAF, NGINX Instance Manager, NIM, log profile bundle, tgz, REST API, app protect, compiler version, logprofiles, bundles"
nd-summary: >
  Compile an existing F5 WAF for NGINX security log profile into a bundle (.tgz) for a specific WAF compiler version using the NGINX Instance Manager REST API.
  Compiling a log profile is required before the profile can be deployed to NGINX instances.
  The compiled bundle includes a hash and size value that you can use to validate bundle integrity at download time.
nd-audience: operator
---

## Overview

Use this guide to compile an existing F5 WAF for NGINX security log profile into a bundle using the NGINX Instance Manager REST API. Compiling a log profile produces a compressed archive (.tgz) for a specific WAF compiler version. The bundle must be compiled before the log profile can be deployed to NGINX instances.

The API response includes a hash and size for each bundle. Use these values to validate bundle integrity when you download the bundle.

---

## Before you begin

Before you begin, make sure you have:

- **NGINX Instance Manager access**: An account with sufficient permissions to manage WAF log profiles. See [Manage roles and permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).
- **An existing security log profile**: A log profile already created in NGINX Instance Manager. See [Configure log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}}).
- **A REST API client**: A tool such as curl or [Postman](https://www.postman.com/) to send requests to the NGINX Instance Manager REST API.
- **Authentication credentials**: A valid access token or other credentials for the NGINX Instance Manager REST API. See [API overview]({{< ref "/nim//fundamentals/api-overview.md" >}}) for supported authentication methods.

---

## Access the REST API

The NGINX Instance Manager REST API base URL uses the following format:

```text
https://<NIM-FQDN>/api/[nim|platform]/<API_VERSION>
```

Replace `<NIM-FQDN>` with the fully qualified domain name of your NGINX Instance Manager host and `<API_VERSION>` with the target API version. All requests require authentication. For details on authentication methods, see the [API overview]({{< ref "/nim//fundamentals/api-overview.md" >}}).

---

## Compile a security log profile bundle

Send a POST request to the Security Log Profiles API to compile one or more log profiles into bundles.

| Method | Endpoint |
|--------|----------|
| POST | `/api/platform/v1/security/logprofiles/bundles` |

### Send the request

1. Prepare a JSON request body that specifies the log profile name and target compiler version for each bundle you want to compile.

    You can compile multiple log profiles in a single request by adding entries to the `bundles` array.

    

2. Send the POST request using curl or your preferred API client.

    
    curl -X POST https://<NIM_FQDN>/api/platform/v1/security/logprofiles/bundles \
        -H "Authorization: Bearer <ACCESS_TOKEN>" \
        -d @default-log-example-bundles.json
    ```

    Replace `<NIM_FQDN>` with your NGINX Instance Manager hostname and `<ACCESS_TOKEN>` with your authentication token.

3. Review the JSON response to confirm that compilation has started or completed for each log profile.

    ```json
    {
        "items": [
            {
                "compilationStatus": {
                    "status": "compiling"
                },
                "metadata": {
                    "compilerVersion": "<COMPILER_VERSION>",
                    "created": "2026-04-08T03:42:33.902171669Z",
                    "hash": "",
                    "logProfileName": "<LOG_PROFILE_01>",
                    "logProfileUid": "d974876d-0c70-4bae-b396-692023968cd2",
                    "modified": "2026-04-08T03:42:33.902171669Z",
                    "size": 0,
                    "uid": "0fea39c3-5512-4a4d-83c9-32e95435fd0d"
                }
            },
            {
                "compilationStatus": {
                    "status": "compiled"
                },
                "metadata": {
                    "compilerVersion": "<COMPILER_VERSION>",
                    "created": "2026-04-08T03:42:30.424Z",
                    "hash": "7b669d6b9907162ca45cc1f62e866a8c8aaee875743ab0f68c99e0afcbb1e050",
                    "logProfileName": "<LOG_PROFILE_02>",
                    "logProfileUid": "858d0ee3-da6a-4b38-a151-51db36ff163d",
                    "modified": "2026-04-08T03:42:32.379Z",
                    "size": 1647,
                    "uid": "63db6f0e-f82c-405c-8b88-dbadeea68190"
                }
            }
        ]
    }
    ```

    A `status` of `compiling` means the bundle is still being processed. A `status` of `compiled` means the bundle is ready. For bundles with a `compiled` status, the response includes a `hash` and `size` that you can use to validate integrity when downloading the bundle.

---

## References

For more information, see:

- [Configure log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}})
- [Review log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/review-log-profile.md" >}})
- [Deploy log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/deploy-log-profile.md" >}})
- [API overview]({{< ref "/nim//fundamentals/api-overview.md" >}})
- [Security Logs]({{< ref "/waf/logging/security-logs.md" >}})