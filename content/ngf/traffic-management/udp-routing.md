---
title: UDPRoute
weight: 1100
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-0000
---

Learn how to configure a UDPRoute to handle a UDP connection between NGINX Gateway Fabric and the backend applications. 

## Overview

UDPRoute enables you to expose and route UDP traffic through a Gateway. In this guide, you’ll configure a Gateway with a UDP listener and attach a UDPRoute to it. The listener defines the external UDP port, and the UDPRoute specifies the backend services; packets arriving on the listener’s port are forwarded to the backend applications.

## Note on Gateway API Experimental Features

{{< call-out "important" >}} UDPRoute is a Gateway API resource from the experimental release channel. {{< /call-out >}}

{{< include "/ngf/installation/install-gateway-api-experimental-features.md" >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with experimental features enabled.

## Setup

Create a simple application `coredns` by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: coredns
  namespace: default
  labels:
    app: coredns
spec:
  ports:
    - name: udp-dns
      port: 53
      protocol: UDP
      targetPort: 53
  selector:
    app: coredns
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  labels:
    app: coredns
spec:
  selector:
    matchLabels:
      app: coredns
  template:
    metadata:
      labels:
        app: coredns
    spec:
      containers:
        - args:
            - -conf
            - /root/Corefile
          image: coredns/coredns
          name: coredns
          volumeMounts:
            - mountPath: /root
              name: conf
      volumes:
        - configMap:
            defaultMode: 420
            name: coredns
          name: conf
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
data:
  Corefile: |
    .:53 {
        forward . 8.8.8.8 9.9.9.9
        log
        errors
    }

    cafe.example.com:53 {
      whoami
    }
EOF
```

This creates a Service and Deployment for `coredns` applications. This application has a DNS entry for `cafe.example.com` , we will use this entry to test the UDP connection. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

```text
NAME                                 READY   STATUS    RESTARTS   AGE
pod/coredns-54bb897547-np694         1/1     Running   0          13m

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/coredns         ClusterIP   10.96.206.93   <none>        53/UDP     13m
```

Create a Gateway with UDP listener:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: coredns
    protocol: UDP
    port: 53
    allowedRoutes:
      kinds:
      - kind: UDPRoute
EOF
```

This creates a Gateway with listener `coredns` that listens on port 53. After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted`:

```text
Status:
  Conditions:
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< call-out "note" >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /call-out >}}

Create UDPRoute for routing to `coredns` application:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: UDPRoute
metadata:
  name: coredns
spec:
  parentRefs:
  - name: gateway
    sectionName: coredns
  rules:
    - backendRefs:
      - name: coredns
        port: 53
EOF
```

This UDPRoute attaches to the `coredns` listener and all requests incoming at port 53 are responded back by coredns application. Verify the status of the UDPRoute and it is `Accepted`:

```shell
kubectl describe udproutes.gateway.networking.k8s.io coredns
```

```
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-01-09T04:41:04Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-01-09T04:41:04Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Namespace:     default
      Section Name:  coredns
```

Next, verify that the UDPRoute is configured by inspecting the NGINX configuration:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see a server block with `udp` listen directive:

```text
server {
    listen 53 udp;
    listen [::]:53 udp;
    proxy_pass default_coredns_53;
}
```

## Send Traffic

We will use the `dig` command to query the dns entry cafe.example.com through the Gateway. Let's send traffic to the application:

```shell
dig @${GW_IP} -p ${GW_PORT} cafe.example.com
```

You should see the following output:

```text
<<>> DiG 9.10.6 <<>> ${GW_IP} 53 cafe.example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13260
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;localhost.			IN	A

;; ANSWER SECTION:
localhost.		600	IN	A	127.0.0.1

;; Query time: 136 msec
;; SERVER: 192.168.72.180#53(192.168.72.180)
;; WHEN: Thu Jan 08 21:44:46 MST 2026
;; MSG SIZE  rcvd: 54

;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 32036
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;53.				IN	A

;; Query time: 141 msec
;; SERVER: 192.168.72.180#53(192.168.72.180)
;; WHEN: Thu Jan 08 21:44:47 MST 2026
;; MSG SIZE  rcvd: 31

;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16210
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;cafe.example.com.		IN	A

;; AUTHORITY SECTION:
example.com.		900	IN	SOA	elliott.ns.cloudflare.com. dns.cloudflare.com. 2393120882 10000 2400 604800 1800

;; Query time: 159 msec
;; SERVER: 192.168.72.180#53(192.168.72.180)
;; WHEN: Thu Jan 08 21:44:47 MST 2026
;; MSG SIZE  rcvd: 107
```

## Further Readings

- [UDPRoute](https://gateway-api.sigs.k8s.io/reference/spec/?h=tcproute#udproute)