+++
authors = []
categories = ["live activity monitoring"]
date = "2021-04-14T13:32:41+00:00"
description = "Learn about the NGINX App Protect DoS Live Activity Monitoring."
doctypes = ["task"]
draft = false
journeys = ["researching", "getting started", "using", "self service"]
personas = ["devops", "netops", "secops", "support"]
roles = ["admin", "user"]
title = "NGINX App Protect DoS Live Activity Monitoring"
toc = true
versions = ["4.1"]
weight = 140
docs= "DOCS-670"

[menu]
  [menu.docs]
    parent = "monitoring"
    weight = 45

+++

{{< img src="/dashboard/dos-tab.png" alt="NGINX App Protect DoS Dashboard" >}}

## Overview

NGINX App Protect DoS provides various monitoring tools for your application:<br>
- The interactive App Protect DoS Dashboard page - a real-time live activity monitoring interface that shows the status and information of the Protected Objects.<br>
- NGINX App Protect DoS REST API - an interface that provides extended metrics information of the Protected Objects.

## Prerequisites

- NGINX Plus R26 and later for NGINX App Protect DoS REST API and the DoS Dashboard

## Configuring the API

To enable the API:
- In the `http` context, specify a `server` block that will be responsible for the API:
  ```nginx
  http {
      server {
          # your api configuration will be here
      }
  }
  ```

- Create a `location` for API requests and specify the `app_protect_dos_api` directive in this location:
  ```nginx
  http {
      # ...
      server {
          listen 192.168.1.23;
          # ...
          location /api {
              app_protect_dos_api;
              # ...
          }
      }
  }
  ```

- It is recommended restricting access to the API location, for example, allow access only from local networks with allow and deny directives:
  ```nginx
  http {
      # ...
      server {
          listen 192.168.1.23;
          # ...
          location /api {
              app_protect_dos_api;
              allow 192.168.1.0/24;
              deny all;
          }
      }
  }
  ```

- It is also recommended restricting access to PATCH, POST, and DELETE methods to particular users. This can be done by implementing HTTP basic authentication:
  ```nginx
  http {
      # ...
      server {
          listen 192.168.1.23;
          # ...
          location /api {
              limit_except GET {
                  auth_basic "NGINX Plus API";
                  auth_basic_user_file /path/to/passwd/file;
              }
              app_protect_dos_api;
              allow 192.168.1.0/24;
              deny  all;
          }
      }
  }
  ```

- Enable the DoS Dashboard by specifying the /dashboard-dos.html location. By default the DoS Dashboard is located in the root directory (for example, /usr/share/nginx/html) specified by the root directive:
  ```nginx
  http {
      # ...
      server {
          listen 192.168.1.23;
          # ...
          location /api {
              limit_except GET {
                  auth_basic "NGINX Plus API";
                  auth_basic_user_file /path/to/passwd/file;
              }
              app_protect_dos_api;
              allow 192.168.1.0/24;
              deny  all;
          }
          location = /dashboard-dos.html {
              root   /usr/share/nginx/html;
          }
      }
  }
  ```

## Using the Dashboard
### Accessing the Dashboard
In the address bar of your browser, type in the address that corresponds to your Dashboard page (in our example `http://192.168.1.23/dashboard-dos.html`). This will display the Dashboard page located at `/usr/share/nginx/html` as specified in the root directive.

### DoS Tab Overview
The **DoS** tab provides live statistics, configuration, and traffic graph per Protected Object.<br>
In case of deployment with arbitrator and multiple NGINX App Protect DoS instances, the statistics will be aggregated.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}
| Metric name  | Values  | Description |
|:--------------- |:------- |:-----------|
| Name  | - | The name of the Protected Object, as defined by the `app_protect_dos_name` directive (or auto-generated if not present)  |
| Health  | [good\|bad] | The health of the backend server, as defined by the `uri` argument of the `app_protect_dos_monitor` directive  |
| Under Attack  | [yes\|no] | Whether the Protected Object is under attack or not  |
| Req/s  | - | Number of incoming requests per second  |
| Mitigations/s  | - | Number of mitigated requests per second  |
| Requests  | - | Total number of incoming requests  |
| Mitigations  | - | Total number of mitigated requests  |
| Learning  | [ready\|ba only\|not ready] | Whether NGINX App Protect DoS collected enough data to protect the Protected Object  |
| Protocol  | [http1\|http2\|grpc] | As defined by the `protocol` argument of the `app_protect_dos_monitor` directive  |
| Mitigation Mode  | [standard\|conservative\|none]  | As defined by the `mitigation_mode` object in the JSON policy file from the `app_protect_dos_policy_file` directive  |
| Signatures  | [on\|off] | As defined by the `signatures` object in the JSON policy file from the `app_protect_dos_policy_file` directive. Values - on/off  |
| Bad Actors  | [on\|off]  | As defined by the `bad_actors` object in the JSON policy file from the `app_protect_dos_policy_file` directive  |
| Automation Tools Detection | [on\|off] | As defined by the `automation_tools_detection` object in the JSON policy file from the `app_protect_dos_policy_file` directive |
| TLS Fingerprint| [on\|off] | As defined by the `tls_fingerprint` object in the JSON policy file from the `app_protect_dos_policy_file` directive |
{{</bootstrap-table>}}
<br>

The graph is a stacked graph which consists of two metrics - `Passthrough Requests` and `Mitigations`, both are per second.
- `Passthrough Requests` shows the number of requests that passed to the backend server.
- `Mitigations` shows the number of mitigated requests.
<br>
The combination of the two metrics, at any second, is the total number of incoming requests.<br>

### Configuring Dashboard Options
You can configure the dashboard by clicking the Gear button in the Tabs menu.<br>
**Update every N sec** - updates the Dashboard data after the specified number of seconds, default is 1 second.<br>

## Using the REST API
Statistics of your server infrastructure can be managed with the REST API interface. The API is based on standard HTTP requests: statistics can be obtained with `GET` requests.

The requests are sent in the JSON format that allows you to connect the stats to monitoring tools or dashboards that support JSON.

The status information of any element can be accessed with a slash-separated URL. The URL may look as follows:
`http://192.168.1.23/api/dos/1/protected_objects`

where:
- `/api` is the location you have configured in the NGINX configuration file for the API
- `/dos` is a prefix which differentiates NGINX App Protect DoS API from Nginx Plus API
- `/1` is the API version, the current API version is 1
- `/protected_objects` is the path to the resource

The requested information is returned in the JSON data format.

To get the list of all available rootpoints, send the GET request with the ‘curl’ command in terminal (in the example, JSON pretty print extension “json_pp” is used):

```shell
curl -s 'http://192.168.1.23/api/dos/1/' | json_pp
```

The JSON data returned:
```json
[
   "protected_objects"
] 
```

To get the statistics for a particular endpoint, send the following GET request:
```shell
curl -s 'http://192.168.1.23/api/dos/1/protected_objects' | json_pp
```

### APIs overview

#### Endpoints
{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}
| Path  | Description |
|:------ |:-----------|
| /  | Return list of root endpoints  |
| /protected_objects/  | Return statistics of all Protected Objects  |
| /protected_objects/{protectedObjectName}  | Return statistics of a Protected Object  |
{{</bootstrap-table>}}

Example response for `/protected_objects` endpoint:
```json
{
    "po_1": {
        "attack": false,
        "health": 0.50,
        "rps": 12,
        "mps": 0,
        "requests": 500123,
        "passthrough": 260023,
        "mitigations": 240100,
        "learning": "ready",
        "protocol": "http1",
        "mode": "standard",
        "sig": true,
        "ba": true,
        "auto_tools": true,
        "tls_fp": true
    },
    "po_http2": {
        "attack": false,
        "health": 0.50,
        "rps": 20,
        "mps": 0,
        "requests": 500123,
        "passthrough": 260023,
        "mitigations": 240100,
        "learning": "not_ready",
        "protocol": "http2",
        "mode": "conservative",
        "sig": true,
        "ba": true,
        "auto_tools": true,
        "tls_fp": true
    },
    "po_grpc": {
        "attack": false,
        "health": 0.50,
        "rps": 25,
        "mps": 0,
        "requests": 6000123,
        "passthrough": 2599123,
        "mitigations": 3401000,
        "learning": "ready",
        "protocol": "grpc",
        "mode": "standard",
        "sig": true,
        "ba": true,
        "auto_tools": true,
        "tls_fp": true
    }
}
```
