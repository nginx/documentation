---
title: NGINX Service Mesh API
description: Instructions for interacting with the F5 NGINX Service Mesh API.
toc: true
weight: 200
nd-docs: DOCS-702
type:
- reference
---

## Overview

The F5 NGINX Service Mesh API exists within a Kubernetes Custom Resource, and can be used to manage the global mesh configuration. This resource is created when the mesh is deployed, and can be updated at runtime using the Kubernetes API.

## Modifying the global mesh configuration

To update the global mesh configuration, use `kubectl` to edit the `meshconfig` resource that lives in the NGINX Service Mesh namespace. By default, the name of the resource is `nginx-mesh-config`.

```bash
kubectl edit meshconfig nginx-mesh-config -n nginx-mesh
```

This will open your default text editor to make changes. To see the configurable fields, download the custom resource definition:

{{< icon "download" >}} [`meshconfig-schema.yaml`](https://github.com/nginxinc/nginx-service-mesh/blob/main/helm-chart/crds/meshconfig.yaml)

{{< call-out "warning" >}}
If the `meshconfig` resource is deleted, or the `spec.meshConfigClassName` field is removed or changed, then the global mesh configuration cannot be updated, and unexpected behavior may occur.
{{< /call-out >}}

## Viewing the global mesh configuration

The `meshconfig` custom resource only contains configuration fields that can be changed at runtime. To view the full state of the mesh configuration, including fields that were set at installation, you can use the `nginx-meshctl` command line tool.

- View the full configuration of the mesh:

```bash
nginx-meshctl config
```

- View the services participating in the mesh:

```bash
nginx-meshctl services
```

## Programmatic Access

For programmatic access, we recommend using a [Kubernetes client SDK](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#programmatic-access-to-the-api).
