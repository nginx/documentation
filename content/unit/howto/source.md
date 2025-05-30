---
title: Building from source
weight: 300
toc: true
---

After you've obtained Unit's
[source code]({{< relref "/unit/installation.md#source" >}}), configure
and compile it to fine-tune and run a custom Unit build.

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Installing Required Software {#source-prereq-build}

Before configuring and compiling Unit, install the required build tools and the
library files for the required languages (Go, Java, Node.js, PHP,
Perl, Python, and Ruby are supported) and all other features you want in your
Unit, such as TLS or regular expressions.

The commands below assume you are configuring Unit with all supported languages
and features (**X**, **Y**, and **Z** denote major, minor, and
revision numbers, respectively); omit the packages you won't use.

{{< tabs name="prereq" >}}

{{% tab name="Debian, Ubuntu" %}}

```console
# apt install build-essential
```

```console
# apt install golang
```

```console
# apt install curl && \
      curl -sL https://deb.nodesource.com/setup_VERSION.x | bash - && \ # Node.js 8.11 or later is supported
      apt install nodejs
```

```console
# npm install -g node-gyp
```

```console
# apt install php-dev libphp-embed
```

```console
# apt install libperl-dev
```

```console
# apt install pythonX-dev # Both Python 2 and Python 3 are supported
```

```console
# apt install ruby-dev ruby-rack
```

```console
# apt install openjdk-X-jdk # Java 8 or later is supported. Different JDKs may be used
```

```console
# apt install libssl-dev
```

```console
# apt install libpcre2-dev
```

{{% /tab %}}

{{% tab name="Amazon, Fedora, RHEL" %}}

```console
# yum install gcc make
```

```console
# yum install golang
```

```console
# yum install curl && \
      curl -sL https://rpm.nodesource.com/setup_VERSION.x | bash - && \ # Node.js 8.11 or later is supported
      yum install nodejs
```

```console
# npm install -g node-gyp
```

```console
# yum install php-devel php-embedded
```

```console
# yum install perl-devel perl-libs
```

```console
# yum install pythonX-devel # Both Python 2 and Python 3 are supported
```

```console
# yum install ruby-devel rubygem-rack
```

```console
# yum install java-X.Y.Z-openjdk-devel # Java 8 or later is supported. Different JDKs may be used
```

```console
# yum install openssl-devel
```
```console
# yum install pcre2-devel
```

{{% /tab %}}

{{% tab name="FreeBSD" %}}

Ports:

```console
# cd /usr/ports/lang/go/ && make install clean
```

```console
# cd /usr/ports/www/node/ && make install clean
```

```console
# cd /usr/ports/www/npm/ && make install clean && npm i -g node-gyp
```

```console
# cd /usr/ports/lang/phpXY/ && make install clean # PHP versions 5, 7, and 8 are supported
```

```console
# cd /usr/ports/lang/perlX.Y/ && make install clean # Perl 5.12 or later is supported
```

```console
# cd /usr/ports/lang/python/ && make install clean
```

```console
# cd /usr/ports/lang/rubyXY/ && make install clean # Ruby 2.0 or later is supported
```

```console
# cd /usr/ports/java/openjdkX/ && make install clean # Java 8 or later is supported. Different JDKs may be used
```

```console
# cd /usr/ports/security/openssl/ && make install clean
```

```console
# cd /usr/ports/devel/pcre2/ && make install clean
```

Packages:

```console
# pkg install go
```

```console
# pkg install node && pkg install npm && npm i -g node-gyp
```

```console
# pkg install phpXY # PHP versions 5, 7, and 8 are supported
```

```console
# pkg install perlX # Perl 5.12 or later is supported
```

```console
# pkg install python
```

```console
# pkg install rubyXY # Ruby 2.0 is supported
```

```console
# pkg install openjdkX # Java 8 or later is supported. Different JDKs may be used
```

```console
# pkg install openssl
```

```console
# pkg install pcre2
```

{{% /tab %}}

{{% tab name="Solaris" %}}

```console
# pkg install golang
```

```console
# pkg install php-XY # PHP versions 5, 7, and 8 are supported
```

```console
# pkg install ruby
```

```console
# pkg install jdk-X # Java 8 or later is supported. Different JDKs may be used
```

```console
# pkg install openssl
```

```console
# pkg install pcre
```

Also, use `gmake` instead of `make` when [building
and installing]({{< relref "/unit/howto/source.md#source-bld-src" >}}) Unit on Solaris.

{{% /tab %}}

{{< /tabs >}}

<details>
<summary>Enabling njs</summary>

<a name="source-njs"></a>

To build Unit with [njs](https://nginx.org/en/docs/njs/) support,
download the `njs` code to the same parent directory as the Unit code.

**0.8.2** is the latest version of `njs` that Unit supports.
Make sure you are in the correct branch before configuring the binaries.

```console
$ git clone https://github.com/nginx/njs.git
```

```console
$ cd njs
```

```console
$ git checkout -b 0.8.2 0.8.2
```

Next, configure and build the `njs` binaries. Make sure to use the
`--no-zlib` and `--no-libxml2` options to avoid
conflicts with Unit's dependencies:

```console
$ ./configure --no-zlib --no-libxml2 && make # Ensures Unit can link against the resulting library
```

Point to the resulting source and build directories when
[configuring]({{< relref "/unit/howto/source.md#source-config-src-njs" >}})
the Unit code.

---
</details>

<details>
<summary>Enabling WebAssembly</summary>
<a name="source-wasm"></a>

{{< tabs name="source-enable-webassembly" >}}
{{% tab name="wasm-wasi-component" %}}

To build Unit with support for the WebAssembly Component Model,
you need **rust** version 1.76.0+, **cargo** and the developer
package for **clang** as mentioned in the
[Required Software]({{< relref "/unit/howto/source.md#source-prereq-build" >}})
section.

Next please refer to
[Configuring Modules - WebAssembly]({{< relref "/unit/howto/source.md#modules-webassembly" >}})
for further instructions.

{{% /tab %}}
{{% tab name="unit-wasm" %}}

{{< warning >}}
The **unit-wasm** module is deprecated. We recommend using **wasm-wasi-component** instead,
available in Unit 1.32.0 and later, which supports WebAssembly Components using
standard WASI 0.2 interfaces.
{{< /warning >}}

To build Unit with the [WebAssembly](https://webassembly.org)
language module, you need the [Wasmtime](https://wasmtime.dev) runtime.
Download the C API [files](https://github.com/bytecodealliance/wasmtime/releases/)
suitable for your OS and architecture to the same parent directory as the Unit code,
for example:

```console
   $ cd ..
```

```console
$ wget -O- https://github.com/bytecodealliance/wasmtime/releases/download/v12.0.0/wasmtime-v12.0.0-x86_64-linux-c-api.tar.xz \
      | tar Jxf -  # Unpacks to the current directory
```

Point to the resulting **include** and **lib** directories when
[configuring]({{< relref "/unit/howto/source.md#source-modules-webassemble" >}})
the Unit code.

To build WebAssembly apps that run on Unit, you need
the
[wasi-sysroot](https://github.com/WebAssembly/wasi-sdk) SDK:

```console
$ wget -O- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-20/wasi-sysroot-20.0.tar.gz | tar zxf -
```

When building the apps, add the following environment variable:

```console
   WASI_SYSROOT=/path/to/wasi-sysroot-dir/ # wasi-sysroot directory
```

{{% /tab %}}
{{< /tabs >}}
</details>

---

## Configuring Sources {#source-config-src}

To run system compatibility checks and generate a **Makefile** with core
build instructions for Unit:

```console
$ ./configure COMPILE-TIME OPTIONS
```

See the table belo for common options.

Finalize the resulting **Makefile** by configuring the
[language modules]({{< relref "/unit/howto/source.md#source-modules" >}}).
you need before proceeding further.

General options and settings that control compilation, runtime privileges,
or support for certain features:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|------------|
| **--help** | Displays a summary of common `./configure` options.<br><br>For language-specific details, run `./configure <language> --help` or see [below](#source-modules). |
| **--cc=pathname** | Custom C compiler pathname.<br><br>The default is **cc**. |
| **--cc-opt=options**, **--ld-opt=options** | Extra options for the C compiler and linker. |
| **--group=name**, **--user=name** | Group name and username to run Unit's non-privileged [processes]({{< relref "/unit/howto/security.md#security-apps" >}}).<br><br>The defaults are **--user**'s primary group and **nobody**, respectively. |
| **--debug** | Turns on the [debug log]({{< relref "/unit/troubleshooting.md#troubleshooting-dbg-log" >}}). |
| **--no-ipv6** | Turns off IPv6 support. |
| **--no-unix-sockets** | Turns off UNIX domain sockets support for control and routing. |
| **--openssl** | Turns on OpenSSL support. Make sure OpenSSL (1.0.1+) header files and libraries are in your compiler's path; it can be set with the **--cc-opt** and **--ld-opt** options or the **CFLAGS** and **LDFLAGS** environment variables when running `./configure`.<br><br>For details of TLS configuration in Unit, see [configuration-ssl]({{< relref "/unit/certificates#configuration-ssl" >}}). |

{{</bootstrap-table>}}


<a name="source-config-src-pcre"></a>

By default, Unit relies on the locally installed version of the [PCRE](https://www.pcre.org) library to support regular expressions in
[routes]({{< relref "/unit/configuration.md#configuration-routes" >}});
if both major versions are present, Unit selects PCRE2. Two additional options
alter this behavior:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|------------|
| **--no-regex** | Turns off regex support; any attempts to use a regex in Unit configuration cause an error. |
| **--no-pcre2** | Ignores PCRE2; the older PCRE 8.x library is used instead. |

{{</bootstrap-table>}}


<a name="source-config-src-njs"></a>

Unit also supports the use of [njs](https://nginx.org/en/docs/njs/) scripts
in configuration; to enable this feature, use the respective option:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option  | Description |
|---------|------------|
| **--njs** | Turns on `njs` support; requires **--openssl**. |

{{</bootstrap-table>}}


When `--njs` is enabled, the `--cc-opt` and `--ld-opt` option values should
point to the **src/** and **build/** subdirectories of the `njs` source code.
For example, if you cloned the `njs` repo beside the Unit repo:

```console
$ ./configure --njs --openssl \
               --cc-opt="-I../njs/src/ -I../njs/build/"  \
               --ld-opt="-L../njs/build/"  \
               ...
```

The next option group customizes Unit's runtime
[directory structure]({{< relref "/unit/howto/source.md#source-dir" >}}):

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|------------|
| **--prefix=PREFIX** |<a name="source-config-src-prefix"></a> Destination directory prefix for [path options]({{< relref "/unit/howto/source.md#source-dir" >}}): `--bindir`, `--sbindir`, `--includedir`, `--libdir`, `--modulesdir`, `--datarootdir`, `--mandir`, `--localstatedir`, `--libstatedir`, `--runstatedir`, `--logdir`, `--tmpdir`, `--control`, `--pid`, `--log`.<br><br> The default is **/usr/local**. |
| **--exec-prefix=EXEC_PREFIX** | Destination directory prefix for the executable directories only.<br><br> The default is the **PREFIX** value. |
| **--bindir=BINDIR**, **--sbindir=SBINDIR** | Directory paths for client and server executables. <br><br>The defaults are **EXEC_PREFIX/bin** and **EXEC_PREFIX/sbin**. |
| **--includedir=INCLUDEDIR**, **--libdir=LIBDIR** | Directory paths for `libunit` header files and libraries.<br><br> The defaults are **PREFIX/include** and **EXEC_PREFIX/lib**. |
| **--modulesdir=MODULESDIR** | Directory path for Unit's language [modules]({{< relref "/unit/howto/modules.md" >}}).<br><br> The default is **LIBDIR/unit/modules**. |
| **--datarootdir=DATAROOTDIR**, **--mandir=MANDIR** | Directory path for **unitd(8)** data storage and its subdirectory where the `man` page is installed.<br><br> The defaults are **PREFIX/share** and **DATAROOTDIR/man**. |
| **--localstatedir=LOCALSTATEDIR** | Directory path where Unit stores its runtime state, PID file, control socket, and logs.<br><br> The default is **PREFIX/var**. |
| **--libstatedir=LIBSTATEDIR** | Directory path where Unit's runtime state (configuration, certificates, other resources) is stored between runs. If you migrate your installation, copy the entire directory.<br><br> <i class="fa-solid fa-triangle-exclamation" style="color: orange"></i> **Warning:** The directory is sensitive and must be owned by **root** with **700** permissions. Don't change its contents externally; use the config API to ensure integrity.<br><br> The default is **LOCALSTATEDIR/run/unit**. |
| **--logdir=LOGDIR**, **--log=LOGFILE** | Directory path and filename for Unit's [log]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}).<br><br> The defaults are **LOCALSTATEDIR/log/unit** and **LOGDIR/unit.log**. |
| **--runstatedir=RUNSTATEDIR** | Directory path where Unit stores its PID file and control socket.<br><br> The default is **LOCALSTATEDIR/run/unit**. |
| **--pid=pathname** | Pathname for the PID file of Unit's `main` [process]({{< relref "/unit/howto/security.md#security-apps" >}}).<br><br> The default is **RUNSTATEDIR/unit.pid**. |
| **--control=SOCKET** | [Control API]({{< relref "/unit/controlapi.md#configuration-mgmt" >}}) socket address in IPv4, IPv6, or UNIX domain format:<br><br> `$ ./configure --control=127.0.0.1:8080`<br> `$ ./configure --control=[::1]:8080`<br> `$ ./configure --control=unix:/path/to/control.unit.sock` (Note the `unix:` prefix).<br><br><i class="fa-solid fa-triangle-exclamation" style="color: orange"></i> **Warning:** Avoid exposing an unprotected control socket in public networks. Use [NGINX]({{< relref "/unit/howto/integration.md#nginx-secure-api" >}}) or a different solution such as SSH for security and authentication. <br><br>The default is **unix:RUNSTATEDIR/control.unit.sock**, created as **root** with **600** permissions. |
| **--tmpdir=TMPDIR** | Defines the temporary file storage location (used to dump large request bodies). The default value is **/tmp**. |

{{</bootstrap-table>}}

### Directory Structure {#source-dir}

By default, `make install` installs Unit at the following pathnames:

{{<bootstrap-table "table table-striped table-bordered">}}

| Directory | Default Path |
|-----------|-------------|
| **bin** directory | **/usr/local/bin/** |
| **sbin** directory | **/usr/local/sbin/** |
| **lib** directory | **/usr/local/lib/** |
| **include** directory | **/usr/local/include/** |
| **tmp** directory | **/tmp/** |
| Man pages | **/usr/local/share/man/** |
| Language modules | **/usr/local/lib/unit/modules/** |
| Runtime state | **/usr/local/var/lib/unit/** |
| PID file | **/usr/local/var/run/unit/unit.pid** |
| Log file | **/usr/local/var/log/unit/unit.log** |
| Control API socket | **unix:/usr/local/var/run/unit/control.unit.sock** |

{{</bootstrap-table>}}


The defaults are designed to work for most cases; to customize this layout,
set the `--prefix` and its related options during
[configuration]({{< relref "/unit/howto/source.md#source-config-src-prefix" >}}).
defining the resulting file structure.

## Configuring Modules {#source-modules}

Next, configure a module for each language you want to use with Unit. The
`./configure <language>` commands set up individual language modules
and place module-specific instructions in the **Makefile**.

{{< note >}}
To run apps in several versions of a language, build and install a module
for each version. To package custom modules, see the module
[howto]({{< relref "/unit/howto/modules.md#modules-pkg" >}}).
{{< /note >}}

{{< tabs name="modules" >}}
{{% tab name="Go" %}}

When you run `./configure go`, Unit sets up the Go package that
lets your applications
[run on Unit]({{< relref "/unit/configuration.md#configuration-go" >}}).
To use the package,
[install]({{< relref "/unit/howto/source.md#source-bld-src-ext" >}})
it in your Go environment. Available configuration options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--go=pathname** | Specific Go executable pathname, also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-ext" >}}) targets.<br><br> The default is **go**. |
| **--go-path=directory** | Custom directory path for Go package installation.<br><br> The default is **$GOPATH**. |

{{</bootstrap-table>}}


{{< note >}}
Running `./configure go` doesn't alter the `GOPATH`
[environment variable](https://github.com/golang/go/wiki/GOPATH), so
configure-time `--go-path` and compile-time `$GOPATH`
must be coherent for Go to find the resulting package.

```console
$ GOPATH=<Go package installation path> GO111MODULE=auto go build -o app app.go # App executable name and source code>`
```
{{< /note >}}

{{% /tab %}}
{{% tab name="Java" %}}

When you run `./configure java`, the script configures a module
to support running [Java Web Applications](https://download.oracle.com/otndocs/jcp/servlet-3_1-fr-spec/index.html)
on Unit.  Available command options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--home=directory** | Directory path for Java utilities and header files to build the module.<br><br> The default is the **java.home** setting. |
| **--jars=directory** | Directory path for Unit's custom **.jar** files.<br><br> The default is the Java module path. |
| **--lib-path=directory** | Directory path for the **libjvm.so** library.<br><br> The default is based on JDK settings. |
| **--local-repo=directory** | Directory path for the local **.jar** repository.<br><br> The default is **$HOME/.m2/repository/**. |
| **--repo=directory** | URL path for the remote Maven repository.<br><br> The default is **http://central.maven.org/maven2/**. |
| **--module=basename** | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets.<br><br> The default is **java**. |

{{</bootstrap-table>}}

To configure a module called **java11.unit.so** with OpenJDK
11.0.1:

```console
$ ./configure java --module=java11  \
                    --home=/Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home
```

{{% /tab %}}
{{% tab name="Node.js" %}}

When you run `./configure nodejs`, Unit sets up the
`unit-http` module that lets your applications
[run on Unit]({{< relref "/unit/configuration.md#configuration-nodejs" >}}).
Available configuration options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--local=directory** | Local directory path where the resulting module is installed.<br><br> By default, the module is installed globally [(recommended)](/unit/installation.md#installation-nodejs-package). |
| **--node=pathname** | Specific Node.js executable pathname, also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets.<br><br> The default is **node**. |
| **--npm=pathname** | Specific `npm` executable pathname.<br><br> The default is **npm**. |
| **--node-gyp=pathname** | Specific `node-gyp` executable pathname.<br><br> The default is **node-gyp**. |

{{</bootstrap-table>}}

{{% /tab %}}
{{% tab name="Perl" %}}

When you run `./configure perl`, the script configures a module
to support running Perl scripts as applications on Unit.  Available
command options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--perl=pathname** | Specific Perl executable pathname.<br><br> The default is **perl**. |
| **--module=basename** | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets.<br><br> The default is the filename of the `--perl` executable. |

{{</bootstrap-table>}}

To configure a module called **perl-5.20.unit.so** for Perl
5.20.2:

```console
   $ ./configure perl --module=perl-5.20  \
                        --perl=perl5.20.2
```

{{% /tab %}}
{{% tab name="PHP" %}}

When you run `./configure php`, the script configures a custom
SAPI module linked with the `libphp` library to support running
PHP applications on Unit.  Available command options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--config=pathname** | Pathname of the `php-config` script used to set up the resulting module.<br><br> The default is **php-config**. |
| **--lib-path=directory** | Directory path of the `libphp` library file (**libphp*.so** or **libphp*.a**), usually available with an `--enable-embed` PHP build. |
| **--lib-static** | Links the static `libphp` library (**libphp*.a**) instead of the dynamic one (**libphp*.so**); requires `--lib-path`. |
| **--module=basename** | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets.<br><br> The default is `--config`'s filename minus the `-config` suffix; thus, **--config=/path/php7-config** yields **php7.unit.so**. |

{{</bootstrap-table>}}


To configure a module called **php70.unit.so** for PHP 7.0:

```console
   $ ./configure php --module=php70  \
                     --config=/usr/lib64/php7.0/bin/php-config  \
                     --lib-path=/usr/lib64/php7.0/lib64
```

{{% /tab %}}
{{% tab name="Python" %}}

When you run `./configure python`, the script configures a
module to support running Python scripts as applications on Unit.
Available command options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option | Description |
|--------|-------------|
| **--config=pathname** | Pathname of the `python-config` script used to set up the resulting module.<br><br> The default is **python-config**. |
| **--lib-path=directory** | Custom directory path of the Python runtime library to use with Unit. |
| **--module=basename** | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets.<br><br> The default is `--config`'s filename minus the `-config` suffix; thus, **/path/python3-config** turns into **python3**. |

{{</bootstrap-table>}}


{{< note >}}
The Python interpreter set by `python-config` must be
compiled with the `--enable-shared` [option](https://docs.python.org/3/using/configure.html#linker-options).
{{< /note >}}

To configure a module called **py33.unit.so** for Python 3.3:

```console
$ ./configure python --module=py33  \
                     --config=python-config-3.3
```
{{% /tab %}}
{{% tab name="Ruby" %}}

When you run `./configure ruby`, the script configures a module
to support running Ruby scripts as applications on Unit.  Available
command options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| **--module=basename**  | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets. <br><br> The default is the filename of the `--ruby` executable. |
| **--ruby=pathname**    | Specific Ruby executable pathname.<br><br> The default is **ruby**.                 |
{{</bootstrap-table>}}


To configure a module called **ru23.unit.so** for Ruby 2.3:

```console
   $ ./configure ruby --module=ru23  \
                        --ruby=ruby23
```

{{% /tab %}}
{{% tab name="WebAssembly" %}}

When you run `./configure wasm-wasi-component`,
the script configures a module to support running WebAssembly
components on Unit.

The module doesn't accept any extra configuration parameters.
The module's basename is wasm-wasi-component.

{{% /tab %}}
{{% tab name="Unit-Wasm" %}}

{{< warning >}}
Unit 1.32.0 and later support the WebAssembly Component Model and WASI
0.2 APIs.
We recommend using the new implementation.
{{< /warning >}}

When you run `./configure wasm`, the script configures a module
to support running WebAssembly applications on Unit.
Available command options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| **--module=basename**  | Resulting module's name (**<basename>.unit.so**), also used in [make]({{< relref "/unit/howto/source.md#source-bld-src-emb" >}}) targets. |
| **--runtime=basename** | The WebAssembly runtime to use. <br><br>The default is **wasmtime**.                |
| **--include-path=path**| The directory path to the runtime's header files.                           |
| **--lib-path=path**    | The directory path to the runtime's library files.                          |
| **--rpath=<path>**     | The directory path that designates the run-time library search path. <br><br> If specified without a value, assumes the **--lib-path** value. |
{{</bootstrap-table>}}


To configure a module called **wasm.unit.so**:

```console
$ ./configure wasm --include-path=/path/to/wasmtime/include  \
                     --lib-path=/path/to/wasmtime/lib \
                     --rpath
```

{{% /tab %}}
{{< /tabs >}}

---

## Building and Installing Unit {#source-bld-src}

To build and install Unit's executables and language modules that you have
`./configure`'d earlier:

```console
$ make
```

```console
# make install
```

Mind that **make install** requires setting up Unit's
[directory structure]({{< relref "/unit/howto/source.md#source-dir" >}})
with `./configure` first.
To run Unit from the build directory tree without installing:

```console
$ ./configure --prefix=./build
```

```console
$ make
```

```console
$ ./build/sbin/unitd
```

You can also build and install language modules individually; the specific
method depends on whether the language module is embedded in Unit (Java, Perl,
PHP, Python, Ruby) or packaged externally (Go, Node.js).

{{< note >}}
For further details about Unit's language modules, see
[Working with language modules]({{< relref "/unit/howto/modules.md" >}})
{{< /note >}}

### Embedded Language Modules {#source-bld-src-emb}

To build and install the modules for Java, PHP, Perl, Python, or Ruby after
configuration, run `make <module basename>` and `make <module basename>-install`,
for example:

```console
$ make perl-5.20 # This is the --module option value from ./configure perl
```

```console
# make perl-5.20-install # This is the --module option value from ./configure perl
```

### External Language Modules {#source-bld-src-ext}

To build and install the modules for Go and Node.js globally after
configuration, run `make <go>-install` and `make <node>-install`, for example:

```console
# make go-install # This is the --go option value from ./configure go
```

```console
# make node-install # This is the --node option value from ./configure nodejs
```

{{< note >}}
To install the Node.js module locally, run `make <node>-local-install`:

```console
# make node-local-install # This is the --node option value from ./configure nodejs
```

If you haven't specified the `--local` directory with `./configure nodejs`
earlier, provide it here:

```console
# DESTDIR=/your/project/directory/ make node-local-install
```

If both options are specified, `DESTDIR` prefixes the
`--local` value set by `./configure nodejs`.

Finally, mind that global installation is preferable for the Node.js module.
{{< /note >}}

If you customized the executable pathname with `--go` or `--node`, use the
following pattern:

```console
$ ./configure nodejs --node=/usr/local/bin/node8.12 # Executable pathname
```

```console
# make /usr/local/bin/node8.12-install # Executable pathname becomes a part of the target
```

```console
$ ./configure go --go=/usr/local/bin/go1.7 # Executable pathname
```

```console
# make /usr/local/bin/go1.7-install # Executable pathname becomes a part of the target
```

## Startup and Shutdown {#source-startup}

{{< warning >}}
We advise installing Unit from
[precompiled packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}});
in this case, startup is
[configured]({{< relref "/unit/installation.md#installation-precomp-startup" >}})
automatically.

Even if you install Unit otherwise, avoid manual startup. Instead, configure a
service manager (`OpenRC`, `systemd`, and so on) or create an `rc.d` script to
launch the Unit daemon using the options below.
{{< /warning >}}

The startup command depends on the directories you set with `./configure`, but
their default values place the `unitd` binary in a well-known place, so:

```console
# unitd RUNTIME OPTIONS # Your PATH environment variable should list a path to unitd
```

See the table below for common runtime options.

Run `unitd -h` or `unitd --version` to list Unit's
compile-time settings. Usually, the defaults don't require overrides; still,
the following runtime options are available. For their compile-time
counterparts, see
[here]({{< relref "/unit/howto/source.md#source-config-src" >}}).

{{<bootstrap-table "table table-striped table-bordered">}}
| Option                         | Description                                                                 |
|--------------------------------|-----------------------------------------------------------------------------|
| **--help**, **-h**             | Displays a summary of the command-line options and their defaults.          |
| **--version**                  | Displays Unit's version and the `./configure` settings it was built with.   |
| **--no-daemon**                | Runs Unit in non-daemon mode.                                                |
| **--control socket**           | Control API socket address in IPv4, IPv6, or UNIX domain format: <br><br>`# unitd --control 127.0.0.1:8080`<br><br>`# unitd --control [::1]:8080`<br><br>`# unitd --control unix:/path/to/control.unit.sock`                            |
| **--control-mode**             | Sets the permission of the UNIX domain control socket. Default: 0600        |
| **--control-user**             | Sets the owner of the UNIX domain control socket.                           |
| **--control-group**            | Sets the group of the UNIX domain control socket.                           |
| **--group name**, **--user name**| Group name and user name used to run Unit's non-privileged [processes]({{< relref "/unit/howto/security.md#security-apps" >}}).      |
| **--log pathname**             | Pathname for Unit's [log]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}).                                                    |
| **--modules directory**        | Directory path for Unit's language [modules]({{< relref "/unit/howto/modules.md" >}}) (***.unit.so** files).            |
| **--pid pathname**             | Pathname for the PID file of Unit's **main** [process]({{< relref "/unit/howto/security.md#security-apps" >}}).                           |
| **--state directory**          | Directory path for Unit's state storage.                                    |
| **--tmp directory**            | Directory path for Unit's temporary file storage.                           |
{{</bootstrap-table>}}


Finally, to stop a running Unit:

```console
# pkill unitd
```

This command signals all Unit's processes to terminate in a graceful manner.
