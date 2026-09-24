---
title: Install NGINX Ingress Controller with F5 WAF for NGINX using PLM
weight: 200
toc: true
f5-content-type: tutorial
f5-product: F5 NGINX Ingress Controller
f5-description: >
  Install F5 NGINX Ingress Controller with F5 WAF for NGINX and Policy
  Lifecycle Management (PLM). Deploy WAF-protected traffic using either a
  VirtualServer or an Ingress resource.
f5-audience: operator
---

Use this guide to install F5 NGINX Ingress Controller with F5 WAF for NGINX using Policy Lifecycle Management (PLM). PLM defines WAF policies as Kubernetes custom resources, compiles them automatically, and stores the compiled bundles in an in-cluster S3-compatible object store. NGINX Ingress Controller then fetches the bundles from PLM storage and enforces the policies at request time.

By the end of this tutorial, you'll have:

- A running PLM backend and NGINX Ingress Controller deployment configured for PLM storage.
- An `APPolicy` and an `APLogConf` resource compiled by PLM.
- A `k8s.nginx.org/v1` Policy that references the compiled resources.
- The Policy attached to a VirtualServer or an Ingress, with traffic flowing normally and attack payloads blocked.

## Before you begin

Before you start, make sure you have:

- `kubectl` access to a Kubernetes cluster.
- Helm installed.
- Credentials for `private-registry.nginx.com`.

This tutorial uses the following example values. If you use different values, replace them consistently throughout.

| Example value | What it represents |
|---|---|
| `plm-system` | Namespace for the PLM backend |
| `plm` | Helm release name for PLM |
| `nginx-ingress` | Namespace for NGINX Ingress Controller |
| `nic` | Helm release name for NGINX Ingress Controller |
| `security` | Namespace for `APPolicy` and `APLogConf` resources |
| `default` | Namespace for the Policy, sample application, and routing resource |
| `webapp.example.com` | Example hostname for VirtualServer routing |
| `cafe.example.com` | Example hostname for Ingress routing |

## Deploy PLM infrastructure

Install the PLM backend before installing NGINX Ingress Controller. The PLM backend provisions the App Protect v1 CRDs, the Policy Controller, the compiler service, and the SeaweedFS storage backend in the `plm-system` namespace.

{{< include "waf/plm-deploy-infrastructure.md" >}}

Confirm the CRDs are installed:

```shell
kubectl get crd | grep appprotect.f5.com
```

Expected output:

```text
aplogconfs.appprotect.f5.com
appolicies.appprotect.f5.com
apsignatures.appprotect.f5.com
apusersigs.appprotect.f5.com
```

## Look up the PLM storage endpoint and credentials

NGINX Ingress Controller connects to PLM's SeaweedFS filer over S3 to fetch compiled bundles. Before you install the controller, collect these four values from the PLM installation:

1. **PLM storage URL**: the SeaweedFS filer endpoint (HTTPS or HTTP).
2. **Credentials Secret**: the S3 credentials Secret. The access key ID is `admin` by default. The secret access key is in the `seaweedfs_admin_secret` field.
3. **CA Secret** (HTTPS only): verifies the SeaweedFS filer certificate.
4. **Client TLS Secret** (mutual TLS only): presented by NGINX Ingress Controller when it connects to the filer.

List the Services PLM created and identify the filer:

```shell
kubectl get service --namespace plm-system
```

Expected output includes an entry similar to:

```text
NAME                       TYPE        CLUSTER-IP   PORT(S)
plm-f5-waf-seaweed-filer   ClusterIP   10.0.0.10    8333/TCP,9333/TCP,...
```

Assemble the URL from the service name, namespace, and port. Use `9333` for HTTPS and `8333` for HTTP:

- HTTPS (mTLS): `https://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:9333`
- HTTP: `http://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:8333`

List the Secrets PLM created:

```shell
kubectl get secret --namespace plm-system
```

The default PLM install creates three Secrets that NGINX Ingress Controller references:

- `plm-f5-waf-seaweedfs-auth`: SeaweedFS credentials.
- `plm-f5-waf-seaweedfs-ca-cert`: CA certificate for the HTTPS filer.
- `plm-f5-waf-seaweedfs-client-cert`: client TLS certificate for mTLS.

Record the Secret references in `<NAMESPACE/NAME>` form. You'll pass all four values to NGINX Ingress Controller using `--set controller.appprotect.plmStorage.*` flags.

## Install NGINX Ingress Controller with PLM storage

Because PLM owns the `appprotect.f5.com/v1` CRDs, you must apply the controller's own CRDs before running `helm install`. The `deploy/crds.yaml` bundle contains every CRD the controller needs (`VirtualServer`, `VirtualServerRoute`, `Policy`, `TransportServer`, `GlobalConfiguration`, `DNSEndpoint`). The bundle deliberately excludes the App Protect CRDs, which PLM owns.

Download your NGINX Ingress Controller subscription’s JSON Web Token and rename it to `nginx-repo.jwt`.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/deploy/crds.yaml
```

Create a namespace and image pull Secret for NGINX Ingress Controller:

```shell
kubectl create namespace nginx-ingress
kubectl create secret docker-registry regcred \
  --namespace nginx-ingress \
  --docker-server=private-registry.nginx.com \
  --docker-username=$(cat nginx-repo.jwt) \
  --docker-password=none

kubectl create secret generic license-token \
  --namespace nginx-ingress \
  --from-file=license.jwt=nginx-repo.jwt \
  --type=nginx.com/license
```

Add the NGINX Helm repository:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update nginx-stable
```

Install NGINX Ingress Controller with PLM storage turned on. This example uses HTTPS with mutual TLS. For HTTP storage, set only `controller.appprotect.plmStorage.url` and `controller.appprotect.plmStorage.credentialsSecret`.

```shell
helm install nic nginx-stable/nginx-ingress \
  --namespace nginx-ingress \
  --skip-crds \
  --set controller.image.repository="private-registry.nginx.com/nginx-ic-nap-v5/nginx-plus-ingress" \
  --set controller.image.tag="{{< nic-version >}}" \
  --set controller.nginxplus=true \
  --set controller.appprotect.enable=true \
  --set controller.appprotect.v5=true \
  --set controller.appprotect.plmStorage.url="https://plm-f5-waf-seaweed-filer.plm-system.svc.cluster.local:9333" \
  --set controller.appprotect.plmStorage.credentialsSecret="plm-system/plm-f5-waf-seaweedfs-auth" \
  --set controller.appprotect.plmStorage.caSecret="plm-system/plm-f5-waf-seaweedfs-ca-cert" \
  --set controller.appprotect.plmStorage.clientSSLSecret="plm-system/plm-f5-waf-seaweedfs-client-cert" \
  --set controller.appprotect.plmStorage.insecureSkipVerify=false \
  --set controller.serviceAccount.imagePullSecretName=regcred
```

Wait for the controller pod to become ready. Each pod runs three containers: `nginx-ingress`, `waf-enforcer`, and `waf-config-mgr`.

```shell
kubectl wait --for=condition=Ready pods \
  --namespace nginx-ingress \
  --selector app.kubernetes.io/name=nginx-ingress \
  --timeout=180s

kubectl get pods --namespace nginx-ingress
```

Expected output:

```text
NAME                             READY   STATUS    RESTARTS   AGE
nic-nginx-ingress-controller-xxxxx  3/3     Running   0          2m
```

Save the public IP address and HTTP port of the NGINX Ingress Controller LoadBalancer service to shell variables:

```shell
IC_IP=<public IP address>
IC_HTTP_PORT=<port number>
```

## Define the WAF policy

Create the `security` namespace to hold the `APPolicy` and `APLogConf` resources:

```shell
kubectl create namespace security
```

Save the following as `waf-resources.yaml`. The file defines an `APPolicy` that blocks attack signatures and masks credit card numbers and social security numbers in responses. It also defines an `APLogConf` for security logging.

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking
  namespace: security
spec:
  policy:
    name: dataguard-blocking
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    blocking-settings:
      violations:
      - name: VIOL_DATA_GUARD
        alarm: true
        block: true
    data-guard:
      enabled: true
      maskData: true
      creditCardNumbers: true
      usSocialSecurityNumbers: true
---
apiVersion: appprotect.f5.com/v1
kind: APLogConf
metadata:
  name: log-default
  namespace: security
spec:
  content:
    format: default
    max_message_size: 64k
    max_request_size: any
  filter:
    request_type: all
```

Apply the file:

```shell
kubectl apply -f waf-resources.yaml
```

Wait for both resources to reach `ready`:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready \
  appolicy/dataguard-blocking --namespace security --timeout=180s

kubectl wait --for=jsonpath='{.status.bundle.state}'=ready \
  aplogconf/log-default --namespace security --timeout=180s
```

Confirm the compiled bundle location:

```shell
kubectl get appolicy dataguard-blocking --namespace security \
  --output jsonpath='State: {.status.bundle.state}{"\n"}Location: {.status.bundle.location}{"\n"}'
```

## Create the Policy

Save the following as `waf-policy.yaml`. The `apPolicy` and `apLogConf` fields accept `[<NAMESPACE>/]<NAME>`. When you omit the namespace, NGINX Ingress Controller defaults to the Policy's own namespace.

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: waf-policy
  namespace: default
spec:
  waf:
    enable: true
    apPolicy: "security/dataguard-blocking"
    securityLogs:
    - enable: true
      apLogConf: "security/log-default"
      logDest: "syslog:server=syslog-svc.default:514"
```

Apply the file:

```shell
kubectl apply -f waf-policy.yaml
```

Wait for the Policy to become `Valid`:

```shell
kubectl wait --for=jsonpath='{.status.state}'=Valid \
  policy/waf-policy --namespace default --timeout=180s
```

If the Policy stays in `Warning` with a `BundleFetchFailed` reason, see [Troubleshooting](#troubleshooting).

Choose how to attach the Policy:
- [Attach to a VirtualServer](#attach-to-a-virtualserver)
- [Attach to an Ingress](#attach-to-an-ingress)

The Policy resource is the same for both.

## Attach to a VirtualServer

Save the following as `webapp.yaml`. The file defines the sample application Deployment, its Service, and a VirtualServer that references the `waf-policy` Policy.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: webapp-svc
  namespace: default
spec:
  selector:
    app: webapp
  ports:
  - name: http
    port: 80
    targetPort: 8080
---
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: webapp
  namespace: default
spec:
  host: webapp.example.com
  policies:
  - name: waf-policy
  upstreams:
  - name: webapp
    service: webapp-svc
    port: 80
  routes:
  - path: /
    action:
      pass: webapp
```

Apply the file:

```shell
kubectl apply -f webapp.yaml
```

Send a normal request to confirm the application responds:

```shell
curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
  http://webapp.example.com:$IC_HTTP_PORT/
```

Expected output:

```text
Server address: 10.0.0.1:8080
Server name: webapp-xxxxx
```

Send a request that triggers the data guard violation:

```shell
curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP \
  "http://webapp.example.com:$IC_HTTP_PORT/</script>"
```

Expected output:

```text
<html><head><title>Request Rejected</title></head><body>
The requested URL was rejected. Please consult with your administrator.
...
</body></html>
```

## Attach to an Ingress

Save the following as `cafe.yaml`. The file defines the sample cafe application (`coffee` and `tea` Deployments and Services) and an Ingress. The `nginx.com/policies` annotation attaches the `waf-policy` Policy to every route on the Ingress.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
        image: nginxdemos/hello:plain-text
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: coffee-svc
  namespace: default
spec:
  selector:
    app: coffee
  ports:
  - port: 80
    targetPort: 80
    name: http
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/hello:plain-text
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: tea-svc
  namespace: default
spec:
  selector:
    app: tea
  ports:
  - port: 80
    targetPort: 80
    name: http
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cafe-ingress
  namespace: default
  annotations:
    nginx.com/policies: "waf-policy"
spec:
  ingressClassName: nginx
  rules:
  - host: cafe.example.com
    http:
      paths:
      - path: /tea
        pathType: Prefix
        backend:
          service:
            name: tea-svc
            port:
              number: 80
      - path: /coffee
        pathType: Prefix
        backend:
          service:
            name: coffee-svc
            port:
              number: 80
```

Apply the file:

```shell
kubectl apply -f cafe.yaml
```

Send a normal request:

```shell
curl --resolve cafe.example.com:$IC_HTTP_PORT:$IC_IP \
  http://cafe.example.com:$IC_HTTP_PORT/coffee
```

Send a request that triggers the data guard violation:

```shell
curl --resolve cafe.example.com:$IC_HTTP_PORT:$IC_IP \
  "http://cafe.example.com:$IC_HTTP_PORT/coffee/</script>"
```

The response body is `Request Rejected`.

Under PLM, the Ingress-only App Protect annotations (`appprotect.f5.com/app-protect-policy` and `appprotect.f5.com/app-protect-security-log`) aren't supported. Use the `k8s.nginx.org/v1` Policy resource and the `nginx.com/policies` annotation instead, as shown above.

## Verify bundles on disk

Confirm the compiled bundles are present in the ingress controller pod:

```shell
NIC_POD=$(kubectl get pods --namespace nginx-ingress \
  --selector app.kubernetes.io/name=nginx-ingress \
  --output jsonpath='{.items[0].metadata.name}')

kubectl exec --namespace nginx-ingress $NIC_POD --container nginx-ingress -- \
  ls -ltr /etc/app_protect/bundles/
```

Expected output:

```text
total 1860
-rw------- 1 nginx nginx    1654 Aug 12 10:06 fetched_default_waf-policy_log_0.tgz
-rw------- 1 nginx nginx 1898698 Aug 12 13:32 fetched_default_waf-policy_policy.tgz
```

Check the Policy status:

```shell
kubectl describe policy waf-policy
```

A `State: Valid` and `Reason: AddedOrUpdated` status confirms the bundles were fetched successfully.

## Troubleshooting

- **Policy status is `Warning` with reason `BundleFetchFailed`.** Run `kubectl describe appolicy <name> --namespace security` and confirm `status.bundle.state` is `ready`. If PLM hasn't compiled the resource yet, the Policy fetch can't proceed.
- **NGINX Ingress Controller reports the referenced namespace isn't watched.** If `controller.watchNamespace` is set, include the namespace that holds the `APPolicy` and `APLogConf` resources. If `controller.watchSecretNamespace` is set, include the PLM namespace so the controller can observe storage Secret rotation.
