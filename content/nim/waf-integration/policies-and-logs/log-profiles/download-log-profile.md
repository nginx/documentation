---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NIMNGR
title: Download log profile bundles (REST API)
description: "Download a compiled F5 WAF for NGINX security log profile bundle from F5 NGINX Instance Manager using the REST API."
weight: 500
toc: true
f5-keywords: "download log profile bundle, security log profile, WAF, NGINX Instance Manager, NIM, log profile bundle, tgz, REST API, app protect, compiler version, logprofiles, bundles, hash, integrity"
f5-summary: >
  Download a compiled F5 WAF for NGINX security log profile bundle from F5 NGINX Instance Manager using the REST API.
  The downloaded bundle is the compiled output produced by the compile a security log profile API.
  The response includes a hash and size that you can use to verify the integrity of the downloaded bundle against the values returned at compile time.
f5-audience: operator
---

## Overview

Use this guide to download a compiled F5 WAF for NGINX security log profile bundle from F5 NGINX Instance Manager using the REST API. The bundle is the compiled output produced by the [compile a security log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/compile-log-profile.md" >}}) API.

The response includes a `hash` and `size` for the downloaded bundle. Verify these values against the `hash` and `size` returned when the bundle was compiled to confirm the integrity of the download.

---

## Before you begin

Before you begin, make sure you have:

- **NGINX Instance Manager access**: An account with sufficient permissions to manage WAF log profiles. See [Manage roles and permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).
- **A compiled log profile bundle**: A log profile that has already been compiled in NGINX Instance Manager. See [Compile a security log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/compile-log-profile.md" >}}).
- **A REST API client**: A tool such as curl or [Postman](https://www.postman.com/) to send requests to the NGINX Instance Manager REST API.
- **Authentication credentials**: A valid access token or other credentials for the NGINX Instance Manager REST API. See [API overview]({{< ref "/nim/fundamentals/api-overview/" >}}) for supported authentication methods.

---

## Access the REST API

The NGINX Instance Manager REST API base URL uses the following format:

```text
https://<NIM-FQDN>/api/[nim|platform]/<API_VERSION>
```

Replace `<NIM-FQDN>` with the fully qualified domain name of your NGINX Instance Manager host and `<API_VERSION>` with the target API version. All requests require authentication. For details on authentication methods, see the [API overview]({{< ref "/nim/fundamentals/api-overview/" >}}).

---

## Download a security log profile bundle

Send a GET request to the Security Log Profiles API to download a compiled bundle for a specific log profile and compiler version.

| Method | Endpoint |
|--------|----------|
| GET | `/api/platform/v1/security/logprofiles/{logProfileName}/{compilerVersion}/bundle` |

### Send the request

1. Identify the log profile name and compiler version of the bundle you want to download.

    These values correspond to the `logProfileName` and `compilerVersion` fields used when the bundle was compiled. See [Compile a security log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/compile-log-profile.md" >}}).

2. Send the GET request using curl or your preferred API client.

    ```sh
    curl --location 'https://<NIM_FQDN>/api/platform/v1/security/logprofiles/<LOG_PROFILE_NAME>/<COMPILER_VERSION>/bundle' \
    --header 'Authorization: Bearer <ACCESS_TOKEN>'
    ```

    Replace `<NIM_FQDN>` with your NGINX Instance Manager hostname. Replace `<LOG_PROFILE_NAME>` with the name of the log profile. Replace `<COMPILER_VERSION>` with the target WAF compiler version. Replace `<ACCESS_TOKEN>` with your authentication token.

3. Review the JSON response to confirm the download succeeded and to retrieve the bundle content and integrity values.

    ```json
    {
        "compiledBundle": "H4sIAAAAAAAAB+2bWnQcRRTuabNpQyKLq8TTsEQTNDzb9eR/B1KJQ5hF2EMRiUJc3V1922mmbe7u2mZqGiZQ3od4EHITEx70Ih495BCVePXgISfy5NmEQkHwWU5mdn6zu65lKhyvb9rq6Vmv7r2q8867Xd1FrGRe0Xrtsl7YXBBtgEOpwCKY4uGWWEovQm1jIBt6NqEudkIPIZy7StNalEOUGBQmz5uNJ+tWi+pe1g6VYmNkpBGKXj/u8vyOrJRmwN1PBt6vFIuOZ+W7PC9SlRXuRrN6kyVEpYfCeBPBFoS3hRqRRNDQCfq5SGAxpQ5stkF8Qj3cIhYLvDAlmPs+8WMwsX1F4MNmnoeLpWPm+7JMsyl7v/O63W67vsfs0HNjginkfsJoZYlMEopj5lDeV9pgdmto8rU8ajcvIPEGsmBJ+4JrF3kKbrHum6CRsS7MbrOs9TenPWt9VIisUqY9DsnR67eb2MLPhkW3LO+aRdoVt219vfGkR7UQFJMxHGRyl28uzonkuGvbB/IfMMt/TLDStBgn0j7+5/zfj/8shB9gQhx//tR3iI7/MnBJ/J+5ey+dL8eOP8aOrP87/owHY4y/ycJIbxvHkz9FGOo4LwOPQ/6WhWey4F/Fo2Jd/5fCxcRgoiD2k+D49cgJQ3X9l4HWZmvz8lWReb6m2Y0G2Zg4/6uYz1yh3NuUuQEP/44G……",
        "metadata": {
            "compilerVersion": "5.575.0",
            "created": "2026-03-21T11:17:45.312Z",
            "hash": "a3f82c1e6d09b74f5c3a1e8b2d7f0c94e5b6a1d8f2c3e7b0a4d9f1e6c8b2a35",
            "logProfileName": "log_profile_01",
            "logProfileUid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
            "modified": "2026-03-21T11:18:02.741Z",
            "size": 1823,
            "uid": "f0e1d2c3-b4a5-6789-cdef-012345678901"
        }
    }
    ```

    The `compiledBundle` field contains the base64-encoded bundle content. The `hash` and `size` values in `metadata` should match the values returned when the bundle was compiled. If the values don't match, don't deploy the bundle. Recompile the log profile instead.

---

## References

For more information, see:

- [Compile a security log profile]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/compile-log-profile.md" >}})
- [Configure log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/configure-log-profile.md" >}})
- [Deploy log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/deploy-log-profile.md" >}})
- [API overview]({{< ref "/nim/fundamentals/api-overview/" >}})
- [Security Logs]({{< ref "/waf/logging/security-logs.md" >}})