---
title: Distribute traffic across clusters with F5 BIG-IP
description: Configure an ExternalLoadBalancer so F5 BIG-IP acts as the external load balancer for Gateways in two clusters, terminating and re-encrypting TLS and distributing traffic between them.
weight: 200
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-0000
f5-audience: operator
f5-keywords: BIG-IP, F5 CIS, Container Ingress Services, IngressLink, AS3, ExternalLoadBalancer, GatewayLink, TLS termination, iRule, health monitor, multi-cluster
f5-summary: Use an ExternalLoadBalancer resource to make F5 BIG-IP the external load balancer for NGINX Gateway Fabric Gateways in two clusters. BIG-IP terminates client TLS, re-encrypts toward NGINX, runs health monitors and iRules, and distributes traffic between the clusters.
---

This guide describes how to use an F5 BIG-IP system as the external load balancer for NGINX Gateway Fabric Gateways in two clusters, with TLS termination and traffic distribution between them.

## Overview

In this guide, you configure an `ExternalLoadBalancer` resource that puts BIG-IP in front of Gateways in two clusters. BIG-IP terminates client TLS and re-encrypts toward NGINX, runs your health monitors and iRules, and spreads traffic across both clusters.

The intended use case is a single hostname and certificate served by backends in more than one cluster, such as an active-active deployment or a migration between clusters. Clients see one address, and traffic moves between clusters without a DNS change.

See [How configuration reaches BIG-IP]({{< ref "/ngf/external-loadbalancers/gateway-link/quickstart.md#how-configuration-reaches-big-ip" >}}).

## Before you begin

You need:

- Two Kubernetes clusters. BIG-IP TLS termination requires the second one. See [Why two clusters are required](#why-two-clusters-are-required).
- An F5 BIG-IP system running version {{< ngf-version-bigip >}} or later, and an account on it with administrator privileges.
- Network access from the first cluster to the BIG-IP system, and from BIG-IP to the nodes of both clusters.

This guide installs the AS3 extension, F5 Container Ingress Services, and NGINX Gateway Fabric.

Replace these placeholders wherever they appear in this guide:

- `<BIGIP_ADDRESS>` is the BIG-IP management address including the port, for example `192.0.2.10:8443`.
- `<BIGIP_USERNAME>` and `<BIGIP_PASSWORD>` are your BIG-IP credentials.
- `<VIRTUAL_SERVER_ADDRESS>` is a free IPv4 address on the BIG-IP subnet, used as the virtual server address.

### Why two clusters are required

BIG-IP terminates TLS, matches on hostname, and runs HTTP-event iRules on a Layer 7 virtual server, which F5 Container Ingress Services builds when it runs in multi-cluster mode. Multi-cluster mode requires at least one external cluster, so a second cluster is part of this setup.

The second cluster runs NGINX Gateway Fabric and serves traffic as an additional pool. It does not run F5 Container Ingress Services.

To use BIG-IP as the external load balancer for a Gateway in a single cluster, see [Use F5 BIG-IP as an external load balancer]({{< ref "/ngf/external-loadbalancers/gateway-link/quickstart.md" >}}).

## Prepare BIG-IP

In this section you install the AS3 extension and create the BIG-IP objects this guide depends on: a partition for F5 Container Ingress Services to own, an iRule, and the SSL profiles and health monitors the `ExternalLoadBalancer` refers to by path.

### AS3 extension

F5 Container Ingress Services configures BIG-IP by posting AS3 declarations, so AS3 must be installed before anything else. Follow [Downloading and installing the BIG-IP AS3 package](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html) in the F5 documentation, then return here.

### Partition

{{< include "ngf/gateway-link/create-partition.md" >}}

### SSL Profiles

This guide uses the two SSL profiles that ship with BIG-IP:

- `/Common/clientssl` carries the certificate BIG-IP presents to clients, and terminates their TLS connections.
- `/Common/serverssl` re-encrypts traffic on the connection BIG-IP opens to NGINX. It does not validate the backend certificate, so the self-signed certificate the Gateway presents is accepted.

Both are suitable for testing. In production, replace them with profiles carrying your own certificates, and configure peer verification on the server SSL profile if the backend certificate must be validated.

### HTTP iRules

Create an iRule named `gatewaylink_irule`, which inserts a response header:

```text
when HTTP_RESPONSE {
  HTTP::header insert "X-GatewayLink" "true"
}
```

The iRule runs on every HTTP response BIG-IP sends back to a client and adds an `X-GatewayLink: true` header to it. Only a Layer 7 virtual server runs HTTP-event iRules, so the header appearing in a response confirms both that BIG-IP built a Layer 7 virtual server and that the iRule is attached to it. You check for the header in [Verify the configuration](#verify-the-configuration).

To create the iRule run the following command:

```shell
curl -sku '<BIGIP_USERNAME>:<BIGIP_PASSWORD>' -X POST "https://<BIGIP_ADDRESS>/mgmt/tm/ltm/rule" \
  -H "Content-Type: application/json" -d '{
    "name": "gatewaylink_irule",
    "apiAnonymous": "when HTTP_RESPONSE { HTTP::header insert \"X-GatewayLink\" \"true\" }"
  }'
```

### Health Monitors

This guide uses two health monitors that ship with BIG-IP, so there is nothing to create:

- `/Common/http` checks the HTTP pool members by sending a request and waiting for a response.
- `/Common/tcp` checks the HTTPS pool members by opening a TCP connection, without inspecting encrypted traffic.

BIG-IP marks a pool member offline when its monitor fails and stops sending traffic to it, so each virtual server is checked in a way that suits the traffic it carries.

## Connect the first cluster to the second

F5 Container Ingress Services runs in the first cluster and reaches the second over a kubeconfig. Build that kubeconfig, because Container Ingress Services needs it at install time.

On the **second** cluster, grant F5 Container Ingress Services read access:

```yaml
kubectl apply -f - <<EOF
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: bigip-ctlr-clusterrole
rules:
  - apiGroups: [""]
    resources: ["nodes", "services", "endpoints", "namespaces", "pods", "secrets", "configmaps"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["cis.f5.com"]
    resources: ["*"]
    verbs: ["get", "list", "watch", "update", "patch"]
  - apiGroups: ["discovery.k8s.io"]
    resources: ["endpointslices"]
    verbs: ["get", "list", "watch"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: bigip-ctlr
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: bigip-ctlr-clusterrole-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: bigip-ctlr-clusterrole
subjects:
  - kind: ServiceAccount
    name: bigip-ctlr
    namespace: kube-system
EOF
```

Generate a kubeconfig from the service account. The `server` address must be the second cluster's API server as reached from the first cluster, so take it from the node rather than from the local kubeconfig, which records `https://127.0.0.1:6443`:

```shell
TOKEN=$(kubectl create token bigip-ctlr -n kube-system --duration=8760h)
CA=$(kubectl get cm kube-root-ca.crt -n kube-system -o jsonpath='{.data.ca\.crt}' | base64 -w0)
APISERVER=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

cat > remote-kubeconfig.yaml <<EOF
apiVersion: v1
kind: Config
clusters:
- name: remote
  cluster:
    server: https://${APISERVER}:6443
    certificate-authority-data: ${CA}
users:
- name: bigip-ctlr
  user:
    token: ${TOKEN}
contexts:
- name: remote
  context:
    cluster: remote
    user: bigip-ctlr
current-context: remote
EOF
```

Verify the kubeconfig works:

```shell
KUBECONFIG=remote-kubeconfig.yaml kubectl get nodes
```

The command lists the nodes of the second cluster:

```text
NAME    STATUS   ROLES                  AGE   VERSION
vm2     Ready    control-plane,master   14d   v1.31.5+k3s1
```

## Configure the first cluster

Run these steps against the **first** cluster. Only this cluster runs F5 Container Ingress Services and owns the BIG-IP configuration.

### Generate secret to connect to second cluster

Copy the `remote-kubeconfig.yaml` file you generated on the second cluster over to the first cluster, then create a Secret from it. Create the Secret before installing F5 Container Ingress Services, because it reads the kubeconfig at startup.

```shell
kubectl create secret generic remote-kubeconfig -n kube-system \
  --from-file=kubeconfig=remote-kubeconfig.yaml
```

{{< call-out "important" >}}
The Secret name and namespace must match the `secret` value in the `extended-spec-config` ConfigMap created in the next section, and the key inside the Secret must be `kubeconfig`. Nothing validates these names. F5 Container Ingress Services starts normally, builds only local pools, and reports the mismatch in its log:

```text
error occurred while fetching Secret: remote-kubeconfig for the cluster: remote, Error: secrets "remote-kubeconfig" not found
```
{{< /call-out >}}

### Install F5 Container Ingress Services

Install the F5 Container Ingress Services custom resource definitions:

{{< include "ngf/gateway-link/install-cis-crds.md" >}}

Create a ConfigMap named `extended-spec-config`:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: extended-spec-config
  namespace: kube-system
  labels:
    f5nr: "true"
data:
  extendedSpec: |
    mode: default
    externalClustersConfig:
    - clusterName: remote
      secret: kube-system/remote-kubeconfig
EOF
```

F5 Container Ingress Services reads its multi-cluster configuration from this ConfigMap. The `f5nr: "true"` label is required. The `clusterName` value is how you refer to the second cluster in the `ExternalLoadBalancer` resource later.

Deploy F5 Container Ingress Services:

```shell
helm repo add f5-stable https://f5networks.github.io/charts/stable
helm repo update

helm install f5-cis f5-stable/f5-bigip-ctlr -n kube-system \
  --set bigip_secret.create=true \
  --set bigip_secret.username="<BIGIP_USERNAME>" \
  --set bigip_secret.password="<BIGIP_PASSWORD>" \
  --set rbac.create=true \
  --set serviceAccount.create=true \
  --set namespace=kube-system \
  --set args.bigip_url="<BIGIP_ADDRESS>" \
  --set args.bigip_partition=k8s \
  --set args.pool_member_type=nodeport \
  --set args.custom_resource_mode=true \
  --set args.insecure=true \
  --set args.log_level=DEBUG \
  --set args.log-as3-response=true \
  --set args.multi-cluster-mode=standalone \
  --set args.local-cluster-name=local \
  --set args.extended-spec-configmap=kube-system/extended-spec-config
```

These fields must be set according to your own setup:

- `args.bigip_url` must include the port. F5 Container Ingress Services assumes 443, so omitting a non-default port causes connection failures.
- `args.custom_resource_mode=true` is required. Without it, F5 Container Ingress Services never watches `IngressLink` resources.
- `args.multi-cluster-mode=standalone` is required for a Layer 7 virtual server and TLS termination.
- `args.local-cluster-name` is required whenever multi-cluster mode is set, and must match `multiCluster.localClusterName` in the `ExternalLoadBalancer`.
- `args.extended-spec-configmap` points to the ConfigMap created earlier, in `<NAMESPACE>/<NAME>` form. F5 Container Ingress Services reads the list of external clusters and their kubeconfig Secrets from it, so without this value it has no way to reach the second cluster.
- `args.pool_member_type` must match the type of the Gateway's Service. Use `nodeport` with `NodePort`, or `cluster` with `ClusterIP`.
- `args.log-as3-response=true` logs the BIG-IP response to each declaration, which is useful for troubleshooting.

Confirm F5 Container Ingress Services reached BIG-IP and accepted the mode:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr | grep -E "authn/login|multi-cluster-mode"
```

The log shows a successful login and the configured multi-cluster mode:

```text
[DEBUG] [BIGIP] postConfig request: POST https://<BIGIP_ADDRESS>/mgmt/shared/authn/login 200 OK
[DEBUG] Multi-cluster-mode: standalone, local cluster name: local
```

## Setup for both clusters

Apply the following resources to **both** clusters. Use the same Gateway name and the same listeners in each, so the data plane Services carry matching labels and expose the same ports. F5 Container Ingress Services builds one virtual server per Service port and pools every cluster behind that virtual server.

### Install the custom resource definitions

Install the F5 Container Ingress Services custom resource definitions in **both** clusters, including the second one, which does not run F5 Container Ingress Services:

{{< include "ngf/gateway-link/install-cis-crds.md" >}}

With external load balancer support enabled, NGINX Gateway Fabric watches `IngressLink` resources on startup in every cluster it runs in. A cluster without the custom resource definition leaves the control plane unable to start, and its Pod restarts continuously:

```text
no matches for kind "IngressLink" in version "cis.f5.com/v1"
failed to start control loop: failed to wait for provisioner-IngressLink caches to sync
```

### Install NGINX Gateway Fabric

{{< include "ngf/gateway-link/install-ngf.md" >}}

### Create a Gateway

Create an `NginxProxy` resource named `gatewaylink-proxy`, which exposes the readiness probe:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: gatewaylink-proxy
spec:
  kubernetes:
    deployment:
      container:
        readinessProbe:
          expose: true
          port: 8081
          path: /nginx-ready
    service:
      type: NodePort
      externalTrafficPolicy: Local
EOF
```

This `NginxProxy` configures the Gateway that references it with the settings BIG-IP depends on:

- `readinessProbe.expose` puts the readiness port on the data plane Service. F5 Container Ingress Services builds its health monitor against the Service port named `health`.
- `readinessProbe.path` sets the readiness path to `/nginx-ready`, which is the path the generated health monitor requests. NGINX Gateway Fabric serves its readiness endpoint at `/readyz` by default.
- `service.type` sets the type of the Gateway's Service, and must match the F5 Container Ingress Services `pool_member_type`.
- `service.externalTrafficPolicy: Local` preserves the client source address, and means only nodes running an NGINX Pod advertise the endpoint, so BIG-IP health checks reach a node that answers.

Issue the listener certificate. cert-manager creates the `nginx-tls` Secret containing `tls.crt` and `tls.key`, which the Gateway presents on its HTTPS listener. Install cert-manager and a local certificate authority in both clusters.

{{< include "ngf/deploy-cert-manager.md" >}}

{{< include "ngf/cert-manager-local-ca.md" >}}

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-tls
  namespace: default
spec:
  secretName: nginx-tls
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: cafe.example.com
  dnsNames:
  - cafe.example.com
EOF
```

Confirm the Secret exists before continuing:

```shell
kubectl get secret nginx-tls -n default
```

Create a Gateway named `gateway` with an HTTP listener and an HTTPS listener:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  infrastructure:
    parametersRef:
      name: gatewaylink-proxy
      group: gateway.nginx.org
      kind: NginxProxy
  listeners:
    - name: http
      port: 80
      protocol: HTTP
      hostname: cafe.example.com
    - name: https
      port: 443
      protocol: HTTPS
      hostname: cafe.example.com
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: nginx-tls
EOF
```

The Gateway has two listeners, so the data plane Service exposes ports 80 and 443. Keep the HTTP listener: it gives BIG-IP a plain HTTP path for health checks, and lets you verify traffic without TLS during setup.

Confirm the Gateway is `Accepted` and `Programmed`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted` and `Programmed`, and that both listeners appear:

```text
Status:
  Conditions:
    Message:               The Gateway is accepted
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
```

### Create coffee application and routes

Create the **coffee** application by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
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
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: coffee
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
EOF
```

Create an HTTPRoute named `coffee` that attaches to the Gateway and routes `/coffee` to that Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: gateway
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /coffee
    backendRefs:
    - name: coffee
      port: 80
EOF
```

Confirm the application is running and the route is attached:

```shell
kubectl get pods,svc,httproute
```

The output lists two **coffee** Pods, the **coffee** Service, and the HTTPRoute:

```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/coffee-7dd75bc79b-cqvb7   1/1     Running   0          77s
pod/coffee-7dd75bc79b-t4xkn   1/1     Running   0          77s

NAME             TYPE        CLUSTER-IP     PORT(S)   AGE
service/coffee   ClusterIP   10.43.174.12   80/TCP    77s

NAME                                         HOSTNAMES               AGE
httproute.gateway.networking.k8s.io/coffee   ["cafe.example.com"]    32s
```

## Create the ExternalLoadBalancer

On the **first** cluster only, create an `ExternalLoadBalancer` resource named `gateway-elb`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: ExternalLoadBalancer
metadata:
  name: gateway-elb
spec:
  targetRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: gateway
  gatewayLink:
    virtualServerAddress: "<VIRTUAL_SERVER_ADDRESS>"
    partition: k8s
    host: cafe.example.com
    tls:
      reference: bigip
      clientSSLs:
        - /Common/clientssl
      serverSSLs:
        - /Common/serverssl
    monitors:
      - name: /Common/http
        reference: bigip
      - name: /Common/tcp
        reference: bigip
    iRules:
      - /Common/gatewaylink_irule
    multiCluster:
      localClusterName: local
      remoteClusters:
        - clusterName: remote
EOF
```

This example configures BIG-IP TLS termination, hostname matching, health monitors, iRules, and multi-cluster traffic distribution.

Set `localClusterName` to the value passed to F5 Container Ingress Services as `args.local-cluster-name`. Set each `clusterName` under `remoteClusters` to a `clusterName` from the extended spec ConfigMap.

{{< call-out "important" >}}
The `multiCluster` field is required when F5 Container Ingress Services runs in multi-cluster mode.
{{< /call-out >}}

Confirm NGINX Gateway Fabric `Accepted` the resource:

```shell
kubectl describe externalloadbalancers.gateway.nginx.org gateway-elb
```

Verify the status is `Accepted`:

```text
Status:
  Controllers:
    Conditions:
      Message:               The ExternalLoadBalancer is accepted
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

## Verify the configuration

Confirm the `IngressLink` was written and accepted:

```shell
kubectl describe ingresslink gateway-nginx
```

F5 Container Ingress Services writes this status after posting the AS3 declaration. A status of `OK` means BIG-IP accepted the declaration, and `Vs Address` is the address the virtual server listens on:

```text
Status:
  Last Updated:  2026-08-05T02:23:16Z
  Status:        OK
  Vs Address:    192.0.2.100
```

Send a request through BIG-IP:

```shell
curl -kv --resolve cafe.example.com:443:<VIRTUAL_SERVER_ADDRESS> https://cafe.example.com/coffee
```

The request returns `200 OK`, with the `X-GatewayLink` header added by the iRule and a response body from the backend application:

```text
< HTTP/1.1 200 OK
< Server: nginx
< Content-Type: text/plain
< X-GatewayLink: true

Server address: 10.42.0.19:8080
Server name: coffee-7b9578cff9-272gf
URI: /coffee
```

Confirm traffic is distributed across both clusters. The example application returns the name of the Pod that served each request:

```shell
for i in $(seq 1 20); do
  curl -sk --resolve cafe.example.com:443:<VIRTUAL_SERVER_ADDRESS> https://cafe.example.com/coffee | grep "Server name"
done | sort | uniq -c
```

The output counts each Pod that answered:

```text
   7 Server name: coffee-7b9578cff9-272gf
   6 Server name: coffee-7b9578cff9-qqxzg
   6 Server name: coffee-7b9578cff9-4mxb9
   1 Server name: coffee-7b9578cff9-tpb2c
```

Match those names against the Pods in each cluster to see which cluster served which request.

Confirm BIG-IP is terminating client TLS. BIG-IP decrypts the client connection and opens a separate connection to NGINX, so NGINX logs the BIG-IP request rather than the client one:

```shell
kubectl logs <NGINX_POD_NAME> -c nginx | grep coffee | tail -1
```

The log records the BIG-IP self-IP address as the client, and the request arriving over HTTP/1.1:

```text
192.0.2.10 - - [05/Aug/2026:02:41:18 +0000] "GET /coffee HTTP/1.1" 200 158 "-" "curl/8.5.0"
```

## Pass TLS through to NGINX

Omitting the `tls` field from the `ExternalLoadBalancer` moves TLS termination to NGINX. BIG-IP builds a TCP virtual server and forwards the encrypted stream without decrypting it, so clients see the certificate from the Gateway `certificateRefs` Secret and no SSL profiles are needed on BIG-IP.

Use this when the certificate and private key must stay inside the cluster. Note that BIG-IP cannot read a stream it does not decrypt, so hostname matching and HTTP-event iRules are not available in this configuration.

## Troubleshooting

These entries cover problems specific to a multi-cluster setup. For problems common to both guides, such as no `IngressLink` being created or an AS3 declaration being rejected, see [Troubleshooting]({{< ref "/ngf/external-loadbalancers/gateway-link/quickstart.md#troubleshooting" >}}).

### The control plane restarts continuously in the second cluster

The NGINX Gateway Fabric Pod reports `CrashLoopBackOff`, and its logs end with a cache sync failure:

```text
no matches for kind "IngressLink" in version "cis.f5.com/v1"
failed to start control loop: failed to wait for provisioner-IngressLink caches to sync
```

The F5 Container Ingress Services custom resource definitions are missing from that cluster. With external load balancer support enabled, NGINX Gateway Fabric watches `IngressLink` resources on startup, whether or not Container Ingress Services runs there.

- Install the custom resource definitions in the affected cluster:

```shell
kubectl apply -f https://raw.githubusercontent.com/F5Networks/k8s-bigip-ctlr/v{{< ngf-version-cis >}}/docs/config_examples/customResourceDefinitions/customresourcedefinitions.yml
```

- Delete the Pod so it restarts immediately rather than waiting out its backoff:

```shell
kubectl delete pod -n nginx-gateway -l app.kubernetes.io/name=nginx-gateway-fabric
```

### The remote cluster has no pool

Only `_local` pools exist on BIG-IP, and traffic never reaches the second cluster. F5 Container Ingress Services could not load the second cluster's kubeconfig, so it has no endpoints to pool. Start with its log, which names the cause directly:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr | grep -i "MultiCluster"
```

- Confirm the Secret exists under the name and namespace the `extended-spec-config` ConfigMap refers to. A Secret created under a different name is reported as missing:

```text
error occurred while fetching Secret: remote-kubeconfig for the cluster: remote, Error: secrets "remote-kubeconfig" not found
```

- Confirm the token is still valid. A token issued for a ServiceAccount that has since been deleted and recreated is rejected:

```text
the server has asked for the client to provide credentials
```

Regenerate the kubeconfig on the second cluster and recreate the Secret.

- Confirm the Secret holding the second cluster's kubeconfig parses. A kubeconfig with broken indentation is stored without complaint and fails only when F5 Container Ingress Services loads it:

```shell
kubectl get secret remote-kubeconfig -n kube-system -o jsonpath='{.data.kubeconfig}' | base64 -d > /tmp/check.yaml
KUBECONFIG=/tmp/check.yaml kubectl get nodes
```

The command lists the second cluster's nodes. An error such as `mapping values are not allowed in this context` means the file is malformed, so regenerate it and recreate the Secret.

- Confirm the `clusterName` in the extended spec ConfigMap matches the `clusterName` under `remoteClusters` in the `ExternalLoadBalancer`.
- Restart F5 Container Ingress Services after replacing the Secret, because it reads the kubeconfig at startup:

```shell
kubectl rollout restart deploy/f5-cis-f5-bigip-ctlr -n kube-system
```

### The remote pool member is down

The `_remote` pool exists but its member reports `offline`, so all traffic goes to the local cluster.

- Confirm the second cluster's data plane Service exposes the same ports as the first. A missing HTTPS listener leaves nothing listening on the 443 NodePort:

```shell
kubectl get svc gateway-nginx -o jsonpath='{range .spec.ports[*]}{.name} {.port}:{.nodePort}{"\n"}{end}'
```

- Confirm the `nginx-tls` Secret exists in the second cluster. Without it the HTTPS listener is not programmed and NGINX never listens on 443.
- Restart the data plane after creating a certificate. NGINX does not load a certificate created after the Pod started, and the Gateway reports every condition as healthy while the listener is missing from the configuration:

```shell
kubectl rollout restart deploy/gateway-nginx -n default
```

### A pool is empty

A virtual server exists, but one of its pools contains no members. Requests succeed but only ever reach one cluster. The Gateway in the affected cluster does not expose the port the virtual server is built for.

- Compare the data plane Service ports in each cluster:

```shell
kubectl get svc gateway-nginx -o jsonpath='{.spec.ports}' | python3 -m json.tool
```

A missing port means the Gateway in that cluster has no listener on that port. For an HTTPS listener, a missing or invalid `certificateRefs` Secret also leaves the listener unprogrammed. Check the Gateway status as well:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

### Requests fail with a connection reset

A request through BIG-IP fails with `Recv failure: Connection reset by peer`. NGINX Gateway Fabric enables HTTP/2 by default. BIG-IP SSL profiles do not negotiate HTTP/2 unless configured to, so BIG-IP sends HTTP/1.1 into a connection NGINX set up for HTTP/2.

- Set `disableHTTP2: true` on the `NginxProxy` resource, or use a BIG-IP SSL profile with HTTP/2 enabled. Confirm the setting reached the data plane rather than trusting the resource:

```shell
kubectl exec <NGINX_POD_NAME> -c nginx -- grep "listen 443" /etc/nginx/conf.d/http.conf
```

The absence of an `http2` token on the `listen` line means HTTP/2 is off.

## Remove the configuration

Delete the `ExternalLoadBalancer` so F5 Container Ingress Services deletes the objects it created on BIG-IP:

```shell
kubectl delete externalloadbalancer gateway-elb
```

Confirm the virtual servers are gone:

```shell
curl -sku '<BIGIP_USERNAME>:<BIGIP_PASSWORD>' "https://<BIGIP_ADDRESS>/mgmt/tm/ltm/virtual" | python3 -m json.tool | grep fullPath
```

The output contains no virtual servers in the `k8s` partition.

Delete the Gateway resources.

(Optional) Uninstall F5 Container Ingress Services when decommissioning the integration entirely:

```shell
helm uninstall f5-cis -n kube-system
```

The BIG-IP objects created by hand are not managed by F5 Container Ingress Services. The partition, SSL profiles, monitors, and iRules remain until you remove them.

## References

- [F5 IngressLink documentation](https://clouddocs.f5.com/containers/latest/userguide/ingresslink/): the F5 Container Ingress Services resource that NGINX Gateway Fabric generates.
- [F5 Application Services 3 Extension reference](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schema-reference.html): the declaration format F5 Container Ingress Services posts to BIG-IP.
- [F5 Container Ingress Services](https://github.com/F5Networks/k8s-bigip-ctlr): the F5 Container Ingress Services source and custom resource definitions.
- [F5 IPAM Controller](https://github.com/F5Networks/f5-ipam-controller): allocates virtual server addresses when using the `ipamLabel` field instead of a fixed address.
- [F5 BIG-IP iControl REST API](https://clouddocs.f5.com/api/icontrol-rest/): the API used by the `curl` commands in this guide.
- [BIG-IP Virtual Edition on Amazon Web Services](https://clouddocs.f5.com/cloud/public/v1/aws_index.html)
- [BIG-IP Virtual Edition on Microsoft Azure](https://clouddocs.f5.com/cloud/public/v1/azure_index.html)
- [BIG-IP Virtual Edition on Google Cloud Platform](https://clouddocs.f5.com/cloud/public/v1/google_index.html)
- [F5 Container Ingress Services multi-cluster guide](https://clouddocs.f5.com/containers/latest/userguide/multicluster/): multi-cluster deployment topologies.


