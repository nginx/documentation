---
# We use sentence case and present imperative tone
title: "Upgrade F5 WAF for NGINX"
# Weights are assigned in increments of 100: determines sorting order
weight: 700
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes how to upgrade F5 WAF for NGINX.

Security updates can be managed independently from F5 WAF for NGINX versions: based on your installation method, you should read the [Update F5 WAF for NGINX signatures]({{< ref "/waf/install/update-signatures.md" >}}) or [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}}) topics.

## Virtual environment packages

Depending on your method, you may have installed virtual environment packages as part of a virtual machine/bare metal installation or a hybrid Docker configuration deployment.

You can update the F5 WAF for NGINX packages using the environment's package manager, used during the [Platform-specific instructions]({{< ref "/waf/install/virtual-environment.md#platform-specific-instructions" >}}) of installation.

An operating system using `dnf` might update the package with this command:

```shell
sudo dnf -y update app-protect
```

While an `apt` based system would use the following instead:

```shell
sudo apt-get update && apt-get install -y app-protect
```

## Docker deployments

You can upgrade packages within Docker containers the same way as in the [Virtual environment packages](#virtual-environment-packages) section.

Otherwise, you can update the version of F5 WAF components you are using by changing the tag prefixed to the `image:` key in your _docker-compose_ files.

## Kubernetes deployments

In a Kubernetes deployment, your approach for upgrading F5 WAF for NGINX depends on your installation method.

For Helm, first `pull` the chart:

```shell
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-name> --untar
```

Then use the `upgrade` argument with the release name.

```shell
helm upgrade <release-name> .
```

For Manifests you can update the tagged `image:` in your [created Manifest files]({{< ref "/waf/install/kubernetes.md#create-manifest-files" >}}).

Then you can use `apply` to upgrade:

```shell
kubectl apply -f manifests/
```