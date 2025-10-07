---
description: Learn about the F5 F5 DoS for NGINX Operation Log.
nd-docs: DOCS-669
title: F5 DoS for NGINX Operation Log
toc: true
weight: 180
type:
- how-to
---

## Overview

The operation logs consists of system operational and health events. The events are sent to the NGINX error log and are distinguished by the `APP_PROTECT_DOS` prefix followed by JSON body. The log level depends on the event: success is usually `notice` while failure is `error`. The timestamp is inherent in the error log.

## Events

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
|Configuration Error |error |There were errors in the [directives]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md" >}}) in the `nginx.conf` file. <br> Configuration error event is produced when one of F5 F5 DoS for NGINX directives is supplied with an incorrect data. An additional information will be added to the message, describing what was incorrect. NGINX will run with default values for this directive. <br> Please note that if the directive supplied with an incorrect number of arguments then NGINX will issue an error and NGINX will not run. It is a generic NGINX behavior.|

{{</bootstrap-table>}}

```json
{
    "event": "configuration_error",
    "error_message": "unknown argument",
    "line_number": 58
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
|Configuration Load Failure |error |There was an error in one of the configuration files: file not found, failed to parse.|

{{</bootstrap-table>}}

```json
{
    "event": "configuration_load_failure",
    "error_message": "Failed to load Policy '/etc/app_protect_dos/BADOSDefaultPolicy.json' : Fail parse JSON Policy: malformed JSON string, neither tag, array, object, number, string or atom, at character offset 0 (before \"xxxx\\nhdjk\\n\\n555\\n\") \n.\n",
    "error_line_number": 58
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
|Configuration Load Success | notice |The `APP_PROTECT_DOS` configuration process ended successfully: all policies, log configuration and global settings were loaded to F5 DoS for NGINX and all traffic will be handled by this configuration. The `error_message` contains warnings. This event is also generated on the initial configuration (when NGINX Plus starts).|

{{</bootstrap-table>}}

```json
{
    "event": "configuration_load_success",
    "software_version": "x.x.x.x.x",
    "error_message": "warning if exists..."
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
|Shared Memory Failure |error |A worker attempted to connect to shared memory but the operation failed. One time error (per worker) - upon switch from `init` or `operational` mode to `failure`. The `mode` should be `failure`.|

{{</bootstrap-table>}}


```json
{
    "event": "shared_memory_failure",
    "worker_pid": 4928,
    "mode": "failure",
    "mode_changed": true
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
|Shared Memory Connected |notice |A worker successfully connected to shared memory. <br>One time message (per worker) - upon switch from init or failure mode to `operational`. <br>The `mode` attribute should be `operational`, unless there is an ongoing problem.|

{{</bootstrap-table>}}

```json
{
    "event": "shared_memory_connected",
    "worker_pid": 4928,
    "mode": "operational",
    "mode_changed": true
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
| eBPF Failure | error | A worker attempted to connect to eBPF maps but the operation failed. One time error (per worker) - upon switch from `init` or `operational` mode to `failure`. The mode should be `failure`.|

{{</bootstrap-table>}}


```json
{
    "event": "ebpf_failure",
    "worker_pid": 4928,
    "mode": "failure",
    "mode_changed": true
}
```

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Event Type|Level|Meaning|
|--------- |-----|------ |
| eBPF Connected | notice | A worker successfully connected to eBPF maps. <br>One time message (per worker) - upon switch from `init` or `failure` mode to `operational`. <br>The `mode` attribute should be `operational`, unless there is an ongoing problem. |

{{</bootstrap-table>}}

```json
{
    "event": "ebpf_connected",
    "worker_pid": 4928,
    "mode": "operational",
    "mode_changed": true
}
```
