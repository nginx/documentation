---
# We use sentence case and present imperative tone
title: "Uninstall F5 WAF for NGINX"
# Weights are assigned in increments of 100: determines sorting order
weight: 800
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes how to uninstall F5 WAF for NGINX.

The steps vary based on your installation style: ensure that you remove any F5 WAF configuration changes from your NGINX configuration files if you intend to continue using NGINX without F5 WAF.

## Virtual environment packages

Depending on your installation method, you may have installed virtual environment packages as part of a virtual machine/bare metal installation or a hybrid Docker configuration deployment.

Using the environment's package manager, identify and uninstall the package. It will be named something in the following list:

- `app-protect`
- `app-protect-module-oss`
- `app-protect-module-plus`

If you used the [IP intelligence feature]({{< ref "/waf/policies/ip-intelligence.md" >}}), its package should also be removed first, and is named `app-protect-ip-intelligence`.

Once the packages have been removed, you may also wish to remove the F5 WAF for NGINX repositories you added to the environment during installation.

## Docker deployments

In an installation method involving Docker, navigate to the directory that contains the _docker-compose.yml_ file and run:

```shell
sudo docker compose stop
```

For a single container configuration, use this command instead:

```shell
sudo docker container stop <your-container-name>
```

## Kubernetes deployments

In an installation method involving Kubernetes, you'll need to remove the resources created for F5 WAF for NGINX.

For Helm, run the following command:

```shell
helm uninstall <release-name>
```

For Manifests, locate the folder with your Manifest files:

```shell
kubectl delete -f manifests/
```

