+++
authors = []
categories = ["access log"]
date = "2021-04-14T13:32:41+00:00"
description = "Learn about NGINX App Protect DoS Directives and Policy."
doctypes = ["task"]
draft = false
journeys = ["researching", "getting started", "using", "self service"]
personas = ["devops", "netops", "secops", "support"]
roles = ["admin", "user"]
title = "NGINX App Protect DoS Directives and Policy"
toc = true
versions = ["4.1"]
weight = 120
docs= "DOCS-667"

[menu]
  [menu.docs]
    parent = "directives-and-policy"
    weight = 45

+++

## Introduction

NGINX directives are written in the `nginx.conf` file and are used to configure specific modules of NGINX.<br>
NGINX App Protect DoS has its own directives (which follows the same rules of all other directives) and are used to enable and configure it.<br>

The table below summarizes all the NGINX App Protect DoS directives.<br>

Although only the first directive is mandatory (used for enabling NGINX App Protect DoS), it is advised to use as many directives as possible in order to make use of the product's monitoring and application health detection capabilities.<br>
When reloading NGINX after inserting the directives, pay attention to any errors or warnings that might be written to the NGINX error log.<br>

## Directives table
This is a summary of all NGINX App Protect DoS directives. You can find the description of each below.
 
 {{% table %}}
| Directive syntax | Options  | Context  |  Description |  Mandatory |  Default |
|------------------|----------|----------|--------------|------------|----------|
| [app_protect_dos_enable](#enable-directive-app_protect_dos_enable)  | [on\|off]  | http, <br> server, <br> location  |  Enable/Disable DoS protection | Yes  |  off |
| [app_protect_dos_policy_file](#policy-directive-app_protect_dos_policy_file)  | [FILE-PATH]  | http, <br> server, <br> location | Load DoS configuration from a policy file  | No  | `/etc/app_protect_dos/BADOSDefaultPolicy.json` |
| [app_protect_dos_name](#service-name-directive-app_protect_dos_name)  | [SERVICE-NAME]  | http, <br> server, <br> location  | Name of protected object  | No | **line_num-server_name**:*seq*-location_name <br> <br> (i.e. `30-backend:1-/abc`) |
| [app_protect_dos_monitor](#monitor-directive-app_protect_dos_monitor)  | [uri=X]  [protocol=Y]  [timeout=Z] [proxy_protocol \| proxy_protocol=on\|off] | http, <br> server, <br> location  | URI to monitor server's stress. Protocol and timeout are optional  |  Yes, unless its regular http1 traffic | uri - None <br> protocol - http1 <br> timeout - 10 seconds for http1/websocket ; 5 seconds for http2/grpc <br> proxy_protocol - off |
| [app_protect_dos_security_log_enable](#security-log-enable-directive-app_protect_dos_security_log_enable) | [on\|off] | http, <br> server, <br> location | Enable/Disable security logger | No | off |
| [app_protect_dos_security_log](#security-log-directive-app_protect_dos_security_log)  | [LOG-CONFIG-FILE] [DESTINATION] | http, <br> server, <br> location  | Security logger configuration. Second argument: <br>"syslog:server={ip}:{port}"  or <br>"stderr" or  <br>  "{absolute_file_path}" | No | `/etc/app_protect_dos/log-default.json stderr` |
| [app_protect_dos_liveness](#liveness-probe-directive-app_protect_dos_liveness)  | [on\|off] [uri:URI] [port:PORT]  |  http | Liveness prob. Second and third arguments are optional |  No | `off uri:/app_protect_dos_liveness port:8090`  |
| [app_protect_dos_readiness](#readiness-probe-directive-app_protect_dos_readiness)  | 	[on\|off] [uri:URI] [port:PORT]  | http  | Readiness prob. Second and third arguments are optional  | No | `off  uri:/app_protect_dos_readiness port:8090`  |
| [app_protect_dos_arb_fqdn](#arbitrator-fqdn-directive-app_protect_dos_arb_fqdn)  | [FQDN\|IP address]  | http | Arbitrator FQDN/IP address  | No | `svc-appprotect-dos-arb` | 
| [app_protect_dos_api](#api-directive-app_protect_dos_api)  | No arguments  | location | Monitoring via Rest API (also includes the dashboard)  | No | off | 
| [app_protect_dos_accelerated_mitigation](#api-directive-app_protect_dos_api) | [on\|off] [syn_drop=on\|off]| http | Enable/Disable L4 accelerated mitigation. Second argument is optional | No | off syn_drop=off |
{{% /table %}}


## Directives Info

### Enable directive (`app_protect_dos_enable`)

Enables/disables App Protect DoS module in the relevant block/s. <br>
It can be written in the following contexts: `location/server/http`.

The derived blocks/contexts also inherit the directive.
**For example:** A directive written in `http` context will be considered as if written also in all of the http's server blocks and their location blocks.

In case of multiple directives in different contexts, the derived overwrites the base's directive.

 {{% table %}}
 | Config | Expected |
 |------- | -------- |
 | Http block: directive is **on** <br> Server block: none is written <br> Location-1 block: none is written <br> Location-2 block: none is written | VS1: the server block <br> VS2: location-1 block <br> VS3: location-2 block |
 | Server block: directive is **on** <br> Location-1 block: directive is **off** <br> Location-2 block: none is written | VS1: the server block <br> VS2: location-2 block |
 | Http block: directive is **on** <br> Server block: directive is **off** <br> Location-1 block: directive is **on** <br> Location-2 block: none is written | VS1: location-1 block |
 {{% /table %}}

 **Example:**

```nginx
app_protect_dos_enable on;
```

### Policy directive (`app_protect_dos_policy_file`)

This is the path to the JSON policy file which includes the product's configuration parameters. It can be written in the following contexts: `location/server/http`.

The directive is optional. If not inserted then default path will be used, which is `/etc/app_protect_dos/BADOSDefaultPolicy.json`.

If the configuration file doesn't exist or its attributes are invalid, default values will be used.

`BADOSDefaultPolicy.json`:

```json
{
    "mitigation_mode": "standard",
    "signatures": "on",
    "bad_actors": "on",
    "automation_tools_detection": "on",
    "tls_fingerprint" : "on"
}
```

{{% table %}}
| Parameter name  | Values  | Default |Description |
|:--------------- |:------- |:--------|:-----------|
| mitigation_mode | standard / conservative / none | standard| **Standard** - module allowed to use global rate mitigation <br> **Conservative** - module is not allowed to use global rate but only Signatures/Bad Actors mitigation <br> **None** - module is not allowed to mitigate. Only to learn and report. |
| signatures  | [on\|off] | on| Enable mitigation by Signatures algorithm |
| bad_actors  | [on\|off]  | on|  Enable mitigation by Bad Actors algorithm |
| automation_tools_detection | [on\|off] | on |Enable the usage of automation tools detection (via cookies and redirect) |
| tls_fingerprint| [on\|off] | on | Enable source identification using TLS fingerprinting|
{{% /table %}}

{{% table %}}
| Scenario  |  Result |
|:--------- |:-------- |
| Directive is not written  | Default path is used: "/etc/app_protect_dos/BADOSDefaultPolicy.json"  |
| Directive is written  | Path from the directive is used  |
| File not found / file syntax is invalid | Default values are used |
{{% /table %}}

**Example:**

```nginx
app_protect_dos_policy_file /etc/app_protect_dos/BADOSPolicy.json;
```

### Service Name directive (`app_protect_dos_name`)

This is the VS (protected object) name, it should be unique and is used to identify the VS in the logs. It can be used in `location/server/http` blocks.

Directive is optional. If not written, then each protected object (VS) will have an auto-generated name according to the following syntax:

`line_number-server_name:seq-location_name`

**For example:**
`30-backend:1-/abc`

- `line number:` the line number of the server block (`server {`) in the `nginx.conf` file (i.e. `30`)<br>
- `server name:` taken from directive `server_name` (i.e. `backend`) <br>
seq: 0 for server block, increments for each location block. i.e. VS created from server block will have 0 and VS's from location blocks will be 1,2,3,... (i.e. `1`)
- `location name:` the name of the location (i.e. `/abc`)

**Example:**

```nginx
app_protect_dos_name po-example;
```

### Monitor directive (`app_protect_dos_monitor`)

**Syntax:** app_protect_dos_monitor uri=path [protocol=http1|http2|grpc|websocket] [timeout=number] [proxy_protocol=on|off];

**Default:** —

**Context:** http, server, location

Monitors the stress level of the Protected Object. Requests for this monitoring are sent from the localhost (127.0.0.1).
This directive is mandatory, except when using the HTTP1 protocol, where it is still strongly recommended for optimal performance.

Monitor directive has four arguments - **uri**, **protocol**, **timeout** and **proxy_protocol**. The first is mandatory and the rest are optional.
- **URI** - destination to the desired protected object in the `nginx.conf`. Format: **scheme://server_name:port/location**.

  {{< note >}}For gRPC, a certain method should be specified in the location. For example, /RouteGuide/GetFeature. {{< /note >}}

- **Protocol** -  determines the protocol type of the service. Options: `http1 / http2 / grpc / websocket`. Default: `http1`.

  {{< note >}}http2 and grpc are supported from NGINX App Protect DoS v2 ; websocket is supported from NGINX App Protect DoS v4. {{< /note >}}

- **Timeout** - determines how long (in seconds) should NGINX App Protect DoS wait for a response. Default: 10 seconds for `http1/http2/websocket` and 5 seconds for `grpc`.

- **Proxy Protocol** - should be used when the listen directive of the correspondent server block contains proxy_protocol parameter.
It adds an HAProxy PROXY protocol header to the monitor request.
Format: **proxy_protocol | proxy_protocol=on**. Default: off.

  {{< note >}}proxy_protocol is supported from NGINX App Protect DoS v3.1. {{< /note >}}


#### For NGINX App Protect DoS v1:

Monitor directive has one argument which is the `uri` to be monitored. Only HTTP1 is supported.

The argument is a destination to the desired protected object in the `nginx.conf`: **scheme://server_name:port/location**.
<br><br>
**Examples:**

1. http1 on port 80:

```nginx
listen 80;
server_name serv;
 
location / {
    # Protected Object is defined here
    app_protect_dos_monitor uri=http://serv:80/;
}
```
{{< note >}}For NGINX App Protect DoS v1, use: app_protect_dos_monitor http://serv:80/; {{< /note >}}

2. http2 over SSL

```nginx
listen 443 http2 reuseport ssl;
server_name serv;
 
location / {
    # Protected Object is defined here
    app_protect_dos_monitor uri=https://serv:443/ protocol=http2 timeout=5;
}
```

3. gRPC service on port 50051

```nginx
listen 50051 http2 reuseport;
server_name my_grpc;
 
location /routeguide. {
    # Protected Object is defined here
    app_protect_dos_monitor uri=http://my_grpc:50051/routeguide.RouteGuide/GetFeature protocol=grpc;
}
```

4. Server with proxy_protocol
```nginx
listen 443 ssl http2 proxy_protocol;
server_name serv;
 
location / {
    # Protected Object is defined here
    app_protect_dos_monitor uri=https://serv:443/ protocol=http2 timeout=5 proxy_protocol=on;
}

location /example2 {
    # Protected Object is defined here
    app_protect_dos_monitor uri=https://serv:443/ protocol=http2 timeout=5 proxy_protocol;
}
```

5. WebSocket service

```nginx
listen 80;
server_name wsapp;

location /wsapp/ {
    # WebSocket configuration, required by NGINX
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host $host;
  
    # Protected Object is defined here
    app_protect_dos_monitor uri=http://wsapp:80/ protocol=websocket;
}
```

### Security log enable directive (`app_protect_dos_security_log_enable`)

Enable/Disable App Protect DoS security logger. It can be used in `location/server/http` blocks.

Directive is optional. If not written, then logger is disabled.

**Example:**<br>

```nginx
app_protect_dos_security_log_enable on;
```

### Security log directive (`app_protect_dos_security_log`)

This directive has two string arguments.

First argument is the configuration file path, i.e. `/etc/app_protect_dos/log-default.json`.

Second argument is the destination (the location which the events will be sent to). The destination can be one of three options:

- `syslog:server={ip}:{port}`, i.e. `syslog:server=1.2.3.4:3000`
- `stderr` (**default**)
- `{absolute_file_path}`, i.e. `/shared/dos_sec_logger.log`

Implemented according to: [NGINX App Protect DoS Security Log]({{< relref "monitoring/security-log.md" >}})

   {{< note >}} 
- When using stderr, make sure that the process `admd` is not redirecting the stderr output to file.
- When using the Docker `entrypoint.sh` startup script from the admin guide, make sure that it doesn’t redirect stderr.
   {{< /note >}} 


**Examples:**

- **Syslog:**

```nginx
app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=1.2.3.4:5000;
```

- **File:**

```nginx
app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" /shared/logger.log;
```

- **Stderr:**

```nginx
app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" stderr;
```

While `/etc/app_protect_dos/log-default.json` is:

```json
{
    "filter": {
        "traffic-mitigation-stats": "all",
        "bad-actors": "top 10",
        "attack-signatures": "top 10"
    }
}
```

### Liveness probe directive (`app_protect_dos_liveness`)

This directive has 3 arguments.

{{% table %}}
| First argument | Second argument | Third argument |
| :-------------- | :--------------- | :-------------- |
| [on\|off] <br> depending if this feature should be enabled or disabled.| URI <br> Syntax is: `uri:___` | Port <br> Syntax is: `port:____`|
{{% /table %}}

   {{< note >}} 
Second and Third arguments are optional; if one or more is not written, the default will take place.
   {{< /note >}} 

If liveness is enabled, a request with URI and PORT that matches the probe configuration (i.e. `/app_protect_dos_liveness:8090`) will be answered with RC 200 "Alive" by our NGINX module, without being counted or pass to other handlers nor the backend server.

Any other response will indicate that our NGINX module (NGINX App Protect DoS) has not received the request (possibly means that NGINX is down).

**Example:**

```nginx
app_protect_dos_liveness on uri:/liveness port:8090;
```

### Readiness probe directive (`app_protect_dos_readiness`)

This directive has 3 arguments.

{{% table %}}
| First argument | Second argument | Third argument |
| :-------------- | :--------------- | :-------------- |
| [on\|off] <br> depending if this feature should be enabled or disabled.| URI <br> Syntax is: `uri:___`| Port <br> Syntax is: `port:____`|
{{% /table %}}

   {{< note >}} 
Second and Third arguments are optional; if one or more is not written, the default will take place.
   {{< /note >}}

If readiness is enabled, a request with URI and PORT that matches the probe configuration (i.e. `/app_protect_dos_readiness:8090`) will be answered with RC 200 "Ready" or RC 503 "Not Ready" by our NGINX module, without being counted or pass to other handlers nor the backend server.

Any other response will indicate that our NGINX module (NGINX App Protect DoS) has not received the request (possibly means that NGINX is down).

RC 200 "Ready" will occur if two conditions are met:

1. NGINX worker successfully connected to the global shared memory block
2. ADMD process is running (and not stuck)

**Example:**

```nginx
app_protect_dos_readiness on uri:/readiness port:8090;
```

### Arbitrator FQDN directive (`app_protect_dos_arb_fqdn`)

Arbitrator FQDN directive has one argument which is the `FQDN/IP`.

The argument is the FQDN to the desired Arbitrator.

**Examples:**

FQDN:
```nginx
app_protect_dos_arb_fqdn svc-appprotect-dos-arb.arb.svc.cluster.local;
```
IP address:
```nginx
app_protect_dos_arb_fqdn 192.168.1.10;
```
### API directive (`app_protect_dos_api`)

This directive is used to enable the App Protect DoS monitoring capability via REST API.<br>
The REST API interface provides extended metrics information of the Protected Objects.
It can be used by sending REST API requests manually or by using the App Protect DoS dashboard page.

For more information refer to [NGINX App Protect DoS Live Activity Monitoring]({{< relref "/monitoring/live-activity-monitoring.md" >}})

**Example:**

  ```nginx
  http {
      # ...
      server {
          listen 192.168.1.23;
          # ...
          location /api {
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

### Accelerated mitigation directive (`app_protect_dos_accelerated_mitigation`)

This directive is used to enable or disable App Protect DoS L4 accelerated mitigation.<br>

syn_drop is an optional parameter; the default value is "off".<br>
syn_drop=on mode is applicable for plane HTTP services or HTTPS when the `tls_fingerprint` feature is disabled. Refer to policy parameter "tls_fingerprint" in [Policy directive](#policy-directive-app_protect_dos_policy_file).
In syn_drop mode, the SYN packet of detected bad actors will be dropped.

syn_drop mode is recommended for the deployments of NGINX App Protect DoS at the perimeter network or behind L3 load balancer.
Using this mode when NGINX App Protect DoS is deployed behind L4/L7 load balancer may result in the load balancer’s starvation during an attack.

{{< note >}}
To use this directive you need to install eBPF package.
{{< /note >}}

**Example:**

```nginx
app_protect_dos_accelerated_mitigation on syn_drop=on;
```
