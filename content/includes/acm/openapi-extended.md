---
docs: DOCS-1340
---

### Uploading an OAS Schema
OAS Schemas can be uploaded to API Connectivity Manager and stored for use as references for *Proxy* deployments.
The routes contained in the OAS Schema will be used to create the routes for your *Proxy*

### Creating a Proxy with an OAS
After you have uploaded your OAS Schema as an *API Doc*, you can then reference that *API Doc* in your *Proxy* deployments using the `specRef` parameter in the JSON payload.
Using the `specRef` will then associate that OAS Schema in API Connectivity Manager and allow API Connectivity Manager to create your routes from the information contained in the OAS Schema.

### Extended support for OAS in API Connectivity Manager
API Connectivity Manager now allows you to set up an API gateway using Open API Specification by supporting the creation of *Backends* (upstream servers) from the supplied OAS using an API Connectivity Manager specific *x-* extension in your OAS document.
API Connectivity Manager now also supports server URL templating in the global URL(s).

<details closed>
<summary>Example JSON</summary>

```json
"servers": [
  {
    "url": "https://{server}.example.com/api/{version}",
    "variables": {
      "version": {
        "default": "v1"
      },
      "server": {
        "default": "staging"
      }
    },
    "x-acm-append-rule": "NONE",
    "x-acm-strip-basepath": false,
    "x-acm-backends": [
      {
        "serviceName": "pets-backend",
        "serviceVersion": "pets-backend-v1",
        "serviceLabel": "default",
        "contextRoot": "/dev",
        "upstreams": [
          {
            "url": "https://gecho1.null.ie",
            "maxFails": 10,
            "maxConnections": 5,
            "failTimeout": "5s",
            "slowStart": "10s"
          },
          {
            "url": "https://gecho2.null.ie",
            "maxFails": 5,
            "maxConnections": 8,
            "failTimeout": "15s",
            "slowStart": "3s"
          },
          {
            "url": "https://gecho3.null.ie",
            "maxFails": 7,
            "maxConnections": 33,
            "failTimeout": "35s",
            "slowStart": "1s"
          }
        ]
      }
    ]
  }
],
```

</details>

&nbsp;


### Server URL Templating

```json
"servers": [
  {
    "url": "https://{server}.example.com/api/{version}",
    "variables": {
      "version": {
        "default": "v1"
      },
      "server": {
        "default": "staging"
      }
    },
```

In the above section, we can see how server URL templating will make substitutions with a matching value from the variables section of the server object in the specification.
Each placeholder in the URL *must* have a matching variable in the variables section or the validation will fail and return an error.

### Creating Backends
This section explains how to create a backend target for our API Gateway configuration, a Backend is a collection of upstream servers bundled under one "Service label".
An API Gateway can have multiple *Backends* which can each contain multiple upstream servers.

```json
"x-acm-backends": [
      {
        "serviceName": "pets-backend",
        "serviceVersion": "pets-backend-v1",
        "serviceLabel": "default",
        "contextRoot": "/dev",
        "upstreams": [
          {
            "url": "https://server.example.com",
            "maxFails": 10,
            "maxConnections": 5,
            "failTimeout": "5s",
            "slowStart": "10s"
          },
```

In the above example, we can see how to create a single *Backend* with a single upstream server.

{{<bootstrap-table "table">}}

| Variable       | Purpose                                                                                                                                                                                                                                   | Required | Default | Context  |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|----------|
| serviceName    | provides a human-readable identifier to the Backend                                                                                                                                                                                       | true     | none    | Backend  |
| serviceVersion | provides some version metadata should it be required                                                                                                                                                                                      | false    | none    | Backend  |
| serviceLabel   | provides a means to target this backend from this and other API Gateway deployments                                                                                                                                                       | true     | default | Backend  |
| contextRoot    | sets the service root path for the upstream servers, i.e. /dev would mean that all requests proxied to /api/v1 would be proxied to /dev/api/v1 on the upstream servers.                                                                   | false    | /       | Backend  |
| upstreams      | array of upstream servers, requires at least one server to be provided.                                                                                                                                                                   | true     | none    | Backend  |
| url            | the URL of the upstream server, a port should be provided if using non-standard scheme -> port mappings, i.e. http:80, https:443                                                                                                          | true     | none    | Upstream |
| maxFails       | sets the number of unsuccessful attempts to communicate with the server that should happen in the duration set by the `fail_timeout` parameter to consider the server unavailable for a duration also set by the `fail_timeout` parameter | false    | 0       | Upstream |
| maxConnections | limits the maximum `_number_` of simultaneous active connections to the proxied server                                                                                                                                                    | false    | 0       | Upstream |
| failTimeout    | sets the time during which the specified number of unsuccessful attempts to communicate with the server should happen to consider the server unavailable and the period of time the server will be considered unavailable.                | false    | 10s     | Upstream |
| slowStart      | sets the `_time during which the server will recover its weight from zero to a nominal value, when an unhealthy server becomes healthy, or when the server becomes available after being unavailable.           | false    | none    | Upstream |

{{</bootstrap-table>}}

All values supplied in the OAS Specification are only modifiable through the OAS Specification and not through the API or UI, this means that the OAS Specification is the source of truth for all values supplied within it.
If values are omitted from the OAS Schema then they may be added or modified via the API or UI.

### Proxy Basepath
It is possible to modify the basepath provided using two additional extensions:
`x-acm-append-rule` and `x-acm-strip-basepath`.

`x-acm-append-rule` is a legacy configuration option that was used to either prepend or append the version field from the `info` section to your API basepath, going forward the basepath should be added explicitly to the global server URL section in exactly the manner in which it is to be used, for example: <https://myserver.host.com/api/v1>

`x-acm-append-rule` defaults to `NONE` and the version field in the `info` section is only used as the document version metadata in favor of explicitly adding the version to the server URL. `x-acm-append-rule` should ONLY be used for legacy deployments that used a value other than `NONE`

`x-acm-strip-basepath` is a boolean value that denotes whether to strip the basepath from the request URI before proxying the request to the backend servers.

{{<bootstrap-table "table">}}

| Incoming URI          | basePath | stripBasepath | Context Root | Proxied URI            |
|-----------------------|----------|---------------|--------------|------------------------|
| /api/v1/customers     | /api/v1  | false         | /            | /api/v1/customers      |
| /api/v1/customers     | /api/v1  | true          | /            | /customers             |
| /api/v1/customers/123 | /api/v1  | true          | /            | /customers/123         |
| /api/v1/customers     | /api/v1  | false         | /prod        | /prod/api/v1/customers |
| /api/v1/customers     | /api/v1  | true          | /prod        | /prod/customers        |

{{</bootstrap-table>}}
