---
description: How to set up Kubernetes-native API Gateways using Instance Groups (requires
  the API Management module).
docs: DOCS-775
title: Manage Containerized Instances
toc: true
weight: 15
type:
- tutorial
---

## Overview

{{< important >}} Instance groups are supported in the F5 NGINX Controller API Management module beginning with version 3.18-APIM. Instance groups are supported in the NGINX Controller Application Delivery module versions 3.20, 3.21, and 3.22.
{{< /important >}}

Instance groups allow an API Gateway to be native in Kubernetes.

## Create an Instance Group

To create an instance group using the web interface, see [Create an Instance Group]({{< relref "/controller/infrastructure/instances/manage-instances.md#create-an-instance-group" >}}).

To create an instance group using the NGINX Controller REST API, send a PUT request similar to the following example to the instance-groups API endpoint.

`PUT https://{{controllerIP}}/api/v1/infrastructure/instance-groups/k8s-nginx-deploy`

```json
{
    "metadata": {
        "name": "k8s-nginx-deploy",
        "displayName": "K8S NGINX+ deployment",
        "description": "k8s-nginx-deploy"
    },
    "desiredState": {}
}
```

## Build and Run an NGINX Controller-Enabled NGINX Plus Image

1. Follow the instructions to [Build and Run an NGINX Controller-Enabled NGINX Plus Image](https://github.com/nginxinc/docker-nginx-controller#2-how-to-build-and-run-an-nginx-controller-enabled-nginx-plus-image).
1. Ensure that the Dockerfile includes the name you used when you created the instance group.

```bash
# example Instance group already defined in NGINX Controller
ARG INSTANCE_GROUP=k8s-nginx-deploy
ENV ENV_CONTROLLER_INSTANCE_GROUP=$INSTANCE_GROUP
```

## Create a Gateway for the Instance Group

To create a gateway using the NGINX Controller REST API, send a PUT request similar to the following example to the Gateways API endpoint.

`PUT https://{{host}}/api/v1/services/environments/dev/gateways/sportsgw`

```json
{
    "metadata": {
        "name": "sportsgw",
        "displayName": "sports GW",
        "description": "sports.com"
    },
    "desiredState": {
        "ingress": {
            "uris": {
                "http://api.dev.sports.com": {
                    "matchMethod": "PREFIX"
                }
            },
            "placement": {
                "instanceGroupRefs": [
                    {
                        "ref": "/infrastructure/instance-groups/k8s-nginx-deploy"
                    }
                ]
            }
        }
    }
}
```

## Create a Published API and Components for the Gateway

If you are using the included Kubernetes DNS -- for example, CoreDNS or KubeDNS -- the Kubernetes service names can be referenced using the following format. No IP addresses are needed, although service cluster IPs are OK to use as well. The service's port number must be included.

```json
"backend": {
    "workloadGroups": {
        "serverGrp12345": {
            "uris": {
                "http://my-k8s-service:8080": {}
            }
        }
    }

    }
```

To make the best of use of NGINX and its load-balancing capabilities for the workload pods, we recommend running the Kubernetes services as Headless (setting `ClusterIP` to `None` in the deployment). In this mode, the DNS configuration returns A records that point directly to the Pods backing the service instead of the single cluster IP or Kubernetes Load Balancer IP.

You can configure the `servers` setting for `dnsServiceDiscovery` for the component to include the IP of the Kubernetes KubeDNS/CoreDNS (or whatever DNS they are using). NGINX resolves the IP addresses of the pods and takes care of the load balancing.

To get the IP of KubeDNS/CoreDNS, run the following command:

```bash
kubectl get svc --namespace=kube-system
```

For both KubeDNS/CoreDNS, the service name will show up as `kube-dns`.

Example component backend:

```json
{
    "workloadGroups": {
        "serverGrp12345": {
            "uris": {
                "http://hello-mini.default.svc.cluster.local:8080": {}
            },
            "dnsServiceDiscovery": {
                "servers": ["10.96.0.10"],
                "ttl": "30s",
                "timeout": "30s"
            }
        }
    },
    "monitoring":{}
}
```

The workload group URI must use the FQDN of the Kubernetes service instead of just the name. In the preceding example, `hello-mini` corresponds to the service name, `default` stands for the namespace the service is defined in, and `svc.cluster.local` is the cluster domain suffix. You still need to know the service's port number.

## Configure Kubernetes to Use the Docker Image

You might need to set `imagePullPolicy: Never` in your Kubernetes deployment for locally built images.

```text
spec:
  containers:
  - image: yourusername/yourimagename:latest
    imagePullPolicy: Never
    name: yourimagename
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
```

You can get the stock deployment yaml running a comment similar to the following example. In this example,  `hello-node` is the deployment name. You can change this name to whatever you want.

```bash
kubectl create deployment hello-node --image=yourusername/yourimagename
kubectl get deploy hello-node -o yaml
```

Edit the image pull policy, then recreate the deployment:

```bash
kubectl delete deployment hello-node
kubectl create -f modified_deployment.yaml
```

If the pod is up and running, the `nginx.conf` file will be automatically updated.

Now, you can then scale your Kubernetes cluster:

```bash
kubectl scale deployments/hello-node --replicas=2
```

The cluster automatically receives config updates.

{{< versions "3.18" "latest" "apimvers" >}}
