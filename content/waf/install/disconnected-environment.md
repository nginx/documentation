---
# We use sentence case and present imperative tone
title: "Disconnected or air-gapped environments"
# Weights are assigned in increments of 100: determines sorting order
weight: 500
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

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

{{< call-out "note" >}}

This section is most relevant for a [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md" >}}) installation.

{{< /call-out >}}

When working with package files, you can install the packages directly in your disconnected environment, or add them to an internal repository.

The first step is to download the package files from your connected environment.

This will vary based on your operating system choice, which determines your package manager.

For example, a `yum` based system will require a special plugin:

```shell
# Install the download plugin
yum -y install yum-plugin-downloadonly
# Create a directory for packages
mkdir -p /etc/packages/
# Use yum to download the packages into the directory
yum install --downloadonly --downloaddir=/etc/packages/ app-protect
```

Once you've obtained the package files and transferred them to your disconnected environment, you can directly install them or add them to a local repository.

## Download Docker images

After pulling or building Docker images in a connected environment, you can save them to `.tar` files:

```shell
docker save -o waf-enforcer.tar waf-enforcer:5.2.0
docker save -o waf-config-mgr.tar waf-config-mgr:5.2.0
# Optional, if using IP intelligence
docker save -o waf-ip-intelligence.tar waf-ip-intelligence:5.2.0
```

You can then transfer the files and load the images in your disconnected environment:

```shell
docker load -i waf-enforcer.tar
docker load -i waf-config-mgr.tar
# Optional, if using IP intelligence
docker load -i waf-ip-intelligence.tar
```

Ensure your Docker compose files use the tagged images you've transferred.

