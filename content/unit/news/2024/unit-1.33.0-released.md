---
title: Unit 1.33.0 Released
weight: 200
---

We are pleased to announce the release of NGINX Unit 1.33.0. This release includes
a number of new features and changes:

## New configuration options

This release introduces three new configuration options:

1. **listen_threads**

   This option can be set under **/settings/listen_threads** and controls the
   number of threads the router process creates to handle client
   connections. By default, Unit creates the same number of threads as there
   are CPUs available.

2. **backlog**

   This option can be set under **/listeners/backlog**. This is a per-listener
   option that sets the the backlog parameter as passed to the **listen(2)**
   system-call, which defines the maximum length for the queue of pending
   connections for the socket.

   This is analogous to the **backlog** parameter of the **listen** directive in
   NGINX.

3. **factory**

   This option can be set under '/applications/\<app>/factory' and is specific to
   Python applications. This allows you to enable the `Application factories`
   feature of Python.

   This option is a boolean value. If set to 'true', Unit treats 'callable' as
   a factory.

   The default value is 'false'.

   NOTE: Unit does **not** support passing arguments to factories.

## unitctl CLI tool

[unitctl]({{<relref "/unit/unitctl.md">}})
is a Rust-based CLI tool that allows you to deploy, manage, and configure Unit
in your environment.

{{< note >}}
This is a "Technical Preview" release of **unitctl**. We welcome feedback and
suggestions for this early access version. It is provided to test its features
and should not be used in production environments.
{{< /note >}}

## Chunked request body support

Unit can now accept chunked requests rather than returning **411
Length Required**. This feature is experimental (not documented and subject to change), and can
be enabled setting the **/settings/chunked_transform** configuration option
to **true**.

## Changes in behavior and other updates

- On Linux, we now default to a **listen(2)** backlog of **-1**, which means we
  use the OS's default: **4096** for Linux 5.4 and later; **128** for older versions.

  The previous default for Unit was 511.

- Under systemd, Unit once again runs in **forking** mode. This allows the
  per-application logging feature to work out the box.

- The Python language module now supports **Application Factories**
  (thanks to Gourav).

## Changes for developers

We have made some changes to the build system:

### Prettified make output by default with GNU make

Instead of getting the normal compiler command for each target being built
you now get a simplified line like:

```console
CC     build/src/nxt_cgroup.o
```

You can use the **V=1** option to get the old verbose output, for example:

```console
make V=1
```

### Make variables

You can now control some aspects of the build process by passing variables to
**make** (like the above). The currently supported variables are:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option         | Description                    | Default |
|----------------|--------------------------------|---------|
| **D=1**       | Enables debug builds (-O0)     | 0       |
| **E=0**       | Disables -Werror               | 1       |
| **V=1**       | Enables verbose output         | 0       |
| **EXTRA_CFLAGS=** | Add extra compiler options |         |

{{</bootstrap-table>}}


### GCC & Clang

We removed support for several lesser-known compilers. GCC and Clang are now the
only supported compilers for building Unit.

### -std=gnu11

We now build with **-std=gnu11** (C11 with GNU extensions). While previously we
didn't explicitly set the -std= option, as we were supporting CentOS 7 (which is now
EOL), we were effectively limited to **-std=gnu89/90**.

## Wall of fame

Special Thanks to all external contributors helping us
making Unit better! With 1.33.0 we would like to send a shout out to:

- Alejandro Colomar
- Costas Drongos
- Gourav
- Remi Collet
- Robbie McKinstry

Special thanks to Arjun for his fuzzing work.

## Full Changelog

```none
Changes with Unit 1.33.0                                           18 Sep 2024

  *) Feature: show list of loaded language modules in the /status
     endpoint.

  *) Feature: make the number of router threads configurable.

  *) Feature: make the listen(2) backlog configurable.

  *) Feature: add fuzzing via oss-fuzz.

  *) Feature: add Python application factory support.

  *) Feature: add chunked request body support.

  *) Feature: add "if" option to the "match" object.

  *) Feature: Unit ships with a new Rust based CLI application "unitctl".

  *) Feature: the wasm-wasi-component language module now inherits the
     processes environment.

  *) Change: under systemd unit runs in forking mode (once again).

  *) Change: if building with njs, version 0.8.3 or later is now required.

  *) Change: Unit now builds with -std=gnu11 (C11 with GNU extensions).

  *) Change: Unit now creates the full directory path for the PID file and
     control socket.

  *) Change: build system improvements, including pretty printing the make
     output and enabling various make variables to influence the build
     process (see: make help).

  *) Change: better detection of available runnable CPUs on Linux.

  *) Change: default listen(2) backlog on Linux now defaults to Kernel
     default.

  *) Bugfix: fix a crash when interrupting a download via a proxy.

  *) Bugfix: don't create the $runstatedir directory which triggered an
     Alpine packaging error.

  *) Bugfix: wasm-wasi-component application process hangs after receiving
     restart signal from the control endpoint.

  *) Bugfix: njs variables accessed with a JS template literal should not
     be cacheable.

  *) Bugfix: don't modify REQUEST_URI.

  *) Bugfix: properly handle deleting arrays of certificates.
```
