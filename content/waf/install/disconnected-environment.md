---
# We use sentence case and present imperative tone
title: "Disconnected or air-gapped environments"
# Weights are assigned in increments of 100: determines sorting order
weight: 400
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is as a standalone page for the operating system specific installation use cases:

- [v4]({{< ref "/nap-waf/v4/admin-guide/install.md#offline-installation" >}})
- [v5]({{< ref "/nap-waf/v5/admin-guide/install.md#air-gap-install-secure-offline-installation" >}})

{{</ call-out>}}

This topic describes how to install F5 WAF for NGINX in a disconnected or air-gapped environment.

Many of the steps involved are similar to other installation methods: this document will refer to them when appropriate.

## Before you begin

To complete this guide, you will need the following prerequisites:

- The requirements of your installation method:
    - [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md#before-you-begin" >}})
    - [Docker]({{< ref "/waf/install/docker.md#before-you-begin" >}})
    - [Kubernetes]({{< ref "/waf/install/kubernetes.md#before-you-begin" >}})
- An active F5 WAF for NGINX subscription (Purchased or trial).
- A connected environment with similar architecture
- A method to transfer files between two environments

These instructions outline the broad, conceptual steps involved with working with a disconnected environment. You will need to make adjustments based on your specific security requirements.

Some users may be able to use a USB stick to transfer necessary set-up artefacts, whereas other users may be able to use tools such as SSH or SCP.

In the following sections, the term _connected environment_ refers to the environment with access to the internet you will use to download set-up artefacts.

The term _disconnected environment_ refers to the final environment the F5 WAF for NGINX installation is intended to run in, and is the target to transfer set-up artefacts from the connected environment.

## Download and run the documentation website locally

For a disconnected environment, you may want to browse documentation offline.

This is possible by cloning the repository and the binary file for Hugo.

In addition to accessing F5 WAF for NGINX documentation, you will be able to access any supporting documentation you may need from other products.

You will need `git` and `wget` in your connected environment.

Run the following two commands: replace `<hugo-release>` with the tarball appropriate to the environment from [the release page](https://github.com/gohugoio/hugo/releases/tag/v0.147.8):

```shell
git clone git@github.com:nginx/documentation.git
wget <hugo-release>
```

Move the repository folder and the tarball to your disconnected environment.

In your disconnected environment, extract the tarball archive, then move the `hugo` binary somewhere on your PATH.

Change into the cloned repository and run Hugo: you should be able to access the documentation on localhost.

```shell
cd documentation
hugo server
```

## Download package files


## Download Docker images


## Download Kubernetes files


