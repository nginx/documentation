---
title: Deploy unprivileged NGINX Plus on Kubernetes and OpenShift
canonical: TODO
description: "Run F5 NGINX Plus as an unprivileged, non-root pod on Kubernetes or OpenShift, and optionally connect it to NGINX Instance Manager or NGINX One Console."
toc: true
weight: 650
f5-product: F5 NGINX Plus
f5-content-type: how-to
f5-docs: DOCS-000
f5-keywords: "NGINX Plus, Kubernetes, OpenShift, non-root, unprivileged, rootless, UID, GID, SCC, NGINX Agent, NGINX Instance Manager, NGINX One Console, docker-image-builder"
f5-summary: >
  This guide shows how to run NGINX Plus as an unprivileged pod on Kubernetes or Red Hat OpenShift.
  It covers getting or building a non-root image, deploying it with example manifests, and connecting NGINX Agent to NGINX Instance Manager or NGINX One Console.
  It also explains how to run with the UID that OpenShift assigns or with a fixed UID.
f5-audience: operator
---

## Overview

This guide shows how to run F5 NGINX Plus as an unprivileged (non-root) pod in a Kubernetes or Red Hat OpenShift cluster. This is a regular NGINX Plus deployment, not an ingress controller.

The pod can also run NGINX Agent, which connects it to F5 NGINX Instance Manager or F5 NGINX One Console.

You will:

1. Get an unprivileged NGINX Plus image.
1. Create the Secrets that the pod needs.
1. Deploy NGINX Plus on Kubernetes.
1. Connect NGINX Agent to NGINX Instance Manager or NGINX One Console (optional).
1. Adjust the deployment for OpenShift security constraints.

---

## Before you begin

Before you begin, make sure you have:

- **A cluster**: A Kubernetes or OpenShift cluster, and the `kubectl` or `oc` command-line tool configured to access it.
- **A license**: The JSON Web Token (JWT) license file for your NGINX Plus subscription, named `license.jwt`. See [About subscription licenses]({{< ref "/solutions/about-subscription-licenses.md" >}}).
- **A private registry**: A container registry that your cluster can pull images from.
- **A control plane (optional)**: For the NGINX Agent steps, the FQDN of your NGINX Instance Manager host, or a [data plane key]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}) for NGINX One Console.

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

{{< call-out class="note" title="Note" >}}
An unprivileged NGINX Plus process can't listen on ports below `1024`. The examples in this guide listen on port `8080` in the pod and expose it as port `80` through a Service.
{{< /call-out >}}

---

## Get an unprivileged NGINX Plus image

To get an image, pull a prebuilt image from the F5 private registry, or build a custom image. Build a custom image if you need a UID and GID other than `101`, or if you need additional components such as F5 WAF for NGINX.

### Pull a prebuilt image

The F5 private registry, `private-registry.nginx.com`, provides unprivileged images that run as the `nginx` user (UID `101`, GID `101`):

{{<table>}}
| Image | Contents |
|-------|----------|
| `nginx-plus/rootless-base` | NGINX Plus |
| `nginx-plus/rootless-agent` | NGINX Plus with NGINX Agent version 2 |
| `nginx-plus/rootless-agentv3` | NGINX Plus with NGINX Agent version 3 |
{{</table >}}

1. Pull one of the images and push it to your private registry. Follow the steps in [Use official NGINX Plus Docker images]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md#nginx_plus_official_images" >}}).

1. Choose the NGINX Agent version that your NGINX Instance Manager or NGINX One Console deployment supports.

### Build a custom image

To build a custom image, use the NGINX [Docker image builder](https://github.com/nginx/nginx-demos/tree/main/nginx/docker-image-builder).

1. Clone the repository and go to the builder directory:

   ```shell
   git clone https://github.com/nginx/nginx-demos.git
   cd nginx-demos/nginx/docker-image-builder
   ```

1. Copy the `nginx-repo.crt` and `nginx-repo.key` files from MyF5 to the builder directory.

1. Run the build script:

   ```shell
   ./scripts/build.sh \
     -C nginx-repo.crt \
     -K nginx-repo.key \
     -t <MY_DOCKER_REGISTRY>/nginx-plus-unprivileged:<VERSION_TAG> \
     -u \
     -i <UID>:<GID> \
     -a <AGENT_VERSION>
   ```

   Replace the placeholders as follows:

   - `<MY_DOCKER_REGISTRY>`: the path to your private registry
   - `<VERSION_TAG>`: the tag to assign to the image
   - `<UID>` and `<GID>`: the user ID and group ID for the `nginx` user
   - `<AGENT_VERSION>`: `2` or `3`

   The script options are:

   - `-u` builds an unprivileged image.
   - `-i <UID>:<GID>` sets the UID and GID of the `nginx` user. The default is `101:101`.
   - `-a <AGENT_VERSION>` adds NGINX Agent version 2 or 3. Omit this option to build without NGINX Agent.
   - `-w` adds F5 WAF for NGINX.

1. Push the image to your private registry:

   ```shell
   docker push <MY_DOCKER_REGISTRY>/nginx-plus-unprivileged:<VERSION_TAG>
   ```

   Replace `<MY_DOCKER_REGISTRY>` and `<VERSION_TAG>` with the values from the previous step.

The builder assigns the directories that NGINX needs, such as `/etc/nginx` and `/var/cache/nginx`, to group `0` and makes them group-writable. This lets the image run under the UID that OpenShift assigns to the pod.

---

## Create the namespace and Secrets {#create-secrets}

1. Create a namespace:

   ```shell
   kubectl create namespace <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with the name of the namespace, for example, `nginx-plus`.

1. Create a Secret for your JWT license. The Secret key must be `license.jwt`:

   ```shell
   kubectl create secret generic nginx-plus-license \
     --from-file=license.jwt=<PATH/TO/LICENSE.JWT> \
     -n <NAMESPACE>
   ```

   Replace `<PATH/TO/LICENSE.JWT>` with the path to your JWT license file.

1. If the cluster pulls the image from the F5 private registry, create an image pull Secret:

   ```shell
   kubectl create secret docker-registry nginx-plus-registry-secret \
     --docker-server=private-registry.nginx.com \
     --docker-username=<JWT_TOKEN> \
     --docker-password=none \
     -n <NAMESPACE>
   ```

   Replace `<JWT_TOKEN>` with the contents of your JWT license file.

   If you pull from your own registry, set `--docker-server` to `<MY_DOCKER_REGISTRY>` and use the credentials for that registry. If your registry needs no authentication, skip this step.

{{< include "security/jwt-password-note.md" >}}

---

## Deploy NGINX Plus on Kubernetes {#deploy-kubernetes}

The following manifest deploys an unprivileged NGINX Plus pod. It contains a ConfigMap with a sample NGINX configuration, a Deployment, and a Service.

1. Save the manifest as `nginx-plus-unprivileged.yaml`:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: nginx-plus-conf
     namespace: <NAMESPACE>
   data:
     default.conf: |
       server {
         listen 8080;
         location / {
           default_type text/plain;
           return 200 "Hello from unprivileged NGINX Plus\n";
         }
       }
   ---
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-plus
     namespace: <NAMESPACE>
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: nginx-plus
     template:
       metadata:
         labels:
           app: nginx-plus
       spec:
         imagePullSecrets:
           - name: nginx-plus-registry-secret
         securityContext:
           runAsNonRoot: true
           runAsUser: <UID>
           runAsGroup: <GID>
           seccompProfile:
             type: RuntimeDefault
         containers:
           - name: nginx-plus
             image: <MY_DOCKER_REGISTRY>/nginx-plus/rootless-base:<VERSION_TAG>
             ports:
               - containerPort: 8080
             env:
               - name: NGINX_LICENSE_JWT
                 valueFrom:
                   secretKeyRef:
                     name: nginx-plus-license
                     key: license.jwt
             securityContext:
               allowPrivilegeEscalation: false
               capabilities:
                 drop:
                   - ALL
             volumeMounts:
               - name: nginx-conf
                 mountPath: /etc/nginx/conf.d
         volumes:
           - name: nginx-conf
             configMap:
               name: nginx-plus-conf
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-plus
     namespace: <NAMESPACE>
   spec:
     selector:
       app: nginx-plus
     ports:
       - port: 80
         targetPort: 8080
   ```

   Replace the placeholders as follows:

   - `<NAMESPACE>`: the namespace you created
   - `<UID>` and `<GID>`: `101` and `101` for the prebuilt images, or the values you passed to `-i` for a custom image
   - `<MY_DOCKER_REGISTRY>`: the path to your private registry, or `private-registry.nginx.com` to pull from the F5 private registry
   - `<VERSION_TAG>`: the image tag, for example, `r36-debian`

   If you built a custom image, replace the full `image` value with the name of your image. If you don't use an image pull Secret, remove the `imagePullSecrets` section.

1. Apply the manifest:

   ```shell
   kubectl apply -f nginx-plus-unprivileged.yaml
   ```

1. Check that the pod is running:

   ```shell
   kubectl get pods -n <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with your namespace. The pod status is `Running`.

1. Confirm that NGINX Plus runs as an unprivileged user:

   ```shell
   kubectl exec -n <NAMESPACE> deploy/nginx-plus -- id
   ```

   Replace `<NAMESPACE>` with your namespace. The output shows the UID and GID you configured, for example, `uid=101(nginx) gid=101(nginx)`.

1. Forward a local port to the Service:

   ```shell
   kubectl port-forward -n <NAMESPACE> svc/nginx-plus 8080:80
   ```

   Replace `<NAMESPACE>` with your namespace.

1. In a second terminal, send a request:

   ```shell
   curl http://localhost:8080
   ```

   The response is `Hello from unprivileged NGINX Plus`.

---

## Connect NGINX Agent to NGINX Instance Manager or NGINX One Console {#connect-agent}

To manage the pod from NGINX Instance Manager or NGINX One Console, use an image that includes NGINX Agent. Pass the NGINX Agent connection settings as environment variables.

The control plane pushes NGINX configuration to the pod, so change the manifest first:

- Remove the `nginx-conf` volume and its `volumeMounts` entry from the Deployment. NGINX Agent can't update a read-only ConfigMap mount.
- Publish configurations that listen on ports above `1024`.

1. If you connect to NGINX One Console, store the data plane key in a Secret:

   ```shell
   kubectl create secret generic nginx-agent-credentials \
     --from-literal=token=<DATA_PLANE_KEY> \
     -n <NAMESPACE>
   ```

   Replace `<DATA_PLANE_KEY>` with your NGINX One Console data plane key and `<NAMESPACE>` with your namespace.

1. In the Deployment, set `image` to an image that includes NGINX Agent. Add the environment variables for your control plane under `env`, next to `NGINX_LICENSE_JWT`.

   {{<tabs name="agent-connect">}}
   {{%tab name="NGINX Instance Manager"%}}

   For NGINX Agent version 2, use the `rootless-agent` image and add:

   ```yaml
   - name: NGINX_AGENT_SERVER_HOST
     value: "<NIM_FQDN>"
   - name: NGINX_AGENT_SERVER_GRPCPORT
     value: "443"
   - name: NGINX_AGENT_TLS_ENABLE
     value: "true"
   - name: NGINX_AGENT_INSTANCE_GROUP
     value: "<INSTANCE_GROUP>"
   ```

   Replace `<NIM_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Instance Manager host. Replace `<INSTANCE_GROUP>` with the name of the instance group for the pod. Remove the `NGINX_AGENT_INSTANCE_GROUP` entry if you don't use instance groups.

   To secure the connection, see [Encrypt communication]({{< ref "/agent/configuration/encrypt-communication.md" >}}).

   {{%/tab%}}
   {{%tab name="NGINX One Console"%}}

   For NGINX Agent version 2, use the `rootless-agent` image and add:

   ```yaml
   - name: NGINX_AGENT_SERVER_HOST
     value: "agent.connect.nginx.com"
   - name: NGINX_AGENT_SERVER_GRPCPORT
     value: "443"
   - name: NGINX_AGENT_TLS_ENABLE
     value: "true"
   - name: NGINX_AGENT_SERVER_TOKEN
     valueFrom:
       secretKeyRef:
         name: nginx-agent-credentials
         key: token
   ```

   For NGINX Agent version 3, use the `rootless-agentv3` image and add:

   ```yaml
   - name: NGINX_AGENT_COMMAND_SERVER_HOST
     value: "agent.connect.nginx.com"
   - name: NGINX_AGENT_COMMAND_SERVER_PORT
     value: "443"
   - name: NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY
     value: "false"
   - name: NGINX_AGENT_COMMAND_AUTH_TOKEN
     valueFrom:
       secretKeyRef:
         name: nginx-agent-credentials
         key: token
   ```

   {{%/tab%}}
   {{</tabs>}}

   For other options, see [CLI flags and environment variables]({{< ref "/agent/configuration/configuration-overview.md#cli-flags-and-environment-variables" >}}).

1. If you built a custom image with the Docker image builder, use the variables in the following table instead. The builder's startup script reads these names.

   {{<table>}}
   | Variable | Description |
   |----------|-------------|
   | `NGINX_LICENSE` | The contents of your JWT license. Use it instead of `NGINX_LICENSE_JWT`. |
   | `NGINX_AGENT_ENABLED` | Set to `true` to start NGINX Agent. |
   | `NGINX_AGENT_SERVER_HOST` | The FQDN of NGINX Instance Manager, or `agent.connect.nginx.com` for NGINX One Console. |
   | `NGINX_AGENT_SERVER_GRPCPORT` | The gRPC port of the control plane, for example, `443`. |
   | `NGINX_AGENT_SERVER_TOKEN` | The NGINX One Console data plane key. |
   | `NGINX_AGENT_TLS_ENABLE` | Set to `true` to turn on TLS. |
   | `NGINX_AGENT_TLS_SKIP_VERIFY` | Set to `true` to accept self-signed certificates. Use only for testing. |
   | `NGINX_AGENT_INSTANCE_GROUP` | The instance group or config sync group to join. |
   | `NGINX_AGENT_TAGS` | A comma-separated list of tags. |
   | `NGINX_AGENT_ALLOWED_DIRECTORIES` | A comma-separated list of directories that NGINX Agent can read and write, for example, `/etc/nginx`. |
   {{</table >}}

1. Apply the updated manifest:

   ```shell
   kubectl apply -f nginx-plus-unprivileged.yaml
   ```

1. Check that the instance appears in NGINX Instance Manager or NGINX One Console. If it doesn't, read the pod logs:

   ```shell
   kubectl logs -n <NAMESPACE> deploy/nginx-plus
   ```

   Replace `<NAMESPACE>` with your namespace.

---

## Deploy on OpenShift {#deploy-openshift}

OpenShift enforces Security Context Constraints (SCCs). The default `restricted-v2` SCC runs each pod under a UID from a range assigned to the project. It rejects a pod that requests a fixed UID outside that range. For background, see [A guide to OpenShift and UIDs](https://www.redhat.com/en/blog/a-guide-to-openshift-and-uids).

Choose one of the following approaches.

### Run under the UID that OpenShift assigns

If you use a custom image built with the Docker image builder, let OpenShift assign the UID. The image's directories are writable by group `0`, which is the group of the pod's process.

1. Create the project:

   ```shell
   oc new-project <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with the name of the project.

1. Create the Secrets. Follow [Create the namespace and Secrets](#create-secrets) and use `oc` instead of `kubectl`.

1. In the manifest from [Deploy NGINX Plus on Kubernetes](#deploy-kubernetes), delete the `runAsUser` and `runAsGroup` lines from the pod `securityContext`. Keep `runAsNonRoot: true`.

1. Apply the manifest:

   ```shell
   oc apply -f nginx-plus-unprivileged.yaml -n <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with the name of the project.

1. Check the SCC and the UID that OpenShift assigned:

   ```shell
   oc get pod <POD_NAME> -n <NAMESPACE> -o jsonpath='{.metadata.annotations.openshift.io/scc}'
   oc exec <POD_NAME> -n <NAMESPACE> -- id
   ```

   Replace `<POD_NAME>` with the name of the pod and `<NAMESPACE>` with the name of the project. The first command returns `restricted-v2`. The second command shows a UID from the project range and group `0`.

### Run under a fixed UID

If you use a prebuilt registry image (UID `101`), or a custom image that needs a specific UID, grant the `nonroot-v2` SCC to a service account. You need cluster administrator rights.

1. Create a service account:

   ```shell
   oc create serviceaccount nginx-plus -n <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with the name of the project.

1. Allow the service account to use the `nonroot-v2` SCC. This SCC permits any non-root UID:

   ```shell
   oc adm policy add-scc-to-user nonroot-v2 -z nginx-plus -n <NAMESPACE>
   ```

   Replace `<NAMESPACE>` with the name of the project.

1. In the Deployment, add `serviceAccountName: nginx-plus` to the pod spec. Keep `runAsUser: <UID>` and `runAsGroup: <GID>` in the pod `securityContext`.

1. Apply the manifest, then check the pod as described in the previous procedure. The `openshift.io/scc` annotation returns `nonroot-v2`.

### Expose the service

To reach NGINX Plus from outside the cluster, create a route:

```shell
oc expose service nginx-plus -n <NAMESPACE>
oc get route nginx-plus -n <NAMESPACE>
```

Replace `<NAMESPACE>` with the name of the project. The second command shows the route host name.

---

## Troubleshooting

### Permission denied when binding to a port

**Symptom**: The pod fails with a `permission denied` error for a port.

**Cause**: An unprivileged process can't listen on ports below `1024`.

**Fix**: Configure NGINX to listen on a port above `1024`, for example, `8080`. Use the same port for `containerPort` and the Service `targetPort`.

### OpenShift rejects the pod

**Symptom**: OpenShift reports `unable to validate against any security context constraint`.

**Cause**: The `runAsUser` value is outside the UID range that the SCC allows.

**Fix**: Delete `runAsUser`, or grant the `nonroot-v2` SCC to the pod's service account. See [Run under a fixed UID](#deploy-openshift).

### NGINX can't write to a file or directory

**Symptom**: NGINX fails to start and logs `Permission denied` for a file or directory.

**Cause**: The UID that the pod runs under can't write to a directory that NGINX needs.

**Fix**: Build the image with the Docker image builder, which makes the directories writable by group `0`. Or set the pod UID to the UID of the image.

### The pod can't pull the image

**Symptom**: The pod status is `ImagePullBackOff`.

**Cause**: The image name or tag is wrong, or the image pull Secret is missing.

**Fix**: Check the image name and tag. Make sure the image pull Secret exists in the same namespace as the Deployment.

### NGINX Agent doesn't connect

**Symptom**: The instance doesn't appear in NGINX Instance Manager or NGINX One Console.

**Cause**: The pod can't reach the control plane, or the connection settings are wrong.

**Fix**: Make sure the pod can reach the control plane host and port. Check the pod logs with `kubectl logs`.

---

## References

For more information, see:

- [Deploying NGINX and NGINX Plus with Docker]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-docker.md" >}})
- [NGINX Plus unprivileged installation]({{< ref "/nginx/admin-guide/installing-nginx/installing-nginx-plus.md#unpriv_install" >}})
- [Connect NGINX Plus container images to NGINX One Console]({{< ref "/nginx-one-console/connect-instances/connect-nginx-plus-container-images-to-nginx-one.md" >}})
- [Deploy NGINX Plus and NGINX Agent with Docker for NGINX Instance Manager]({{< ref "/nim/deploy/docker/deploy-nginx-plus-and-agent-docker.md" >}})
- [CLI flags and environment variables]({{< ref "/agent/configuration/configuration-overview.md#cli-flags-and-environment-variables" >}})
