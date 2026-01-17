---
nd-docs: DOCS-331
title: Install the WAF compiler
description: Install the WAF compiler on the NGINX Instance Manager host to precompile security configurations for F5 WAF for NGINX.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
---

The WAF compiler lets NGINX Instance Manager precompile security configurations before deploying them to F5 WAF for NGINX instances.  
Precompiling configurations improves performance and reduces the risk of runtime errors.

Install the WAF compiler on the NGINX Instance Manager host only if you plan to compile configurations on the management plane.  
If you compile on the data plane, you can skip this step.

Each version of F5 WAF for NGINX has a corresponding WAF compiler version.  
If you manage multiple versions, install the matching compiler for each one on the NGINX Instance Manager host.

The WAF compiler installs to the `/opt` directory.  
Make sure this directory has the correct permissions so the owner can write to it. A typical permission setting of `0755` is sufficient.

To organize instances running the same version, you can create [instance groups]({{< ref "/nim/nginx-instances/manage-instance-groups" >}}).

For an overview of how the compiler works, see [Security bundle compilation]({{< ref "/nim/waf-integration/overview#security-bundle" >}}).

## Before you begin

{{< include "/nim/waf/nim-waf-before-you-begin.md" >}}

## WAF compiler version support

Use the table below to find the correct WAF compiler version for each release of F5 WAF for NGINX:

{{< include "/waf/waf-nim-compiler-support.md" >}}

{{< call-out "note" >}}
Beginning with version 5.9.0, both the virtual machine and container installation packages are categorized under the 5.x.x tag.  
Earlier releases used 4.x.x for VM packages (for example, NAP 4.15.0, NAP 4.16.0) and 5.x.x for container packages (for example, NAP 5.7.0, NAP 5.8.0).
{{< /call-out >}}

## Install the WAF compiler

{{< tabs name="install-waf-compiler" >}}

{{% tab name="Debian or Ubuntu" %}}

1. Install the WAF compiler:

   ```shell
   sudo apt-get install nms-nap-compiler-v5.550.0
   ```

1. To install multiple compiler versions on the same system, append the `--force-overwrite` option after the first installation:

   ```shell
   sudo apt-get install nms-nap-compiler-v5.550.0 -o Dpkg::Options::="--force-overwrite"
   ```

1. {{< include "nim/waf/restart-nms-integrations.md" >}}

{{% /tab %}}

{{% tab name="RHEL 8.1" %}}

1. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
   ```

1. Enable the CodeReady Builder repository:

   ```shell
   sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
   ```

1. Install the WAF compiler:

   ```shell
   sudo yum install nms-nap-compiler-v5.550.0
   ```

1. {{< include "nim/waf/restart-nms-integrations.md" >}}

{{% /tab %}}

{{% tab name="RHEL 9" %}}

1. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
   ```

1. Enable the CodeReady Builder repository:

   ```shell
   sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
   ```

1. Install the WAF compiler:

   ```shell
   sudo yum install nms-nap-compiler-v5.550.0
   ```

1. {{< include "nim/waf/restart-nms-integrations.md" >}}

{{% /tab %}}

{{% tab name="Oracle Linux 8.1" %}}

1. Download the `dependencies.repo` file to `/etc/yum.repos.d`:

   ```shell
   sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/dependencies.repo
   ```

1. Enable the `ol8_codeready_builder` repository:

   ```shell
   sudo yum-config-manager --enable ol8_codeready_builder
   ```

1. Install the WAF compiler:

   ```shell
   sudo yum install nms-nap-compiler-v5.550.0
   ```

1. {{< include "nim/waf/restart-nms-integrations.md" >}}

{{% /tab %}}

{{< /tabs >}}
