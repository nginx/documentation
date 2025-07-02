---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  enable and configure caching to improve the performance of your API gateway proxy.
nd-docs: DOCS-1190
title: Proxy Cache
toc: true
weight: null
type:
- reference
---

## Overview

{{< include "acm/how-to/policies-proxy-intro.md" >}}

---

## About the Policy

Enable and configure caching to improve the performance of your API Gateways, speed up delivery to clients, and reduce the load on the backend API runtimes. When caching is enabled, the API Gateway saves responses to a disk cache and uses them to respond to clients without having to proxy requests for the same content every time.

By default, the API Gateway caches all responses to requests made with the HTTP GET and HEAD methods the first time such responses are received from a proxied server. The API Gateway uses the request string as a request's key (identifier). If a request has the same key as a cached response, the API Gateway sends the cached response to the client. You can customize and control which responses are cached.

Fine-tune the cache for further improvements in performance by instructing it to use conditional GET requests when refreshing content from origin servers, set a minimum request number to cache content, enable background update, and cache lock.

### Intended Audience

{{< include "acm/how-to/policies/api-owner-persona.md">}}

---

## How to apply the policy

- Create an API proxy or edit an existing one.
- Check the advanced settings for the API proxy to see if the policy has been applied.
- Edit the policy to make changes for each API proxy. Save and publish the changes.

---

## Policy Settings

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field        | Datatype | Possible Values     | Description                                        | Required | Default               |
|--------------|----------|---------------------|----------------------------------------------------|----------|-----------------------|
| `httpMethods`   | array  | GET, HEAD, POST  | HTTP request methods to cache. | No | GET, HEAD |
| `cacheKey` | array   | host, requestURI, scheme, cookieJSessionID, cookieUser | Keys to be cached. 'host' is the name & port of the proxied server. 'requestURI' is the URI of the request. 'scheme' is the protocol used to access the resource on the proxied server. 'cookieJSessionID' is the cookie used for session management. 'cookieUser' is the cookie used for user management.  | No | host, requestURI, scheme |
| `maxCacheSize`   | string  | 1K (available units - K, M, G) | Upper limit of the size of the cache. | No | 1G |
| `cacheValidTime`   | string  | 1s (available units - s, m, h) | Enforces an expiration for the cached data. | No | 10m |
| `minUseOfProxyToCache`   | integer  | 1 | Minimum number of client requests before caching is enabled. | No | 1 |
| `reValidate`   | boolean  | true/false | Enables revalidation of expired cache items using conditional GET requests with the If-Modified-Since and If-None-Match header fields. | No | false |
| `backgroundUpdate` | boolean  | true/false | Enables delivery of stale content when clients request an item that is in the process of being updated from the origin server. All updates will be done in the background. The stale file is returned for all requests until the updated file is fully downloaded. | No | false |
| `stale.backendErrors`   | array  | error, timeout, invalid_header, updating | Determines in which cases a stale cached response can be used during communication with the proxied server. | No |  |
| `stale.backendCodes`   | array  | 403, 404, 429, 500, 502, 503, 504 | Determines for which HTTP status codes a stale cached response can be used during communication with the proxied server. | No |  |
| `cacheLock.enabled`   | boolean  | true/false | When enabled, only one request at a time will be allowed to populate a new cache element identified according to the cacheKey by passing a request to a proxied server. | No | false |
| `cacheLock.age`   | string  | 1s (available units - s, m, h) | If the last request passed to the proxied server for populating a new cache element has not completed for the specified time, one more request may be passed to the proxied server. | No | 5s  |
| `cacheLock.timeout`   | string  | 1s (available units - s, m, h) | Sets a timeout for cacheLock; When the time expires, the request will be passed to the proxied server, however, the response will not be cached. | No | 5s |

{{< /bootstrap-table >}}


---

## Adding the Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To apply the Proxy Cache policy using the REST API, send an HTTP `POST` request to the Proxies endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint            |
|--------|---------------------|
| `POST` | `/services/workspaces/{workspaceName}/proxies` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request</summary>

``` json
{
    "policies": {
        "proxy-cache": [
            {
                "action": {
                    "httpMethods": [
                        "GET",
                        "HEAD",
                        "POST"
                    ],
                    "cacheKey": [
                        "host",
                        "requestURI",
                        "scheme",
                        "cookieJSessionID",
                        "cookieUser"
                    ],
                    "maxCacheSize": "1G",
                    "cacheValidTime": "10m",
                    "minUseOfProxyToCache": 1,
                    "reValidate": true,
                    "backgroundUpdate": true,
                    "stale": {
                        "backendErrors": [
                            "error",
                            "timeout",
                            "invalid_header",
                            "updating"
                        ],
                        "backendErrorCodes": [
                            403,
                            404,
                            429,
                            500,
                            502,
                            503,
                            504
                        ]
                    },
                    "cacheLock": {
                        "enabled": true,
                        "age": "5s",
                        "timeout": "5s"
                    }
                }
            }
        ]
    }
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To apply the Proxy Cache policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Services**.
3. Select a workspace in the list that contains the API Proxy you want to update.
4. On the workspace overview page, on the **API Proxies** tab, locate the API Proxy you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit Proxy**.
5. On the left menu, select **API Proxy > Advanced > Policies**.
6. On the *Advanced > Policies* page, on the **API Proxy** tab, locate **Proxy Cache**. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Add Policy**.
7. Modify the configuration as needed.
8. Select **Add** to apply the policy to the API Proxy.
9. Select **Save and Publish** to deploy the configuration to the API Proxy.

{{%/tab%}}

{{</tabs>}}

---
