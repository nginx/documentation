---
title: Installation
weight: 400
toc: true
---

You can install NGINX Unit in four alternative ways:

- Choose from our official [binary packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) for a few popular systems.
  They're as easy to use as any other packaged software and suit most purposes
  straight out of the box.
- If your preferred OS or language version is missing from the official package list,
  try [third-party repositories]({{< relref "/unit/installation.md#installation-community-repos" >}}).
  Be warned, though: we don't maintain them.
- Run our [Docker official images]({{< relref "/unit/installation.md#installation-docker" >}}),
  prepackaged with varied language combinations.
- To fine-tune Unit to your goals,
  download the [sources]({{< relref "/unit/installation.md#source" >}}),
  install the [toolchain]({{< relref "/unit/howto/source.md#source-prereq-build" >}}),
  and [build]({{< relref "/unit/howto/source.md#source-config-src" >}}) a custom binary from scratch; just make sure you know what you're doing.

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Prerequisites {#source-prereqs}

Unit compiles and runs on various Unix-like operating systems, including:

- FreeBSD 10 or later
- Linux 2.6 or later
- macOS 10.6 or later
- Solaris 11

It also supports most modern instruction set architectures, such as:

- ARM
- IA-32
- PowerPC
- MIPS
- S390X
- x86-64

App languages and platforms that Unit can run
(including several versions of the same language):

- Go 1.6 or later
- Java 8 or later
- Node.js 8.11 or later
- PHP 5, 7, 8
- Perl 5.12 or later
- Python 2.6, 2.7, 3
- Ruby 2.0 or later
- WebAssembly Components WASI 0.2

Optional dependencies:

- OpenSSL 1.0.1 or later for [TLS]({{< relref "/unit/certificates.md#configuration-ssl" >}}) support
- PCRE (8.0 or later) or PCRE2 (10.23 or later) for
  [regular expression matching]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns">}})
- The   [njs](https://nginx.org/en/docs/njs/) scripting language
- Wasmtime for WebAssembly Support

## Official packages {#installation-precomp-pkgs}

Installing an official precompiled Unit binary package
is best on most occasions;
they're available for:

- Amazon Linux [AMI]({{< relref "/unit/installation.md#installation-amazon-ami" >}}),
  Amazon Linux [2]({{< relref "/unit/installation.md#installation-amazon-20lts" >}}),
  Amazon Linux [2023]({{< relref "/unit/installation.md#installation-amazon-2023" >}})
- Debian [11]({{< relref "/unit/installation.md#installation-debian-11" >}}),
  [12]({{< relref "/unit/installation.md#installation-debian-12" >}})
- Fedora [41]({{< relref "/unit/installation.md#installation-fedora-41" >}})
- RHEL [8]({{< relref "/unit/installation.md#installation-rhel-8x" >}}),
  [9]({{< relref "/unit/installation.md#installation-rhel-9x" >}})
- Ubuntu [16.04]({{< relref "/unit/installation.md#installation-ubuntu-1604" >}}),
  [18.04]({{< relref "/unit/installation.md#installation-ubuntu-1804" >}}),
  [20.04]({{< relref "/unit/installation.md#installation-ubuntu-2004" >}}),
  [21.04]({{< relref "/unit/installation.md#installation-ubuntu-2104" >}}),
  [22.04]({{< relref "/unit/installation.md#installation-ubuntu-2204" >}}),
  [24.04]({{< relref "/unit/installation.md#installation-ubuntu-2404" >}})

The packages include core executables, developer files,and support for individual
languages.
We also maintain a Homebrew [tap]({{< relref "/unit/installation.md#installation-macos-homebrew" >}}) for
macOS users and a [module]({{< relref "/unit/installation.md#installation-nodejs-package" >}}) for Node.js
at the [npm](https://www.npmjs.com/package/unit-http) registry.

{{< note >}}
For details of packaging custom modules that install alongside the official Unit,
see [here]({{< relref "/unit/howto/modules.md#modules-pkg" >}}).
{{< /note >}}

### Repository installation script {#repo-install}

<details open=true>
<summary>Repo installation script</summary>

   We provide a [script](https://github.com/nginx/unit/tree/master/tools>)
   that adds our official repos on the systems we support:

   ```console
   wget https://raw.githubusercontent.com/nginx/unit/master/tools/setup-unit && chmod +x setup-unit
   ```

   Run the following command as root:

   ```console
   ./setup-unit repo-config
   ```

   Use it at your discretion; explicit steps are provided below
   for each distribution.
</details>

---

### Amazon Linux {#installation-precomp-amazon}

{{<tabs name="Amazon Linux">}}

{{%tab name="2023"%}}
Supported architecture: x86-64.

1. To configure Unit's repository,
   create the following file named
   **/etc/yum.repos.d/unit.repo**:

   ```ini
   [unit]
   name=unit repo
   baseurl=https://packages.nginx.org/unit/amzn/2023/$basearch/
   gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
   gpgcheck=1
   enabled=1
   ```

1. Install the core package and other packages you need:

   ```console
   # yum install unit
   ```

   ```console
   # yum install unit-devel unit-jsc17 unit-perl  \ # unit-devel is required to install the Node.js module
         unit-php unit-python39 unit-python311 unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```



{{<bootstrap-table "table table-striped table-bordered">}}
|           Runtime details:         | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})             | **/var/run/unit/control.sock**      |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})   | **/var/log/unit/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                            |

{{</bootstrap-table>}}
{{%/tab%}}

{{%tab name="2022 LTS"%}}

Supported architecture: x86-64.

1. To configure Unit's repository, create the following file named **/etc/yum.repos.d/unit.repo**:

   ```ini
   [unit]
   name=unit repo
   baseurl=https://packages.nginx.org/unit/amzn2/$releasever/$basearch/
   gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
   gpgcheck=1
   enabled=1
   ```

1. Install the core package
   and other packages you need:

   ```console
   # yum install unit
   ```

   ```console
   # yum install unit-devel unit-jsc8 unit-perl  \ # unit-devel is required to install the Node.js module
         unit-php unit-python27 unit-python37 unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

|      Runtime details:              | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})     | **/var/run/unit/control.sock**                                |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}) | **/var/log/unit/unit.log**                                    |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                                     |

{{</bootstrap-table>}}


{{%/tab%}}

{{%tab name="AMI"%}}

{{< warning >}}
Unit's 1.22+ packages aren't built for Amazon Linux AMI. This distribution is
obsolete; please update.
{{< /warning >}}

Supported architecture: x86-64.

1. To configure Unit's repository,
   create the following file named
   **/etc/yum.repos.d/unit.repo**:

   ```ini
      [unit]
      name=unit repo
      baseurl=https://packages.nginx.org/unit/amzn/$releasever/$basearch/
      gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
      gpgcheck=1
      enabled=1
   ```

1. Install the core package
   and other packages you need:

   ```console
     # yum install unit
   ```

   ```console
     # yum install unit-devel unit-jsc8 unit-perl unit-php  \ # unit-devel is required to install the Node.js module
            unit-python27 unit-python34 unit-python35 unit-python36
   ```

   ```console
     # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

|      Runtime details:              | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})     | **/var/run/unit/control.sock**                                |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}) | **/var/log/unit/unit.log**                                    |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                                     |

{{</bootstrap-table>}}

{{%/tab%}}
{{</tabs>}}

---

### Debian {#installation-precomp-deb}

{{<tabs name="Debian">}}
{{%tab name="12"%}}
Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bookworm unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bookworm unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-jsc17 unit-perl  \ # unit-dev is required to install the Node.js module
         unit-php unit-python3.11 unit-ruby unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```
{{<bootstrap-table "table table-striped table-bordered">}}
|   Runtime details:           | Description                                                        |
|--------------------|--------------------------------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})     | **/var/run/control.unit.sock**                                |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}) | **/var/log/unit.log**                                        |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                                     |
{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="11"%}}

Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ bullseye unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-jsc11 unit-perl  \ # unit-dev is required to install the Node.js module
         unit-php unit-python2.7 unit-python3.9 unit-ruby unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}
| Runtime details:                                  | Description                    |
|---------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})        | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})    | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |
{{</bootstrap-table>}}

{{%/tab%}}
{{</tabs>}}

---

### Fedora {#installation-precomp-fedora}

{{<tabs name="Fedora">}}
{{%tab name="41"%}}

Supported architecture: x86-64.

1. To configure Unit's repository, create the following file named
   **/etc/yum.repos.d/unit.repo**:

   ```ini
   [unit]
   name=unit repo
   baseurl=https://packages.nginx.org/unit/fedora/$releasever/$basearch/
   gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
   gpgcheck=1
   enabled=1
   ```

1. Install the core package and other packages you need:

   ```console
   # dnf install unit
   ```

   ```console
   # dnf install unit-devel unit-jsc17 unit-perl  \ # unit-devel is required to install the Node.js module
         unit-php unit-python311 unit-ruby
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}
| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/unit/control.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}) | **/var/log/unit/unit.log** |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit** |
{{</bootstrap-table>}}

{{%/tab%}}
{{</tabs>}}

---

### RHEL and derivatives {#installation-precomp-rhel}

{{< note >}}
Use these steps for binary-compatible distributions: AlmaLinux, CentOS,
Oracle Linux, or Rocky Linux.
{{< /note >}}

{{<tabs name="RHEL and derivatives">}}
{{%tab name="9.x"%}}

Supported architecture: x86-64.

1. To configure Unit's repository, create the following file named
   **/etc/yum.repos.d/unit.repo**:

   ```ini
   [unit]
   name=unit repo
   baseurl=https://packages.nginx.org/unit/rhel/$releasever/$basearch/
   gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
   gpgcheck=1
   enabled=1
   ```

1. Install the core package and other packages you need:

   ```console
   # yum install unit
   ```

   ```console
   # yum install unit-devel unit-go unit-jsc8 unit-jsc11  \ # unit-devel is required to install the Node.js module and build Go apps
         unit-perl unit-php unit-python39 unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                 | Description                    |
|---------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})        | **/var/run/unit/control.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})    | **/var/log/unit/unit.log**     |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="8.x"%}}

Supported architecture: x86-64.

1. To configure Unit's repository, create the following file named
   **/etc/yum.repos.d/unit.repo**:

   ```ini
   [unit]
   name=unit repo
   baseurl=https://packages.nginx.org/unit/rhel/$releasever/$basearch/
   gpgkey=https://unit.nginx.org/keys/nginx-keyring.gpg
   gpgcheck=1
   enabled=1
   ```

1. Install the core package and other packages you need:

   ```console
   # yum install unit
   ```

   ```console
   # yum install unit-devel unit-jsc8 unit-jsc11  \  # unit-devel is required to install the Node.js module
         unit-perl unit-php unit-python27 unit-python36 unit-python38 unit-python39 unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                 | Description                    |
|---------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})        | **/var/run/unit/control.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})    | **/var/log/unit/unit.log**     |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{</tabs>}}

---

{{< note >}}Use these steps for binary-compatible distributions: AlmaLinux, CentOS, Oracle Linux, or Rocky Linux.{{< /note >}}

---

### Ubuntu {#installation-precomp-ubuntu}
{{<tabs name="Ubuntu">}}
{{%tab name="24.04"%}}

Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ noble unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ noble unit
   ```


1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-go unit-jsc11 unit-jsc17 unit-jsc21  \ # unit-dev is required to install the Node.js module and build Go apps
               unit-perl unit-php unit-python3.12 unit-ruby unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                    |
|-----------------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="22.04"%}}

Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ jammy unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ jammy unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-go unit-jsc11 unit-jsc16 unit-jsc17 unit-jsc18  \ # unit-dev is required to install the Node.js module and build Go apps
                  unit-perl unit-php unit-python2.7 unit-python3.10 unit-ruby unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                    |
|-----------------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="20.04"%}}

Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ focal unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ focal unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-jsc11 unit-perl  \ # unit-dev is required to install the Node.js module
         unit-php unit-python2.7 unit-python3.8 unit-ruby unit-wasm
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                    |
|-----------------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="18.04"%}}

{{< warning >}}
Unit's 1.31+ packages aren't built for Ubuntu 18.04. This distribution is obsolete;
please update.
{{< /warning >}}

Supported architectures: arm64, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ bionic unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ bionic unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-jsc8 unit-jsc11 unit-perl  \ # unit-dev is required to install the Node.js module
         unit-php unit-python2.7 unit-python3.6 unit-python3.7 unit-ruby
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                    |
|-----------------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{%tab name="16.04"%}}

{{< warning >}}
Unit's 1.24+ packages aren't built for Ubuntu 16.04. This distribution is obsolete;
please update.
{{< /warning >}}

Supported architectures: arm64, i386, x86-64.

1. Download and save NGINX's signing key:

   ```console
   # curl --output /usr/share/keyrings/nginx-keyring.gpg  \
         https://unit.nginx.org/keys/nginx-keyring.gpg
   ```

   This eliminates the "packages cannot be authenticated" warnings
   during installation.

1. To configure Unit's repository, create the following file named
   **/etc/apt/sources.list.d/unit.list**:

   ```none
   deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ xenial unit
   deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ xenial unit
   ```

1. Install the core package and other packages you need:

   ```console
   # apt update
   ```

   ```console
   # apt install unit
   ```

   ```console
   # apt install unit-dev unit-jsc8 unit-perl unit-php  \ # unit-dev is required to install the Node.js module
         unit-python2.7 unit-python3.5 unit-ruby
   ```

   ```console
   # systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
   ```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                    |
|-----------------------------------------------|--------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/var/run/control.unit.sock** |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**          |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                       |

{{</bootstrap-table>}}

{{%/tab%}}
{{</tabs>}}

---

### macOS {#installation-macos}

To install Unit on macOS, use the official Homebrew
[tap](https://github.com/nginx/homebrew-unit).

```console
$ brew install nginx/unit/unit
```

This deploys the core Unit binary and the prerequisites for the
[Node.js]({{< relref "/unit/installation.md#installation-nodejs-package" >}})
language module.

To install the Java, Perl, Python, and Ruby language modules from Homebrew:

```console
$ brew install unit-java unit-perl unit-php unit-python unit-python3 unit-ruby
```

```console
# pkill unitd  # Stop Unit
```

```console
# unitd        # Start Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                                                                                                                                       |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}}) | **/usr/local/var/run/unit/control.sock** (Intel), **/opt/homebrew/var/run/unit/control.sock** (Apple Silicon)                                                     |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/usr/local/var/log/unit/unit.log** (Intel), **/opt/homebrew/var/log/unit/unit.log** (Apple Silicon)                                                             |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **nobody**                                                                                                                                                        |

{{</bootstrap-table>}}


{{< note >}}
To run Unit as **root** on macOS:

```console
$ export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```

```console
$ sudo --preserve-env=OBJC_DISABLE_INITIALIZE_FORK_SAFETY /path/to/unitd ...
```
{{< /note >}}

### Node.js {#installation-nodejs-package}

Unit's npm-hosted Node.js [module](https://www.npmjs.com/package/unit-http)
is called `unit-http`. Install it to run Node.js apps on Unit:

1. First, install the **unit-dev/unit-devel**
   [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}); it's needed to build `unit-http`.

2. Next, build and install `unit-http` globally (this requires
   `npm` and `node-gyp`):

   ```console
   # npm install -g --unsafe-perm unit-http
   ```

   {{< warning >}}
   The `unit-http` module is platform dependent due to optimizations;
   you can't move it across systems with the rest of **node-modules**.
   Global installation avoids such scenarios; just [relink]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
   the migrated app.
   {{< /warning >}}

3. It's entirely possible to run
   [Node.js apps]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
   on Unit without mentioning **unit-http** in your app sources.
   However, you can explicitly use **unit-http** in your code instead of the
   built-in **http**, but mind that such frameworks as Express may require extra
   [changes]({{< relref "/unit/howto/frameworks/express.md" >}}).

{{< warning >}}
The `unit-http` module and `Unit` must have matching version numbers.
{{< /warning >}}

If you update Unit later, make sure to update the module as well:

```console
# npm update -g --unsafe-perm unit-http
```

{{< note >}}
You can also [configure]({{< relref "/unit/howto/modules.md#howto/source-modules-nodejs" >}}) and
[install]({{< relref "/unit/installation.md#source-bld-src-ext" >}}) the `unit-http` module from sources.
{{< /note >}}

#### Working with multiple Node.js versions {#multiple-nodejs-versions}
<details>
<summary>Working with multiple Node.js versions</summary>

To use Unit with multiple Node.js versions side by side, we recommend
[Node Version Manager](https://github.com/nvm-sh/nvm).

```console
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/x.y.z/install.sh | bash # Replace x.y.z with the nvm version
```

Install the versions you need and select the one you want to use with Unit:

```console
$ nvm install 18
```

```console
$ nvm install 16
```

```console
$ nvm use 18
      Now using node v18.12.1 (npm v8.19.2) # Note the version numbers
```

Having selected the specific version, install the `node-gyp` module:

```console
$ npm install -g node-gyp
```

Next, clone the Unit source code to build a `unit-http` module for the selected
Node.js version:

```console
$ git clone https://github.com/nginx/unit
```

```console
$ cd unit
```

```console
$ pwd
      /home/user/unit # Note the path to the source code
```

```console
$ ./configure
```

```console
$ ./configure nodejs

      configuring nodejs module
      checking for node ... found
         + node version v18.12.1 # Should be the version selected with nvm
      checking for npm ... found
         + npm version `8.19.2 # Should be the version selected with npm
      checking for node-gyp ... found
         + node-gyp version v9.3.0
```

Point to Unit's header files and libraries in the source code directory
to build the module:

```console
$ CPPFLAGS="-I/home/user/unit/include/" LDFLAGS="-L/home/user/unit/lib/"  \
      make node-install
```

```console
$ npm list -g

      /home/vagrant/.nvm/versions/node/v18.12.1/lib
      ├── corepack@0.14.2
      ├── node-gyp@9.3.0
      ├── npm@8.19.2
      └── unit-http@1.29.0
```

That's all; use the newly built module to run your
[Node.js apps]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
on Unit as usual.
</details>

### Startup and shutdown {#installation-precomp-startup}

{{< tabs name="Startup and shutdown" >}}
{{% tab name="Amazon, Debian, Fedora, RHEL, Ubuntu" %}}

Enable Unit to launch automatically at system startup:

```console
# systemctl enable unit
```

Start or restart Unit:

```console
# systemctl restart unit
```

Stop a running Unit:

```console
# systemctl stop unit
```

Disable Unit's automatic startup:

```console
# systemctl disable unit
```

{{%/tab%}}
{{% tab name="macOS (Homebrew)" %}}

Start Unit as a daemon:

```console
# unitd
```

Stop all Unit's processes:

```console
# pkill unitd
```

For startup options, see the
[Building from source]({{< relref "/unit/howto/source.md#source-startup" >}})
documentation.
{{%/tab%}}
{{</tabs>}}

---

{{< note >}} Restarting Unit is necessary after installing or uninstalling any
language modules to pick up the changes.
{{< /note >}}

## Community Repositories {#installation-community-repos}

{{< warning >}}
These distributions are maintained by their respective communities,
not NGINX. Use them with caution.
{{< /warning >}}

{{< tabs name="Community Repositories" >}}
{{% tab name="Alpine" %}}

To install Unit's core executables from the Alpine Linux
[packages](https://pkgs.alpinelinux.org/packages?name=unit*):

```console
# apk update
```

```console
# apk upgrade
```

```console
# apk add unit
```

To install service manager files and specific language modules:

```console
# apk add unit-openrc unit-perl unit-php7 unit-python3 unit-ruby
```

```console
# service unit restart  # Necessary for Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/run/control.unit.sock**                   |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit.log**                         |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                      |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   ```console
   # service unit enable # Enable Unit to launch automatically at system startup
   ```

   ```console
   # service unit restart # Start or restart Unit; one-time action
   ```

   ```console
   # service unit stop # Stop a running Unit; one-time action
   ```

   ```console
   # service unit disable # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="Alt" %}}

To install Unit's core executables and specific language modules
from the Sisyphus [packages](https://packages.altlinux.org/en/sisyphus/srpms/unit):

```console
# apt-get update
```

```console
# apt-get install unit
```

```console
# apt-get install unit-perl unit-php unit-python3 unit-ruby
```

```console
# service unit restart  # Necessary for Unit to pick up any changes in language module setup
```

Versions of these packages with the ***-debuginfo** suffix contain symbols for
[debugging]({{< relref "/unit/troubleshooting.md#troubleshooting-core-dumps" >}}).


{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/run/unit/control.sock**                   |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit/unit.log**                   |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **_unit** (mind the **_** prefix)            |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   ```console
   # service unit enable # Enable Unit to launch automatically at system startup
   ```

   ```console
   # service unit restart # Start or restart Unit; one-time action
   ```

   ```console
   # service unit stop # Stop a running Unit; one-time action
   ```

   ```console
   # service unit disable # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="Arch" %}}


To install Unit's core executables and all language modules,
clone the [Arch User Repository (AUR)](https://aur.archlinux.org/pkgbase/nginx-unit/).

```console
$ git clone https://aur.archlinux.org/nginx-unit.git
$ cd nginx-unit
```

Before proceeding further, verify that the **PKGBUILD** and the accompanying files
aren't malicious or untrustworthy. AUR packages are user produced without
pre-moderation; use them at your own risk.

Next, build the package:

```console
$ makepkg -si
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/run/nginx-unit.control.sock**             |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/nginx-unit.log**                  |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **nobody**                                   |

{{</bootstrap-table>}}

- **Startup and shutdown:**

   ```console
   # systemctl enable unit # Enable Unit to launch automatically at system startup
   ```

   ```console
   # systemctl restart unit # Start or restart Unit; one-time action
   ```

   ```console
   # systemctl stop unit # Stop a running Unit; one-time action
   ```

   ```console
   # systemctl disable unit # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="FreeBSD" %}}

To install Unit from
[FreeBSD packages](https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro>)
get the core package and other packages you need:

```console
# pkg install -y unit
```

```console
# pkg install -y `libunit # Required to install the Node.js module
```

```console
# pkg install -y unit-java8  \
                  unit-perl5.36  \
                  unit-php81 unit-php82 unit-php83  \
                  unit-python39  \
                  unit-ruby3.2  \
                  unit-wasm
```

```console
# service unitd restart  # Necessary for Unit to pick up any changes in language module setup
```

To install Unit from [FreeBSD ports](https://docs.freebsd.org/en/books/handbook/ports/#ports-using),
start by updating your port collection.

With `portsnap`:

```console
# portsnap fetch update
```

With `git`:

```console
# cd /usr/ports && git pull
```

Next, browse to the port path to build and install the core Unit port:

```console
# cd /usr/ports/www/unit/
```

```console
# make
```

```console
# make install
```

Repeat the steps for the other ports you need:
[libunit](https://www.freshports.org/devel/libunit/)
(required to install the Node.js
[module]({{< relref "/unit/installation.md#installation-nodejs-package" >}})
and build
[Go apps]({{< relref "/unit/configuration.md#configuration-go" >}}),
,
[unit-java](https://www.freshports.org/www/unit-java/),
[unit-perl](https://www.freshports.org/www/unit-perl/),
[unit-php](https://www.freshports.org/www/unit-php/),
[unit-python](https://www.freshports.org/www/unit-python/),
[unit-ruby](https://www.freshports.org/www/unit-ruby/),
or
[unit-wasm](https://www.freshports.org/www/unit-wasm/).

After that, restart Unit:

```console
# service unitd restart  # Necessary for Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/var/run/unit/control.unit.sock**          |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit/unit.log**                   |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **www**                                      |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   ```console
   # service unitd enable # Enable Unit to launch automatically at system startup
   ```

   ```console
   # service unitd restart # Start or restart Unit; one-time action
   ```

   ```console
   # service unitd stop # Stop a running Unit; one-time action
   ```

   ```console
   # service unitd disable # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="Gentoo" %}}

To install Unit using [Portage](https://wiki.gentoo.org/wiki/Handbook:X86/Full/Portage),
update the repositoryand install the

```console
# emerge --sync
```

```console
# emerge www-servers/nginx-unit
```

To install specific language modules and features, apply the corresponding
[USE flags](https://packages.gentoo.org/packages/www-servers/nginx-unit).

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/run/nginx-unit.sock**                     |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/nginx-unit**                      |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **nobody**                                  |

{{</bootstrap-table>}}

- **Startup and shutdown:**

   ```console
   # rc-update add nginx-unit # Enable Unit to launch automatically at system startup
   ```

   ```console
   # rc-service nginx-unit restart # Start or restart Unit; one-time action
   ```

   ```console
   # rc-service nginx-unit stop # Stop a running Unit; one-time action
   ```

   ```console
   # rc-update del nginx-unit # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="NetBSD" %}}

To install Unit's core package and the other packages you need
from the [NetBSD Packages Collection](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/www/unit/index.html):

```console
# pkg_add unit
```

```console
# pkg_add libunit # Required to install the Node.js module
```

```console
# pkg_add unit-perl  \
            unit-python2.7  \
            unit-python3.8 unit-python3.9 unit-python3.10 unit-python3.11 unit-python3.12  \
            unit-ruby31 unit-ruby32 unit-ruby33
```

```console
# service unit restart  # Necessary for Unit to pick up any changes in language module setup
```

To build Unit manually, start by updating the package collection:

```console
# cd /usr/pkgsrc && cvs update -dP
```

Next, browse to the package path to build and install the core Unit binaries:

```console
# cd /usr/pkgsrc/www/unit/
```

```console
# make build install
```

Repeat the steps for the other packages you need:
[libunit](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/devel/libunit/index.html)
(required to install the Node.js
[module]({{< relref "/unit/installation.md#installation-nodejs-package" >}}) and build
[Go apps]({{< relref "/unit/configuration.md#configuration-go" >}}),
[unit-perl](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/www/unit-perl/index.html),
[unit-php](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/www/unit-php/index.html),
[unit-python](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/www/unit-python/index.html),
or
[unit-ruby](https://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/www/unit-ruby/index.html).

Note that **unit-php** packages require the PHP package to be built with the **php-embed** option. To enable the option for **lang/php82**:

```console
# echo "PKG_OPTIONS.php82=php-embed" >> /etc/mk.conf
```

After that, restart Unit:

```console
# service unit restart  # Necessary for Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})        | **/var/run/unit/control.unit.sock**           |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit/unit.log**                    |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                      |

{{</bootstrap-table>}}


- **Startup and shutdown:**

First, add Unit's startup script to the **/etc/rc.d/** directory:

   ```console
   # cp /usr/pkg/share/examples/rc.d/unit /etc/rc.d/
   ```

   After that, you can start and stop Unit as follows:

   ```console
   # service unit restart # Start or restart Unit; one-time action
   ```

   ```console
   # service unit stop # Stop a running Unit; one-time action
   ```

To enable or disable Unit's automatic startup, edit **/etc/rc.conf**:

```ini
# Enable service:
unit=YES

# Disable service:
unit=NO
```

{{%/tab%}}
{{%tab name="Nix" %}}

To install Unit's core executables and all language modules using the
[Nix](https://nixos.org) package manager, update the channel, check if Unit's
available, and install the [package](https://github.com/NixOS/nixpkgs/tree/master/pkgs/servers/http/unit)

```console
$ nix-channel --update
$ nix-env -qa 'unit'
$ nix-env -i unit
```

This installs most embedded language modules and such features as SSL or IPv6 support.
For a full list of optionals, see the
[package definition]https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/http/unit/default.nix);
for a **.nix** configuration file defining an app, see
[this sample](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/web-servers/unit-php.nix).

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/run/unit/control.unit.sock**               |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit/unit.log**                    |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                      |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   Add **services.unit.enable = true;** to **/etc/nixos/configuration.nix**
   and rebuild the system configuration:

   ```console
   # nixos-rebuild switch
   ```

   After that, use `systemctl`:

   ```console
   # systemctl enable unit # Enable Unit to launch automatically at system startup
   ```

   ```console
   # systemctl restart unit # Start or restart Unit; one-time action
   ```

   ```console
   # systemctl stop unit # Stop a running Unit; one-time action
   ```

   ```console
   # systemctl disable unit # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="OpenBSD" %}}

To install Unit from [OpenBSD packages](https://www.openbsd.org/faq/faq15.html)
get the core package and other packages you need:

```console
# pkg_add unit
```

```console
# pkg_add unit-perl
```

```console
# pkg_add unit-php74
```

```console
# pkg_add unit-php80
```

```console
# pkg_add unit-php81
```

```console
# pkg_add unit-php82
```

```console
# pkg_add unit-php83
```

```console
# pkg_add unit-python
```

```console
# pkg_add unit-ruby
```

```console
# rcctl restart unit  # Necessary for Unit to pick up any changes in language module setup
```

To install Unit from [OpenBSD ports](https://pkgsrc.se/www/unit),
start by updating your port collection, for example:

```console
$ cd /usr/
```

```console
$ cvs -d anoncvs@anoncvs.spacehopper.org:/cvs checkout -P ports
```

Next, browse to the port path to build and install Unit:

```console
$ cd /usr/ports/www/unit/
```

```console
$ make
```

```console
# make install
```

This also installs the language modules for Perl, PHP, Python, and Ruby;
other modules can be built and installed from
[source]({{< relref "/unit/howto/source.md" >}}).

After that, restart Unit:

```console
# rcctl restart unit  # Necessary for Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                          | Description                                   |
|-----------------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}})       | **/var/run/unit/control.unit.sock**           |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})        | **/var/log/unit/unit.log**                    |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **_unit**                                     |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   ```console
   # rcctl enable unit # Enable Unit to launch automatically at system startup
   ```

   ```console
   # rcctl restart unit # Start or restart Unit; one-time action
   ```

   ```console
   # rcctl stop unit # Stop a running Unit; one-time action
   ```

   ```console
   # rcctl disable unit # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{%tab name="Remi's RPM" %}}

[Remi's RPM repository](https://blog.remirepo.net/post/2019/01/14/PHP-with-the-NGINX-unit-application-server>),
which hosts the latest versions of the PHP stack for Fedora and RHEL,
also has the core Unit package and the PHP modules.

To use Remi's versions of Unit's packages, configure the
[repository](https://blog.remirepo.net/pages/Config-en)
first.
Remi's PHP language modules are also compatible with the core Unit package from
[our own repository]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Next, install Unit and the PHP modules you want:

```console
# yum install --enablerepo=remi unit  \
      php54-unit-php php55-unit-php php56-unit-php  \
      php70-unit-php php71-unit-php php72-unit-php php73-unit-php php74-unit-php  \
      php80-unit-php php81-unit-php php82-unit-php
```

```console
# systemctl restart unit  # Necessary for Unit to pick up any changes in language module setup
```

{{<bootstrap-table "table table-striped table-bordered">}}

| Runtime details                                | Description                                   |
|-------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/source.md#source-startup" >}}) | **/run/unit/control.sock**                   |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}}) | **/var/log/unit/unit.log** |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **nobody** |

{{</bootstrap-table>}}


- **Startup and shutdown:**

   ```console
   # systemctl enable unit # Enable Unit to launch automatically at system startup
   ```

   ```console
   # systemctl restart unit # Start or restart Unit; one-time action
   ```

   ```console
   # systemctl stop unit # Stop a running Unit; one-time action
   ```

   ```console
   # systemctl disable unit # Disable Unit's automatic startup
   ```

{{%/tab%}}
{{</tabs>}}

---

## Docker Images {#installation-docker}

Unit's Docker images
come in several language-specific flavors:

{{<bootstrap-table "table table-striped table-bordered">}}

| Tag                                  | Description                                                                                      |
|--------------------------------------|--------------------------------------------------------------------------------------------------|
| `{{< param "unitversion" >}}-minimal` | No language modules; based on the **debian:bullseye-slim** [image](https://hub.docker.com/_/debian). |
| `{{< param "unitversion" >}}-go1.21`  | Single-language; based on the **golang:1.21** [image](https://hub.docker.com/_/golang).             |
| `{{< param "unitversion" >}}-jsc11`   | Single-language; based on the **eclipse-temurin:11-jdk** [image](https://hub.docker.com/_/eclipse-temurin). |
| `{{< param "unitversion" >}}-node20`  | Single-language; based on the **node:20** [image](https://hub.docker.com/_/node).                   |
| `{{< param "unitversion" >}}-perl5.38`| Single-language; based on the **perl:5.38** [image](https://hub.docker.com/_/perl).                 |
| `{{< param "unitversion" >}}-php8.2`  | Single-language; based on the **php:8.2-cli** [image](https://hub.docker.com/_/php).                |
| `{{< param "unitversion" >}}-python3.11` | Single-language; based on the **python:3.11** [image](https://hub.docker.com/_/python).           |
| `{{< param "unitversion" >}}-ruby3.2` | Single-language; based on the **ruby:3.2** [image](https://hub.docker.com/_/ruby).                 |
| `{{< param "unitversion" >}}-wasm`    | Single-language; based on the **debian:bullseye-slim** [image](https://hub.docker.com/_/debian).    |

{{</bootstrap-table>}}


### Customizing language versions in Docker images {#inst-lang-docker}

<details>
<summary>Customizing language versions in Docker images</summary>

To build a custom language version image, clone and rebuild the sources locally
with Docker installed:

```console
$ make build-<language name><language version> VERSIONS_<language name>=<language version>
```

The `make` utility parses the command line to extract the language name and version;
these values must reference an existing official language image to be used as the base
for the build.
If not sure whether an official image exists for a specific language version,
follow the links in the tag table above.

{{< note >}}
Unit relies on the official Docker images, so any customization method offered by their
maintainers is equally applicable; to tailor a Unit image to your needs,
see the quick reference for its base image.
{{< /note >}}

The language name can be **go**, **jsc**, **node**, **perl**, **php**,
**python**, or **ruby**; the version is defined as **\<major\>.\<minor\>**,
except for **jsc** and **node** that take only major version numbers (as seen in
the tag table).

Thus, to create an image with Python 3.10
and tag it as **unit:{{< param "unitversion" >}}-python3.10**:

```console
$ git clone https://github.com/nginx/unit
```

```console
$ cd unit
```

```console
$ git checkout {{< param "unitversion" >}}  # Optional; use to choose a specific Unit version
```

```console
$ cd pkg/docker/
```

```console
$ make build-python3.10 VERSIONS_python=3.10 # Language and version
```

For details, see the [Makefile](https://github.com/nginx/unit/blob/master/pkg/docker/Makefile).
For other customization scenarios, see the [Docker howto]({{< relref "/unit/howto/docker.md">}}).
</details>

<details>
<summary>Image tags for pre-1.29.1 Unit versions</summary>

Before Unit 1.29.1 was released, our Docker images were available
from the official [NGINX repository](https://hub.docker.com/r/nginx/unit/)
on Docker Hub.

</details>

<details>
<summary>Images with pre-1.22.0 Unit versions</summary>

Before Unit 1.22.0 was released, the following tagging scheme was used:

{{<bootstrap-table "table table-striped table-bordered">}}

| Tag                  | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| **\<version\>-full**   | Contains modules for all languages that Unit then supported.               |
| **\<version\>-minimal**| No language modules were included.                                         |
| **\<version\>-\<language\>** | A specific language module such as **1.21.0-ruby2.3** or **1.21.0-python2.7**. |

{{</bootstrap-table>}}


</details>

You can obtain the images from these sources:

{{< tabs name="Docker" >}}
{{% tab name="Docker Hub" %}}


To install and run Unit from [official builds](https://hub.docker.com/_/unit)
at Docker Hub:

```console
$ docker pull unit:TAG # Specific image tag; see above for a complete list
```

```console
$ docker run -d unit:TAG # Specific image tag; see above for a complete list
```

{{%/tab%}}
{{% tab name="Amazon ECR Public Gallery" %}}

To install and run Unit from NGINX's [repository](https://gallery.ecr.aws/nginx/unit)
at Amazon ECR Public Gallery:

```console
$ docker pull public.ecr.aws/nginx/unit:TAG # Specific image tag; see above for a complete list
```

```console
$ docker run -d public.ecr.aws/nginx/unit:TAG # Specific image tag; see above for a complete list
```

{{%/tab%}}
{{% tab name="packages.nginx.org" %}}

{{< warning >}}
Unit's 1.30+ image tarballs aren't published on the website; this channel is deprecated.
{{< /warning >}}

To install and run Unit from the tarballs stored on our
[website](https://packages.nginx.org/unit/docker/):

```console
$ curl -O https://packages.nginx.org/unit/docker/1.29.1/nginx-unit-TAG.tar.gz # Specific image tag; see above for a complete list
```

```console
$ curl -O https://packages.nginx.org/unit/docker/1.29.1/nginx-unit-TAG.tar.gz.sha512 # Specific image tag; see above for a complete list
```

```console
$ sha512sum -c nginx-unit-TAG.tar.gz.sha512 # Specific image tag; see above for a complete list
      nginx-unit-TAG.tar.gz: OK # Specific image tag; see above for a complete list
```

```console
$ docker load < nginx-unit-TAG.tar.gz # Specific image tag; see above for a complete list
```

{{%/tab%}}
{{</tabs>}}

---

{{<bootstrap-table "table table-striped table-bordered">}}
| Runtime details                                | Description                                   |
|-------------------------------------|-----------------------------------------------|
| Control [socket]({{< relref "/unit/howto/security.md#sec-socket" >}})       | **/var/run/control.unit.sock**                                           |
| Log [file]({{< relref "/unit/troubleshooting.md#troubleshooting-log" >}})   | Forwarded to the [Docker log collector](https://docs.docker.com/config/containers/logging/) |
| Non-privileged [user and group]({{< relref "/unit/howto/security.md#security-apps" >}}) | **unit**                                                                |

{{</bootstrap-table>}}


For more details, see the repository pages ([Docker Hub](https://hub.docker.com/_/unit),
[Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/unit))
and our [Docker howto]({{< relref "/unit/howto/docker.md">}}).

### Initial configuration {#installation-docker-init}

The official images support initial container configuration,
implemented with an **ENTRYPOINT**
[script](https://docs.docker.com/engine/reference/builder/#entrypoint).
First, the script checks the Unit
[state directory]({{< relref "/unit/howto/source.md#source-config-src-state" >}})
in the container
(**/var/lib/unit/**).

If it's empty,
the script processes certain file types
in the container's **/docker-entrypoint.d/** directory:

{{<bootstrap-table "table table-striped table-bordered">}}

| File Type  | Purpose/Action                                                                                                                                                                                                                                    |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **.pem**   | [Certificate bundles]({{< relref "/unit/certificates.md">}}), uploaded under respective names:<br><br>**cert.pem** to **/certificates/cert**.                                                                                                   |
| **.json**  | [Configuration snippets]({{< relref "/unit/controlapi.md#configuration-mgmt" >}}), uploaded to the **/config** section of Unit's configuration.                                                                                                 |
| **.sh**    | Shell scripts, run after the **.pem** and **.json** files are uploaded. Use shebang in your scripts to specify a custom shell;<br><br>must be executable.                                                                                     |

{{</bootstrap-table>}}


The script warns about any other file types in **/docker-entrypoint.d/**.

This mechanism enables customizing your containers at startup,
reusing configurations, and automating workflows to reduce manual effort.
To use the feature, add **COPY** directives for certificate bundles,
configuration fragments, and shell scripts to your **Dockerfile** derived from
an official image:

```dockerfile
FROM unit:{{< param "unitversion" >}}-minimal
COPY ./*.pem  /docker-entrypoint.d/
COPY ./*.json /docker-entrypoint.d/
COPY ./*.sh   /docker-entrypoint.d/
```

{{< note >}}
Mind that running Unit even once populates its state directory;
this prevents the script from executing, so this script-based initialization must occur
before you run Unit in your derived container.
{{< /note >}}

This feature comes in handy if you want to tie Unit to a certain app configuration
for later use. For ad-hoc initialization, you can mount a directory with configuration files to a container at startup:

```console
$ docker run -d --mount \
      type=bind,src=/path/to/config/files/,dst=/docker-entrypoint.d/ \ # Use a real path instead
      unit:{{< param "unitversion" >}}-minimal
```

## Source Code {#source}

You can get Unit's source code from our official GitHub repository or as a tarball.

{{< tabs name="Source Code" >}}
{{% tab name="Git" %}}

```console
$ git clone https://github.com/nginx/unit            # Latest updates to the repository
```

```console
$ # -- or --
```

```console
$ git clone -b {{< param "unitversion" >}} https://github.com/nginx/unit  # Specific version tag; see https://github.com/nginx/unit/tags
```

```console
$ cd unit
```

{{%/tab%}}
{{% tab name="Tarball" %}}

```console
$ curl -O https://sources.nginx.org/unit/unit-{{< param "unitversion" >}}.tar.gz
```

```console
$ tar xzf unit-{{< param "unitversion" >}}.tar.gz
```

```console
$ cd unit-{{< param "unitversion" >}}
```

{{%/tab%}}
{{</tabs>}}

---

To build Unit and specific language modules from these sources,
refer to the [source code howto]({{< relref "/unit/howto/source.md" >}}).
to package custom modules, see the
[module howto]({{< relref "/unit/howto/modules.md#modules-pkg" >}}).
