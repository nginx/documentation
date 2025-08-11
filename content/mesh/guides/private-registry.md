---
title: Private Registry
description: How to set up access to a private registry
weight: 70
toc: true
nd-docs: DOCS-694
type:
- how-to
---

## Overview

F5 NGINX Service Mesh supports using a private registry to store its components. In order to deploy NGINX Service Mesh from a private registry, you need to configure the NGINX Service Mesh CLI with credentials that can access the registry.

## CLI Flags

You can use the following NGINX Service Mesh CLI flags to configure private registry access.

{{% table %}}
| Flag                  | Description |
|-----------------------|-------------|
| `--registry-server`   | The host name and port (if needed) of the private registry, for example, "gcr.io". Can also contain the path, though only the domain is used for authentication. Pull requests for images to this registry will authenticate using the provided credentials. |
| `--registry-username` | The username to access the private registry. Must be used with `--registry-password`. Cannot be used with `--registry-key`. |
| `--registry-password` | The password to access the private registry.  Must be used with `--registry-username`. Cannot be used with `--registry-key`. |
| `--registry-key`      | The path on disk to a JSON key file that allows access to a GKE registry. Cannot be used with `--registry-username` or `--registry-password`. |
{{% /table %}}

There are two methods of accessing a private registry:

- Registry username and password can be specified with `--registry-username` and `--registry-password`.
- For a GKE registry, you can specify the path to the JSON key using `--registry-key`. The path can be relative to the working directory or absolute.

{{< call-out "warning" >}}
Using the `--registry-password` flag can expose your plain text password on the console and in the console history.
{{< /call-out >}}

## Images

See this [list]( {{< ref "/mesh/about/mesh-tech-specs.md#images" >}} ) for the images you need to copy to your private registry. The image names and tags must remain the same.

 `gcr.io/spiffe-io/spire-agent:1.5.6` would become `your-registry/spire-agent:1.5.6`

 `nats:2.9-alpine` would become `your-registry/nats:2.9-alpine`

When running `nginx-meshctl deploy`, use the `--disable-public-images` flag to instruct the mesh to use your `--registry-server` for all images.

```bash
nginx-meshctl deploy --registry-server your-registry --disable-public-images ...
```

## Examples

Deploying from a private registry using a username and password:

```bash
nginx-meshctl deploy ... --registry-server <your-docker-registry> --registry-username <your-username> --registry-password <your-password>
```

Deploy from a GKE registry using a JSON Key:

```bash
nginx-meshctl deploy ... --registry-server <your-gke-docker-registry> --registry-key </path/to/key.json>
```

## How it Works

When deploying with the private registry flags, `nginx-meshctl` will create a Kubernetes Secret (example below) that encapsulates the secret data:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: nginx-mesh-registry-key
    namespace: nginx-mesh
    labels:
        usage: nginx-mesh-registry-key
data:
    .dockerconfigjson: <base64-encoded-config>
type: kubernetes.io/dockerconfigjson
```

The <base64-encoded-key> is a base64 encoded JSON that encapsulates the secret data with a header. When using the `--registry-username` and `--regsitry-password` option, that section looks like:

```json
{
    "auths": {
        "<your-docker-registry as specified with --registry-server>": {
            "username": "<your-username>",
            "password": "<your-password>",
            "auth": "<base64 encoded string of your username and password>"
        }
    }
}
```

NGINX Service Mesh creates the Kubernetes Secret in its namespace. Kubernetes Secrets aren't cluster-wide, so when injecting a pod with a sidecar, NGINX Service Mesh duplicates the Kubernetes Secret into the namespace of that pod.

NGINX Service Mesh will additionally inject the below yaml snippet into Pods injected with a sidecar. This allows the Pod to use the Kubernetes Secret to pull the NGINX Service Mesh sidecar container:

```yaml
imagePullSecrets:
- name: nginx-mesh-registry-key
```

When you remove NGINX Service Mesh, all of the Kubernetes Secrets that it created are deleted. It uses a [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) to get a list of all the Kubernetes Secrets with the label `usage=nginx-mesh-registry-key`. You can simulate this operation using kubectl:

```bash
kubectl get secrets -l usage=nginx-mesh-registry-key -A
```
