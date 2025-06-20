---
description: Use NGINX or F5 NGINX Plus as the Ingress Controller for Amazon Elastic
  Kubernetes Services.
docs: DOCS-447
title: Using NGINX or NGINX Plus as the Ingress Controller for Amazon Elastic Kubernetes
  Services
toc: true
weight: 400
type:
- how-to
---

This guide explains how to use NGINX Open Source or F5 NGINX Plus with NGINX Ingress Controller for Amazon Elastic Kubernetes Services (EKS).

{{< note >}} These instructions apply to NGINX Ingress Controller with NGINX Open Source or NGINX Plus. For ease of reading, the document refers to NGINX Plus only. {{< /note >}}


<span id="prereqs"></span>
## Prerequisites

- [An AWS account](https://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).
- A prebuilt image of the NGINX or NGINX Plus Ingress Controller for Kubernetes. 
  - For NGINX Open Source you can use the pre-built image [on DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/). You can also build your own image.
  - For NGINX Plus, you must [build an image](https://docs.nginx.com/nginx-ingress-controller/installation/build-nginx-ingress-controller/).

{{< note >}}  Never upload your NGINX Plus Ingress Controller images to a public repository such as Docker Hub. Doing so violates your license agreement.  Run the `make container` command below. {{< /note >}}

```shell
make container DOCKERFILE=DockerfileForPlus PREFIX=nginx/nginx-plus-ingress
```

The `PREFIX` argument specifies the repo name in your private container registry. In this example, we set it to `nginx/nginx-plus-ingress`. You can later use that name to reference the image instead of its numerical ID.
   

<span id="amazon-eks"></span>
## Create an Amazon EKS Cluster
You can create an Amazon EKS cluster with:
- the AWS Management Console
- the AWS CLI
- the `eksctl` command line utility. 

This guide covers the `eksctl` command as it is the simplest option. 

1. Follow the instructions in the [eksctl.io documentation](https://eksctl.io/installation/) to install or update the `eksctl` command.

2. Create an Amazon EKS cluster by following the instructions in the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html). Select the {{<nb>}}**Managed nodes – Linux**{{</nb>}} option for each step. Note that the <span style="white-space: nowrap;">`eksctl create cluster`</span> command in the first step can take ten minutes or more.

<span id="amazon-ecr"></span>
## Push the NGINX Plus Ingress Controller Image to AWS ECR

This step is only required if you do not plan to use the prebuilt NGINX Open Source image.

1. Use the [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html) to create a repository in the Amazon Elastic Container Registry (ECR). In Step 4 of the AWS instructions, name the repository {{<nb>}}**nginx-plus-ic**{{</nb>}} as that is what we use in this guide. 

2. Run the following AWS CLI command. It generates an auth token for your AWS ECR registry, then pipes it into the `docker login` command. This lets AWS ECR authenticate and authorize the upcoming Docker requests. For details about the command, see the [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html).

   ```shell
   aws ecr get-login-password --region <aws_region_code> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<aws_region_code>.amazonaws.com
   ```
   - `<aws_region_code>` is the same region name you specified in Step 2 above.
   - `<aws_account_id>` is your AWS account number. For instructions on retrieving the ID, see the [AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).

3. Run the following command to apply the tag `edge` to your NGINX Ingress Controller image:

   ```shell
   docker tag <registry/image>:edge <aws_account_id>.dkr.ecr.<aws-region-code>.amazonaws.com/<ecr_repo>:edge
   ```
   - `<registry/image>` is the repo name you set with the `PREFIX` parameter to the `make container` command (see [Prerequisites](#prereqs)). In this guide it is `nginx/nginx-plus-ingress`.
   - `<ecr_repo>` is the AWS ECR repository you created in Step 1 above. In this guide it is called `nginx-plus-ic`.

   The final command is:

   ```shell
   docker tag nginx/nginx-plus-ingress:edge <aws_account_id>.dkr.ecr.<aws_region_code>.amazonaws.com/nginx-plus-ic:edge
   ```

5. Push the NGINX Plus Ingress Controller image to AWS ECR:

   ```shell
   docker push <aws_account_id>.dkr.ecr.<aws_region_code>.amazonaws.com/<ecr_repo>:edge
   ```

<span id="ingress-controller"></span>
## Install the NGINX Plus Ingress Controller

Use [our documentation](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/) to install the NGINX Plus Ingress Controller in your Amazon EKS cluster.

Complete the steps up to and including [Confirm NGINX Ingress Controller is running](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-manifests/#confirm-nginx-ingress-controller-is-running). Next, follow the instructions below to create a Network Load Balancer to route traffic to NGINX Plus Ingress Controller.

---

## Use a Network Load Balancer in front of NGINX Ingress Controller

These steps assume you've cloned the [kubernetes-ingress](https://github.com/nginx/kubernetes-ingress) repository in the previous step.

You need a Kubernetes `LoadBalancer` service to route traffic to the NGINX Ingress Controller. By default, Amazon EKS will create a [Classic Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html) for Kubernetes services of type `LoadBalancer`. However, we recommend that you create a [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) (NLB). It operates at the transport layer and is optimized for high performance and low latency. 

We also recommend enabling the PROXY Protocol for both the NGINX Plus Ingress Controller and your NLB target groups. This is used to forward client connection information. If you choose not to enable the PROXY protocol, see the [Appendix](#appendix).

### Configure a `LoadBalancer` Service to Use NLB

Apply the manifest `deployments/service/loadbalancer-aws-elb.yaml` to create a `LoadBalancer` of type NLB:

   ```shell
   kubectl apply -f deployments/service/loadbalancer-aws-elb.yaml
   ```

### Enable the PROXY Protocol

1. Add the following keys to the `deployments/common/nginx-config.yaml` config map file:

   ```yaml
   proxy-protocol: "True"
   real-ip-header: "proxy_protocol"
   set-real-ip-from: "0.0.0.0/0"
   ```

2. Run the following command to update the config map. This will enable the PROXY protocol for the NGINX Plus Ingress Controller:

   ```shell
   kubectl apply -f deployments/common/nginx-config.yaml
   ```

3. Enable the PROXY Protocol for the target groups linked to the NLB. Follow the steps in the **Enable proxy protocol** section of the [AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/edit-target-group-attributes.html#proxy-protocol) to do this.


<span id="testing"></span>
## Testing

1. Get the DNS name of NGINX Ingress Controller with the command below. Find the value of the "LoadBalancer Ingress" in the output.

   ```shell
   kubectl describe svc nginx-ingress --namespace=nginx-ingress
   ```

2. Resolve the DNS name into an IP address using `nslookup`:

   ```shell
   nslookup <dns-name>
   ```

3. Follow the [instructions](https://github.com/nginx/kubernetes-ingress/tree/main/examples/ingress-resources/complete-example) to deploy the Cafe demo app into the EKS cluster. It will be load balanced by NGINX Ingress Controller.
   * In Step 1 of deploying the demo app, save the public IP address into the `IC_IP` shell variable. Set `IC_HTTPS_PORT` to 443.
   * The `kubectl` commands are relative to the `deployment/examples/ingress-resources/complete-example` directory of the [kubernetes-ingress](https://github.com/nginx/kubernetes-ingress) repository.
   * Run the `curl` command listed in the instructions. It will access the demo app and populate the NGINX Plus Ingress Controller logs.

4. Run the following commands to check if the PROXY Protocol is enabled: 
   1. Display the pod of NGINX Ingress Controller:

      ```shell
      kubectl get pods -n nginx-ingress
      ```
   2. Display the logs from NGINX Ingress Controller. Replace `<pod_name>` with the name from the previous step. If the logged IP address matches the one you used to access the demo app, then the PROXY Protocol is enabled.

      ```shell
      kubectl logs <pod_name> -n nginx-ingress
      ```


<span id="appendix"></span>
## Appendix: Disable the PROXY Protocol

If you want to disable the PROXY Protocol, perform these steps.

1. Disable the PROXY Protocol for the target groups linked to the NLB. Undo the steps in the **Enable proxy protocol** section of the [AWS documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/edit-target-group-attributes.html#proxy-protocol).

2. Remove the following keys from `deployments/common/nginx-config.yaml` the config map file:

   ```yaml
   proxy-protocol: "True"
   real-ip-header: "proxy_protocol"
   set-real-ip-from: "0.0.0.0/0"
   ```

2. Run the following command to update the config map:

   ```shell
   kubectl apply -f deployments/common/nginx-config.yaml
   ```

3. In the `deployments/service/loadbalancer-aws-elb.yaml` service file, add the `externalTrafficPolicy` key in the `spec` section. Set it to `Local`, as in this example:

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
   kubectl apply -f deployments/service/loadbalancer-aws-elb.yaml
   ```

### Revision History

- Version 2 (February 2025) – Initial version (NGINX Plus Release 20)
