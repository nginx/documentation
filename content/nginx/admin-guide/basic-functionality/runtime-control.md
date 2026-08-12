---
description: Understand the NGINX processes that handle traffic, and how to control
  them at runtime.
f5-docs: DOCS-379
title: Control NGINX Processes at Runtime
toc: true
weight: 200
f5-content-type: how-to
f5-product: NGINX Plus
---

This section describes the processes that NGINX starts at run time and how to control them.

## Master and worker processes {#processes}

NGINX has one master process and one or more worker processes. If [caching]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}}) is enabled, the cache loader and cache manager processes also run at startup.

The main purpose of the master process is to read and evaluate configuration files, as well as maintain the worker processes.

The worker processes do the actual processing of requests. NGINX relies on <span style="white-space: nowrap;">OS-dependent</span> mechanisms to efficiently distribute requests among worker processes. The number of worker processes is defined by the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) directive in the **nginx.conf** configuration file and can either be set to a fixed number or configured to adjust automatically to the number of available CPU cores.

## Control NGINX with signals {#signals}

To reload your configuration, you can stop or restart NGINX, or send signals to the master process. A signal can be sent by running the `nginx` command (invoking the NGINX executable) with the `-s` argument.

```none
nginx -s <SIGNAL>
```

where `<SIGNAL>` can be one of the following:

- `quit` – Shut down gracefully (the `SIGQUIT` signal)
- `reload` – Reload the configuration file (the `SIGHUP` signal)
- `reopen` – Reopen log files (the `SIGUSR1` signal)
- `stop` – Shut down immediately (or fast shutdown, the `SIGTERM` signal)

The `kill` utility can also be used to send a signal directly to the master process. The process ID of the master process is written, by default, to the **nginx.pid** file, which is located in the **/usr/local/nginx/logs** or **/var/run** directory.

For more information about advanced signals (for performing live binary upgrades, for example), see [Control nginx](https://nginx.org/en/docs/control.html) at **nginx.org**.


## Control NGINX with Control API {#control-api}

In addition to [signal-based controls](#signals), NGINX Plus can be controlled with the Control REST API, available since [NGINX Plus PLS R37.0.0 LTS]({{< ref "nginx/releases.md#r37.0" >}}).

The Control API is implemented in the [NGINX master process](#processes) and provides a REST interface for runtime control and inspection. It allows you to:

- view worker process information (process name, PID, and exit state);
- get a memory dump of loaded NGINX configuration files;
- trigger a configuration reload similar to `nginx -s reload` and review reload logs.

The Control API provides the following endpoints:

- `/1/control/processes` — return worker process information;
- `/1/control/config` — return the in-memory NGINX configuration and trigger reloads with `PATCH`;
- `/1/nginx` — return NGINX version and build information.

See [NGINX Control REST API reference]({{< ref "nginx/admin-guide/basic-functionality/control-api-reference.md" >}}) for details.

### Enable NGINX Control API

By default, the Control API is disabled. To enable it, start NGINX Plus with the [`-l` argument](https://nginx.org/en/docs/switches.html#l), specifying a UNIX-domain socket or TCP port:

```shell
sudo nginx -l unix:/tmp/nginx.sock
```

### Security implications

- Never expose the Control API to the public Internet. Restrict access to the Control API listener with firewalls or ACLs, where possible, place it on a dedicated interface or VLAN.
- Configure the Control API to listen on a UNIX-domain socket. This is currently the most effective way to control access, because authorization can be managed through file permissions, and the created socket file is accessible only to the user running NGINX.
- Keep NGINX Plus and the operating system up to date.

### Control API reference documentation

See [NGINX Control REST API reference]({{< ref "nginx/admin-guide/basic-functionality/control-api-reference.md" >}}) for details on available endpoints, request parameters, and response schemas.

[{{<icon "download">}}Download Control API OpenAPI YAML specification](/nginx/admin-guide/yaml/nginx-control-api/1/nginx_control_api.yaml) or copy this link to explore the API using standard OpenAPI-compatible tools such as Redoc or Swagger UI.






