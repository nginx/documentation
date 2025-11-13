---
title: "Expose NGINX Gateway Fabric"
weight: 300
nd-docs: "DOCS-1427"
---

When a Gateway resource is created, the NGINX Gateway Fabric control plane will provision an NGINX service. By default, this is a LoadBalancer service.

There are two options for accessing the NGINX service depending on the type of LoadBalancer service you chose during installation:

- If the Service type is `NodePort`, Kubernetes will randomly allocate two ports on every node of the cluster.
  To access NGINX, use an IP address of any node of the cluster along with the two allocated ports.

  {{< call-out "tip" >}} Read more about the type NodePort in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport). {{< /call-out >}}

- If the Service type is `LoadBalancer`:

  - For GCP or Azure, Kubernetes will allocate a cloud load balancer for load balancing the NGINX pods.
    Use the public IP of the load balancer to access NGINX.
  - For AWS, Kubernetes will allocate a Network Load Balancer (NLB) in TCP mode with the PROXY protocol enabled to pass
    the client's information (the IP address and the port).

  Use the public IP of the load balancer to access NGINX. The NGINX Service exists in the same namespace that you deployed your Gateway in, and its name is `<gatewayName-gatewayClassName>`. To get the public IP which is reported in the `EXTERNAL-IP` column:

  - For GCP or Azure, run:

    ```shell
    kubectl get svc <gatewayName-gatewayClassName> -n <gateway-namespace>
    ```

  - In AWS, the NLB (Network Load Balancer) DNS name will be reported by Kubernetes instead of a public IP. To get the DNS name, run:

    ```shell
    kubectl get svc <gatewayName-gatewayClassName> -n <gateway-namespace>
    ```

    {{< call-out "note" >}} We recommend using the NLB DNS whenever possible, but for testing purposes, you can resolve the DNS name to get the IP address of the load balancer:

  ```shell
  nslookup <dns-name>
  ```

    {{< /call-out >}}

  {{< call-out "tip" >}} Learn more about type LoadBalancer in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer).

  For AWS, additional options regarding an allocated load balancer are available, such as its type and SSL
  termination. Read the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer) to learn more.
  {{< /call-out >}}

NGINX Gateway Fabric uses the created service to update the **Addresses** field in the **Gateway Status** resource. Using a **LoadBalancer** service sets this field to the IP address and/or hostname of that service. Without a service, the pod IP address is used.

This gateway is associated with NGINX Gateway Fabric through the **gatewayClassName** field. The default installation of NGINX Gateway Fabric creates a **GatewayClass** with the name **nginx**. NGINX Gateway Fabric will only configure gateways with a **gatewayClassName** of **nginx** unless you change the name via the `--gatewayclass` [command-line flag]({{< ref "/ngf/reference/cli-help.md#controller">}}).
