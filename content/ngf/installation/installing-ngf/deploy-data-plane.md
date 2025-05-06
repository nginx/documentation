---
title: Deploy the Data Plane
weight: 500
toc: true
type: how-to
product: NGF
docs: DOCS-000
---

## Overview

Learn how NGINX Gateway Fabric provisions NGINX Data Plane instances and how to modify them.

---

## Before you begin

- [Install]({{< ref "/ngf/installation/" >}}) NGINX Gateway Fabric.

---

## What is a Gateway

As the official [Gateway API Docs](https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway) put it, 
"A Gateway describes how traffic can be translated to Services within the cluster. 
That is, it defines a request for a way to translate traffic from somewhere that does not know about Kubernetes to somewhere that does.".

As the name suggests, a Gateway is at the heart for all inbound request trafficking and is a key Gateway API resource.
When a Gateway is attached to a GatewayClass associated with NGINX Gateway Fabric, a Service and NGINX Deployment are created
and form the NGINX Data Plane to handle requests.

Multiple Gateways can be attached to the single GatewayClass associated with NGINX Gateway Fabric. 
Separate Services and NGINX Deployments are then created for each Gateway. 

---

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

Using `kubectl get` we can see the NGINX Deployment:

```text
~ ❯ kubectl get deployments                                                                                                                                        ⎈ kind-kind
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
cafe-nginx   1/1     1            1           3m18s
```

We can also see the Service fronting it:

```text
~ ❯ kubectl get services                                                                                                                                           ⎈ kind-kind
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
cafe-nginx   NodePort    10.96.125.117   <none>        80:30180/TCP   5m2s
```

The type of Service can be modified, which will be explained below.

---

## How to modify provisioned NGINX instances

Both the NGINX Deployment and Service Kubernetes objects provisioned by NGINX Gateway Fabric upon creation of a Gateway
can be modified through the NginxProxy custom resource. 

{{< note >}} Updating most Kubernetes related fields in NginxProxy will trigger a restart of the related resource to update. {{< /note >}}

An NginxProxy resource is created by default after deploying NGINX Gateway Fabric. Use `kubectl get` and `kubectl describe` to 
get some more information on the resource:

```text
~ ❯ kubectl get nginxproxies -A                                                                                                                                    ⎈ kind-kind
NAMESPACE       NAME                      AGE
nginx-gateway   my-release-proxy-config   19h
```

```text
~ ❯ kubectl describe nginxproxy -n nginx-gateway my-release-proxy-config                                                                                                   ⎈ kind-kind
Name:         my-release-proxy-config
Namespace:    nginx-gateway
Labels:       app.kubernetes.io/instance=my-release
              app.kubernetes.io/managed-by=Helm
              app.kubernetes.io/name=nginx-gateway-fabric
              app.kubernetes.io/version=edge
              helm.sh/chart=nginx-gateway-fabric-1.6.2
Annotations:  meta.helm.sh/release-name: my-release
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
          Pull Policy:  Never
          Repository:   nginx-gateway-fabric/nginx
          Tag:          edge
      Replicas:         1
    Service:
      External Traffic Policy:  Local
      Type:                     NodePort
Events:                         <none>
```

From the information we got through `kubectl describe` we can see the default settings for the provisioned NGINX Deployment and Service.
Under `Spec.Kubernetes` we can see a couple of things:
- The NGINX container image settings
- How many NGINX Deployment replicas are specified
- The type of Service and external traffic policy

{{< note >}} These default NginxProxy settings may change over time, and may not match what is shown. {{< /note >}}

Let's modify the NginxProxy resource to change the type of Service. Use `kubectl edit` to modify the default
NginxProxy and insert the following under `spec.kubernetes.service`

```yaml
type: LoadBalancer
```

After saving the changes, use `kubectl get` on the service, and you should see the service type has changed to LoadBalancer.

```text
~ ❯ kubectl get service cafe-nginx                                                                                                                                                  ⎈ kind-kind
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
cafe-nginx   LoadBalancer   10.96.172.204   <pending>     80:32615/TCP   3h5m
```

### How to set annotations and labels on provisioned resources

While the majority of configuration will happen on the NginxProxy resource, that is not always the case. Uniquely, if
you want to set any annotations or labels on the NGINX Deployment or Service, you need to set those annotations on the Gateway which
provisioned them. 

To do so, we can use `kubectl edit` on our gateway and add the following to the `spec`:

```yaml
infrastructure:
  annotations:
    annotationKey: annotationValue
  labels:
    labelKey: labelValue
```

After saving the changes, we can check our NGINX Deployment and Service using `kubectl describe`. 

```text
~ ❯ kubectl describe deployment cafe                                                                                                                                         1m 52s ⎈ kind-kind
Name:                   cafe-nginx
Namespace:              default
CreationTimestamp:      Mon, 05 May 2025 16:49:33 -0700
...
Pod Template:
  Labels:           app.kubernetes.io/instance=my-release
                    app.kubernetes.io/managed-by=my-release-nginx
                    app.kubernetes.io/name=cafe-nginx
                    gateway.networking.k8s.io/gateway-name=cafe
                    labelKey=labelValue
  Annotations:      annotationKey: annotationValue
                    prometheus.io/port: 9113
                    prometheus.io/scrape: true
...
```

{{< note >}} In order for the changes to propagate onto the Service, it needs to be manually restarted. {{< /note >}}

```text
~ ❯ kubectl describe service cafe-nginx                                                                                                                                             ⎈ kind-kind
Name:                     cafe-nginx
Namespace:                default
Labels:                   app.kubernetes.io/instance=my-release
                          app.kubernetes.io/managed-by=my-release-nginx
                          app.kubernetes.io/name=cafe-nginx
                          gateway.networking.k8s.io/gateway-name=cafe
                          labelKey=labelValue
Annotations:              annotationKey: annotationValue
```

---

## See Also

For more guides on routing traffic to applications and more information on Data Plane configuration, check out the following resources:

- [Routing Traffic to Your App]({{< ref "/ngf/how-to/traffic-management/routing-traffic-to-your-app.md" >}})
- [Advanced Routing]({{< ref "/ngf/how-to/traffic-management/advanced-routing.md" >}})
- [Data Plane Configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}})
- [NGINX Gateway Fabric API Reference]({{< ref "/ngf/reference/api.md" >}})