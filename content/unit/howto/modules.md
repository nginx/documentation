---
title: Working with language modules
weight: 700
toc: true
---

Languages supported by Unit fall into these two categories:

- [External]({{< relref "/unit/howto/modules.md#modules-ext" >}})
  (Go, Node.js): Run outside Unit with an
  interface layer to the native runtime.
- [Embedded]({{< relref "/unit/howto/modules.md#modules-emb" >}})
  (Java, Perl, PHP, Python, Ruby, WebAssembly):
  Execute in runtimes that Unit loads at startup.

For any specific language and its version, Unit needs a language module.

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## External language modules {#modules-ext}

External modules are regular language libraries or packages that you install
like any other. They provide common web functionality, communicating with Unit
from the app's runspace.

In Go, Unit support is implemented with a package that you
[import]({{< relref "/unit/configuration.md#configuration-go" >}})
in your apps to make them Unit-aware.

In Node.js, Unit is supported by an `npm`-hosted [package](https://www.npmjs.com/package/unit-http) that you
[require]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
in your app code. You can
[install]({{< relref "/unit/installation.md#installation-nodejs-package" >}})
the package from the `npm` repository;
otherwise, [build]({{< relref "/unit/howto/source.md#modules-nodejs" >}})
it for your version of Node.js using Unit's sources.

For WebAssembly, Unit delegates bytecode execution to the
[Wasmtime](https://wasmtime.dev/) runtime that is installed with the
[language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
module or during a
[source build]({{< relref "/unit/howto/source.md#source-wasm" >}}).

## Embedded language modules {#modules-emb}

Embedded modules are shared libraries that Unit loads at startup. Query Unit
to find them in your system:

```console
$ unitd -h

         ...
      --log FILE           set log filename
                           default: /default/path/to/unit.log  # This is the default log path which can be overridden at runtime

      --modules DIRECTORY  set modules directory name
                           default: /default/modules/path/  # This is the default modules path which can be overridden at runtime

$ ps ax | grep unitd  # Check whether the defaults were overridden at launch
      ...
      unit: main v1.34.1 [unitd --log /runtime/path/to/unit.log --modules /runtime/modules/path/ ... ]  # If this option is set, its value is used at runtime

$ ls /path/to/modules  # Use runtime value if the default was overridden

      java.unit.so  php.unit.so     ruby.unit.so  wasm_wasi_component.unit.so
      perl.unit.so  python.unit.so  wasm.unit.so

```

To clarify the module versions, check the {ref}`Unit log <troubleshooting-log>`
to see which modules were loaded at startup:

```console
# less /path/to/unit.log  # Path to log can be determined in the same manner as above
      ...
      discovery started
      module: <language> <version> "/path/to/modules/<module name>.unit.so"
      ...
```

If a language version is not listed, Unit can't run apps that rely on it;
however, you can add new modules:

- If possible, use the official
  [language packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
  for easy integration and maintenance.
- If you installed Unit via a
  [third-party repo]({{< relref "/unit/installation.md#installation-community-repos" >}}),
  check whether a suitable language package is
  available there.
- If you want a customized yet reusable solution,
  [prepare]({{< relref "/unit/howto/modules.md#modules-pkg" >}})
  your own package to be installed beside Unit.

### Packaging Custom Modules {#modules-pkg}

There's always a chance that you need to run a language version that isn't yet
available among the official Unit
[pacakges]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).
but still want to benefit from the convenience of a packaged installation. In
this case, you can build your own package to be installed alongside the
official distribution, adding the latter as a prerequisite.

Here, we are packaging a custom PHP 7.3
[module]({{< relref "/unit/howto/source.md#source-modules" >}})
to be installed next to the official Unit package;
adjust the command samples as needed to fit your scenario.

{{< note >}}
For details of building Unit language modules, see the source code
[now-to]({{< relref "/unit/howto/source.md#source-modules" >}}); it also describes building
[Unit]({{< relref "/unit/howto/source.md" >}}) itself.
For more packaging examples, see our package
[sources](https://github.com/nginx/unit/tree/master/pkg).
{{< /note >}}


<a name="modules-deb"></a>
<a name="modules-rpm"></a>

{{< tabs name="packages">}}
{{% tab name=".deb" %}}

Assuming you are packaging for the current system and have the official
Unit package installed:

1. Make sure to install the
   [prerequisites]({{< relref "/unit/howto/source.md#source-prereq-build" >}})
   for the package. In our example, it's PHP 7.3 on Debian 10:

   ```console
   # apt update
   ```

   ```console
   # apt install ca-certificates apt-transport-https debian-archive-keyring # Needed to install the php7.3 package from the PHP repo
   ```

   ```console
   # curl --output /usr/share/keyrings/php-keyring.gpg  \
         https://packages.sury.org/php/apt.gpg # Adding the repo key to make it usable
   ```

   ```console
   # echo "deb [signed-by=/usr/share/keyrings/php-keyring.gpg]  \
         https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list
   ```

   ```console
   # apt update
   ```

   ```console
   # apt install php7.3
   ```

   ```console
   # apt install php-dev libphp-embed # Needed to build the module and the package
   ```

1. Create a staging directory for your package:

   ```console
   $ export UNITTMP=$(mktemp -d -p /tmp -t unit.XXXXXX)
   $ mkdir -p $UNITTMP/unit-php7.3/DEBIAN
   $ cd $UNITTMP
   ```

   This creates a folder structure fit for `dpkg-deb`; the
   **DEBIAN** folder will store the package definition.

1. Run `unitd --version` and note the `./configure`
   [flags]({{< relref "/unit/howto/source.md#source-config-src" >}})
      for later use, omitting `--ld-opt` and `--njs`:

   ```console
   $ unitd --version

      unit version: {{< param "unitversion" >}}
      configured as ./configure # Note the flags, omitting --ld-opt and --njs
   ```

1. Download Unit's sources,
   [configure]({{< relref "/unit/howto/source.md#source-modules" >}})
   and build your custom module, then put it where Unit will find it:

   ```console
   $ curl -O https://sources.nginx.org/unit/unit-{{< param "unitversion" >}}.tar.gz
   $ tar xzf unit-{{< param "unitversion" >}}.tar.gz                                 # Puts Unit's sources in the unit-{{< param "unitversion" >}} subdirectory
   $ cd unit-{{< param "unitversion" >}}
   $ ./configure FLAGS  # Use the ./configure flags noted in the previous step
   $ ./configure php --module=php7.3 --config=php-config        # Configures the module itself
   $ make php7.3                                                # Builds the module in the build/ subdirectory
   $ mkdir -p $UNITTMP/unit-php7.3/MODULESPATH  # Use the module path set by ./configure or by default
   $ mv build/php7.3.unit.so $UNITTMP/unit-php7.3/MODULESPATH   # Adds the module to the package
   ```

1. Create a **$UNITTMP/unit-php7.3/DEBIAN/control**
   [file](https://www.debian.org/doc/debian-policy/ch-controlfields.html),
   listing **unit** with other dependencies:

   ```control
   Package: unit-php7.3
   Version: {{< param "unitversion" >}}
   Comment0: Use Unit's package version for consistency: 'apt show unit | grep Version'
   Architecture: amd64
   Comment1: To get current architecture, run 'dpkg --print-architecture'
   Comment2: For a list of other options, run 'dpkg-architecture -L'
   Depends: unit (= {{< param "unitversion" >}}-1~buster), php7.3, libphp-embed
   Comment3: Specify Unit's package version to avoid issues when Unit updates
   Comment4: Again, run 'apt show unit | grep Version' to get this value
   Maintainer: Jane Doe <j.doe@example.com>
   Description: Custom PHP 7.3 language module for NGINX Unit {{< param "unitversion" >}}
   ```

   Save and close the file.

1. Build and install the package:

   ```console
   $ dpkg-deb -b $UNITTMP/unit-php7.3
   # dpkg -i $UNITTMP/unit-php7.3.deb
   ```

{{% /tab %}}
{{% tab name=".rpm" %}}

Assuming you are packaging for the current system and have the official
Unit package installed:

1. Make sure to install the
   [prerequisites]({{< relref "/unit/howto/source.md#source-prereq-build" >}})
   for the package.  In our example, it's PHP 7.3 on Fedora 30:

   ```console
   # yum install -y php-7.3.8
   ```

   ```console
   # yum install php-devel php-embedded
   ```

1. Install RPM development tools and prepare the directory structure:

   ```console
   # yum install -y rpmdevtools
   ```

   ```console
   $ rpmdev-setuptree
   ```

1. Create a **.spec** [file](https://rpm-packaging-guide.github.io/#what-is-a-spec-file)
   to store build commands for your custom package:

   ```console
   $ cd ~/rpmbuild/SPECS
   ```

   ```console
   $ rpmdev-newspec unit-php7.3
   ```

1. Run `unitd --version` and note the `./configure`
   [flags]({{< relref "/unit/howto/source.md#source-config-src" >}}) for later use, omitting
   `--ld-opt` and `--njs`:

   ```console
   $ unitd --version

         unit version: {{< param "unitversion" >}}
         configured as ./configure FLAGS  # Note the flags, omitting --ld-opt and --njs
   ```

1. Edit the **unit-php7.3.spec** file, adding the commands that
   download Unit's sources,
   [configure]({{< relref "/unit/howto/source.md#source-modules" >}})
   and build your custom module, then  put it where Unit will find it:

   ```spec
      Name:           unit-php7.3
   Version:        {{< param "unitversion" >}}
   # Use Unit's package version for consistency: 'yum info unit | grep Version'
   Release:        1%{?dist}
   Summary:        Custom language module for NGINX Unit

   License:        ASL 2.0
   # Unit uses ASL 2.0; your license depends on the language you are packaging
   URL:            https://example.com
   BuildRequires:  gcc
   BuildRequires:  make
   BuildRequires:  php-devel
   BuildRequires:  php-embedded
   Requires:       unit = {{< param "unitversion" >}}
   # Specify Unit's package version to avoid issues when Unit updates
   # Again, run 'yum info unit | grep Version' to get this value
   Requires:       php >= 7.3
   Requires:       php-embedded

   %description
   Custom language module for NGINX Unit {{< param "unitversion" >}} (https://unit.nginx.org).

   Maintainer: Jane Doe <j.doe@example.com>

   %prep
   curl -O https://sources.nginx.org/unit/unit-{{< param "unitversion" >}}.tar.gz
   # Downloads Unit's sources
   tar --strip-components=1 -xzf unit-{{< param "unitversion" >}}.tar.gz
   # Extracts them locally for compilation steps in the %build section

   %build
   ./configure FLAGS W/O --LD-OPT & --NJS  # The ./configure flags, except for --ld-opt and --njs
   ./configure php --module=php7.3 --config=php-config
   # Configures the module itself
   make php7.3
   # Builds the module

   %install
   DESTDIR=%{buildroot} make php7.3-install
   # Adds the module to the package

   %files
   %attr(0755, root, root) MODULESPATH/php7.3.unit.so
   # Lists the module as package contents to include it in the package build
   # Use the module path set by ./configure or by default

   ```

   Save and close the file.


1. Build and install the package:

   ```console
   $ rpmbuild -bb unit-php7.3.spec

         ...
         Wrote: /home/user/rpmbuild/RPMS/<arch>/unit-php7.3-<moduleversion>.<arch>.rpm
         ...
   ```

   ```console
   # yum install -y /home/user/rpmbuild/RPMS/<arch>/unit-php7.3-<moduleversion>.<arch>.rpm
   ```

{{% /tab %}}
{{< /tabs >}}
