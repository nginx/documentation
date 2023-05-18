Before installing NGINX Controller, ensure you have the following prerequisites:

- Your NGINX Controller trial Association Token. You can find this in the [MyF5 Customer Portal](https://account.f5.com/myf5).

- Required Linux utilities:
  These utilities are required by the installation script. The script will prompt you to install any missing utilities.

  - `awk`
  - `bash` (4.0 or later)
  - `conntrack`
  - `coreutils`: `base64`, `basename`, `cat`, `comm`, `dirname`, `head`, `id`, `mkdir`, `numfmt`, `sort`, `tee`
  - `curl` or `wget`
  - `ebtables`
  - `envsubst` (provided by the `gettext` package)
  - `ethtool`
  - `getent`
  - `grep`
  - `gunzip` (provided by the `gzip` package)
  - `iproute`
  - `iptables`
  - `jq` (1.5 or later)
  - `less`
  - `openssl`
  - `sed`
  - `socat`
  - `tar`
  - `util-linux`
  - `yum-plugin-versionlock` on RedHat/CentOS

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-333 -->