---
description: Learn about the F5 F5 DoS for NGINX Security Log.
nd-docs: DOCS-670
title: F5 DoS for NGINX Security Log
toc: true
weight: 140
type:
- how-to
---

## Overview

Security logs contain information about the status of the protected objects. It gives a general picture about each protected object in terms of traffic intensity, health of the backend server, learning and mitigations.

There are several types of logs, each contains different information and published either periodically or upon an important event.

### Dictionary

The following table lists all the possible fields in the logs and their meaning.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Field  |  Type  | Meaning                                                                                                                                                                                                                                                                                                                                                                                                        |
|----------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `date_time`  |  string  | the date and time of the event                                                                                                                                                                                                                                                                                                                                                                                 |
| `product`   |  string  | always set to `app-protect-dos`                                                                                                                                                                                                                                                                                                                                                                                |
| `product_version` | string  | F5 F5 DoS for NGINX version                                                                                                                                                                                                                                                                                                                                                                                  |
| `unit_hostname` |  string  | host name of the app-protect-dos instance                                                                                                                                                                                                                                                                                                                                                                      |
| `instance_id` |  string  | instance ID: container id from `/proc/self/cgroup`or hostname if container is is not available                                                                                                                                                                                                                                                                                                                 |
| `vs_name` | string  | A unique identifier (representing the protected object's name) of the location in the `nginx.conf` file that this request is associated with. It contains the line number of the containing server block in `nginx.conf`, the server name, a numeric discriminator that distinguishes between multiple entries within the same server, and the location name. <br>For example: `34-mydomain.com:0-~/.*php(2)`. |
|  `dos_attack_id`| integer  | unique attack IP per unit_hostname                                                                                                                                                                                                                                                                                                                                                                             |
|  `attack_event` |  string  | Event name as it appears in remote logger.                                                                                                                                                                                                                                                                                                                                                                     |
|  `stress_level`  |  float  | a number from 0 to ... that reflects stress level.                                                                                                                                                                                                                                                                                                                                                             |
|  `learning_confidence` | string  | the possible values are  **not ready/bad actors only/ready**                                                                                                                                                                                                                                                                                                                                                   |
|  `baseline_dps` |  integer  | learned datagrams per second (DPS)                                                                                                                                                                                                                                                                                                                                                                             |
|  `incoming_dps` |  integer  | current datagrams per second (DPS)                                                                                                                                                                                                                                                                                                                                                                             |
|  `incoming_rps` |  integer  | current RPS (requests per second)                                                                                                                                                                                                                                                                                                                                                                              |
|  `successful_tps` |  integer  | successful TPS (successful requests per second - Any RC but 5xx)                                                                                                                                                                                                                                                                                                                                               |
|  `allowlist_rps` |  integer  | allowlist requests per second                                                                                                                                                                                                                                                                                                                                                                                  |
|  `unsuccessful_rps`  | integer  | unsuccessful requests per second (passed to server and not responded: `reset / timeout / 5xx`                                                                                                                                                                                                                                                                                                                  |
|  `incoming_datagrams` | integer  | incremental number of incoming datagrams                                                                                                                                                                                                                                                                                                                                                                       |
|  `incoming_requests` | integer  | incremental number of incoming requests                                                                                                                                                                                                                                                                                                                                                                        |
|  `allowlist_requests` | integer  | incremental number of allowlist requests                                                                                                                                                                                                                                                                                                                                                                       |
|  `successful_responses` |  integer  | incremental number of successful responses                                                                                                                                                                                                                                                                                                                                                                     |
|  `unsuccessful_requests`  |  integer  | incremental number of unsuccessful requests (passed to server and not responded: `reset / timeout / 5xx`                                                                                                                                                                                                                                                                                                       |
|  `active_connections`|  integer  | current number of active server connections                                                                                                                                                                                                                                                                                                                                                                    |
|  `threshold_dps`  | float  | global rate DPS threshold                                                                                                                                                                                                                                                                                                                                                                                      |
|  `threshold_conns` |  float  | active connections threshold                                                                                                                                                                                                                                                                                                                                                                                   |
|  `mitigated_bad_actors` <br> `redirect_bad_actor` <br> `challenge_bad_actor` <br> `block_bad_actor` |  integer  | incremental number of mitigated bad actors. Increments upon any type of bad actors mitigations. <br> incremental number of http redirections sent  to detected bad actors<br> incremental number of JS challenges sent  to detected bad actors <br> incremental number of blocked bad actors                                                                                                                   |
|  `mitigated_by_signatures` <br> `redirect_signature` <br> `challenge_signature` <br> `block_signature`  |  integer  | incremental number of requests mitigated by signatures. Increments upon any type of signatures mitigations. <br>  incremental number of http redirections sent to clients when requests match a signature. <br> incremental number of JS challenges sent  to clients when requests match a signature. <br>incremental number of blocked requests when requests match a signature.                              |
| `mitigated_by_global_rate`  <br> `redirect_global`  <br> `challenge_global` <br> `block_global` |  integer  | incremental number of requests mitigated by global_rate. Increments upon any type of global rate mitigations. <br> incremental number of http redirections sent to clients upon global rate mitigation. <br>  incremental number of JS challenges sent to clients upon global rate mitigation. <br>  incremental number of blocked requests upon global rate mitigation.                                       |
| `mitigated_slow` <br> `redirect_slow`  <br>  `challenge_slow` <br>  `block_slow`|   integer  | incremental number of mitigated slow requests. Increments upon any type of slow requests mitigations.<br>incremental number of http redirections sent to clients upon slow request mitigation. <br>incremental number of JS challenges sent to clients upon slow request mitigation. <br>incremental number of blocked slow requests.                                                                          |
| `mitigated_connections`   |  integer  | incremental number of mitigated by connections mitigation                                                                                                                                                                                                                                                                                                                                                      |
| `mitigated_bad_actors_l4` |  integer  | incremental number of mitigated by L4 accelerated mitigation                                                                                                                                                                                                                                                                                                                                                   |
| `mitigated_bad_actors_rps` <br> `redirect_bad_actor_rps` <br> `challenge_bad_actor_rps` <br> `block_bad_actor_rps`  |   integer  | mitigated_bad_actors rps. Includes any type of bad actors mitigations.<br>http redirections per second sent  to detected bad actors. <br> JS challenges per second sent to detected bad actors.<br> blocked bad actors per second.                                                                                                                                                                             |
|  `mitigated_by_signatures_rps` <br> `redirect_signature_rps` <br> `challenge_signature_rps`  <br> `block_signature_rps` | integer  | mitigated_signatures rps. Includes any type of signatures mitigations.<br>http redirections sent per second to clients when requests match a signature.<br>JS challenges per second sent  to clients when requests match a signature.<br> blocked requests per second when requests match a signature.                                                                                                         |
|  `mitigated_slow_rps` <br> `redirect_slow_rps` <br> `challenge_slow_rps` <br> `block_slow_rps` | integer  | mitigated slow requests per second. Includes any type of slow requests mitigations. <br>http redirections per second sent to clients upon slow request mitigation. <br> JS challenges per second sent to clients upon slow request mitigation. <br> blocked slow requests per second.                                                                                                                          |
| `mitigated_by_global_rate_rps` <br> `redirect_global_rps` <br> `challenge_global_rps` <br> `block_global_rps`  |  integer  | mitigated_global_rate rps. Includes any type of global rate mitigations. <br>http redirections per second sent to clients upon global rate mitigation. <br>JS challenges per second sent to clients upon global rate mitigation. <br>blocked requests  per second upon global rate mitigation.                                                                                                                 |
| `mitigated_bad_actors_l4_rps` |  integer  | blocked requests per second when mitigated by L4 accelerated mitigation                                                                                                                                                                                                                                                                                                                                        |
| `mitigated_connections_rps`  | integer  | mitigated_connections rps                                                                                                                                                                                                                                                                                                                                                                                      |
| `source_ip` <br> `tls_fp` <br> `impact_rps`   | string <br> string <br> integer  | ip address of the detected bad actor `1.1.1.1` <br> TLS Fingerprint of the bad actor <br> RPS created by bad actor in the time of the detection **(to be calculated as a max hitcount in AMT / 10)**                                                                                                                                                                                                           |
|  `new_bad_actors_detected` <br> `bad_actors` |  integer  | the number of newly detected bad actors <br> the number of bad actors                                                                                                                                                                                                                                                                                                                                          |
|  `signature` <br> `signature_id` <br>`signature_efficiency` <br> `signature_accuracy`| string <br> integer <br> float <br> float  | signature string `http.request.method eq GET and http.uri_parameters eq 6` <br> unique signature ID per unit_host <br> estimated efficiency upon signature detection: percentage of bad traffic covered by the signature <br> estimated accuracy upon signature detection: percentage of learned good traffic NOT covered by the signature                                                                     |

{{</bootstrap-table>}}

## Events

### 1a. Attack notification

Reports about the start and end of an attack, as well as major parameters of ongoing attacks.

a. Example: **Attack Started**

```shell
date_time="Oct 05 2021 08:01:00",
product="app-protect-dos",
product_version="25+1.78.0-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="129c76",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Attack started",
stress_level="1.00",
learning_confidence="Ready",
baseline_dps="17",
incoming_dps="181",
incoming_rps="181",
successful_tps="0",
allowlist_rps="0",
unsuccessful_rps="0",
incoming_datagrams="8576",
incoming_requests="8576",
allowlist_requests="162",
successful_responses="5265",
unsuccessful_requests="0",
active_connections="58",
threshold_dps="41.60",
threshold_conns="41.60",
mitigated_bad_actors="0",
mitigated_by_signatures="0",
mitigated_by_global_rate="0",
mitigated_bad_actors_l4="0",
mitigated_slow="0",
redirect_global="0",
redirect_bad_actor="0",
redirect_signature="0",
redirect_slow="0",
challenge_global="0",
challenge_bad_actor="0",
challenge_signature="0",
challenge_slow="0",
block_global="0",
block_bad_actor="0",
block_signature="0",
block_slow="0",
mitigated_connections="0",
mitigated_bad_actors_rps="0",
mitigated_by_signatures_rps="0",
mitigated_by_global_rate_rps="0",
mitigated_bad_actors_l4_rps="0",
mitigated_slow_rps="0",
redirect_global_rps="0",
redirect_bad_actor_rps="0",
redirect_signature_rps="0",
redirect_slow_rps="0",
challenge_global_rps="0",
challenge_bad_actor_rps="0",
challenge_signature_rps="0",
challenge_slow_rps="0",
block_global_rps="0",
block_bad_actor_rps="0",
block_signature_rps="0",
block_slow_rps="0",
mitigated_connections_rps="0",
```

b. Example: **Attack Ended**

```shell
date_time="Oct 05 2021 08:06:21",
product="app-protect-dos",
product_version="25+1.78.0-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="129c76",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Attack ended",
stress_level="0.50",
learning_confidence="Ready",
baseline_dps="12",
incoming_dps="0",
incoming_rps="0",
successful_tps="0",
allowlist_rps="0",
unsuccessful_rps="0",
incoming_datagrams="226566",
incoming_requests="226566",
allowlist_requests="1632",
successful_responses="7760",
unsuccessful_requests="0",
active_connections="0",
threshold_dps="2121.60",
threshold_conns="2121.60",
mitigated_bad_actors="94488",
mitigated_by_signatures="117361",
mitigated_by_global_rate="2861",
mitigated_bad_actors_l4="62788",
mitigated_slow="0",
redirect_global="2861",
redirect_bad_actor="94488",
redirect_signature="117361",
redirect_slow="0",
challenge_global="0",
challenge_bad_actor="0",
challenge_signature="0",
challenge_slow="0",
block_global="0",
block_bad_actor="0",
block_signature="0",
block_slow="0",
mitigated_connections="0",
mitigated_bad_actors_rps="0",
mitigated_by_signatures_rps="0",
mitigated_by_global_rate_rps="0",
mitigated_bad_actors_l4_rps="0",
mitigated_slow_rps="0",
redirect_global_rps="0",
redirect_bad_actor_rps="0",
redirect_signature_rps="0",
redirect_slow_rps="0",
challenge_global_rps="0",
challenge_bad_actor_rps="0",
challenge_signature_rps="0",
challenge_slow_rps="0",
block_global_rps="0",
block_bad_actor_rps="0",
block_signature_rps="0",
block_slow_rps="0",
mitigated_connections_rps="0",
```

### 1b. Traffic/Mitigation summary stats

Reported periodically, providing aggregated statistics per protected object.<br>
This corresponds to the metrics reported on the main Grafana screen.

a. Example: **No Attack**

```shell
date_time="Oct 05 2021 07:54:29",
product="app-protect-dos",
product_version="25+1.78.0-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="129c76",
vs_name="example.com/",
dos_attack_id="0",
attack_event="No Attack",
stress_level="0.50",
learning_confidence="Not ready",
baseline_dps="19",
incoming_dps="9",
incoming_rps="9",
successful_tps="10",
allowlist_rps="1",
unsuccessful_rps="0",
incoming_datagrams="678",
incoming_requests="678",
allowlist_requests="52",
successful_responses="678",
unsuccessful_requests="0",
active_connections="0",
threshold_dps="2121.60",
threshold_conns="2121.60",
mitigated_bad_actors="0",
mitigated_by_signatures="0",
mitigated_by_global_rate="0",
mitigated_bad_actors_l4="0",
mitigated_slow="0",
redirect_global="0",
redirect_bad_actor="0",
redirect_signature="0",
redirect_slow="0",
challenge_global="0",
challenge_bad_actor="0",
challenge_signature="0",
challenge_slow="0",
block_global="0",
block_bad_actor="0",
block_signature="0",
block_slow="0",
mitigated_connections="0",
mitigated_bad_actors_rps="0",
mitigated_by_signatures_rps="0",
mitigated_by_global_rate_rps="0",
mitigated_bad_actors_l4_rps="0",
mitigated_slow_rps="0",
redirect_global_rps="0",
redirect_bad_actor_rps="0",
redirect_signature_rps="0",
redirect_slow_rps="0",
challenge_global_rps="0",
challenge_bad_actor_rps="0",
challenge_signature_rps="0",
challenge_slow_rps="0",
block_global_rps="0",
block_bad_actor_rps="0",
block_signature_rps="0",
block_slow_rps="0",
mitigated_connections_rps="0",
```

b. Example: **Under Attack**

```shell
date_time="Oct 05 2021 08:02:35",
product="app-protect-dos",
product_version="25+1.78.0-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="129c76",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Under Attack",
stress_level="0.50",
learning_confidence="Ready",
baseline_dps="12",
incoming_dps="893",
incoming_rps="893",
successful_tps="12",
allowlist_rps="1",
unsuccessful_rps="0",
incoming_datagrams="87823",
incoming_requests="87823",
allowlist_requests="1523",
successful_responses="5736",
unsuccessful_requests="0",
active_connections="1",
threshold_dps="92.40",
threshold_conns="92.40",
mitigated_bad_actors="0",
mitigated_by_signatures="75137",
mitigated_by_global_rate="2861",
mitigated_bad_actors_l4="62788",
mitigated_slow="0",
redirect_global="2861",
redirect_bad_actor="0",
redirect_signature="75137",
redirect_slow="0",
challenge_global="0",
challenge_bad_actor="0",
challenge_signature="0",
challenge_slow="0",
block_global="0",
block_bad_actor="0",
block_signature="0",
block_slow="0",
mitigated_connections="0",
mitigated_bad_actors_rps="0",
mitigated_by_signatures_rps="879",
mitigated_by_global_rate_rps="0",
mitigated_bad_actors_l4_rps="0",
mitigated_slow_rps="0",
redirect_global_rps="0",
redirect_bad_actor_rps="0",
redirect_signature_rps="879",
redirect_slow_rps="0",
challenge_global_rps="0",
challenge_bad_actor_rps="0",
challenge_signature_rps="0",
challenge_slow_rps="0",
block_global_rps="0",
block_bad_actor_rps="0",
block_signature_rps="0",
block_slow_rps="0",
mitigated_connections_rps="0",
```

### 2. Bad actor detection/expiration
Reports F5 DoS for NGINX decisions regarding bad actors.

a. Example: **Bad Actor Detection**

```shell
date_time="Apr 29 2021 14:03:01",
product="app-protect-dos",
product_version="23+1.54.1-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="d9a6d8",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Bad actor detection",
source_ip="5.5.5.9",
impact_rps="30",
```

b. Example: **Bad Actor Expired**

```shell
date_time="Apr 29 2021 14:05:29",
product="app-protect-dos",
product_version="23+1.54.1-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="d9a6d8",
vs_name="example.com/",
dos_attack_id="0",
attack_event="Bad actor expired",
source_ip="5.5.5.10",
impact_rps="12",
```

### 3. Attack signatures
Reports F5 DoS for NGINX decisions regarding signatures.<br>

Example: **Attack Signature Detected**

```shell
date_time="Apr 29 2021 14:02:56",
product="app-protect-dos",
product_version="23+1.54.1-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="d9a6d8",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Attack signature detected",
signature="(http.user_agent_header_exists eq true) and (http.accept contains other-than(application|audio|message|text|image|multipart)) and (http.unknown_header_exists eq true) and (http.headers_count neq 10) and (http.x_forwarded_for_header_exists eq false) and (http.uri_parameters eq 1) and (http.uri_len between 48-63) and (http.accept_header_exists eq true) and (http.hdrorder not-hashes-to 55) and (http.connection_header_exists eq true) and (http.accept_encoding_header_exists eq true) and (http.request.method eq reserved) and (http.cookie_header_exists eq true) and (http.uri_file hashes-to 7) and (http.host_header_exists eq true)",
signature_id="809655398",
signature_efficiency="72.00",
signature_accuracy="100.00",
```

### 4. Bad actors detection information
Provides detailed information about bad actors.<br>

Example: **Bad Actors Detected**

```shell
date_time="Apr 29 2021 14:02:00",
product="app-protect-dos",
product_version="23+1.54.1-1.el7.ngx",
unit_hostname="localhost.localdomain",
instance_id="d9a6d8",
vs_name="example.com/",
dos_attack_id="1",
attack_event="Bad actors detected",
new_bad_actors_detected="2",
bad_actors="2",
```

## Security Log Configuration File
The file is in JSON format.
<br>
### Filter <br>

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Element  |  Description | Type/Values| Default |
|----------|--------------| ---------- | -----------|
|traffic-mitigation-stats| This filter element refers to [Traffic/Mitigation summary stats](#1b-trafficmitigation-summary-stats).| **Enumerated values:** <br> - **all** <br> - **none**| `all` |
|bad-actors| This filter element refers to [Bad actor detection/expiration](#2-bad-actor-detectionexpiration), every 10 seconds.| **Enumerated values:** <br> - **all** <br> - **none** <br> - **top N**|  `top 10` |
|attack-signatures| This filter element refers to [Attack Signatures](#3-attack-signatures), every 10 seconds.| **Enumerated values:** <br> - **all** <br> - **none** <br> - **top N**|  `top 10` |

{{</bootstrap-table>}}


Example:

```json
{
    "filter": {
        "traffic-mitigation-stats": "all",
        "bad-actors": "top 100",
        "attack-signatures": "top 100"
    }
}
```
