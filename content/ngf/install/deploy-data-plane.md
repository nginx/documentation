---
title: Deploy a Gateway for data plane instances
weight: 600
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1854
---

## Overview

This document describes how to use a Gateway to deploy the NGINX data plane, and how to modify it using an NGINX custom resource.

[A Gateway](https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway) is used to manage all inbound requests, and is a key Gateway API resource.

When a Gateway is attached to a GatewayClass associated with NGINX Gateway Fabric, it creates a Service and an NGINX deployment. This forms the NGINX data plane, handling requests.

A single GatewayClass can have multiple Gateways: each Gateway will create a separate Service and NGINX deployment.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Create a Gateway

To deploy a Gateway, run the following command:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: cafe
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
EOF
```

To check that the Gateway has deployed correctly, use `kubectl describe` to check its status:

```shell
kubectl describe gateway
```

You should see these conditions:

```text
Conditions:
      Last Transition Time:  2025-05-05T23:49:33Z
      Message:               Listener is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2025-05-05T23:49:33Z
      Message:               Listener is programmed
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
      Last Transition Time:  2025-05-05T23:49:33Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2025-05-05T23:49:33Z
      Message:               No conflicts
      Observed Generation:   1
      Reason:                NoConflicts
      Status:                False
      Type:                  Conflicted
```

Using `kubectl get` you can see the NGINX Deployment:

```shell
kubectl get deployments
```
```text
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
cafe-nginx   1/1     1            1           3m18s
```

You can also see the Service fronting it:

```shell
kubectl get services
```
```text
NAME         TYPE            CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
cafe-nginx   LoadBalancer    10.96.125.117   <pending>     80:30180/TCP   5m2s
```

The Service type can be changed, as explained in the next section.

## Modify provisioned NGINX instances

The NginxProxy custom resource can modify the provisioning of the Service object and NGINX deployment when a Gateway is created.

{{< call-out "note" >}} Updating most Kubernetes related fields in NginxProxy will trigger a restart of the related resources. {{< /call-out >}}

An NginxProxy resource is created by default after deploying NGINX Gateway Fabric. This NginxProxy resource is attached to the GatewayClass (created on NGINX Gateway Fabric installation), and
its settings are applied globally to all Gateways.

Use `kubectl get` and `kubectl describe` to get some more information on the resource:

```shell
kubectl get nginxproxies -A
```
```text
NAMESPACE       NAME                      AGE
nginx-gateway   ngf-proxy-config   19h
```

```shell
kubectl describe nginxproxy -n nginx-gateway ngf-proxy-config
```
```text
Name:         ngf-proxy-config
Namespace:    nginx-gateway
Labels:       app.kubernetes.io/instance=ngf
              app.kubernetes.io/managed-by=Helm
              app.kubernetes.io/name=nginx-gateway-fabric
              app.kubernetes.io/version=edge
              helm.sh/chart=nginx-gateway-fabric-1.6.2
Annotations:  meta.helm.sh/release-name: ngf
              meta.helm.sh/release-namespace: nginx-gateway
API Version:  gateway.nginx.org/v1alpha2
Kind:         NginxProxy
Metadata:
  Creation Timestamp:  2025-05-05T23:01:28Z
  Generation:          1
  Resource Version:    2245
  UID:                 b545aa9e-74f8-45c0-b472-f14d3cab936f
Spec:
  Ip Family:  dual
  Kubernetes:
    Deployment:
      Container:
        Image:
          Pull Policy:  IfNotPresent
          Repository:   nginx-gateway-fabric/nginx
          Tag:          edge
      Replicas:         1
    Service:
      External Traffic Policy:  Local
      Type:                     LoadBalancer
Events:                         <none>
```

From the information obtained with `kubectl describe` you can see the default settings for the provisioned NGINX Deployment and Service.
Under `Spec.Kubernetes` you can see a few things:
- The NGINX container image settings
- How many NGINX Deployment replicas are specified
- The type of Service and external traffic policy

{{< call-out "note" >}} Depending on installation configuration, the default NginxProxy settings may be slightly different from what is shown in the example.
For more information on NginxProxy and its configurable fields, see the [API reference]({{< ref "/ngf/reference/api.md" >}}). {{< /call-out >}}

Modify the NginxProxy resource to change the type of Service.

Use `kubectl edit` to modify the default NginxProxy and insert the following under `spec.kubernetes.service`:

```yaml
type: NodePort
```

After saving the changes, use `kubectl get` on the service, and you should see the service type has changed to `LoadBalancer`.

```shell
kubectl get service cafe-nginx
```
```text
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
cafe-nginx   NodePort       10.96.172.204   <none>        80:32615/TCP   3h5m
```

### Set annotations and labels on provisioned resources

While the majority of configuration will happen on the NginxProxy resource, that is not always the case. Uniquely, if
you want to set any annotations or labels on the NGINX Deployment or Service, you need to set those annotations on the Gateway which
provisioned them.

You can use `kubectl edit` on the Gateway and add the following to the `spec`:

```yaml
infrastructure:
  annotations:
    annotationKey: annotationValue
  labels:
    labelKey: labelValue
```

After saving the changes, check the Service and NGINX deployment with `kubectl describe`.

```shell
kubectl describe deployment cafe
```
```text
Name:                   cafe-nginx
Namespace:              default
CreationTimestamp:      Mon, 05 May 2025 16:49:33 -0700
...
Pod Template:
  Labels:           app.kubernetes.io/instance=ngf
                    app.kubernetes.io/managed-by=ngf-nginx
                    app.kubernetes.io/name=cafe-nginx
                    gateway.networking.k8s.io/gateway-name=cafe
                    labelKey=labelValue
  Annotations:      annotationKey: annotationValue
                    prometheus.io/port: 9113
                    prometheus.io/scrape: true
...
```

```shell
kubectl describe service cafe-nginx
```
```text
Name:                     cafe-nginx
Namespace:                default
Labels:                   app.kubernetes.io/instance=ngf
                          app.kubernetes.io/managed-by=ngf-nginx
                          app.kubernetes.io/name=cafe-nginx
                          gateway.networking.k8s.io/gateway-name=cafe
                          labelKey=labelValue
Annotations:              annotationKey: annotationValue
```

## See also

For more guides on routing traffic to applications and more information on Data Plane configuration, check out the following resources:

- [Routing traffic to applications]({{< ref "/ngf/traffic-management/basic-routing.md" >}})
- [Application routes using HTTP matching conditions]({{< ref "/ngf/traffic-management/advanced-routing.md" >}})
- [Data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}})
- [API reference]({{< ref "/ngf/reference/api.md" >}})