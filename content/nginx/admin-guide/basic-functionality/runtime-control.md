---
description: Understand the NGINX processes that handle traffic, and how to control
  them at runtime.
docs: DOCS-379
title: Control NGINX Processes at Runtime
toc: true
weight: 100
type:
- how-to
---

This section describes the processes that NGINX starts at run time and how to control them.

## Master and Worker Processes

NGINX has one master process and one or more worker processes. If [caching]({{< ref "nginx/admin-guide/content-cache/content-caching.md" >}}) is enabled, the cache loader and cache manager processes also run at startup.

The main purpose of the master process is to read and evaluate configuration files, as well as maintain the worker processes.

The worker processes do the actual processing of requests. NGINX relies on <span style="white-space: nowrap;">OS-dependent</span> mechanisms to efficiently distribute requests among worker processes. The number of worker processes is defined by the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) directive in the **nginx.conf** configuration file and can either be set to a fixed number or configured to adjust automatically to the number of available CPU cores.

## Control NGINX

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
