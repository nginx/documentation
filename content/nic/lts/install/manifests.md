---
title: Install NGINX Ingress Controller LTS with Manifests
toc: true
weight: 500
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

This guide explains how to use Manifests to install F5 NGINX Ingress Controller LTS, then create both common and custom resources and set up role-based access control.

## Before you begin

If you are using NGINX Plus, get the NGINX Ingress Controller LTS JWT and [create a license secret]({{< ref "/nic/lts/install/license-secret.md" >}}).

### Get the NGINX Controller Image

{{< call-out "note" >}} We recommend installing the latest LTS patch release of NGINX Ingress Controller LTS, available on the GitHub repository's [releases page](https://github.com/nginx/kubernetes-ingress/releases). {{< /call-out >}}

Choose one of the following methods to get the NGINX Ingress Controller LTS image:

- **NGINX Plus Ingress Controller**: You have two options for this, both requiring an NGINX Ingress Controller LTS subscription.
- - [Download NGINX Ingress Controller LTS from the F5 Registry]({{< ref "/nic/lts/install/images/registry-download.md" >}}) topic.
- - [Add an NGINX Ingress Controller LTS image to your cluster]({{< ref "/nic/lts/install/images/add-image-to-cluster.md" >}})

### Clone the repository

Clone the NGINX Ingress Controller LTS repository using the command shown below, and replace `<version_number>` with the specific release you want to use.

```shell
git clone https://github.com/nginx/kubernetes-ingress.git --branch <version_number>
```

For example, if you want to use version {{< nic-lts-version >}}, the command would be:

```shell
git clone https://github.com/nginx/kubernetes-ingress.git --branch v{{< nic-lts-version >}}
```

This guide assumes you are using the latest release.

Change the active directory.

```shell
cd kubernetes-ingress
```

## Set up role-based access control (RBAC) {#configure-rbac}

{{< include "/nic/rbac/set-up-rbac.md" >}}

## Create common resources {#create-common-resources}

{{< include "/nic/installation/create-common-resources.md" >}}

## Deploy NGINX Ingress Controller LTS {#deploy-ingress-controller}

You have three options for deploying NGINX Ingress Controller LTS:

- **Deployment**. Choose this method for the flexibility to dynamically change the number of NGINX Ingress Controller LTS replicas.
- **DaemonSet**. Choose this method if you want NGINX Ingress Controller LTS to run on all nodes or a subset of nodes.
- **StatefulSet**. Choose this method when you need stable, persistent storage and ordered deployment/scaling for your NGINX Ingress Controller LTS pods.

Before you start, update the [command-line arguments]({{< ref "/nic/lts/configuration/global-configuration/command-line-arguments.md" >}}) for the NGINX Ingress Controller LTS container in the relevant manifest file to meet your specific requirements.

### Using a Deployment

{{< include "/nic/installation/manifests/deployment.md" >}}

### Using a DaemonSet

{{< include "/nic/installation/manifests/daemonset.md" >}}

### Using a StatefulSet

{{< include "/nic/installation/manifests/statefulset.md" >}}

## Confirm NGINX Ingress Controller LTS is running

{{< include "/nic/installation/manifests/verify-pods-are-running.md" >}}

## How to access NGINX Ingress Controller LTS

### Using a Deployment or StatefulSet

For Deployments and StatefulSets, you have two options for accessing NGINX Ingress Controller LTS pods.

#### Option 1: Create a NodePort service

For more information about the  _NodePort_ service, refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport).

1. To create a service of type *NodePort*, run:

    ```shell
    kubectl create -f deployments/service/nodeport.yaml
    ```

    Kubernetes automatically allocates two ports on every node in the cluster. You can access NGINX Ingress Controller LTS by combining any node's IP address with these ports.

#### Option 2: Create a LoadBalancer service

For more information about the _LoadBalancer_ service, refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer).

1. To set up a _LoadBalancer_ service, run one of the following commands based on your cloud provider:

    - GCP or Azure:

        ```shell
        kubectl apply -f deployments/service/loadbalancer.yaml
        ```

    - AWS:

        ```shell
        kubectl apply -f deployments/service/loadbalancer-aws-elb.yaml
        ```

        For more details see service guide [here](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/service/annotations/#annotations)

2. AWS users: Follow these additional steps to work with ELB in TCP mode.

     - Add the following keys to the `nginx-config.yaml` ConfigMap file, which you created in the [Create common resources](#create-common-resources) section.

         ```yaml
         proxy-protocol: "True"
         real-ip-header: "proxy_protocol"
         set-real-ip-from: "0.0.0.0/0"
         ```

     - Update the ConfigMap:

         ```shell
         kubectl apply -f deployments/common/nginx-config.yaml
         ```

    {{< call-out "note" >}}AWS users have more customization options for their load balancers. These include choosing the load balancer type and configuring SSL termination. Refer to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer) to learn more. {{< /call-out >}}

3. To access NGINX Ingress Controller LTS, get the public IP of your load balancer.

    - For GCP or Azure, run:

        ```shell
        kubectl get svc nginx-ingress --namespace=nginx-ingress
        ```

    - For AWS find the DNS name:

        ```shell
        kubectl describe svc nginx-ingress --namespace=nginx-ingress
        ```

        Resolve the DNS name into an IP address using `nslookup`:

        ```shell
        nslookup <dns-name>
        ```

    You can also find more details about the public IP in the status section of an ingress resource. For more details, refer to the [Reporting Resources Status doc]({{< ref "/nic/lts/configuration/global-configuration/reporting-resources-status.md" >}}).

### Using a DaemonSet

Connect to ports 80 and 443 using the IP address of any node in the cluster where NGINX Ingress Controller LTS is running.

## Uninstall NGINX Ingress Controller LTS

{{< call-out "warning" >}}Proceed with caution when performing these steps, as they will remove NGINX Ingress Controller LTS and all related resources, potentially affecting your running services.{{< /call-out >}}

1. **Delete the nginx-ingress namespace**: To remove NGINX Ingress Controller LTS and all auxiliary resources, run:

    ```shell
    kubectl delete namespace nginx-ingress
    ```

1. **Remove the cluster role and cluster role binding**:

    ```shell
    kubectl delete clusterrole nginx-ingress
    kubectl delete clusterrolebinding nginx-ingress
    ```

1. **Delete the Custom Resource Definitions**:

{{<tabs name="delete-crds">}}

{{% tab name="Deleting CRDs from single YAML" %}}

Delete core custom resource definitions:

```shell
kubectl delete -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-lts-version >}}/deploy/crds.yaml
```

{{%/tab%}}

{{%tab name="Deleting CRDs after cloning the repo"%}}

Delete core custom resource definitions:

```shell
kubectl delete -f config/crd/bases/crds.yaml
```

{{%/tab%}}

{{</tabs>}}
