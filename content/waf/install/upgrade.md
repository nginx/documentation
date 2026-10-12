---
title: "Upgrade F5 WAF for NGINX"
weight: 700
toc: false
f5-content-type: how-to
f5-product: F5 WAF for NGINX
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
sudo apt-get update && sudo apt-get install -y app-protect
```

## Docker deployments

You can upgrade packages within Docker containers the same way as in the [Virtual environment packages](#virtual-environment-packages) section.

Otherwise, you can update the version of F5 WAF components you are using by changing the tag prefixed to the `image:` key in your _docker-compose_ files.

### Update Docker deployments to 5.16.0

Starting with release 5.16.0, the `waf-enforcer` and `waf-config-mgr` images run as user ID (UID) `100` instead of `101`. The group ID (GID) is still `101`. If you update from a release earlier than 5.16.0, change the owner of the shared host directories first. Do this before you start the new containers.

1. Stop the F5 WAF for NGINX services:

    ```shell
    sudo docker compose down
    ```

1. Set the owner and group permissions of the shared directories:

    ```shell
    sudo chown -R 100:101 /opt/app_protect/bd_config /opt/app_protect/config
    sudo chmod -R g+rwX /opt/app_protect/
    ```

1. In your _docker-compose.yml_ file, change the `waf-enforcer` and `waf-config-mgr` image tags to `5.16.0`.

1. Pull the new images:

    ```shell
    docker pull private-registry.nginx.com/nap/waf-enforcer:5.16.0
    docker pull private-registry.nginx.com/nap/waf-config-mgr:5.16.0
    ```

1. Start the services:

    ```shell
    sudo docker compose up -d
    ```

If you skip the ownership change, the update fails:

- `waf-config-mgr` logs `chtimes ...: operation not permitted` or `config_set_cache.yaml: permission denied`.
- `waf-enforcer` restarts continuously.
- NGINX fails to start or reload.

To fix the problem, run the commands in step 2, then restart the services.

## Kubernetes deployments

In a Kubernetes deployment, your approach for upgrading F5 WAF for NGINX depends on your installation method.

For Helm, first `pull` the chart:

```shell
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <RELEASE_VERSION> --untar
```

Replace `<RELEASE_VERSION>` with the Helm chart release version.

Then use the `upgrade` argument with the release name.

```shell
helm upgrade <RELEASE_NAME> .
```

Replace `<RELEASE_NAME>` with the name of your Helm release.

For Manifests you can update the tagged `image:` in your [created Manifest files]({{< ref "/waf/install/kubernetes.md#create-manifest-files" >}}).

Then you can use `apply` to upgrade:

```shell
kubectl apply -f manifests/
```