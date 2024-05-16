---
description: Use NGINX or NGINX Plus as the Ingress Controller for Amazon Elastic
  Kubernetes Services.
docs: DOCS-447
doctypes:
- task
title: Using NGINX or NGINX Plus as the Ingress Controller for Amazon Elastic Kubernetes
  Services
toc: true
weight: 400
---

This guide explains how to use the NGINX Open Source or NGINX Plus Ingress Controller for Kubernetes as the Ingress controller for a Kubernetes cluster hosted in the Amazon Elastic Kubernetes Service (EKS).

**Note:** The instructions in this document apply to both the NGINX and NGINX Plus Ingress Controllers for Kubernetes. For ease of reading, the document refers to NGINX Plus only.


<span id="prereqs"></span>
## Prerequisites

- [An AWS account](https://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- A prebuilt image of the NGINX or NGINX Plus Ingress Controller for Kubernetes. For NGINX Open Source, NGINX provides a prebuilt image on DockerHub, or you can build your own with our instructions. For NGINX Plus, you must build an image.

  **Note:** If you build the image, do not push it to a public registry.  Run the following <span style="white-space: nowrap;">`make` `container`</span> command. Include the `PREFIX` argument to specify the repo in your private registry where the container is created; this also sets the name that you can later use to reference the image, instead of its numerical ID. In this example we set it to <span style="white-space: nowrap; font-weight:bold;">nginx/nginx-plus-ingress</span>.


```shell
make container DOCKERFILE=DockerfileForPlus PREFIX=nginx/nginx-plus-ingress
```

<span id="amazon-eks"></span>
## Creating an Amazon EKS Cluster
In this guide we’re using the `eksctl` command to create an Amazon EKS cluster (you can also use the AWS Management Console or AWS CLI).

1. If the `eksctl` command is not already installed, or to make sure you have the latest version, follow the instructions in the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl).

2. Create an Amazon EKS cluster by following the instructions on the **eksctl** tab in the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html). In Step 1 of those instructions, use the <span style="white-space: nowrap;">`eksctl` `create` `cluster`</span> command shown in the **Cluster with Linux‑only workloads** section.



<span id="amazon-ecr"></span>
## Pushing the NGINX Plus Ingress Controller Image to AWS ECR

1. Create a repository in the Amazon Elastic Container Registry (ECR) using the instructions in the [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html). In this guide, we name the repository <span style="white-space: nowrap; font-weight:bold;">nginx-plus-ic</span> in Step 5 of the AWS instructions.

2. Run the following AWS CLI command. It generates an authorization token for your AWS ECR registry and outputs the <span style="white-space: nowrap;">`docker` `login`</span> command for logging into the registry. For details about the command, see the [AWS documentation](https://docs.aws.amazon.com/cli/latest/reference/ecr/get-login.html).

   ```shell
   aws ecr get-login --no-include-email --region <aws_region_code>
   ```

3. Run the <span style="white-space: nowrap;">`docker` `login`</span>  command generated in Step 2.

4. Run the following command to apply the tag `edge` to your NGINX Plus Ingress Controller image, where:

   - `<registry/image>` is the value you specified with the `PREFIX` parameter to the <span style="white-space: nowrap;">`make` `container`</span> command you ran to create the NGINX Plus Ingress Controller image (see [Prerequisites](#prereqs)). In this guide it is <span style="white-space: nowrap;">`nginx/nginx-plus-ingress`</span>.
   - `<aws_account_id>` is your AWS account number. For instructions on retrieving the ID, see the [AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).
   - `<aws_region_code>` is the same region name you specified in Step 2 above.
   - `<ecr_repo>` is the AWS ECR repository you created in Step 1 above. In this guide it is called <span style="white-space: nowrap;">`nginx-plus-ic`</span>.

   ```shell
   docker tag <registry/image>:edge <aws_account_id>.dkr.ecr.<aws-region-code>.amazonaws.com/<ecr_repo>:edge
   ```

   So in this guide, the command is

   ```shell
   docker tag nginx/nginx-plus-ingress:edge <aws_account_id>.dkr.ecr.<aws_region_code>.amazonaws.com/nginx-plus-ic:edge
   ```

5. Push the NGINX Plus Ingress Controller image to AWS ECR:

   ```shell
   docker push <aws_account_id>.dkr.ecr.<aws_region_code>.amazonaws.com/<ecr_repo>:edge
   ```

<span id="ingress-controller"></span>
## Installing the NGINX Plus Ingress Controller
Install your NGINX Plus Ingress Controller image in the Amazon EKS cluster you created in [Creating an Amazon EKS Cluster](#amazon-eks), using the instructions in [our documentation](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/).

<span id="nlb"></span>
## Using NLB in Front of the NGINX Plus Ingress Controller

By default, Amazon EKS uses [Classic Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html) for Kubernetes services of type `LoadBalancer`. We recommend that you use [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) (NLB) instead, and this section provides instructions for configuring it. We also recommend that you enable the PROXY Protocol for both the NGINX Plus Ingress Controller and your NLB target groups. If you choose not to enable the PROXY protocol, see the [Appendix](#appendix).

We assume you performed all the steps in the instructions referenced in [Installing the NGINX Plus Ingress Controller](#ingress-controller), and [built a service for your NGINX Plus Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/#create-a-service-for-the-ingress-controller-pods). If you created a `LoadBalancer` service, you can either edit its configuration or add a new `LoadBalancer` service. If you created a `NodePort` service, you must add a new `LoadBalancer` service now.

### Configuring a `LoadBalancer` Service to Use NLB


1. In <span style="white-space: nowrap; font-weight:bold;">service/loadbalancer-aws-elb.yaml</span>, add the following annotation to the existing or new `LoadBalancer` service:

   ```yaml
   service.beta.kubernetes.io/aws-load-balancer-type: nlb
   ```

2. Run the following command:

   ```shell
   kubectl apply -f service/loadbalancer-aws-elb.yaml
   ```

### Enabling the PROXY Protocol

1. Add the following keys to the <span style="white-space: nowrap; font-weight:bold;">common/nginx-config.yaml</span> config map file:

   ```yaml
   proxy-protocol: "True"
   real-ip-header: "proxy_protocol"
   set-real-ip-from: "0.0.0.0/0"
   ```

2. Run the following command to update the config map:

   ```shell
   kubectl apply -f common/nginx-config.yaml
   ```

3. Enable the PROXY Protocol on the target group associated with the NLB created for your `LoadBalancer` service, by performing the steps in the **Enable Proxy Protocol** section of the [AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol).


<span id="testing"></span>
## Testing

1. Follow the [instructions](https://github.com/nginxinc/kubernetes-ingress/tree/master/examples/complete-example) for setting up our sample deployment of a demo app load balanced by the NGINX Plus Ingress controller.

2. Navigate in a browser to **<http://cafe.example.com/coffee>** (or issue the `curl` command against that URL).

3. Run the following command to display the name of the running Ingress pod:

   ```shell
   kubectl get pods -namespace=nginx-ingress
   ```

4. Run the following command to display the logs from the NGINX Plus Ingress Controller, where `<pod_name>` is the name you learned in the previous step. If the logged IP address matches the IP address from which you accessed **<http://cafe> .example.com/coffee**, the PROXY Protocol is enabled.

   ```shell
   kubectl logs nginx-ingress-<pod_name> -n nginx-ingress
   ```


<span id="appendix"></span>
## Appendix: Disabling the PROXY Protocol

If you choose to disable the PROXY Protocol, perform these steps.

1. If the <span style="white-space: nowrap; font-weight:bold;">common/nginx-config.yaml</span> config map file includes these keys, remove them:

   ```yaml
   proxy-protocol: "True"
   real-ip-header: "proxy_protocol"
   set-real-ip-from: "0.0.0.0/0"
   ```


2. Run the following command to update the config map:

   ```shell
   kubectl apply -f common/nginx-config.yaml
   ```

3. In the <span style="white-space: nowrap; font-weight:bold;">service/loadbalancer-aws-elb.yaml</span> service file, add the `externalTrafficPolicy` key in the `spec` section and set it to `Local`, as in this example:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
    name: nginx-ingress-nlb
    namespace: nginx-ingress
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
   spec:
      externalTrafficPolicy: Local
      type: LoadBalancer
      ports:
      - port: 80
        targetPort: 80
        protocol: TCP
        name: http
      - port: 443
        targetPort: 443
        protocol: TCP
        name: https
      selector:
        app: nginx-ingress
   ```

4. Run the following command to update the service:

   ```shell
   kubectl apply -f service/loadbalancer-aws-elb.yaml
   ```

### Revision History

- Version 1 (March 2020) – Initial version (NGINX Plus Release 20)

