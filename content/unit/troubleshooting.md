---
title: Troubleshooting
weight: 1100
toc: true
---

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Logging {#troubleshooting-log}

Unit maintains a single general-purpose log, a system-wide log for runtime messaging,
 usually found at `/var/log/unit.log`, for diagnostics and troubleshooting
(not to be confused with the [access log]({{< relref "/unit/configuration#configuration-access-log" >}})).
To find out its default location in your installation:

```console
$ unitd -h

    unit options:
    ...
    --log FILE           set log filename
                         default: "/path/to/unit.log"
```

The **--log** option overrides the default value; if Unit is already running,
check whether this option is set:

```console
$ ps ax | grep unitd
      ...
      unit: main v1.34.1 [/path/to/unitd ... --log /path/to/unit.log ...]
```

If Unit isn't running, see its system startup scripts or configuration files
to check if **--log** is set, and how.

Available log levels:

- **[alert]**: Non-fatal errors such as app exceptions or misconfigurations.
- **[error]**: Serious errors such as invalid ports or addresses.
- **[warn]**: Recoverable issues such as **umount2(2)** failures.
- **[notice]**: Self-diagnostic and router events.
- **[info]**: General-purpose reporting.
- **[debug]**: Debug events.

{{< note >}}
Mind that our Docker images forward their log output to the
[Docker log collector](https://docs.docker.com/config/containers/logging/)
instead of a file.
{{< /note >}}

### Router events {#troubleshooting-router-log}

The **log_route** option in Unit's
[settings]({{< relref "/unit/configuration#configuration-stngs" >}})
allows recording
[routing choices]({{< relref "/unit/configuration#configuration-routes-matching" >}})
in the general-purpose log:

{{<bootstrap-table "table table-striped table-bordered">}}

| Event                | Log Level      | Description                                                                                       |
|----------------------|----------------|---------------------------------------------------------------------------------------------------|
| HTTP request line    | **[notice]**   | Incoming [request line](https://datatracker.ietf.org/doc/html/rfc9112#section-3).                |
| URI rewritten        | **[notice]**   | The request URI is updated.                                                                      |
| Route step selected  | **[notice]**   | The route step is selected to serve the request.                                                 |
| Fallback taken       | **[notice]**   | A **fallback** action is taken after the step is selected.                                       |

{{</bootstrap-table>}}


Sample router logging output may look like this:

```none
[notice] 8308#8339 *16 http request line "GET / HTTP/1.1"
[info] 8308#8339 *16 "routes/0" discarded
[info] 8308#8339 *16 "routes/1" discarded
[notice] 8308#8339 *16 "routes/2" selected
[notice] 8308#8339 *16 URI rewritten to "/backend/"
[notice] 8308#8339 *16 "fallback" taken
```

It lists specific steps and actions (such as **routes/2**) that can be queried via
the [control API]({{< relref "/unit/controlapi.md" >}}) for details:

```console
curl --unix-socket /path/to/control.unit.sock http://localhost/config/routes/2  # The step listed in the log
```

### Debug events {#troubleshooting-dbg-log}

Unit's log can be set to record **[debug]**-level events; the steps to enable this
mode vary by install method.

{{< warning >}}
Debug log is meant for developers; it grows rapidly, so enable it only for
detailed reports and inspection.
{{< /warning >}}

{{< tabs name="debug-log" >}}
{{% tab name="Installing From Our Repos" %}}

Our [repositories]({{< relref "/unit/installation.md#installation-precomp-packages" >}})
provide a debug version of `unitd` called `unitd-debug` within the `unit` package:

```console
# unitd-debug <command line options>
```

{{% /tab %}}
{{% tab name="Running From Docker Images" %}}

To enable debug-level logging when using our
[Docker iamges]({{< relref "/unit/installation.md#installation-docker" >}}):

```console
$ docker run -d unit:{{< param "unitversion" >}}-minimal unitd-debug --no-daemon  \
      --control unix:/var/run/control.unit.sock
```

Another option is adding a new layer in a Dockerfile:

```dockerfile

FROM unit:{{< param "unitversion" >}}-minimal

CMD ["unitd-debug","--no-daemon","--control","unix:/var/run/control.unit.sock"]
```

The **CMD** instruction above replaces the default `unitd` executable
with its debug version.

{{% /tab %}}
{{% tab name="Building From Source" %}}

To enable debug-level logging when
[installing from source]({{< relref "/unit/installation.md#source" >}}),
use the **--debug** option:

```console
$ ./configure --debug <other options>
```

Then recompile and reinstall Unit and your
[language modules]({{< relref "/unit/howto/source.md#source-modules" >}}).
{{% /tab %}}
{{< /tabs >}}


## Core dumps {#troubleshooting-core-dumps}

Core dumps help us investigate crashes; attach them when
[reporting an issue]({{< relref "/unit/troubleshooting.md#troubleshooting-support" >}}).
For builds from
[our repositories]({{< relref "/unit/installation.md#installation-precomp-packages" >}}),
we maintain debug symbols in special packages; they have the original packages'
names with the **-dbg** suffix appended, such as **unit-dbg**.

{{< note >}}
This section assumes you're running Unit as **root** (recommended).
{{< /note >}}

{{< tabs name="core-dumps" >}}
{{% tab name="Linux: systemd" %}}

To enable saving core dumps while running Unit as a `systemd` service
(for example, with
[packaged installations]({{< relref "/unit/installation.md#installation-precomp-packages" >}})),
adjust the [service settings](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
in **/lib/systemd/system/unit.service**:

```ini
[Service]
...
LimitCORE=infinity
LimitNOFILE=65535
```

Alternatively, update the
[global settings](https://www.freedesktop.org/software/systemd/man/systemd.directives.html)
in **/etc/systemd/system.conf**:

```ini
[Manager]
...
DefaultLimitCORE=infinity
DefaultLimitNOFILE=65535
```

Next, reload the service configuration and restart Unit to reproduce the crash
condition:

```console
# systemctl daemon-reload
```

```console
# systemczl restart unit.service
```

After a crash, locate the core dump file:

```console
# coredumpctl -1                     # optional

      TIME                            PID   UID   GID SIG COREFILE  EXE
      Mon 2020-07-27 11:05:40 GMT    1157     0     0  11 present   /usr/sbin/unitd
```

```console
# ls -al /var/lib/systemd/coredump/  # default, see also /etc/systemd/coredump.conf and /etc/systemd/coredump.conf.d/*.conf

      ...
      -rw-r----- 1 root root 177662 Jul 27 11:05 core.unitd.0.6135489c850b4fb4a74795ebbc1e382a.1157.1590577472000000.lz4
```

{{% /tab %}}
{{% tab name="Linux: Manual Setup" %}}

Check the
[core dump settings](https://www.man7.org/linux/man-pages/man5/limits.conf.5.html)
in **/etc/security/limits.conf**, adjusting them if necessary:

```none
root           soft    core       0          # disables core dumps by default
root           hard    core       unlimited  # enables raising the size limit
```

Next, raise the core dump size limit with
[ulimit](https://www.man7.org/linux/man-pages/man1/bash.1.html#SHELL_BUILTIN_COMMANDS),
then restart Unit to reproduce the crash condition:

```console
# ulimit -c unlimited
```

```console
# cd /path/to/unit/ # Unit's installation directory
```

```console
# sbin/unitd           # or sbin/unitd-debug
```

After a crash, locate the core dump file:

```console
# ls -al /path/to/unit/working/directory/  # default location, see /proc/sys/kernel/core_pattern

      ...
      -rw-r----- 1 root root 177662 Jul 27 11:05 core.1157
```

{{% /tab %}}
{{% tab name="FreeBSD" %}}

Check the
[core dump settings](https://www.freebsd.org/cgi/man.cgi?sysctl.conf(5))
in **/etc/sysctl.conf**, adjusting them if necessary:

```ini
kern.coredump=1
# must be set to 1
kern.corefile=/path/to/core/files/%N.core
# must provide a valid pathname
```

Alternatively, update the settings in runtime:

```console
# sysctl kern.coredump=1
```

```console
# sysctl kern.corefile=/path/to/core/files/%N.core
```

Next, restart Unit to reproduce the crash condition.
If Unit is installed as a service:

```console
# service unitd restart
```


If it's installed manually:

```console
# cd /path/to/unit/ # Unit's installation directory
```

```console
# sbin/unitd
```

After a crash, locate the core dump file:

```console
# ls -al /path/to/core/files/ # core dump directory

      ...
      -rw-------  1 root     root  9912320 Jul 27 11:05 unitd.core
```

{{% /tab %}}
{{< /tabs >}}

## Getting support {#troubleshooting-support}

{{<bootstrap-table "table table-striped table-bordered">}}

| Support \| Channel   | Details |
|----------------------|---------|
| **GitHub**          | Visit our [repo](https://github.com/nginx/unit) to submit issues, suggest features, ask questions, or see the roadmap. |
| **Mailing lists**   | To post questions to [unit@nginx.org](mailto:unit@nginx.org) and get notifications, including release news, email [unit-subscribe@nginx.org](mailto:unit-subscribe@nginx.org) or sign up [here](https://mailman.nginx.org/mailman/listinfo/unit).<br><br>To receive all OSS release announcements from NGINX, join the general mailing list [here](https://mailman.nginx.org/mailman/listinfo/nginx-announce). |
| **Security alerts** | Please report security issues to [security-alert@nginx.org](mailto:security-alert@nginx.org), specifically mentioning NGINX Unit in the subject and following the [CVSS v3.1](https://www.first.org/cvss/v3.1/specification-document) specification. |

{{</bootstrap-table>}}


In addition, we offer [commercial support](https://my.f5.com/manage/s/article/K000140156/).
