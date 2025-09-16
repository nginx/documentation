---
# We use sentence case and present imperative tone
title: "Kubernetes"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to encapsulate the Kubernetes deployment methods, currently split between the following two pages:

- [Deploy F5 WAF for NGINX with Helm]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md" >}})
- [Deploy F5 WAF for NGINX with Manifests]({{< ref "/nap-waf/v5/admin-guide/deploy-with-manifests.md" >}})

The steps are largely identical, so hyperlinks will be used to direct the reader to Helm or Manifest-specific steps.

This pattern is present in the [Virtual environment]({{< ref "/waf/install/virtual-environment.md" >}}) and [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) topics already, where users may skip a Docker step if they're using a container services deployment instead of a host services one.

{{</ call-out>}}


## Before you begin


## Download your subscription credentials 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

## Create a Dockerfile

In the same folder as your credential and configuration files, create a _Dockerfile_ based on your desired operating system image using an example below:

{{< call-out "note" >}}

If you are not using using `custom_log_format.json` or the IP intelligence feature,  you should remove any references to them from your Dockerfile.

{{< /call-out >}}

### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/alpine-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/alpine-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/amazon-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/amazon-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/debian-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/debian-oss.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Oracle Linux

{{< tabs name="oracle-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/oracle-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/oracle-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel8-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel8-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rocky9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rocky9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/ubuntu-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/ubuntu-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}